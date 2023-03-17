({
	setCardDetails : function(cmp) {
        var facilityDetails = cmp.get("v.facilityDetails");

		// US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
		let pos = "--";
		let expectedAdmitDischargeDate = "--";
		let actualAdmitDischargeDate = "--";
		let expirationDate = "--";
		let decisionOutcome = "--";
		let decisionSubtype = "--";
		let decisionMadeby = "--";
		let advanceNotificationTimeStampRendered = "--";
		let admissionNotifyDateTimeRendered = "--";
		let dischargeNotifyDateTimeRendered = "--";
		var claimCode = "--";
		// US3222393	View Auth: Facility Details Integration and Testing - Sarma - 12/02/2021
        var serviceDate = "--";

		// US3222404
		var roleDecision = "--";

		if(!$A.util.isEmpty(facilityDetails)){

			if(!$A.util.isEmpty(facilityDetails.facility)){
				if(!$A.util.isEmpty(facilityDetails.facility.placeOfServiceCode) && !$A.util.isEmpty(facilityDetails.facility.placeOfServiceCode.description)){
                    pos = facilityDetails.facility.placeOfServiceCode.description;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.expectedAdmissionDischargeRendered)){
                    expectedAdmitDischargeDate = facilityDetails.facility.expectedAdmissionDischargeRendered;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.actualAdmitDischargeRendered)){
                    actualAdmitDischargeDate = facilityDetails.facility.actualAdmitDischargeRendered;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.expirationDateRendered)){
                    expirationDate = facilityDetails.facility.expirationDateRendered;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.advanceNotificationTimeStampRendered)){
                    advanceNotificationTimeStampRendered = facilityDetails.facility.advanceNotificationTimeStampRendered;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.admissionNotifyDateTimeRendered)){
                    admissionNotifyDateTimeRendered = facilityDetails.facility.admissionNotifyDateTimeRendered;
				}
				if(!$A.util.isEmpty(facilityDetails.facility.dischargeNotifyDateTimeRendered)){
                    dischargeNotifyDateTimeRendered = facilityDetails.facility.dischargeNotifyDateTimeRendered;
				}


				if(!$A.util.isEmpty(facilityDetails.facility.facilityDecision)){
					if(!$A.util.isEmpty(facilityDetails.facility.facilityDecision.decisionOutcomeCode) && !$A.util.isEmpty(facilityDetails.facility.facilityDecision.decisionOutcomeCode.description) ){
						decisionOutcome = facilityDetails.facility.facilityDecision.decisionOutcomeCode.description;
					}
					if(!$A.util.isEmpty(facilityDetails.facility.facilityDecision.subTypeCode) && !$A.util.isEmpty(facilityDetails.facility.facilityDecision.subTypeCode.description) ){
						decisionSubtype = facilityDetails.facility.facilityDecision.subTypeCode.description;
					}
					if(!$A.util.isEmpty(facilityDetails.facility.facilityDecision.madeByUserId)){
						decisionMadeby = facilityDetails.facility.facilityDecision.madeByUserId;
					}
					if(!$A.util.isEmpty(facilityDetails.facility.facilityDecision.overideClaimRemarkCode) && !$A.util.isEmpty(facilityDetails.facility.facilityDecision.overideClaimRemarkCode.code)){
						claimCode = facilityDetails.facility.facilityDecision.overideClaimRemarkCode.code;
					} else if (!$A.util.isEmpty(facilityDetails.facility.facilityDecision.derviedClaimRemarkCode) && !$A.util.isEmpty(facilityDetails.facility.facilityDecision.derviedClaimRemarkCode.code)){
						claimCode = facilityDetails.facility.facilityDecision.derviedClaimRemarkCode.code;
					}

					// US3222404
					if (cmp.get("v.authType") == "OutPatient") {
						if (!$A.util.isUndefinedOrNull(facilityDetails.services)) {
							var SRN = cmp.get('v.SRN');
							var services = facilityDetails.services;
							for (var i = 0; i < services.length; i++) {
								if (!$A.util.isUndefinedOrNull(facilityDetails.services[i].serviceReferenceNumber)) {
									if (facilityDetails.services[i].serviceReferenceNumber == SRN) {
										if (!$A.util.isEmpty(services[i].serviceDecision) && !$A.util.isEmpty(services[i].serviceDecision.decisionMadeByUserPosition)) {
											roleDecision = services[i].serviceDecision.decisionMadeByUserPosition;
										}
									}
								}
							}
						}
					} else {
						if (!$A.util.isEmpty(facilityDetails.facility.facilityDecision.madeByUserPosition)) {
							roleDecision = facilityDetails.facility.facilityDecision.madeByUserPosition;
						}
					}

				}

			}
			// US3222393	View Auth: Facility Details Integration and Testing - Sarma - 12/02/2021
			if (cmp.get("v.authType") == "OutPatient") {
				advanceNotificationTimeStampRendered = '--';
				let srn = cmp.get("v.SRN");
				if (!$A.util.isEmpty(facilityDetails.services) && facilityDetails.services.length > 0) {
					let servicesList = facilityDetails.services;
					for (let n = 0; n < servicesList.length; n++) {
						if (servicesList[n].serviceReferenceNumber == srn) {
							if (!$A.util.isEmpty(servicesList[n].serviceNonFacility) && !$A.util.isEmpty(servicesList[n].serviceNonFacility.serviceEffDates) && !$A.util.isEmpty(servicesList[n].serviceNonFacility.serviceEffDates.startDate)) {
								serviceDate = servicesList[n].serviceNonFacility.serviceEffDates.startDate;
								if (!$A.util.isEmpty(servicesList[n].serviceNonFacility.serviceEffDates.stopDate)) {
									serviceDate = serviceDate + ' - ' + servicesList[n].serviceNonFacility.serviceEffDates.stopDate;
								}
							}
							if (!$A.util.isEmpty(servicesList[n].serviceNonFacility) && !$A.util.isEmpty(servicesList[n].serviceNonFacility.advanceNotificationTimestampRendered)) {
								advanceNotificationTimeStampRendered = servicesList[n].serviceNonFacility.advanceNotificationTimestampRendered;
							}
							break;
						}
					}
				}
			}
		}

        var cardDetails = new Object();
         var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
         var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
            var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
         if(cmp.get("v.isClaimDetail")){
        cardDetails.componentName = "Facility Details: " + cmp.get("v.SRN")+": "+claimNo;
        cardDetails.componentOrder =16.03 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
             // US3653575
             cardDetails.caseItemsExtId = claimNo;
         }
        else{
        cardDetails.componentName = "Facility Details: " + cmp.get("v.SRN");
        cardDetails.componentOrder = 6;
            cardDetails.caseItemsExtId = cmp.get("v.SRN");
        }
        cardDetails.noOfColumns = (cmp.get("v.authType") == "InPatient") ? "slds-size_1-of-8" : ((cmp.get("v.authType") == "OutPatient") || (cmp.get("v.authType") == "OutPatientFacility") ? "slds-size_1-of-6" : "slds-size_1-of-7");
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        // US3653575
        cardDetails.reportingHeader = 'Facility Details';
        cardDetails.cardData = [
            {
                "checked": false,
                "fieldName": "Name/Status",
                "fieldType": "link",
                "fieldValue": ($A.util.isEmpty(cmp.get("v.finalText")) ? "--" : cmp.get("v.finalText")),
                "fieldValueTitle" : cmp.get("v.hoverText"),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "POS",
                "fieldType": "outputText",
                "fieldValue": pos,
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            }
		];
		//US3225477 Swapnil- Rearrangement of fields
		if(cmp.get("v.authType") == "InPatient"){
			cardDetails.cardData.push(
				{
					"checked": false,
					"fieldName": "Expected Admit/Discharge Date(s)",
					"fieldType": "customWidthText",
					"width": "200%",
					"fieldValue": expectedAdmitDischargeDate,
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"fieldName": "",
					"fieldType": "emptySpace",
					"fieldValue": ""
				},
				{
					"checked": false,
					"fieldName": "Advance Notification",
					"fieldType": "outputText",
					"fieldValue": (advanceNotificationTimeStampRendered.length > 20) ? advanceNotificationTimeStampRendered.substring(0, 20) + "..." : advanceNotificationTimeStampRendered,
					"fieldValueTitle": (advanceNotificationTimeStampRendered.length > 20) ? advanceNotificationTimeStampRendered : "",
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "Decision Made by",
					"fieldType": "outputText",
					"fieldValue": decisionMadeby,
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "Admission Notification",
					"fieldType": "outputText",
					"fieldValue": (admissionNotifyDateTimeRendered.length > 20) ? admissionNotifyDateTimeRendered.substring(0, 20) + "..." : admissionNotifyDateTimeRendered,
					"fieldValueTitle": (admissionNotifyDateTimeRendered.length > 20) ? admissionNotifyDateTimeRendered : "",
					"showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
				}
			);
		} else if((cmp.get("v.authType") == "OutPatient") || (cmp.get("v.authType") == "OutPatientFacility")){

			// US3222393	View Auth: Facility Details Integration and Testing - Sarma - 12/02/2021
            if (cmp.get("v.authType") == "OutPatientFacility") {
                if (!$A.util.isEmpty(cmp.get("v.facilityDetails.facility")) && !$A.util.isEmpty(cmp.get("v.facilityDetails.facility.expectedAdmissionDate")) && !$A.util.isEmpty(cmp.get("v.facilityDetails.facility.expectedDischargeDate"))) {
                    serviceDate = cmp.get("v.facilityDetails.facility.expectedAdmissionDate") + ' - ' + cmp.get("v.facilityDetails.facility.expectedDischargeDate");
                }
            }

			cardDetails.cardData.push(
				{
					"checked": false,
					"fieldName": "Service Date(s)",
					"fieldType": "outputText",
					"fieldValue": (serviceDate.length > 20) ? serviceDate.substring(0, 20) + "..." : serviceDate,
					"fieldValueTitle": (serviceDate.length > 20) ? serviceDate : "",
					"showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
				});

			// US3222404
			if ((cmp.get("v.authType") == "OutPatientFacility")) {
				cardDetails.cardData.push(
				{
					"checked": false,
					"fieldName": "Expiration Date",
					"fieldType": "outputText",
					"fieldValue": expirationDate,
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
					}
				);
			}

			cardDetails.cardData.push({
				"checked": false,
				"fieldName": "Advance Notification",
				"fieldType": "outputText",
				"fieldValue": (advanceNotificationTimeStampRendered.length > 20) ? advanceNotificationTimeStampRendered.substring(0, 20) + "..." : advanceNotificationTimeStampRendered,
				"fieldValueTitle": (advanceNotificationTimeStampRendered.length > 20) ? advanceNotificationTimeStampRendered : "",
				"showCheckbox": true,
				"isReportable": true // US2834058 - Thanish - 13th Oct 2020
			});
			if ((cmp.get("v.authType") == "OutPatientFacility")) {
				cardDetails.cardData.push(
				{
					"fieldName": "",
					"fieldType": "emptySpace",
					"fieldValue": ""
					});
				}
		}
		cardDetails.cardData.push(
			{
				"checked": false,
				"fieldName": "Decision Outcome",
				"fieldType": "outputText",
				"fieldValue": decisionOutcome,
				"showCheckbox": true,
				"isReportable": true // US2834058 - Thanish - 13th Oct 2020
			});
		if (cmp.get("v.authType") == "OutPatient") {
			cardDetails.cardData.push(
				{
					"fieldName": "",
					"fieldType": "emptySpace",
					"fieldValue": ""
				}
			);
		}
		cardDetails.cardData.push(
			{
				"checked": false,
				"fieldName": "Decision Sub Type",
				"fieldType": "outputText",
				"fieldValue": decisionSubtype,
				"showCheckbox": true,
				"isReportable": true // US2834058 - Thanish - 13th Oct 2020
			}
		);
		if (cmp.get("v.authType") == "InPatient") {

			cardDetails.cardData.push(
			{
				"checked": false,
					"fieldName": "Role/Position",
				"fieldType": "outputText",
					"fieldValue": (roleDecision.length > 20) ? roleDecision.substring(0, 20) + "..." : roleDecision, // US3222404
				"showCheckbox": true,
				"isReportable": true // US2834058 - Thanish - 13th Oct 2020
			},
			{
				"checked": false,
					"fieldName": "Actual Admit/Discharge Date(s)",
					"fieldType": "customWidthText",
					"width": "200%",
					"fieldValue": actualAdmitDischargeDate,
				"showCheckbox": true,
				"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"fieldName": "",
					"fieldType": "emptySpace",
					"fieldValue": ""
				},
				{
					"checked": false,
					"fieldName": "Claim Code",
					"fieldType": "hoverText",
					"popupWidth": "600px",
					"descriptionList": cmp.get("v.descList"),
					"popupId": "ClaimCode",
					"fieldValue": claimCode,
					"alternateFieldValue": claimCode,
					"showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "LOS",
					"fieldType": "outputText",
					"fieldValue": ($A.util.isEmpty(cmp.get("v.LengthOfStay")) ? "--" : cmp.get("v.LengthOfStay") + " Days"),
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "Discharge Notification",
					"fieldType": "outputText",
					"fieldValue": (dischargeNotifyDateTimeRendered.length > 20) ? dischargeNotifyDateTimeRendered.substring(0,20) + "..." : dischargeNotifyDateTimeRendered,
					"fieldValueTitle" : (dischargeNotifyDateTimeRendered.length > 20) ? dischargeNotifyDateTimeRendered : "",
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				}
			);
		}
		if((cmp.get("v.authType") == "OutPatient") || (cmp.get("v.authType") == "OutPatientFacility")){
			
			cardDetails.cardData.push(
				{
					"checked": false,
					"fieldName": "Decision Made by",
					"fieldType": "outputText",
					"fieldValue": decisionMadeby,
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "Role/Position",
					"fieldType": "outputText",
					"fieldValue": (roleDecision.length > 20) ? roleDecision.substring(0, 20) + "..." : roleDecision, // US3222404
					"showCheckbox": true,
					"isReportable": true // US2834058 - Thanish - 13th Oct 2020
				},
				{
					"checked": false,
					"fieldName": "Claim Code",
					"fieldType": "hoverText",
					"popupWidth": "350px",
					"descriptionList": cmp.get("v.descList"),
					"popupId": "ClaimCode2",
					"fieldValue": claimCode,
					"alternateFieldValue": claimCode,
					"showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
				}
			);
		}
		cmp.set("v.cardDetails", cardDetails);
    }
})