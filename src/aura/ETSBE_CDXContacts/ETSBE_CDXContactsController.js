({
    doInit : function(component, event, helper) {
        
        component.set('v.contactColumns', [
            {label: 'First Name', fieldName: 'firstName', type: 'text'},
                {label: 'Last Name', fieldName: 'lastName', type: 'text'},
                {label: 'Role', fieldName: 'role', type: 'Phone'}
            ]);
    },
	closeCDXContacts : function(component, event, helper) {
        component.get("v.cdxContactData");
        var evt = $A.get("e.c:ETSBE_closeRootCauseModal");
        evt.setParams({"isRootCause":false});
        evt.fire();	
	},
    
    onRowSelection: function(component,event,helper){
        if(component.get("v.dataExists") == true){
            var selectedRow = event.getParam("selectedRows");
            console.log(selectedRow);
            
            var contactVal = selectedRow[0].name + ', ' + selectedRow[0].role;
            var evt = $A.get("e.c:ETSBE_closeRootCauseModal");
            
            evt.setParams({"isRootCause":false,
                           "cdxContactValue":contactVal,
                           
                           "cdxFlag":component.get("v.cdxFlag")});
            evt.fire();	
        }else{
             var  isAllValid =true;
            var FirstCmp = component.find('firstName');
            var FirstCmpValue = FirstCmp.get("v.value");
            var LastCmp = component.find('lastName');
            var LastCmpValue = LastCmp.get("v.value");
            var RoleCmp = component.find('Role');
            var RoleCmpValue = RoleCmp.get("v.value");
            if($A.util.isUndefinedOrNull(FirstCmpValue) || FirstCmpValue=='' ) {
            //set the custom error message
            isAllValid=false;
           
            FirstCmp.set('v.validity', {valid:false, badInput :true});
            $A.util.addClass(FirstCmp, "slds-has-error"); // remove red border
            $A.util.removeClass(FirstCmp, "hide-error-message");
            FirstCmp.reportValidity();
        	}
             if($A.util.isUndefinedOrNull(LastCmpValue) || LastCmpValue=='' ) {
            //set the custom error message
            isAllValid=false;
           
            LastCmp.set('v.validity', {valid:false, badInput :true});
            $A.util.addClass(LastCmp, "slds-has-error"); // remove red border
            $A.util.removeClass(LastCmp, "hide-error-message");
            LastCmp.reportValidity();
        	}
            if($A.util.isUndefinedOrNull(RoleCmpValue) || RoleCmpValue=='' ) {
            //set the custom error message
            isAllValid=false;
           
            RoleCmp.set('v.validity', {valid:false, badInput :true});
            $A.util.addClass(RoleCmp, "slds-has-error"); // remove red border
            $A.util.removeClass(RoleCmp, "hide-error-message");
            RoleCmp.reportValidity();
        	}
            
           
            if(isAllValid== true){
            var contactVal = component.get("v.firstName") +' '+component.get("v.lastName") + ', ' + component.get("v.Role");
            //component.set("v.singledata",true);
            var evt = $A.get("e.c:ETSBE_closeRootCauseModal");
            evt.setParams({"isRootCause":false,
                           "firstName":component.get("v.firstName"),
                           "lastName":component.get("v.lastName"),
                           "role":component.get("v.Role"),
                           "cdxContactValue":contactVal,
                           "cdxFlag":component.get("v.cdxFlag")});
            evt.fire();	
            }
        
        
        }
        
    },
    getMessage:function(cmp,event,helper){
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.childdata;
            if(param1.length>0){
                cmp.set("v.dataExists",true);
            }
            else{
                cmp.set("v.dataExists",false);
            }
        }
    },
    
    getRowInfo : function(cmp,event,helper){
       
        var selectedRow = event.currentTarget.getAttribute("data-row");
        var selectedRowIndex = event.currentTarget.getAttribute("data-index");
        console.log(selectedRow.firstName);
        console.log(selectedRow.lastName);
        console.log(selectedRow.role);                
    }
})