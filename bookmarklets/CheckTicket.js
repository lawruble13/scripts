var wb = Array.prototype.slice.call($("ul.pastWinNumbers")[0].children).map(function(item) {
    return item.textContent;
});
var w = wb.slice(0, 7).map(Number);
var b = wb[7].substring(5);
while (true) {
    var t = prompt("Please enter your ticket numbers, separated by a single space", "#1 #2 #3 #4 #5 #6 #7").split(" ").map(Number);
    nw = 0;
    nb = 0;
    for (i = 0; i < t.length; i++) {
        if (w.includes(t[i])) {
            nw++;
        };
        if (t[i] == b) {
            nb++;
        };
    };
    alert("Your ticket has " + nw.toString() + " winning numbers, and " + ((nb == 1) ? "did" : "did not") + " match the bonus.");
    nmm = 0;
    jQuery("div.pastWinNumMMGroup").first().children("ul.pastWinNumbers").each(function(index) {
        var m = Array.prototype.slice.call(this.children).map(function(item) {
            return item.textContent
        }).map(Number);
        for (i = 0; i < 7; i++) {
            if (t[i] == m[i]) {
                if (i == 6) {
                    nmm++
                } else {
                    continue
                };
            } else {
                break;
            }
        };
    });
    alert("This ticket won " + nmm.toString() + " Maxmillions");
}
