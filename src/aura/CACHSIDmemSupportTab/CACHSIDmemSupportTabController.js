({
	doInit : function(component, event, helper) {
    var action2 = component.get('c.HSIDmemUrls');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS") {
                console.log('>>>>>>is member or not<<<<<<<'+response.getReturnValue());
                component.set('v.showHSID', response.getReturnValue());
            }
            
        });        
       
        $A.enqueueAction(action2);
        
    },
    handleClick: function(component, event, helper) {
        
        var action = component.get("c.getCustMetaData");
        action.setCallback(this, function(response){
            console.log('response: '+response.getReturnValue());
            if(response.getReturnValue()==false){
                window.open($A.get("$Label.c.Change_Password_URL"),'_self');   
            }
            else{
               
                    let currentUser = $A.get("$SObjectType.CurrentUser.Id");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/settings/'+currentUser 
                    });
                    urlEvent.fire(); 
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    ShowAccSetting: function(component, event, helper) {
                var currentUser = $A.get("$SObjectType.CurrentUser.Id");
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": '/settings/'+currentUser 
            });
            urlEvent.fire();
            
            }

    
})