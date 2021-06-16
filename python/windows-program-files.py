import re, platform, subprocess, sys

_split_lines = re.compile(r"\r\n(?!\s)")
_unwrap = re.compile(r"\s*\r\n\s*")
_discovered_commands = None
enabled_by_default=True

def discover():
    global _discovered_commands
    discovered = subprocess.run("powershell.exe $(~/.local/scripts/to_winpath ~/.local/scripts/Get-ObviousExecutables.ps1)",
                                capture_output=True,
                                shell=True)
    discovered_lines = [line.strip() for line in _split_lines.split(discovered.stdout.decode("utf-8")) if len(line) > 0]
    _discovered_commands = {line[:line.find('{')].strip(): line[line.find('{'):].strip() for line in discovered_lines}
    _discovered_commands = {c: [opt.strip() for opt in _unwrap.sub("", opts[1:-1]).split(',') if opt.strip() != "$null"] for (c, opts) in _discovered_commands.items()}

def match(command):
    if "not found" in command.output.lower():
        uname = platform.uname()
        if uname.system.lower() != 'linux' or ("microsoft" not in uname.release.lower() and "wsl" not in uname.release.lower()):
            return False
        # At this point, we know we're on a WSL installation. Check for executables and links in obvious locations
        discover()
        with open("match.out", "a") as f:
            f.write("Found match: {}\nDiscovered commands:\n".format(command.script_parts[0] in _discovered_commands))
            for dc in _discovered_commands.keys():
                f.write(f"{dc}\n")
        return command.script_parts[0] in _discovered_commands
    return False

def get_new_command(command, only=None):
    results = []
    for option in _discovered_commands[command.script_parts[0]]:
        if option[-3:] == 'exe' and (only is None or only == "exe"):
            opt = re.sub(r"[cC]:","/mnt/c",option)
            opt = re.sub(r"\\","/",opt)
            results.append('"{}" {}'.format(opt, " ".join(command.script_parts[1:])))
        elif option[-3:] == 'lnk' and (only is None or only == "lnk"):
            opt = re.sub(r"\\", "\\\\", option)
            results.append('powershell.exe "Start-Process -FilePath \\"{}\\" -ArgumentList \"{}\""'.format(opt, " ".join(command.script_parts[1:])))
    with open("/home/liam/get_new_command.out", "w") as f:
        f.write("Checking options for command {}\n".format(str(command)))
        if only is not None:
            f.write("Filtering to only items with extension {}\n".format(only))
        f.write("Available results: \n{}\n".format(str(results)))
    return results

if __name__ == '__main__':
    if len(sys.argv) == 1:
        discover()
        for (command, options) in _discovered_commands.items():
            indent = len(command) + 2
            print(f"{command}: {options[0]}")
            for option in options[1:]:
                print("{}{}".format(" "*indent, option))
    elif len(sys.argv) == 2:
        class Command(object):
            def __init__(self, output, script, script_parts):
                self.output=output
                self.script=script
                self.script_parts=script_parts
        c = Command("not found", sys.argv[1], [sys.argv[1]])
        if match(c):
            possible = get_new_command(c, only="exe")
            if len(possible) == 1:
                comm = possible[0][1:-2]
                print(comm)
            else:
                print()

