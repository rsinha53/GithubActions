({
    doInit : function(component, event, helper){
     component.set("v.togglecasepopup","false");
   },
	onClickRelatedCases : function(component, event, helper) { 
        component.set("v.togglecasepopup","false");
         component.set("v.isModalOpen", true);
        component.set("v.Spinner", true);
        component.set('v.dataTblId', new Date().getTime());
        helper.userCheck(component, event, helper);
        var interactiontype = component.get("v.interactiontype");
        var Calltopic = component.get("v.Calltopic");
        var ExternalIDs = component.get("v.ExternalIDs");
        var InteractionId = component.get("v.InteractionId");
        var SurrogateKey = component.get("v.SurrogateKey");
        var highlightPanel_String = component.get("v.highlightPanel_String");
        var action = component.get("c.getRelatedCases");     
        action.setParams({ 
                     "InteractionId" : InteractionId ,
                      "interactiontype" :interactiontype,
                      "Calltopic":Calltopic,
                      "ExternalIDs":ExternalIDs,
                      "SurrogateKey":SurrogateKey,
                      "highlightPanel_String":highlightPanel_String
                     }); 

    action.setCallback(this, function(response) {

        var state = response.getState();
        var newlst =[];
        var newlst1 =[];       
        if (state === "SUCCESS") {
            helper.hideSpinner2(component,event,helper);
         var AllRelatedCases = response.getReturnValue().AllRelatedCases;
         var AllRelatedCaseComments =response.getReturnValue().AllRelatedCaseComments;
            for(var i = 0; i < AllRelatedCases.length; i++){
                    AllRelatedCases[i].CreatedDate = $A.localizationService.formatDateTime(AllRelatedCases[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    newlst.push(AllRelatedCases[i]);
             }
           // alert(newlst);
             component.set("v.AllRelatedCases",newlst);
            for(var i = 0; i < AllRelatedCaseComments.length; i++){
                    AllRelatedCaseComments[i].CreatedDate = $A.localizationService.formatDateTime(AllRelatedCaseComments[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    newlst1.push(AllRelatedCaseComments[i]);
             }
             component.set("v.AllRelatedCaseComments",newlst1);
            //component.set("v.AllRelatedCaseComments",AllRelatedCaseComments);
            setTimeout(function(){
              var dataTblId = ('#'+component.get("v.dataTblId"));
                    $(dataTblId).DataTable({ 
                         paging: false,
                         bPaginate: false, 
                         bFilter: false,
                         bInfo: false,
                         order: [[0, 'desc']],
                         aoColumnDefs: [
                    { "aTargets": [ 0 ], "bSortable": true },
                    { "aTargets": [ 1 ], "bSortable": true },
                    { "aTargets": [ 2 ], "bSortable": true },
                    { "aTargets": [ 3 ], "bSortable": true },
                    { "aTargets": [ 4 ], "bSortable": true },
                    { "aTargets": [ 5 ], "bSortable": true },
                    { "aTargets": [ 6 ], "bSortable": true }
                ],
                searching: false
                });
        },5); 
        }
        else {
            helper.hideSpinner2(component,event,helper);
            console.log(state);
        }
       
    });
    $A.enqueueAction(action);
	},
    opencase: function(component, event, helper) {
        var CaseId =event.currentTarget.getAttribute("data-CaseId");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'case',
                    recordId : CaseId  
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
    handleMouseOveroncasenumber: function(component, event, helper) {
        var togglecasepopup = component.get("v.togglecasepopup");
        var CaseId =event.currentTarget.getAttribute("data-CaseId");

        if(togglecasepopup =="true"){
        helper.handleMouseOveroncasenumber(component, event,CaseId);
        }
    },
    CloseCasepopup: function(component, event, helper) {
       component.set("v.togglecasepopup","false");
    },
    OpencasenumberModel: function(component, event, helper) {
          component.set("v.togglecasepopup","true");
          var CaseId =event.currentTarget.getAttribute("data-CaseId");
          helper.handleMouseOveroncasenumber(component, event,CaseId);
    },
    OpenparentcasenumberModel: function(component, event, helper) {
          component.set("v.togglecasepopup","true");
          var CaseId =event.currentTarget.getAttribute("data-CaseId");
          helper.handleMouseOveroncaseParentnumber(component, event,CaseId);
    },
    closeModal: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   }
   
})