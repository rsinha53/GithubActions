({
    getClaimSubType: function(component, event, helper, viewClaims, viewClaimsSubType,codesList) {
        if(viewClaims == 'View Claims' )  {
                    var Issue = helper.getReasonCodes(component, event, helper, codesList, component.get("v.viewClaimsSubType"));
                   if(!$A.util.isEmpty(Issue)){
                        component.set("v.IssueDropDown",Issue);
                       if(viewClaimsSubType!="Benefit Discrepancies" && viewClaimsSubType != "Dispute Allowed Amount" && viewClaimsSubType != 'Claims Project 20+ Claims' && viewClaimsSubType != 'Keying Request' && viewClaimsSubType != 'Stop Pay and Reissue') //US3463210 - Sravan
                       component.set("v.IssueValue",Issue[0].value);
                       else if(viewClaimsSubType =="Benefit Discrepancies" || viewClaimsSubType =="Dispute Allowed Amount"  || viewClaimsSubType =="Keying Request" || viewClaimsSubType =="Stop Pay and Reissue" || viewClaimsSubType == 'Claims Project 20+ Claims')
                       component.find("Issue").set("v.required", true);
                    }
        }
    },
      getReasonCodes: function(cmp, event,helper,reasonCodes,viewClaimSubType) {
        var lstOfCodes = [];
        console.log('hjkjk',reasonCodes)
        console.log('viewClaimSubType'+viewClaimSubType)
        for(var i in reasonCodes) {
            if(viewClaimSubType == reasonCodes[i].Subtype__c){
                lstOfCodes.push({label:reasonCodes[i].Issue__c, value:reasonCodes[i].Issue__c});
                  cmp.set("v.category",reasonCodes[i].Category__c);
                  cmp.set("v.reasonCode",reasonCodes[i].Reason__c);
            }
        }
        lstOfCodes.sort((a, b) => a.label === b.label ? 0 : a.label > b.label || -1);
        return lstOfCodes;
    },
     onlyDigit: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
            return fieldValue.replace(regEx, '');
        }
        return fieldValue;
    },
    cahsedChangefunction: function(cmp, event,helper){
     var claims = cmp.get("v.selectedUnresolvedClaims");
        if(!$A.util.isEmpty(claims) ){
        	var claimWithCashedAndNo = claims.find( a => a.typesValue == "Paper" && a.cashedValue == "No" )
            if(!$A.util.isEmpty(claimWithCashedAndNo))
                cmp.set("v.enableMemberInfoInput", true);
            else
                 cmp.set("v.enableMemberInfoInput", false);
        }
          },
     cleanErrorMsgs: function(cmp, event, helper,ids,claims){
         var index=cmp.get("v.index");
        for(var id of ids){
         if(claims.length>1 && id.length>1 && !id[index].get("v.disabled")){
           id[index].set("v.disabled", true);
           id[index].set("v.required", false);
           id[index].setCustomValidity(" ");
           id[index].setCustomValidity("");
           id[index].reportValidity();
        }
        else if(claims.length==1){
            id.set("v.disabled", true);
        	id.set("v.required", false);
        	id.setCustomValidity(" ");
        	id.setCustomValidity("");
        	id.reportValidity();
            }
       }
     },
     cleanErrorMsg: function(cmp, event, helper,ids,claims){
            for(var id of ids){
             if(claims.length==1 && id.get("v.disabled")){
             id.setCustomValidity(" ");
             id.setCustomValidity("");
             id.reportValidity();
               }
              var index=0;
             if(claims.length>1 && id[index].get("v.disabled")){
             for(var i of claims){
             id[index].setCustomValidity(" ");
             id[index].setCustomValidity("");
             id[index].reportValidity();
             index++;
             }}}
       },
    onchngValue : function(cmp, event, helpe) {
        var demographicInfo = cmp.get("v.demographicInfo");
        demographicInfo.issue = cmp.get("v.IssueValue");
        cmp.set("v.demographicInfo",demographicInfo);
        console.log('demographicInfo@@@@@',JSON.stringify(cmp.get("v.demographicInfo")));
        var id=cmp.find(event.getSource().getLocalId());
       var claims = cmp.get("v.selectedUnresolvedClaims");
      var index=cmp.get("v.index");
      if( claims.length>1 && id.length>1 ){
            id[index].setCustomValidity("");
           id[index].reportValidity();
        }
        else{
        id.setCustomValidity("");
           id.reportValidity();
        }
    },
   commonValidation: function (cmp, event, helper,iDs,ids,warning,count) {
       var ZipCode=cmp.find("ZipCode");
       var FAXid=cmp.find("FAXid");
       var subType=cmp.get("v.viewClaimsSubType");
       var count=count;
       var showError=cmp.get("v.showError");
       var conStartTime=cmp.get("v.conStartTime");
       var conEndTime=cmp.get("v.conEndTime");
	   var Contact =cmp.find("Contact");
       var issue=cmp.find("Issue");
		if($A.util.isEmpty(Contact.get('v.value'))){
			Contact.setCustomValidity("This field is required");
			Contact.reportValidity();
			++count;
		}	   
       var ClaimRoutingTabChangeEvent = cmp.getEvent("ClaimRoutingTabChangeEvent");
        if(conStartTime == 'Select'){
            cmp.find('startTimeId').validation();
            cmp.find('startTimeId').find('comboboxFieldAI').reportValidity();
            ++count;
        }
        if(conEndTime == 'Select'){
            cmp.find('endTimeId').validation();
            cmp.find('endTimeId').find('comboboxFieldAI').reportValidity();
            ++count;
        }
        if(subType=="Stop Pay and Reissue"){
            if($A.util.isEmpty(issue.get('v.value'))){
            if(!showError){
            issue.setCustomValidity("This field is required");
            issue.reportValidity();
            }
            ++count;
          }
        }
          if(cmp.get("v.enableMemberInfoInput")){
          cmp.find("State").validation();
         if(cmp.get('v.demographicInfo.stateValue')=="Select")
            ++count;
          if(!$A.util.isEmpty(ZipCode.get('v.value'))){
          if(ZipCode.get('v.value').length !=5  ){
            if(!showError){
            ZipCode.setCustomValidity("Enter 5 digits");
            ZipCode.reportValidity();
            }
            ++count;
          }}
        for(var id of iDs){
        if($A.util.isEmpty(id.get('v.value'))){
            if(!showError){
            id.setCustomValidity("This field is required");
            id.reportValidity();
            }
            ++count;
          }}}
        for(var i=0;i<ids.length;i++){
        if(ids[i].length>0){
        for(var j = 0; j<ids[i].length; j++) {
        if($A.util.isEmpty(ids[i][j].get('v.value')) && !ids[i][j].get("v.disabled")){
            if(!showError){
          ids[i][j].setCustomValidity("This field is required");
          ids[i][j].reportValidity();
            }
          ++count;
            }
          else if((subType=="Additional Information Received" &&  $A.localizationService.formatDate(ids[0][j].get('v.value'),"yyyy/MM/dd")<$A.localizationService.formatDate(ids[1][j].get('v.value'),"yyyy/MM/dd"))||
                  (subType=="Misquote of Information" && ids[0][j].get('v.value')=="No")|| (!cmp.get("v.isStopapy") && subType=="Stop Pay and Reissue" && (ids[0][j].get('v.value')!="Paper" || ids[2][j].get('v.value') =="Yes")))
            cmp.set("v.warning","other");
            }
            } else{
        if($A.util.isEmpty(ids[i].get('v.value'))  && !ids[i].get("v.disabled")){
            if(!showError){
          ids[i].setCustomValidity("This field is required");
          ids[i].reportValidity();
            }
          ++count;
          }
          else if((subType=="Additional Information Received" && $A.localizationService.formatDate(ids[0].get('v.value'),"yyyy/MM/dd")<$A.localizationService.formatDate(ids[1].get('v.value'),"yyyy/MM/dd")) ||
                  (subType=="Misquote of Information" && ids[0].get('v.value')=="No")||(!cmp.get("v.isStopapy") && subType=="Stop Pay and Reissue" && (ids[0].get('v.value')!="Paper" || ids[2].get('v.value') =="Yes")))
          cmp.set("v.warning","other");
            }}
        if(cmp.get("v.isMethofDelValue")){
        if($A.util.isEmpty(FAXid.get('v.value')) && !FAXid.get("v.disabled")){
            if(!showError){
          FAXid.setCustomValidity("This field is required");
          FAXid.reportValidity();
            }
          ++count;
            } }
     if(count!=0 && showError){
         cmp.set("v.stopChngTab","No");
         return false;
          }
      if(count==0  && event.getParam("Type")!="Submit"){
          ClaimRoutingTabChangeEvent.setParams({"isServiceReqCmp" : true,"warningMessage":warning,"Types":cmp.get("v.warning")});
          ClaimRoutingTabChangeEvent.fire();
          }
      else if( event.getParam("Type")!="Submit"){
           setTimeout(function() {
           cmp.find("ServiceRequest").getElement().scrollIntoView({
            behavior: 'smooth',
            block: 'center',
            inline: 'nearest'
             });
              }, 100);
     }
     },

    getHours: function (cmp) {
        var conStartTime = cmp.get("v.conStartTime");
        var conStartType = cmp.get("v.conStartType");
        var conEndTime = cmp.get("v.conEndTime");
        var conEndType = cmp.get("v.conEndType");
        var conTimeZone = cmp.get("v.conTimeZone");
        var conTimeZone = cmp.get("v.conTimeZone");
        var demographicInfo = cmp.get("v.demographicInfo");
        demographicInfo.hours=conStartTime+' '+conStartType+' TO '+conEndTime+' '+conEndType+' '+conTimeZone;
        cmp.set('v.demographicInfo',demographicInfo);
    },

    //US3463210 - Sravan
    getClaimProjectManagement: function(component, event, helper){
      var getClaimProject = component.get("c.getClaimProjectManagement");
      getClaimProject.setParams({"sourceCode": component.get("v.policyType")});
      getClaimProject.setCallback(this, function(response){
        var state = response.getState();
        if(state == 'SUCCESS'){
          var claimProjectManagement = response.getReturnValue();
           console.log('Claim Project Management'+ claimProjectManagement);
          if(!$A.util.isUndefinedOrNull(claimProjectManagement) && !$A.util.isEmpty(claimProjectManagement)){
            component.set("v.claimProjectManagement",claimProjectManagement);
          }
        }
      });
      $A.enqueueAction(getClaimProject);
    }
})