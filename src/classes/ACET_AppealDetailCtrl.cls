public class ACET_AppealDetailCtrl {
    
    static final String DUEDATE = '01/01/2021';

    @Auraenabled
    public static AppealDetailWrapper getAppealInfo(String taxId, String appealId) {
        ACET_SAECalloutResult result = ACET_AppealsService.getAppealDetails(taxId,appealId);
        AppealDetailWrapper apppealDetailInfo = new AppealDetailWrapper();
        if(!result.isSuccess){
            return apppealDetailInfo;
        }
        try {
            ACET_AppealDetailsWrapper appealWrapper = (ACET_AppealDetailsWrapper) result.response;
            // Appeal detail Card
            ACET_AutoDocUtil.CardDetails appDetailCard = new ACET_AutoDocUtil.CardDetails();
            appDetailCard.componentName = 'Appeal Details: ' + appealWrapper.appealId;
            appDetailCard.reportingHeader = 'Appeal Details';
            appDetailCard.componentOrder = 12;
            appDetailCard.type = 'card';
            appDetailCard.noOfColumns = 'slds-size_1-of-7';
            appDetailCard.caseItemsExtId = appealWrapper.appealId;
            List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
            //first row
            String memberName = appealWrapper.patientInfo.patientFn + ' ' + appealWrapper.patientInfo.patientLn;
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Case Info Member Name', memberName, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Relationship',appealWrapper.patientInfo.relationshipCd, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Acknowledgement Letter Req?',appealWrapper.acknowledgementLetterReq, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Member Release Required', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Member Release Recv' + '\'' + 'd', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            //Second row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'UHG Received', appealWrapper.dateSubmitted, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'CEU Received', appealWrapper.ceuReceivedDt, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Due Date', '--', 'outputText', true));//Gap
            //No dateClosed in response
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Closed Date', appealWrapper.dateClosed, 'outputText', true));
            String claimDt = appealWrapper.ImpactedItems.initialClaimDenial != null ? appealWrapper.ImpactedItems.initialClaimDenial : '--';
            String srnDt = appealWrapper.ImpactedItems.initialSRNDenial != null ? appealWrapper.ImpactedItems.initialSRNDenial : '--';
            String initialDenial = claimDt == '--' ? (srnDt != '--' ? srnDt : '--') : claimDt;
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Initial Denial', initialDenial, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Related Case', '--', 'link', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            //Third row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Received From', appealWrapper.receivedFromDesc, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'External ID', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Pre/Post Service', appealWrapper.preOrPostServiceDesc, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal Type', appealWrapper.appealTypeDesc, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Financial Liability', appealWrapper.financialLiabilityDesc, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            //Fourth row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'FLN #', '--', 'link', true)); //Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Portal Attachment', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Funding', appealWrapper.fundingDesc, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'State Specific Form Required ', appealWrapper.stateSpecificFormRev, 'outputText', true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'State Specific Form Rev' + '\'' + 'd', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Pharmacy Details Drug Name', '--', 'outputText', true));//Gap
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Pharmacy Overturn', '--', 'outputText', true));//Gap
            //Fifth row
            String appealReason = 'Level['+appealWrapper.issueTypeId+']';
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal Reason', appealReason, 'outputTextArea', true, '', '950px'));
            appDetailCard.cardData = cardData;
            apppealDetailInfo.appealDetailCard = appDetailCard;

            //Determination Card
            apppealDetailInfo.determinationCard = setDetermination(appealWrapper);

            //Impacted Items
            apppealDetailInfo.impactedItemsTable = setImpacted(appealWrapper);

            //Comments
            apppealDetailInfo.appealCommentsTable = setComments(appealWrapper);

            //Letters
            apppealDetailInfo.appealLettersTable = setLetters(appealWrapper);
        } catch (Exception ex) {
            System.debug('Exception in Appeal detail class::' + ex.getStackTraceString());
        }
        return apppealDetailInfo;
    }

    private static ACET_AutoDocUtil.TableDetails setImpacted(ACET_AppealDetailsWrapper appealWrapper){
        ACET_AutoDocUtil.TableDetails impItemsTable = new ACET_AutoDocUtil.TableDetails();
        impItemsTable.type = 'table';
        impItemsTable.componentOrder = 14;
        impItemsTable.componentName = 'Impacted Items';
        impItemsTable.autodocHeaderName = 'Impacted Items';
        impItemsTable.tableHeaders = new List < String > {
            'CLAIM/ SRN #',
            'INITIAL CLAIM/SRN DENIAL',
            'CHARGED',
            'OVERTURNED',
            'PAID',
            'PATIENT RESPONSIBILITY'
        };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if(appealWrapper.ImpactedItems == null){
            impItemsTable.tableBody.add(setNoResults(appealWrapper.appealId));
            return impItemsTable;
        }
        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
        tableRow.checked = false;
        tableRow.uniqueKey = '0';
        tableRow.caseItemsExtId = appealWrapper.appealId;
        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
        String claimNo = appealWrapper.claims != null && appealWrapper.claims.size() > 0 ? appealWrapper.claims[0].claimNumber : '--';
        String claimDt = appealWrapper.ImpactedItems.initialClaimDenial != null ? appealWrapper.ImpactedItems.initialClaimDenial : '--';
        String srnDt = appealWrapper.ImpactedItems.initialSRNDenial != null ? appealWrapper.ImpactedItems.initialSRNDenial : '--';
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', claimNo, true));
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',  claimDt + '/' + srnDt, true));
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true));//gap
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true));//gap
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true));//gap
        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true));//gap
        tableRow.rowColumnData = rowColumns;
        tableRows.add(tableRow);
        impItemsTable.tableBody = tableRows;

        return impItemsTable;
    }

    private static ACET_AutoDocUtil.TableDetails setComments(ACET_AppealDetailsWrapper appealWrapper){
        ACET_AutoDocUtil.TableDetails commentsTable = new ACET_AutoDocUtil.TableDetails();
        commentsTable.type = 'table';
        commentsTable.componentOrder = 15;
        commentsTable.componentName = 'Comments';
        commentsTable.autodocHeaderName = 'Comments';
        commentsTable.tableHeaders = new List < String > {
            'DATE',
            'FOLLOW UP',
            'COMMENT TYPE',
            'COMMENT'
        };
        List < ACET_AutoDocUtil.TableRow > commentTableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if(appealWrapper.comments == null || appealWrapper.comments.isEmpty()){
            commentsTable.tableBody.add(setNoResults(appealWrapper.appealId));
            return commentsTable;
        }
        for (ACET_AppealDetailsWrapper.Comments comm : appealWrapper.comments) {
            ACET_AutoDocUtil.TableRow commentTableRow = new ACET_AutoDocUtil.TableRow();
            commentTableRow.checked = false;
            commentTableRow.uniqueKey = comm.date_Z;
            commentTableRow.caseItemsExtId = appealWrapper.appealId;
            List < ACET_AutoDocUtil.RowColumnData > commentRowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
            commentRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', comm.date_Z, true));
            commentRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true)); //Gap
            String commentsType =  comm.description != null ?  comm.description.replaceAll('\r\n', '<br/>') : '--';
            commentRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', commentsType, true));
            String commentsDesc =  comm.type != null ?  comm.type.replaceAll('\r\n', '<br/>') : '--';
            commentRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', commentsDesc, true));
            commentTableRow.rowColumnData = commentRowColumns;
            commentTableRows.add(commentTableRow);
        }
        commentsTable.tableBody = commentTableRows;

        return commentsTable;
    }

    private static ACET_AutoDocUtil.CardDetails setDetermination(ACET_AppealDetailsWrapper appealWrapper){
        ACET_AutoDocUtil.CardDetails detDetailCard = new ACET_AutoDocUtil.CardDetails();
        detDetailCard.componentName = 'Determination';
        detDetailCard.componentOrder = 13;
        detDetailCard.type = 'card';
        detDetailCard.noOfColumns = 'slds-size_1-of-5';
        List < ACET_AutoDocUtil.FieldDetails > detCardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        //first row
        //no outcome field in response
        detCardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Outcome', appealWrapper.outcome, 'outputText', true));
        detCardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Pend Reason', '--', 'outputText', true));//gap
        detCardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Extension Requested', '--', 'outputText', true));//gap
        detCardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Granted Days', appealWrapper.grantedDays, 'outputText', true));
        detCardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Follow Up', SAEUtils.formatDate(appealWrapper.followUp), 'outputText', true));
        detDetailCard.cardData = detCardData;

        return detDetailCard;
    }

    private static ACET_AutoDocUtil.TableDetails setLetters(ACET_AppealDetailsWrapper appealWrapper){
        ACET_AutoDocUtil.TableDetails lettersTable = new ACET_AutoDocUtil.TableDetails();
        lettersTable.type = 'table';
        lettersTable.componentOrder = 16;
        lettersTable.componentName = 'Letters';
        lettersTable.autodocHeaderName = 'Letters';
        lettersTable.tableHeaders = new List < String > {
            'TYPE',
            'MAILED DATE',
            'ID'
        };
        List < ACET_AutoDocUtil.TableRow > lettersTableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if(appealWrapper.attachments == null || appealWrapper.attachments.isEmpty()){
            lettersTable.tableBody.add(setNoResults(appealWrapper.appealId));
            return lettersTable;
        }
        for(ACET_AppealDetailsWrapper.Attachments att : appealWrapper.attachments){
            ACET_AutoDocUtil.TableRow lettersTableRow = new ACET_AutoDocUtil.TableRow();
            lettersTableRow.checked = false;
            lettersTableRow.uniqueKey = String.valueOf(att.attachmentId);
            lettersTableRow.caseItemsExtId = appealWrapper.appealId;
            List < ACET_AutoDocUtil.RowColumnData > lettersRowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
            lettersRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', att.attachmentDescription, true));
            lettersRowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', att.mailedDt, true));
            lettersRowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', String.valueOf(att.caseAttachmentId), true));
            lettersTableRow.rowColumnData = lettersRowColumns;
            lettersTableRows.add(lettersTableRow);
        }
        lettersTable.tableBody = lettersTableRows;

        return lettersTable;
    }

    private static ACET_AutoDocUtil.TableRow setNoResults(String appealId){
        ACET_AutoDocUtil.TableRow row = new ACET_AutoDocUtil.TableRow();
        row.checked = false;
        row.uniqueKey = 'No Results Found';
        row.caseItemsExtId = appealId;
        ACET_AutoDocUtil.RowColumnData cellData = new ACET_AutoDocUtil.RowColumnData();
        cellData.fieldType = 'noRecords';
        cellData.fieldValue = 'No Results Found';
        cellData.fieldLabel = 'noRecords';
        cellData.isNoRecords = true;
        cellData.isReportable = true;
        row.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>{cellData};
        return row;
    }

    public class AppealDetailWrapper {
        @Auraenabled public ACET_AutoDocUtil.CardDetails appealDetailCard;
        @Auraenabled public ACET_AutoDocUtil.CardDetails determinationCard;
        @Auraenabled public ACET_AutoDocUtil.TableDetails impactedItemsTable;
        @Auraenabled public ACET_AutoDocUtil.TableDetails appealCommentsTable;
        @Auraenabled public ACET_AutoDocUtil.TableDetails appealLettersTable;
    }

}