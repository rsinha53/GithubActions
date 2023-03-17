({
    onLoad : function(cmp, event, helper) {
        debugger;
        var sendToListInputs = {
            "advocateRole": "Select",
            "teamQuickList": "Select",
            "office": "Select",
            "department": "Select",
            "team": "Select",
            "individual": "Select",
            "officeAPI":"",
            "departmentAPI":"",
            "teamAPI":"",
        };
        cmp.set("v.sendToListInputs", sendToListInputs);
        var viewClaims = cmp.get("v.ttsTopic");
        var viewClaimsSubType = cmp.get("v.ttsSubType");
        cmp.set('v.optionName',"sendListName"+Math.random());
        if(viewClaims == 'View Claims'){
            cmp.set("v.isClaim", true);
            cmp.set("v.disableRoleField",false);
            cmp.set("v.disableQuickListField",false);
            cmp.set("v.hideEntireSection",false);
            cmp.set("v.isClaimView", true);
            cmp.set("v.quickListFieldsRequiredSymbol",false);
        }
        cmp.set("v.whereConditionForDepartment", 'Topic__c = '+"'" + viewClaims + "'");
        cmp.set("v.whereConditionForTeam", 'Topic__c = '+"'" + viewClaims + "'");
        var commonWhereCondition= 'Topic__c ='+ "'" +'View Claims'+"'" +' AND Type__c ='+ "'"+'Issue Routed'+"'"+' AND Subtype__c ='+"'"+viewClaimsSubType+"'";
        cmp.set("v.commonWhereCondition",commonWhereCondition);
        if(cmp.get("v.policyName")=="CS")
            commonWhereCondition=commonWhereCondition+' AND Advocate_Role__c NOT IN ('+"'"+'M&R'+"','"+'M&R Strategic Account Services'+"')";
        else if(cmp.get("v.policyName")=="CO - Hospital")
            commonWhereCondition=commonWhereCondition+' AND Advocate_Role__c NOT IN ('+"'"+'E&I'+"','"+'E&I Strategic Account Services'+"')";
        else
            commonWhereCondition=commonWhereCondition+' AND Advocate_Role__c NOT IN ('+"'"+'E&I'+"','"+'E&I Strategic Account Services'+"')";
        cmp.set("v.whereConditionForAdvocate",commonWhereCondition);
        cmp.set("v.whereTTSTopic",commonWhereCondition); 
         //US3463210 - Sravan - Start
                if(viewClaimsSubType == 'Claims Project 20+ Claims'){
                    cmp.set("v.isShowCmp", false);
                }
                else{
                    cmp.set("v.isShowCmp", true);
                }
                //US3463210 - Sravan - EndisTPSM
    },

    isTPMSLevelChange: function(cmp, event, helper){
        var tpsm=cmp.get("v.TPMSLevel");
        var isTpsm=false;
        var policyName=cmp.get("v.policyName");
        var isEscalatedValueChange = cmp.get('c.isEscalatedValueChange');
        var whereCondition= cmp.get("v.whereConditionForAdvocate");
        if(tpsm>=100 && tpsm<=599)
            isTpsm=true;
        cmp.set("v.isTPSM",isTpsm);
        whereCondition=whereCondition+' AND TPSM__c IN ('+"'"+isTpsm+"')";
        cmp.set("v.whereConditionForAdvocate",whereCondition);
        cmp.set("v.whereTTSTopic",whereCondition);
        cmp.set("v.AdvocatetReload",!cmp.get("v.AdvocatetReload"));
        cmp.set("v.TeamQuickListReload",!cmp.get("v.TeamQuickListReload"));
        $A.enqueueAction(isEscalatedValueChange);
    },

    isEscalatedValueChange : function(cmp, event, helper){
        var  isEscalatedValue = cmp.get("v.isEscalatedValue");
        var policyName=cmp.get("v.policyName");
        var isTpsm=cmp.get("v.isTPSM");
        var viewClaimsSubType = cmp.get("v.ttsSubType");
        var selectedSendValue=cmp.get("v.selectedSendValue");
        if(viewClaimsSubType!='Escalated Appeal' && viewClaimsSubType!='Claims Project 20+ Claims' &&viewClaimsSubType!='Stop Pay and Reissue'){
        if(policyName=="CS"){
            if(isEscalatedValue=='Yes' && isTpsm==false ){
                cmp.set("v.sendToListInputs.advocateRole","E&I");
                cmp.set("v.sendToListInputs.teamQuickList","Reconsideration - Escalated");
            }
            else if(isEscalatedValue=='Yes' && isTpsm==true){
                cmp.set("v.sendToListInputs.advocateRole","E&I Strategic Account Services");
                cmp.set("v.sendToListInputs.teamQuickList","SAS Reconsideration - Escalated");
            }else if(isEscalatedValue=='No' && isTpsm==false ){
            	cmp.set("v.sendToListInputs.advocateRole","E&I");
            }else if(isEscalatedValue=='No' && isTpsm==true ){
            	cmp.set("v.sendToListInputs.advocateRole","E&I Strategic Account Services");
            }
        }else if(policyName=='CO - Physician' || policyName == 'CO - Hospital'){
            if(isEscalatedValue=='No' && isTpsm==false ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R");
            }
           else if(policyName=='CO - Physician' && isEscalatedValue=='Yes' && isTpsm==false ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R");
                cmp.set("v.sendToListInputs.teamQuickList","Reconsideration - Escalated Physician");
            }
            else if(policyName=='CO - Physician' && isEscalatedValue=='Yes' && isTpsm==true ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R Strategic Account Services");
                cmp.set("v.sendToListInputs.teamQuickList","SAS Reconsideration - Escalated Physician");
            }else if(policyName=='CO - Hospital' && isEscalatedValue=='Yes' && isTpsm==false ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R");
                cmp.set("v.sendToListInputs.teamQuickList","Reconsideration - Escalated Facility");
            }
            else if(policyName=='CO - Hospital' && isEscalatedValue=='Yes' && isTpsm==true ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R Strategic Account Services");
                cmp.set("v.sendToListInputs.teamQuickList","SAS Reconsideration - Escalated Facility");
            }
            else if(isEscalatedValue=='No' && isTpsm==true ){
            	cmp.set("v.sendToListInputs.advocateRole","M&R Strategic Account Services");
            }
        }}
         if(selectedSendValue=="teamList"){
             cmp.find("advocateRoleId").stopError();
             cmp.find("teamQuickListId").stopError();
        }
       else {
            if(!cmp.get("v.disableOfficeField"))cmp.find("officeId").stopError();
            if(!cmp.get("v.disableDepartmentField"))cmp.find("departmentId").stopError();
            if(!cmp.get("v.disableTeamField"))cmp.find("teamId").stopError();
            if(!cmp.get("v.disableIndividualField"))cmp.find("Individual").stopError();
        }
    },

	chooseSendOptions : function(component, event, helper){
        var selectList = event.getParam('value');
        var  isEscalatedValue = component.get("v.isEscalatedValue");
        var isTpsm=component.get("v.isTPSM");
        var demographicInfo = component.get('v.demographicInfo');
        var enableIndividual = component.get('c.enableIndividual');
        var viewClaimsSubType = component.get("v.ttsSubType");
        var viewClaimsSubType = component.get("v.ttsSubType");
         component.set("v.selectedSendValue", selectList);
         component.set("v.isIndividualReq",false);
        component.set("v.disableIndividualField",true);
        component.find("Individual").stopValidation();
        if(selectList == 'teamList'){
            component.set("v.quickListFieldsRequiredSymbol",false);
            component.set("v.officeFieldsRequiredSymbol",true);
            component.set("v.disableRoleField",false);
            component.set("v.disableQuickListField",false);
            component.set("v.disableOfficeField",true);
            component.set("v.disableDepartmentField",true);
            component.set("v.disableTeamField",true);
            component.find("officeId").stopValidation();
            component.find("departmentId").stopValidation();
            component.find("teamId").stopValidation();
            $A.enqueueAction(component.get('c.isEscalatedValueChange'));
        }else {
            var whereCondition=component.get("v.whereTTSTopic");
            var demographicInfo = component.get('v.demographicInfo');
            if(component.get("v.sendToListInputs.advocateRole")=="Select" || component.get("v.sendToListInputs.teamQuickList")=="Select"){
                whereCondition= component.get("v.commonWhereCondition");
                if(component.get("v.policyName")=="CS"){
                  whereCondition= whereCondition+' AND Office__c NOT IN  ('+"'"+'PRV'+"','"+'COSTCNT'+"','"+'GOV COSTCNT'+"','"+'GOV'+"')";
                    if(isTpsm==true &&viewClaimsSubType!='Stop Pay and Reissue' && viewClaimsSubType!='Claims Project 20+ Claims' &&
                    viewClaimsSubType!='Clerical Request' && viewClaimsSubType!='Escalated Appeal'){
              component.set("v.sendToListInputs.office","SAS");
             component.set("v.sendToListInputs.department","ENI");
              component.set("v.sendToListInputs.team","ADJ");
                  }
                    if(demographicInfo.issue == 'TRACR Request'){
                    whereCondition= whereCondition+' AND Office__c IN  ('+"'"+'SPRINGFLD'+"')";
                    }
                }
                else if(component.get("v.policyName")=="CO - Hospital"){
                       whereCondition= whereCondition+' AND Office__c NOT IN  ('+"'"+'PCRS'+"','"+'SPRINGFLD'+"','"+'MED REV'+"')";
                   if(viewClaimsSubType!='Stop Pay and Reissue' && viewClaimsSubType!='Claims Project 20+ Claims' &&
                      viewClaimsSubType!='Clerical Request' && viewClaimsSubType!='Escalated Appeal'){
                        if( isTpsm==true ) {
              component.set("v.sendToListInputs.office","SAS");
             component.set("v.sendToListInputs.department","MNR");
              component.set("v.sendToListInputs.team","HOS");
                   }else if(isTpsm==false) {
              component.set("v.sendToListInputs.office","PRV");
             component.set("v.sendToListInputs.department","Hospital");
              component.set("v.sendToListInputs.team","HOS");
                   }
                   }
                    if(demographicInfo.issue == 'TRACR Request'){
                        whereCondition=whereCondition+' AND Office__c IN ('+"'"+'COSTCNT'+"')";
                    }else if(demographicInfo.issue == 'Stop Pay and Reissue'){
                        whereCondition=whereCondition+' AND Office__c IN ('+"'"+'COSTCNT'+"')";
                    }
                }
                else{
                        whereCondition= whereCondition+' AND Office__c NOT IN  ('+"'"+'PCRS'+"','"+'SPRINGFLD'+"','"+'MED REV'+"','"+'GOV COSTCNT'+"')";
                    if(viewClaimsSubType!='Stop Pay and Reissue' && viewClaimsSubType!='Claims Project 20+ Claims' &&
                       viewClaimsSubType!='Clerical Request' && viewClaimsSubType!='Escalated Appeal') {
                        if( isTpsm==true){
                        component.set("v.sendToListInputs.office","SAS");
                        component.set("v.sendToListInputs.department","MNR");
                        component.set("v.sendToListInputs.team","PHY");
                        }else if(isTpsm==false){
                         component.set("v.sendToListInputs.office","PRV");
                        component.set("v.sendToListInputs.department","Physician");
                        component.set("v.sendToListInputs.team","PHY");
                        }
                   }
                    if(demographicInfo.issue == 'TRACR Request'){
                        whereCondition=whereCondition+' AND Office__c IN ('+"'"+'COSTCNT'+"')";
                        } else if(demographicInfo.issue == 'Stop Pay and Reissue'){
                        whereCondition=whereCondition+' AND Office__c IN ('+"'"+'COSTCNT'+"')";
                        }
                }
            }
            component.set("v.whereTTSTopic",whereCondition);
            component.set("v.officeReload",!component.get("v.officeReload"));
            component.set("v.officeFieldsRequiredSymbol",false);
            component.set("v.quickListFieldsRequiredSymbol",true);
            component.set("v.disableOfficeField",false);
            component.set("v.disableRoleField",true);
            component.set("v.disableQuickListField",true);
            component.find("advocateRoleId").stopValidation();
            component.find("teamQuickListId").stopValidation();
        }
        $A.enqueueAction(enableIndividual);
    },
    quickListChange : function(component,event){
        var viewClaims = component.get("v.ttsTopic");
        var viewClaimsSubType = component.get("v.ttsSubType");
        var allList = component.get("v.sendToListInputs");
        var teamQuickList = allList.teamQuickList;
        var orsMap = component.get("v.orsMap");
        var size=0;
        var office="Select";
        var dept="Select";
        var team="Select";
        console.log('orsMap'+orsMap);
         console.log('orsMap1'+JSON.stringify(orsMap));
        for(var i in orsMap) {
         if(orsMap[i].Advocate_Role__c == allList.advocateRole && orsMap[i].Team_Quick_List__c == teamQuickList &&  orsMap[i].Topic__c == viewClaims && orsMap[i].Type__c=='Issue Routed'  && orsMap[i].Subtype__c == viewClaimsSubType) {
             var office=orsMap[i].Office__c;
             var dept=orsMap[i].Department__c;
             var team=orsMap[i].Team__c;
             component.set("v.sendToListInputs.officeAPI",orsMap[i].Office_API__c);
             component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
             component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);
             size++;
            }
        }
        if(size>1){
             component.set("v.disableOfficeField",false);
             component.set("v.quickListFieldsRequiredSymbol",true);
        }
        component.set("v.sendToListInputs.office",office);
        component.set("v.sendToListInputs.department",dept);
        component.set("v.sendToListInputs.team",team);
    },
     enableTeam : function(component, event, helper){
         var whereTTSTopic = component.get("v.whereTTSTopic");
         var demographicInfo = component.get('v.demographicInfo');
         var whereCondition = whereTTSTopic+' AND '+'Office__c = '+"'"+component.get("v.sendToListInputs").office+"'"+' AND '+'Department__c = '+"'"+component.get("v.sendToListInputs").department+"'";
        if(component.get("v.policyName")=="CO - Hospital"){
             whereCondition=whereCondition+' AND Team__c NOT IN ('+"'"+'PHY'+"')";
            if(demographicInfo.issue == 'TRACR Request'){
                whereCondition=whereCondition+' AND Team__c IN ('+"'"+'TRACR'+"')";
            }else if(demographicInfo.issue == 'Stop Pay and Reissue'){
                whereCondition=whereCondition+' AND Team__c IN ('+"'"+'HOS'+"')";
            }
        }
        else if(component.get("v.policyName")=="CO - Physician"){
            whereCondition=whereCondition+' AND Team__c NOT IN ('+"'"+'HOS'+"')";
            if(demographicInfo.issue == 'TRACR Request'){
                whereCondition=whereCondition+' AND Team__c IN ('+"'"+'TRACR'+"')";
            }else if(demographicInfo.issue == 'Stop Pay and Reissue'){
                whereCondition=whereCondition+' AND Team__c IN ('+"'"+'PHY'+"')";
            }

        }
         component.set("v.whereConditionForTeam",whereCondition);
         component.set("v.teamReload",!component.get("v.teamReload"));
         component.set("v.disableTeamField",false);
         component.set("v.isIndividualReq",false);
         component.set("v.disableIndividualField",true);
         component.set("v.sendToListInputs.individual",'Select');
         if(component.get("v.sendToListInputs.department") == 'Select'){
             component.set("v.sendToListInputs.team",'Select');
         }
    },
     enableDepartment : function(component, event, helper){
         var whereTTSTopic = component.get("v.whereTTSTopic");
         var demographicInfo = component.get('v.demographicInfo');
         var whereCondition = whereTTSTopic+' AND '+'Office__c = '+"'"+component.get("v.sendToListInputs").office+"'";
         if(component.get("v.policyName")=="CS"){
                      whereCondition=whereCondition+' AND Department__c NOT IN ('+"'"+'MNR'+"')";
                 if(demographicInfo.issue == 'TRACR Request')
                        whereCondition=whereCondition+' AND Department__c IN ('+"'"+'TRACR'+"')";
         }
         else if(component.get("v.policyName")=="CO - Hospital")
                whereCondition=whereCondition+' AND Department__c NOT IN ('+"'"+'ENI'+"','"+'Physician'+"')";
         else
            whereCondition=whereCondition+' AND Department__c NOT IN ('+"'"+'ENI'+"','"+'Hospital'+"')";
         component.set("v.whereConditionForDepartment",whereCondition);
         component.set("v.departmentReload",!component.get("v.departmentReload"));
         component.set("v.disableDepartmentField",false);
         component.set("v.isIndividualReq",false);
         component.set("v.disableIndividualField",true);
         component.set("v.sendToListInputs.individual",'Select');
         if(component.get("v.sendToListInputs.office") == 'Select'){
             component.set("v.sendToListInputs.department","Select");
         }
    },
    enableIndividual : function(component, event, helper){
        var sendToListInputs = component.get("v.sendToListInputs");
        if(component.get("v.sendToListInputs.team") == 'Select'){
            component.set("v.sendToListInputs.individual",'Select');
        }
        if(component.get("v.selectedSendValue")=="individual" && sendToListInputs.department != 'Select' && sendToListInputs.team != 'Select' && sendToListInputs.office != 'Select')
        {
            component.set("v.disableIndividualField",false);
            component.set("v.isIndividualReq",true);
        }
         helper.getIndividualRecords(component, event, helper);
            },
   /* departmentChange : function(component,event){
        var allList = component.get("v.sendToListInputs");
        var department = allList.department;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Department__c == department) {
                component.set("v.sendToListInputs.departmentAPI",orsMap[i].Department_API__c);
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
    teamChange : function(component,event){
        var allList = component.get("v.sendToListInputs");
        var team = allList.team;
        var orsMap = component.get("v.orsMap");
        for(var i in orsMap) {
            if(orsMap[i].Team__c == team) {
                component.set("v.sendToListInputs.teamAPI",orsMap[i].Team_API__c);
            }
        }
    },*/
    advoacteRoleChange: function(component, event, helper){
        var viewClaims = component.get("v.ttsTopic");
        var viewClaimsSubType = component.get("v.ttsSubType");
        var allList = component.get("v.sendToListInputs");
        var advocateRole = allList.advocateRole;
        var whereTTSTopic = component.get("v.whereTTSTopic");
        console.log('In Send To - demographicInfo ' +JSON.stringify(component.get('v.demographicInfo')));
        var demographicInfo = component.get('v.demographicInfo');

        var whereCondition = 'Topic__c ='+ "'" +'View Claims'+"'" +' AND Type__c ='+ "'"+'Issue Routed'+"'"+' AND '+'Advocate_Role__c = '+"'"+advocateRole+"'";
        whereCondition = whereCondition+' AND Subtype__c ='+"'"+viewClaimsSubType+"'" ;
       if(component.get("v.policyName")=="CO - Hospital"){
            whereCondition=whereCondition+' AND Team_Quick_List__c NOT IN ('+"'"+'Reconsideration - Escalated Physician'+"','"+'Reconsideration - Non Escalated Physician'+"','"
            +'SAS Reconsideration - Escalated Physician'+"','"+'SAS Reconsideration - Non Escalated Physician'+"','"+'Stop Pay/Reissue - Physician'+"','"+'Initial Keying - Non Escalated Physician'+"','"
            +'Keying Corrections - Non Escalated Physician'+"','"+'SAS Initial Keying - Non Escalated Physician'+"','"+'SAS Keying Corrections - Escalated Physician'+"','"+'SAS Keying Corrections - Non Escalated Physician'+"')";
        }else if(component.get("v.policyName")=="CO - Physician")
            whereCondition=whereCondition+' AND Team_Quick_List__c NOT IN ('+"'"+'Reconsideration - Escalated Facility'+"','"+'Reconsideration - Non Escalated Facility'+"','"
            +'SAS Reconsideration - Escalated Facility'+"','"+'SAS Reconsideration - Non Escalated Facility'+"','"+'Stop Pay/Reissue - Facility'+"','"+'Initial Keying - Non Escalated Facility'+"','"+'Keying Corrections - Non Escalated Facility'+"','"+
             'SAS Initial Keying - Non Escalated Facility'+"','"+'SAS Keying Corrections - Escalated Facility'+"','"+'SAS Keying Corrections - Non Escalated Facility'
            +"','"+'HCA - Med Nec Review'+"','"+'SAS HCA - Med Nec Review'+"')";
             if(demographicInfo.issue == 'TRACR Request'){
                        whereCondition =  whereCondition+ ' AND Team_Quick_List__c IN ('+"'"+'TRACR Check Request'+"')";
                }else if(demographicInfo.issue =='Stop Pay and Reissue'){
                        if(component.get("v.policyName")=="CO - Hospital"){
                                whereCondition =  whereCondition+ ' AND Team_Quick_List__c IN ('+"'"+'Stop Pay/Reissue - Facility'+"')";
                        }else if(component.get("v.policyName")=="CO - Physician"){
                                whereCondition =  whereCondition+ ' AND Team_Quick_List__c IN ('+"'"+'Stop Pay/Reissue - Physician'+"')";
                        }else{
                                whereCondition =  whereCondition+ ' AND Team_Quick_List__c IN ('+"'"+'Stop Pay/Reissue'+"')";
                        }
                }
        component.set("v.whereTTSTopic",whereCondition);
        var sendToListInputs = component.get("v.sendToListInputs");
        sendToListInputs.teamQuickList = 'Select';
        component.set("v.sendToListInputs",sendToListInputs);
        console.log('advoacte role'+whereCondition);
        component.set("v.TeamQuickListReload",!component.get("v.TeamQuickListReload"));
        component.set("v.officeReload",!component.get("v.officeReload"));
        component.set("v.disableTeamField",true);
        //}
    },
    onTeamQuickChange: function(component, event, helper){
       /* var viewClaims = component.get("v.ttsTopic");
          var viewClaimsSubType = component.get("v.ttsSubType");*/
            var allList = component.get("v.sendToListInputs");
            var office = allList.office;
            //if(component.get("v.sendToListInputs.teamQuickList")!='Select'){
             var  whereCondition =component.get("v.whereTTSTopic")+' AND '+'Team_Quick_List__c = '+"'"+allList.teamQuickList+"'" ;
            component.set("v.whereTTSTopic",whereCondition);
            console.log('office'+whereCondition);
            component.set("v.officeReload",!component.get("v.officeReload"));
            console.log('officeReload'+whereCondition);
           // }
    },
     validation : function(cmp, event, helper) {
        //US3463210 - Sravan - Start
        var viewClaimsSubType = cmp.get("v.ttsSubType");
        var skipValidation = false;
        if(viewClaimsSubType == 'Claims Project 20+ Claims'){
            skipValidation = true;
        }
        else{
            skipValidation = false;
        }
        //US3463210 - Sravan - End

     var ClaimRoutingTabChangeEvent = cmp.getEvent("ClaimRoutingTabChangeEvent");
         var selectedSendValue=cmp.get("v.selectedSendValue");
        if(event.getParam("Type")!="Submit" && ((selectedSendValue=="teamList" && cmp.get("v.sendToListInputs.advocateRole")!="Select" && cmp.get("v.sendToListInputs.teamQuickList")!="Select")
         ||((selectedSendValue=="office" || (selectedSendValue=="individual" && cmp.get("v.sendToListInputs.individual")!="Select")) && cmp.get("v.sendToListInputs.office")!="Select" && cmp.get("v.sendToListInputs.department")!="Select"&& cmp.get("v.sendToListInputs.team")!="Select"))){
            ClaimRoutingTabChangeEvent.setParams({"isComboboxCmp" : true});
            ClaimRoutingTabChangeEvent.fire();
            return false;
        }
       else if(cmp.get("v.showError") && !skipValidation){
            cmp.set("v.stopChngTab","No");
            return false;
        }
       else if( event.getParam("Type")!="Submit" && !skipValidation){
            setTimeout(function() {
             cmp.find("SendTo").getElement().scrollIntoView({
             behavior: 'smooth',
             block: 'center',
             inline: 'nearest'
              });
              }, 100);
            }
        if(selectedSendValue=="teamList" && !skipValidation){
             cmp.find("advocateRoleId").validation();
             cmp.find("teamQuickListId").validation();
            return;
        }
       else if(!skipValidation){
            if(!cmp.get("v.disableOfficeField"))cmp.find("officeId").validation();
            if(!cmp.get("v.disableDepartmentField"))cmp.find("departmentId").validation();
            if(!cmp.get("v.disableTeamField"))cmp.find("teamId").validation();
            if(!cmp.get("v.disableIndividualField"))cmp.find("Individual").validation();
              return;
        }
          },
     createCase : function(cmp, event, helper) {

         console.log('In Send To - additionalReqDtl '  + JSON.stringify(cmp.get('v.additionalReqDtl')));
         console.log('In Send To - demographicInfo ' +JSON.stringify(cmp.get('v.demographicInfo')));
         console.log('In Send To - selectedUnresolvedClaims '+ JSON.stringify(cmp.get('v.selectedUnresolvedClaims')));
         console.log('In Send To - sendToListInputs ' +JSON.stringify(cmp.get('v.sendToListInputs')));
         var sbtBName= cmp.get("v.sbtBName");
         var claimPolicyList= cmp.get("v.claimPolicyList");
         var count=0;
         if(sbtBName=="Submit"){
         for(var i=1;i<claimPolicyList.length;i++){
             if(!cmp.get("v.Tabs").includes(claimPolicyList[i-1].policyType)){
               cmp.set("v.selTabId",claimPolicyList[i-1].policyType);
               cmp.set("v.prvselTabId",claimPolicyList[i-1].policyType);
                 count++;
                 break;
             }}
            if(count==0)
             cmp.set("v.Tabs",cmp.get("v.Tabs")+"Last");

               }
         cmp.set("v.showError",false);
         cmp.set("v.isShowError",false);
         cmp.set("v.text",'');
         var ClaimRoutingValidationEvent = cmp.getEvent("ClaimRoutingValidationEvent");
           ClaimRoutingValidationEvent.setParams({"Type" :cmp.get('v.sbtBName')});
                 ClaimRoutingValidationEvent.fire();

         },
     seterrorToButton:function(component, event, helper){
      if(component.get("v.isShowError")){
       component.set("v.text",'Select the Next button to continue.');
        setTimeout(function() {
             component.find("SendTo").getElement().scrollIntoView({
             behavior: 'smooth',
             block: 'center',
             inline: 'nearest'
              });
              }, 100);
      }
      else
        component.set("v.text",'');
     },
     individualSelected : function(component, event, helper){
        var individualName = component.get("v.individualName");
        var associateRecords = component.get("v.associateRecords");
         if( !$A.util.isEmpty(associateRecords)){
            var selectedRec = associateRecords.find( a => a.associateName == individualName);
         	if(!$A.util.isEmpty(selectedRec) ){
            var associateId = selectedRec.associateId;
            component.set("v.sendToListInputs.individual", associateId);
    		 }
     	}
         if(individualName=="Select")
    		 component.set("v.sendToListInputs.individual", "Select");
      },
     retryORSCases : function(cmp, event, helper) {
          var count= cmp.get('v.count');
           if(count==0){
              cmp.set("v.Tabs",cmp.get("v.Tabs")+"resolvefail");
              cmp.set('v.dUniqueCmbClaimMap',cmp.get('v.uniqueCmbClaimMap'));
              cmp.set('v.dSelectedUnresolClaims',cmp.get('v.selectedUnresolClaims'));
              cmp.set('v.retry',false);
              cmp.set('v.uniqueCmbClaimMap',[]);
              cmp.set('v.selectedUnresolClaims',[]);
                   }
               var selectedUnresolClaims =cmp.get('v.dSelectedUnresolClaims');
               if(count==selectedUnresolClaims.length-1 ||selectedUnresolClaims.length==0 ){
               var uniqueCmbClaimMap=cmp.get('v.dUniqueCmbClaimMap');
               cmp.set('v.retry',true);
               if(!$A.util.isEmpty(uniqueCmbClaimMap)){
                 uniqueCmbClaimMap.filter(a=> a.orsFailed== true).forEach( r=> {
                 r.orsFailed = false;
                 r.sendToOrs = false;
                             })
                    }
                  cmp.set('v.uniqueCmbClaimMap',uniqueCmbClaimMap);
                    }
                       else
                       cmp.set('v.retry',false);
                     cmp.set('v.failSelectedUnresolvedClaims',[]);
                  cmp.set('v.claimsToRetry',[]);
                 if( !$A.util.isUndefinedOrNull(selectedUnresolClaims[count])){
                 var claimsToRetry=selectedUnresolClaims[count];
                 var  claims=claimsToRetry.claimsToRetryFromCurrentRun;
                 cmp.set("v.failedAdditionalReqDtl",claimsToRetry.additionalReqDtl);
                 cmp.set('v.failedDemographicInfo',claimsToRetry.demographicInfo);
                 cmp.set('v.failedSendToListInputs', claimsToRetry.sendToListInputs);
                   if(!$A.util.isEmpty(claims)){
                      claims.forEach( r=> {
                      r.sendToOrs = false;
                       })
		 cmp.set('v.failSelectedUnresolvedClaims',claims);
                 }}
                var createORSCases = cmp.get('c.createORSCases');
                $A.enqueueAction(createORSCases);
         /*working logic
         var unresolvedClmsToRetry = cmp.get("v.unresolvedClmsToRetry");
         var resolvedUniquePolicyToRetry = cmp.get("v.resolvedUniquePolicyToRetry");
         */

             },
    createORSCases : function(cmp, event, helper) {

         console.log("createORSCases in SendTo component");
         var acetCaseId = cmp.get("v.acetCaseId");
         var strRecord = JSON.stringify(cmp.get("v.caseWrapper"));
         if(  !$A.util.isEmpty(acetCaseId) && acetCaseId!='' ){

             var allResolvedClaims = cmp.get('v.allResolvedClaims');
             var selectedUnresolvedClaims ;
             var additionalReqDtl;
             var demographicInfo ;
             var sendToListInputs;
             if(!cmp.get("v.Tabs").includes("resolvefail")){
                 selectedUnresolvedClaims = cmp.get("v.selectedUnresolvedClaims");
                 additionalReqDtl = cmp.get("v.additionalReqDtl");
                 demographicInfo = cmp.get('v.demographicInfo');
                 sendToListInputs= cmp.get('v.sendToListInputs');
             }else{
                 selectedUnresolvedClaims = cmp.get("v.failSelectedUnresolvedClaims");
                 additionalReqDtl = cmp.get("v.failedAdditionalReqDtl");
                 demographicInfo = cmp.get('v.failedDemographicInfo');
                 sendToListInputs= cmp.get('v.failedSendToListInputs');
             }
             var threeClaims;
             if(selectedUnresolvedClaims.length>0){
             if(demographicInfo.stateValue=="Select")
               demographicInfo.stateValue="";
             console.log('selectedUnresolvedClaimsInSendTo: '+JSON.stringify(selectedUnresolvedClaims));
             if(cmp.get("v.ttsSubType")=="Misquote of Information"){
                  threeClaims = selectedUnresolvedClaims
                 .filter(c => c.sendToOrs!= true && c.underAmmount =="Yes" && c.PCMValue == "Yes" )
                 .slice(0,3);
             }else if(cmp.get("v.ttsSubType")=="Stop Pay and Reissue" && demographicInfo.issue != 'TRACR Request'){
                 threeClaims = selectedUnresolvedClaims
                 .filter(c => c.sendToOrs!= true && c.typesValue =="Paper" && c.cashedValue=="No" )
                 .slice(0,3);
             }else if(cmp.get("v.ttsSubType")=="Additional Information Received"){
                  threeClaims = selectedUnresolvedClaims
                 .filter(c => c.sendToOrs!= true && ((($A.localizationService.formatDate(c.AIRLUDateValue,"yyyy/MM/dd") >= $A.localizationService.formatDate(c.AIRPDNDateValue,"yyyy/MM/dd"))&& c.AIRreason == "COB Update") || (c.AIRreason != "COB Update")))
                 .slice(0,3);
             }else{
                   threeClaims = selectedUnresolvedClaims
                 .filter(c => c.sendToOrs!= true)
                 .slice(0,3);
             }}


             console.log('threeClaims: '+JSON.stringify(threeClaims));

             //console.log('misqThreeClaims: '+JSON.stringify(misqThreeClaims));

             var threeUniqueCmb = [];

             var isResolved = false;
             var finalSubmitCaseCreated = false;
             var claimForORSCase = [];
             var claimAddDetails = {};
             var sbtBName = cmp.get("v.sbtBName");

             var uniqueCmbClaimMap = cmp.get("v.uniqueCmbClaimMap");

             if(!$A.util.isEmpty(threeClaims) && threeClaims.length > 0 ){
                 //unresolved claims
                 isResolved = false;
                 claimForORSCase =  threeClaims;
                 claimAddDetails.demographicInfo = demographicInfo;
                 claimAddDetails.additionalReqDtl =  additionalReqDtl;
                 claimAddDetails.sendToInfo=sendToListInputs;

             }
             else if ( sbtBName == "Submit"){
                 //resolved claims
                 var firstSubmit = cmp.get("v.firstSubmit");
                 if(firstSubmit && !cmp.get("v.Tabs").includes("resolvefail")){
                     if(cmp.get("v.ttsSubType")=="Stop Pay and Reissue" && demographicInfo.issue != 'TRACR Request'){
                     var nonPaperClaims = selectedUnresolvedClaims.filter(c => c.typesValue != "Paper" || (c.typesValue == "Paper" && c.cashedValue == "Yes"));
                     allResolvedClaims = allResolvedClaims.concat(nonPaperClaims);
                     }
                     else if(cmp.get("v.ttsSubType")=="Misquote of Information"){
                        var misqResovedClaims = selectedUnresolvedClaims.filter(c => (c.underAmmount =="No" || (c.underAmmount =="Yes" && c.PCMValue == "No" )));
                     allResolvedClaims = allResolvedClaims.concat(misqResovedClaims);
                     }else if(cmp.get("v.ttsSubType")=="Additional Information Received"){
                          var misqResovedClaims = selectedUnresolvedClaims.filter(c => ($A.localizationService.formatDate(c.AIRLUDateValue,"yyyy/MM/dd") < $A.localizationService.formatDate(c.AIRPDNDateValue,"yyyy/MM/dd")));
                          allResolvedClaims = allResolvedClaims.concat(misqResovedClaims);
                     }

                     var uniqueCmbClaimMap = [] ;
                     if(!$A.util.isEmpty(allResolvedClaims) && allResolvedClaims.length > 0){
                     	cmp.set('v.allResolvedClaims',allResolvedClaims);
                     	cmp.set("v.firstSubmit",false);

                     	var uniqueCombinationsForResolved;

                     	uniqueCombinationsForResolved = allResolvedClaims.map(p => {
                                                         return {"policyType" : p.policyType  ,
                                                          "memberId" :p.memberId,
                                                          "groupNo" :p.groupNo,
                                                          }})
                                                        .filter((a, i) => allResolvedClaims
                                                                .findIndex(b =>
                                                                           b.policyType === a.policyType &&
                                                                           b.memberId === a.memberId
                                                                           && a.groupNo === b.groupNo) === i);


                      	uniqueCombinationsForResolved.forEach( u => {
                        var clmList = allResolvedClaims.filter( c => c.policyType === u.policyType
                                                                           && c.groupNo === u.groupNo
                                                                           &&  c.memberId === u.memberId
                                                                      );

                               var uniqueKey = u.policyType + '_' + u.groupNo + '_'+ u.memberId;
                               var obj = {};
                               obj.policyType = u.policyType;
                               obj.memberId =  u.memberId;
                               obj.groupNo =  u.groupNo;
                               obj.claims =  clmList;
                               uniqueCmbClaimMap.push(obj);
                       }) ;

                       cmp.set("v.uniqueCmbClaimMap", uniqueCmbClaimMap);
                 	}
                  }
                  var uniqueCmbClaimMap = cmp.get("v.uniqueCmbClaimMap");
                  threeUniqueCmb = uniqueCmbClaimMap
                                .filter(c => c.sendToOrs!= true )
                                .slice(0,3);
              }


             if(claimForORSCase.length > 0 ){
                 var orsSubType = cmp.get("v.ttsSubType");
				 //unresolved cases exist
                 claimForORSCase.forEach( c => c.sendToOrs = true);
                 var action = cmp.get('c.createORSCaseForClaimsUnresolved');
                 var orsFormatClaims = claimForORSCase.map( c=>   { return {
                                                                   "claimId" : c.claimId,
                                                                   "ServiceDate" : c.serviceDates,
                                                                   "types" : c.typesValue,
                                                                   "cashed" : c.cashedValue,
                                                                   "paymentNoInput": c.paymentNoInput,
                                                                   "matchingSRN":c.matchingSRN,

                                                                   "charged":c.charged,
                                                                   "underAmmount":c.underAmmount,
                                                                   "PCMValue":c.PCMValue,
                                                                   "sourceValue":c.sourceValue,
                                                                   "FLNNumber":c.FLNNumber,
                                                                   "MISInfo":c.MISInfo,
                                                                   "externalID":c.externalID,
                                                                   "providerStatus" : c.providerStatus,
                                                                   "benfitLevel": c.benfitLevel,
                                                                   "expectedAllowed":c.expectedAllowed,
                                                                   "reason":c.reason,
                                                                   "eReasonValue":c.eReasonValue,
                                                                   "coverageLevel":c.coverageLevel,
                                                                   "eligibilityDates":c.eligibilityDates,
                                                                   "matchingRefereal":c.matchingRefereal,
                                                                   "receivedDate":c.receivedDate,
                                                                   "tflDate":$A.localizationService.formatDate(c.tflDate,"MM/dd/yyyy"),
                                                                   "uhcErrorValue":c.uhcErrorValue,
                                                                   "FLNValue":c.FLNValue,
                                                                   "RODreason":c.RODreason,
                                                                   "CheckValue":c.CheckValue,
                                                                   "DateValue":$A.localizationService.formatDate(c.DateValue,"MM/dd/yyyy"),
                                                                   "overPayValue":c.overPayValue,
                                                                   "ReasonValue":c.ReasonValue,
                                                                   "AIRreason":c.AIRreason,
                                                                   "AIRFLNValue":c.AIRFLNValue,
                                                                   "AIRFLNDateValue":!$A.util.isEmpty(c.AIRFLNDateValue) ? $A.localizationService.formatDate(c.AIRFLNDateValue,"MM/dd/yyyy") : '',
                                                                   "AIRLUDateValue":!$A.util.isEmpty(c.AIRLUDateValue) ? $A.localizationService.formatDate(c.AIRLUDateValue,"MM/dd/yyyy") : '',
                                                                   "AIRPDNDateValue":c.AIRPDNDateValue,
                                                                   "PsReason":c.PsReason,
                                                                   "originalClaim":c.originalClaim,
                                                                   "correctedClaim":c.correctedClaim,
																   "engCode":orsSubType == 'Keying Request' ? c.engCode: '--',
                                                                   "flndcc":orsSubType == 'Keying Request' ? c.flndcc: '--',
                                                                   "checkAmount":c.checkAmount,
                                                                   "CheckDate":$A.localizationService.formatDate(c.CheckDate,"MM/dd/yyyy"),
                                                                   "ChashDate":!$A.util.isEmpty(c.ChashDate) ?$A.localizationService.formatDate(c.ChashDate,"MM/dd/yyyy"): '',
                                                                   "groupNo":c.groupNo
                                                                  }
                                                            });

                 action.setParams({
                     "strRecord": strRecord,
                     "caseId" : acetCaseId,
                     "claims": orsFormatClaims,
                     "claimAddDetails" : claimAddDetails,
                 });
                 action.setCallback(this, function(response) {
                     var state = response.getState();
                     console.log('state@@@' + state);
                     var data; //ketki ors retry
                     if (state == "SUCCESS") {
                         data = response.getReturnValue(); //ketki ors retry
                         cmp.set("v.acetCaseId", data.caseId);


                     }
                     else if (state === "INCOMPLETE") {
                         console.log("Failed to connect Salesforce!!");

                     }
                         else if (state === "ERROR") {
                             var errors = response.getError();
                             if (errors) {
                                 if (errors[0] && errors[0].message) {
                                     console.log("error :"+errors[0].message);
                                 }
                             }
                      }

                     //ketki ors retry begin

                    var failedClaims;

                     //var selectedUnresolvedClaims =  cmp.get('v.selectedUnresolvedClaims');

                     if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.unresolvedORSClaimResults)){
                               failedClaims = data.unresolvedORSClaimResults.filter(u => u.result.resultStatus != "200").map(c => c.claimId);

                              //ketki routing using continuation begin
                         	  var allrelatedCaseItemMap = cmp.get("v.caseWrapper").allrelatedCaseItemMap;
                              var unresolvedORSClaimResults = data.unresolvedORSClaimResults;
                              for(let res in unresolvedORSClaimResults ){
                                     let groupNo = unresolvedORSClaimResults[res].result.relatedGroupNumber;

                                             let claimNumber = unresolvedORSClaimResults[res].result.relatedclaimNumber;
                                             let orsReturnId = unresolvedORSClaimResults[res].result.orsReturnId;


                                             for (const [key, value] of Object.entries(allrelatedCaseItemMap)) {

                                                           let caseItemByGrpMap = value ;
                                                           for (let [key1, value1] of Object.entries(caseItemByGrpMap)) {
                                                                    let caseItem = value1;
                                                                    if(caseItem.uniqueKey == claimNumber){
                                                                        if(unresolvedORSClaimResults[res].result.resultStatus =="200"){
                                                                            caseItem.orsReturnId = orsReturnId;
                                                                        }
                                                                        	caseItem.relatedGroupNumber = groupNo;
                                                                        	break;
                                                                    }

                                                           }

                                             }

                                }
                         		//ketki routing using continuation end
                      }
                      else if ($A.util.isEmpty(data) || $A.util.isEmpty(data.unresolvedORSClaimResults)){
                             //assume all send claims failed
                              failedClaims = orsFormatClaims.map(c => c.claimId);
                       }
                       //update original unresolved claim list with indicating failed status
                     if(!$A.util.isEmpty(failedClaims)){
                           var claimsToRetry = cmp.get('v.claimsToRetry');
                           var claimsToRetryFromCurrentRun = selectedUnresolvedClaims.filter(r=> failedClaims.includes(r.claimId));
                           claimsToRetry = claimsToRetry.concat(claimsToRetryFromCurrentRun);
                           cmp.set('v.claimsToRetry',claimsToRetry);
                      }
                       //ketki ors retry end

                     if(cmp.get("v.ttsSubType")=="Stop Pay and Reissue" && demographicInfo.issue != 'TRACR Request'){
                         var claimsNotProcessed = selectedUnresolvedClaims.filter(c => c.sendToOrs!= true && c.typesValue =="Paper" && c.cashedValue == "No");
					 }else if(cmp.get("v.ttsSubType")=="Misquote of Information"){
                          var claimsNotProcessed = selectedUnresolvedClaims.filter(c => c.sendToOrs!= true && c.underAmmount =="Yes" && c.PCMValue == "Yes");
					 }else if(cmp.get("v.ttsSubType")=="Additional Information Received"){
                          var claimsNotProcessed = selectedUnresolvedClaims.filter(c => c.sendToOrs!= true && ((($A.localizationService.formatDate(c.AIRLUDateValue,"yyyy/MM/dd") >= $A.localizationService.formatDate(c.AIRPDNDateValue,"yyyy/MM/dd"))&& c.AIRreason == "COB Update") || (c.AIRreason != "COB Update")))
                     }else {
                          var claimsNotProcessed = selectedUnresolvedClaims.filter(c => c.sendToOrs!= true);
                     }
                     var totalResolvedClaimsNotProcessed;
                     if( $A.util.isEmpty(claimsNotProcessed) || claimsNotProcessed.length == 0 ){

                           //add non paper claims to all resolved before returning
                         var nonProcessedClaims;
                         if(cmp.get("v.ttsSubType")=="Stop Pay and Reissue" && demographicInfo.issue != 'TRACR Request'){
                              nonProcessedClaims = selectedUnresolvedClaims.filter(c => c.typesValue != "Paper" || (c.typesValue == "Paper" && c.cashedValue == "Yes"));
						}else if(cmp.get("v.ttsSubType")=="Misquote of Information"){
                              nonProcessedClaims = selectedUnresolvedClaims.filter(c => c.underAmmount =="No" || (c.underAmmount =="Yes" && c.PCMValue == "No" ));
                         }else if(cmp.get("v.ttsSubType")=="Additional Information Received"){
                              nonProcessedClaims = selectedUnresolvedClaims.filter(c => $A.localizationService.formatDate(c.AIRLUDateValue,"yyyy/MM/dd") < $A.localizationService.formatDate(c.AIRPDNDateValue,"yyyy/MM/dd"));
                         }else{
                             nonProcessedClaims = selectedUnresolvedClaims;
                         }

                         totalResolvedClaimsNotProcessed = allResolvedClaims.concat(nonProcessedClaims);
                         totalResolvedClaimsNotProcessed = totalResolvedClaimsNotProcessed.filter(c => c.sendToOrs!= true );
                     }

                     if((!$A.util.isEmpty(claimsNotProcessed) && claimsNotProcessed.length >0) ||
                        (cmp.get("v.sbtBName") == "Submit" && !$A.util.isEmpty(totalResolvedClaimsNotProcessed) && totalResolvedClaimsNotProcessed.length >0 )){
                          //repeat the service call
                         var createORSCases = cmp.get('c.createORSCases');
                         $A.enqueueAction(createORSCases);
                      }
                      else{
                           //return from next button
                          if(cmp.get("v.ttsSubType")=="Stop Pay and Reissue" && demographicInfo.issue != 'TRACR Request'){
                              var nonPaperClaims = selectedUnresolvedClaims.filter(c => c.typesValue != "Paper" || (c.typesValue == "Paper" && c.cashedValue == "Yes"));
                              allResolvedClaims = allResolvedClaims.concat(nonPaperClaims);
                              cmp.set('v.allResolvedClaims',allResolvedClaims);
                          }else if(cmp.get("v.ttsSubType")=="Misquote of Information"){
                              var misqResovedClaims = selectedUnresolvedClaims.filter(c => (c.underAmmount =="No" || (c.underAmmount =="Yes" && c.PCMValue == "No" )));
                              allResolvedClaims = allResolvedClaims.concat(misqResovedClaims);
                              cmp.set('v.allResolvedClaims',allResolvedClaims);
                          }else if(cmp.get("v.ttsSubType")=="Additional Information Received"){
                              var misqResovedClaims = selectedUnresolvedClaims.filter(c => ($A.localizationService.formatDate(c.AIRLUDateValue,"yyyy/MM/dd") < $A.localizationService.formatDate(c.AIRPDNDateValue,"yyyy/MM/dd")));
                              allResolvedClaims = allResolvedClaims.concat(misqResovedClaims);
                              cmp.set('v.allResolvedClaims',allResolvedClaims);
                          }
                          var sbtBName = cmp.get("v.sbtBName");
                          var displayModal = false;
                          var selectedUnresolClaims = cmp.get('v.selectedUnresolClaims');
                          var claimsToRetry={};
                          if(!$A.util.isEmpty(cmp.get('v.claimsToRetry'))){
                          claimsToRetry.claimsToRetryFromCurrentRun=cmp.get('v.claimsToRetry');
                          claimsToRetry.additionalReqDtl=additionalReqDtl;
                          claimsToRetry.demographicInfo= demographicInfo;
                          claimsToRetry.sendToListInputs= sendToListInputs;
                          selectedUnresolClaims = selectedUnresolClaims.concat(claimsToRetry);
                          cmp.set('v.selectedUnresolClaims',selectedUnresolClaims);
                          }
                          if( sbtBName=="Submit" ){
                            var claimsToRetry =  cmp.get('v.selectedUnresolClaims');
                            if( !$A.util.isEmpty(claimsToRetry)){
                                  displayModal = true;
                            }
                          }
                          if( cmp.get('v.retry')){
                               cmp.set('v.count',0);
                               var claimRoutingServiceCallCompleteEvent = cmp.getEvent("ClaimRoutingServiceCallCompleteEvent");
                               claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : displayModal });
                               claimRoutingServiceCallCompleteEvent.fire();
                          }else{
                              var cont=cmp.get('v.count');
                               cmp.set('v.count',cont+1);
                               var retryORSCases = cmp.get('c.retryORSCases');
                                  $A.enqueueAction(retryORSCases);
                          }
                      }
                 });
                 $A.enqueueAction(action);
             }
             else if( threeUniqueCmb.length > 0){
				 //resolved cases exist
                 threeUniqueCmb.forEach( u => {
                                               u.sendToOrs = true ;
                                               u.claims.forEach( c => c.sendToOrs = true);
                                              });
                 var allUnresolvedResolvedFlg = false;
                 var allResolvedClaims =  cmp.get("v.allResolvedClaims");
                 var ar1 =[];
                    if(!$A.util.isEmpty(allResolvedClaims)){
                        ar1 = allResolvedClaims.map(p=> p.claimId);
                    }

                    //var selectedUnresolvedClaims =  cmp.get("v.selectedUnresolvedClaims");
                    var ar2 =[];
                    if(!$A.util.isEmpty(selectedUnresolvedClaims)){
                        ar2 = selectedUnresolvedClaims.map(p=> p.claimId);
                    }

                    if(ar2.every(r => ar1.includes(r))){
                      console.log('all unresolved claims are now resolved');
                      allUnresolvedResolvedFlg = true;
                    }else{
                       allUnresolvedResolvedFlg = false;
                       console.log('all unresolved claims are NOT resolved');
                    }
                    cmp.set('v.allUnresolvedResolvedFlg',allUnresolvedResolvedFlg) ;

                 var action = cmp.get('c.createORSCaseForClaimsResolved');
                 var orsFormatUniqueComp = threeUniqueCmb.map( u=>   { return {
                                                                         "policyType" : u.policyType,
                                                                         "memberId" : u.memberId,
                                                                         "groupNo" : u.groupNo,
                                                                         "claims" : u.claims.map (c => {return {
                                                                                                         "claimId" : c.claimId,
                                                                                                         "ServiceDate" : c.serviceDates,
                                                                                                         "types" : c.typesValue,
                                                                                                         "cashed" : c.cashedValue,
                                                                                                        }}),
                                                                }});

                    //ketki continuation - update previously unresolved cases to resolved in allrelatedCaseItems begin
                    var allrelatedCaseItemMap = cmp.get("v.caseWrapper").allrelatedCaseItemMap;
					var claims = orsFormatUniqueComp.flatMap( c=>c.claims);
                    for (let i in claims ){
                     for (const [key, value] of Object.entries(allrelatedCaseItemMap)) {
                         let caseItemByGrpMap = value ;
                         for (let [key1, value1] of Object.entries(caseItemByGrpMap)) {
                             let caseItem = value1;
                             if(caseItem.uniqueKey == claims[i].claimId){
                                 caseItem.isResolved = true;
                                 break;
                             }
                         }
                      }
                   }
                   //ketki continuation - update previously unresolved cases to resolved in allrelatedCaseItems end


                 action.setParams({
                     "strRecord": strRecord,
                     "caseId" : acetCaseId,
                     "resolvedCaseClaims": orsFormatUniqueComp,
					 "allUnresolvedResolvedFlg": allUnresolvedResolvedFlg
                 });
                 action.setCallback(this, function(response) {
                     var state = response.getState();
                     console.log('state@@@' + state);
                     var data ;
                     if (state == "SUCCESS") {
                         data = response.getReturnValue();
                     }
                     else if (state === "INCOMPLETE") {
                         console.log("Failed to connect Salesforce!!");
                     }
                         else if (state === "ERROR") {
                             var errors = response.getError();
                             if (errors) {
                                 if (errors[0] && errors[0].message) {
                                     console.log("error :"+errors[0].message);
                                 }
                             }
                      }

                      //ketki ors retry begin
                      var failedUniquePolicies;

                     var uniqueCmbClaimMap = cmp.get('v.uniqueCmbClaimMap');

                     if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.resolvedORSClaimResults)){
                         failedUniquePolicies = data.resolvedORSClaimResults.filter(u => u.result.resultStatus != "200").map(c =>{ return {
                            																							 "memberId":c.memberId,
                             																							 "policyType": c.policyType,
                            																							 "groupNo" : c.groupNo
                                                                                                                                 }});
                          //ketki routing using continuation begin
                         	  var allrelatedCaseItemMap = cmp.get("v.caseWrapper").allrelatedCaseItemMap;
                              var resolvedORSClaimResults = data.resolvedORSClaimResults;
                              for(let res in resolvedORSClaimResults ){
                                     let groupNo = resolvedORSClaimResults[res].groupNo;
                                     let memberId = resolvedORSClaimResults[res].memberId;
                                     let policyType = resolvedORSClaimResults[res].policyType;




                                             var claims = orsFormatUniqueComp.find( u=> u.groupNo == groupNo &&
                                                                                   u.memberId == memberId &&
                                                                                   u.policyType == policyType).claims;
                                             let orsReturnId = resolvedORSClaimResults[res].result.orsReturnId;


                                         	 for (let i in claims ){
                                                 for (const [key, value] of Object.entries(allrelatedCaseItemMap)) {
                                                     let caseItemByGrpMap = value ;
                                                     for (let [key1, value1] of Object.entries(caseItemByGrpMap)) {
                                                         let caseItem = value1;
                                                         if(caseItem.uniqueKey == claims[i].claimId){
                                                             if(resolvedORSClaimResults[res].result.resultStatus =="200"){
                                                             	caseItem.orsReturnId = orsReturnId;
                                                             }
                                                             caseItem.relatedGroupNumber = groupNo;
                                                             break;
                                                         }

                                                     }
                                                 }
                                         	}

                                }
                         		//ketki routing using continuation end
                      }
                      else if ($A.util.isEmpty(data) || $A.util.isEmpty(data.resolvedORSClaimResults)){
                           //assume all unique policies failed
                          failedUniquePolicies = orsFormatUniqueComp.map(c => { return {
                                 														"memberId":c.memberId,
                             															"policyType": c.policyType,
                            															"groupNo" : c.groupNo
                                                                                     }});
                       }
                      //update original resolved claims list with indicating failed status
                     if(!$A.util.isEmpty(failedUniquePolicies)){
                       failedUniquePolicies.forEach( f=>
                             uniqueCmbClaimMap.filter(a=> a.memberId == f.memberId
                                                      && a.policyType == f.policyType
                                                      && a.groupNo == f.groupNo ).forEach( s => s.orsFailed = true )
                       );
                     }
                      cmp.set('v.uniqueCmbClaimMap',uniqueCmbClaimMap);
                      //ketki ors retry end

                     var uniqueCmbClaimMapNotProcessed = uniqueCmbClaimMap.filter(c => c.sendToOrs!= true );
                     if((!$A.util.isEmpty(uniqueCmbClaimMapNotProcessed) && uniqueCmbClaimMapNotProcessed.length >0)){
                          //repeat the service call
                          var createORSCases = cmp.get('c.createORSCases');
                          $A.enqueueAction(createORSCases);
                      }
                      else{
                            //ketki ors retry begin
                            //check if any of the resolved or unresolved ors cases have failed
                             var displayModal = false;
                             var selectedUnresolClaims = cmp.get('v.selectedUnresolClaims');
                             var claimsToRetry={};
                             if(!$A.util.isEmpty(cmp.get('v.claimsToRetry'))){
                             claimsToRetry.claimsToRetryFromCurrentRun=cmp.get('v.claimsToRetry');
                             claimsToRetry.additionalReqDtl= additionalReqDtl;
                             claimsToRetry.demographicInfo=demographicInfo;
                             claimsToRetry.sendToListInputs=sendToListInputs;
                             selectedUnresolClaims = selectedUnresolClaims.concat(claimsToRetry);
                             cmp.set('v.selectedUnresolClaims',selectedUnresolClaims);
                          }
                            var claimsToRetry =  cmp.get('v.selectedUnresolClaims');
                            if( !$A.util.isEmpty(claimsToRetry)){
                                  displayModal = true;
                            }else {
                                  var allResolvedClaims = cmp.get('v.uniqueCmbClaimMap');
                                  var anyFailedResolvedCase = allResolvedClaims.find(c => c.orsFailed == true);
                                  if( !$A.util.isEmpty(anyFailedResolvedCase)){
                                  		displayModal = true;
                            	  }
                            }

                            //ketki ors retry end
                           if( cmp.get('v.retry')){
                               cmp.set('v.count',0);
                           var claimRoutingServiceCallCompleteEvent = cmp.getEvent("ClaimRoutingServiceCallCompleteEvent");
                           claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : displayModal });
                           claimRoutingServiceCallCompleteEvent.fire();
                           }
                          else{
                              var cont=cmp.get('v.count');
                               cmp.set('v.count',cont+1);
                               var retryORSCases =cmp.get('c.retryORSCases');
                                  $A.enqueueAction(retryORSCases);
                          }
                       }
                 });
                 $A.enqueueAction(action);

             }
             else{


                  //this gets called if the current tab is not submit. It will add cases which were previously marked as unresolved and are now
                  //converted to resolved
                  var nonPaperClaims = selectedUnresolvedClaims.filter(c => c.typesValue ||c.types!= "Paper" );
                  allResolvedClaims = allResolvedClaims.concat(nonPaperClaims);
                  cmp.set('v.allResolvedClaims',allResolvedClaims);

                  var claimRoutingServiceCallCompleteEvent = cmp.getEvent("ClaimRoutingServiceCallCompleteEvent");
                  claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
                  claimRoutingServiceCallCompleteEvent.fire();
             }
         }
         else {
 			 //get acet case ID
              var action = cmp.get('c.saveCase');
              action.setParams({
                         "strRecord": strRecord,
                         "isProvider" : false
               });
				action.setCallback(this, function(response) {
                     var state = response.getState();
                     console.log('state@@@' + state);
                     if (state == "SUCCESS") {
                         var data = response.getReturnValue();
                         cmp.set("v.acetCaseId", data);
                        var createORSCases = cmp.get('c.createORSCases');
                        $A.enqueueAction(createORSCases);
                     }
                     else if (state === "INCOMPLETE") {
                         console.log("Failed to connect Salesforce!!");
                     }
                         else if (state === "ERROR") {
                             var errors = response.getError();
                             if (errors) {
                                 if (errors[0] && errors[0].message) {
                                     console.log("error :"+errors[0].message);
                                 }
                             }
                      }
                  });
                 $A.enqueueAction(action);
         }
     },

     //US3463210 - Sravan - Start
     createCaseForClaimsProject: function(component, event, helper){
        var sbtBName = component.get("v.sbtBName");
        var strRecord = JSON.stringify(component.get("v.caseWrapper"));
        if(sbtBName == 'Submit'){
            var action = component.get('c.saveCase');
              action.setParams({
                         "strRecord": strRecord,
                         "isProvider" : false
               });
				action.setCallback(this, function(response) {
                     var state = response.getState();
                     console.log('state@@@' + state);
                     if (state == "SUCCESS") {
                         var data = response.getReturnValue();
                         component.set("v.acetCaseId", data);
                         var claimPolicyList = component.get("v.claimPolicyList");
                         if(!$A.util.isUndefinedOrNull(claimPolicyList) && !$A.util.isEmpty(claimPolicyList)){
                             for(var key in claimPolicyList){
                                if(claimPolicyList[key].policyType != 'AP'){
                                    component.set("v.selectedUnresolvedClaims",claimPolicyList[key].claims);
                                    var createOrsForSOP = component.get('c.createOrsForSOP');
                                    $A.enqueueAction(createOrsForSOP);
                                }
                                else{
                                    var createFacets = component.get("c.createFacets");
                                    $A.enqueueAction(createFacets);
                                }
                             }

                         }


                     }
                     else if (state === "INCOMPLETE") {
                         console.log("Failed to connect Salesforce!!");
                     }
                         else if (state === "ERROR") {
                             var errors = response.getError();
                             if (errors) {
                                 if (errors[0] && errors[0].message) {
                                     console.log("error :"+errors[0].message);
                                 }
                             }
                      }
                  });
                 $A.enqueueAction(action);
        }
        else{
            var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
            claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : true });
            claimRoutingServiceCallCompleteEvent.fire();

        }
     },

     createOrsForSOP: function(component, event, helper){
        var acetCaseId = component.get("v.acetCaseId");
        var strRecord = JSON.stringify(component.get("v.caseWrapper"));
        var selectedUnresolvedClaims = component.get("v.selectedUnresolvedClaims");
        console.log('Selected Claims'+ JSON.stringify(selectedUnresolvedClaims));
        var uniqueCmbClaimMap = [] ;
        var threeUniqueCmb = [];
        var uniqueCombinationsForResolved;
        if(!$A.util.isUndefinedOrNull(selectedUnresolvedClaims) && !$A.util.isEmpty(selectedUnresolvedClaims)){
        uniqueCombinationsForResolved = selectedUnresolvedClaims.map(p => {
                                                         return {"policyType" : p.policyType  ,
                                                          "memberId" :p.memberId,
                                                          "groupNo" :p.groupNo,
                                                          }})
                                                        .filter((a, i) => selectedUnresolvedClaims
                                                                .findIndex(b =>
                                                                           b.policyType === a.policyType &&
                                                                           b.memberId === a.memberId
                                                                           && a.groupNo === b.groupNo) === i);


                      	uniqueCombinationsForResolved.forEach( u => {
                        var clmList = selectedUnresolvedClaims.filter( c => c.policyType === u.policyType
                                                                           && c.groupNo === u.groupNo
                                                                           &&  c.memberId === u.memberId
                                                                      );

                               var uniqueKey = u.policyType + '_' + u.groupNo + '_'+ u.memberId;
                               var obj = {};
                               obj.policyType = u.policyType;
                               obj.memberId =  u.memberId;
                               obj.groupNo =  u.groupNo;
                               obj.claims =  clmList;
                               uniqueCmbClaimMap.push(obj);
                       }) ;
                       component.set("v.uniqueCmbClaimMap", uniqueCmbClaimMap);
        }
        var uniqueCmbClaimMap = component.get("v.uniqueCmbClaimMap");
        threeUniqueCmb = uniqueCmbClaimMap
                      .filter(c => c.sendToOrs!= true )
                      .slice(0,3);
        if(!$A.util.isUndefinedOrNull(threeUniqueCmb) && !$A.util.isEmpty(threeUniqueCmb)){
            threeUniqueCmb.forEach( u => {
                u.sendToOrs = true ;
                u.claims.forEach( c => c.sendToOrs = true);
               });
               var action = component.get('c.createORSCaseForClaimsResolved');
               var orsFormatUniqueComp = threeUniqueCmb.map( u=>   { return {
                                                                       "policyType" : u.policyType,
                                                                       "memberId" : u.memberId,
                                                                       "groupNo" : u.groupNo,
                                                                       "claims" : u.claims.map (c => {return {
                                                                                                       "claimId" : c.claimId,
                                                                                                       "ServiceDate" : c.serviceDates,
                                                                                                       "types" : c.typesValue,
                                                                                                       "cashed" : c.cashedValue,
                                                                                                      }}),
                                                              }});

               action.setParams({
                   "strRecord": strRecord,
                   "caseId" : acetCaseId,
                   "resolvedCaseClaims": orsFormatUniqueComp,
                   "allUnresolvedResolvedFlg": false
               });
               action.setCallback(this, function(response) {
                   var state = response.getState();
                   console.log('state@@@' + state);
                   var data ;
                   if (state == "SUCCESS") {
                       data = response.getReturnValue();
                       var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
                        claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
                        claimRoutingServiceCallCompleteEvent.fire();
                   }
                   else if (state === "INCOMPLETE") {
                       console.log("Failed to connect Salesforce!!");
                       var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
                         claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
                         claimRoutingServiceCallCompleteEvent.fire();
                   }
                       else if (state === "ERROR") {
                           var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
                         claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
                         claimRoutingServiceCallCompleteEvent.fire();
                           var errors = response.getError();
                           if (errors) {
                               if (errors[0] && errors[0].message) {
                                   console.log("error :"+errors[0].message);
                               }
                           }
                    }
                });
                $A.enqueueAction(action);


        }
        else{
            var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
                         claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
                         claimRoutingServiceCallCompleteEvent.fire();
        }
    },

    createFacets : function(component, event, helper){
    var action = component.get("c.saveFacetsCase");
    var acetCaseId = component.get("v.acetCaseId");
    var strRecord = JSON.stringify(component.get("v.caseWrapper"));
       action.setParams({
           strRecord : strRecord,
           caseId : acetCaseId
       });
       action.setCallback(this, function(response) {
           var objResponse, strTitle,strMessage;
           var toastEvent = $A.get("e.force:showToast");
           if(response && response.getState() == 'SUCCESS') {
               objResponse = response.getReturnValue();
               strTitle = '';
               if(objResponse) {
                   objResponse = JSON.parse(objResponse);
                   if(objResponse.strResponse) {
                       strMessage = objResponse.strResponse;
                   } else {
                       strMessage = '';
 	}
                   if(objResponse.isSuccess == true ) {
                       strTitle = 'success';
                   } else {
                       strTitle = 'error'
                   }
               }
           } else {
               strTitle = 'error';
               strMessage = 'Facets Case Creation Failed'
           }
           toastEvent.setParams({
               "title": "Info !!",
               "message": strMessage,
               "type": strTitle
           });
           toastEvent.fire();
           var claimRoutingServiceCallCompleteEvent = component.getEvent("ClaimRoutingServiceCallCompleteEvent");
           claimRoutingServiceCallCompleteEvent.setParams({ "orsFailed" : false });
           claimRoutingServiceCallCompleteEvent.fire();
       });
       $A.enqueueAction(action);
    }
     //US3463210 - Sravan - End
})