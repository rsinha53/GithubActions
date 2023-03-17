({
    // US3125332 - Thanish - 7th Jan 2021
    refreshAutodoc : function(cmp) {
        var cardDetails = cmp.get("v.cardDetails");
        var isdeleteAutodoc = true;
        if(!$A.util.isEmpty(cardDetails)){
            var data;
            for(data of cardDetails.cardData){
                if(!data.disableCheckbox){
                    data.checked = false;
                } else if(data.checked){
                    isdeleteAutodoc = false;
                }
            }
            cardDetails.allChecked = false;
            cmp.set("v.cardDetails", cardDetails);
            if(isdeleteAutodoc) {
                _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"),cardDetails.componentName);   
            } else {
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);   
            }
        }
    }
})