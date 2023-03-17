({
getIndividualRecords: function(component, event, helper){
    var orsMap = component.get("v.orsMap");
    var office="";
    var dept="";
    var team="";
    for(var i in orsMap) {
    if(orsMap[i].Office__c==component.get("v.sendToListInputs.office") &&orsMap[i].Department__c==component.get("v.sendToListInputs.department")&&
      orsMap[i].Team__c==component.get("v.sendToListInputs.team") && orsMap[i].Type__c=='Issue Routed' &&  orsMap[i].Topic__c == component.get("v.ttsTopic")
       && orsMap[i].Subtype__c == component.get("v.ttsSubType")){
        office=orsMap[i].Office_API__c;
        dept=orsMap[i].Department_API__c;
        team=orsMap[i].Team_API__c;
         component.set("v.sendToListInputs.departmentAPI",dept);
         component.set("v.sendToListInputs.officeAPI",office);
         component.set("v.sendToListInputs.teamAPI",team);
            break;
        }
    }
  var action = component.get("c.callSelectAssociateAPI");
        action.setParams({
            officeId:office,
            departmentCode:dept,
            teamCode:team
        });
        action.setCallback(this, function (response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                 var associateRecords =response.getReturnValue();
                 component.set("v.associateRecords",associateRecords);
                 var comboboxRecords = [];
                 var filteredComboboxRecords = [];
                 var comboboxRecords = associateRecords.map(a => a.associateName);

                 component.set("v.comboboxRecords",comboboxRecords);
                 for (var i in associateRecords) {
                     filteredComboboxRecords.push({
                                "label": associateRecords[i].associateName,
                                "value": associateRecords[i].associateName
                            });

                          }
                 component.set("v.individualOptions", filteredComboboxRecords);
            }
            });
        $A.enqueueAction(action);
    }
})