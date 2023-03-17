({
	doInit : function(component, event, helper) {
       component.set('v.dataTblId', new Date().getTime());
      
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
    changeRadio: function(component, event, helper) {
        var selectedvalue = event.getSource().get("v.value");  
        var selectedcaseid = event.getSource().get("v.name");  
        var inputradioselectlst = [];
            inputradioselectlst = component.find('inputradioselect');
         for (var i = 0; i<inputradioselectlst.length; i++){
            if(inputradioselectlst[i].get("v.value")!= selectedvalue){
                inputradioselectlst[i].set("v.checked",false);
             }
         }
        if(selectedvalue != 'No Related Cases'){
        var cmpEvent = component.getEvent("RelatedCases_Support_event");
        cmpEvent.setParams({
            "parentcaseid" : selectedcaseid });
        cmpEvent.fire();
        }
    },
    initrelatedcases: function(component, event, helper) {
                 component.set('v.submitDisabled',true);
       var interactiontype = component.get("v.interactiontype");
        var Calltopic = component.get("v.Calltopic");
        var ExternalIDs = component.get("v.ExternalIDs");
        var InteractionId = component.get("v.InteractionId");
        var SurrogateKey = component.get("v.SurrogateKey");
        var highlightPanel_String = component.get("v.highlightPanel_String");
        var action = component.get("c.getRelatedCases");     

        console.log('timeing relatedcases start'+new Date());
        action.setParams({ "InteractionId" : InteractionId ,
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
         var AllRelatedCases = response.getReturnValue().AllRelatedCases;
         var AllRelatedCaseComments =response.getReturnValue().AllRelatedCaseComments;
            for(var i = 0; i < AllRelatedCases.length; i++){
                    AllRelatedCases[i].CreatedDate = $A.localizationService.formatDateTime(AllRelatedCases[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    newlst.push(AllRelatedCases[i]);
             }
             component.set("v.AllRelatedCases",newlst);
            for(var i = 0; i < AllRelatedCaseComments.length; i++){
                    AllRelatedCaseComments[i].CreatedDate = $A.localizationService.formatDateTime(AllRelatedCaseComments[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    newlst1.push(AllRelatedCaseComments[i]);
             }
             component.set("v.AllRelatedCaseComments",newlst1);
            //component.set("v.AllRelatedCaseComments",AllRelatedCaseComments);
            setTimeout(function(){
	//DE431395-Component Error when clicked on Save Case Button -Added by Prasad
	         $(document).ready(function() {
              var dataTblId = ('#'+component.get("v.dataTblId"));
			  if($.fn.dataTable != undefined && $.fn.dataTable.isDataTable( dataTblId )){
                    $(dataTblId).DataTable({ 
                         paging: false,
                         bPaginate: false, 
                         bFilter: false,
                         bInfo: false,
                         order: [[1, 'desc']],
                         aoColumnDefs: [
                    { "aTargets": [ 0 ], "bSortable": false },
                    { "aTargets": [ 1 ], "bSortable": true },
                    { "aTargets": [ 2 ], "bSortable": true },
                    { "aTargets": [ 3 ], "bSortable": true },
                    { "aTargets": [ 4 ], "bSortable": true },
                    { "aTargets": [ 5 ], "bSortable": true },
                    { "aTargets": [ 6 ], "bSortable": true },
                    { "aTargets": [ 7 ], "bSortable": true }
                    
                ],
                searching: false
                });
				}else{
                        $(dataTblId).DataTable();
                  }
                        console.log('timeing relatedcases end'+new Date());
                component.set('v.Spinner',false);
                component.set('v.submitDisabled',false);
             });
        },500); 
        }
        else {
            console.log(state);
            component.set('v.Spinner',false);
            component.set('v.submitDisabled',false);
        }
    });
    $A.enqueueAction(action);
    }
})