({
    doInit:function(cmp,event,helper){
       
        var intId=cmp.get("v.interaction.Id")+ "MemberDetail";
        //var mbrId = cmp.get("v.interaction.Originator__r.AccountId");
        console.log('mbrId......'+ cmp.get("v.memberId"));
        //cmp.set("v.memberId", mbrId);
        cmp.set("v.AutodocKey",intId);
        helper.getUserInfo(cmp, event, helper);		
        helper.getorgInfo(cmp, event, helper);
        console.log("developerName is"+ cmp.get("v.developerName"));
        //cmp.set('v.interaction', cmp.get('interaction'));
       console.log('The name is '+ cmp.get("v.name"));
        console.log('The intercation id is '+ cmp.get("v.interaction.Id"));
    },
    prepareHighlightPanelInfo: function(cmp,event,helper){
        helper.prepareHighlightPanelInfo(cmp, event, helper);
    },
  
    navigateToDetail:function(component,event,helper){        
        var intId = event.currentTarget.getAttribute("data-intId");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function(tabInfo) {
                
            });
        }).catch(function(error) {
            console.log(error);
        });
    },

    handleShowOriginatorErrstop: function(component,event,helper){
        component.set("v.showOriginatorErrorFired",true);        
    },
    
    
        
})