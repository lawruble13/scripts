var host = window.location.href.toString().split('//')[1];
if (host.indexOf('www.') == 0) {
    host = host.substr(4);
    console.log(host)
}
if (host.split('/')[0] == 'xkcd.com') {
    var url = 'explain'.concat(host);
    window.location.assign('http://'.concat(url));
}
