({
    doInit: function(component, event, helper){
      var action = component.get("c.getFamilyDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVal =  response.getReturnValue();
                if(!responseVal.ErrorOccured){
                var familyMap = responseVal.familyNameMap;
                var familyOptions = [];
                var selectedFamily ='';
                if(familyMap){
                for(var key in familyMap){
                    familyOptions.push({value:familyMap[key], key:key});
                }
                selectedFamily =familyOptions.length > 0 ?familyOptions[0].key : '';
                component.set("v.selectedFamily",selectedFamily);
                component.set("v.familyOptions",familyOptions);
                var careTeamMap = responseVal.careTeamMap;
                component.set("v.completeCareTeamMem",careTeamMap);
                component.set("v.FamilyAccountOwnerMap",responseVal.fLinkAccountOwner);
                helper.onChangeFamily(component, event, helper);
                } 
                }
                else {
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                      "url": "/error"
                  });
                  urlEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);  
    },
    onChangeFamily :function(component, event, helper){
       
        var onLoadSelectedFamily = component.get("v.selectedFamily");
        var selectedFamily = (component.find('FamilyId') == undefined ||component.find('FamilyId').get('v.value') == undefined  ?onLoadSelectedFamily:component.find('FamilyId').get('v.value')) ;
        var careTeamMap = component.get("v.completeCareTeamMem");
        var FamilyAccountOwnerMap = component.get("v.FamilyAccountOwnerMap");
        var careTeamMem = [];
        var selectedFamilyCareTeam = careTeamMap[selectedFamily];
        for(var key in selectedFamilyCareTeam){
            careTeamMem.push(selectedFamilyCareTeam[key]);
        }
        component.set("v.careTeamMembers",careTeamMem);
        component.set("v.FamilyAccountOwner",FamilyAccountOwnerMap[selectedFamily]);

        component.set("v.selectedFamily",selectedFamily);
        var selFamEvent = $A.get("e.c:SNI_FL_getSelectedFamily");
        selFamEvent.setParams({ 
            "familyAccId" : component.get("v.selectedFamily"),
            "familyAccountOwner" : component.get("v.FamilyAccountOwner")
        });
        selFamEvent.fire();
    }
})