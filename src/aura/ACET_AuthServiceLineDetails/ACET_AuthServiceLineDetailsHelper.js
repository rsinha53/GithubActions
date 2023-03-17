({
    setTableData: function(cmp) {
        var authDetailsObj = cmp.get("v.authDetailsObj");
        var authType=authDetailsObj.serviceSettingTypeCode.description;

        let today = new Date();
        let popupId = today.getTime();
        var tableDetails = new Object();
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
         var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
         var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
        tableDetails.type = "table";
         if(cmp.get("v.isClaimDetail")){
        tableDetails.autodocHeaderName = "Service Line Details: " + cmp.get("v.SRN")+": "+claimNo;
        tableDetails.componentOrder = 16.05 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
        tableDetails.componentName = "Service Line Details: " + cmp.get("v.SRN")+": "+claimNo;
         }
        else{
        tableDetails.autodocHeaderName = "Service Line Details: " + cmp.get("v.SRN");
        tableDetails.componentOrder = 8;
        tableDetails.componentName = "Service Line Details: " + cmp.get("v.SRN");
        }
        // US3653575
        tableDetails.componentName = 'Service Line Details';
        tableDetails.showComponentName = false;
        tableDetails.tableHeaders = [ "SERVICE DESC/DETAILS", "CODE", "OTHER TEXT", "COUNT FREQUENCY" ];
        tableDetails.tableHoverHeaders = [
            {
                "popupId": popupId + "nServiceDesc",
                "headerValue": "SERVICE DESC/DETAILS"
            },
            {
                "popupId": popupId + "nCode",
                "headerValue": "CODE"
            },
            {
                "popupId": popupId + "nOtherText",
                "headerValue": "OTHER TEXT"
            },
            {
                "popupId": popupId + "nCountFreq",
                "headerValue": "COUNT FREQUENCY"
            }
        ]
        if((authType == "Outpatient") || (authType == "Outpatient Facility")){
            tableDetails.tableHeaders.push("PURCHASE/RENTAL");
            tableDetails.tableHoverHeaders.push(
                {
                    "popupId": popupId + "nPurchaseRental",
                    "headerValue": "PURCHASE/RENTAL"
                }
            );

        }

        tableDetails.tableHeaders.push(
            "NOTIF DATE/TIME", "SERVICE DATE(S)", "EXPIRATION DATE", "NAME/STATUS", "DESCISION OUTCOME", "DECISION SUB TYPE", "CLAIM CODE", "CRITERIA USED", "CRITERIA COMMENT"
        );

        tableDetails.tableHoverHeaders.push(
            {
                "popupId": popupId + "nDateTime",
                "headerValue": "NOTIF DATE/TIME"
            },
            {
                "popupId": popupId + "servDates",
                "headerValue": "SERVICE DATE(S)"
            },
            {
                "popupId": popupId + "decOut",
                "headerValue": "DESCISION OUTCOME"
            },
            {
                "popupId": popupId + "decSubType",
                "headerValue": "DECISION SUB TYPE"
            },
            {
                "popupId": popupId + "claimCode",
                "hasHover": true,
                "headerValue": "CLAIM CODE",
                "alignRight": true,
                "hoverWidth": "710px",
                "hoverDescriptionList": [
                    "AN - Process based on provider's network status. The admitting physician is paid based on the provider's network status.",
                    "AS - Process services at the INN/higher benefit level. All non-network health care providers will be reimbursed at the network level based on billed charges or the repriced amount.",
                    "OS - Process services at the OON/lower benefit level. All providers will be reimbursed at the OON level of benefits regardless of the provider's network status.",
                    "SS - Process based on claim comments.",
                    "DC - Services do not meet coverage requirements for one of the following reasons: -The requested services are not covered based on a medical policy - Member does not active coverage - The services ares not covered by the member's plan - There is no benefit for the service or the service is excluded from coverage,",
                    "DI - Services denied for lack of information received.",
                    "DM - Services not medically necessary.",
                    "DS - Services are covered and/or medically necessary but have not been approved to be performed in the location (site) requested.",
                    "ZZ - Prior Authorization/Notification Cancelled.",
                ]
            },
            {
                "popupId": popupId + "critUsed",
                "headerValue": "CRITERIA USED"
            },
            {
                "popupId": popupId + "critComment",
                "headerValue": "CRITERIA COMMENT"
            }
        );

        tableDetails.tableBody = [];

        var i = 0; var ser;
        for(ser of authDetailsObj.services){
            // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
            // Null check in each level of object nodes to prevent exception
            let code = "--";
            let codeDesc = "";
            let purchaseRental = "--";
            let notifDateTime = "--";
            let decisionOutcome = "--";
            let decisionSubType = "--";
            let claimCode = "--";
            let criteriaUsed = "--";
            let criteriaComment = "--";
            let otherText = "--";

            if(!$A.util.isEmpty(ser.procedureCode) && !$A.util.isEmpty(ser.procedureCode.code)){
                code = ser.procedureCode.code;
            }
            if(!$A.util.isEmpty(ser.procedureCode) && !$A.util.isEmpty(ser.procedureCode.codeDesc)){
                codeDesc = ser.procedureCode.codeDesc;
            }
            if(!$A.util.isEmpty(ser.procedureOtherText)){
                otherText = ser.procedureOtherText;
            }
            if(!$A.util.isEmpty(ser.serviceNonFacility) && !$A.util.isEmpty(ser.serviceNonFacility.dmeProcurementType)){
                purchaseRental = ser.serviceNonFacility.dmeProcurementType;
                purchaseRental=(purchaseRental=='1')?'Purchase':(purchaseRental=='2')?'Rental':purchaseRental;
            }
            if(!$A.util.isEmpty(ser.serviceNonFacility) && !$A.util.isEmpty(ser.serviceNonFacility.advanceNotificationTimestampRendered)){
                notifDateTime = ser.serviceNonFacility.advanceNotificationTimestampRendered;
            }
            if(!$A.util.isUndefinedOrNull(ser.serviceDecision)){
				decisionOutcome=((!$A.util.isUndefinedOrNull(ser.serviceDecision.decisionOutcomeCode))
                            && (!$A.util.isUndefinedOrNull(ser.serviceDecision.decisionOutcomeCode.description)))
                			?ser.serviceDecision.decisionOutcomeCode.description:'--';

                decisionSubType=((!$A.util.isUndefinedOrNull(ser.serviceDecision.decisionSubTypeCode))
                            && (!$A.util.isUndefinedOrNull(ser.serviceDecision.decisionSubTypeCode.description)))
                			?ser.serviceDecision.decisionSubTypeCode.description:'--';
                claimCode=((!$A.util.isUndefinedOrNull(ser.serviceDecision.derivedClaimRemarkCode))
                            && (!$A.util.isUndefinedOrNull(ser.serviceDecision.derivedClaimRemarkCode.code)))
                			?ser.serviceDecision.derivedClaimRemarkCode.code:'--';

                if(!$A.util.isEmpty(ser.serviceDecision.derivedClaimRemarkCode) && !$A.util.isEmpty(ser.serviceDecision.derivedClaimRemarkCode.code)){
                    claimCode = ser.serviceDecision.derivedClaimRemarkCode.code;
                }
                if(!$A.util.isEmpty(ser.serviceDecision.serviceDecisionSource) && !$A.util.isEmpty(ser.serviceDecision.serviceDecisionSource.criteriaId)){
                    criteriaUsed = ser.serviceDecision.serviceDecisionSource.criteriaId;
                }
                if(!$A.util.isEmpty(ser.serviceDecision.claimNoteText)){
                    criteriaComment = ser.serviceDecision.claimNoteText;
                }
            }

            // US3157932
            var rowColumnData = [];
        var desc1='--';
        var details='--';
        var servicedate='--';
        var serviceStopDate='--';
        var serviceStopDate='--';

        if(authType=='Inpatient')
        {
            var desc1=((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                            && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDescUrgencyCode)) &&
                            (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDescUrgencyCode.description)))
            ?authDetailsObj.facility.serviceDescUrgencyCode.description:'--';
            var details=((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                            && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDetailCategoryCode)) &&
                            (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDetailCategoryCode.description)))
            ?authDetailsObj.facility.serviceDetailCategoryCode.description:'--';

            notifDateTime = ((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                             && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.advanceNotificationTimeStamp)))?authDetailsObj.facility.advanceNotificationTimeStamp:'--';
            servicedate=((!$A.util.isUndefinedOrNull(ser.serviceFacility)) &&
                         (!$A.util.isUndefinedOrNull(ser.serviceFacility.actualProcedureDate)))
            				?ser.serviceFacility.actualProcedureDate:'--';

        }else if(authType=='Outpatient')
        {
			 var desc1=((!$A.util.isUndefinedOrNull(ser.serviceNonFacility)) &&
                         (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceDescUrgencyCode)) &&
                            (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceDescUrgencyCode.description)))
            ?ser.serviceNonFacility.serviceDescUrgencyCode.description:'--';
            var details=((!$A.util.isUndefinedOrNull(ser.serviceNonFacility)) &&
                         (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceDetailCategoryCode)) &&
                            (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceDetailCategoryCode.description)))
            ?ser.serviceNonFacility.serviceDetailCategoryCode.description:'--';

			notifDateTime = ((!$A.util.isUndefinedOrNull(ser.serviceNonFacility))
                             && (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.advanceNotificationTimestamp)))
            ?ser.serviceNonFacility.advanceNotificationTimestamp:'--';

			servicedate=((!$A.util.isUndefinedOrNull(ser.serviceNonFacility))
                             && (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceEffDates)) &&
                            (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceEffDates.startDate)))
            ?ser.serviceNonFacility.serviceEffDates.startDate:'--';
            serviceStopDate=((!$A.util.isUndefinedOrNull(ser.serviceNonFacility))
                             && (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceEffDates)) &&
                             (!$A.util.isUndefinedOrNull(ser.serviceNonFacility.serviceEffDates.stopDate)))
            				?ser.serviceNonFacility.serviceEffDates.stopDate:'--';
        }else if(authType == "Outpatient Facility")
        {
            var desc1=((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                            && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDescUrgencyCode)) &&
                            (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDescUrgencyCode.description)))
            ?authDetailsObj.facility.serviceDescUrgencyCode.description:'--';
            var details=((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                            && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDetailCategoryCode)) &&
                            (!$A.util.isUndefinedOrNull(authDetailsObj.facility.serviceDetailCategoryCode.description)))
            ?authDetailsObj.facility.serviceDetailCategoryCode.description:'--';

            notifDateTime = ((!$A.util.isUndefinedOrNull(authDetailsObj.facility))
                             && (!$A.util.isUndefinedOrNull(authDetailsObj.facility.advanceNotificationTimeStamp)))?authDetailsObj.facility.advanceNotificationTimeStamp:'--';

            servicedate=((!$A.util.isUndefinedOrNull(ser.serviceFacility)) &&
                         (!$A.util.isUndefinedOrNull(ser.serviceFacility.actualProcedureDate)))
            				?ser.serviceFacility.actualProcedureDate:'--';
            serviceStopDate='N/A';

        }

            rowColumnData.push(setRowColumnData('outputText',desc1+'/'+details, i,desc1+'/'+details));
            rowColumnData.push(setRowColumnData('outputText', code, i,codeDesc));
            rowColumnData.push(setRowColumnData('outputText', otherText, i,''));
            rowColumnData.push(setRowColumnData('outputText', ser.countFreqRendered, i,''));
            if ((authType == 'Outpatient') || (authType == 'Outpatient Facility')) {
                rowColumnData.push(setRowColumnData('outputText', (authType=='Outpatient Facility')?'--':purchaseRental, i,''));
            }
           var servicedates='--';
           if((authType=='Inpatient') && (servicedate!='--') && (!$A.util.isUndefinedOrNull(servicedate)))
           {
               servicedates=((servicedate!='--') && (!$A.util.isUndefinedOrNull(servicedate)))?
                            this.convertMilitaryDate(servicedate, 'dt'):'--';
           }
           else if(authType=='Outpatient Facility')
           {
               servicedates=((servicedate!='--') && (!$A.util.isUndefinedOrNull(servicedate)))?
                            this.convertMilitaryDate(servicedate, 'dt'):'--';
           }
           else if(authType=='Outpatient')
           {
               var strDate=((servicedate!='--') && (!$A.util.isUndefinedOrNull(servicedate)))?
                            this.convertMilitaryDate(servicedate, 'dt'):'--';
               var stopDate=((serviceStopDate!='--') && (!$A.util.isUndefinedOrNull(serviceStopDate)))?
                            this.convertMilitaryDate(serviceStopDate, 'dt'):'--';
               servicedates=strDate+' - '+stopDate;
           }

        rowColumnData.push(setRowColumnData('outputText',((notifDateTime!='--')?this.convertMilitaryDate(notifDateTime, 'dttm'):'--'), i,''));
        rowColumnData.push(setRowColumnData('outputText',servicedates, i,servicedates));
           /* rowColumnData.push(setRowColumnData('outputText', '--', i,''));
            rowColumnData.push(setRowColumnData('outputText', '--', i,''));*/
            rowColumnData.push(setRowColumnData('outputText', decisionOutcome, i,''));
            rowColumnData.push(setRowColumnData('outputText', decisionSubType, i,''));
            rowColumnData.push(setRowColumnData('outputText', claimCode, i,''));
            rowColumnData.push(setRowColumnData('outputText', criteriaUsed, i,''));
            rowColumnData.push(setRowColumnData('outputText', criteriaComment, i,''));

            var row = {
                "checked" : false,
                "uniqueKey" : i,
                "rowColumnData": rowColumnData // US3157932
            };

        // US3653575
				row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");

            tableDetails.tableBody.push(row);
            i++;
        }

        // US3157932
        function setRowColumnData(ft, fv, uk, hover) {
            var rowColumnData = new Object();
            rowColumnData.fieldType = ft;
            rowColumnData.key = uk;
            if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
                if (fv.length > 20) {
                    rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                    rowColumnData.titleName = (hover != '' ? hover: fv);
                } else {
                    rowColumnData.fieldValue = fv;
                    rowColumnData.titleName = (hover != '' ? hover: '');
                }
            } else {
                rowColumnData.fieldValue = '--';
                rowColumnData.titleName = '';
            }
            rowColumnData.isReportable = true;
            if ('link' == ft) {
                rowColumnData.isLink = true;
            } else if ('outputText' == ft) {
                rowColumnData.isOutputText = true;
            } else if ('isStatusIcon' == ft) {
                rowColumnData.isIcon = true;
            } else {
                rowColumnData.isOutputText = true;
            }
            return rowColumnData;
        }

        if( i == 0){
            var row = {
                "checked" : false,
                "uniqueKey" : 0,
                "rowColumnData" : [
                    {
                        "isNoRecords" : true,
                        "fieldLabel" : "No Records",
                        "fieldValue" : "No Records Found",
                        "key" : 0
                    }
                ]
            }
    row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
            tableDetails.tableBody.push(row);
        }
        cmp.set("v.tableDetails", tableDetails);
    },

     convertMilitaryDate: function (dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                if (type == 'dt') {
                    var dttm = dateParam;
                    if (!$A.util.isUndefinedOrNull(dateParam.split('-')[3])) {
                        var arr = dateParam.split('-');
                        dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    }
                    returnDate = $A.localizationService.formatDateUTC(dttm, format);
                } else if (type == 'dttm') {
                    var arr = dateParam.split('-');
                    var dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    returnDate = $A.localizationService.formatDateTimeUTC(dttm, format);
                }
            } catch (error) { }
        }
        return returnDate;
    }
})