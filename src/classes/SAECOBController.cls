public class SAECOBController {

    public class CobSearchResultWrapper {
        @AuraEnabled public SAECOBWrapper resultWrapper {
            get;
            set;
        }
    }

    //MNR Request Parameters
    public class COBRequest {
        @AuraEnabled public String cosmosDiv {
            get;
            set;
        }
        @AuraEnabled public String groupNumber {
            get;
            set;
        }
        @AuraEnabled public String subscriberId {
            get;
            set;
        }
        @AuraEnabled public String dependentCode {
            get;
            set;
        }
        @AuraEnabled public String effectiveDate {
            get;
            set;
        }
    }

    //Calling RCED Service for E&I Member
    @AuraEnabled
    public static ACET_SAECalloutResult getENIData(ACET_ReadConsumerEligibilityService.RCEDRequest reqParams) {
        System.debug('reqParams::'+reqParams);
		String claimCode;
        String officeNumber;				 
        reqParams.dateOfBirth = SAEUtils.formatDateFutureDate(reqParams.dateOfBirth);
        System.debug('reqParamsafter::'+reqParams);
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        CobEniWrapper retWrapper = new CobEniWrapper();
        try {
            //Calling Service
            calloutResult = ACET_ReadConsumerEligibilityService.getCOBData(reqParams);
            if (reqParams.sourceCode == 'CS') {
                //get AutodocCard
                retWrapper.eniAutodocCard = getENICobCard(calloutResult);
                retWrapper.eniCobHistoryTable = getENICobHistory(calloutResult);
            }
            ACET_ReadConsumerEligibilityService.ReadConsumerWrapper rcedData = (ACET_ReadConsumerEligibilityService.ReadConsumerWrapper) calloutResult.response;
            retWrapper.regionCode = rcedData.regionCode;
            retWrapper.dependentCode = rcedData.dependentNo;
			claimCode = (rcedData.claimEngineCode)!=null?rcedData.claimEngineCode:'';
            officeNumber = (rcedData.officeNumber)!=null?rcedData.officeNumber:'';
            retWrapper.claimEngineCode = officeNumber+claimCode; //rcedData.officeNumber+rcedData.claimEngineCode;
            retWrapper.createAuthDetails = rcedData.RCEDDetailsForCreateAuth; // US3507486
            calloutResult.response = retWrapper;
        } catch (Exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        return calloutResult;
    }

    //E&I Response Wrapper
    public class CobEniWrapper {
        @AuraEnabled public String regionCode;
        @AuraEnabled public String dependentCode;
		@AuraEnabled public String claimEngineCode;										   
        @AuraEnabled public ACET_AutoDocUtil.CardDetails eniAutodocCard;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails eniCobHistoryTable;
        @AuraEnabled public ACET_ReadConsumerEligibilityService.RCEDDetailsForCreateAuth createAuthDetails;  // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
    }

    // E&I COB AutodocCard
    private static ACET_AutoDocUtil.CardDetails getENICobCard(ACET_SAECalloutResult calloutResponse) {
        //Autodoc Card Formation
        ACET_AutoDocUtil.CardDetails cobCardData = new ACET_AutoDocUtil.CardDetails();
        cobCardData.componentName = 'Coordination Of Benefits (COB)';
        cobCardData.componentOrder = 4;
        cobCardData.noOfColumns = 'slds-size_6-of-12';
        cobCardData.type = 'card';

        ACET_ReadConsumerEligibilityService.ReadConsumerWrapper cobWrapperData = (ACET_ReadConsumerEligibilityService.ReadConsumerWrapper) calloutResponse.response;
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if (calloutResponse.statusCode == 200) {
            String otherInsuranceType = '';
            if(String.isNotBlank(cobWrapperData.otherIns)) {
               otherInsuranceType = cobWrapperData.otherIns;
            } else {
                otherInsuranceType = '--';
            }
            if(String.isNotBlank(cobWrapperData.c_type)) {
                otherInsuranceType = otherInsuranceType + '/' + cobWrapperData.c_type;
            } else {
                otherInsuranceType = otherInsuranceType + '/--';
            }
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Insurance/Type', otherInsuranceType, 'outputText', true));   
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'OI Eligible Dates', String.isNotBlank(cobWrapperData.eligibleDates) ? cobWrapperData.eligibleDates : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Primary Insurance', String.isNotBlank(cobWrapperData.otherInsPrimary) ? cobWrapperData.otherInsPrimary : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Primary Effective Dates', String.isNotBlank(cobWrapperData.primaryEffectiveDates) ? cobWrapperData.primaryEffectiveDates : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payer Name', String.isNotBlank(cobWrapperData.payeeName) ? cobWrapperData.payeeName : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Information', String.isNotBlank(cobWrapperData.medicareInfo) ? cobWrapperData.medicareInfo : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Update Status', String.isNotBlank(cobWrapperData.updateSts) ? cobWrapperData.updateSts : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Last Updated Date', String.isNotBlank(cobWrapperData.lastUpdate) ? cobWrapperData.lastUpdate : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB History/Comments', 'link', true, 'font-weight: bold;', '200%'));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB Process SOP', 'link', true, 'font-weight: bold;', '200%'));
        } else {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Insurance/Type', '--', 'outputText', true));   
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'OI Eligible Dates', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Primary Insurance', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Primary Effective Dates', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payer Name', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Information', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Update Status', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Last Updated Date', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB History/Comments', 'link', true, 'font-weight: bold;', '200%'));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB Process SOP', 'link', true, 'font-weight: bold;', '200%'));
        }
        cobCardData.cardData = cardData;
        return cobCardData;
    }

    // US2585035: COB History Integration E&I - Krish
    private static ACET_AutoDocUtil.TableDetails getENICobHistory(ACET_SAECalloutResult calloutResponse) {
        //Autodoc Card Formation
        ACET_AutoDocUtil.TableDetails cobHistoryTable = new ACET_AutoDocUtil.TableDetails();
        cobHistoryTable.autodocHeaderName = 'Coordination Of Benefits (COB) History';
        cobHistoryTable.componentName = 'Coordination Of Benefits (COB) History';
        cobHistoryTable.componentOrder = 7;
        cobHistoryTable.type = 'table';
        cobHistoryTable.showComponentName = false;
        cobHistoryTable.tableHeaders = new List < String > {
            'Updated',
            'OI Primary',
            'OI Type',
            'Payer Name',
            'Eligible Dates',
            'Medicare Type',
            'Medicare Entitlement Reason'
        };
        Integer uniqueKey = 0;
        try {
            if (calloutResponse.isSuccess) {
                if (calloutResponse.statusCode == 200) {
                    ACET_ReadConsumerEligibilityService.ReadConsumerWrapper cobWrapperData = (ACET_ReadConsumerEligibilityService.ReadConsumerWrapper) calloutResponse.response;
                    List < ACET_ReadMemberCobHistory.COBHistoyWrapper > historyWrapper = (List < ACET_ReadMemberCobHistory.COBHistoyWrapper > ) cobWrapperData.cobHistory;
                    if(historyWrapper != null) {
                        for (ACET_ReadMemberCobHistory.COBHistoyWrapper history: historyWrapper) {
                            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                            tableRow = new ACET_AutoDocUtil.TableRow();
                            tableRow.uniqueKey = String.valueOf(uniqueKey);
                            tableRow.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.updated) ? history.updated : '--', 'Updated', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.oiPrimary) ? history.oiPrimary : '--', 'OI Primary', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.oiType) ? history.oiType : '--', 'OI Type', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.payerName) ? history.payerName : '--', 'Payer Name', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.eligDates) ? history.eligDates : '--', 'Eligible Dates', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.medicareType) ? history.medicareType : '--', 'Medicare Type', '', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.medicareEntReason) ? history.medicareEntReason : '--', 'Medicare Entitlement Reason', '', true));
                            cobHistoryTable.tableBody.add(tableRow);
                            uniqueKey++;
                        }  
                    }

                    if (cobHistoryTable.tableBody.size() == 0) {
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow.uniqueKey = String.valueOf(uniqueKey);
                        tableRow.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
                        tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
                        cobHistoryTable.tableBody.add(tableRow);
                    }
                } else {
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.uniqueKey = String.valueOf(uniqueKey);
                    tableRow.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
                    cobHistoryTable.tableBody.add(tableRow);
                }
            } else {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.uniqueKey = String.valueOf(uniqueKey);
                tableRow.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
                tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
                cobHistoryTable.tableBody.add(tableRow);
            }
        } catch (Exception ex) {
            System.debug('@@@ SAECOBController.getENICobHistory: Exception::' + ex.getStackTraceString());
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow.uniqueKey = String.valueOf(uniqueKey);
            tableRow.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
            cobHistoryTable.tableBody.add(tableRow);
        }
        return cobHistoryTable;
    }

    //Calling ReadMemberCobByPlanIdV5 for MNR Member
    @AuraEnabled
    public static ACET_SAECalloutResult getMNRData(COBRequest cobRequestInfo) {
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        CobMnrWrapper retWrapper = new CobMnrWrapper();
        try {
            //get cosmos userId
            String cosmosUserId = (String) Cache.Session.get('local.TOPSProfileInfo.cosmosId');
            if (String.isBlank(cosmosUserId)) {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                cosmosUserId = (String) Cache.Session.get('local.TOPSProfileInfo.cosmosId');
            }
            if (String.isNotBlank(cosmosUserId) && cosmosUserId.length() > 5) {
                cosmosUserId = cosmosUserId.right(5);
            }

            if (String.isNotBlank(cobRequestInfo.groupNumber) && cobRequestInfo.groupNumber.length() > 5) {
                cobRequestInfo.groupNumber = cobRequestInfo.groupNumber.right(5);
            }

            if (String.isNotBlank(cobRequestInfo.subscriberId) && cobRequestInfo.subscriberId.length() > 9) {
                cobRequestInfo.subscriberId = cobRequestInfo.subscriberId.right(9);
            }
            
            if (String.isNotBlank(cobRequestInfo.dependentCode) && cobRequestInfo.dependentCode.length() > 2) {
                cobRequestInfo.dependentCode = cobRequestInfo.dependentCode.right(2);
            }

            //Calling Service
            calloutResult = ACET_ReadMemberCOBService.invokeService(cosmosUserId, cobRequestInfo.cosmosDiv, cobRequestInfo.groupNumber, cobRequestInfo.subscriberId, cobRequestInfo.dependentCode, cobRequestInfo.effectiveDate);

            //get COB comments table
            retWrapper.cobCommentsTable = getMNRCobCommentsTable(calloutResult);
            //get COB card
            retWrapper.cobCardData = getMNRCobCard(calloutResult);
            calloutResult.response = retWrapper;
        } catch (Exception ex) {
            System.debug('Exception Message::' + ex.getStackTraceString());
        }
        return calloutResult;
    }

    //MNR Response Wrapper
    public class CobMnrWrapper {
        @AuraEnabled public ACET_AutoDocUtil.CardDetails cobCardData;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails cobCommentsTable;
    }

    //MNR Cob Autodoc card
    private static ACET_AutoDocUtil.CardDetails getMNRCobCard(ACET_SAECalloutResult calloutResponse) {
        //Autodoc Card Formation
        ACET_AutoDocUtil.CardDetails cobCardData = new ACET_AutoDocUtil.CardDetails();
        cobCardData.componentName = 'Coordination Of Benefits (COB)';
        cobCardData.componentOrder = 4;
        cobCardData.noOfColumns = 'slds-size_6-of-12';
        cobCardData.type = 'card';

        ACET_ReadMemberCOBService.ReadMemberWrapper cobWrapperData = (ACET_ReadMemberCOBService.ReadMemberWrapper) calloutResponse.response;
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if (calloutResponse.statusCode == 200) {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Insurance/Type', String.isNotBlank(cobWrapperData.otherInsurance) ? cobWrapperData.otherInsurance : '--', 'outputText', true));   
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'OI Eligible Dates', String.isNotBlank(cobWrapperData.eligDates) ? cobWrapperData.eligDates : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Primary Insurance', String.isNotBlank(cobWrapperData.otherPriInsurance) ? cobWrapperData.otherPriInsurance : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Primary Effective Dates', String.isNotBlank(cobWrapperData.priEffDates) ? cobWrapperData.priEffDates: '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payer Name', String.isNotBlank(cobWrapperData.payerName) ? cobWrapperData.payerName : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Information', String.isNotBlank(cobWrapperData.medicareInfo) ? cobWrapperData.medicareInfo : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Update Status', String.isNotBlank(cobWrapperData.updateStatus) ? cobWrapperData.updateStatus : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Last Updated Date', String.isNotBlank(cobWrapperData.lastUpdatedDate) ? cobWrapperData.lastUpdatedDate : '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB History/Comments', 'link', true, 'font-weight: bold;', '200%'));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB Process SOP', 'link', true, 'font-weight: bold;', '200%'));
        } else {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Insurance/Type', '--', 'outputText', true));   
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'OI Eligible Dates', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Other Primary Insurance', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Primary Effective Dates', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payer Name', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Information', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Update Status', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Last Updated Date', '--', 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB History/Comments', 'link', true, 'font-weight: bold;', '200%'));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', 'COB Process SOP', 'link', true, 'font-weight: bold;', '200%'));
        }
        cobCardData.cardData = cardData;
        return cobCardData;
    }

    // US3269760 - Thanish - 16th Feb 2021
    private static ACET_AutoDocUtil.TableDetails getMNRCobCommentsTable(ACET_SAECalloutResult calloutResponse) {
        // Autodoc table formation
        ACET_AutoDocUtil.TableDetails commentsTable = new ACET_AutoDocUtil.TableDetails();
        commentsTable.autodocHeaderName = 'Coordination Of Benefits (COB) Comments';
        commentsTable.componentOrder = 8;
        commentsTable.componentName = 'Coordination Of Benefits (COB) Comments';
        commentsTable.showComponentName = false;
        commentsTable.tableHeaders = new list < String > {
            'Type',
            'Date',
            'Comment'
        };
        Integer uniqueKey = 0;

        ACET_ReadMemberCOBService.ReadMemberWrapper cobWrapperData = (ACET_ReadMemberCOBService.ReadMemberWrapper) calloutResponse.response;
        try {
            if (cobWrapperData.comments != null) {
                for (ACET_ReadCarrierComments.CommentWrapper comCW: cobWrapperData.comments) {
                    ACET_AutoDocUtil.TableRow tr = new ACET_AutoDocUtil.TableRow();
                    tr.uniqueKey = String.valueOf(uniqueKey);
                    tr.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.planType, 'Type'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.commentDate, 'Date'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.comment, 'Comment'));
                    uniqueKey++;
                    commentsTable.tableBody.add(tr);
                }
            }
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        if (commentsTable.tableBody.size() == 0) {
            ACET_AutoDocUtil.TableRow tr = new ACET_AutoDocUtil.TableRow();
            tr.uniqueKey = String.valueOf(uniqueKey);
            tr.rowColumnData = new List < ACET_AutoDocUtil.RowColumnData > ();
            tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
            commentsTable.tableBody.add(tr);
        }
        return commentsTable;
    }

    @AuraEnabled
    public static CobSearchResultWrapper getCob(String transactionId) {
        system.debug('>>>getCOB Method called');
        SAEGetCOBWebService callWS = new SAEGetCOBWebService();
        SAECOBWrapper resultwrap = new SAECOBWrapper();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = callWS.getCobData(transactionId);
        if (CalloutResult.Success) {
            system.debug('>>>Callout success @ COBController ------' + resultwrap);
            system.debug('>>>response@@COB ------' + CalloutResult.Response);
            resultwrap = (SAECOBWrapper) CalloutResult.Response;
            system.debug('>>>resultwrap@@COB ------' + resultwrap.cob);
        } else {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
        }
        CobSearchResultWrapper dataWrap = new CobSearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        return dataWrap;
    }
}