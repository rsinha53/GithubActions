({
    searchRecordsHelper : function(component, event, helper, value) {
        
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var selectedTabId = component.get("v.selectedTabId");
        var userId='';
        if(!isBackupAgentViewcondition){
            userId = selectedTabId;
        } else {
            userId = $A.get("$SObjectType.CurrentUser.Id");
        } 
        var label = '';
        label = component.get("v.label"); 
        component.set('v.userIdValue', userId);        
        var searchString = component.get('v.searchString');
        var familyId = component.get('v.familyId');
       
        component.set('v.message', '');
        component.set('v.recordsList', []);
        // Calling Apex Method
        var action = component.get('c.retrieveProviderData');
        action.setParams({
            "inObjectParameters":{
                'objectName' : component.get('v.objectName'),
                'filterField' : component.get('v.fieldName'),
                'searchString' : searchString,
                'value' : value,
                'userId': component.get('v.userIdValue'),
                'label': label,
                'familyId':familyId,
                'selectedProviderAffliation':component.get("v.selectedProviderAfliation")!=null?component.get("v.selectedProviderAfliation").value:null,
                'isBackupAgentView':isBackupAgentViewcondition
            }
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {                
                if(result!=null && result.length > 0)  {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {

                                                //Sort object
                        result.sort((a,b)=>{
                            
                            let val1 = a.label.toLowerCase(),
                            val2 =b.label.toLowerCase();
                    
                            if(val1 < val2){
                               return -1;
                                                
                            }else if(val1 > val2){
                                return 1;
                            }else{
                                return 0;
                            }
                        
                        });

                        component.set('v.recordsList',result);                        
                    } else {
                        component.set('v.selectedRecord', result[0]);                                                
                    }
                } else {
                    component.set('v.message', "No match found with '" + searchString + "'");
                }
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', "No match found with '" + searchString + "'");
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
            component.set('v.isInit', false);
            
        });
        $A.enqueueAction(action);
    },

   getMemberIdByFamilyId:function(component, event, helper){       				
        var familyID = component.get("v.familyId");	                    
        var action = component.get("c.getMemberNameByAccountId");
            action.setParams({
                "accountID":familyID
            });        
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {					
					component.set("v.accountName", response.getReturnValue());   
                          
                }
                else {
                    console.log("Failed with state: " + state);
                }   
            });
            $A.enqueueAction(action);
            
        var action = component.get("c.getMemberIdByAccountId");
            action.setParams({
                "accountID":familyID
            });        
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {					
                    component.set("v.memberId", response.getReturnValue()); 
                    var memberId =   component.get("v.memberId");
                    var accountName = component.get("v.accountName"); 
                    var display;
                    console.log('memberId = ' +memberId);
                    if(familyID != null && familyID != 'undefined' && memberId != null && memberId != 'undefined' ){
                        display = accountName + " - " + response.getReturnValue();
                    }else{
                        display = accountName;
                    }
					component.set("v.displayName", display)       
                }
                else {
                    console.log("Failed with state: " + state);
                }   
            });
			$A.enqueueAction(action);

    }
})