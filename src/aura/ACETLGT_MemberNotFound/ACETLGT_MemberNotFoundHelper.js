({
	 fireToast: function(title, messages){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        //helper.hideSpinner2(component, event, helper);
        //return;
        
    },hideSpinner2 : function(component, event, helper) {	
        console.log('Hiding Spinner2');
		component.set("v.Spinner", false);
	},showSpinner2: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   	},
    validateAllFields: function (component, event, mandatoryFields) {
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        console.log('-----------mandatoryFields------'+mandatoryFields);
        component.find("zipcode").setCustomValidity("");
        component.find("phonenum").setCustomValidity("");
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = component.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    if (!mandatoryFieldCmp.checkValidity()) {
                        validationCounter++;
                    }
                    mandatoryFieldCmp.reportValidity();                
                } /*else {
                    for (var i in mandatoryFieldCmp) {
                        if (!mandatoryFieldCmp[i].checkValidity()) {
                            if (!mandatoryFieldCmp[i].checkValidity()) {
                                validationCounter++;
                            }
                            mandatoryFieldCmp[i].reportValidity();                        
                        }
                    }
                }*/
            }
        }
        if(validationCounter == 0){
            validationSuccess = true;
        }
        return validationSuccess;
    },
   navigate: function(component,event,helper,int,intId,name,lastname,firstname,intType,EmpName,GrpNumber,state,dob,zip,membid,phonenum){
        var workspaceAPI = component.find("workspace");
        var membnotfoundTabId;
        // To get tab Id to close the membernotfound form tab
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    membnotfoundTabId = response.tabId;
                   
                }); 
       
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_MemberDetail"
                        },
                        "state": {
                            "c__mnfName" : name,
                            "c__mnflastName" : lastname,
                            "c__mnffirstName" : firstname,
                            "c__Ismnf" : "true",
                            "c__mnfId" : membid,
                            "c__mnfgrpnum" : GrpNumber,
                            "c__mnfdob" : dob,
                            "c__mnfstate" : state,
                            "c__mnfzip" : zip,
                            "c__mnfEmpName" : EmpName,             
                            "c__mnfphonenum" : phonenum,             
                            "c__InteractionType" : intType,
                            "c__InteractionId" : intId,
                            "c__Interaction" : int,
                            "c__isMemberFoundFound":false,
                        }
                    },
                    focus: true
                }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Detail-'+lastname
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:people",
                            iconAlt: "Member"
                        });
                       //Close the membernotfound form tab after opening Member detail page                        
                            workspaceAPI.closeTab({
                            tabId: membnotfoundTabId    
                           });      
                    });
                }).catch(function(error) {
                        console.log(error);
                });             
        },
    getFormattedDate:function (component, event, datefield) { 
        if(!$A.util.isEmpty(datefield)){
          var formatdate =  new Date(datefield);
          var year = formatdate.getFullYear();        
          var month = (1 + formatdate.getMonth()).toString();
          month = month.length > 1 ? month : '0' + month;        
          var day = formatdate.getDate().toString();
          day = day.length > 1 ? day : '0' + day;          
          return month + '/' + day + '/' + year;
        }
	}


})