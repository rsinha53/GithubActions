({
    fetchMockStatus : function(component) { 
        let action = component.get("c.getMockStatus");
        action.setCallback( this, function(response) {
            let state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.isMockEnabled", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
     getMemberCaseHistory: function (cmp,producerid,groupid,memberId,xRefId,flowtype){
        
        var action = cmp.get("c.getRelatedETSBECasesHistory");
        action.setParams({
            "producerID":producerid,
            "groupID":groupid,
            "taxMemberID": memberId,
            "xRefIdIndividual": xRefId,
            "toggleOnOff": false,
            "flowType": flowtype
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == 'SUCCESS') {
                this.hideGlobalSpinner(cmp);
                var caselst = [];

                caselst = response.getReturnValue();
                cmp.set("v.caseHistoryList", caselst);
               // alert(caselst.length);
                var appEvent = $A.get("e.c:ETSBE_CaseHistoryEvent");
                appEvent.setParams({"caseHistoryList" : cmp.get("v.caseHistoryList"),
                                    "xRefId" : xRefId, 
                                    "memberID": memberId,
                                    "memberTabId": cmp.get('v.memberTabId')});
                appEvent.fire(); 

            }else {
                this.hideGlobalSpinner(cmp);
            }
        });
        $A.enqueueAction(action);
    },

	processMemberData : function(component, event, helper) {
        debugger;
         var tabId;
        var memberData = component.get("v.selectedMemberInfo");
        console.log('in');
        console.log(JSON.stringify(memberData));
       	component.set("v.memberId",memberData.memberID);
         component.set("v.memberDOB",memberData.DOB);
       // if(cmp.get("v.pageReference").state.c__housememberId )
        let memDob = '';
        if(!$A.util.isUndefinedOrNull(memberData.DOB)) {
            let tempDob  = new Date(memberData.DOB);
            memDob =  ('0' + (tempDob.getMonth()+1)).slice(-2) + '/' + ('0' + tempDob.getDate()).slice(-2) + '/' + tempDob.getFullYear();
        }
        
        //US1761826 - UHC/Optum Exclusion UI : END
        var action;
        var isCallout = true;
        if (component.get("v.isMockEnabled")) {
            action = component.get("c.getElibilityMockData");
        } else {
            action = component.get("c.callEligibilityServices");
        }

        var memberDOBVar = component.get("v.memberDOB");
        var memberDOB = "";
        var memberDOBVar = memDob;
        if (!$A.util.isEmpty(memberDOBVar)) {
            var memberDOBArray = memberDOBVar.split("/");
            memberDOB = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
        }

        /*** US3076045 - Avish **/
       
       
         var memObj = component.get("v.selectedMemberInfo");
         
        var memberDetails = {
            memberId: component.get("v.memberId"),
            memberDOB: memberDOB,
            firstName: memObj.firstName,
            lastName: memObj.lastName,
            groupNumber: '',
            searchOption: 'MemberIDNameDateOfBirth',
            payerID: component.get("v.payerID"),
            isFourthCallout: true
            
        };
        var providerDetails={"isProviderNotFound":true,"isNoProviderToSearch":true,"isOther":true};
        /*** US3076045 - End **/
        action.setParams({
            memberDetails: memberDetails, //US3076045 - Avish 
            providerDetails: providerDetails
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            // US1813580 - Error Message Translation
            // Sanka Dharmasena - 12/06/2019
            var result = response.getReturnValue();
            //US2100807: Added by Ravindra
            result = JSON.parse(result);

            if (state == "SUCCESS" && result.statusCode == 200) {
                this.hideGlobalSpinner(component);
                // component.get("v.interactionOverviewTabId")+
                if (!$A.util.isUndefinedOrNull(tabId)) {
                    _setAndGetSessionValues.settingValue("Member:" + tabId + ":" + tabId, result.resultWrapper);
                }
                // var retval=_setAndGetSessionValues.getSRNEligibilityData(component.get("v.interactionOverviewTabId")+"123");
                // US2804912 - Avish
                if (isCallout) {
                    isCallout = false;
                    this.processEligibilityRepsonse(component, event, result);
                }

            } else {
                // US2804912 - Avishs
                if (result != null && (result.message != '' && result.message != null)) {
                    if (result.message.includes('AAA:72') || result.message.includes('AAA:73') || result.message.includes('AAA:76') ||
                        result.message.includes('AAA:7371')) {
                        var action2 = component.get("c.fourthCallout");
                        var isCalloutFourth = true;
                        /*** US3076045 - Avish **/
                        var memberDetails = {
                            memberId: component.get("v.memberId"),
                            memberDOB: memberDOB,
                            firstName:memObj.firstName,
                            lastName: memObj.lastName,
                            groupNumber: '',
                            searchOption: 'NameDateOfBirth',
                            payerID: component.get("v.payerID"),
                            isFourthCallout: true
                        };
                        /*** US3076045 - End **/
                        action2.setParams({
                            memberDetails: memberDetails, //US3076045 - Avish 
                            providerDetails: providerDetails
                        });

                        action2.setCallback(this, function (response) {
                            var state = response.getState();
                            var resultFourthCall = response.getReturnValue();
                            resultFourthCall = JSON.parse(resultFourthCall);

                            if (state == "SUCCESS" && resultFourthCall.statusCode == 200) {
                                this.hideGlobalSpinner(component);
                                if (!$A.util.isUndefinedOrNull(tabId)) {
                                    _setAndGetSessionValues.settingValue("Member:" + tabId + ":" + tabId, resultFourthCall.resultWrapper);
                                }
                                if (isCalloutFourth) {
                                    isCalloutFourth = false;

                                    this.processEligibilityRepsonse(component, event, resultFourthCall);
                                }
                            } else {
                                this.hideGlobalSpinner(component);
                                component.set("v.isNoPolicies", true);
                                if (resultFourthCall != null) {
                                    var memberLst = [];
                                    var indexStr = resultFourthCall.message.indexOf("(");
                                    var res = resultFourthCall.message.substring(0, indexStr);
                                    helper.fireToastMessage("Error!", res, "warning", "error", "10000");
                                    component.set("v.memberPolicies", memberLst);
                                }
                            }
                        });
                        $A.enqueueAction(action2);

                    } else {
                        this.hideGlobalSpinner(component);
                        component.set("v.isNoPolicies", true);
                        if (result != null && (result.message != '' && result.message != null)) {
                            var memberLst = [];
                            var indexStr = result.message.indexOf("(");
                            var res = result.message.substring(0, indexStr);
                            helper.fireToastMessage("Error!", res, "warning", "error", "10000");
                            component.set("v.memberPolicies", memberLst);
                        }
                    }
                } // US2804912 - Ends
            }

        });
        $A.enqueueAction(action);
                
	},
     processEligibilityRepsonse: function (component, event, result) {
        //US1933887 - UHG Access
        //Sanka D. - 31.07.2019
        if (!$A.util.isEmpty(result.hasAccess)) {
            component.set('v.uhgAccess', result.hasAccess); // Moved this code inside the loop as a part of DE289195 - Avish
        }
        var coverageLines = result.resultWrapper.CoverageLines;
        var ishighlightedPolicy;

        for (var i = 0; i < coverageLines.length; i++) {
            if (coverageLines[i].highlightedPolicy == true) {
                ishighlightedPolicy = true;
                component.set("v.tranId", coverageLines[i].transactionId);
                component.set("v.currentTransactionId", coverageLines[i].transactionId); //US2855833
                component.set("v.contactAddress", coverageLines[i].addressLine1);
                component.set("v.city", coverageLines[i].city);
                component.set("v.state", coverageLines[i].state);
                component.set("v.zip", coverageLines[i].zip);

            }
        }

        if ($A.util.isEmpty(result.resultWrapper.CoverageLines) && result.resultWrapper.CoverageLines.length == 0) {
            component.set("v.isNoPolicies", true);
        } else if (!ishighlightedPolicy) {
            component.set("v.isNoPolicies", true);
            component.set("v.memberPolicies", result.resultWrapper.CoverageLines);
        } else {
            component.set("v.isNoPolicies", false);
            component.set("v.memberPolicies", result.resultWrapper.CoverageLines);
        }

        //USS2221006 - START
        if (!$A.util.isUndefinedOrNull(result.message) && result.message.includes('AAA:72')) {
            helper.fireToastMessage("Error!", result.message, "warning", "error", "10000");
        }
        //USS2221006 - END

        component.set("v.memberCardData", result.resultWrapper);

        //US2137922: Added by Ravindra
        //To refresh member details in member details card
        var memberCmp = component.find("memberDetailsAI");
        if (memberCmp != null && memberCmp != undefined) {
            memberCmp.refreshPatientDetails();
        }

    },
  fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    callHouseHoldWS : function(component,event,helper) {

		var action = component.get("c.getHouseHoldData");
        action.setParams({
            "transactionId": component.get("v.tranId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            console.log('###TABLE:');
            console.log(JSON.stringify(response));
            console.log('state@@@' + state);
            if(state == 'SUCCESS') {
                //US1857687
                helper.hideGlobalSpinner(component);
                var result = response.getReturnValue();
				        console.log(result);
                if (!$A.util.isUndefinedOrNull(result.resultWrapper)) {
               //component.set("v.houseHoldData",result.houseHoldResultWrapper.houseHoldList);
                component.set("v.houseHoldData",result.resultWrapper.houseHoldList);
                }
            } else {
                //US1857687
                helper.hideGlobalSpinner(component);
            }
        });

        $A.enqueueAction(action);
    },
    
    processSubjectCardData : function(component, event, helper) {
	
         console.log( component.get("v.memberDOB"));
        var memberDOBVar = component.get("v.memberDOB");
       
        var memberDOB = "";
        if (!$A.util.isEmpty(memberDOBVar)) {
            var memberDOBArray  = memberDOBVar.split("/");
            memberDOB = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
        }

        var action = component.get('c.subjectCardPopulation');
        var providerDetails = component.get("v.providerDetails");

        /*** US3076045 - Avish **/
        
        var memObj = component.get("v.selectedMemberInfo");
          var memberDetails = {
            memberId: component.get("v.memberId"),
            memberDOB: memberDOB,
            firstName: memObj.firstName,
            lastName: memObj.lastName,
            groupNumber: '',
            searchOption: 'MemberIDNameDateOfBirth',
            payerID: component.get("v.payerID"),
            isFourthCallout: false
            
        };
        
        var providerDetails={"isProviderNotFound":true,"isNoProviderToSearch":true,"isOther":true};

        /*** US3076045 - End **/
        action.setParams({
            memberDetails : memberDetails, //US3076045 - Avish 
            providerDetails: providerDetails
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {

                    var subjectCard = result.resultWrapper.subjectCard;
                    
                    if (subjectCard != "" && subjectCard != undefined) {
                        var ssnValue = subjectCard.SSN;
                        var eeIdValue = subjectCard.EEID;
                        subjectCard.maskedSSN = 'xxx-xx-' + ssnValue.substring(5, 9);
                        subjectCard.formattedSSN = ssnValue.substring(0, 3) + '-' + ssnValue.substring(3, 5) + '-' + ssnValue.substring(5, 9);
                        subjectCard.maskedEEID = 'xxxxx' + eeIdValue.substring(5, 9);
                    }

                    component.set("v.memberCardSnap", subjectCard);
                    console.log(subjectCard);
                   // this.createOrUpdatePersonAccount(component, component.get("v.mnf"), component.get("v.memberFN"), component.get("v.memberLN"), component.get("v.memberDOB"), component.get("v.memberId"), component.get("v.memberGrpN")); //DE284951 Avish
                } else if (result.statusCode == 400) {
                    //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                } else if (result.statusCode == 999) {
                    //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                }
            }

            });
            $A.enqueueAction(action);
    },
    handleProducerData:function(cmp,event){
        var prodInput = cmp.get('v.ProducerInfo');
        var prodssn = (prodInput.producerSSN != null)?prodInput.producerSSN:'';
        var maskedssn = '';
        var legacyList = prodInput.legacyProducers;
        if(prodssn.length == 9){
            prodssn = prodssn.substring(0,3) + '-' + prodssn.substring(3,5) + '-' + prodssn.substring(5,9);
            maskedssn = 'xxx-xx-' + prodssn.substring(7,prodssn.length);
        }
        var streetAddr = (prodInput.producerAddress != null && prodInput.producerAddress.producerStreetLine1 != null)?prodInput.producerAddress.producerStreetLine1:'';
        streetAddr = (prodInput.producerAddress != null && prodInput.producerAddress.producerStreetLine2 != '')?streetAddr + ',' + prodInput.producerAddress.producerStreetLine2:streetAddr;
        var phone = (prodInput.producerAddress != null && prodInput.producerAddress.producerPhoneNumber != null)?prodInput.producerAddress.producerPhoneNumber:'';
        if(phone != null && phone != '' && phone.length == 10){
            if(!phone.includes('-')){
                phone = phone.substring(0,3) + '-' + phone.substring(3,6) + '-' + phone.substring(6,phone.length);
            }
        } 
        var addrList = [];
        var address = {
            addressType: (prodInput.producerAddress != null && prodInput.producerAddress.addressTypeCode != null)?prodInput.producerAddress.addressTypeCode:'',
            streetAddress: streetAddr,
            city: (prodInput.producerAddress != null && prodInput.producerAddress.producerCity != null)?prodInput.producerAddress.producerCity:'',
            zip: (prodInput.producerAddress != null && prodInput.producerAddress.producerZipCode != null)?prodInput.producerAddress.producerZipCode:'',
            state: (prodInput.producerAddress != null && prodInput.producerAddress.producerState != null)?prodInput.producerAddress.producerState:'',
            phone: phone
        };
        addrList.push(address);
        console.log('PRODUCER ADDRESS: ' + JSON.stringify(address));
        console.log('PRODUCER ADDRESS: ' + JSON.stringify(addrList));
        var prodData = {
            firstName: (prodInput.producerIndividualName.firstName != null)?prodInput.producerIndividualName.firstName:'',
            producerId: (prodInput.producerID != null)?prodInput.producerID:'',
            middleinitial: (prodInput.producerIndividualName.middleInitial != null)?prodInput.producerIndividualName.middleInitial:'',
            lastname: (prodInput.producerIndividualName.lastName != null)?prodInput.producerIndividualName.lastName:'',
            taxid: (prodInput.producerTIN != null)?prodInput.producerTIN:'',
            ssn: prodssn,
            maskedssn: maskedssn,
            agencyName: (prodInput.producerCompanyName != null)?prodInput.producerCompanyName:'',
            primarycontactname: (prodInput.producerContact != null)?prodInput.producerContact:'',
            legacybrokercode: (prodInput.legacyProducerIDList != null)?prodInput.legacyProducerIDList:'',
            type: (prodInput.producerType != null)?prodInput.producerType:'',
            addressInfo: addrList
        };
        console.log('HERE IS FINAL PRODUCER: ' + JSON.stringify(prodData));
        cmp.set('v.ProducerData', prodData);
    },
    callCobdWS : function(component,event,helper) {
		console.log('COB Fun called');
		var action = component.get("c.getCobData");

        action.setParams({
            "transactionId": component.get("v.tranId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state

            console.log(JSON.stringify(response));
            console.log('state@@@' + state);
	if(!$A.util.isEmpty(response)){
            if(state == 'SUCCESS') {
                //US1857687
               helper.hideGlobalSpinner(component);
                var result = response.getReturnValue();
                component.set("v.cobData",result.resultWrapper.cob);
                
                //US1954477	Targeted COB Details - Integration - 30/09/2019 - Sarma : Start
                var additionalCoverageList = result.resultWrapper.additionalCoverageList;
                var secondaryCoverageList = [];
                var primaryCoverageList = []; // US2138007
                component.set('v.isPrimaryCoverageAvailable',false);
                component.set('v.isSecondaryCoverageAvailable',false);
                if(!$A.util.isEmpty(additionalCoverageList)){ // adding null check - Sarma - 04/11/2019
                    // US2138007 Update Logic for Targeted COB - 25/10/2019 - Sarma
                    var latestDateIndex=0;
                    var latestDateIndexTemp=0;
                    var counter = 0;
                        for(var i=0 ; i<additionalCoverageList.length; i++){
                            if(additionalCoverageList[i].primaryGroupIndicator =='Y' || additionalCoverageList[i].primaryGroupIndicator =='P'){
                                component.set('v.isPrimaryCoverageAvailable',true);
                                additionalCoverageList[i].primaryGroupIndicator = 'Yes';
                                primaryCoverageList.push(additionalCoverageList[i]);
                                if(additionalCoverageList[i].policyEffectiveStartDate < additionalCoverageList[latestDateIndexTemp].policyEffectiveStartDate){
                                    latestDateIndex = counter;
                                    latestDateIndexTemp = i;
                                }
                                //component.set('v.primaryCoverageDetails',additionalCoverageList[i]);
                                counter++;
                            }
                            else if(!$A.util.isEmpty(additionalCoverageList[i].primaryGroupIndicator)){
                                //component.set('v.isSecondaryCoverageAvailable',true);
                                additionalCoverageList[i].primaryGroupIndicator = 'No';
                                secondaryCoverageList.push(additionalCoverageList[i]);
                            }
                        }
                        console.log('PRIMARY COVERAGE : '+ JSON.stringify(primaryCoverageList));
                        console.log('PRIMARY COVERAGE : '+ latestDateIndex);

                    if(primaryCoverageList.length>1){ //alert('P > 1');
                        component.set('v.primaryCoverageDetails',primaryCoverageList[latestDateIndex]);
                        primaryCoverageList.splice(latestDateIndex,1);
                        secondaryCoverageList = secondaryCoverageList.concat(primaryCoverageList);
                    } else{
                        component.set('v.primaryCoverageDetails',primaryCoverageList[0]);
                    }

                    if(secondaryCoverageList.length>0){ //alert ( 'sec > 0')
                        component.set('v.isSecondaryCoverageAvailable',true);
                        component.set('v.secondaryCoverageList',secondaryCoverageList);
                    }

                    console.log('SECONDORY COVERAGE : '+ JSON.stringify(secondaryCoverageList));
                    // US2138007 - End
                    //US1954477 - End
                }
            } else {
               //US1857687
               helper.hideGlobalSpinner(component);
            }
	} else {
		helper.hideGlobalSpinner(component);
                var emptyArray = [];
                component.set('v.secondaryCoverageList', emptyArray);
            }
        });

        $A.enqueueAction(action);
    },
    hideGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    },
})