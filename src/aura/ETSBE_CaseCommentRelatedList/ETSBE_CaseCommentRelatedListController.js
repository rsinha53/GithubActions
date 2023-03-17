({
    
    init: function (cmp, event, helper) {
        
        var parentId=cmp.get("v.recordId");
        // alert('parentId---'+parentId);
        var action=cmp.get('c.getRelatedList');
        var existingExpArray=[];
        var title="Case Comments";
        action.setParams({
            caseId : parentId
        });
        action.setCallback(this,function(response){     
            var state=response.getState();
            //alert('state 1 ----'+state);
            if(state==="SUCCESS"){
                var responseLength=response.getReturnValue().length;
                
                if(responseLength== 0){
                    cmp.set("v.isShow" ,false);
                }else{
                    cmp.set("v.isShow" ,true);
                }
                if(responseLength<=6){
                    cmp.set("v.caseCommentCount",title + ' ' + '(' + response.getReturnValue().length + ')');
                } else{
                    cmp.set("v.caseCommentCount",title + ' ' + '(' + 6 + '+'+')');  
                }
                cmp.set("v.commentsdata",response.getReturnValue());
                helper.getData(cmp);
            }
        });
        $A.enqueueAction(action);
        var timezones = $A.get("$Locale.timezone");
       var date=  new Date().toLocaleString("en-US", {timeZone: "America/Mexico_City"}) ;
        cmp.set('v.Relatedcolumns', [
            {label: 'User', fieldName: 'linkName', type: 'url' ,hideDefaultActions: "true", cellAttributes:
             // { class: { fieldName: 'customCssClass' } },
             { iconName: { fieldName: 'linkIcon' }, iconLabel: { fieldName: 'Icon' }, iconPosition: 'left' },
             typeAttributes: {label: { fieldName: 'createByName' }, target: '_blank',tooltip: { fieldName: 'createByName' } } },
            {label: 'Public', fieldName: 'IsPublished', type: 'boolean', class:'slds-box'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date',hideDefaultActions: "true",
             typeAttributes: {year:'numeric', month:'numeric', day:'numeric', hour:'2-digit', minute:'2-digit',timeZone:"America/Mexico_City", hour12: true }},
            
            {label: 'Comment', fieldName: 'CommentBody', type: 'text',hideDefaultActions: "true",cellAttributes: { class: { fieldName: 'CommentBodyclass' }}}

            
        ]);
        
    },
    
    displayAddComment: function (component, event, helper) { 
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Case/'+component.get('v.recordId')+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ETSBE_CaseCommentPublicbox"
                    },
                    "state": {
                        "c__ParentID" :component.get('v.recordId')
                    }
                },
                focus: true
            }).then(function(response) {
                
                workspaceAPI.getTabInfo({
                    tabId: response
                    
                }).then(function(tabInfo) {
                    
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label:"New Case Comment"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Case Comment"
                    });
                    
                });
            });
        }).catch(function(error) {
            console.log(error);
        }); 
        
    },
   
    
    
    openRelatedList:function(component,event,helper){
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "CaseComments",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
    },
   
    
    
    
})