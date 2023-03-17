({
    generatePhone: function(cmp, event, helper) {
        if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").authFollowUpContact)){
            if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").authFollowUpContact.phoneNumber)){
                var phone = cmp.get("v.authDetailsObj").authFollowUpContact.phoneNumber;
                    for(var i=0;i<phone.length;i++){
                        if(!$A.util.isUndefinedOrNull(phone[i])){
                            if(phone[i].phoneTypeCode == "14" || phone[i].phoneTypeCode == "15" ){
                                cmp.set('v.phone',phone[i].telephoneNumber);

                            } else if(phone[i].phoneTypeCode == "3"){
                                cmp.set('v.fax',phone[i].telephoneNumber);
                            }
                    }
            }
        }

        // US2300701	Enhancement View Authorizations and Notifications - Inpatient/Outpatient Details UI (Specific Fields)  - Sarma - 20/01/2020
        
        if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").authFollowUpContact.communicationContactRoleCode)){
            var finalTextRole = cmp.get("v.authDetailsObj").authFollowUpContact.communicationContactRoleCode.description;
            var charLength = finalTextRole.length;
            cmp.set('v.hoverTextRole', finalTextRole);
            if(charLength > 20){
                finalTextRole =  finalTextRole.substring(0, 20);
                finalTextRole = finalTextRole +'...';
                cmp.set('v.finalTextRole', finalTextRole);
            } else{
                cmp.set('v.finalTextRole', finalTextRole);
            }            

        }
    } 
        
        helper.setCardDetails(cmp);
    },
    //Swapna
     selectAll: function (cmp, event) {
       var checked = event.getSource().get("v.checked");
        var cardDetails = cmp.get("v.cardDetails");
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
        cmp.set("v.cardDetails", cardDetails);
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cardDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
    }
    //Swapna
})