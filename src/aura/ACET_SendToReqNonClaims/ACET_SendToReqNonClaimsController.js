({
    quickListChange : function(component,event){
        
        var allList = component.get("v.sendToListInputs");
        var teamQuickList = allList.teamQuickList;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Team_Quick_List__c == teamQuickList) {
                if(!component.get('v.isFromWorkQueue'))
                {
                component.set("v.sendToListInputs.office",orsMap[i].Office__c);
                component.set("v.sendToListInputs.department",orsMap[i].Department__c);
                component.set("v.sendToListInputs.team",orsMap[i].Team__c);
                component.set("v.sendToListInputs.officeAPI",orsMap[i].Office_API__c);
                component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
                component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);
                }else
                {
                  if(component.get('v.wqTopic')=='View Claims')
                  {
                      if(orsMap[i].Type__c==component.get('v.wqType') && orsMap[i].Subtype__c==component.get('v.wqSubtype'))
                      {
                          component.set("v.sendToListInputs.office",orsMap[i].Office__c);
                          component.set("v.sendToListInputs.department",orsMap[i].Department__c);
                          component.set("v.sendToListInputs.team",orsMap[i].Team__c);
                          component.set("v.sendToListInputs.officeAPI",orsMap[i].Office_API__c);
                          component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
                          component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);
                      }
                  }else
                  {
                          component.set("v.sendToListInputs.office",orsMap[i].Office__c);
                          component.set("v.sendToListInputs.department",orsMap[i].Department__c);
                          component.set("v.sendToListInputs.team",orsMap[i].Team__c);
                          component.set("v.sendToListInputs.officeAPI",orsMap[i].Office_API__c);
                          component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
                          component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);

                  }
                }
            }
        }
    },
    officeChange : function(component,event){
        var allList = component.get("v.sendToListInputs");
        var office = allList.office;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Office__c == office) {
                component.set("v.sendToListInputs.officeAPI",orsMap[i].Office_API__c);
            }
        }
    },
    departmentChange : function(component,event){
        var allList = component.get("v.sendToListInputs");
        var department = allList.department;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Department__c == department) {
                component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
            }
        }
    },
    teamChange : function(component,event){
        var allList = component.get("v.sendToListInputs");
        var team = allList.team;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Team__c == team) {
                component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);
            }
        }
    },

    chooseSendOptions : function(component, event, helper){
        var selectList = event.getParam('value');
        component.set("v.selectedSendValue", selectList);
        if(selectList == 'teamList'){
            component.set("v.quickListFieldsRequiredSymbol",false);
            component.set("v.officeFieldsRequiredSymbol",true);
            component.set("v.disableRoleField",false);

            let sendToListInputs = component.get('v.sendToListInputs');
            if(!$A.util.isUndefinedOrNull(sendToListInputs.advocateRole) && sendToListInputs.advocateRole != 'Select'){
                component.set("v.disableQuickListField",false);//DE418730 - Sravan
            } else {
                component.set("v.disableQuickListField",true);//DE418730 - Sravan
            }
            component.set("v.disableOfficeField",true);
            component.set("v.disableDepartmentField",true);
            component.set("v.disableTeamField",true);
            component.find('teamQuickListId').find('comboboxFieldAI').setCustomValidity("");
            component.find('teamQuickListId').find('comboboxFieldAI').reportValidity();
            component.find('officeId').find('comboboxFieldAI').setCustomValidity("");
            component.find('officeId').find('comboboxFieldAI').reportValidity();
            component.find('departmentId').find('comboboxFieldAI').setCustomValidity("");
            component.find('departmentId').find('comboboxFieldAI').reportValidity();
            component.find('teamId').find('comboboxFieldAI').setCustomValidity("");
            component.find('teamId').find('comboboxFieldAI').reportValidity();
        }else if(selectList == 'office'){
            component.set("v.officeFieldsRequiredSymbol",false);
            component.set("v.quickListFieldsRequiredSymbol",true);
            component.set("v.disableOfficeField",false);
            //US2883416 - Change Functionality on Routing Screen - Sravan - Start
            //component.set("v.disableDepartmentField",false);
            //component.set("v.disableTeamField",false);
            //US2883416 - Change Functionality on Routing Screen - Sravan - End
            component.set("v.disableRoleField",true);
            component.set("v.disableQuickListField",true);
            component.find('advocateRoleId').find('comboboxFieldAI').setCustomValidity("");
            component.find('advocateRoleId').find('comboboxFieldAI').reportValidity();
            component.find('officeId').find('comboboxFieldAI').setCustomValidity("");
            component.find('officeId').find('comboboxFieldAI').reportValidity();
            component.find('departmentId').find('comboboxFieldAI').setCustomValidity("");
            component.find('departmentId').find('comboboxFieldAI').reportValidity();
            component.find('teamId').find('comboboxFieldAI').setCustomValidity("");
            component.find('teamId').find('comboboxFieldAI').reportValidity();
        }
    },

    validation : function(component, event, helper) {
        var selectedSendValue=component.get("v.selectedSendValue");
        if(selectedSendValue=="teamList"){
            component.find("advocateRoleId").validation();
            component.find("teamQuickListId").validation();
            return;
            
        }else{
            if(!component.get("v.disableOfficeField"))component.find("officeId").validation();
            if(!component.get("v.disableDepartmentField"))component.find("departmentId").validation();
            if(!component.get("v.disableTeamField"))component.find("teamId").validation();
            return;
        }
    },

    createCase : function(component, event, helper) {
        component.set("v.showError",false);
        component.set("v.showSpinner", true);
        component.set("v.isCreateCaseClicked", true);
        var validation = component.get('c.validation');
        $A.enqueueAction(validation);

        var cmpEvent = component.getEvent("createCase"); 
        cmpEvent.fire();

        
    }, 

    hideSpinner : function(component, event, helper) {
        component.set("v.showSpinner", false); 
    },

    //DE418730 - Sravan - Start
    enableDepartment : function(component, event, helper){

        var whereTTSTopic = component.get("v.whereTTSTopic");
        var whereCondition = whereTTSTopic+' AND '+'Office__c = '+"'"+component.get("v.sendToListInputs").office+"'";
        console.log('whereConditionForDepartment'+ whereCondition);
        component.set("v.whereConditionForDepartment",whereCondition);
        component.set("v.departmentReload",!component.get("v.departmentReload"));
        component.set("v.disableDepartmentField",false);
        if(component.get("v.sendToListInputs").office == 'Select'){
             var sendToListInputs = component.get("v.sendToListInputs");
             sendToListInputs.department = 'Select';
             component.set("v.sendToListInputs",sendToListInputs);
        }
    },
    enableTeam : function(component, event, helper){

         var whereTTSTopic = component.get("v.whereTTSTopic");
         var whereCondition = whereTTSTopic+' AND '+'Office__c = '+"'"+component.get("v.sendToListInputs").office+"'"+' AND '+'Department__c = '+"'"+component.get("v.sendToListInputs").department+"'";
         console.log('whereConditionForTeam'+ whereCondition);
         component.set("v.whereConditionForTeam",whereCondition);
         component.set("v.teamReload",!component.get("v.teamReload"));
         component.set("v.disableTeamField",false);
         if(component.get("v.sendToListInputs").department == 'Select'){
             var sendToListInputs = component.get("v.sendToListInputs");
             sendToListInputs.team = 'Select';
             component.set("v.sendToListInputs",sendToListInputs);
    	}
    },
    enableTeamQuickList : function(component, event, helper){
        var whereTTSTopic = component.get("v.whereTTSTopic");
        var whereCondition = whereTTSTopic+' AND '+'Advocate_Role__c = '+"'"+component.get("v.sendToListInputs").advocateRole+"'";
        console.log('whereConditionForTeamQuickList'+ whereCondition);
        component.set("v.whereConditionForTeamQuickList",whereCondition);
        component.set("v.TeamQuickListReload",!component.get("v.TeamQuickListReload"));
        component.set("v.disableQuickListField",false);
        if(component.get("v.sendToListInputs").advocateRole == 'Select'){
             var sendToListInputs = component.get("v.sendToListInputs");
             sendToListInputs.teamQuickList = 'Select';
             component.set("v.sendToListInputs",sendToListInputs);
        }
    },

    reloadAdvocateValues : function(component, event, helper){
        var advocateReload = component.get("v.advocateReload");
        component.set("v.advocateReload",!advocateReload);

    },
    enableTeamQuickListDefault : function(component, event, helper){
    	component.set("v.sendToListInputs.advocateRole",'All');

        var lstSelectedRoutedProviders=component.get("v.lstSelectedRoutedProviders");

        var state;
        if(  !$A.util.isEmpty(lstSelectedRoutedProviders)){
            state = lstSelectedRoutedProviders[0].state ;
        }
          if(!$A.util.isEmpty(state) ) {
                var action = component.get("c.getZones");
                action.setParams({
                        stateName:state
                    });
                action.setCallback(this, function (response) {
                    var responseData = response.getReturnValue();
                    if (responseData.success) {
                        var zone = responseData.zone;
                        if(!$A.util.isEmpty(zone) ){
                            component.set("v.sendToListInputs.teamQuickList",zone);
                            component.set("v.disableQuickListField",false);
                            component.set("v.IsDelegatedSpeciality",false);
                        }
                    }
                   }
            );
            $A.enqueueAction(action);
       }
    },

})