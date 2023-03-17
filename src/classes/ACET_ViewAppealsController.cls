public class ACET_ViewAppealsController {
    
    static final String APPEALTABLENAME = 'Appeal Results';
    static final List <String> APPEALTABLEHEADER = new List<String>{'APPEAL #','MEMBER NAME','TAX ID','ISSUE TYPE','SERVICE TYPE','RECEIVED','STATUS','OUTCOME','CLAIM #', 'SRN #'};

    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getCNSAppealTable(ACET_AppealsService.AppealRequest appealRequest){
        // System.debug(appealRequest);
        // ACET_SAECalloutResult result = ACET_AppealsService.getAppealResults(appealRequest);
        // return processResults(result);
        return getENIMNRAppealTable(appealRequest);
    }

    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getENIMNRAppealTable(ACET_AppealsService.AppealRequest appealRequest){
        System.debug(appealRequest);
        ACET_SAECalloutResult result = ACET_AppealsService.getAppealResults(appealRequest);
        return processResults(result);
    }

    private static ACET_AutoDocUtil.TableDetails processResults(ACET_SAECalloutResult result){
        ACET_AutoDocUtil.TableDetails table = new ACET_AutoDocUtil.TableDetails();
        table.componentName = APPEALTABLENAME;
        table.autodocHeaderName = APPEALTABLENAME;
        table.reportingHeader = APPEALTABLENAME;
        table.showComponentName = false;
        table.tableHeaders = APPEALTABLEHEADER;
        table.componentOrder = 3;
        table.caseItemsEnabled = true;
        if(!result.isSuccess){
            ACET_AutoDocUtil.TableRow row = new ACET_AutoDocUtil.TableRow();
            row.checked = true;
        	row.resolved = true;
        	row.checkBoxDisabled = false;
        	row.uniqueKey = 'No Matching Appeal Results Found';
            row.caseItemsExtId = 'No Matching Appeal Results Found';
            row.isResolvedDisabled = true;
            ACET_AutoDocUtil.RowColumnData cellData = new ACET_AutoDocUtil.RowColumnData();
            cellData.fieldType = 'noRecords';
            cellData.fieldValue = 'No Results Found';
            cellData.fieldLabel = 'noRecords';
            cellData.isNoRecords = true;
            cellData.isReportable = true;
            row.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>{cellData};
            table.tableBody.add(row);
            table.selectedRows.add(row);
            return table;
        }

        for (ACET_AppealsService.AppealResponse resp : (List<ACET_AppealsService.AppealResponse>) result.response) {
            ACET_AutoDocUtil.TableRow row = new ACET_AutoDocUtil.TableRow();
            row.checked = false;
        	row.resolved = false;
        	row.linkDisabled = false;
        	row.checkBoxDisabled = false;
        	row.uniqueKey = resp.appealNo;
            row.caseItemsExtId = resp.appealNo;

        	List<ACET_AutoDocUtil.RowColumnData> cellData = new List<ACET_AutoDocUtil.RowColumnData>();
            cellData.add(ACET_AutoDocUtil.setRowColumnData('link', resp.appealNo, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.memberName, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.taxId, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.issueType, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.serviceType, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.received, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.status, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.outcome, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.claimNo, true));
            cellData.add(ACET_AutoDocUtil.setRowColumnData('outputText', resp.srnNo, true));
            row.rowColumnData = cellData;

            table.tableBody.add(row);
        }

        return table;
    }
}