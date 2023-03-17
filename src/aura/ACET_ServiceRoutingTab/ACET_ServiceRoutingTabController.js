({
	onInit : function(cmp, event, helper) {
        //convert case items from map to list. This would allow it to be parsed in ACET_RoutingController

         var caseWrapper = cmp.get("v.caseWrapper");
         var caseItems = caseWrapper.caseItems;
         if(caseItems != null || caseItems != undefined){
                caseWrapper.caseItems = Object.values(caseItems);
         }else{
                caseWrapper.caseItems = [];
         }
        cmp.set("v.caseWrapper",caseWrapper);
        helper.createTabs(cmp, event, helper);
        var claimPolicyList= cmp.get("v.claimPolicyList");
        if(!$A.util.isEmpty(claimPolicyList)){
            cmp.set("v.selTabId",(claimPolicyList[0].policyType));
            cmp.set("v.contactNo", cmp.get("v.sendToListInputs.phoneNumber"));
            cmp.set("v.conStartTime", cmp.get("v.flowDetails.conStartTime"));
            cmp.set("v.conStartType", cmp.get("v.flowDetails.conStartType"));
            cmp.set("v.conEndTime", cmp.get("v.flowDetails.conEndTime"));
            cmp.set("v.conEndType", cmp.get("v.flowDetails.conEndType"));
            cmp.set("v.conTimeZone", cmp.get("v.flowDetails.conTimeZone"));
            cmp.set("v.prvselTabId",(claimPolicyList[0].policyType));
            }
	},
     stopChngTab: function(cmp, event, helper) {
        if(cmp.get("v.showError") && cmp.get("v.stopChngTab")=="No")
         cmp.set("v.selTabId",cmp.get("v.prvselTabId"));
     },
     tabChangeMan: function(cmp, event, helper) {
        //US3463210 - Sravan - Start
        var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        if(viewClaimsSubType != 'Claims Project 20+ Claims'){


          var validation = cmp.get('c.validation');
          var selTabId=cmp.get("v.selTabId");
    	  var prvselTabId=cmp.get("v.prvselTabId");
    	  var tabsDet=cmp.get("v.claimPolicyList");
    	  cmp.set("v.isShowError",false);
         if(selTabId=='CO - Hospital' && cmp.get("v.count")==1 && tabsDet.length==3){
          cmp.set("v.selTabId","CO - Physician");
          cmp.set("v.vCount",2);
          cmp.set("v.selTabId","CO - Hospital");
         }
          cmp.set("v.stopChngTab","");
		  cmp.set("v.showError",true);
          cmp.set("v.selTabId",prvselTabId);
          cmp.set("v.prvselTabId",selTabId);
		  if(cmp.get("v.Tabs").includes(cmp.get("v.selTabId")))
		  cmp.set("v.selTabId",cmp.get("v.prvselTabId"));
		  else if(prvselTabId==tabsDet[tabsDet.length-1].policyType)
          cmp.set("v.selTabId",cmp.get("v.prvselTabId"));
		  else
          $A.enqueueAction(validation);
      }
        //US3463210 - Sravan - End
     },
     validation : function(cmp, event, helper) {
         var tabid=cmp.find("ClaimServiceRouting");
         var selTabId=cmp.get("v.selTabId");
         var tabsDet=cmp.get("v.claimPolicyList");
         cmp.set("v.isServiceReqCmp",false);
         cmp.set("v.isAdditionaDetCmp",false);
         cmp.set("v.isComboboxCmp",false);
         cmp.set("v.warning","");
         if(!cmp.get("v.showError")){
          if(event.getParam("Type")=="Submit"){
         var SubmitButtonValidation = $A.get("e.c:ACET_SubmitButtonValidation");
               SubmitButtonValidation.setParams({"Type" : "Submit"});
               SubmitButtonValidation.fire();
          }}
         var vCount=cmp.get("v.vCount");
         if(tabid.length>0){
          for(var i=0;i<tabsDet.length && vCount==1;i++){
             if(selTabId==tabsDet[i].policyType )
               tabid[i].validation();
          }
          if(selTabId=='CS'&& vCount==2)
          tabid[0].validation();
          else if(selTabId=='CO - Hospital'&& vCount==2)
          tabid[1].validation();
          else if(selTabId=='CO - Physician'&& vCount==2)
          tabid[2].validation();
         }
         else{
             tabid.validation();
         }
         console.log("ClaimServiceRouting"+cmp.find("ClaimServiceRouting"));
     },
    tabChange : function(cmp, event, helper) {
         var isServiceReqCmp=event.getParam("isServiceReqCmp");
         var isAdditionaDetCmp=event.getParam("isAdditionaDetCmp");
         var isComboboxCmp=event.getParam("isComboboxCmp");
         var claimPolicyList= cmp.get("v.claimPolicyList");
         var selTabId=cmp.get("v.selTabId");
        //US3463210 - Sravan
         var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        if(isServiceReqCmp){
         cmp.set("v.warning",event.getParam("Types"));
         cmp.set("v.warningMessage",event.getParam("warningMessage"));
         cmp.set("v.isServiceReqCmp",isServiceReqCmp);
            }
        else if(isAdditionaDetCmp){
         cmp.set("v.isAdditionaDetCmp",isAdditionaDetCmp);
            }
        else if(isComboboxCmp){
         cmp.set("v.isComboboxCmp",isComboboxCmp);
                }
        if(cmp.get("v.isServiceReqCmp") && cmp.get("v.isAdditionaDetCmp") && cmp.get("v.isComboboxCmp") || cmp.get("v.isServiceReqCmp") && cmp.get("v.isAdditionaDetCmp") && viewClaimsSubType == 'Claims Project 20+ Claims'){
            if(cmp.get("v.showError") && (viewClaimsSubType != 'Claims Project 20+ Claims' && cmp.get("v.isComboboxCmp") != undefined)){
              cmp.set("v.isShowError",false);
              cmp.set("v.prvselTabId",cmp.get("v.selTabId"));
              cmp.set("v.isShowError",true);
                return false;
            }
           if(cmp.get("v.warning")=="other") {
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
           title : 'Warning',
            message:cmp.get("v.warningMessage"),
            duration:'20000',
            key: 'info_alt',
            type: 'warning',
           mode: "dismissible"
        });
        toastEvent.fire();
    }
          $A.util.addClass(cmp.find('disabled'), 'disabled');
             //call ORS case creation
            helper.showSpinner(cmp);
            var tabsDet=cmp.get("v.claimPolicyList");
         	var tabid=cmp.find("ClaimServiceRouting");
            var vCount=cmp.get("v.vCount");
            if(tabid.length>0){
            for(var i=0;i<tabsDet.length && vCount==1;i++){
             if(selTabId==tabsDet[i].policyType )
               tabid[i].createORSCases();
                 }
           if(selTabId=='CS'&& vCount==2)
           tabid[0].createORSCases();
           else if(selTabId=='CO - Hospital'&& vCount==2)
           tabid[1].createORSCases();
           else if(selTabId=='CO - Physician'&& vCount==2)
           tabid[2].createORSCases();
                }
            else{
                tabid.createORSCases();
            }
               //call aura method on ACET_ClaimServiceRouting component to create ORS case.
               //ACET_ClaimServiceRouting can in turn call ACET_SentTo aura method to create the ORS case
            }
         },
    orsServiceCallComplete:  function(cmp, event, helper) {
        console.log("service complete event received");
        //disable spinner
        helper.hideSpinner(cmp);
        var claimPolicyList= cmp.get("v.claimPolicyList");
        var selTabId=cmp.get("v.selTabId");
        var vCount=cmp.get("v.vCount");


        var isModalOpen = event.getParam("orsFailed");

        if((!isModalOpen && cmp.get("v.Tabs").includes("Last") && cmp.get("v.isServiceReqCmp") && cmp.get("v.isAdditionaDetCmp") && cmp.get("v.isComboboxCmp") ) || (!isModalOpen && cmp.get("v.Tabs").includes("Last") && cmp.get("v.isServiceReqCmp") && cmp.get("v.isAdditionaDetCmp") &&  cmp.get("v.viewClaimsSubType") =='Claims Project 20+ Claims' )){
          helper.navigateToCaseDetail(cmp, event, helper);
        }
        for(var i=0;i<claimPolicyList.length-1;i++){
              if(selTabId==claimPolicyList[i].policyType){
                  if(selTabId==claimPolicyList[i].policyType && vCount==1 )
                  $A.util.addClass(cmp.find('disabled')[i], 'disabled');
                  else if(selTabId=='CS'&& vCount==2)
                  $A.util.addClass(cmp.find('disabled')[0], 'disabled');
                  else if(selTabId=='CO - Physician'&& vCount==2)
                  $A.util.addClass(cmp.find('disabled')[2], 'disabled');
                  cmp.set("v.Tabs", cmp.get("v.Tabs")+cmp.get("v.selTabId"));
                  cmp.set("v.selTabId",(claimPolicyList[i+1].policyType));
                  cmp.set("v.prvselTabId",claimPolicyList[i+1].policyType);
                  break;
                }
        }
        //US3463210 - Sravan - Start
        var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        if(viewClaimsSubType != 'Claims Project 20+ Claims'){
        cmp.set("v.isModalOpen",isModalOpen);
        }
        //US3463210 - Sravan - End
        },

    closeModal : function(component, event, helper) {
		component.set("v.isModalOpen", false);
        helper.navigateToCaseDetail(component, event, helper);
     },
   retryORSCase : function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.stopChngTab","secNo");
        helper.showSpinner(component);
        var tabsDet=component.get("v.claimPolicyList");
        var tabid=component.find("ClaimServiceRouting");
        var vCount=component.get("v.vCount");
        var selTabId=component.get("v.selTabId");
        if(tabid.length>0){
           for(var i=0;i<tabsDet.length && vCount==1;i++){
             if(selTabId==tabsDet[i].policyType )
               tabid[i].retryORSCases();
           }
           if(selTabId=='CS'&& vCount==2)
           		tabid[0].retryORSCases();
           else if(selTabId=='CO - Hospital'&& vCount==2)
           		tabid[1].retryORSCases();
           else if(selTabId=='CO - Physician'&& vCount==2)
           		tabid[2].retryORSCases();
         }
         else{
                tabid.retryORSCases();
         }

        //call ors routing method
	}
})