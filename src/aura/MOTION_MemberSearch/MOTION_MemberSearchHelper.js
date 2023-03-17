({
    // Clear the search details
    clearSearch : function(component, event, helper) {
        var isCSmem = component.get('v.iscaseMember');
        if(!isCSmem){
            $A.get('e.force:refreshView').fire();     
        }else{
            var clearResult = component.getEvent("clearResult");
            clearResult.fire();
            component.set('v.firstName','');
            component.set('v.lastName','');
            component.set('v.statusDefault','');     
            component.set('v.dateOfBirth',null);
            component.set('v.email','');
            component.set('v.memberId','');
            component.set('v.groupName','');
            component.set('v.transactionId','');
            component.set("v.showSearchResults",false);
        } 
    },
    
    populatePickListValues:function(component, event, helper){
        
        // populate values for picklist in the Advance and Basic Search UI
        var action = component.get("c.memberSearchPickListValues");
        action.setCallback(this,function(response){           
            var state = response.getState();
			var defaultValue;
            if(state === "SUCCESS"){     
                var result  = response.getReturnValue();
                for(let i in (result.lstInteractionTypes)){                    
                    if((result.lstInteractionTypes[i].value).toLocaleLowerCase()==='phone'){
                        defaultValue =result.lstInteractionTypes[i].value;
                    }
                }                
                component.set('v.options',result.lstInteractionTypes);
                component.set('v.statusOptions',result.lstStatusValues);
                //component.set('v.defaultValue',defaultValue);               
         }           
        });
        $A.enqueueAction(action); 
		var isCSmem = component.get('v.iscaseMember');
        
        if(!isCSmem){
        	component.set('v.defaultValue','Phone');     
        }
    },
   
    showAdvanceSearchResults: function(component ,event, helper){
        var spinner = component.find("Spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var isValidSuccess = false;
        var interactType = component.find("interactType").get("v.value");
        component.set("v.interactType", interactType);
        var status = component.find("status").get("v.value");
        var emailFieldValue = component.find("email").get("v.value");
        var firstName = component.get("v.firstName");
        
        var lastName = component.get("v.lastName");
        var dateOfBirth = component.get("v.dateOfBirth");
        var memberId = component.get("v.memberId");
        var groupName = component.get("v.groupName");
        var transactionId = component.get("v.transactionId");
        var pageNum = component.get("v.pageNumber");
        console.log("interaction type :"+component.get("v.interactType"));
        var fmtDtDob;
        if(dateOfBirth != null && dateOfBirth != ''){
            fmtDtDob = $A.localizationService.formatDate(dateOfBirth, "MM/dd/yyyy");
        }
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        isValidSuccess = this.validateAdvanceSearchFields(component, firstName, lastName, dateOfBirth, emailFieldValue, memberId, groupName, transactionId, status);
        //set searchType to A as it is Advance search
        component.set("v.searchType", "A");
        if (isValidSuccess){     	            
            var action=component.get("c.getAdvanceSearchResults");       
            action.setParams({
                intType:interactType,
                firstName:firstName,
                lastName:lastName,
                dob:fmtDtDob,
                email:emailFieldValue,
                memberId:memberId,
                groupName:groupName,
                status:status,
                transactionId:transactionId,
                reqPageNumber:pageNum
            });
            action.setCallback(this,function(response){
                var state=response.getState();            
                if(state==="SUCCESS"){
                    
                    $A.util.addClass(spinner, "slds-hide");
                    var response=response.getReturnValue(); 
                    if(response != null){
                        component.set("v.tableDetails",response);                
                        component.set("v.headerOptions",response.tableHeaders);
                        component.set("v.tablebody",response.tableBody);
                        component.set("v.tablePaginations", response.paginations);

                        var isCsMbr = component.get("v.iscaserecord");  
                        if(!isCsMbr){
                            component.set("v.showSearchResults",true);
                            console.log('In advance serarch');
                            //calling Search result componnet method to refresh the table for pagination
                            var tableWithHeadersCmp = component.find("searchResultId");
                            tableWithHeadersCmp.refreshTable();
                        }
                        else{
                            var resultEvent = component.getEvent("showResult");
                            resultEvent.setParams({
                                "headerOptions" : response.tableHeaders,
                                "tablebody": response.tableBody,
                                "tablePaginations": response.paginations,
                                "interactType" : component.find("interactType").get("v.value"),
                                "searchType" : "A"
                            });
                            resultEvent.fire();
                        }
                    }
                    else if (response == null){
                        //$A.util.addClass(spinner, "slds-hide");
                        component.set("v.showSearchResults",false);                                             
                        var advToastEvent = $A.get("e.force:showToast");
                        advToastEvent.setParams({                
                            message : 'No results were found',
                            duration: '10000',                
                            type: 'error',
                            mode: 'dismissible'
                        });
                        advToastEvent.fire();
                    }
                } 
                else if (state === "INCOMPLETE") {
                    $A.util.addClass(spinner, "slds-hide"); 
                    // do something
                }
                else if (state === "ERROR") {
                	$A.util.addClass(spinner, "slds-hide"); 
                    var errors = response.getError();
                    if (errors) {
                    	if (errors[0] && errors[0].message) {
                        	console.log("Error message: "+errors[0].message);
                            var advToastEvent = $A.get("e.force:showToast");
                            advToastEvent.setParams({                
                            	message : errors[0].message,
                                duration: '10000',                
                                type: 'error',
                                mode: 'dismissible'
                            });
                            advToastEvent.fire();
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            }); 
            $A.enqueueAction(action);            
        }
        else{           
            component.set("v.showSearchResults",false); 
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    
    validateAdvanceSearchFields:
    function(component,fName, lName, dtBirth, email, memberId, groupName, transactionId, status){
           	var isValid = false;
        	var errorMessage = 'Search criteria must include either Last Name OR First Name + Last Name OR Last Name + DOB OR Member ID OR Email Address OR Transaction ID OR Group Name';
           	var showErrorMsg= false;          
          	
       	   	if(lName==='' && ((dtBirth!==null && lName==='') || (memberId ==='' && transactionId==='' && groupName ==='' && email===''))){
             	showErrorMsg = true;
        	}        
        	if(status==='' && memberId ==='' && transactionId==='' && groupName ==='' && email==='' && dtBirth===null && lName==='' && (fName===''|| fName==fName)){          		
                showErrorMsg = true;
           	}
        	else if (status!=='' && (memberId ==='' && transactionId==='' && groupName ==='' && email==='' && dtBirth===null && lName==='' && fName==='')){
                showErrorMsg = true;
            }
        	           
            if(showErrorMsg){                
            	var advToastEvent = $A.get("e.force:showToast");
            	advToastEvent.setParams({                
                    message : errorMessage,
                    duration: '10000',                
                    type: 'error',
                    mode: 'dismissible'
            	});
            	advToastEvent.fire();                 
            }else{
                isValid = true;
            }
               return isValid;   
    },

    validateBasicSearchFields: function(component, fName, lName, dtBirth){
        var isValid = false;       
        var errorMessage= 'Search criteria must include either Last Name OR First Name + Last Name OR Last Name + DOB';
        var showErrorMsg= false;
        if(lName===''){           
              showErrorMsg = true;     	           
        }
              
        if(showErrorMsg){            
            var basicToastEvent = $A.get("e.force:showToast");
            basicToastEvent.setParams({                
                message : errorMessage,
                duration: '10000',                
                type: 'error',
                mode: 'dismissible'
            });
            basicToastEvent.fire();
        }else{
            isValid = true;
        }
		return isValid;        
	},
    
    showBasicSearchResults: function(component,event, helper){  
        var spinner = component.find("Spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var isValidSuccess = false;
        var interactType = component.find("interactType").get("v.value");
        component.set("v.interactType", interactType); 
        console.log("interaction type :"+component.get("v.interactType"));
        
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var dtDob = component.get("v.dateOfBirth");
        var fmtDtDob;
        if(dtDob != null && dtDob != ''){       
            fmtDtDob = $A.localizationService.formatDate(dtDob, "MM/dd/yyyy");
        }
        var pageNum = component.get("v.pageNumber");
        
        isValidSuccess = this.validateBasicSearchFields(component, firstName, lastName, dtDob);
        //set searchType to B as it is Basic search
        component.set("v.searchType", "B");       
        if (isValidSuccess){       
            var errorMessage = "";                        
            var action=component.get("c.getBasicSearchResults");       
            action.setParams({
                intType:interactType,
                firstName:firstName,
                lastName:lastName,
                dob:fmtDtDob,
                reqPageNumber:pageNum
            });
            action.setCallback(this,function(response){
                var state=response.getState();            
                if(state==="SUCCESS"){  
                    $A.util.addClass(spinner, "slds-hide");
                    var response=response.getReturnValue();
                    
                    if(response != null){                    
                        component.set("v.tableDetails",response);                
                        component.set("v.headerOptions",response.tableHeaders);
                        component.set("v.tablebody",response.tableBody);
                        component.set("v.tablePaginations", response.paginations);
                        
                        var isCsMbr = component.get("v.iscaserecord");
                        if(!isCsMbr){
                            component.set("v.showSearchResults",true);
                            
                            //calling Search result componnet method to refresh the table for pagination
                            var tableWithHeadersCmp = component.find("searchResultId");
                            tableWithHeadersCmp.refreshTable();
                        }else{
                            var resultEvent = component.getEvent("showResult");
                            resultEvent.setParams({
                                "headerOptions" 	: response.tableHeaders,
                                "tablebody"			: response.tableBody,
                                "tablePaginations"	: response.paginations,
                                "interactType" 		: component.find("interactType").get("v.value"),
                                "searchType" 		: "B",
                            });
                            resultEvent.fire();
                        }
                    } 
                    else  {
                        component.set("v.showSearchResults",false);                       
                        var basicToastEvent = $A.get("e.force:showToast");
                        basicToastEvent.setParams({                
                            message : 'No results were found',
                            duration: '10000',                
                            type: 'error',
                            mode: 'dismissible'
                        });
                        basicToastEvent.fire();
                    }
                }
                else if (state === "INCOMPLETE") {
                    $A.util.addClass(spinner, "slds-hide"); 
                    // do something
                }
                else if (state === "ERROR") {
                	$A.util.addClass(spinner, "slds-hide"); 
                    var errors = response.getError();
                    if (errors) {
                    	if (errors[0] && errors[0].message) {
                        	console.log("Error message: "+errors[0].message);
                            var advToastEvent = $A.get("e.force:showToast");
                            advToastEvent.setParams({                
                            	message : errors[0].message,
                                duration: '10000',                
                                type: 'error',
                                mode: 'dismissible'
                            });
                            advToastEvent.fire();
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            }); 
            $A.enqueueAction(action);            
        } 
        else{           
            component.set("v.showSearchResults",false); 
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    navigationAddIndividual : function(component,event, helper){
    	var workspaceAPI = component.find("workspace");
        var interactionType = component.find("interactType").get("v.value");        
        var membnotfoundTabId;
		var state = component.get("v.pageReference").state;
        var isCsMbr = component.get("v.iscaserecord");		   
        //To get tab Id to close the Member Information from Tab
        workspaceAPI.getFocusedTabInfo().then(function(response){
            membnotfoundTabId = response.tabId;
        });
		if(isCsMbr){
			 var openAddIndv = component.getEvent("addIndiv");
                            openAddIndv.setParams({
                                "addIndiv" : true 
		});
                            openAddIndv.fire();
        }		   								
        else{  
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__Motion_AddIndividual"  
                },
                "state": {
                    "c__interactionType":interactionType 
                }
                
                
            },
            focus: true
        }).then(function(response) {
            
            	workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Add Individual'
                        });
                        
                       //Close the membernotfound form tab after opening Member detail page                        
                            workspaceAPI.closeTab({
                            tabId: membnotfoundTabId    
                           });      
                    });
                }).catch(function(error) {
            console.log(error);
        });
    }
	},
    /* showSpinner : function(component){
        // component.set("v.spinner", true);
        var spinnerSearch = component.find("Spinner");
        $A.util.removeClass(spinnerSearch, "slds-hide");
    },
    hideSpinner : function(component){
        //component.set("v.spinner", false);
        var spinnerSearch = component.find("Spinner");
        $A.util.addClass(spinnerSearch, "slds-hide");
    } */
 })