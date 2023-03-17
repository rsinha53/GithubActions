({
    doInit : function(component, event, helper) {
        if(!component.get('v.apiCallMade')){
        helper.getEngagementHistory(component, event, helper);        
        }
    },
    
    handleDetailButton : function(component, event, helper) {
        var currIndex = event.target.dataset.index;
        var curr = component.get("v.contactHistoryDataList")[currIndex];
        component.set("v.contactHistoryDetailData",curr);
        component.set("v.isVisibleDetailPage", true);
    },
    
    closeDetailPage : function(component, event, helper) {
        component.set("v.isVisibleDetailPage", false);
    },
    
    sortByStatus: function(component, event, helper) {
        helper.sortBy(component,helper, "status");
        var a=component.get("v.sortAsc");
        component.set("v.status",a);
    },
    
    sortByCommunication: function(component, event, helper) {
        helper.sortBy(component,helper, "communication");
        var a=component.get("v.sortAsc");
        component.set("v.communication",a);
    },
    
    sortByCreatedBy: function(component, event, helper) {
        helper.sortBy(component,helper, "createdBy");
        var a=component.get("v.sortAsc");
        component.set("v.createdBy",a);
    },
    
    sortByType: function(component, event, helper) {
        helper.sortBy(component,helper, "type");
        var a=component.get("v.sortAsc");
        component.set("v.type",a);
    },
    
    sortByClosed: function(component, event, helper) {
        helper.sortBy(component,helper, "closedDateTime");
        var a=component.get("v.sortAsc");
        component.set("v.closedDateTime",a);
    },
    
    sortByOpened : function(component, event, helper) {
        helper.sortBy(component,helper, "openedDateTime");
        var a=component.get("v.sortAsc");
        component.set("v.openedDateTime",a);
    },
    
    sortByEngagementId : function(component, event, helper) {
        helper.sortBy(component,helper, "engagementId");
        var a=component.get("v.sortAsc");
        component.set("v.engagementId",a);
    },
    //Commented US2943826
    /*navigateDigitalContactHistory : function(component, event, helper) {
              helper.openDigitalContactHistoryUrl(component, event, helper);
             }*/
	 showContactHistoryCard : function(component, event,helper) { 
        component.set('v.renderContactHistory',false);
        component.set('v.renderCommitmentsCards',true);
        if(!component.get('v.apiCallMade')){
        helper.getEngagementHistory(component, event, helper);        
        }
    },
    hideContactHistoryCard: function(component, event) { 
        component.set('v.renderContactHistory',true);
        component.set('v.renderCommitmentsCards',false);
    }
})