({
    // DE415502 - Thanish - 4th Mar 2021
    onInit : function(cmp) {
        let today = new Date();
        cmp.set("v.cmpUniqueId", today.getTime());
    },

    autodocByDefault: function (cmp, event) {
        if (cmp.get("v.defaultAutodoc")) {
            var cardDetails = cmp.get("v.cardDetails");
            //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cardDetails);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        }
    },
    
    handleSelectCheckBox: function (cmp, event) {
        var cardDetails = cmp.get("v.cardDetails");
        var index = cmp.get("v.autoSelectFieldIndex");
        var indexValue = event.getSource().get("v.label");
        if(indexValue != index && cmp.get("v.autoSelectField") && cardDetails.cardData.length > index + 1) {
            var autoselect = false;
            for(var i= index + 1; i<cardDetails.cardData.length; i++) {
                if(cardDetails.cardData[i].checked) {
                    autoselect = true;
                }
                cardDetails.cardData[index].checked = autoselect;
            }
            cmp.set("v.cardDetails", cardDetails);
        }

        if (cardDetails.cardData[indexValue].isParent == true) {
            var parentName = cardDetails.cardData[indexValue].parentName;
            var checked = cardDetails.cardData[indexValue].checked;
            for(var i= 0; i<cardDetails.cardData.length; i++){
                var parentNames = cardDetails.cardData[i].parentName;
                var isParent = cardDetails.cardData[i].isParent;
                var isChild = cardDetails.cardData[i].isChild;
                if(parentName == parentNames && isChild && !isParent){
                    cardDetails.cardData[i].checked = checked;
                }
            }
            cmp.set("v.cardDetails", cardDetails);
        }

        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
    },
    
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
    },
    
    fireAutodocEvent : function(cmp, event) {
        var cardDetails = cmp.get("v.cardDetails");
        var currentTarget = event.currentTarget;
        var index = currentTarget.dataset.index;
        var autodocEvent = cmp.getEvent("AutodocEvent");
        autodocEvent.setParams({
            "autodocCmpName" : cardDetails.componentName,
            "cmpType" : cardDetails.type,
            "eventData" : cardDetails.cardData[index],
            "index" : index
        });
        autodocEvent.fire();
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        var tooltip = document.getElementById(showPopup);
        tooltip.style.left = tooltip.dataset.left + "px";
    },
    
     togglePopup2 : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    maskedMenuItemClicked : function(cmp, event){
        var selectedMenuItemValue = event.getParam("value");
        var cardData = cmp.get("v.cardDetails.cardData")[event.getSource().get("v.name")];
        
        if(selectedMenuItemValue == "unmask"){
            document.getElementById(cardData.fieldName + "value" + cmp.get("v.cmpUniqueId")).innerText = cardData.unmaskedValue; //DE415502 - Thanish - 4th Mar 2021
            
        } else if(selectedMenuItemValue == "copy"){
            var hiddenInput = document.createElement("input");
            hiddenInput.setAttribute("value", cardData.unmaskedValue);
            document.body.appendChild(hiddenInput);
            hiddenInput.select();
            document.execCommand("copy");
            document.body.removeChild(hiddenInput);
            
            var orignalLabel = event.getSource().get("v.label");
            event.getSource().set("v.label" , 'copied');
            setTimeout(function(){
                event.getSource().set("v.label" , orignalLabel);
            }, 700);
        }
    },
    
    // US3125332 - Thanish - 7th Jan 2021
    handleAutodocRefresh : function(cmp, event, helper) {
        if(cmp.get("v.enableRefreshAutodoc") && (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId"))){
            helper.refreshAutodoc(cmp);
        }
    },
    
    toggleSection: function(cmp,event) {
        var indexValue = event.currentTarget.getAttribute("data-index");
        let cardData = cmp.get("v.cardDetails.cardData");
        var iconName = cardData[indexValue].iconName;
        if(iconName === "utility:chevrondown") {
            cardData[indexValue].iconName = "utility:chevronright";
            cardData[indexValue].toggleClass = "slds-hide";
        } else {
            cardData[indexValue].iconName = "utility:chevrondown";
            cardData[indexValue].toggleClass = "slds-show";
        }
        cmp.set("v.cardDetails.cardData", cardData);
    },
})