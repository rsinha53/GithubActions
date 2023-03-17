({
	onLoad : function(cmp, event, helper) {

        //US3463210 - Sravan - Start
        var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        if(viewClaimsSubType == 'Claims Project 20+ Claims'){
            var additionalReqDtlForCalimsProject = {"tatProvided": "5","days":false}
            cmp.set("v.enableTat",false);
            cmp.set("v.showSubmit",true);
            cmp.set("v.enableTatToggle",false);
            cmp.set("v.additionalReqDtl",additionalReqDtlForCalimsProject);

			let isEscalatedValue=cmp.get("v.isEscalatedValue");
        	additionalReqDtlForCalimsProject.isEscalatedValue=isEscalatedValue;
            var caseWrapper = cmp.get("v.caseWrapper");
            additionalReqDtlForCalimsProject.Commentvalue = cmp.get("v.sendToListInputs.comments");
            if(!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper)){
                var SRClaimMap = {};
                var policyType = cmp.get("v.policyName");
                SRClaimMap = caseWrapper.SRClaimMap;
                console.log('SRClaimMap Updated Comments'+ JSON.stringify(SRClaimMap));
                if(!$A.util.isUndefinedOrNull(SRClaimMap) && !$A.util.isEmpty(SRClaimMap)){
                    var hasCS = false;
                    var hasCOPhy = false;
                    var hasCOHsp = false;
                    var hasAp = false;
                    for(var claimKey in SRClaimMap){
                        if(claimKey == 'CS'){
                            hasCS = true;
                        }
                        else if(claimKey == 'CO - Physician'){
                            hasCOPhy = true;
                        }
                        else if(claimKey == 'CO - Hospital'){
                            hasCOHsp = true;
                        }
                        else if(claimKey == 'AP'){
                            hasAp = true;
                        }
                    }
                    for(var key in SRClaimMap){
                        var sourceCodeInfo = SRClaimMap[key];
                        var keyVal = '';
                        if(policyType == 'CO - Physician'){
                            if(hasCS){
                                keyVal = 'CS';
                            }
                            if(key == keyVal){
                                var commentBox = cmp.find("commentsBoxId");
                                if(!$A.util.isUndefinedOrNull(commentBox) && !$A.util.isEmpty(commentBox)){
                                    commentBox.set("v.value",sourceCodeInfo.comment);
                                    additionalReqDtlForCalimsProject.Commentvalue = sourceCodeInfo.comment;
                                }
                            }
                        }
                        if(policyType == 'CO - Hospital'){
                            if(hasCS){
                                keyVal = 'CS';
                            }
                            if(hasCOPhy){
                                keyVal = 'CO - Physician';
                            }
                            if(key == keyVal){
                                var commentBox = cmp.find("commentsBoxId");
                                if(!$A.util.isUndefinedOrNull(commentBox) && !$A.util.isEmpty(commentBox)){
                                    commentBox.set("v.value",sourceCodeInfo.comment);
                                    additionalReqDtlForCalimsProject.Commentvalue = sourceCodeInfo.comment;
                                }
                            }
                        }
                        if(policyType == 'AP'){
                            if(hasCS){
                                keyVal = 'CS';
                            }
                            if(hasCOPhy){
                                keyVal = 'CO - Physician';
                            }
                            if(hasCOHsp){
                                keyVal = 'CO - Hospital';
                            }
                            if(key == keyVal){
                                var commentBox = cmp.find("commentsBoxId");
                                if(!$A.util.isUndefinedOrNull(commentBox) && !$A.util.isEmpty(commentBox)){
                                    commentBox.set("v.value",sourceCodeInfo.comment);
                                    additionalReqDtlForCalimsProject.Commentvalue = sourceCodeInfo.comment;
                                }
                            }
                        }
                    }
                }
            }
            cmp.set('v.additionalReqDtl',additionalReqDtlForCalimsProject);

        }
        else{
        var additionalReqDtl = {"days" : true};
        cmp.set('v.additionalReqDtl',additionalReqDtl);
        cmp.set('v.optionName',"YesORNo"+Math.random());
        cmp.set('v.additionalReqDtl.Commentvalue',cmp.get("v.sendToListInputs.comments"));

        let isEscalatedValue=cmp.get("v.isEscalatedValue");
        additionalReqDtl.isEscalatedValue=isEscalatedValue;
        cmp.set('v.additionalReqDtl',additionalReqDtl);
        }
        //US3463210 - Sravan - End
    },

	onchngValue : function(cmp, event, helper) {
        var ID=event.getSource().getLocalId();
             var auraID=cmp.find(ID);
              if(!$A.util.isEmpty(auraID.get('v.value'))){
                 auraID.setCustomValidity("  ");
                  auraID.setCustomValidity("");
                }
               else
                  auraID.setCustomValidity("This field is required");
               auraID.reportValidity();
               if(ID=="ExpectedPayment"){
               if( auraID.get('v.value') <= 0)
                   cmp.set('v.additionalReqDtl.expPaymentValue','');
               }
    },
    
    checkValue : function(cmp, event, helper) {
        var field=cmp.find("ExpectedPayment");
        var expectedAmount = field.get('v.value');
        if(!$A.util.isEmpty(expectedAmount)){
            var charcount = (expectedAmount.split(".").length - 1);
            if(charcount > 1){
                field.setCustomValidity("Enter a valid value.");
            }else{
                field.setCustomValidity("  ");
                field.setCustomValidity("");
            }
            field.reportValidity();
        }
        
    },
  
	onchngDNK : function(cmp, event, helper) {
        var ExpectedPayment=cmp.find("ExpectedPayment");
        ExpectedPayment.set("v.required", false);
         ExpectedPayment.setCustomValidity("  ");
         ExpectedPayment.reportValidity();
         //ExpectedPayment.set('v.validity', {'valid':false});
           ExpectedPayment.setCustomValidity("");
           ExpectedPayment.reportValidity();
           let additionalReqDtl = cmp.get("v.additionalReqDtl");

    	if(cmp.get("v.checked")){
   			ExpectedPayment.set("v.disabled", true);
        	additionalReqDtl.doesNotKnow=true;
            cmp.set('v.additionalReqDtl',additionalReqDtl);
    	}
    	else{
     		ExpectedPayment.set("v.required", true);
    		ExpectedPayment.set("v.disabled", false);
            additionalReqDtl.doesNotKnow=false;
            cmp.set('v.additionalReqDtl',additionalReqDtl);
        }
	},
     onchangeEscalated: function(cmp, event, helper) {
          var EscalationReason=cmp.find("EscalationReason");
         var PriorExternalIDt=cmp.find("PriorExternalID");

         let isEscalatedValue=cmp.get("v.isEscalatedValue");
         let additionalReqDtl = cmp.get("v.additionalReqDtl");
         additionalReqDtl.isEscalatedValue=isEscalatedValue;
         cmp.set('v.additionalReqDtl',additionalReqDtl);

          if(cmp.get("v.isEscalatedValue")=="Yes"){
          if(cmp.get("v.EsReason")){
              if($A.util.isEmpty(EscalationReason.get('v.value'))){
        EscalationReason.setCustomValidity("This field is required");
        EscalationReason.reportValidity();
              }
          }
          if(cmp.get("v.PriorExternal")){
               if($A.util.isEmpty(PriorExternalIDt.get('v.value')) ){
         PriorExternalIDt.setCustomValidity("This field is required");
         PriorExternalIDt.reportValidity();
         }
          }
          }
    },
     togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    EsReasonValChng : function(cmp, event) {
        cmp.set("v.EsReason",true);
    },
     PriorExValChng : function(cmp, event) {
        cmp.set("v.PriorExternal",true);
    },
    validation : function(cmp, event, helper) {
        var EscalationReason=cmp.find("EscalationReason");
        var PriorExternalIDt=cmp.find("PriorExternalID");
        var showError=cmp.get("v.showError");
        var ids=[cmp.find("ExpectedPayment"),cmp.find("TATProvided"),cmp.find("commentsBoxId")];
        var count=0;
        var ClaimRoutingTabChangeEvent = cmp.getEvent("ClaimRoutingTabChangeEvent");
        if(cmp.get("v.isEscalatedValue")=="Yes"){
        if($A.util.isEmpty(EscalationReason.get('v.value'))){
         if(!showError){
        EscalationReason.setCustomValidity("This field is required");
        EscalationReason.reportValidity();
             }
            ++count;
        cmp.set("v.EsReason",true);
	                    }
        if($A.util.isEmpty(PriorExternalIDt.get('v.value')) ){
        if(!showError){
        PriorExternalIDt.setCustomValidity("This field is required");
        PriorExternalIDt.reportValidity();
        }
          ++count;
          cmp.set("v.PriorExternal",true);
           }}
        for(var id of ids){
        if($A.util.isEmpty(id.get('v.value')) && !id.get("v.disabled")){
        if(!showError){
        id.setCustomValidity("This field is required");
        id.reportValidity();
               }
          ++count;
             }}
         if(count!=0 && showError){
          cmp.set("v.stopChngTab","No");
          return false;
         }
         if(count==0 && event.getParam("Type")!="Submit"){
          ClaimRoutingTabChangeEvent.setParams({"isAdditionaDetCmp" : true});
          ClaimRoutingTabChangeEvent.fire();
            }
         else if( event.getParam("Type")!="Submit"){
           setTimeout(function() {
             cmp.find("AdditionalDet").getElement().scrollIntoView({
             behavior: 'smooth',
             block: 'center',
            inline: 'nearest'
             });
             }, 100);
        }},
		
		 allowOnlyNumbers: function(component, event, helper){
            var dateCode = (event.which) ? event.which : event.keyCode;
             if(dateCode !=46 && dateCode > 31 && (dateCode < 48 || dateCode > 57)){
                if(event.preventDefault){
                    event.preventDefault();
                }else{
                    event.returnValue = false;
                }
            }
        },
    	//US3463210 - Sravan
    onSubmit: function(component, event, helper){
        var sbtBName = component.get("v.sbtBName");
         var claimPolicyList= component.get("v.claimPolicyList");
         var count=0;
         if(sbtBName=="Submit"){
         for(var i=1;i<claimPolicyList.length;i++){
             if(!component.get("v.Tabs").includes(claimPolicyList[i-1].policyType)){
               component.set("v.selTabId",claimPolicyList[i-1].policyType);
               component.set("v.prvselTabId",claimPolicyList[i-1].policyType);
                 count++;
                 break;
             }}
            if(count==0)
             component.set("v.Tabs",component.get("v.Tabs")+"Last");

               }
               //US3463210 - Sravan - Start
             var caseWrapper = component.get("v.caseWrapper");
             var policyName = component.get("v.policyName");
             var SRClaimMap = caseWrapper.SRClaimMap;
             if(!$A.util.isUndefinedOrNull(SRClaimMap) && !$A.util.isEmpty(SRClaimMap)){
                if(SRClaimMap.hasOwnProperty(policyName)){
                    var sourceCodeInfo = SRClaimMap[policyName];
                    if(!$A.util.isUndefined(sourceCodeInfo) && !$A.util.isEmpty(sourceCodeInfo)){
                        var commentBox = component.find("commentsBoxId");
                        if(!$A.util.isUndefinedOrNull(commentBox) && !$A.util.isEmpty(commentBox)){
                            sourceCodeInfo.comment = commentBox.get('v.value');
                        }
                    }
                    SRClaimMap[policyName] = sourceCodeInfo;
                    caseWrapper.SRClaimMap = SRClaimMap;
                }
             }
             console.log('SRClaimMap for comment'+ JSON.stringify(caseWrapper.SRClaimMap));
             component.set("v.caseWrapper",caseWrapper);
             //US3463210 - Sravan - End
         var ClaimRoutingValidationEvent = component.getEvent("ClaimRoutingValidationEvent");
           ClaimRoutingValidationEvent.setParams({"Type" :component.get('v.sbtBName')});
                 ClaimRoutingValidationEvent.fire();

    }


})