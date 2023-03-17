({
	createTabs : function(cmp, event, helper) {
        console.log("original policy wrapper in tabs component "+ JSON.stringify(cmp.get("v.caseWrapper")));

        console.log("subtab in tabs component "+ JSON.stringify(cmp.get("v.viewClaimsSubType")));
        var caseWrapper = cmp.get("v.caseWrapper") ;
        var claimDetails=caseWrapper.claimDetails;
        var claimEngineCode=caseWrapper.claimEngineCode;
        var savedAutoDoc = JSON.parse(caseWrapper.savedAutodoc);
        var arraySize = savedAutoDoc.length;
        var engineCode = '--'
        var index = 0;
        var policies = [];
        var indexes = [];
        //map of policy type with claims
        for( var i=0; i< arraySize ; i++){
            if( savedAutoDoc[i].componentName === "Policies" ){
                indexes.push(i);
            }
        }

        for (var j =0; j < indexes.length; j++){
                var startIndex = indexes[j];
                var endIndex;
                if(j!= indexes.length-1){
                   endIndex = indexes[j+1]-1;
                }
                else{
                    endIndex = arraySize -1
                }

                 var policyTable  = savedAutoDoc[startIndex];
            	 console.log("policy table "+ JSON.stringify(policyTable));
                 var sourceObj = policyTable.selectedRows[0].rowColumnData.find(obj  => obj.fieldLabel === "SOURCE");
                 var groupObj = policyTable.selectedRows[0].rowColumnData.find(obj  => obj.fieldLabel === "Group #");

                 if(!$A.util.isEmpty(sourceObj) ){

                    var policyClmObj = {};
                    policyClmObj.policyType = sourceObj.fieldValue ;
                    policyClmObj.groupNo = groupObj.fieldValue ;
                    policyClmObj.coverageLevel =policyTable.selectedRows[0].rowColumnData.find(obj  => obj.fieldLabel.includes( "COVERAGE LEVEL")).fieldValue ;
                    policyClmObj.eligibilityDates =  policyTable.selectedRows[0].rowColumnData.find(obj  => obj.fieldLabel.includes( "DATES")).fieldValue ;
                     for(var k = startIndex ; k <= endIndex ; k++ ){
                        if( savedAutoDoc[k].componentName == "Member Details"   )
                        {
                             var memberIdCard =  savedAutoDoc[k].cardData.find( obj => obj.fieldName === "Member ID");
                             policyClmObj.memberId = memberIdCard.fieldValue;
                             break;
                        }
                     }

                     if(!$A.util.isEmpty(claimEngineCode) ){
                         for (var ce in claimEngineCode) {
                            // if(claimEngineCode[ce].groupNumber==groupObj.fieldValue)
                            if(claimEngineCode[ce].groupNumber.includes(groupObj.fieldValue))
                             {
                                 if(!$A.util.isEmpty(claimEngineCode[ce].claimEngineCode)){
                                     engineCode=claimEngineCode[ce].claimEngineCode;
                                 }
                                 break;
                             }
                         }
                     }

                    for(var k = startIndex ; k <= endIndex ; k++ ){
                        if( savedAutoDoc[k].componentName == "Claim Results" && !$A.util.isEmpty(savedAutoDoc[k].selectedRows) && savedAutoDoc[k].selectedRows.length >0  )
                        {
                            var claimsTable = savedAutoDoc[k].selectedRows.filter(clm => clm.resolved == false) ;
                            debugger;
                            var claims = claimsTable.map(clm =>
                                                         {
                                                             var serviceDatesRow = clm.rowColumnData.find(obj  => obj.fieldLabel === "SERVICE DATES");
                                                             var claimStatus = clm.rowColumnData.find(obj  => obj.fieldLabel === "STATUS");
                                                             var serviceDates = "";
                                                             var processedDate="";
                                                             var processedeDatesRow = clm.rowColumnData.find(obj  => obj.fieldLabel === "PROCESSED DATE");
                                                             var receivedDate="";
                                                             var disTFLField=false;
                                                             var tflDate="";
                                                             var status="";
                                                             var lastUpdateDateValue="";
                                                             var benefitLevel="";
                                                             var flndcc="--";
                                                             var engCode=engineCode;
                                                             var receivedDateRow = clm.rowColumnData.find(obj  => obj.fieldLabel === "RECEIVED DATE");
                                                             var claimTimelyFillingAutoDoc = savedAutoDoc.find(e => e.componentName === "Timely Filing: "+clm.caseItemsExtId);
                                                             var coordinationAutoDoc = savedAutoDoc.find(e => e.componentName === "Coordination Of Benefits (COB): "+clm.caseItemsExtId);
                                                             var claimSummaryAutoDoc = savedAutoDoc.find(e => !$A.util.isEmpty(e.componentName) && e.componentName.includes("Claim Summary: "+clm.caseItemsExtId)); // DE477063 - Thanish - 13th Aug 2021
                                                             if(!$A.util.isEmpty(serviceDatesRow) ){
                                                             	serviceDates= serviceDatesRow.fieldValue ;
                                                        	 }
                                                              if(!$A.util.isEmpty(processedeDatesRow) ){
                                                             	processedDate= processedeDatesRow.fieldValue ;
                                                        	 }
                                                             if(!$A.util.isEmpty(receivedDateRow) ){
                                                             	receivedDate= receivedDateRow.fieldValue ;
                                                        	 }
															  if( !$A.util.isEmpty(claimTimelyFillingAutoDoc)){
                                                                    var tflDataField =claimTimelyFillingAutoDoc.cardData.find(a => a.fieldName ==="TFL Date");
                                                                    if( !$A.util.isEmpty(tflDataField)){
                                                                        tflDate=tflDataField.fieldValue!="--"? tflDataField.fieldValue:'';
																		disTFLField=tflDataField.fieldValue!="--"? true:false;
                                                                    }
                                                                }
                                                              if( !$A.util.isEmpty(coordinationAutoDoc)){
                                                                    var lastUpdatedDate =coordinationAutoDoc.cardData.find(a => a.fieldName ==="Last Updated Date");
                                                                    if( !$A.util.isEmpty(lastUpdatedDate)){
                                                                        lastUpdateDateValue=lastUpdatedDate.fieldValue!="--"? lastUpdatedDate.fieldValue:'';
                                                                    }
                                                                }
                                                             if( !$A.util.isEmpty(claimSummaryAutoDoc)){
                                                                    var statusField =claimSummaryAutoDoc.cardData.find(a => a.fieldName.includes( "Adjudicated Provider"));
                                                                    if( !$A.util.isEmpty(statusField)){
                                                                        status=statusField.fieldValue!="--"?statusField.fieldValue:'';
                                                                    }
                                                                }
                                                             var paymentNo='';
                                                             if(!$A.util.isEmpty(clm.additionalData.PaymentNo) &&  clm.additionalData.PaymentNo.trim()!="--" ) {
                                                                 paymentNo = clm.additionalData.PaymentNo;
                                                             }
                           									 else{


                                                             	var claimStatusAutoDoc = savedAutoDoc.find(e => e.componentName === "Claim Status: "+clm.caseItemsExtId);

                                                                 if( !$A.util.isEmpty(claimStatusAutoDoc)){
                                                                     var allRowColData = claimStatusAutoDoc.tableBody.flatMap(t => t.rowColumnData);
                                                                     if( !$A.util.isEmpty(allRowColData )){
                                                                        var paymentNoRow = allRowColData.find(obj  => obj.fieldLabel === "PAYMENT #" && !$A.util.isEmpty(obj.fieldValue));
                                                                        var benefitLevelRow = allRowColData.find(obj  => obj.fieldLabel === "BENEFIT LEVEL" && !$A.util.isEmpty(obj.fieldValue));
                                                                         if( !$A.util.isEmpty(paymentNoRow )){
                                                                            paymentNo= paymentNoRow.fieldValue!="--"? paymentNoRow.fieldValue:'';
                                                                        }
                                                                        if( !$A.util.isEmpty(benefitLevelRow )){
                                                                           benefitLevel= benefitLevelRow.fieldValue!="--"? benefitLevelRow.fieldValue:'';
                                                                        }
                                                                     }
                                                                  }
                                                             }



                                                             var type='';
                            								 var typeAutoDoc = savedAutoDoc.find(e => e.componentName === "Payment Status: "+paymentNo);

                                                                if( !$A.util.isEmpty(typeAutoDoc)){
                                                                    var cardDataField =typeAutoDoc.cardData.find(a => a.fieldName ==="Type");
                                                                    if( !$A.util.isEmpty(cardDataField)){
                                                                        type =cardDataField.fieldValue;
                                                                    }
                                                                }
                                                             var chargedRow = clm.rowColumnData.find(obj  => obj.fieldLabel === "CHARGED");
                                                             var charged = "";
                                                             if(!$A.util.isEmpty(chargedRow) ){
                                                             	charged= chargedRow.fieldValue ;
                                                        	 }
                                                              console.log("ClaimType"+clm.additionalData.ClaimType);

                            var platform = clm.additionalData.platform;
                            var TopsAdditionalInfo = clm.additionalData.TopsAdditionalInfo;
                            var cStatus = '';
                            if(!$A.util.isEmpty(claimStatus) ){
                                cStatus = claimStatus.fieldValue;
                            }
                            if((platform == 'UNET') || (cStatus == 'Acknowledgement' || cStatus == 'Rejected' || cStatus == 'Action Required')){
                                flndcc = TopsAdditionalInfo;
                            }else{
                                for (var claimDetail in claimDetails) {
                                    if(claimDetails[claimDetail].claimNumber==clm.caseItemsExtId)
                                    {
                                        if(!$A.util.isEmpty(claimDetails[claimDetail].flnNumber)){
                                            flndcc=claimDetails[claimDetail].flnNumber;
                                        }
                                        break;
                                    }
                                }
                            }


                                                         	 return  {"claimId" : clm.caseItemsExtId,
                                                                      "claimType" :clm.additionalData.ClaimType,
                                                                      "serviceDates": serviceDates,
                                                                      "types": type,
                                                                      "flndcc":flndcc,
                                                                      "engCode":engCode,
                                                                      "paymentNo":paymentNo,
                                                                      "charged":charged,
                                                                      "policyType" : policyClmObj.policyType,
                                                                      "memberId" : policyClmObj.memberId,
                                                                      "resolved":clm.resolved,
                                                                      "groupNo" : policyClmObj.groupNo,
                                                                      "receivedDate":receivedDate,
                                                                      "tflDateValue":tflDate,
                                                                      "coverageLevel": policyClmObj.coverageLevel ,
                                                                      "eligibilityDates":   policyClmObj.eligibilityDates ,
                                                                      "disTFLField":disTFLField,
                                                                      "processedDate":processedDate,
                                                                      "lastUpdateDateValue":lastUpdateDateValue,
                                                                      "status":status,
                                                                      "benefitLevel":benefitLevel,
                                                                     } ;

                                                         });
                            policyClmObj.claims =  claims ;

                             var claimsTableResolved = savedAutoDoc[k].selectedRows.filter(clm => clm.resolved == true)
                                                      .map( clm => {
                                                                            var serviceDatesRow = clm.rowColumnData.find(obj  => obj.fieldLabel === "SERVICE DATES");
                                                                            var serviceDates = "";
                                                                            if(!$A.util.isEmpty(serviceDatesRow) ){
                                                                            serviceDates= serviceDatesRow.fieldValue ;
                                                                            }

                                                            				var claimType ="";

                                                                            if( !$A.util.isUndefinedOrNull(clm.additionalData) && !$A.util.isEmpty(clm.additionalData)){
                                                                                claimType = clm.additionalData.ClaimType;

                                                                           	 }
                                                                             return {"claimId" : clm.caseItemsExtId,
                                                                                     "claimType" :claimType,
                                                                                     "serviceDates": serviceDates,
                                                                                     "policyType" : policyClmObj.policyType,
                                                                                     "memberId" : policyClmObj.memberId,
                                                                                     "groupNo" : policyClmObj.groupNo
                                                                                    }
                                                                          });

                            policyClmObj.resolvedClaims =  claimsTableResolved;
                            policies.push(policyClmObj);
                        }
                    }
                }
        }

        var allResolvedClaims =  policies.flatMap( plc => plc.resolvedClaims);
        cmp.set("v.allResolvedClaims", allResolvedClaims);

        //map of policy type - claim type with claims
        //check CS
        var claimPolicyList = [];
        if(!$A.util.isEmpty(policies) && policies.length > 0 ){
            var csClaims = policies.filter( plc => plc.policyType === "CS" );
            if (!$A.util.isEmpty(csClaims) && csClaims.length > 0){
                let claimPolicy = {}
                claimPolicy.policyType = "CS";
                claimPolicy.claims = csClaims.flatMap(plc => plc.claims);
                claimPolicyList.push(claimPolicy);
            }
            var coClaims = policies.filter( plc => plc.policyType.includes("CO")   );
            if (!$A.util.isEmpty(coClaims) && coClaims.length > 0){
                var allClaimsInCOPolicies =  coClaims.flatMap(plc => plc.claims);
                 if (!$A.util.isEmpty(allClaimsInCOPolicies) && allClaimsInCOPolicies.length > 0){
                     	 var coPhyClaims = allClaimsInCOPolicies.filter(clm => clm.claimType == "P");
                         if (!$A.util.isEmpty(coPhyClaims) && coPhyClaims.length > 0){
                            let claimPolicy = {}
                            claimPolicy.policyType = "CO - Physician";
                            claimPolicy.claims = coPhyClaims;
                            claimPolicyList.push(claimPolicy);
                         }
                        //var coHospClaims = allClaimsInCOPolicies.filter(clm => clm.claimType == "H");
                        var coHospClaims =allClaimsInCOPolicies.filter(clm => clm.claimType == "H" || clm.claimType == "I");
                         if (!$A.util.isEmpty(coHospClaims) && coHospClaims.length > 0){
                            let claimPolicy = {}
                            claimPolicy.policyType = "CO - Hospital";
                            claimPolicy.claims = coHospClaims;
                            claimPolicyList.push(claimPolicy);
                         }
                 }
            }
            //US3463210 - Sravan - Start
            var apClaims = policies.filter( plc => plc.policyType.includes("AP")   );
            if (!$A.util.isEmpty(apClaims) && apClaims.length > 0){
                let claimPolicy = {}
                claimPolicy.policyType = "AP";
                claimPolicy.claims = apClaims.flatMap(plc => plc.claims);
                claimPolicyList.push(claimPolicy);
            }
            //US3463210 - Sravan - End
        }
        cmp.set("v.claimPolicyList", claimPolicyList);

		var resolvedClaimIDs = [];
		var unresolvedClaimIDs = [];
		if( !$A.util.isEmpty(allResolvedClaims) ){
        	resolvedClaimIDs = allResolvedClaims.map(c => c.claimId);
		}
		if(!$A.util.isEmpty(claimPolicyList)){
			unresolvedClaimIDs = claimPolicyList.flatMap( c => c.claims).map(c => c.claimId);
		}
		var allClaimIds = resolvedClaimIDs.concat(unresolvedClaimIDs);

		var relatedCaseItems = "";
        for(var i=0; i<allClaimIds.length; i++ ){
            if(i == 0){
                relatedCaseItems += "External ID - "+ allClaimIds[i];
            }
            else{
                relatedCaseItems += ",External ID - "+ allClaimIds[i];
            }
        }

		var caseWrapper = cmp.get("v.caseWrapper");
		caseWrapper.relatedCaseItems = relatedCaseItems;
        //US3463210 - Sravan - Start
        if(!$A.util.isUndefinedOrNull(claimPolicyList) && !$A.util.isEmpty(claimPolicyList) && cmp.get("v.viewClaimsSubType") == 'Claims Project 20+ Claims'){
          var SRClaimMap = {};
          for(var key in claimPolicyList){
             var SRSourceCodeInfo = {};
             SRSourceCodeInfo.email = '';
             SRSourceCodeInfo.BeginDOS = '';
             SRSourceCodeInfo.EndDOS = '';
             var claimsInfo = [];
             for(var claimKey in claimPolicyList[key].claims){
                claimsInfo[claimKey]  = claimPolicyList[key].claims[claimKey].claimId;
                if(!$A.util.isUndefinedOrNull(claimsInfo) && !$A.util.isEmpty(claimsInfo)){
                    SRSourceCodeInfo.ClaimsInfo = claimsInfo;
                 }
             }
             SRSourceCodeInfo.comment = '';
             SRClaimMap[claimPolicyList[key].policyType] = SRSourceCodeInfo;
          }
          console.log('SRClaimMap'+ JSON.stringify(SRClaimMap));
          if(!$A.util.isUndefinedOrNull(SRClaimMap) && !$A.util.isEmpty(SRClaimMap)){
           caseWrapper.SRClaimMap = SRClaimMap;
          }

         }
        //US3463210 - Sravan - End
		cmp.set("v.caseWrapper",caseWrapper);
	},
     showSpinner: function (cmp) {
        var spinner = cmp.find("clmdtl-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("clmdtl-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    navigateToCaseDetail : function(component,event,helper){

        var caseId = component.get("v.acetCaseId");
        var allUnresolvedResolvedFlg = component.get("v.allUnresolvedResolvedFlg");
        var strRecord = JSON.stringify(component.get("v.caseWrapper"));
        var action = component.get('c.createCaseItemsClaims');

        action.setParams({
            "strRecord": strRecord,
            "caseId" : caseId,
            "allUnresolvedResolvedFlg": allUnresolvedResolvedFlg
        });

        action.setCallback(this, function(response) {

            var state = response.getState();
            console.log('state@@@' + state);
            var data ;

            if (state == "SUCCESS") {

                data = response.getReturnValue();
                 this.hideSpinner(component,event,helper);

                //var caseId='5005500000AQIX0AAP';
                // US2815284 - Sanka
                if(!$A.util.isEmpty(caseId)){
                 this.callRefreshEvent(component);
                }
                component.set("v.isClosedPopup",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Success! The case was routed successfully.",
                    "type": "success"
                });
                if(!$A.util.isEmpty(caseId)){
                    toastEvent.fire();
                }
                var workspaceAPI = component.find("workspace");
                workspaceAPI.openSubtab({
                    url: '#/sObject/'+caseId+'/view',
                    focus: true
                });
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                })
                .catch(function(error) {
                    console.log(error);
                });


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

    },
    callRefreshEvent: function (cmp) {
        var caseWrapper =  cmp.get("v.caseWrapper");
        var appEvent = $A.get("e.c:ACET_CaseHistoryRefreshEvt");
        appEvent.setParams({
            "uniqueId": caseWrapper.refreshUnique
        });
        appEvent.fire();
        var refreshEvent = $A.get("e.c:ACET_AutoDocRefreshEvent");
        refreshEvent.setParams({
            "autodocUniqueId": cmp.get("v.AutodocKey")
        });
        refreshEvent.fire();
        _autodoc.clearAutoDoc(cmp.get("v.AutodocKey")); // DE477048 - Thanish - 12th Aug 2021
    }
})