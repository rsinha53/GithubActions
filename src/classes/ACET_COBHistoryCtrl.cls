public class ACET_COBHistoryCtrl {
    public class COBHistoryRequest {
        @AuraEnabled public String cosmosDivision {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String subscriberId {get;set;}
        @AuraEnabled public String dependentCode {get;set;}
        @AuraEnabled public String effectiveDate {get;set;}
        @AuraEnabled public String medicareType {get;set;}
        @AuraEnabled public String medicareEntReason {get;set;}
    }
	// US2890614: COB History Integration M&R - Krish - 15th Feb 2021
    @AuraEnabled
    public static ACET_SAECalloutResult getCOBHistoryMNR(COBHistoryRequest cobHistoryRequest) {
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        // Creating Autodoc table
        ACET_AutoDocUtil.TableDetails cobHistoryTable = new ACET_AutoDocUtil.TableDetails();
        Integer uniqueKey = 0;
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

            if (String.isNotBlank(cosmosUserId) && cosmosUserId.length() > 5) {
                cosmosUserId = cosmosUserId.right(5);
            }
            
            if (String.isNotBlank(cobHistoryRequest.groupNumber) && cobHistoryRequest.groupNumber.length() > 5) {
                cobHistoryRequest.groupNumber = cobHistoryRequest.groupNumber.right(5);
            }

            if (String.isNotBlank(cobHistoryRequest.subscriberId) && cobHistoryRequest.subscriberId.length() > 9) {
                cobHistoryRequest.subscriberId = cobHistoryRequest.subscriberId.right(9);
            }
            
            if (String.isNotBlank(cobHistoryRequest.dependentCode) && cobHistoryRequest.dependentCode.length() > 2) {
                cobHistoryRequest.dependentCode = cobHistoryRequest.dependentCode.right(2);
            }
            
            cobHistoryTable.type = 'table';
            cobHistoryTable.autodocHeaderName = 'Coordination Of Benefits (COB) History';
            cobHistoryTable.componentName = 'Coordination Of Benefits (COB) History';
            cobHistoryTable.componentOrder = 7;
            cobHistoryTable.showComponentName = false;
            cobHistoryTable.tableHeaders = new List<String>{'Updated', 'OI Primary', 'OI Type', 'Payer Name','Eligible Dates','Medicare Type', 'Medicare Entitlement Reason'};
            
            System.debug('@@@ ACET_COBHistoryCtrl - getCOBHistoryMNR():    '+cobHistoryRequest);
			// Calling Service
            if(cobHistoryRequest!=null){
                calloutResult = ACET_ReadMemberCobHistory.invokeService(cosmosUserId, cobHistoryRequest.cosmosDivision, cobHistoryRequest.groupNumber, cobHistoryRequest.subscriberId, cobHistoryRequest.dependentCode, cobHistoryRequest.effectiveDate);
            }
            System.debug('@@@ ACET_COBHistoryCtrl - calloutResult:    '+JSON.serialize(calloutResult));
            if(calloutResult.isSuccess){
                List<ACET_ReadMemberCobHistory.COBHistoyWrapper> historyWrapper = (List<ACET_ReadMemberCobHistory.COBHistoyWrapper>) calloutResult.response;
                for(ACET_ReadMemberCobHistory.COBHistoyWrapper history : historyWrapper){
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.uniqueKey = String.valueOf(uniqueKey);
                    tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.updated) ? history.updated : '--', 'Updated', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.oiPrimary) ? history.oiPrimary : '--', 'OI Primary', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.oiType) ? history.oiType : '--', 'OI Type', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.payerName) ? history.payerName : '--', 'Payer Name', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(history.eligDates) ? history.eligDates : '--', 'Eligible Dates', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(cobHistoryRequest.medicareType) ? cobHistoryRequest.medicareType : '--', 'Medicare Type', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(cobHistoryRequest.medicareEntReason) ? cobHistoryRequest.medicareEntReason : '--', 'Medicare Entitlement Reason', '', true));
                    cobHistoryTable.tableBody.add(tableRow);
                    uniqueKey++;
                }
            }
            if(cobHistoryTable.tableBody.size()==0){
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.uniqueKey = String.valueOf(uniqueKey);
                tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                ACET_AutoDocUtil.RowColumnData noRecordsFound = new ACET_AutoDocUtil.RowColumnData();
                noRecordsFound.fieldType = 'noRecords';
                noRecordsFound.fieldValue = 'No Coordination Of Benefits (COB) History Results Found';
                noRecordsFound.fieldLabel = 'noRecords';
                noRecordsFound.isNoRecords = true;
                noRecordsFound.isReportable = true;
                tableRow.rowColumnData.add(noRecordsFound);
                cobHistoryTable.tableBody.add(tableRow);
            }
            calloutResult.response = cobHistoryTable;
        }
        catch (Exception ex) {
            System.debug('Exception Message::' + ex.getStackTraceString());
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow.uniqueKey = String.valueOf(uniqueKey);
            tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
            ACET_AutoDocUtil.RowColumnData noRecordsFound = new ACET_AutoDocUtil.RowColumnData();
            noRecordsFound.fieldType = 'noRecords';
            noRecordsFound.fieldValue = 'No Coordination Of Benefits (COB) History Results Found';
            noRecordsFound.fieldLabel = 'noRecords';
            noRecordsFound.isNoRecords = true;
            noRecordsFound.isReportable = true;
            tableRow.rowColumnData.add(noRecordsFound);
            cobHistoryTable.tableBody.add(tableRow);
            calloutResult.response = cobHistoryTable;
        }
        return calloutResult;
    }
    // US3269760 - Thanish - 15th Feb 2021
    @AuraEnabled
    public static COBCommentsENIWrapper getCOBCommentsENI(String sysName, String empId, String policyId){
        COBCommentsENIWrapper retWrapper = new COBCommentsENIWrapper();
        ACET_AutoDocUtil.TableDetails commentsTable = new ACET_AutoDocUtil.TableDetails();
        commentsTable.autodocHeaderName = 'Coordination Of Benefits (COB) Comments';
        commentsTable.componentOrder = 8;
        commentsTable.componentName = 'Coordination Of Benefits (COB) Comments';
        commentsTable.showComponentName = false;
        commentsTable.tableHeaders = new list<String> {'Type', 'Date', 'Comment'};
        ACET_ReadCarrierComments.COBWrapper wrapper;
        
        try {
            String username = ''; String password = ''; Integer uniqueKey = 0;
            List<Per_User_Credentials__c> lstPerUserCredentials = [SELECT Id, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
            
            if(lstPerUserCredentials.size()>0){
                username = lstPerUserCredentials[0].UserName__c;
                password = ACET_TOPSEncryptionAlgorithm.getDecryptedString(lstPerUserCredentials[0].Password__c);
            }

            // ACET_SAECalloutResult comResult = ACET_ReadCarrierComments.invokeService('COMMERCIAL', '000005307', 'Feb2021!', 'ACU1', 'S', '464910134', '1W4576');
            ACET_SAECalloutResult comResult = ACET_ReadCarrierComments.invokeService('COMMERCIAL', username, password, sysName, 'S', empId, policyId);
            if(comResult.isSuccess){
                wrapper = (ACET_ReadCarrierComments.COBWrapper) comResult.response;
                for(ACET_ReadCarrierComments.CommentWrapper comCW : wrapper.comments){
                    ACET_AutoDocUtil.TableRow tr =  new ACET_AutoDocUtil.TableRow();
                    tr.uniqueKey = String.valueOf(uniqueKey);
                    tr.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.planType, 'Type'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.commentDate, 'Date'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', comCW.comment, 'Comment'));
                    uniqueKey++;
                    commentsTable.tableBody.add(tr);
                }
            }
            // ACET_SAECalloutResult medResult = ACET_ReadCarrierComments.invokeService('MEDICARE', '000005307', 'Feb2021!', 'ACU1', 'S', '464910134', '1W4576');
            ACET_SAECalloutResult medResult = ACET_ReadCarrierComments.invokeService('MEDICARE', username, password, sysName, 'S', empId, policyId);
            if(medResult.isSuccess){
                wrapper = (ACET_ReadCarrierComments.COBWrapper) medResult.response;
                for(ACET_ReadCarrierComments.CommentWrapper medCW : wrapper.comments){
                    ACET_AutoDocUtil.TableRow tr =  new ACET_AutoDocUtil.TableRow();
                    tr.uniqueKey = String.valueOf(uniqueKey);
                    tr.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', medCW.planType, 'Type'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', medCW.commentDate, 'Date'));
                    tr.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', medCW.comment, 'Comment'));
                    uniqueKey++;
                    commentsTable.tableBody.add(tr);
                } 
            }
            if(commentsTable.tableBody.size()==0){
                ACET_AutoDocUtil.TableRow tr =  new ACET_AutoDocUtil.TableRow();
                tr.uniqueKey = String.valueOf(uniqueKey);
                tr.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                ACET_AutoDocUtil.RowColumnData noRecordsFound = new ACET_AutoDocUtil.RowColumnData();
                noRecordsFound.fieldType = 'noRecords';
                noRecordsFound.fieldValue = 'No COB Comments Results Found';
                noRecordsFound.fieldLabel = 'noRecords';
                noRecordsFound.isNoRecords = true;
                noRecordsFound.isReportable = true;
                tr.rowColumnData.add(noRecordsFound);
                commentsTable.tableBody.add(tr);
            }         
            // US3299151 - Thanish - 16th Mar 2021
            if(comResult.statusCode!=200 && medResult.statusCode!=200){
                retWrapper.statusCode = 500;
            }
        } catch (Exception e) {
            retWrapper.statusCode = 999;
        }
        retWrapper.comments=commentsTable;
        return retWrapper;
        }
    // US3299151 - Thanish - 16th Mar 2021
    public class COBCommentsENIWrapper{
        @AuraEnabled public ACET_AutoDocUtil.TableDetails comments;
        @AuraEnabled public Integer statusCode;

        public COBCommentsENIWrapper(){
            statusCode=200;
        }
    }
}