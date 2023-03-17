({
    hlprGetBackupAdvisors  : function(component, event, helper){

        var action = component.get("c.getBackUpAdvisors");
        // set param to method  
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length > 0) {
                    storeResponse.forEach(function(record){
                        record.Name = record.Advisor__r.Name
                    })
                    component.set("v.backupAgents", storeResponse);
                    var backupAgents = component.get("v.backupAgents");
                    console.log('backupAgents : ' + backupAgents);
                    var detail = [];
                    var newlst = [];
                    newlst.push(detail);
                    for(var i=0; i < backupAgents.length && i <= 10 ; i++) {
                        $A.createComponent("lightning:tab", {
                            "label" : backupAgents[i].Advisor__r.Name ,
                            "id" : backupAgents[i].Advisor__c ,
                            "onactive" : component.getReference("c.addContent", backupAgents[i])
                        }, function(newTab, status, error){
                            if(status === "SUCCESS"){
                                newlst.push(newTab);
                            } else {
                                throw new Error(error);
                            }    
                        });
                    }
                    component.set("v.agenttabs", newlst);
                } else {
                    
                }
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
  /*  addContent : function(component, event, helper){
        var tab = event.getSource();
        $A.createComponent('c:SNI_FL_AgentView', {
            'isConnectAPI' : true,
            'titleName' : tab.get("v.label"),
            'isBackupAgentView' : false,
            'selectedTabId' : tab.get("v.id")
        }, function (newContent, status, error) {  
            if (status === 'SUCCESS') {
                tab.set('v.body', newContent);
            } else {
                console.log(error);
            }
        })
    }*/
})