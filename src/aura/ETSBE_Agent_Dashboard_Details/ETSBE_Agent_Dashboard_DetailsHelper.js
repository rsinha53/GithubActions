({
    onsectiontogglehelper: function (cmp ,event,helper){
        if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedLookUpRecord"))&& !$A.util.isEmpty(cmp.get("v.selectedLookUpRecord"))){
            var spinner = cmp.find("dropdown-spinner");
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
            var userRole = '';
            var selectedBusinessUnit = cmp.get("v.businessUnitText");
            if(cmp.get("v.selectedLookUpRecord").Role_Name__c == "System Administrator"){
                userRole = cmp.get("v.selectedLookUpRecord").Role_Name__c;
            } else {
                userRole = cmp.get("v.selectedLookUpRecord").BEO_Specialty__c;
                if($A.util.isUndefinedOrNull(userRole)){
                    userRole ='';
                }
            }
            var userProfile = '';
            userProfile = cmp.get("v.selectedLookUpRecord").Profile_Name__c;
            var action = cmp.get("c.populateBusinessDropdown");
            action.setParams({
                searchType: 'Business Unit',
                searchUser: userRole,
                searchProfile: userProfile,
                loggedinuserBU : cmp.get("v.buList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE returned from populateBusinessDropdown call: ' + state);
                if(state == "SUCCESS"){
                    var storeResponse = response.getReturnValue();
                    console.log('RESULTS: ' + JSON.stringify(storeResponse));
                    var dropdownOptions = [];
                    dropdownOptions.push({
                        label: "None",
                        value: "None"
                    });
                    for (var i = 0; i < storeResponse.length; i++) {
                        dropdownOptions.push({
                            label: storeResponse[i],
                            value: storeResponse[i]
                        });
                    }
                    
                    cmp.set('v.businessUnitOptions', dropdownOptions);
                    cmp.set("v.businessUnitFilter", cmp.get("v.businessUnitOptions"));
                    var spinner2 = cmp.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    
                    console.log( cmp.get('v.businessUnitOptions'));
                }
                if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message in onsectiontogglehelper while calling populateBusinessDropdown: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var spinner2 = cmp.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                }
            });
            $A.enqueueAction(action);
            
            
            
           
        }else{
            helper.closeAllDropdownsHelper(cmp,event);
            cmp.set("v.businessUnitText", "");  
        }
    },
    onsectiontoggle: function (cmp ,event,helper){
        if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedLookUpRecord"))&& !$A.util.isEmpty(cmp.get("v.selectedLookUpRecord"))){
            var spinner = cmp.find("dropdown-spinner");
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
            var userRole = '';
            var selectedBusinessUnit = cmp.get("v.businessUnitText");
            if(cmp.get("v.selectedLookUpRecord").Role_Name__c == "System Administrator"){
                userRole = cmp.get("v.selectedLookUpRecord").Role_Name__c;
            } else {
                userRole = cmp.get("v.selectedLookUpRecord").BEO_Specialty__c;
                if($A.util.isUndefinedOrNull(userRole)){
                    userRole ='';
                }
            }
            
            var userProfile = '';
            userProfile = cmp.get("v.selectedLookUpRecord").Profile_Name__c;
            var action = cmp.get("c.populateBusinessDropdown");
            action.setParams({
                searchType: 'Business Unit',
                searchUser: userRole,
                searchProfile: userProfile,
                'loggedinuserBU' : cmp.get("v.buList")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE returned from populateBusinessDropdown call: ' + state);
                if(state == "SUCCESS"){
                    var storeResponse = response.getReturnValue();
                    console.log('RESULTS: ' + JSON.stringify(storeResponse));
                    var dropdownOptions = [];
                    dropdownOptions.push({
                        label: "None",
                        value: "None"
                    });
                    for (var i = 0; i < storeResponse.length; i++) {
                        dropdownOptions.push({
                            label: storeResponse[i],
                            value: storeResponse[i]
                        });
                    }
                    
                    cmp.set('v.businessUnitOptions', dropdownOptions);
                    cmp.set("v.businessUnitFilter", cmp.get("v.businessUnitOptions"));
                    var spinner2 = cmp.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    
                    console.log( cmp.get('v.businessUnitOptions'));
                }
                if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message in onsectiontogglehelper while calling populateBusinessDropdown: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var spinner2 = cmp.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                }
            });
            $A.enqueueAction(action);
            
            
           
            var selectedLookupUser = cmp.get("v.selectedLookUpRecord");
            
        }else{
            helper.closeAllDropdownsHelper(cmp,event);
            cmp.set("v.businessUnitText", "");  
        }
    },
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    closeAllDropdownsHelper:function(component,event,helper){
        component.set("v.displayBU", false);
        if(component.get("v.businessUnitText") == ""){
            component.set("v.businessUnitText", "None");
        }
        
    },
    resetFields: function(component,event,helper){
        component.set("v.displayBU", false);
        
    },
    filterBusinessUnits: function(component, event, helper){
        var typeText = component.get('v.businessUnitText');
        var dataList = component.get("v.businessUnitOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.businessUnitFilter', dataList);
            component.set('v.displayBU', false);
            return;
        }
        typeText = typeText.toLowerCase();
        var dataListFilter = [];
        for (var i = 0; i < dataList.length; i++) {
            if ((dataList[i].value.toLowerCase().indexOf(typeText) != -1) || (dataList[i].label.toLowerCase().indexOf(typeText) != -1)) {
                dataListFilter.push(dataList[i]);
            }
        }
        if (dataListFilter.length > 0) {
            component.set('v.businessUnitFilter', dataListFilter);
            component.set('v.displayBU', true);
        } else {
            component.set('v.businessUnitFilter', dataList);
        }
    },
})