javascript:function loadIntoStorage(stor){s=JSON.parse(stor);ls=s[0];ss=s[1];for(var k in ls){localStorage.setItem(k,ls[k]);};for(var k in ss){sessionStorage.setItem(k,ss[k]);};}var input=document.createElement('input');input.type='file';input.onchange= e => {     var file = e.target.files[0];      var reader = new FileReader();    reader.readAsText(file,'UTF-8');     reader.onload = readerEvent => {       var content = readerEvent.target.result;       console.log( content ); loadIntoStorage(content);   }; document.body.removeChild(input); }; document.body.appendChild(input); input.click();
