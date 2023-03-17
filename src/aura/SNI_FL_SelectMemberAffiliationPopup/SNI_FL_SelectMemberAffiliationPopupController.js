({
    doInit : function(component, event, helper) {
        var columnHeaders =[{label: 'Name', fieldName: 'MemberName', type: 'text'},{label: 'Member Affiliation ID', fieldName: 'AffiliationID', type: 'text' },{label: 'Provider Affiliation', fieldName: 'ProviderAffiliationName', type: 'text'},{label: 'Enrollment Date', fieldName: 'EnrollmentDate', type: 'text'}] ;
        component.set('v.affiliationColumnPopUp',columnHeaders);
        component.set('v.saveDisableMemberAffiliationPopUp',true);
        var action = component.get("c.getMemberAffiliationList");
        action.setParams({
            "accountID": component.get("v.AccountID")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var memberAffiliationResponse = response.getReturnValue();
                component.set('v.affiliationDetails',memberAffiliationResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    closeModel : function(component,event,helper){
        helper.setModel(component,event,false);
    },
    
    rowselect: function(component,event,helper){
        var popId =event.getSource().getLocalId();
        var rowSelAction = event.getParam("selectedRows");
        var selectedRowArray = [];
        selectedRowArray.push({
            'ID': rowSelAction[0].id,
            'MemberName':rowSelAction[0].MemberName,
            'AffiliationID':rowSelAction[0].AffiliationID,
            'ProviderAffiliationName' :rowSelAction[0].ProviderAffiliationName,
            'EnrollmentDate':rowSelAction[0].EnrollmentDate
        });
        component.set("v.selectedAffiliationID",rowSelAction[0].id);
        component.set("v.AccountName",rowSelAction[0].MemberName);
        component.set("v.selectedRow",selectedRowArray);
        if(popId == 'MemberAffiliationPopUp'){
            if(selectedRowArray.length > 0){
                component.set("v.saveDisableMemberAffiliationPopUp",false);
            }
        }
    },
    
    viewMessage: function(component,event,helper){
       helper.navigateOlderMessage(component,event,helper);
    }
})