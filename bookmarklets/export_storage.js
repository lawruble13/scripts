javascript:function generateJson(){   ls = {};   for(var i = 0; i < localStorage.length; i++){     k = localStorage.key(i);     ls[k] = localStorage.getItem(k);   }   ss = {};   for(var i=0; i<sessionStorage.length; i++){     k=sessionStorage.key(i);     ss[k] = sessionStorage.getItem(k);   }   stor = [ls, ss];   return JSON.stringify(stor); } function download(filename, text){   var element = document.createElement('a');   element.setAttribute('href', 'data:text/plain;charset=utf16,' + encodeURIComponent(text));   element.setAttribute('download', filename);   element.style.display = 'none';   document.body.appendChild(element);   element.click();   document.body.removeChild(element); } download("storage.json",generateJson());