({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
    }, 
 
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.providerSearchResults");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
                   
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    onCheckboxChange : function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
          
		var availableCheckboxes = component.find('rowSelectionCheckboxId'); 
         var selectedProviderDetails=component.get("v.selectedProviderDetails");
        var resetCheckboxValue  = false;
        if (Array.isArray(availableCheckboxes) && availableCheckboxes.length>1) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.value', resetCheckboxValue);
            }); 
        } else {
            //if only one checkbox available then it will be unchecked
           
            if(availableCheckboxes.get('v.value')==false){
            availableCheckboxes.set('v.value', false);
               selectedProviderDetails=null;
                component.set("v.selectedProviderDetails",null);
               // alert(JSON.stringify(selectedProviderDetails));
           
            } else if(availableCheckboxes.get('v.value')==true){
                var obj={};
                selectedProviderDetails=obj;
            }
            
           
        }
 
        if (Array.isArray(availableCheckboxes) && availableCheckboxes.length>1){  
       event.getSource().set("v.value",true);
        }

    
         var PaginationList=component.get("v.PaginationList");   
        for (var i = 0; i < PaginationList.length; i++) {  
               
                if( PaginationList[i].isChecked = true && selectedProviderDetails!=null){
                  
                  selectedProviderDetails.firstName= PaginationList[i].firstName;
                  selectedProviderDetails.lastName= PaginationList[i].lastName;
                  selectedProviderDetails.taxidornpi= PaginationList[i].taxidornpi;
                  selectedProviderDetails.corporateOwnerLastName= PaginationList[i].cwLastName;
                  selectedProviderDetails.corpMPIN= PaginationList[i].corpMPIN;
                  selectedProviderDetails.payeeProviderId= PaginationList[i].payeeProviderId;
                                      
                }
               }
        //console.log('selectedProviderDetails.providerSpeciality'+selectedProviderDetails.firstName);
         //Get the event
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        //Set event attribute value
        appEvent.setParams({"providerFlowDetails" : component.get("v.providerDetails"),
                           "selectedProviderDetails" : selectedProviderDetails}); 
        appEvent.fire();  
	},
 

    onClickHandler: function(component, event, helper) {
     var availableCheckboxes2 = component.find('rowSelectionCheckboxId'); 
        event.getSource().set("v.value",!availableCheckboxes2.get("v.value")); 
    }
})