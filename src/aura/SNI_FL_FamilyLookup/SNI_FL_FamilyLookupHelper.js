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

        component.set('v.userIdValue', userId);        
        var searchString = component.get('v.searchString');
        var recordType = '';
        var isProviderMsgLevel = component.get('v.isProviderMsgLevel');
        var familyId = component.get('v.familyId');
        if(isProviderMsgLevel == true){
            //Updated to pass label for provider messages feature for US3075477,US3078403,US3121134,US3124318,US3124366,US3124385
            recordType = component.get("v.label"); 
        }else{
            recordType = 'Family';
        }
        component.set('v.message', '');
        component.set('v.recordsList', []);
        
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'value' : value,
            'userId': component.get('v.userIdValue'),
            'recordType': recordType,
            'familyId':familyId,
            'isBackupAgentView':isBackupAgentViewcondition
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
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
    }
})