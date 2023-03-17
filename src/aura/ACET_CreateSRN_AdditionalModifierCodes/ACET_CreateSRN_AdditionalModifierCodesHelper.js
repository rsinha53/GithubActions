({
    
    // US2816952
    keepAlphanumericAndNoSpecialCharacters: function (cmp, event) {
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)) {
            return true;
        } else {
            event.preventDefault();
            return false;
        }
    }
    
})