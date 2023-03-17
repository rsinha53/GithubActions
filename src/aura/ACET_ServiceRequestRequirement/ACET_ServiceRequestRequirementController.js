({
	onLoad : function(cmp, event, helper) {
        debugger;
        var viewClaims = cmp.get("v.viewClaims");
        var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        var selectedUnresolvedClaims = cmp.get("v.selectedUnresolvedClaims");
		var isEnableContact =  cmp.get("v.isEnableContact");
		var isRequiredContact = cmp.get("v.isRequiredContact");
        if(viewClaimsSubType=='Keying Request'){
			cmp.set('v.text','Add keying correction details in the comments box below.');
			if(cmp.get("v.policyType").startsWith("CS")){
                cmp.set('v.isFLN',true);
                cmp.set('v.isEngine',true);
            }
            else if(cmp.get("v.policyType").startsWith("CO"))
                cmp.set('v.isFLN',true);											 
		}else if(viewClaimsSubType=='Paid Correctly, Pre-Appeal Reconsideration'){
			cmp.set('v.text','I attest that based on my research of the claim(s) and information available, I have determined that the claim(s) paid correctly.  I explained the processing to the provider, however they requested that the claim(s) be sent back as reconsideration to satisfy the need to have a reconsideration on file prior to filing an appeal.');
		}
			
		
		if(viewClaimsSubType == 'Escalated Appeal'){
			cmp.set('v.isEnableContact',true);
			cmp.set('v.isRequiredContact',false);
		}
		else{
			cmp.set('v.isEnableContact',false);
			cmp.set('v.isRequiredContact',true); 
		}
        //US3463210 - Sravan - Start
        if(viewClaimsSubType == 'Claims Project 20+ Claims'){
            cmp.set("v.showEmail",true);
            cmp.set("v.showDos",true);
            cmp.set("v.adjustPadding",'slds-col slds-size_1-of-12 ');
            cmp.set("v.showCpmSopHypeLink",true);
            cmp.set("v.text",'Additional claims may be requested for diagnosis of issue.');
            helper.getClaimProjectManagement(cmp,event,helper);
            var caseWrapper = cmp.get("v.caseWrapper");
            if(!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper)){
                var SRClaimMap = {};
                var policyType = cmp.get("v.policyType");
                var hasCS = false;
                var hasCOPhy = false;
                var hasCOHsp = false;
                var hasAp = false;
                SRClaimMap = caseWrapper.SRClaimMap;
                if(!$A.util.isUndefinedOrNull(SRClaimMap) && !$A.util.isEmpty(SRClaimMap)){
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
                                var email = cmp.find("Email");
                                if(!$A.util.isUndefinedOrNull(email) && !$A.util.isEmpty(email)){
                                    email.set("v.value",sourceCodeInfo.email);
                                    cmp.set("v.enableEmail",false);
                                }
                                var begninningDos = cmp.find("beginningDos");
                                if(!$A.util.isUndefinedOrNull(begninningDos) && !$A.util.isEmpty(begninningDos)){
                                    begninningDos.set("v.value",sourceCodeInfo.BeginDOS);
                                    cmp.set("v.enableBeginningDos",false);
                                }
                                var endingDos = cmp.find("endingDos");
                                if(!$A.util.isUndefinedOrNull(endingDos) && !$A.util.isEmpty(endingDos)){
                                    endingDos.set("v.value",sourceCodeInfo.EndDOS);
                                    cmp.set("v.enableEndingDos",false);
                                }
                                var issue = cmp.find("Issue");
                                if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                                    issue.set("v.value",sourceCodeInfo.Issue);
                                    cmp.set("v.IssueValue",sourceCodeInfo.Issue);
                                    cmp.set("v.enableIssue",false);
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
                                var email = cmp.find("Email");
                                if(!$A.util.isUndefinedOrNull(email) && !$A.util.isEmpty(email)){
                                    email.set("v.value",sourceCodeInfo.email);
                                    cmp.set("v.enableEmail",false);
                                }
                                var begninningDos = cmp.find("beginningDos");
                                if(!$A.util.isUndefinedOrNull(begninningDos) && !$A.util.isEmpty(begninningDos)){
                                    begninningDos.set("v.value",sourceCodeInfo.BeginDOS);
                                    cmp.set("v.enableBeginningDos",false);
                                }
                                var endingDos = cmp.find("endingDos");
                                if(!$A.util.isUndefinedOrNull(endingDos) && !$A.util.isEmpty(endingDos)){
                                    endingDos.set("v.value",sourceCodeInfo.EndDOS);
                                    cmp.set("v.enableEndingDos",false);
                                }
                                var issue = cmp.find("Issue");
                                if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                                    issue.set("v.value",sourceCodeInfo.Issue);
                                    cmp.set("v.IssueValue",sourceCodeInfo.Issue);
                                    cmp.set("v.enableIssue",false);
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
                                var email = cmp.find("Email");
                                if(!$A.util.isUndefinedOrNull(email) && !$A.util.isEmpty(email)){
                                    email.set("v.value",sourceCodeInfo.email);
                                    cmp.set("v.enableEmail",false);
                                }
                                var begninningDos = cmp.find("beginningDos");
                                if(!$A.util.isUndefinedOrNull(begninningDos) && !$A.util.isEmpty(begninningDos)){
                                    begninningDos.set("v.value",sourceCodeInfo.BeginDOS);
                                    cmp.set("v.enableBeginningDos",false);
                                }
                                var endingDos = cmp.find("endingDos");
                                if(!$A.util.isUndefinedOrNull(endingDos) && !$A.util.isEmpty(endingDos)){
                                    endingDos.set("v.value",sourceCodeInfo.EndDOS);
                                    cmp.set("v.enableEndingDos",false);
                                }
                                var issue = cmp.find("Issue");
                                if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                                    issue.set("v.value",sourceCodeInfo.Issue);
                                    cmp.set("v.IssueValue",sourceCodeInfo.Issue);
                                    cmp.set("v.enableIssue",false);
                                }
                            }
                        }
                    }
                }
            }
        }
        else{
            cmp.set("v.showEmail",false);
            cmp.set("v.showDos",false);
            cmp.set("v.adjustPadding",'slds-col slds-size_2-of-12 slds-p-left_small slds-p-right_small');
            cmp.set("v.showCpmSopHypeLink",false);
            cmp.set("v.text",'Additional claims may be requested for diagnosis of issue.');
        }
        if(viewClaimsSubType == 'Keying Request' || viewClaimsSubType == 'Benefit Discrepancies' || viewClaimsSubType == 'Claims Project 20+ Claims'){
            cmp.set("v.showClaimTable",true);
        }
        else{
            cmp.set("v.showClaimTable",false);
        }
        //US3463210 - Sravan - End
        if( !$A.util.isEmpty(selectedUnresolvedClaims)){
            selectedUnresolvedClaims.forEach(clm => {
                clm.disCheckField= true;
                clm.disOverField= true;
                clm.disDateLField= true;
                clm.disableReasonReview= true;
                clm.disFLNValue=true;
                clm.disAIRFLNField=true;
                clm.disAIRFLNDateLField=true;
                clm.disAIRLUDateLField=true;
                clm.disAIRPDDateLField=true;
                clm.disProviderStatus=true;
                clm.disBenefitLevel=true;
                clm.disExpectedAllowed=true;
                clm.disableTypes=true;
                clm.disableAmount=true;
                if(!$A.util.isEmpty(clm.tflDateValue))
                  clm.tflDate=$A.localizationService.formatDate(clm.tflDateValue,"MM/dd/yyyy");
                if(clm.paymentNo != '' && viewClaimsSubType!="Dispute Allowed Amount"){
                	clm.paymentNoInput = clm.paymentNo;
            	}

                if( clm.types == "Paper" ){
                 	clm.disableCashed = false;
                	clm.typesValue = clm.types;
           		 }
                 else{
                    clm.disableCashed = true;
                 }
            })
        }
        var claims = cmp.get("v.selectedUnresolvedClaims");
         if(!$A.util.isEmpty(claims) ){
             claims.forEach( clm => {
                 var chargedamt = clm.charged.split(".");
                 var charged = chargedamt[0].replace(/[^\w\s]/gi, '');
                 if(charged < 7000){
                 clm.underAmmount = 'Yes';
                 clm.disablePCM = false;
             }else{
                            clm.underAmmount = 'No';
                            clm.disablePCM = true;
                            }
                            clm.disableSource = true;
                            clm.disableEID = true;
                            clm.disableFLN = true;
                            clm.disableMIS = true;
                            clm.requiredFLN = false;
                            clm.requiredEID = false;
                            } );
         }
        cmp.set("v.selectedUnresolvedClaims",claims);
        var claimNumber = '';
                if(!$A.util.isEmpty(claims) ){
                claims.forEach( clm => {
                if($A.util.isEmpty(claimNumber))
                claimNumber = clm.claimId;

            });
            }
        var mapClaimSummaryDetails = cmp.get("v.mapClaimSummaryDetails");
        console.log('mapClaimSummaryDetails-->'+JSON.stringify(mapClaimSummaryDetails));
        let selectedClaimDetailCard = mapClaimSummaryDetails.find(v => v.componentName.includes(claimNumber));
        console.log('map let-->'+JSON.stringify(mapClaimSummaryDetails));
        var providerId = '';
        var providerTaxId = '';

		if(!$A.util.isUndefinedOrNull(selectedClaimDetailCard)){
        for (var key in selectedClaimDetailCard.cardData) {
					if(selectedClaimDetailCard.cardData[key].fieldName == 'Adjudicated Provider ID'){
						 if(!$A.util.isEmpty(selectedClaimDetailCard.cardData[key].fieldValue)){
						     providerId = selectedClaimDetailCard.cardData[key].fieldValue;
						 }
					}
					if(selectedClaimDetailCard.cardData[key].fieldName == 'AdjTaxID'){
						providerTaxId = selectedClaimDetailCard.cardData[key].fieldValue;
					}
					if($A.util.isEmpty(providerId) && selectedClaimDetailCard.cardData[key].fieldName == 'adjservicingMpin'){
						if(!$A.util.isEmpty(selectedClaimDetailCard.cardData[key].fieldValue))
                			providerId = selectedClaimDetailCard.cardData[key].fieldValue;
					}
                }
                var action = cmp.get("c.getTPSMValues");
      action.setParams({"providerId": providerId,
                "adTaxId":providerTaxId});
      action.setCallback(this, function(response){
        var state = response.getState();
        if(state == 'SUCCESS'){
          var claimProjectManagement = response.getReturnValue();
           console.log('Claim Project Management'+ claimProjectManagement);
          if(!$A.util.isUndefinedOrNull(claimProjectManagement) && !$A.util.isEmpty(claimProjectManagement)){
            cmp.set("v.TPMSLevel",claimProjectManagement);
          }else{
          	cmp.set("v.TPMSLevel","0");
          }
        }
      });
        }


        var codesList = cmp.get("v.reasonCodesList");
         helper.getClaimSubType(cmp, event, helper, viewClaims, viewClaimsSubType, codesList);
         var phoneNumber=cmp.get("v.sendToListInputs.phoneNumber");
         var issue=cmp.get("v.IssueValue");
         var demographicInfo = {};
         demographicInfo.phone = phoneNumber;
         demographicInfo.issue = issue;
         demographicInfo.stateValue="Select";
         cmp.set('v.demographicInfo',demographicInfo);
         helper.getHours(cmp);
         if(!$A.util.isUndefinedOrNull(selectedClaimDetailCard))
            $A.enqueueAction(action);
     },
     togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
     getIndex : function(cmp, event) {
         var currentTarget = event.currentTarget;
         var index = currentTarget.dataset.index;
         cmp.set("v.index",index);
    },
	
	onChangeContact:function(cmp, event, helper){
		var conField = cmp.find("Contact");
		var contact = cmp.find("Contact").get("v.value");
		var removeSpace = contact.replaceAll(' ','');
		var removeDash = removeSpace.replaceAll('-','');
		var index = removeDash.indexOf('Ext');
		if(index >= 0){
			var finalContact = removeDash.substring(0,index);
			let charCount = finalContact.length;
			if(charCount != 10){
				conField.setCustomValidity("Enter 10 Digits");
			}else{
				conField.setCustomValidity("");
			}
		} else  {
			if(removeDash.length == 0){
				conField.setCustomValidity("This field is required");
			}else if(removeDash.length != 10){
				conField.setCustomValidity("Enter 10 Digits");
			}else{
				conField.setCustomValidity("");
			}
		}
	},

	onLeaveContact:function(cmp, event, helper){
		var phoneNumber=cmp.find("Contact").get("v.value");
		cmp.set("v.demographicInfo.phone",phoneNumber);
		cmp.set("v.sendToListInputs.phoneNumber",phoneNumber);
	},

    onchngIssue :function(cmp, event, helper){//Provider Status INN/OON Dispute,
        if(cmp.get("v.viewClaimsSubType")=="Dispute Allowed Amount"){
        var claims = cmp.get("v.selectedUnresolvedClaims");
        var ids = [cmp.find("PROVIDERSTATUS"),cmp.find("BENEFITLEVEL"),cmp.find("EXPECTEDALLOWED")];
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(cmp.get("v.IssueValue")=="Allowed Amount Dispute"){
                clm.providerStatus='';
                clm.benfitLevel='';
                clm.disProviderStatus=true;
                clm.disBenefitLevel=true;
                clm.disExpectedAllowed=false;
            }else{
                clm.expectedAllowed='';
                clm.disProviderStatus=false;
                clm.disBenefitLevel=false;
                clm.disExpectedAllowed=true;
                if(!$A.util.isEmpty(clm.status))
                clm.providerStatus=clm.status;
               if(!$A.util.isEmpty(clm.benefitLevel))
                clm.benfitLevel= clm.benefitLevel;
            }
                            } );
                cmp.set("v.selectedUnresolvedClaims",claims);
                }
                helper.cleanErrorMsg(cmp, event, helper,ids,claims);
                }
        //US3463210 - Sravan - Start
        if(cmp.get("v.viewClaimsSubType") == 'Claims Project 20+ Claims'){
            var issue = cmp.find("Issue");
            if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                 if(issue.get("v.value") == 'All other issues'){
                    issue.setCustomValidity("All other issues is out of scope, please review your SOP.");
                    issue.reportValidity();
                    cmp.set("v.disableSubmit",true);
                    return;
                 }
                 else{
                    issue.setCustomValidity(" ");
                    issue.reportValidity();
                    cmp.set("v.disableSubmit",false);
                    helper.onchngValue(cmp, event, helper);
                 }
            }
        }
            if(cmp.get("v.viewClaimsSubType") == 'Stop Pay and Reissue'){
                var issue = cmp.find("Issue");
                var claims = cmp.get("v.selectedUnresolvedClaims");

        		var ids = [cmp.find("TYPES"),cmp.find("CASHED"),cmp.find("CHECKAMOUNT"),cmp.find("CHECKDATE"),cmp.find("CASHEDDATE")];

                if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                     if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(cmp.get("v.IssueValue")=='TRACR Request'){
                clm.typesValue='';
                clm.cashedValue='';
                clm.disableTypes=true;
                clm.disableCashed=true;
                clm.disableAmount=false;
                cmp.set("v.enableMemberInfoInput", false);
            }else{
                clm.checkAmount='';
                clm.CheckDate='';
                clm.ChashDate='';
                clm.disableAmount=true;
                clm.disableTypes=false;


            }
                            } );
                cmp.set("v.selectedUnresolvedClaims",claims);
                }


            }

             helper.cleanErrorMsg(cmp, event, helper,ids,claims);
            }
        //US3463210 - Sravan - End
                helper.onchngValue(cmp, event, helper);
    },
    onchngAIRReason: function(cmp, event, helper){
        var claims = cmp.get("v.selectedUnresolvedClaims");
        var ids = [cmp.find("FLN#"),cmp.find("RECEIVEDDATEOFFLN"),cmp.find("LASTUPDATEDDATE"),cmp.find("PROCESSEDDATE")];
        helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(clm.AIRreason == "COB Update"){
                clm.AIRFLNDateValue='';
                clm.AIRFLNValue='';
                clm.disAIRFLNField=true;
                clm.disAIRFLNDateLField=true;
                clm.disAIRLUDateLField=false;
                if(!$A.util.isEmpty(clm.lastUpdateDateValue))
                clm.AIRLUDateValue=clm.lastUpdateDateValue;
                clm.disAIRPDDateLField=false;
                clm.AIRPDNDateValue=clm.processedDate;
            }else if(!$A.util.isEmpty(clm.AIRreason) && clm.AIRreason != "COB Update" ){
                clm.AIRLUDateValue='';
                clm.AIRPDNDateValue='';
                clm.disAIRFLNField=false;
                clm.disAIRFLNDateLField=false;
                clm.disAIRLUDateLField=true;
                clm.disAIRPDDateLField=true;
            }
                            } );
             cmp.set("v.selectedUnresolvedClaims",claims);
        }
        helper.onchngValue(cmp, event, helper);
     },
     onchngReason: function(cmp, event, helper){
        var claims = cmp.get("v.selectedUnresolvedClaims");
        var ids = [cmp.find("CHECK#"),cmp.find("DATECHECKSENT"),cmp.find("OVERPAYMENTREASONGIVEN"),cmp.find("REASONFORREVIEWBEINGREQUESTED")];
        helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(clm.RODreason == "Disputing Overpayment/Bulk Recovery"){
                clm.DateValue='';
                clm.CheckValue='';
                clm.disOverField= false;
                clm.disableReasonReview=false;
                clm.disCheckField= true;
                clm.disDateLField= true;
            }else if(clm.RODreason == "Submitted Check for Overpayment"){
                clm.ReasonValue='';
                clm.overPayValue='';
                clm.disOverField= true;
                clm.disableReasonReview= true;
                clm.disCheckField= false;
                clm.disDateLField= false;
            }
                           } );
             cmp.set("v.selectedUnresolvedClaims",claims);
        }
        helper.onchngValue(cmp, event, helper);
               },
    handleTypesChange : function(cmp, event, helper){
       debugger;
        var claims = cmp.get("v.selectedUnresolvedClaims");
         var ids = [cmp.find("CASHED")];
           helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                					if(clm.typesValue == "Paper")
                						 clm.disableCashed = false;
               						 else{
               						    clm.cashedValue='';
                						clm.disableCashed = true;
           								 }
                					} );
            cmp.set("v.selectedUnresolvedClaims",claims);
            helper.cahsedChangefunction(cmp, event, helper);
        }
        helper.onchngValue(cmp, event, helper);
    },
    handlePCMChange : function(cmp, event, helper){
        var claims = cmp.get("v.selectedUnresolvedClaims");
        var ids = [cmp.find("SOURCE"),cmp.find("FLN"),cmp.find("EXTERNALID"),cmp.find("MISQUOTEDINFORMATION")];
        helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(clm.PCMValue == "Yes"){
                clm.disableSource = false;
                clm.PCMRequied = true;
                clm.disableMIS = false;
            }else{
                clm.disableSource = true;
                clm.PCMRequied = false;
                clm.disableFLN = true;
                clm.disableEID = true;
                clm.disableMIS = true;
                clm.requiredEID = false;
                clm.requiredFLN = false;
                clm.sourceValue ='';
                 clm.FLNNumber ='';
                 clm.externalID ='';
                 clm.MISInfo ='';
            }
                           } );
            cmp.set("v.selectedUnresolvedClaims",claims);
        }
         helper.onchngValue(cmp, event, helper);
    },
    handleSourceChange : function(cmp, event, helper){
        var ids = [cmp.find("FLN"),cmp.find("EXTERNALID")];
        var claims = cmp.get("v.selectedUnresolvedClaims");
           helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
            claims.forEach( clm => {
                if(clm.sourceValue == "Call"){
               clm.disableEID = false;
                clm.requiredEID = true;
                clm.disableFLN = true;
                clm.requiredFLN = false;
                clm.FLNNumber ='';
            }else if(clm.sourceValue == "Link"){
                clm.disableFLN = false;
                clm.requiredFLN = true;
                clm.disableEID = true;
                clm.requiredEID = false;
                clm.externalID ='';
            }
                           } );
            cmp.set("v.selectedUnresolvedClaims",claims);
        }
           helper.onchngValue(cmp, event, helper);
    },
  methofDelChange: function(cmp, event, helper) {
      var selectRadio = event.getParam('value');
      var demographicInfo=cmp.get("v.demographicInfo");
      demographicInfo.methofDelValue=selectRadio;
      cmp.set("v.demographicInfo",demographicInfo);
      cmp.set("v.isMethofDelValue",true);
       var faxid=cmp.find("FAXid");
       faxid.set("v.required", false);
       faxid.setCustomValidity("  ");
       faxid.setCustomValidity("");
       faxid.reportValidity();
        if(selectRadio == 'Faxed'){
            cmp.set("v.enableMemberInfoInput",false);
            faxid.set("v.required", true);
            faxid.set("v.disabled", false);
        }else if(selectRadio == 'Mailed'){
            cmp.set("v.enableMemberInfoInput",true);
            faxid.set("v.disabled", true);
            cmp.set("v.demographicInfo.fax",'');
        }
     helper.onchngValue(cmp, event, helper);
    },

    handleCashedChange: function(cmp, event, helper){
        debugger;
       helper.cahsedChangefunction(cmp, event, helper);
         helper.onchngValue(cmp, event, helper);
    },
 onchngValue : function(cmp, event, helper) {
      helper.onchngValue(cmp, event, helper);
	},
    allowOnlyNumbers: function(component, event, helper){
        var dateCode = (event.which) ? event.which : event.keyCode;
        if( dateCode > 31 && (dateCode < 48 || dateCode > 57)){
            if(event.preventDefault){
                event.preventDefault();
            }else{
                event.returnValue = false;
            }
        }
    },
        allowOnlyDecimalNumbers: function(component, event, helper){
        var dateCode = (event.which) ? event.which : event.keyCode;
             if(dateCode !=46 && dateCode > 31 && (dateCode < 48 || dateCode > 57)){
                if(event.preventDefault){
                    event.preventDefault();
                }else{
                    event.returnValue = false;
                }
            }
    },
     handleUHCErrorChange: function(cmp, event,helper) {
        var claims = cmp.get("v.selectedUnresolvedClaims");
        var fln=cmp.find("FLN#");
        var index=cmp.get("v.index");
        var ids = [fln];
        helper.cleanErrorMsgs(cmp, event, helper,ids,claims);
        if(!$A.util.isEmpty(claims) ){
                claims.forEach( clm => {
                if(clm.uhcErrorValue == "Yes"){
                clm.FLNValue='';
                clm.disFLNValue=true;
            }else if(clm.uhcErrorValue == "No")
                clm.disFLNValue=false;
                           } );
               cmp.set("v.selectedUnresolvedClaims",claims);
        }
        helper.onchngValue(cmp, event, helper);
     },
    zipValidation: function (cmp, event, helper) {
           var ZipCode=cmp.find("ZipCode");
           ZipCode.set("v.required", false);
           ZipCode.setCustomValidity("     ");
           ZipCode.setCustomValidity("");
           ZipCode.reportValidity();
           ZipCode.set("v.required", true);
    },
   validation : function(cmp, event, helper) {
       var strRecord = cmp.get("v.caseWrapper");
       if(!$A.util.isEmpty(strRecord))
       strRecord.issueId=cmp.get("v.IssueValue") ;
       //US3463210 - Sravan - Start
       var SRClaimMap = strRecord.SRClaimMap;
       var SRClaimMapUpdated = {};
       if(!$A.util.isUndefinedOrNull(SRClaimMap) && !$A.util.isEmpty(SRClaimMap)){
           for(var key in SRClaimMap){
                var email = cmp.find("Email");
                var beginningDos = cmp.find("beginningDos");
                var endingDos = cmp.find("endingDos");
                var issue = cmp.find("Issue");
                if(!$A.util.isUndefinedOrNull(email) && !$A.util.isEmpty(email)){
                    SRClaimMap[key].email = email.get('v.value');
                }
                if(!$A.util.isUndefinedOrNull(beginningDos) && !$A.util.isEmpty(beginningDos)){
                    SRClaimMap[key].BeginDOS = beginningDos.get('v.value');
                }
                if(!$A.util.isUndefinedOrNull(endingDos) && !$A.util.isEmpty(endingDos)){
                    SRClaimMap[key].EndDOS = endingDos.get('v.value');
                }
                if(!$A.util.isUndefinedOrNull(issue) && !$A.util.isEmpty(issue)){
                    SRClaimMap[key].Issue = issue.get('v.value');
                }
                SRClaimMapUpdated[key] = SRClaimMap[key];
            }
            if(!$A.util.isUndefinedOrNull(SRClaimMapUpdated) && !$A.util.isEmpty(SRClaimMapUpdated)){
                strRecord.SRClaimMap = SRClaimMapUpdated;
            }
       }
       console.log('Updated SRClaimMap'+ JSON.stringify(strRecord.SRClaimMap));
       //US3463210 - Sravan - End
       cmp.set("v.caseWrapper",strRecord);
       var subType=cmp.get("v.viewClaimsSubType");
       cmp.set("v.warning","");
       var selectedissue = cmp.find("Issue");
       if(subType=="Stop Pay and Reissue"){
           var ids=[];
            cmp.set("v.isStopapy",false);
           if(selectedissue.get("v.value") != 'TRACR Request'){
           ids = [cmp.find("TYPES"),cmp.find("PAYMENTNUMBER"),cmp.find("CASHED")];
           }else{
             cmp.set("v.isStopapy",true);
           	ids = [cmp.find("CHECKAMOUNT"),cmp.find("PAYMENTNUMBER"),cmp.find("CHECKDATE")];
           }
          var iDs = [cmp.find("ZipCode"),cmp.find("city"),cmp.find("Address"),cmp.find("lstName"),cmp.find("fstName")];
           helper.commonValidation(cmp, event,helper,iDs,ids,'Any claim(s) identified as not meeting the criteria for Stop Pay and Reissue will not be routed and instead be updated to resolved.',0);
       }
       else if(subType=="Authorization Discrepancy"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("MATCHINGSRN")],'',0);
       }else if(subType=="Referral Discrepancy"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("MATCHINGREFERRAL")],'',0);
       }
       else if(subType=="Eligibility Issue"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("EReason")],'',0);
       }
       else if(subType=="Corrected Claim"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("ORIGINALFLN"),cmp.find("CORRECTEDFLN")],'',0);
       }
       else if(subType=="Benefit Discrepancies"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("Issue")],'',0);
       }
       else if(subType=="Pend Status"){
           helper.commonValidation(cmp, event,helper,'','','',0);
       }
       else if(subType=="Misquote of Information"){
               var selectedUnresolvedClaims = cmp.get("v.selectedUnresolvedClaims");
               var ids = [cmp.find("PAECRITERIAMET"),cmp.find("SOURCE"),cmp.find("FLN"),cmp.find("EXTERNALID"),cmp.find("MISQUOTEDINFORMATION")];
               if( !$A.util.isEmpty(selectedUnresolvedClaims)){
               selectedUnresolvedClaims.forEach(clm => {
               if(clm.underAmmount == "No" ){
                   cmp.set("v.warning","other");
                   }  })  }
               helper.commonValidation(cmp, event,helper,'',ids,'Any claim(s) identified as not meeting PAE criteria or the charged amount is over $7,000 will not be routed and instead be updated to resolved.',0);
               }
       else if(subType=="Clerical Request"){
           var iDs = [cmp.find("ZipCode"),cmp.find("city"),cmp.find("Address"),cmp.find("lstName"),cmp.find("fstName")];
           helper.commonValidation(cmp, event,helper,iDs,[cmp.find("METHODOFDELIVERY"),cmp.find("Reason")],'',0);
               }
       else if(subType=="Timely Filing Discrepancy"){
           helper.commonValidation(cmp, event,helper,'',[cmp.find("TFLDATE"),cmp.find("UHCERROR"),cmp.find("FLN#")],'',0);
                   }
       else if(subType=="Recovery, Overpayment Dispute"){
           var ids = [cmp.find("RODReason"),cmp.find("CHECK#"),cmp.find("DATECHECKSENT"),cmp.find("OVERPAYMENTREASONGIVEN"),cmp.find("REASONFORREVIEWBEINGREQUESTED")];
           helper.commonValidation(cmp, event,helper,'',ids,'',0);
               }
       else if(subType=="Additional Information Received"){
           var ids = [cmp.find("LASTUPDATEDDATE"),cmp.find("PROCESSEDDATE"),cmp.find("AIRReason"),cmp.find("RECEIVEDDATEOFFLN"),cmp.find("FLN#")];
           helper.commonValidation(cmp, event,helper,'',ids,'COB Last Update Date is before the claim Processed Date, advise that COB Update is required.  This will not be routed and instead be updated to resolved.',0);
               }
       else if(subType=="Paid Correctly, Pre-Appeal Reconsideration"){
           var count=0;
           var attestId=cmp.find("attestId");
           if(!attestId.get('v.checked')) {
           attestId.setCustomValidity("This field is required");
           attestId.reportValidity();
           ++count;
               }
           if(count==0)
           helper.commonValidation(cmp, event,helper,'','','',count);
           else
           helper.commonValidation(cmp, event,helper,'','','',count);
               }
      else if(subType=="Keying Request"){
           helper.commonValidation(cmp, event,helper,'','','',0);
               }
       else if(subType=="Medical/Reimbursement Policy"){
               helper.commonValidation(cmp, event,helper,'',[cmp.find("PReason")],'',0);
               }
       else if(subType=="Dispute Allowed Amount"){
                   helper.commonValidation(cmp, event,helper,'',[cmp.find("BENEFITLEVEL"),cmp.find("PROVIDERSTATUS"),cmp.find("EXPECTEDALLOWED"),cmp.find("Issue")],'',0);
               }
        //US3463210 - Sravan - Start
        else if(subType == 'Claims Project 20+ Claims'){
            var claimsProjectRequiredIds = [cmp.find("Email"),cmp.find("beginningDos"),cmp.find("endingDos"),cmp.find("Issue")];
            helper.commonValidation(cmp, event,helper,'',claimsProjectRequiredIds,'',0);
        }

        //US3463210 - Sravan - End
                helper.getHours(cmp);
   },

   onChangeOfValue : function(cmp, event, helper) {
    var ID=event.getSource().getLocalId();
         var auraID=cmp.find(ID);
          if(!$A.util.isEmpty(auraID.get('v.value'))){
             auraID.setCustomValidity("  ");
              auraID.setCustomValidity("");
            }
           else{
              auraID.setCustomValidity("This field is required");
              auraID.reportValidity();
           }

    }

})