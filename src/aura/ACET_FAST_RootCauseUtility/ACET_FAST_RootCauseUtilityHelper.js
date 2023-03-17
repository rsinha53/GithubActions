({
    showSpinner: function(component, event){
        var spinner = component.find("spinnerId");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("spinnerId");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    sortList: function(arrayList){
        if(arrayList!= undefined && arrayList!=null && arrayList.length>0){
           arrayList.sort(this.GetSortOrder("rcName")); 
        }
        return arrayList;
    },
    GetSortOrder: function(prop) {    
        return function(a, b) {    
            a = a[prop].toLowerCase();
            b = b[prop].toLowerCase();
            if (a > b) {    
                return 1;    
            } else if (a < b) {    
                return -1;    
            }    
            return 0;    
        }    
    },
})