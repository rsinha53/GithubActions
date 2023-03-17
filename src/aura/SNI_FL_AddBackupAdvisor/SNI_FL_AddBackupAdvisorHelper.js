({
   /* deleteClearedRecords : function(component,event,helper,selectedPills) {
        if(selectedPills.length > 0 && selectedPills!=null){
            console.log(selectedPills);
            
            //added vamsi sep10
            var action = component.get("c.delteBackUpAdvisors");
            // set param to method  
            action.setParams({
                'selectedPills': selectedPills
            });
            // set a callBack    
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    alert("From server: " + response.getReturnValue());
                    console.log('testregdg',storeResponse)
                    this.hlprsaveRecords(component,event,helper);
                    
                    if (storeResponse) {
                        console.log('testregdg',storeResponse)
                        
                    }
                }
                
            });
            // enqueue the Action  
            $A.enqueueAction(action);
        }else{
            this.hlprsaveRecords(component,event,helper);
            
        }
        
    },*/
    
    hlprsaveRecords : function(component,event,helper) {
        var deleteRecords = component.get('v.TodeleteclearedRecords');
        console.log('test',deleteRecords);
        var selectedUsers = component.get('v.selectedUserLookUpRecords');
        console.log('selectedUsers',selectedUsers);

        var BackUpAdvisor = []; 
        selectedUsers.forEach(function(record){
            if(record.Advisor__c==null){
                BackUpAdvisor.push({'Advisor':record.Id,
                                    'Name' : record.Name,
                                    'ExistingId':null});
            }else{
                BackUpAdvisor.push({
                    'Advisor':record.Advisor__c,
                    'Name' : record.Name,
                    'ExistingId':record.Id
                }) 
            }
        })
        
        
        var action = component.get("c.saveBackUpAdvisors");
        action.setParams({
            "strBackUpAdvisor" : JSON.stringify(BackUpAdvisor),
            'selectedPills' : deleteRecords
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                storeResponse.forEach(function(record){
                        record.Name = record.Advisor__r.Name
                    })
                
                component.set("v.selectedBackupAdvisors", storeResponse);
                var compEvents = component.getEvent("addBkpAdvsrEventFired");
                compEvents.setParams({ "Users" : storeResponse});
                compEvents.fire();
                $A.get('e.force:refreshView').fire(); 
            }
            else{
            }
        });
        $A.enqueueAction(action); 
        
    }
    
})