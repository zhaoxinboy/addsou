function removeImgByUrl(url) {
    var x = document.getElementsByTagName("img");
    for (var i = 0; i < x.length; i++){
        if (x[i].src==url){
            x[i].parentNode.remove(x[i]);
        }
    }
}
