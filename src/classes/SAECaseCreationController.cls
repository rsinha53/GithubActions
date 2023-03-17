/**
@Desc: TTS Modal Case Creation Controller. A new file created!
@Date: 01-08-2019

**/
public class SAECaseCreationController {

     public class StateInfo {
        public HttpRequest httpRequest { get; set; }
        public Boolean isResolved { get; set; }
        public String finalOrsIssueID { get; set; }
	}

	public static string acetCaseId;
    static final String CASE_RECORD_TYPE_SAE_PROVIDER = 'SAE Provider';
    static final String FinancialTier1 = 'FinancialsTier 1';
    static final String FinancialINN = 'FinancialsINN';
    static final String FinancialOON = 'FinancialsOON';
	static final String ASOFDATE = 'As of Date';
    static final Map < string, string > finalContactTypeToORSCodeMap = new Map < string, string > {
        'Member' => 'EM',
        'Attorney' => 'LA',
        'Internal/UHG Employee' => 'MI',
        'Member Representative (Friend, Family, Navigator, Representative, etc.)' => 'MR',
        'Other Carrier/Payor/Billing Vendor' => 'OI',
        'Pharmacy/Pharmacist' => 'PX',
        'Prospective Member' => 'PM',
        'Reporter/Media Representative' => 'NM',
        'State Regulatory Agent/Government Agency' => 'RT',
        'Other' => 'NM',
        'Provider' => 'PR'
    };

    /**
    @Desc: Get the Type List based on the Call Topic
    **/
    @AuraEnabled
    public static list < String > getTTSFilterMapKeyStr(string callTopic, Boolean isRoutingAllowed) {
        list < string > keylist = new list < string > ();
        for (string str: ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).keyset()) {
            if(!isRoutingAllowed && str.equalsIgnoreCase('Issue Routed')) {
                //Skipping Issue routed value for Member Only and Other flows
            } else {
                keylist.add(str);
            }
        }
        return keylist;
    }

    /**
    @Desc: Get the Sub Type List based on the Call Topic and selected Type
    **/
    @AuraEnabled
    public static List < String > getTTSFilterMapValueStr(string callTopic, string keystr) {
        string caseSubtype = ACETCallTopicsPicklistUtility.getTTSFilterMap(callTopic).get(keystr);

        // US2091974 - Sanka - Case Creation
        List < String > caseSubtypes = new List < String > ();
        if (caseSubtype != null) {
            caseSubtypes = caseSubtype.split(';');
        }
        return caseSubtypes;
    }

    /**
    @Desc: US1875495 : Case creation
    **/
    //US1970508 - Ravindra
    @AuraEnabled
    public static String saveTTSCase(String strRecord, Boolean isProvider) {

        String strCreatedCaseId = '';

        try {

            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'case'
                AND name =: CASE_RECORD_TYPE_SAE_PROVIDER
            ];
            User userDetails = [SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];

            Case caseObj = new Case();

            String strCaseStatus = 'Open'; // US2148602 - Case Creation - Status of Case Open : Removing 2nd condition - 28/10/2019 - Sarma.
            if (caseWrapper.AddInfoOrginType.equals('Issue Resolved')) {
                strCaseStatus = 'Closed';
            }

            if (caseWrapper.AddInfoOrginType.equals('System Unavailable')) {
                strCaseStatus = 'Closed';
            }

            //US1970508 - Ravindra - start
            // Originator
            caseObj.Originator_name__c = caseWrapper.OriginatorName;
            caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
            caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
            caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
            caseObj.Caller__c = caseWrapper.OriginatorContactName;

            //US2587781 - Avish
            if (String.isNotBlank(caseWrapper.contactNumber)) {
                String phoneFormat = caseWrapper.contactNumber;
                if (String.isNotBlank(caseWrapper.contactExt)) {
                    caseObj.PC_External_Contact_Phone__c = phoneFormat + '	Ext ' + caseWrapper.contactExt;
                } else {
                    caseObj.PC_External_Contact_Phone__c = phoneFormat;
                }
            }
            //US2587781 - Avish - Ends

            //US2678265 - Sarma
            if (String.isNotBlank(caseWrapper.onShoreRestriction) && caseWrapper.onShoreRestriction != null) {
                caseObj.Onshore_Restriction__c = caseWrapper.onShoreRestriction;
            }
            //US2678265 - Sarma Ends

            // Subject
            caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Type__c = caseWrapper.SubjectType;
            caseObj.Relationship__c = caseWrapper.Relationship;
			caseObj.SourceCode__c = caseWrapper.strSourceCode;

            if (caseWrapper.noProviderToSearch != null && caseWrapper.noProviderToSearch) {
                if (caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch) {

                } else if (caseWrapper.mnf == 'mnf') {

                } else {
                    caseObj.ID__c = caseWrapper.SubjectId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                }
            } else if (caseWrapper.providerNotFound != null && caseWrapper.providerNotFound) {
                //Provider not found
                // Originator
                caseObj.ContactId = caseWrapper.providerContactId;
                caseObj.TaxID__c = caseWrapper.TaxId;
                if (caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch) {
                    caseObj.Subject_Type__c = 'Provider';
                } else if (caseWrapper.mnf == 'mnf') {
                    caseObj.Subject_Name__c = caseWrapper.SubjectName;
                    caseObj.ContactId = caseWrapper.memberContactId;
                } else {
                    caseObj.ID__c = caseWrapper.SubjectId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                }
            } else if (caseWrapper.isOtherSearch != null && caseWrapper.isOtherSearch) {
                if (caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch) {
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                } else if (caseWrapper.mnf == 'mnf') {
                    caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.Subject_Name__c = caseWrapper.SubjectName;
                } else {
                    caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.ID__c = caseWrapper.SubjectId;
                }
            } else {
                if (isProvider) {
                    caseObj.Subject_Type__c = 'Provider';
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                }
                // Originator
                caseObj.ID__c = caseWrapper.providerId;
                if (caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch) {
                    caseObj.ContactId = caseWrapper.providerContactId;
                } else if (caseWrapper.mnf == 'mnf') {
                    if (isProvider) {
                        caseObj.ID__c = '';
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        caseObj.ContactId = caseWrapper.memberContactId;
                    }
                } else {
                    if (isProvider) {
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        caseObj.ID__c = caseWrapper.SubjectId;
                        caseObj.ContactId = caseWrapper.memberContactId;
                    }
                }
                // Group/Family ID
                caseObj.TaxID__c = caseWrapper.TaxId;
            }

            if (caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch) {

            } else if (caseWrapper.mnf == 'mnf') {
                caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/');
                //US3172545 - No Provider to Search to MNF - Sravan - Start
                caseObj.ID__c = caseWrapper.SubjectId;
                //US3172545 - No Provider to Search to MNF - Sravan - End
                system.debug('For Member Not Found');
            } else {
                if (!isProvider) {
                    String caseName = String.isNotBlank(caseWrapper.SubjectName) ? caseWrapper.SubjectName.remove(' ') : '';
                    String caseDOB = String.isNotBlank(caseWrapper.SubjectDOB) ? caseWrapper.SubjectDOB.remove('/') : '';
                    caseObj.Surrogate_Key__c = caseName + caseDOB + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                }
            }
            //US1970508 - Ravindra - end
            caseObj.Status = strCaseStatus;

            caseObj.Interaction__c = caseWrapper.Interaction != '' ? caseWrapper.Interaction : null;

            caseObj.RecordTypeId = recordType.Id;
            if (caseWrapper.SubjectDOB != null) {
                if (caseWrapper.SubjectDOB.contains('/')) {
                    caseObj.DOB__c = caseWrapper.SubjectDOB;
                } else {
                    caseObj.DOB__c = SAEUtils.formatDate(caseWrapper.SubjectDOB);
                }
            }
            if (isProvider) {
                caseObj.Subject_Group_ID__c = '';
            } else {
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
            }

            // Additional Information
            //keep this code
            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Type__c = caseWrapper.ttsType;
            caseObj.Subtype__c = caseWrapper.ttsSubType;

            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;

            caseObj.Created_By_Role__c = userDetails.UserRole.Name;

            // US2091974 - Sanka - Case Creation
            caseObj.TaxID__c = caseWrapper.TaxId;

            // US2928159 - Thanish - 2nd Oct 2020 - removed autodoc string.

            insert caseObj;

            //For Autodoc Reporting
            /*if (String.isNotBlank(caseWrapper.savedAutodoc) && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).Disable_Autodoc_Reporting__c ||
                    Organization_Properties__c.getInstance(UserInfo.getUserId()).Disable_Autodoc_Reporting__c ||
                    Organization_Properties__c.getOrgDefaults().Disable_Autodoc_Reporting__c)) {
                createADReporting(caseWrapper.savedAutodoc, caseObj.Id);
            }*/
            //Facets
            String strCaseComments  = '';

            case objCaseRecord = [SELECT id,CaseNumber,PC_ResurrectedLevel__c  FROM Case WHERE id = :caseObj.Id];
            if(caseObj.Id != null && caseWrapper.AddInfoTopic  == 'View Claims' && caseWrapper.ttsType == 'Issue Routed' && caseWrapper.ttsSubType == 'Claims Project 20+ Claims'){
                saveChildCase(caseObj,strRecord,objCaseRecord);
            }
            CaseComment objCaseComment = new CaseComment();
            objCaseComment.ParentId = caseObj.Id;
            system.debug('==caseWrapper.createFacetsCase=='+caseWrapper.createFacetsCase);
            //US3182779 - Sravan
            String facetsComments = caseWrapper.strFacetsRoutingComments != null ? caseWrapper.strFacetsRoutingComments : '';
            if(caseWrapper.createFacetsCase == true && caseWrapper.createORSCase == false) {
                strCaseComments = 'FACETS ID created for ACET Case Number ' + objCaseRecord.CaseNumber + '\n' + (string.isNotBlank(caseWrapper.freeFormCommentsVal) ? caseWrapper.freeFormCommentsVal : '')+ (string.isNotBlank(caseWrapper.relatedCaseItems) ? caseWrapper.relatedCaseItems : '');//US3149404 - Sravan
                if(caseWrapper.ttsType == 'Issue Routed' && (caseWrapper.ttsSubType == 'COB Investigation Initiated' || caseWrapper.ttsSubType == 'Eligibility Investigation Initiated'
                                                            || caseWrapper.ttsSubType == 'Network Management Request')) {
                    //strCaseComments = 'FACETS record and MACESS record' +'\n'+facetsComments+'\n'+'created for ACET Case Number'+ '\n'+ objCaseRecord.CaseNumber+'\n'+(string.isNotBlank(caseWrapper.relatedCaseItems) ? caseWrapper.relatedCaseItems : '');//US3149404 - Sravan
                    strCaseComments = 'FACETS and MACESS record'+'\n'+facetsComments+'has been created for Case Number'+'\n'+objCaseRecord.CaseNumber+'\n'+(string.isNotBlank(caseWrapper.relatedCaseItems) ? caseWrapper.relatedCaseItems : '');//US3149404 - Sravan
                }
            } else if(caseWrapper.createORSCase == true && caseWrapper.createFacetsCase == false) {

                strCaseComments = 'ORS created for ACET Case Number' + ' ' + objCaseRecord.CaseNumber+ '\n' +  (string.isNotBlank(caseWrapper.relatedCaseItems) ? caseWrapper.relatedCaseItems : '');//US3149404 - Sravan

                if(caseObj.Type__c != 'Issue Routed'){
                    strCaseComments = strCaseComments + '\n' + (string.isNotBlank(caseWrapper.freeFormCommentsVal) ? caseWrapper.freeFormCommentsVal : '');
                }
                else{
                    strCaseComments = strCaseComments + '\n' + (string.isNotBlank(caseWrapper.manualEnteredComments) ? caseWrapper.manualEnteredComments: '');

                }
                }
            else if(caseWrapper.createFacetsCase == true && caseWrapper.createORSCase == true){
                 strCaseComments = 'ORS and FACETS are created for ACET Case Number' + ' ' + objCaseRecord.CaseNumber+ '\n'  + (string.isNotBlank(caseWrapper.relatedCaseItems) ? caseWrapper.relatedCaseItems : '');//US3149404 - Sravan
                 if(caseObj.Type__c != 'Issue Routed'){
                    strCaseComments = strCaseComments + '\n' + (string.isNotBlank(caseWrapper.freeFormCommentsVal) ? caseWrapper.freeFormCommentsVal : '');
            }

            }
            system.debug('==Comment=='+objCaseComment.CommentBody);
            objCaseComment.CommentBody = strCaseComments;

            insert objCaseComment;

            strCreatedCaseId = caseObj.Id;

            //US2038277 - Autodoc Integration - Sanka
            if (!String.isEmpty(caseWrapper.savedAutodoc)) {
                addFilesToCase(caseObj.Id, caseWrapper.savedAutodoc);
            }

            // US2119574 - Thanish - 26th Nov 2019 - Added external IDf or empty caseItemsInfo
            String extID = ' ';
            if (!String.isEmpty(caseWrapper.TaxId)) {
                extID = caseWrapper.TaxId;
            }

            //DE3151146 - Sanka - External Id not populating
            if (caseWrapper.mnf == 'mnf') {
                extID = caseWrapper.mnfExternalId;
            }

            //DE315205
            if (caseWrapper.providerNotFound) {
                extID = caseWrapper.pnfExternalId;
            }

            List <SAETTSCaseWrapper.ACETCaseItem > cItems = caseWrapper.caseItems;
            system.debug('Case Items'+ cItems);
            if (cItems != null && !cItems.isEmpty()) {
                //US3071655 - Sravan
                List<SAETTSCaseWrapper.ACETCaseItem> filteredCaseItems = new List<SAETTSCaseWrapper.ACETCaseItem>();
                for(SAETTSCaseWrapper.ACETCaseItem cItem : cItems){
                    if(caseWrapper.AddInfoTopic == cItem.topic){
                        filteredCaseItems.add(cItem);
                    }
                }

            }

            //For Autodoc Reporting - original location
            // if (String.isNotBlank(caseWrapper.savedAutodoc) && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).Disable_Autodoc_Reporting__c ||
            //                                                      Organization_Properties__c.getInstance(UserInfo.getUserId()).Disable_Autodoc_Reporting__c ||
            //                                                      Organization_Properties__c.getOrgDefaults().Disable_Autodoc_Reporting__c)) {
            //                                                          createADReporting(caseWrapper.savedAutodoc, caseObj.Id);
            //                                                      }
            //End
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, '####ERROR:' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '####ERROR LINE:' + e.getLineNumber());
        }
        return strCreatedCaseId;
    }

    // Inserting Autodoc Reporting Objects
    // Sanka : 25.09.2020
    public static void createADReporting(String autodocValue, String caseId) {
        List < Autodoc_Reporting__c > autodocReportingList = new List < Autodoc_Reporting__c > ();
		List < Autodoc_Reporting__c > financialAutodocReportingList = new List < Autodoc_Reporting__c > ();
        // US3429736 - Case Item relationship change
        Map<String,String> caseItemMap = ACET_AutoDocUtil.getCaseItemMap(caseId);
        List < Object > autoDocObjList = (List < Object > ) JSON.deserializeUntyped(autodocValue);
        for (Object obj: autoDocObjList) {
            Map < String, Object > adobj = (Map < String, Object > ) obj;
            String componentType = (String) adobj.get('type');
            if (componentType == 'card') {
                List < Object > cardData = (List < Object > ) adobj.get('cardData');
                for (Object card: cardData) {
                    Map < String, Object > cardField = (Map < String, Object > ) card;
                    if (cardField.get('checked') != null && (Boolean) cardField.get('checked') &&
                        cardField.get('isReportable') != null && (Boolean) cardField.get('isReportable')) {
                        Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
                        reportRecord.Case__c = caseId;
                        String fieldVal = (String) cardField.get('fieldValue');
                        String fieldName = cardField.get('fieldName') != null ? (String) cardField.get('fieldName') : '';
                        String repportingFieldName = cardField.get('reportingFieldName') != null ? (String) cardField.get('reportingFieldName') : fieldName;
                        fieldVal = fieldVal.replace('<br/>', ', ');
                        reportRecord.Field_Name__c = repportingFieldName.length() > 255 ? repportingFieldName.substring(0, 254) : repportingFieldName;
                        reportRecord.Field_Value__c = fieldVal.length() > 255 ? fieldVal.substring(0, 254) : fieldVal;
                            // US3691213
                            String headerName = adobj.get('reportingHeader') != null &&
                                                !String.isBlank((String) adobj.get('reportingHeader')) ? (String) adobj.get('reportingHeader') : (String) adobj.get('componentName');
                            // reportRecord.Component_Name__c = (String) adobj.get('componentName');
                            reportRecord.Component_Name__c = headerName;
                        // US3429736 - Case Item relationship change
                        if(!String.isBlank(caseItemMap.get((String)adobj.get('caseItemsExtId')))){
                            reportRecord.Case_Item__c = caseItemMap.get((String)adobj.get('caseItemsExtId'));
                        }
                        autodocReportingList.add(reportRecord);
                    }
                }
            } else if (componentType == 'table') {
                List < Object > rowData = (List < Object > ) adobj.get('selectedRows');
                List < Object > additionalSectionDataList = (List < Object > ) adobj.get('additionalSectionData');
                List < Object > tableHeaders = (List < Object > ) adobj.get('tableHeaders');
                if (rowData != null) {
                    // US3653575
                    String headerName = adobj.get('reportingHeader') != null &&
                                        !String.isBlank((String) adobj.get('reportingHeader')) ? (String) adobj.get('reportingHeader') : (String) adobj.get('componentName');

                    Boolean isResolvedReportable = (Boolean) adobj.get('isResolvedReportable'); //US2981549
                    for (Object row: rowData) {
                        Map < String, Object > selectedRow = (Map < String, Object > ) row;
                        List < Object > cells = (List < Object > ) selectedRow.get('rowColumnData');
                        if (cells != null) {
                            for (integer i = 0; i < cells.size(); i++) {
                                Map < String, Object > cellData = (Map < String, Object > ) cells.get(i);
                                if (cellData.get('isReportable') != null && (Boolean) cellData.get('isReportable')) {
                                    // US2833912 - Thanish - 27th Oct 2020 - no records found reporting
                                    if(cellData.get('isNoRecords') != null && (Boolean) cellData.get('isNoRecords') && tableHeaders != null) {
                                        for (integer q = 0; q < tableHeaders.size(); q++){
                                            String fieldVal = (String) cellData.get('fieldValue');
                                            String fieldName = (String) tableHeaders.get(q);
                                            Autodoc_Reporting__c noRecordReport = new Autodoc_Reporting__c();
                                            noRecordReport.Case__c = caseId;
                                            noRecordReport.Field_Name__c = fieldName.length() > 255 ? fieldName.substring(0, 254) : fieldName;
                                            noRecordReport.Field_Value__c = fieldVal.length() > 255 ? fieldVal.substring(0, 254) : fieldVal;
                                            // noRecordReport.Component_Name__c = (String) adobj.get('componentName');
                                            // US3653575
                                            noRecordReport.Component_Name__c = headerName;
                                            // US3429736 - Case Item relationship change
                                            if(!String.isBlank(caseItemMap.get((String)selectedRow.get('caseItemsExtId')))){
                                                System.debug((String)selectedRow.get('caseItemsExtId'));
                                                noRecordReport.Case_Item__c = caseItemMap.get((String)selectedRow.get('caseItemsExtId'));
                                            }
                                            autodocReportingList.add(noRecordReport);
                                        }
                                    } else {
                                        String fieldVal = (String) cellData.get('fieldValue');
                                        String fieldName = (String) tableHeaders.get(i);
                                        Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
                                        reportRecord.Case__c = caseId;
                                        reportRecord.Field_Name__c = (String) tableHeaders.get(i);
                                        reportRecord.Field_Value__c = (String) cellData.get('fieldValue');
                                        // reportRecord.Component_Name__c = (String) adobj.get('componentName');
                                        // US3653575
                                        reportRecord.Component_Name__c = headerName;
                                        // US3429736 - Case Item relationship change
                                        System.debug((String)selectedRow.get('caseItemsExtId'));
                                        if(!String.isBlank(caseItemMap.get((String)selectedRow.get('caseItemsExtId')))){
                                            reportRecord.Case_Item__c = caseItemMap.get((String)selectedRow.get('caseItemsExtId'));
                                        }
                                        autodocReportingList.add(reportRecord);
                                    }
                                }
                            }
                        }
                        //US2981549
                        if (isResolvedReportable != null && isResolvedReportable) {
                            Autodoc_Reporting__c resolvedReport = new Autodoc_Reporting__c();
                            resolvedReport.Case__c = caseId;
                            resolvedReport.Field_Name__c = 'RESOLVED';
                            resolvedReport.Field_Value__c = ((Boolean) selectedRow.get('resolved')) ? 'Resolved' : 'Unresolved';
                            // resolvedReport.Component_Name__c = (String) adobj.get('componentName');
                            // US3653575
                            resolvedReport.Component_Name__c = headerName;
                            if(!String.isBlank(caseItemMap.get((String)selectedRow.get('caseItemsExtId')))){
                                resolvedReport.Case_Item__c = caseItemMap.get((String)selectedRow.get('caseItemsExtId'));
                            }
                            autodocReportingList.add(resolvedReport);
                        }
                    }
                }

                if(additionalSectionDataList != null) {
                    for (Object card: additionalSectionDataList) {
                        Map < String, Object > cardField = (Map < String, Object > ) card;
                        if (cardField.get('checked') != null && (Boolean) cardField.get('checked') &&
                            cardField.get('isReportable') != null && (Boolean) cardField.get('isReportable')) {
                                Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
                                reportRecord.Case__c = caseId;
                                String fieldVal = (String) cardField.get('fieldValue');
                                String fieldName = (String) cardField.get('fieldName');
                                fieldVal = fieldVal.replace('<br/>', ', ');
                                reportRecord.Field_Name__c = fieldName.length() > 255 ? fieldName.substring(0, 254) : fieldName;
                                reportRecord.Field_Value__c = fieldVal.length() > 255 ? fieldVal.substring(0, 254) : fieldVal;
                                reportRecord.Component_Name__c = (String) adobj.get('componentName');
                                // US3429736 - Case Item relationship change
                                if(!String.isBlank(caseItemMap.get((String)adobj.get('caseItemsExtId')))){
                                    reportRecord.Case_Item__c = caseItemMap.get((String)adobj.get('caseItemsExtId'));
                                }
                                autodocReportingList.add(reportRecord);
                            }
                    }
                }
            } else if (componentType == 'financials') {
                financialAutodocReportingList = createFinancialsAutodocReport(adobj, caseId);
				autodocReportingList.addAll(financialAutodocReportingList);
            }
        }

        if (!autodocReportingList.isEmpty()) {
            Insert autodocReportingList;
        }
    }

    public static List < Autodoc_Reporting__c > createFinancialsAutodocReport(Map < String, Object > financialObject, String caseId) {
        List < Autodoc_Reporting__c > financialReportList = new List < Autodoc_Reporting__c > ();
        Map<String,String> caseItemMap = ACET_AutoDocUtil.getCaseItemMap(caseId);

        //Family Data
        Object familyData = financialObject.get('Family');
        Map < String, Object > familyMap = (Map < String, Object > ) familyData;
        //Individual Data
        Object individualData = financialObject.get('Individual');
        Map < String, Object > individualMap = (Map < String, Object > ) individualData;

        //Claims Case Item External Id
        String claimsExtId = (String) financialObject.get('claimsExtId');

        //Tier1 Data
        //Family
        Object tieroneFamily = familyMap.get('tierone');
        Map < String, Object > tieroneFamilyMap = (Map < String, Object > ) tieroneFamily;
        //Deductible
        Object tieroneFamilyDeductible = tieroneFamilyMap.get('Deductible');
        Map < String, Object > tieroneFamilyDeductibleMap = (Map < String, Object > ) tieroneFamilyDeductible;
        if ((Boolean) tieroneFamilyDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + tieroneFamilyDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                tieroneFamilyDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                tieroneFamilyDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object tieroneFamilyOOP2 = tieroneFamilyMap.get('OutofPocket2');
        Map < String, Object > tieroneFamilyOOP2Map = (Map < String, Object > ) tieroneFamilyOOP2;
        if ((Boolean) tieroneFamilyOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + tieroneFamilyOOP2Map.get('TotalAmount') + ' Total Amount $' +
                tieroneFamilyOOP2Map.get('RemainingAmount') + ' Remaining $' +
                tieroneFamilyOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object tieroneFamilyOOP = tieroneFamilyMap.get('OutofPocket');
        Map < String, Object > tieroneFamilyOOPMap = (Map < String, Object > ) tieroneFamilyOOP;
        if ((Boolean) tieroneFamilyOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + tieroneFamilyOOPMap.get('TotalAmount') + ' Total Amount $' +
                tieroneFamilyOOPMap.get('RemainingAmount') + ' Remaining $' +
                tieroneFamilyOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object tieroneFamilyMLM = tieroneFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > tieroneFamilyMLMMap = (Map < String, Object > ) tieroneFamilyMLM;
        if ((Boolean) tieroneFamilyMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + tieroneFamilyMLMMap.get('TotalAmount') + ' Total Amount $' +
                tieroneFamilyMLMMap.get('RemainingAmount') + ' Remaining $' +
                tieroneFamilyMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object tieroneFamilyCopayMax = tieroneFamilyMap.get('CopayMax');
        Map < String, Object > tieroneFamilyCopayMaxMap = (Map < String, Object > ) tieroneFamilyCopayMax;
        if ((Boolean) tieroneFamilyCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + tieroneFamilyCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object tieroneFamilyCrsAppOOP = tieroneFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > tieroneFamilyCrsAppOOPMap = (Map < String, Object > ) tieroneFamilyCrsAppOOP;
        if ((Boolean) tieroneFamilyCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) tieroneFamilyCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object tieroneFamilyCrsAppCopay = tieroneFamilyMap.get('CrossApplyCopay');
        Map < String, Object > tieroneFamilyCrsAppCopayMap = (Map < String, Object > ) tieroneFamilyCrsAppCopay;
        if ((Boolean) tieroneFamilyCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) tieroneFamilyCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object tieroneFamilyCrsAppCore = tieroneFamilyMap.get('CrossApplyCore');
        Map < String, Object > tieroneFamilyCrsAppCoreMap = (Map < String, Object > ) tieroneFamilyCrsAppCore;
        if ((Boolean) tieroneFamilyCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) tieroneFamilyCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) tieroneFamilyDeductibleMap.get('isAutodoc') || (Boolean) tieroneFamilyOOP2Map.get('isAutodoc') ||
           (Boolean) tieroneFamilyOOPMap.get('isAutodoc') || (Boolean) tieroneFamilyMLMMap.get('isAutodoc') ||
           (Boolean) tieroneFamilyCopayMaxMap.get('isAutodoc') || (Boolean) tieroneFamilyCrsAppOOPMap.get('isAutodoc') ||
           (Boolean) tieroneFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) tieroneFamilyCrsAppCoreMap.get('isAutodoc')) {
               Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
               reportRecord.Case__c = caseId;
               if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                   reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
               }
               reportRecord.Field_Name__c = ASOFDATE;
               reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
               reportRecord.Component_Name__c = 'Financials - Tier1 - Family';
               financialReportList.add(reportRecord);
           }

        //Individual
        Object tieroneIndividual = individualMap.get('tierone');
        Map < String, Object > tieroneIndividualMap = (Map < String, Object > ) tieroneIndividual;
        //Deductible
        Object tieroneIndividualDeductible = tieroneIndividualMap.get('Deductible');
        Map < String, Object > tieroneIndividualDeductibleMap = (Map < String, Object > ) tieroneIndividualDeductible;
        if ((Boolean) tieroneIndividualDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + tieroneIndividualDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                tieroneIndividualDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                tieroneIndividualDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object tieroneIndividualOOP2 = tieroneIndividualMap.get('OutofPocket2');
        Map < String, Object > tieroneIndividualOOP2Map = (Map < String, Object > ) tieroneIndividualOOP2;
        if ((Boolean) tieroneIndividualOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + tieroneIndividualOOP2Map.get('TotalAmount') + ' Total Amount $' +
                tieroneIndividualOOP2Map.get('RemainingAmount') + ' Remaining $' +
                tieroneIndividualOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object tieroneIndividualOOP = tieroneIndividualMap.get('OutofPocket');
        Map < String, Object > tieroneIndividualOOPMap = (Map < String, Object > ) tieroneIndividualOOP;
        if ((Boolean) tieroneIndividualOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + tieroneIndividualOOPMap.get('TotalAmount') + ' Total Amount $' +
                tieroneIndividualOOPMap.get('RemainingAmount') + ' Remaining $' +
                tieroneIndividualOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object tieroneIndividualMLM = tieroneIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > tieroneIndividualMLMMap = (Map < String, Object > ) tieroneIndividualMLM;
        if ((Boolean) tieroneIndividualMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + tieroneIndividualMLMMap.get('TotalAmount') + ' Total Amount $' +
                tieroneIndividualMLMMap.get('RemainingAmount') + ' Remaining $' +
                tieroneIndividualMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object tieroneIndividualCopayMax = tieroneIndividualMap.get('CopayMax');
        Map < String, Object > tieroneIndividualCopayMaxMap = (Map < String, Object > ) tieroneIndividualCopayMax;
        if ((Boolean) tieroneIndividualCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + tieroneIndividualCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object tieroneIndividualCrsAppOOP = tieroneIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > tieroneIndividualCrsAppOOPMap = (Map < String, Object > ) tieroneIndividualCrsAppOOP;
        if ((Boolean) tieroneIndividualCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) tieroneIndividualCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object tieroneIndividualCrsAppCopay = tieroneIndividualMap.get('CrossApplyCopay');
        Map < String, Object > tieroneIndividualCrsAppCopayMap = (Map < String, Object > ) tieroneIndividualCrsAppCopay;
        if ((Boolean) tieroneIndividualCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) tieroneIndividualCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object tieroneIndividualCrsAppCore = tieroneIndividualMap.get('CrossApplyCore');
        Map < String, Object > tieroneIndividualCrsAppCoreMap = (Map < String, Object > ) tieroneIndividualCrsAppCore;
        if ((Boolean) tieroneIndividualCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) tieroneIndividualCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) tieroneIndividualDeductibleMap.get('isAutodoc') || (Boolean) tieroneIndividualOOP2Map.get('isAutodoc') ||
           (Boolean) tieroneIndividualOOPMap.get('isAutodoc') || (Boolean) tieroneIndividualMLMMap.get('isAutodoc') ||
           (Boolean) tieroneIndividualCopayMaxMap.get('isAutodoc') || (Boolean) tieroneIndividualCrsAppOOPMap.get('isAutodoc') ||
           (Boolean) tieroneIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) tieroneIndividualCrsAppCoreMap.get('isAutodoc')) {
               Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
               reportRecord.Case__c = caseId;
               if(!String.isBlank(caseItemMap.get(FinancialTier1))) {
                   reportRecord.Case_Item__c = caseItemMap.get(FinancialTier1);
               }
               reportRecord.Field_Name__c = ASOFDATE;
               reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
               reportRecord.Component_Name__c = 'Financials - Tier1 - Individual';
               financialReportList.add(reportRecord);
           }

        //INN data
        //Family
        Object inNetworkFamily = familyMap.get('inNetwork');
        Map < String, Object > inNetworkFamilyMap = (Map < String, Object > ) inNetworkFamily;
        //Deductible
        Object inNetworkFamilyDeductible = inNetworkFamilyMap.get('Deductible');
        Map < String, Object > inNetworkFamilyDeductibleMap = (Map < String, Object > ) inNetworkFamilyDeductible;
        if ((Boolean) inNetworkFamilyDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + inNetworkFamilyDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkFamilyDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkFamilyDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object inNetworkFamilyOOP2 = inNetworkFamilyMap.get('OutofPocket2');
        Map < String, Object > inNetworkFamilyOOP2Map = (Map < String, Object > ) inNetworkFamilyOOP2;
        if ((Boolean) inNetworkFamilyOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + inNetworkFamilyOOP2Map.get('TotalAmount') + ' Total Amount $' +
                inNetworkFamilyOOP2Map.get('RemainingAmount') + ' Remaining $' +
                inNetworkFamilyOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object inNetworkFamilyOOP = inNetworkFamilyMap.get('OutofPocket');
        Map < String, Object > inNetworkFamilyOOPMap = (Map < String, Object > ) inNetworkFamilyOOP;
        if ((Boolean) inNetworkFamilyOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + inNetworkFamilyOOPMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkFamilyOOPMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkFamilyOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object inNetworkFamilyMLM = inNetworkFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > inNetworkFamilyMLMMap = (Map < String, Object > ) inNetworkFamilyMLM;
        if ((Boolean) inNetworkFamilyMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + inNetworkFamilyMLMMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkFamilyMLMMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkFamilyMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object inNetworkFamilyCopayMax = inNetworkFamilyMap.get('CopayMax');
        Map < String, Object > inNetworkFamilyCopayMaxMap = (Map < String, Object > ) inNetworkFamilyCopayMax;
        if ((Boolean) inNetworkFamilyCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + inNetworkFamilyCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object inNetworkFamilyCrsAppOOP = inNetworkFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > inNetworkFamilyCrsAppOOPMap = (Map < String, Object > ) inNetworkFamilyCrsAppOOP;
        if ((Boolean) inNetworkFamilyCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) inNetworkFamilyCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object inNetworkFamilyCrsAppCopay = inNetworkFamilyMap.get('CrossApplyCopay');
        Map < String, Object > inNetworkFamilyCrsAppCopayMap = (Map < String, Object > ) inNetworkFamilyCrsAppCopay;
        if ((Boolean) inNetworkFamilyCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) inNetworkFamilyCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object inNetworkFamilyCrsAppCore = inNetworkFamilyMap.get('CrossApplyCore');
        Map < String, Object > inNetworkFamilyCrsAppCoreMap = (Map < String, Object > ) inNetworkFamilyCrsAppCore;
        if ((Boolean) inNetworkFamilyCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) inNetworkFamilyCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CombinedDeductible
        Object inNetworkFamilyCombinedDeductible = inNetworkFamilyMap.get('CombinedDeductible');
        Map < String, Object > inNetworkFamilyCombinedDeductibleMap = (Map < String, Object > ) inNetworkFamilyCombinedDeductible;
        if ((Boolean) inNetworkFamilyCombinedDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Combined Deductible';
            reportRecord.Field_Value__c = (String) inNetworkFamilyCombinedDeductibleMap.get('comDedVal');
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }
        //CombinedOOP
        Object inNetworkFamilyCombinedOOP = inNetworkFamilyMap.get('CombinedOOP');
        Map < String, Object > inNetworkFamilyCombinedOOPMap = (Map < String, Object > ) inNetworkFamilyCombinedOOP;
        if ((Boolean) inNetworkFamilyCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Combined Out of Pocket';
            reportRecord.Field_Value__c = (String) inNetworkFamilyCombinedOOPMap.get('comOopVal');
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) inNetworkFamilyDeductibleMap.get('isAutodoc') || (Boolean) inNetworkFamilyOOP2Map.get('isAutodoc') ||
          (Boolean) inNetworkFamilyOOPMap.get('isAutodoc') || (Boolean) inNetworkFamilyMLMMap.get('isAutodoc') ||
          (Boolean) inNetworkFamilyCopayMaxMap.get('isAutodoc') || (Boolean) inNetworkFamilyCrsAppOOPMap.get('isAutodoc') ||
          (Boolean) inNetworkFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) inNetworkFamilyCrsAppCoreMap.get('isAutodoc') ||
          (Boolean) inNetworkFamilyCombinedDeductibleMap.get('isAutodoc') || (Boolean) inNetworkFamilyCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = ASOFDATE;
            reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
            reportRecord.Component_Name__c = 'Financials - INN - Family';
            financialReportList.add(reportRecord);
        }

        //Individual
        Object inNetworkIndividual = individualMap.get('inNetwork');
        Map < String, Object > inNetworkIndividualMap = (Map < String, Object > ) inNetworkIndividual;
        //Deductible
        Object inNetworkIndividualDeductible = inNetworkIndividualMap.get('Deductible');
        Map < String, Object > inNetworkIndividualDeductibleMap = (Map < String, Object > ) inNetworkIndividualDeductible;
        if ((Boolean) inNetworkIndividualDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + inNetworkIndividualDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkIndividualDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkIndividualDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object inNetworkIndividualOOP2 = inNetworkIndividualMap.get('OutofPocket2');
        Map < String, Object > inNetworkIndividualOOP2Map = (Map < String, Object > ) inNetworkIndividualOOP2;
        if ((Boolean) inNetworkIndividualOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + inNetworkIndividualOOP2Map.get('TotalAmount') + ' Total Amount $' +
                inNetworkIndividualOOP2Map.get('RemainingAmount') + ' Remaining $' +
                inNetworkIndividualOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object inNetworkIndividualOOP = inNetworkIndividualMap.get('OutofPocket');
        Map < String, Object > inNetworkIndividualOOPMap = (Map < String, Object > ) inNetworkIndividualOOP;
        if ((Boolean) inNetworkIndividualOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + inNetworkIndividualOOPMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkIndividualOOPMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkIndividualOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object inNetworkIndividualMLM = inNetworkIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > inNetworkIndividualMLMMap = (Map < String, Object > ) inNetworkIndividualMLM;
        if ((Boolean) inNetworkIndividualMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + inNetworkIndividualMLMMap.get('TotalAmount') + ' Total Amount $' +
                inNetworkIndividualMLMMap.get('RemainingAmount') + ' Remaining $' +
                inNetworkIndividualMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object inNetworkIndividualCopayMax = inNetworkIndividualMap.get('CopayMax');
        Map < String, Object > inNetworkIndividualCopayMaxMap = (Map < String, Object > ) inNetworkIndividualCopayMax;
        if ((Boolean) inNetworkIndividualCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + inNetworkIndividualCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object inNetworkIndividualCrsAppOOP = inNetworkIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > inNetworkIndividualCrsAppOOPMap = (Map < String, Object > ) inNetworkIndividualCrsAppOOP;
        if ((Boolean) inNetworkIndividualCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) inNetworkIndividualCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object inNetworkIndividualCrsAppCopay = inNetworkIndividualMap.get('CrossApplyCopay');
        Map < String, Object > inNetworkIndividualCrsAppCopayMap = (Map < String, Object > ) inNetworkIndividualCrsAppCopay;
        if ((Boolean) inNetworkIndividualCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) inNetworkIndividualCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object inNetworkIndividualCrsAppCore = inNetworkIndividualMap.get('CrossApplyCore');
        Map < String, Object > inNetworkIndividualCrsAppCoreMap = (Map < String, Object > ) inNetworkIndividualCrsAppCore;
        if ((Boolean) inNetworkIndividualCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) inNetworkIndividualCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CombinedDeductible
        Object inNetworkIndividualCombinedDeductible = inNetworkIndividualMap.get('CombinedDeductible');
        Map < String, Object > inNetworkIndividualCombinedDeductibleMap = (Map < String, Object > ) inNetworkIndividualCombinedDeductible;
        if ((Boolean) inNetworkIndividualCombinedDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Combined Deductible';
            reportRecord.Field_Value__c = (String) inNetworkIndividualCombinedDeductibleMap.get('comDedVal');
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }
        //CombinedOOP
        Object inNetworkIndividualCombinedOOP = inNetworkIndividualMap.get('CombinedOOP');
        Map < String, Object > inNetworkIndividualCombinedOOPMap = (Map < String, Object > ) inNetworkIndividualCombinedOOP;
        if ((Boolean) inNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
            }
            reportRecord.Field_Name__c = 'Combined Out of Pocket';
            reportRecord.Field_Value__c = (String) inNetworkIndividualCombinedOOPMap.get('comOopVal');
            reportRecord.Component_Name__c = 'Financials - INN - Individual';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) inNetworkIndividualDeductibleMap.get('isAutodoc') || (Boolean) inNetworkIndividualOOP2Map.get('isAutodoc') ||
           (Boolean) inNetworkIndividualOOPMap.get('isAutodoc') || (Boolean) inNetworkIndividualMLMMap.get('isAutodoc') ||
           (Boolean) inNetworkIndividualCopayMaxMap.get('isAutodoc') || (Boolean) inNetworkIndividualCrsAppOOPMap.get('isAutodoc') ||
           (Boolean) inNetworkIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) inNetworkIndividualCrsAppCoreMap.get('isAutodoc') ||
           (Boolean) inNetworkIndividualCombinedDeductibleMap.get('isAutodoc') || (Boolean) inNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
               Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
               reportRecord.Case__c = caseId;
               if(!String.isBlank(caseItemMap.get(FinancialINN))) {
                   reportRecord.Case_Item__c = caseItemMap.get(FinancialINN);
               }
               reportRecord.Field_Name__c = ASOFDATE;
               reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
               reportRecord.Component_Name__c = 'Financials - INN - Individual';
               financialReportList.add(reportRecord);
           }

        //OON data
        //Family
        Object outofNetworkFamily = familyMap.get('outofNetwork');
        Map < String, Object > outofNetworkFamilyMap = (Map < String, Object > ) outofNetworkFamily;
        //Deductible
        Object outofNetworkFamilyDeductible = outofNetworkFamilyMap.get('Deductible');
        Map < String, Object > outofNetworkFamilyDeductibleMap = (Map < String, Object > ) outofNetworkFamilyDeductible;
        if ((Boolean) outofNetworkFamilyDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + outofNetworkFamilyDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkFamilyDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkFamilyDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object outofNetworkFamilyOOP2 = outofNetworkFamilyMap.get('OutofPocket2');
        Map < String, Object > outofNetworkFamilyOOP2Map = (Map < String, Object > ) outofNetworkFamilyOOP2;
        if ((Boolean) outofNetworkFamilyOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + outofNetworkFamilyOOP2Map.get('TotalAmount') + ' Total Amount $' +
                outofNetworkFamilyOOP2Map.get('RemainingAmount') + ' Remaining $' +
                outofNetworkFamilyOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object outofNetworkFamilyOOP = outofNetworkFamilyMap.get('OutofPocket');
        Map < String, Object > outofNetworkFamilyOOPMap = (Map < String, Object > ) outofNetworkFamilyOOP;
        if ((Boolean) outofNetworkFamilyOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + outofNetworkFamilyOOPMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkFamilyOOPMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkFamilyOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object outofNetworkFamilyMLM = outofNetworkFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > outofNetworkFamilyMLMMap = (Map < String, Object > ) outofNetworkFamilyMLM;
        if ((Boolean) outofNetworkFamilyMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + outofNetworkFamilyMLMMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkFamilyMLMMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkFamilyMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object outofNetworkFamilyCopayMax = outofNetworkFamilyMap.get('CopayMax');
        Map < String, Object > outofNetworkFamilyCopayMaxMap = (Map < String, Object > ) outofNetworkFamilyCopayMax;
        if ((Boolean) outofNetworkFamilyCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + outofNetworkFamilyCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object outofNetworkFamilyCrsAppOOP = outofNetworkFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > outofNetworkFamilyCrsAppOOPMap = (Map < String, Object > ) outofNetworkFamilyCrsAppOOP;
        if ((Boolean) outofNetworkFamilyCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) outofNetworkFamilyCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object outofNetworkFamilyCrsAppCopay = outofNetworkFamilyMap.get('CrossApplyCopay');
        Map < String, Object > outofNetworkFamilyCrsAppCopayMap = (Map < String, Object > ) outofNetworkFamilyCrsAppCopay;
        if ((Boolean) outofNetworkFamilyCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) outofNetworkFamilyCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object outofNetworkFamilyCrsAppCore = outofNetworkFamilyMap.get('CrossApplyCore');
        Map < String, Object > outofNetworkFamilyCrsAppCoreMap = (Map < String, Object > ) outofNetworkFamilyCrsAppCore;
        if ((Boolean) outofNetworkFamilyCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) outofNetworkFamilyCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CombinedDeductible
        Object outofNetworkFamilyCombinedDeductible = outofNetworkFamilyMap.get('CombinedDeductible');
        Map < String, Object > outofNetworkFamilyCombinedDeductibleMap = (Map < String, Object > ) outofNetworkFamilyCombinedDeductible;
        if ((Boolean) outofNetworkFamilyCombinedDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Combined Deductible';
            reportRecord.Field_Value__c = (String) outofNetworkFamilyCombinedDeductibleMap.get('comDedVal');
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }
        //CombinedOOP
        Object outofNetworkFamilyCombinedOOP = outofNetworkFamilyMap.get('CombinedOOP');
        Map < String, Object > outofNetworkFamilyCombinedOOPMap = (Map < String, Object > ) outofNetworkFamilyCombinedOOP;
        if ((Boolean) outofNetworkFamilyCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Combined Out of Pocket';
            reportRecord.Field_Value__c = (String) outofNetworkFamilyCombinedOOPMap.get('comOopVal');
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) outofNetworkFamilyDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkFamilyOOP2Map.get('isAutodoc') ||
          (Boolean) outofNetworkFamilyOOPMap.get('isAutodoc') || (Boolean) outofNetworkFamilyMLMMap.get('isAutodoc') ||
          (Boolean) outofNetworkFamilyCopayMaxMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCrsAppOOPMap.get('isAutodoc') ||
          (Boolean) outofNetworkFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCrsAppCoreMap.get('isAutodoc') ||
          (Boolean) outofNetworkFamilyCombinedDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = ASOFDATE;
            reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
            reportRecord.Component_Name__c = 'Financials - OON - Family';
            financialReportList.add(reportRecord);
        }

        //Individual
        Object outofNetworkIndividual = individualMap.get('outofNetwork');
        Map < String, Object > outofNetworkIndividualMap = (Map < String, Object > ) outofNetworkIndividual;
        //Deductible
        Object outofNetworkIndividualDeductible = outofNetworkIndividualMap.get('Deductible');
        Map < String, Object > outofNetworkIndividualDeductibleMap = (Map < String, Object > ) outofNetworkIndividualDeductible;
        if ((Boolean) outofNetworkIndividualDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Deductible';
            reportRecord.Field_Value__c = '$' + outofNetworkIndividualDeductibleMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkIndividualDeductibleMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkIndividualDeductibleMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket2
        Object outofNetworkIndividualOOP2 = outofNetworkIndividualMap.get('OutofPocket2');
        Map < String, Object > outofNetworkIndividualOOP2Map = (Map < String, Object > ) outofNetworkIndividualOOP2;
        if ((Boolean) outofNetworkIndividualOOP2Map.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket 2';
            reportRecord.Field_Value__c = '$' + outofNetworkIndividualOOP2Map.get('TotalAmount') + ' Total Amount $' +
                outofNetworkIndividualOOP2Map.get('RemainingAmount') + ' Remaining $' +
                outofNetworkIndividualOOP2Map.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //OutofPocket
        Object outofNetworkIndividualOOP = outofNetworkIndividualMap.get('OutofPocket');
        Map < String, Object > outofNetworkIndividualOOPMap = (Map < String, Object > ) outofNetworkIndividualOOP;
        if ((Boolean) outofNetworkIndividualOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Out-of-Pocket';
            reportRecord.Field_Value__c = '$' + outofNetworkIndividualOOPMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkIndividualOOPMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkIndividualOOPMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //MedicalLifeMaximum
        Object outofNetworkIndividualMLM = outofNetworkIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > outofNetworkIndividualMLMMap = (Map < String, Object > ) outofNetworkIndividualMLM;
        if ((Boolean) outofNetworkIndividualMLMMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Medical Life Maximum';
            reportRecord.Field_Value__c = '$' + outofNetworkIndividualMLMMap.get('TotalAmount') + ' Total Amount $' +
                outofNetworkIndividualMLMMap.get('RemainingAmount') + ' Remaining $' +
                outofNetworkIndividualMLMMap.get('SpentAmount') + ' Satisfied';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CopayMax
        Object outofNetworkIndividualCopayMax = outofNetworkIndividualMap.get('CopayMax');
        Map < String, Object > outofNetworkIndividualCopayMaxMap = (Map < String, Object > ) outofNetworkIndividualCopayMax;
        if ((Boolean) outofNetworkIndividualCopayMaxMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Copay Max';
            reportRecord.Field_Value__c = '$' + outofNetworkIndividualCopayMaxMap.get('TotalAmount') + ' Total Amount';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyOutofPocket
        Object outofNetworkIndividualCrsAppOOP = outofNetworkIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > outofNetworkIndividualCrsAppOOPMap = (Map < String, Object > ) outofNetworkIndividualCrsAppOOP;
        if ((Boolean) outofNetworkIndividualCrsAppOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Out of Pocket';
            reportRecord.Field_Value__c = (Integer) outofNetworkIndividualCrsAppOOPMap.get('crsAplOopSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCopay
        Object outofNetworkIndividualCrsAppCopay = outofNetworkIndividualMap.get('CrossApplyCopay');
        Map < String, Object > outofNetworkIndividualCrsAppCopayMap = (Map < String, Object > ) outofNetworkIndividualCrsAppCopay;
        if ((Boolean) outofNetworkIndividualCrsAppCopayMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Copay';
            reportRecord.Field_Value__c = (Integer) outofNetworkIndividualCrsAppCopayMap.get('crsAplCopySignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CrossApplyCore
        Object outofNetworkIndividualCrsAppCore = outofNetworkIndividualMap.get('CrossApplyCore');
        Map < String, Object > outofNetworkIndividualCrsAppCoreMap = (Map < String, Object > ) outofNetworkIndividualCrsAppCore;
        if ((Boolean) outofNetworkIndividualCrsAppCoreMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Cross Apply Core';
            reportRecord.Field_Value__c = (Integer) outofNetworkIndividualCrsAppCoreMap.get('crsAplCoreSignVal') > 0 ? 'Y' : 'N';
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CombinedDeductible
        Object outofNetworkIndividualCombinedDeductible = outofNetworkIndividualMap.get('CombinedDeductible');
        Map < String, Object > outofNetworkIndividualCombinedDeductibleMap = (Map < String, Object > ) outofNetworkIndividualCombinedDeductible;
        if ((Boolean) outofNetworkIndividualCombinedDeductibleMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Combined Deductible';
            reportRecord.Field_Value__c = (String) outofNetworkIndividualCombinedDeductibleMap.get('comDedVal');
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }
        //CombinedOOP
        Object outofNetworkIndividualCombinedOOP = outofNetworkIndividualMap.get('CombinedOOP');
        Map < String, Object > outofNetworkIndividualCombinedOOPMap = (Map < String, Object > ) outofNetworkIndividualCombinedOOP;
        if ((Boolean) outofNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = 'Combined Out of Pocket';
            reportRecord.Field_Value__c = (String) outofNetworkIndividualCombinedOOPMap.get('comOopVal');
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }

        //As of Date
        if((Boolean) outofNetworkIndividualDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkIndividualOOP2Map.get('isAutodoc') ||
          (Boolean) outofNetworkIndividualOOPMap.get('isAutodoc') || (Boolean) outofNetworkIndividualMLMMap.get('isAutodoc') ||
          (Boolean) outofNetworkIndividualCopayMaxMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCrsAppOOPMap.get('isAutodoc') ||
          (Boolean) outofNetworkIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCrsAppCoreMap.get('isAutodoc') ||
          (Boolean) outofNetworkIndividualCombinedDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
            Autodoc_Reporting__c reportRecord = new Autodoc_Reporting__c();
            reportRecord.Case__c = caseId;
            if(!String.isBlank(caseItemMap.get(FinancialOON))) {
                reportRecord.Case_Item__c = caseItemMap.get(FinancialOON);
            }
            reportRecord.Field_Name__c = ASOFDATE;
            reportRecord.Field_Value__c = (String)financialObject.get('financialDate');
            reportRecord.Component_Name__c = 'Financials - OON - Individual';
            financialReportList.add(reportRecord);
        }

        //Claims External Id
        if(claimsExtId != null && !String.isEmpty(claimsExtId) && !String.isBlank(caseItemMap.get(claimsExtId))){
            for(Autodoc_Reporting__c ar : financialReportList){
                ar.Case_Item__c = caseItemMap.get(claimsExtId);
            }
        }

        return financialReportList;
    }

    public static void insertCaseItems(String caseId, List < SAETTSCaseWrapper.ACETCaseItem > cItems) {
        List < Case > cse = [SELECT id, Topic__c, Type__c, subtype__c FROM Case WHERE id =: caseId];
        if (!cse.isEmpty()) {
            Case relatedCase = cse.get(0);
            List < Case_Item__c > caseItems = new List < Case_Item__c > ();
            for (SAETTSCaseWrapper.ACETCaseItem item: cItems) {
                Case_Item__c ci = new Case_Item__c();
                ci.Case__c = caseId;
                ci.ExternalID__c = item.uniqueKey.length() > 255 ? item.uniqueKey.substring(0,254) : item.uniqueKey;
                ci.tax_id__c = '';
                if (relatedCase.Type__c == 'System Unavailable' || relatedCase.Type__c == 'Issue Resolved') {
                    ci.Resolved__c = true;
                } else {
                    ci.Resolved__c = item.isResolved;
                }
                ci.Resolved_Reason__c = ci.Resolved__c ? 'Resolved' : '';
                ci.Type__c = relatedCase.Type__c;
                ci.Subtype__c = relatedCase.Subtype__c;

                caseItems.add(ci);
            }
            if (Case_Item__c.SObjectType.getDescribe().isCreateable()) {
                insert caseItems;
            }
        }
    }

    //US2038277 - Autodoc Integration - Sanka
    public static void addFilesToCase(String caseId, String Autodoc) {

        Case cId = [Select Id, CaseNumber from
            case where Id = :
                caseId
        ];

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'autodoc.html'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Autodoc ' + cId.CaseNumber; // Display name of the files
        conVer.VersionData = blob.valueof(Autodoc); // converting your binary string to Blog
        insert conVer;

        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: conVer.Id].ContentDocumentId;

        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = caseId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I';
        insert cDe;

    }

    //US3074131
    public static string processAddressDataForProviderLookupExternalId( Map < String, Object > row){
        string finalExternalId =  String.valueOf(row.get('caseItemsExtId')) ;
        string providerExternalId = String.valueOf(row.get('caseItemsExtId')) != NULL ? String.valueOf(row.get('caseItemsExtId')).trim(): '';
        List<Object> lstofRowData =  (List<Object>) row.get('rowColumnData');
        if(lstofRowData != NULL && lstofRowData.size() >= 7 ){
        Map < String, Object > addressData = (Map < String, Object > ) lstofRowData.get(6);
        string mergedExternalid = providerExternalId +' - '+ (string.valueof(addressData.get('fieldValue')) != NULL ? string.valueof(addressData.get('fieldValue')).trim() : '') ;
        if(mergedExternalid.length() >= 255) finalExternalId = mergedExternalid.substring(0,254);
        else finalExternalId = mergedExternalid;
        }
        return finalExternalId;
    }
    // US2431041 - Thanish - 29th Apr 2020
    public static void addCaseItems(String caseId, String caseItemsInfo, String ttsType, String ttsSubType, String extID, String infoTopic, String AutoDocJSON) {
        // Mod by Sanka - US3125332
        List <case>cse = [select id,Topic__c,Type__c, subtype__c, (SELECT Id FROM Work_Items__r) from Case where id =: caseId];
        Case caseRecord = cse.get(0);
        List < Case_Item__c > caseItems = new List < Case_Item__c > ();
        List < Case_Item__c > existingCaseItems = caseRecord.Work_Items__r;
		List < Case_Item__c > financialCaseItems = new List < Case_Item__c > ();
        List < Object > caseStrMap = (List < Object > ) JSON.deserializeUntyped(AutoDocJSON);
        Map<String,String> topicToKey = new Map<String,String> {
            'View Authorizations' => 'Authorizations',
            'View PCP Referrals' => 'Referrals',
            'View Claims' => 'Claims',
            'Provider Lookup' => 'Provider Not Found'
        };
        for (Object obj: caseStrMap) {
            Map < String, Object > ob = (Map < String, Object > ) obj;
            String componentType = (String) ob.get('type');
            // Get topic of the table
            String tblTopic = (String) ob.get('callTopic');

            Boolean caseItemsEnabled = ob.get('caseItemsEnabled') != null ? (Boolean) ob.get('caseItemsEnabled') : false;
            if (componentType == 'financials') {
                String policyNumber = (String) ob.get('policyNumber');
                financialCaseItems = CreateCaseItemsForFinancials(ob, caseId, policyNumber);
                caseItems.addall(financialCaseItems);
            }
            if (caseItemsEnabled) {
                String externalId = (String) ob.get('caseItemExtId');
                List < Object > selectedRows = (List < Object > ) ob.get('selectedRows');
                if (externalId != null && externalId != '') {
                    Case_Item__c ci = new Case_Item__c();
                    ci.Case__c = caseId;
                    ci.ExternalID__c = externalId.length() > 255 ? externalId.substring(0, 254) : externalId;
                    ci.tax_id__c = extID;
                    ci.Resolved__c = true;
                    ci.Resolved_Reason__c = 'Resolved';
                    ci.Type__c = ttsType;
                    ci.Subtype__c = ttsSubType;
                    caseItems.add(ci);
                } else if (selectedRows != null) {
                    for (Object s_row: selectedRows) {
                        Map < String, Object > row = (Map < String, Object > ) s_row;
                        String extnId = String.valueOf(row.get('caseItemsExtId'));
                        Case_Item__c ci = new Case_Item__c();
                        ci.Case__c = caseId;
                        ci.ExternalID__c = extnId.length() > 255 ? extnId.substring(0, 254) : extnId;
                         //US3074131
                         //moved to lookup controller
                        //if(string.isNotBlank(infoTopic) && infoTopic.contains('Provider Lookup'))  ci.ExternalID__c = processAddressDataForProviderLookupExternalId(row);
                        ci.tax_id__c = extID;
                        if (ttsType == 'System Unavailable' || ttsType == 'Issue Resolved' || ttsType == 'Research') {//DE391207 - Sravan
                            ci.Resolved__c = true;
                        } else {
                            ci.Resolved__c = row.get('resolved') != null ? (Boolean) row.get('resolved') : false;
                        }
                        ci.Resolved_Reason__c = ci.Resolved__c ? 'Resolved' : '';
                        ci.Type__c = ttsType;
                        ci.Subtype__c = ttsSubType;
                        caseItems.add(ci);
                    }

                    // Avoid unnecessary case items
                    if (selectedRows.isEmpty() && existingCaseItems.size() == 0 && (tblTopic != null && tblTopic.equals(caseRecord.Topic__c))) {
                        // Added by Jay for adding case item when no rows selected
                        // US3125332 - Sanka
                        // Topic specific default case item Ext Id
                        Case_Item__c ci = new Case_Item__c();
                        ci.Case__c = caseId;
                        ci.ExternalID__c = topicToKey.containsKey(caseRecord.Topic__c) ? topicToKey.get(caseRecord.Topic__c) : '';
                        ci.Resolved__c = true;
                        ci.Resolved_Reason__c = 'Resolved';
                        ci.Type__c = ttsType;
                        ci.Subtype__c = ttsSubType;
                        caseItems.add(ci);
                    }
                }
            }
        }

        //De421979
        if (caseItems.isEmpty() && existingCaseItems.size() == 0) {
            // Added by Jay for adding case item when no rows selected
            Case_Item__c ci = new Case_Item__c();
            ci.Case__c = caseId;
            ci.ExternalID__c = topicToKey.containsKey(caseRecord.Topic__c) ? topicToKey.get(caseRecord.Topic__c) : '';
            ci.Resolved__c = true;
            ci.Resolved_Reason__c = 'Resolved';
            ci.Type__c = ttsType;
            ci.Subtype__c = ttsSubType;
            caseItems.add(ci);
        }

        if (Case_Item__c.SObjectType.getDescribe().isCreateable()) {
            insert caseItems;
        }
    }

	//Case items for Financials
    public static List < Case_Item__c > CreateCaseItemsForFinancials(Map < String, Object > financialObject, String caseId, String policyNumber) {
        Case caseRecord = [SELECT Id, Type__c, subtype__c FROM Case WHERE ID =: caseId];
        List < Case_Item__c > caseItems = new List < Case_Item__c > ();
        //Family Data
        Object familyData = financialObject.get('Family');
        Map < String, Object > familyMap = (Map < String, Object > ) familyData;
        //Individual Data
        Object individualData = financialObject.get('Individual');
        Map < String, Object > individualMap = (Map < String, Object > ) individualData;

        //Tier1 Data
        //Family
        Object tieroneFamily = familyMap.get('tierone');
        Map < String, Object > tieroneFamilyMap = (Map < String, Object > ) tieroneFamily;
        //Deductible
        Object tieroneFamilyDeductible = tieroneFamilyMap.get('Deductible');
        Map < String, Object > tieroneFamilyDeductibleMap = (Map < String, Object > ) tieroneFamilyDeductible;
        //OutofPocket2
        Object tieroneFamilyOOP2 = tieroneFamilyMap.get('OutofPocket2');
        Map < String, Object > tieroneFamilyOOP2Map = (Map < String, Object > ) tieroneFamilyOOP2;
        //OutofPocket
        Object tieroneFamilyOOP = tieroneFamilyMap.get('OutofPocket');
        Map < String, Object > tieroneFamilyOOPMap = (Map < String, Object > ) tieroneFamilyOOP;
        //MedicalLifeMaximum
        Object tieroneFamilyMLM = tieroneFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > tieroneFamilyMLMMap = (Map < String, Object > ) tieroneFamilyMLM;
        //CopayMax
        Object tieroneFamilyCopayMax = tieroneFamilyMap.get('CopayMax');
        Map < String, Object > tieroneFamilyCopayMaxMap = (Map < String, Object > ) tieroneFamilyCopayMax;
        //CrossApplyOutofPocket
        Object tieroneFamilyCrsAppOOP = tieroneFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > tieroneFamilyCrsAppOOPMap = (Map < String, Object > ) tieroneFamilyCrsAppOOP;
        //CrossApplyCopay
        Object tieroneFamilyCrsAppCopay = tieroneFamilyMap.get('CrossApplyCopay');
        Map < String, Object > tieroneFamilyCrsAppCopayMap = (Map < String, Object > ) tieroneFamilyCrsAppCopay;
        //CrossApplyCore
        Object tieroneFamilyCrsAppCore = tieroneFamilyMap.get('CrossApplyCore');
        Map < String, Object > tieroneFamilyCrsAppCoreMap = (Map < String, Object > ) tieroneFamilyCrsAppCore;

        //Individual
        Object tieroneIndividual = individualMap.get('tierone');
        Map < String, Object > tieroneIndividualMap = (Map < String, Object > ) tieroneIndividual;
        //Deductible
        Object tieroneIndividualDeductible = tieroneIndividualMap.get('Deductible');
        Map < String, Object > tieroneIndividualDeductibleMap = (Map < String, Object > ) tieroneIndividualDeductible;
        //OutofPocket2
        Object tieroneIndividualOOP2 = tieroneIndividualMap.get('OutofPocket2');
        Map < String, Object > tieroneIndividualOOP2Map = (Map < String, Object > ) tieroneIndividualOOP2;
        //OutofPocket
        Object tieroneIndividualOOP = tieroneIndividualMap.get('OutofPocket');
        Map < String, Object > tieroneIndividualOOPMap = (Map < String, Object > ) tieroneIndividualOOP;
        //MedicalLifeMaximum
        Object tieroneIndividualMLM = tieroneIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > tieroneIndividualMLMMap = (Map < String, Object > ) tieroneIndividualMLM;
        //CopayMax
        Object tieroneIndividualCopayMax = tieroneIndividualMap.get('CopayMax');
        Map < String, Object > tieroneIndividualCopayMaxMap = (Map < String, Object > ) tieroneIndividualCopayMax;
        //CrossApplyOutofPocket
        Object tieroneIndividualCrsAppOOP = tieroneIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > tieroneIndividualCrsAppOOPMap = (Map < String, Object > ) tieroneIndividualCrsAppOOP;
        //CrossApplyCopay
        Object tieroneIndividualCrsAppCopay = tieroneIndividualMap.get('CrossApplyCopay');
        Map < String, Object > tieroneIndividualCrsAppCopayMap = (Map < String, Object > ) tieroneIndividualCrsAppCopay;
        //CrossApplyCore
        Object tieroneIndividualCrsAppCore = tieroneIndividualMap.get('CrossApplyCore');
        Map < String, Object > tieroneIndividualCrsAppCoreMap = (Map < String, Object > ) tieroneIndividualCrsAppCore;
        //Tier1 Case item
        if ((Boolean) tieroneFamilyDeductibleMap.get('isAutodoc') || (Boolean) tieroneFamilyOOP2Map.get('isAutodoc') ||
            (Boolean) tieroneFamilyOOPMap.get('isAutodoc') || (Boolean) tieroneFamilyMLMMap.get('isAutodoc') ||
            (Boolean) tieroneFamilyCopayMaxMap.get('isAutodoc') || (Boolean) tieroneFamilyCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) tieroneFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) tieroneFamilyCrsAppCoreMap.get('isAutodoc') ||
            (Boolean) tieroneIndividualDeductibleMap.get('isAutodoc') || (Boolean) tieroneIndividualOOP2Map.get('isAutodoc') ||
            (Boolean) tieroneIndividualOOPMap.get('isAutodoc') || (Boolean) tieroneIndividualMLMMap.get('isAutodoc') ||
            (Boolean) tieroneIndividualCopayMaxMap.get('isAutodoc') || (Boolean) tieroneIndividualCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) tieroneIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) tieroneIndividualCrsAppCoreMap.get('isAutodoc')) {
            Case_item__c ci = new Case_item__c();
            ci.Case__c = caseId;
            ci.ExternalID__c = 'Financials';
            ci.Benefit_Level__c = 'Tier 1';
            ci.Group_Number__c = policyNumber;
            ci.Resolved__c = true;
            ci.Resolved_Reason__c = ci.Resolved__c ? 'Resolved' : '';
            ci.Type__c = caseRecord.Type__c;
            ci.Subtype__c = caseRecord.Subtype__c;
            caseItems.add(ci);
        }

        //INN data
        //Family
        Object inNetworkFamily = familyMap.get('inNetwork');
        Map < String, Object > inNetworkFamilyMap = (Map < String, Object > ) inNetworkFamily;
        //Deductible
        Object inNetworkFamilyDeductible = inNetworkFamilyMap.get('Deductible');
        Map < String, Object > inNetworkFamilyDeductibleMap = (Map < String, Object > ) inNetworkFamilyDeductible;
        //OutofPocket2
        Object inNetworkFamilyOOP2 = inNetworkFamilyMap.get('OutofPocket2');
        Map < String, Object > inNetworkFamilyOOP2Map = (Map < String, Object > ) inNetworkFamilyOOP2;
        //OutofPocket
        Object inNetworkFamilyOOP = inNetworkFamilyMap.get('OutofPocket');
        Map < String, Object > inNetworkFamilyOOPMap = (Map < String, Object > ) inNetworkFamilyOOP;
        //MedicalLifeMaximum
        Object inNetworkFamilyMLM = inNetworkFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > inNetworkFamilyMLMMap = (Map < String, Object > ) inNetworkFamilyMLM;
        //CopayMax
        Object inNetworkFamilyCopayMax = inNetworkFamilyMap.get('CopayMax');
        Map < String, Object > inNetworkFamilyCopayMaxMap = (Map < String, Object > ) inNetworkFamilyCopayMax;
        //CrossApplyOutofPocket
        Object inNetworkFamilyCrsAppOOP = inNetworkFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > inNetworkFamilyCrsAppOOPMap = (Map < String, Object > ) inNetworkFamilyCrsAppOOP;
        //CrossApplyCopay
        Object inNetworkFamilyCrsAppCopay = inNetworkFamilyMap.get('CrossApplyCopay');
        Map < String, Object > inNetworkFamilyCrsAppCopayMap = (Map < String, Object > ) inNetworkFamilyCrsAppCopay;
        //CrossApplyCore
        Object inNetworkFamilyCrsAppCore = inNetworkFamilyMap.get('CrossApplyCore');
        Map < String, Object > inNetworkFamilyCrsAppCoreMap = (Map < String, Object > ) inNetworkFamilyCrsAppCore;
        //CombinedDeductible
        Object inNetworkFamilyCombinedDeductible = inNetworkFamilyMap.get('CombinedDeductible');
        Map < String, Object > inNetworkFamilyCombinedDeductibleMap = (Map < String, Object > ) inNetworkFamilyCombinedDeductible;
        //CombinedOOP
        Object inNetworkFamilyCombinedOOP = inNetworkFamilyMap.get('CombinedOOP');
        Map < String, Object > inNetworkFamilyCombinedOOPMap = (Map < String, Object > ) inNetworkFamilyCombinedOOP;

        //Individual
        Object inNetworkIndividual = individualMap.get('inNetwork');
        Map < String, Object > inNetworkIndividualMap = (Map < String, Object > ) inNetworkIndividual;
        //Deductible
        Object inNetworkIndividualDeductible = inNetworkIndividualMap.get('Deductible');
        Map < String, Object > inNetworkIndividualDeductibleMap = (Map < String, Object > ) inNetworkIndividualDeductible;
        //OutofPocket2
        Object inNetworkIndividualOOP2 = inNetworkIndividualMap.get('OutofPocket2');
        Map < String, Object > inNetworkIndividualOOP2Map = (Map < String, Object > ) inNetworkIndividualOOP2;
        //OutofPocket
        Object inNetworkIndividualOOP = inNetworkIndividualMap.get('OutofPocket');
        Map < String, Object > inNetworkIndividualOOPMap = (Map < String, Object > ) inNetworkIndividualOOP;
        //MedicalLifeMaximum
        Object inNetworkIndividualMLM = inNetworkIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > inNetworkIndividualMLMMap = (Map < String, Object > ) inNetworkIndividualMLM;
        //CopayMax
        Object inNetworkIndividualCopayMax = inNetworkIndividualMap.get('CopayMax');
        Map < String, Object > inNetworkIndividualCopayMaxMap = (Map < String, Object > ) inNetworkIndividualCopayMax;
        //CrossApplyOutofPocket
        Object inNetworkIndividualCrsAppOOP = inNetworkIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > inNetworkIndividualCrsAppOOPMap = (Map < String, Object > ) inNetworkIndividualCrsAppOOP;
        //CrossApplyCopay
        Object inNetworkIndividualCrsAppCopay = inNetworkIndividualMap.get('CrossApplyCopay');
        Map < String, Object > inNetworkIndividualCrsAppCopayMap = (Map < String, Object > ) inNetworkIndividualCrsAppCopay;
        //CrossApplyCore
        Object inNetworkIndividualCrsAppCore = inNetworkIndividualMap.get('CrossApplyCore');
        Map < String, Object > inNetworkIndividualCrsAppCoreMap = (Map < String, Object > ) inNetworkIndividualCrsAppCore;
        //CombinedDeductible
        Object inNetworkIndividualCombinedDeductible = inNetworkIndividualMap.get('CombinedDeductible');
        Map < String, Object > inNetworkIndividualCombinedDeductibleMap = (Map < String, Object > ) inNetworkIndividualCombinedDeductible;
        //CombinedOOP
        Object inNetworkIndividualCombinedOOP = inNetworkIndividualMap.get('CombinedOOP');
        Map < String, Object > inNetworkIndividualCombinedOOPMap = (Map < String, Object > ) inNetworkIndividualCombinedOOP;
        if ((Boolean) inNetworkFamilyDeductibleMap.get('isAutodoc') || (Boolean) inNetworkFamilyOOP2Map.get('isAutodoc') ||
            (Boolean) inNetworkFamilyOOPMap.get('isAutodoc') || (Boolean) inNetworkFamilyMLMMap.get('isAutodoc') ||
            (Boolean) inNetworkFamilyCopayMaxMap.get('isAutodoc') || (Boolean) inNetworkFamilyCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) inNetworkFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) inNetworkFamilyCrsAppCoreMap.get('isAutodoc') ||
            (Boolean) inNetworkFamilyCombinedDeductibleMap.get('isAutodoc') || (Boolean) inNetworkFamilyCombinedOOPMap.get('isAutodoc') ||
            (Boolean) inNetworkIndividualDeductibleMap.get('isAutodoc') || (Boolean) inNetworkIndividualOOP2Map.get('isAutodoc') ||
            (Boolean) inNetworkIndividualOOPMap.get('isAutodoc') || (Boolean) inNetworkIndividualMLMMap.get('isAutodoc') ||
            (Boolean) inNetworkIndividualCopayMaxMap.get('isAutodoc') || (Boolean) inNetworkIndividualCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) inNetworkIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) inNetworkIndividualCrsAppCoreMap.get('isAutodoc') ||
            (Boolean) inNetworkIndividualCombinedDeductibleMap.get('isAutodoc') || (Boolean) inNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
            Case_item__c ci = new Case_item__c();
            ci.Case__c = caseId;
            ci.ExternalID__c = 'Financials';
            ci.Benefit_Level__c = 'INN';
            ci.Group_Number__c = policyNumber;
            ci.Resolved__c = true;
            ci.Resolved_Reason__c = ci.Resolved__c ? 'Resolved' : '';
            ci.Type__c = caseRecord.Type__c;
            ci.Subtype__c = caseRecord.Subtype__c;
            caseItems.add(ci);
        }

        //OON data
        //Family
        Object outofNetworkFamily = familyMap.get('outofNetwork');
        Map < String, Object > outofNetworkFamilyMap = (Map < String, Object > ) outofNetworkFamily;
        //Deductible
        Object outofNetworkFamilyDeductible = outofNetworkFamilyMap.get('Deductible');
        Map < String, Object > outofNetworkFamilyDeductibleMap = (Map < String, Object > ) outofNetworkFamilyDeductible;
        //OutofPocket2
        Object outofNetworkFamilyOOP2 = outofNetworkFamilyMap.get('OutofPocket2');
        Map < String, Object > outofNetworkFamilyOOP2Map = (Map < String, Object > ) outofNetworkFamilyOOP2;
        //OutofPocket
        Object outofNetworkFamilyOOP = outofNetworkFamilyMap.get('OutofPocket');
        Map < String, Object > outofNetworkFamilyOOPMap = (Map < String, Object > ) outofNetworkFamilyOOP;
        //MedicalLifeMaximum
        Object outofNetworkFamilyMLM = outofNetworkFamilyMap.get('MedicalLifeMaximum');
        Map < String, Object > outofNetworkFamilyMLMMap = (Map < String, Object > ) outofNetworkFamilyMLM;
        //CopayMax
        Object outofNetworkFamilyCopayMax = outofNetworkFamilyMap.get('CopayMax');
        Map < String, Object > outofNetworkFamilyCopayMaxMap = (Map < String, Object > ) outofNetworkFamilyCopayMax;
        //CrossApplyOutofPocket
        Object outofNetworkFamilyCrsAppOOP = outofNetworkFamilyMap.get('CrossApplyOutofPocket');
        Map < String, Object > outofNetworkFamilyCrsAppOOPMap = (Map < String, Object > ) outofNetworkFamilyCrsAppOOP;
        //CrossApplyCopay
        Object outofNetworkFamilyCrsAppCopay = outofNetworkFamilyMap.get('CrossApplyCopay');
        Map < String, Object > outofNetworkFamilyCrsAppCopayMap = (Map < String, Object > ) outofNetworkFamilyCrsAppCopay;
        //CrossApplyCore
        Object outofNetworkFamilyCrsAppCore = outofNetworkFamilyMap.get('CrossApplyCore');
        Map < String, Object > outofNetworkFamilyCrsAppCoreMap = (Map < String, Object > ) outofNetworkFamilyCrsAppCore;
        //CombinedDeductible
        Object outofNetworkFamilyCombinedDeductible = outofNetworkFamilyMap.get('CombinedDeductible');
        Map < String, Object > outofNetworkFamilyCombinedDeductibleMap = (Map < String, Object > ) outofNetworkFamilyCombinedDeductible;
        //CombinedOOP
        Object outofNetworkFamilyCombinedOOP = outofNetworkFamilyMap.get('CombinedOOP');
        Map < String, Object > outofNetworkFamilyCombinedOOPMap = (Map < String, Object > ) outofNetworkFamilyCombinedOOP;

        //Individual
        Object outofNetworkIndividual = individualMap.get('outofNetwork');
        Map < String, Object > outofNetworkIndividualMap = (Map < String, Object > ) outofNetworkIndividual;
        //Deductible
        Object outofNetworkIndividualDeductible = outofNetworkIndividualMap.get('Deductible');
        Map < String, Object > outofNetworkIndividualDeductibleMap = (Map < String, Object > ) outofNetworkIndividualDeductible;
        //OutofPocket2
        Object outofNetworkIndividualOOP2 = outofNetworkIndividualMap.get('OutofPocket2');
        Map < String, Object > outofNetworkIndividualOOP2Map = (Map < String, Object > ) outofNetworkIndividualOOP2;
        //OutofPocket
        Object outofNetworkIndividualOOP = outofNetworkIndividualMap.get('OutofPocket');
        Map < String, Object > outofNetworkIndividualOOPMap = (Map < String, Object > ) outofNetworkIndividualOOP;
        //MedicalLifeMaximum
        Object outofNetworkIndividualMLM = outofNetworkIndividualMap.get('MedicalLifeMaximum');
        Map < String, Object > outofNetworkIndividualMLMMap = (Map < String, Object > ) outofNetworkIndividualMLM;
        //CopayMax
        Object outofNetworkIndividualCopayMax = outofNetworkIndividualMap.get('CopayMax');
        Map < String, Object > outofNetworkIndividualCopayMaxMap = (Map < String, Object > ) outofNetworkIndividualCopayMax;
        //CrossApplyOutofPocket
        Object outofNetworkIndividualCrsAppOOP = outofNetworkIndividualMap.get('CrossApplyOutofPocket');
        Map < String, Object > outofNetworkIndividualCrsAppOOPMap = (Map < String, Object > ) outofNetworkIndividualCrsAppOOP;
        //CrossApplyCopay
        Object outofNetworkIndividualCrsAppCopay = outofNetworkIndividualMap.get('CrossApplyCopay');
        Map < String, Object > outofNetworkIndividualCrsAppCopayMap = (Map < String, Object > ) outofNetworkIndividualCrsAppCopay;
        //CrossApplyCore
        Object outofNetworkIndividualCrsAppCore = outofNetworkIndividualMap.get('CrossApplyCore');
        Map < String, Object > outofNetworkIndividualCrsAppCoreMap = (Map < String, Object > ) outofNetworkIndividualCrsAppCore;
        //CombinedDeductible
        Object outofNetworkIndividualCombinedDeductible = outofNetworkIndividualMap.get('CombinedDeductible');
        Map < String, Object > outofNetworkIndividualCombinedDeductibleMap = (Map < String, Object > ) outofNetworkIndividualCombinedDeductible;
        //CombinedOOP
        Object outofNetworkIndividualCombinedOOP = outofNetworkIndividualMap.get('CombinedOOP');
        Map < String, Object > outofNetworkIndividualCombinedOOPMap = (Map < String, Object > ) outofNetworkIndividualCombinedOOP;
        if ((Boolean) outofNetworkFamilyDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkFamilyOOP2Map.get('isAutodoc') ||
            (Boolean) outofNetworkFamilyOOPMap.get('isAutodoc') || (Boolean) outofNetworkFamilyMLMMap.get('isAutodoc') ||
            (Boolean) outofNetworkFamilyCopayMaxMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) outofNetworkFamilyCrsAppCopayMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCrsAppCoreMap.get('isAutodoc') ||
            (Boolean) outofNetworkFamilyCombinedDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkFamilyCombinedOOPMap.get('isAutodoc') ||
            (Boolean) outofNetworkIndividualDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkIndividualOOP2Map.get('isAutodoc') ||
            (Boolean) outofNetworkIndividualOOPMap.get('isAutodoc') || (Boolean) outofNetworkIndividualMLMMap.get('isAutodoc') ||
            (Boolean) outofNetworkIndividualCopayMaxMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCrsAppOOPMap.get('isAutodoc') ||
            (Boolean) outofNetworkIndividualCrsAppCopayMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCrsAppCoreMap.get('isAutodoc') ||
            (Boolean) outofNetworkIndividualCombinedDeductibleMap.get('isAutodoc') || (Boolean) outofNetworkIndividualCombinedOOPMap.get('isAutodoc')) {
            Case_item__c ci = new Case_item__c();
            ci.Case__c = caseId;
            ci.ExternalID__c = 'Financials';
            ci.Benefit_Level__c = 'OON';
            ci.Group_Number__c = policyNumber;
            ci.Resolved__c = true;
            ci.Resolved_Reason__c = ci.Resolved__c ? 'Resolved' : '';
            ci.Type__c = caseRecord.Type__c;
            ci.Subtype__c = caseRecord.Subtype__c;
            caseItems.add(ci);
        }
        return caseItems;
    }

    // US2435572 - Create ORS From Save Case - Sanka - 17.03.2020
    // US2098661 - Thanish - 19th Mar 2020 - updated the function
    @AuraEnabled
   public static List < ORSResultWrapper > CreateORSRecord(String strRecord, String caseId) {
        // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
        List < ORSResultWrapper > returnList = new List < ORSResultWrapper > ();

        // US2737680 - End User ORS Creation - Sanka
        if (!isEndUser()) {
            if (!Test.isRunningTest()) {
                //Temporarily removing end user logic
                return returnList;
            }
        }
		acetCaseId=caseId;
        system.debug('caseId::' + caseId);
        String returnId = '';
        //US3644559 - Sravan - Start
        String extID = '';
        List<String> resolvedCaseItems = new List<String>();
        List<String> unResolvedCaseItems = new List<String>();
        //US3644559 - Sravan - End

        try {
            // US2041480 - Thanish - 27th Mar 2020 - assigning ors ID to case
            List < Case > caseRecord = [SELECT id, CaseNumber, Status, Case_Items_Unresolved__c, Case_Items_Complete__c,
                ORS_Issue_ID__c, Originator_Type__c  FROM Case WHERE id =: caseId
            ];
            String caseNumber = '';

            if (caseRecord != null && caseRecord.size() > 0) {
                caseNumber = String.valueOf(caseRecord.get(0).CaseNumber);
            }
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);

            if (caseWrapper.createORSCase == null) {
                caseWrapper.createORSCase = true;
            }

            if (caseWrapper.createORSCase) {
                List < String > orsCaseComments = new List < String > ();
                // Case Comments
                String caseCommentDefault = 'ORS Created for ACET Case No. ' + caseNumber;
                system.debug('caseWrapper::' + caseWrapper);

                // Sub-Provider Info

                ACET_ORSRequestWrapper.Provider provider = new ACET_ORSRequestWrapper.Provider();
                // US2098661 - Thanish - Provider Lookup Details for ORS Case Creation
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
                ACET_ORSRequestWrapper.ProviderName providerName = new ACET_ORSRequestWrapper.ProviderName();
                providerName.firstName = caseWrapper.plFirstName;
                providerName.lastName = caseWrapper.plLastName;
                providerName.firstInitial = caseWrapper.plFirstInitial;
                provider.providerName = providerName;

                provider.mpin = caseWrapper.plMpin;
                provider.providerID = caseWrapper.plProviderID;
                ACET_ORSRequestWrapper.Address address = new ACET_ORSRequestWrapper.Address();
                address.state = caseWrapper.plState;
                address.street1 = caseWrapper.plStreet1;
                address.street2 = caseWrapper.plStreet2;
                address.zip = caseWrapper.plZip;
                address.city = string.isNotBlank(caseWrapper.providerInfoCity) ? caseWrapper.providerInfoCity : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                provider.address = address;
                ACET_ORSRequestWrapper.Phone providerphone = new ACET_ORSRequestWrapper.Phone();
                Map < String, String > providerPhoneMap = new Map < String, String > ();
                providerPhoneMap = getPhoneNumber(caseWrapper.phoneNumber);
                if (providerPhoneMap != null) {
                    if (providerPhoneMap.containsKey('AreaCode')) {
                        providerphone.areaCode = providerPhoneMap.get('AreaCode');
                    }
                    if (providerPhoneMap.containsKey('Number')) {
                        providerphone.number_Z = providerPhoneMap.get('Number');
                    }
                }
                provider.phone = providerphone;
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
                provider.taxId = caseWrapper.plTaxId;
                provider.taxPrefix = caseWrapper.plTaxPrefix;
                provider.taxSuffix = caseWrapper.plTaxSuffix;
                // Commented as part of US2887985 - Sravan
                //provider.city = string.isNotBlank(caseWrapper.providerInfoCity) ? caseWrapper.providerInfoCity : '';//US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga


                // PCP Information - US2099074 - Sanka
                ACET_ORSRequestWrapper.Pcp pcp = new ACET_ORSRequestWrapper.Pcp();
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
                ACET_ORSRequestWrapper.ProviderName pcpProviderName = new ACET_ORSRequestWrapper.ProviderName();
                pcpProviderName.firstName = caseWrapper.pcpFirstName;
                pcpProviderName.lastName = caseWrapper.pcpLastName;
                pcpProviderName.firstInitial = string.isNotBlank(caseWrapper.pcpFirstName) ? caseWrapper.pcpFirstName.substring(0, 1) : '';
                pcp.providerName = pcpProviderName;
                pcp.mpin = caseWrapper.pcpMpin;
                pcp.providerID = caseWrapper.pcpProviderID;

                ACET_ORSRequestWrapper.Address pcpAddress = new ACET_ORSRequestWrapper.Address();
                pcpAddress.state = caseWrapper.pcpState;
                pcpAddress.street1 = caseWrapper.pcpStreet1;
                pcpAddress.street2 = caseWrapper.pcpStreet2;
                pcpAddress.zip = caseWrapper.pcpZip;
                pcp.address = pcpAddress;

                ACET_ORSRequestWrapper.Phone pcpPhone = new ACET_ORSRequestWrapper.Phone();
                pcp.phone = pcpPhone;
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
                pcp.taxId = caseWrapper.pcpTaxId;
                pcp.taxPrefix = caseWrapper.pcpTaxPrefix;
                pcp.taxSuffix = caseWrapper.pcpTaxSuffix;

                // Provider Details
                ACET_ORSRequestWrapper.ProviderInfo providerInfo = new ACET_ORSRequestWrapper.ProviderInfo();
                providerInfo.commonProviderID = caseWrapper.providerId;
                providerInfo.contractNumber = '';
                providerInfo.degreeName = caseWrapper.degree;
                providerInfo.ipa = '';
                providerInfo.npis = new List < String > {
                    caseWrapper.providerNPI
                };
                // Not in DD
                providerInfo.tpsmIndicator = caseWrapper.providerTpsm;
                //US2099066 - Provider Not Found - Cases Created in ACET to Feed ORS - Sravan
                system.debug('Phone Number: ' + caseWrapper.phoneNumber);
                //providerInfo.phoneNumber = String.isNotBlank(caseWrapper.phoneNumber) ? caseWrapper.phoneNumber : '';- Commented as part of US2887985 - Sravan
                providerInfo.provider = provider;
                providerInfo.pcp = pcp;
                providerInfo.providerValidatedFlag = 'Y';

                ACET_ORSRequestWrapper.CallerName callerName = new ACET_ORSRequestWrapper.CallerName();

                //US2740876 - Contact First Name and Last Name Entry Fields - Populate Contact Name and ORS Cases - Sravan
                if (caseWrapper.OriginatorContactName != null && String.isNotBlank(caseWrapper.OriginatorContactName)) {
                    List < String > originatorFullName = new List < String > ();
                    originatorFullName = caseWrapper.OriginatorContactName.split(' ');
                    if (originatorFullName.Size() > 1) {
                        callerName.firstName = originatorFullName[0];
                        callerName.lastName = originatorFullName[1];
                    } else if (originatorFullName.Size() == 1) {
                        callerName.firstName = originatorFullName[0];
                    }
                }


                ACET_ORSRequestWrapper.Originator originator = new ACET_ORSRequestWrapper.Originator();
                originator.providerId = caseWrapper.providerId;
                originator.callerName = callerName;
                originator.originatorTin = caseWrapper.TaxId;
                originator.originatorTinSuffix = '';
                originator.callerAddress = new ACET_ORSRequestWrapper.CallerAddress();
                //originator.autoId = '';- Commented as part of US2887985 - Sravan
                //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                //if(string.isNotBlank(caseWrapper.contactNumber)) originator.autoId = caseWrapper.contactNumber.replace('(','').replace(')','').replace('-','').replace(' ','');- Commented as part of US2887985 - Sravan
                originator.originatorMpin = caseWrapper.providerMpin;

                //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
                ACET_ORSRequestWrapper.Cti cti = new ACET_ORSRequestWrapper.Cti();
                ACET_ORSRequestWrapper.DayPhone dayPhone = new ACET_ORSRequestWrapper.DayPhone();
                ACET_ORSRequestWrapper.EveningPhone eveningPhone = new ACET_ORSRequestWrapper.EveningPhone();

                originator.cti = cti;
                originator.dayPhone = dayPhone;
                originator.eveningPhone = eveningPhone;

                ACET_ORSRequestWrapper.OtherInfo otherInfo = new ACET_ORSRequestWrapper.OtherInfo();
                otherInfo.agencyName = '';

                ACET_ORSRequestWrapper.Employer empInfp = new ACET_ORSRequestWrapper.Employer();
                empInfp.employerName = '';
                empInfp.employerNumber = '';
                empInfp.employerState = '';
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End



                ACET_ORSRequestWrapper.Member member = new ACET_ORSRequestWrapper.Member();
                //US2887985: Tech: Create ORS Change to Microservice - Sravan
                if (caseWrapper.SubjectAge != null && String.isNotBlank(caseWrapper.SubjectAge)) {
                    String subjectAge = caseWrapper.SubjectAge;
                    member.age = Integer.valueOf(subjectAge.replaceAll('[^0-9]', ''));
                } else {
                    member.age = 0;
                }
                member.dateOfBirth = SAEUtils.formatDateFutureDate(caseWrapper.SubjectDOB);
                member.dateOfDeath = '';
                //member.city = '';- Commented as part of US2887985 - Sravan
                //member.countryCode = '';- Commented as part of US2887985 - Sravan
                member.neonIndicator = 'N';
                member.memberNumber = caseWrapper.EEID;//caseWrapper.SubjectId; US3577946 - TECH: Map EEID to  Member ID
                ACET_ORSRequestWrapper.MemberName memberName = new ACET_ORSRequestWrapper.MemberName();
                memberName.middleInitial = caseWrapper.middleInitial != null && string.isNotBlank(caseWrapper.middleInitial) ? caseWrapper.middleInitial.substring(0, 1) : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga - Changed as part of US2887985 - Sravan
                member.memberName = memberName;
                member.groupName = string.isNotBlank(caseWrapper.groupName) ? caseWrapper.groupName : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                // Group number modification
                member.groupNumber = caseWrapper.SubjectGroupId;
                member.otherGroupNumber = caseWrapper.SubjectGroupId;
                //ORS Policy-not populating
                member.policy = caseWrapper.policyNumber != '' && caseWrapper.policyNumber != null ? caseWrapper.policyNumber : (String.isNotBlank(caseWrapper.MisdirectReason) ? '' : '0' + caseWrapper.SubjectGroupId);
                member.alternateId = caseWrapper.EEID;
                member.benefitPackageCode = caseWrapper.benefitPackage;
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
                ACET_ORSRequestWrapper.Address memberAddress = new ACET_ORSRequestWrapper.Address();
                memberAddress.state = caseWrapper.plState;
                memberAddress.street1 = caseWrapper.memStreet1;
                memberAddress.street2 = caseWrapper.memStreet2;
                memberAddress.zip = caseWrapper.memZip;
                memberAddress.city = '';
                member.address = memberAddress;
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End

                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan-Start
                //member.stateCode = caseWrapper.stateCode;- Commented as part of US2887985 - Sravan
                //member.phoneNumber = caseWrapper.subjectPhoneNumber;- Commented as part of US2887985 - Sravan

                //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
                ACET_ORSRequestWrapper.Phone memberPhone = new ACET_ORSRequestWrapper.Phone();
                Map < String, String > memberPhoneMap = new Map < String, String > ();
                memberPhoneMap = getPhoneNumber(caseWrapper.subjectPhoneNumber);
                if (memberPhoneMap != null) {
                    if (memberPhoneMap.containsKey('AreaCode')) {
                        memberPhone.areaCode = memberPhoneMap.get('AreaCode');
                    }
                    if (memberPhoneMap.containsKey('Number')) {
                        memberPhone.number_Z = memberPhoneMap.get('Number');
                    }
                }
                member.phone = memberPhone;
                member.riderCodes = new List < String > {
                    ''
                };
                ACET_ORSRequestWrapper.ServicesQuoted servicesQuoted = new ACET_ORSRequestWrapper.ServicesQuoted();
                member.servicesQuoted = servicesQuoted;

                ACET_ORSRequestWrapper.FaxNumber faxNumber = new ACET_ORSRequestWrapper.FaxNumber();
                member.faxNumber = faxNumber;
                member.totalNonCoverageCount = 0;
                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End

                //Missed Mapping
                member.relationshipCode = caseWrapper.RelationshipCode;
                ACET_ORSRequestWrapper.DependentName dependentName = new ACET_ORSRequestWrapper.DependentName();
                //Added by Vinay for Dependent Number Mapping
                if (caseWrapper.SubjectType == 'Member') {
                    // added the above if condition for member name will map only for Member flow (Edited by Thanish - DE348406 - 20th Jul 2020)
                    if (String.isNotBlank(caseWrapper.SubjectId)) {
                        //member.dependentNumber = caseWrapper.SubjectId; // Commented as part of dependent number is change as part of US2784325
                        if (String.isNotBlank(caseWrapper.SubjectName)) {
                            List < String > fullName = new List < String > ();
                            fullName = caseWrapper.SubjectName.split(' ');
                            if (fullName.Size() > 1) {
                                dependentName.firstName = fullName[0];
                                dependentName.lastName = fullName[1];
                            }
                        }
                    }
                    if (String.isNotBlank(caseWrapper.subjectFirstName) && String.isNotBlank(caseWrapper.subjectLastName)) {
                        member.memberName.firstName = caseWrapper.subjectFirstName.substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                        member.memberName.lastName = caseWrapper.subjectLastName;
                    } else {
                        if (String.isNotBlank(caseWrapper.SubjectName)) {
                            List < String > fullName = new List < String > ();
                            fullName = caseWrapper.SubjectName.split(' ');
                            if (fullName.Size() > 1) {
                                member.memberName.firstName = fullName[0].substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga;
                                member.memberName.lastName = fullName[1];
                            } else {
                                member.memberName.firstName = fullName[0].substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga;
                            }
                        }

                    }
                }
                member.dependentName = dependentName;
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan-End
                member.dependentNumber = string.isNotBlank(caseWrapper.dependentNumber) ? caseWrapper.dependentNumber : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga


                // Issue main object
                ACET_ORSRequestWrapper.Issue issue = new ACET_ORSRequestWrapper.Issue();
                //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                issue.payer = string.isNotBlank(caseWrapper.payerId) ? caseWrapper.payerId : '';
                //issue.updateType = 'N';
                issue.providerInfo = providerInfo;
                issue.contactMethodCode = 'P';
                issue.directionCode = 'I';
                //issue.createdByApplicationIndicator = 'H';
                // PR for Provider
                //issue.originatorTypeCode = caseRecord.get(0).Originator_Type__c == 'Member' ? 'EM' : 'PR';
                //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                originator.originatorTypeCode = 'PR';
                if (!caseRecord.isEmpty()) {
                    if (caseRecord.get(0).Originator_Type__c == 'Other' && finalContactTypeToORSCodeMap.get(caseWrapper.OtherOrginatorType) != NULL) originator.originatorTypeCode = finalContactTypeToORSCodeMap.get(caseWrapper.OtherOrginatorType);
                    else if (caseRecord.get(0).Originator_Type__c == 'Member' || caseRecord.get(0).Originator_Type__c == 'Provider') originator.originatorTypeCode = finalContactTypeToORSCodeMap.get(caseRecord.get(0).Originator_Type__c);
                }
                issue.originator = originator;
                //issue.issueId = '';- Commented as part of US2887985 - Sravan
                issue.otherInfo = otherInfo;
                //Need to set Dynamically
                //US2481391 : ORS - System Unavailable - Update to be Closed Case: Praveen CR - Start
                //Adding ORS case comments based on the CASE status - 2020/04/27
                //issue.comments = orsCaseComments;
                issue.contactElapseTime = 0; //- Changed as part of US2887985 - Sravan
                issue.contactId = '';
                //issue.followupDate = '';- Commented as part of US2887985 - Sravan
                issue.employer = empInfp;
                issue.member = member;
                ACET_ORSRequestWrapper.CarbonCopies carbonCopies = new ACET_ORSRequestWrapper.CarbonCopies();
                ACET_ORSRequestWrapper.RoutedTo routedTo = new ACET_ORSRequestWrapper.RoutedTo();
                ACET_ORSRequestWrapper.ResolvedBy resolvedBy = new ACET_ORSRequestWrapper.ResolvedBy();
                ACET_ORSRequestWrapper.IssueHandling issueHandling = new ACET_ORSRequestWrapper.IssueHandling();
                issueHandling.carbonCopies = new List < ACET_ORSRequestWrapper.CarbonCopies > {
                    carbonCopies
                };
                issueHandling.routedTo = routedTo;
                issueHandling.resolvedBy = resolvedBy;
                issue.issueHandling = issueHandling;
                ACET_ORSRequestWrapper.Grievance grievance = new ACET_ORSRequestWrapper.Grievance();
                issue.grievance = grievance;
                issue.issueElapseTime = 0;

                ACET_ORSRequestWrapper.Claim claim = new ACET_ORSRequestWrapper.Claim();
                claim.claimNumber = caseWrapper.claimNumber;
                claim.serviceDate = caseWrapper.serviceDate;
                ACET_ORSRequestWrapper.Drafts drafts = new ACET_ORSRequestWrapper.Drafts();
                ACET_ORSRequestWrapper.Atg atg = new ACET_ORSRequestWrapper.Atg();
                atg.drafts = new List < ACET_ORSRequestWrapper.Drafts > {
                    drafts
                };
                claim.atg = atg;
                issue.claim = claim;

                ACET_ORSRequestWrapper.CellPhone cellPhone = new ACET_ORSRequestWrapper.CellPhone();
                ACET_ORSRequestWrapper.Creator creator = new ACET_ORSRequestWrapper.Creator();
                ACET_ORSRequestWrapper.Fax fax = new ACET_ORSRequestWrapper.Fax();
                ACET_ORSRequestWrapper.HomePhone homePhone = new ACET_ORSRequestWrapper.HomePhone();
                ACET_ORSRequestWrapper.OtherPhone otherPhone = new ACET_ORSRequestWrapper.OtherPhone();
                ACET_ORSRequestWrapper.WorkPhone workPhone = new ACET_ORSRequestWrapper.WorkPhone();

                ACET_ORSRequestWrapper.FollowUp followUp = new ACET_ORSRequestWrapper.FollowUp();
                followUp.cellPhone = cellPhone;
                followUp.creator = creator;
                followUp.fax = fax;
                followUp.homePhone = homePhone;
                followUp.otherPhone = otherPhone;
                followUp.workPhone = workPhone;



                issue.followUp = followUp;
                issue.logoLookups = new List < ACET_ORSRequestWrapper.LogoLookups > {
                    new ACET_ORSRequestWrapper.LogoLookups()
                };
                issue.serviceRequest = new ACET_ORSRequestWrapper.ServiceRequest();

                //US2510172-Populate Category and Reason Based on TTS of Case
                //if(caseWrapper.AddInfoTopic != 'Provider Not Found' && caseWrapper.AddInfoTopic != 'Member Not Found'){ commented for US2099066 & US2098644 - Sravan
                List < SAE_Reason_Codes__mdt > saeReasonCodes = [SELECT Category_API__c, Reason_API__c
                    FROM SAE_Reason_Codes__mdt WHERE
                    Topic__c =: caseWrapper.AddInfoTopic AND
                    Type__c =: caseWrapper.ttsType AND
                    Subtype__c =: caseWrapper.ttsSubType AND
                    Issue__c =: caseWrapper.issueId
                ];

                if (saeReasonCodes != null && saeReasonCodes.size() > 0) {
                    issue.reasonCategory = saeReasonCodes.get(0).Category_API__c;
                    issue.reasonCode = saeReasonCodes.get(0).Reason_API__c;
                }
                //}


                if (caseWrapper.MisdirectReason != null) {
                    List < SAE_Reason_Codes__mdt > reasonCodes = [SELECT Category_API__c, Reason_API__c
                        FROM SAE_Reason_Codes__mdt WHERE
                        Label = 'Misdirects'
                    ];

                    if (reasonCodes != null && reasonCodes.size() > 0) {
                        issue.reasonCategory = reasonCodes.get(0).Category_API__c;
                        issue.reasonCode = reasonCodes.get(0).Reason_API__c;
                    }
                }

                // DE349999: SAE defaults ORS case priority to N - Normal
                issue.priority = 'N';
                //US2099066-Provider Not Found - Cases Created in ACET to Feed ORS-Sravan (Added extra condition)
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan (Added extra condition)
                if (caseWrapper.ttsType == 'Research' || caseWrapper.MisdirectReason != null || caseWrapper.AddInfoTopic == 'Provider Not Found' || caseWrapper.AddInfoTopic == 'Member Not Found') {
                    issue.status = 'C';
                } else {
                    issue.status = caseRecord.get(0).Status == 'Closed' ? 'C' : 'O';
                }

                //US2481391 : ORS - System Unavailable - Update to be Closed Case: Praveen CR - Start
                //US2481391 : Adding ORS case comments based on the CASE status - 2020/04/27
                //US2481391 : Adding ORS Case Comments when the case type is System Unavailable - 2020/04/27
                if (issue.status == 'C' && caseWrapper.ttsType != null && caseWrapper.ttsType == 'System Unavailable') {
                    caseCommentDefault = 'ORS Issue created when System unavailable for ACET Case :- ' + caseNumber;
                }

                orsCaseComments.add(caseCommentDefault);

                if (caseWrapper.isFromAuth != null && caseWrapper.isFromAuth && caseWrapper.AddInfoTopic == 'View Authorizations' && !String.isEmpty(caseWrapper.AutoDocCaseItems)) {
                    List < String > keyIds = caseWrapper.AutoDocCaseItems.split('\\|');
                    String commentString = '';

                    List < String > allIds = new List < String > ();
                    for (String keyId: keyIds) {
                        List < String > allIds_temp = new List < String > ();
                        if (keyId.indexOf('::') != -1) {
                            //commentString = commentString + keyId.split('::').get(0) + ',';
                            allIds_temp.addAll(allIds);
                            String comment_temp = String.join(allIds_temp, ',');
                            String newStr = comment_temp + keyId.split('::').get(0);

                            if (newStr.length() > 71) {
                                orsCaseComments.add(comment_temp);
                                allIds = new List < String > {
                                    keyId.split('::').get(0)
                                };
                            } else {
                                allIds.add(keyId.split('::').get(0));
                            }
                        }
                    }
                    orsCaseComments.add(string.join(allIds, ','));
                }

                if (caseWrapper.MisdirectReason != null) {
                    caseWrapper.MisdirectReason = 'Misdirect Reason <' + caseWrapper.MisdirectReason + '>';
                    Integer length = caseWrapper.MisdirectReason.length();
                    if (length > 71) {
                        Integer noOfIterations = (Integer) length / 71;
                        for (Integer i = 0; i <= noOfIterations; i++) {
                            if (length > (i * 71) + 71) {
                                orsCaseComments.add(caseWrapper.MisdirectReason.subString(i * 71, (i * 71) + 71));
                            } else {
                                orsCaseComments.add(caseWrapper.MisdirectReason.subString(i * 71, length));
                            }
                        }
                    } else {
                        orsCaseComments.add(caseWrapper.MisdirectReason);
                    }
                }

                if (caseWrapper.misdirectComments != null && caseWrapper.misdirectComments != '') {
                    Integer length = caseWrapper.misdirectComments.length();
                    if (length > 71) {
                        Integer noOfIterations = (Integer) length / 71;
                        for (Integer i = 0; i <= noOfIterations; i++) {
                            if (length > (i * 71) + 71) {
                                orsCaseComments.add(caseWrapper.misdirectComments.subString(i * 71, (i * 71) + 71));
                            } else {
                                orsCaseComments.add(caseWrapper.misdirectComments.subString(i * 71, length));
                            }
                        }
                    } else {
                        orsCaseComments.add(caseWrapper.misdirectComments);
                    }
                }

                //Added by Vinay for Not Issue Routed Comments
                if (!String.isEmpty(caseWrapper.freeFormCommentsVal)) {
                    if (caseWrapper.ttsType != 'Issue Routed') {
                        if (caseWrapper.freeFormCommentsVal != null) {
                            Integer length = caseWrapper.freeFormCommentsVal.length();
                            if (length > 71) {
                                Integer noOfIterations = (Integer) length / 71;
                                for (Integer i = 0; i <= noOfIterations; i++) {
                                    if (length > (i * 71) + 71) {
                                        orsCaseComments.add(caseWrapper.freeFormCommentsVal.subString(i * 71, (i * 71) + 71));
                                    } else {
                                        orsCaseComments.add(caseWrapper.freeFormCommentsVal.subString(i * 71, length));
                                    }
                                }
                            } else {
                                orsCaseComments.add(caseWrapper.freeFormCommentsVal);
                            }
                        }

                    }
                }

                //US2481391 : ORS - System Unavailable - Update to be Closed Case: Praveen CR - End

                if (caseWrapper.manualEnteredComments != null) {
                    Integer length = caseWrapper.manualEnteredComments.length();
                    if (length > 71) {
                        //orsCaseComments.add(caseWrapper.manualEnteredComments.subString(0, 71));
                        Integer noOfIterations = (Integer) length / 71;
                        for (Integer i = 0; i <= noOfIterations; i++) {
                            if (length > (i * 71) + 71) {
                                orsCaseComments.add(caseWrapper.manualEnteredComments.subString(i * 71, (i * 71) + 71));
                            } else {
                                orsCaseComments.add(caseWrapper.manualEnteredComments.subString(i * 71, length));
                            }
                        }
                    } else {
                        orsCaseComments.add(caseWrapper.manualEnteredComments);
                    }
                }
                if (!String.isEmpty(caseWrapper.concatinatedComments)) {
                    if (caseWrapper.concatinatedComments != null) {
                        Integer length = caseWrapper.concatinatedComments.length();
                        if (length > 71) {
                            Integer noOfIterations = (Integer) length / 71;
                            for (Integer i = 0; i <= noOfIterations; i++) {
                                if (length > (i * 71) + 71) {
                                    orsCaseComments.add(caseWrapper.concatinatedComments.subString(i * 71, (i * 71) + 71));
                                } else {
                                    orsCaseComments.add(caseWrapper.concatinatedComments.subString(i * 71, length));
                                }
                            }
                        } else {
                            orsCaseComments.add(caseWrapper.concatinatedComments);
                        }
                    }
                }



                // US2098648 - Benefit ORS
                issue.caseNumber = caseNumber;
                String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId'); //673/JR2
                List < String > businessSegmentList = new List < String > ();
                businessSegmentList = (List < String > ) Cache.Session.get('local.TOPSProfileInfo.businessGroups');
                List < String > searchInputParams = new List < String > ();
                if (!String.isBlank(topsUserId)) {
                    searchInputParams = topsUserId.split('/');
                } else {
                    // Thanish - 17th Jun 2020 - Code Coverage
                    if (!Test.isRunningTest()) {
                        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                        loginflow.validateTopsCredentials();
                        topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
                        if (businessSegmentList == null) {
                            businessSegmentList = (List < String > ) Cache.Session.get('local.TOPSProfileInfo.businessGroups');
                        }
                        if (!String.isBlank(topsUserId)) {
                            searchInputParams = topsUserId.split('/');
                        }
                    }
                }
                //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                if (businessSegmentList != null && !businessSegmentList.isEmpty() && businessSegmentList.contains('STANDARD')) {
                    issue.businessSegmentName = 'STANDARD';
                } else {
                    issue.businessSegmentName = '';
                }
                ACET_ORSRequestWrapper.OrsSourceSystemParameters sysPar = new ACET_ORSRequestWrapper.OrsSourceSystemParameters();
                if (!searchInputParams.isempty()) {
                    sysPar.logonOffice = searchInputParams[0];
                    sysPar.logonId = searchInputParams[1];
                }

                //Added by Vinay

                ACET_ORSRequestWrapper.controlModifiers controlModifiers = new ACET_ORSRequestWrapper.controlModifiers();
                controlModifiers.orsSourceSystemParameters = sysPar;

                ACET_ORSRequestWrapper.Meta metaInfo = new ACET_ORSRequestWrapper.Meta();
                metaInfo.controlModifiers = controlModifiers;

                ACET_ORSRequestWrapper.Data dataObj = new ACET_ORSRequestWrapper.Data();
                dataObj.issue = issue;

                ACET_ORSRequestWrapper acetORS = new ACET_ORSRequestWrapper();
                acetORS.meta = metaInfo;
                acetORS.data = dataObj;

                String orsRequest = '';

                // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
                HttpResponse responseStr;
                HttpResponse responseStr1;

                //US3644559 - Sravan - Start
                resolvedCaseItems = getCaseItems(caseWrapper,true);
                unResolvedCaseItems = getCaseItems(caseWrapper,false);
                system.debug('Resolved Case Items'+resolvedCaseItems);
                system.debug('UnResolved Case Items'+unResolvedCaseItems);

                //ketki provider extenal id fix begin
                String relatedCaseResolved = '';
                String relatedCaseUnresolved ='';

				if( resolvedCaseItems  != null && !resolvedCaseItems.isEmpty()){
					for( String caseItem :  resolvedCaseItems ){
						if(caseItem!=  caseWrapper.TaxId){
                              relatedCaseResolved += 'EXTERNAL ID-'+ caseItem + ' ';
						}
                    }
				}

				if( unResolvedCaseItems  != null && !unResolvedCaseItems.isEmpty()){
					for( String caseItem :  unResolvedCaseItems ){
						if(caseItem!=  caseWrapper.TaxId){
                              relatedCaseUnresolved += 'EXTERNAL ID-'+ caseItem + ' ';
						}
                    }
				}

                relatedCaseResolved += ' EXTERNAL ID-'+ caseWrapper.TaxId ;
            	relatedCaseUnresolved += ' EXTERNAL ID-'+ caseWrapper.TaxId ;
				//ketki provider extenal id fix end
				//US3583865 - k - Start
                if  (caseWrapper.AddInfoTopic == 'Provider Details'){
                     if(relatedCaseUnresolved != null && String.isNotBlank(relatedCaseUnresolved)){
                        Integer length = relatedCaseUnresolved.length();
                            if (length > 71) {
                                Integer noOfIterations = (Integer) length / 71;
                                for (Integer i = 0; i <= noOfIterations; i++) {
                                    if (length > (i * 71) + 71) {
                                        orsCaseComments.add(relatedCaseUnresolved.subString(i * 71, (i * 71) + 71));

                                    } else {
                                        orsCaseComments.add(relatedCaseUnresolved.subString(i * 71, length));
                                    }
                                }
                            } else {
                                orsCaseComments.add(relatedCaseUnresolved);
                            }
                    }

                }
                else {
                     if(caseWrapper.relatedCaseItems != null && String.isNotBlank(caseWrapper.relatedCaseItems)){
                        Integer length = caseWrapper.relatedCaseItems.length();
                            if (length > 71) {
                                Integer noOfIterations = (Integer) length / 71;
                                for (Integer i = 0; i <= noOfIterations; i++) {
                                    if (length > (i * 71) + 71) {
                                        orsCaseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, (i * 71) + 71));

                                    } else {
                                        orsCaseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, length));

                                    }
                                }
                            } else {
                                orsCaseComments.add(caseWrapper.relatedCaseItems);
                            }
                    }

                }
                //US3149404 - Sravan - End

                issue.comments = orsCaseComments;


				extID = getExtId(caseWrapper);
                //US3644559 - Sravan - End

                //Create closed ors
                if((resolvedCaseItems != null && !resolvedCaseItems.isEmpty()) || caseWrapper.MisdirectReason != null ){
                            acetORS.data.issue.status = 'C';
                            orsRequest = '';
                            //US2781219 - ORS - Comments for Open vs. Closed ORS - Sravan
                            if (caseWrapper.ttsType == 'Issue Routed') {
                                List < String > caseComments = new List < String > ();
                                caseComments.add(caseCommentDefault);
                                if (caseWrapper.freeFormCommentsVal != null && String.isNotBlank(caseWrapper.freeFormCommentsVal)) {
                                    caseComments.add(caseWrapper.freeFormCommentsVal);
                                }

                                //US3583865 - ketki - Start
                                 if  (caseWrapper.AddInfoTopic == 'Provider Details'){

                                        if(relatedCaseResolved != null && String.isNotBlank(relatedCaseResolved)){
                                        Integer length = relatedCaseResolved.length();
                                            if (length > 71) {
                                                Integer noOfIterations = (Integer) length / 71;
                                                for (Integer i = 0; i <= noOfIterations; i++) {
                                                    if (length > (i * 71) + 71) {
                                                        caseComments.add(relatedCaseResolved.subString(i * 71, (i * 71) + 71));

                                                    } else {
                                                        caseComments.add(relatedCaseResolved.subString(i * 71, length));
                                                    }
                                                }
                                            } else {
                                                caseComments.add(relatedCaseResolved);
                                            }
                                    }

                                }
                                else {

                                if(caseWrapper.relatedCaseItems != null && String.isNotBlank(caseWrapper.relatedCaseItems)){
                                     Integer length = caseWrapper.relatedCaseItems.length();
                                     if (length > 71) {
                                         Integer noOfIterations = (Integer) length / 71;
                                         for (Integer i = 0; i <= noOfIterations; i++) {
                                              if (length > (i * 71) + 71) {
                                                    caseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, (i * 71) + 71));
                                              } else {
                                                    caseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, length));
                                              }
                                          }
                                       } else {
                                            caseComments.add(caseWrapper.relatedCaseItems);
                                       }
                                  }

                                }
                                  //US3353397 - Sravan - End

                                //Ketki Claims ORS case creation
                                if( caseWrapper.claimCaseStatus != null && caseWrapper.claimCaseStatus != ''){
                                   acetORS.data.issue.status = caseWrapper.claimCaseStatus;
                                }
                                if( caseWrapper.claimComments != null && caseWrapper.claimComments.size() > 0){
                                    System.debug('Adding claim comments to ORS comments '+ caseWrapper.claimComments);
                                    caseComments.addAll(caseWrapper.claimComments);
                                }
                                //Ketki Claims ORS case creation  end
                                acetORS.data.issue.comments = caseComments;
                            }
                        Object reqObjResolved = addCreateIssueAttributes(acetORS);
                        orsRequest = JSON.serialize(reqObjResolved);

                        //orsRequest = orsRequest.replace('null', '""').replace('number_Z', 'number').replace('--', '');
			orsRequest = orsRequest.replace('number_Z', 'number').replace('--', '');
                        responseStr = (HttpResponse) ACET_ORSWebservice.createORSIssue(orsRequest);

                        //US3068040 Jitendra to make another callout to ORS System if Status Code is 409
                        if(responseStr.getStatusCode() == 409) {
                            System.debug(' Inside 409 ');
                            //responseStr = (HttpResponse) ACET_ORSWebservice.createORSIssue(orsRequest);
                        }

                        if (responseStr.getStatusCode() != 200) {
                        //US3644559 -- Sravan
                        createCaseItems(true,'',caseId,caseWrapper.policyNumber,resolvedCaseItems,extID,caseWrapper);
                            ORSResultWrapper errorObject = new ORSResultWrapper();
                            errorObject.resultStatus = responseStr.getStatusCode();
                            if (responseStr.getStatusCode() == 400) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                            } else if (responseStr.getStatusCode() == 404) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                            } else if (responseStr.getStatusCode() == 500) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                            } else {
                                errorObject.resultStatusMessage = 'Unexpected error occured while creating ORS case. Error Code: ' + String.valueOf(responseStr.getStatusCode());
                            }
                            returnList.add(errorObject);
                        }
                }//Closed ors

                //Create open ors
                if(unResolvedCaseItems != null && !unResolvedCaseItems.isEmpty()){
                        //US2781219 - ORS - Comments for Open vs. Closed ORS - Sravan
                        //DE353624 - Sravan
                        if (caseWrapper.ttsType == 'Issue Routed') {
                            acetORS.data.issue.IssueHandling.routedTo.officeId = caseWrapper.officeAPI;
                            acetORS.data.issue.IssueHandling.routedTo.departmentCode = caseWrapper.departmentAPI;
                            acetORS.data.issue.IssueHandling.routedTo.teamCode = caseWrapper.teamAPI;
                            acetORS.data.issue.status = 'O';

                            acetORS.data.issue.comments = orsCaseComments;
                        }
                        orsRequest = '';
                        Object reqObjUnresolved = addCreateIssueAttributes(acetORS);
                        orsRequest = JSON.serialize(reqObjUnresolved);

                        //orsRequest = orsRequest.replace('null', '""').replace('number_Z', 'number').replace('--', '');
			orsRequest = orsRequest.replace('number_Z', 'number').replace('--', '');
                        system.debug('UnResolved Request' + orsRequest);
                        responseStr1 = (HttpResponse) ACET_ORSWebservice.createORSIssue(orsRequest);

                        //US3068040 Jitendra to make another callout to ORS System if Status Code is 409
                        if(responseStr1.getStatusCode() == 409) {
                            System.debug(' Inside 409 ');
                            //responseStr1 = (HttpResponse) ACET_ORSWebservice.createORSIssue(orsRequest);
                        }

                        if (responseStr1.getStatusCode() != 200) {
                        //US3644559 -- Sravan
                        createCaseItems(false,'',caseId,caseWrapper.policyNumber,unResolvedCaseItems,extID,caseWrapper);
                            ORSResultWrapper errorObject = new ORSResultWrapper();
                            errorObject.resultStatus = responseStr1.getStatusCode();
                            if (responseStr1.getStatusCode() == 400) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                            } else if (responseStr1.getStatusCode() == 404) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                            } else if (responseStr1.getStatusCode() == 500) {
                                errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                            } else {
                                errorObject.resultStatusMessage = 'Unexpected error occured while creating ORS case. Error Code: ' + String.valueOf(responseStr.getStatusCode());
                            }
                            returnList.add(errorObject);
                        }
                        system.debug('responseStr1::' + responseStr1);
                }//Open ors
                String responseOrsId1 = '';
                String responseOrsId2 = '';
                if (responseStr != null) {
                    if (responseStr.getStatusCode() == 200) {
                        ORSResponseWrapper orsResponse = (ORSResponseWrapper) JSON.deserialize(responseStr.getBody(), ORSResponseWrapper.class);
                        ORSResultWrapper resultWrapper = new ORSResultWrapper();
                        resultWrapper.resultStatus = 200;
                        resultWrapper.resultStatusMessage = 'Success';
                        returnId = orsResponse.data.createIssueOutput.issueId;
                        responseOrsId1 = orsResponse.data.createIssueOutput.issueId;
                        returnList.add(resultWrapper);
                    }
                }

                if (responseStr1 != null) {
                    if (responseStr1.getStatusCode() == 200) {
                        ORSResponseWrapper orsResponse1 = (ORSResponseWrapper) JSON.deserialize(responseStr1.getBody(), ORSResponseWrapper.class);
                        ORSResultWrapper resultWrapper1 = new ORSResultWrapper();
                        resultWrapper1.resultStatus = 200;
                        resultWrapper1.resultStatusMessage = 'Success';
                        string returnId1 = orsResponse1.data.createIssueOutput.issueId;
                        responseOrsId2 = orsResponse1.data.createIssueOutput.issueId;
                        if (returnId1 != null && !string.isEmpty(returnId1)) {
                            if (returnId != null && !string.isEmpty(returnId)) {
                                returnId = returnId + ',' + returnId1;
                            } else {
                                returnId = returnId1;
                            }
                        }
                        returnList.add(resultWrapper1);

                    }
                }
                caseRecord[0].ORS_Issue_ID__c = caseRecord[0].ORS_Issue_ID__c != null ? caseRecord[0].ORS_Issue_ID__c + ',' +returnId : returnId;
                update caseRecord;
                if(String.isNotBlank(responseOrsId1)){
                  //US3644559 -- Sravan
                  createCaseItems(true,responseOrsId1,caseId,caseWrapper.policyNumber,resolvedCaseItems,extID,caseWrapper);
                }
                if(String.isNotBlank(responseOrsId2)){
                  //US3644559 -- Sravan
                  createCaseItems(false,responseOrsId2,caseId,caseWrapper.policyNumber,unResolvedCaseItems,extID,caseWrapper);
                }
                return returnList;
            } else {
                return returnList;
            }
        } catch (Exception ex) {
            //US3644559 -- Sravan
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            resolvedCaseItems = getCaseItems(caseWrapper,true);
            unResolvedCaseItems = getCaseItems(caseWrapper,false);
			extID = getExtId(caseWrapper);
            if(resolvedCaseItems != null && !resolvedCaseItems.isEmpty()){
               createCaseItems(true,'',caseId,caseWrapper.policyNumber,resolvedCaseItems,extID,caseWrapper);
            }
            if(unResolvedCaseItems != null && !unResolvedCaseItems.isEmpty()){
              createCaseItems(false,'',caseId,caseWrapper.policyNumber,unResolvedCaseItems,extID,caseWrapper);
            }
            System.debug('ORS Case Creation ' + ex.getStackTraceString());
            ORSResultWrapper errorObject = new ORSResultWrapper();
            errorObject.resultStatus = 999;
            errorObject.resultStatusMessage = 'Unexpected error occured while creating ORS case. Error Code: 999';
            returnList.add(errorObject);
            return returnList;
        }
    }
    
    //US3644559 - Sravan - Start
    public static void createCaseItems(Boolean isResolved,String orsId,String caseId,String groupNumber,List<String> relatedUniqueKeys,String extID,SAETTSCaseWrapper caseWrapper){
		List <case> caseRecord = [select id,Topic__c,Type__c, subtype__c, (SELECT Id FROM Work_Items__r) from Case where id =: caseId];
		List <Object> savedAutoDoc = (List <Object> ) JSON.deserializeUntyped(caseWrapper.savedAutodoc);
		List<Case_Item__c> caseItems = new List<Case_Item__c>();
		List<Case_Item__c> financialCaseItems = new List<Case_Item__c>();
		List<Case_Item__c> updatedFinancialCaseItems = new List<Case_Item__c>();
		system.debug('Auto Doc JSON'+ savedAutoDoc);
		for(Object obj : savedAutoDoc){
			Map < String, Object > ob = (Map < String, Object > ) obj;
			String componentType = (String) ob.get('type');
			if (componentType == 'financials' && caseWrapper.AddInfoTopic == 'Plan Benefits') {
			    financialCaseItems = CreateCaseItemsForFinancials(ob, caseId, groupNumber);
				updatedFinancialCaseItems = mapOrsValuesToFinancialCaseItems(financialCaseItems,orsId,getOrsStatus(isResolved));

			}
		}
		if(updatedFinancialCaseItems != null && !updatedFinancialCaseItems.isEmpty()){
			caseItems.addAll(updatedFinancialCaseItems);
		}
		for(String externalId : relatedUniqueKeys){
			if(externalId != 'Financials'){
				Case_Item__c ci = new Case_Item__c();
				ci.Case__c = caseId;
				ci.ExternalID__c = getExternaId(externalId);
				ci.tax_id__c = extID;
				ci.Resolved__c = isResolved;
			    ci.Resolved_Reason__c = getResolvedReason(isResolved);
				ci.Type__c = caseRecord[0].Type__c;
				ci.Subtype__c = caseRecord[0].subtype__c;
				ci.Ext_Record_ID__c = orsId;
				ci.Ext_Record_Status__c = getOrsStatus(isResolved);
				ci.Group_Number__c = groupNumber;
				caseItems.add(ci);
			}
		}


        if (Case_Item__c.SObjectType.getDescribe().isCreateable()) {
            try{
            insert caseItems;
            }
            catch(Exception ex){

            }

        }

        //For Autodoc Reporting - Changed position
        createReporting(caseWrapper,caseId);

    }

    private static void createReporting(SAETTSCaseWrapper caseWrapper, String caseId){
        //For Autodoc Reporting - Changed position
        try{
                 if (String.isNotBlank(caseWrapper.savedAutodoc) && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).Disable_Autodoc_Reporting__c ||
                 Organization_Properties__c.getInstance(UserInfo.getUserId()).Disable_Autodoc_Reporting__c ||
                 Organization_Properties__c.getOrgDefaults().Disable_Autodoc_Reporting__c)) {
                     createADReporting(caseWrapper.savedAutodoc, caseId);
                 }
        }catch(Exception e){
            System.debug(e.getLineNumber());
        }

    }

    public static List<Case_Item__c> mapOrsValuesToFinancialCaseItems(List<Case_Item__c> financialCaseItems,String orsId,String orsStatus){
		List<Case_Item__c> updatedFinancialCaseItems = new List<Case_Item__c>();
		for(Case_Item__c fcaseItem : financialCaseItems){
			fcaseItem.Ext_Record_ID__c = orsId;
			fcaseItem.Ext_Record_Status__c = orsStatus;
			updatedFinancialCaseItems.add(fcaseItem);
		}
		return updatedFinancialCaseItems;
	}

	public static String getExternaId(String externalId){
		String externalKey = '';
		if(String.isNotBlank(externalId)){
			externalKey = externalId.length() > 255 ? externalId.substring(0, 254) : externalId;
		}
		return externalKey;
	}

	public static String getResolvedReason(Boolean isResolved){
		String resolvedReason = '';
		if(isResolved){
			resolvedReason =  'Resolved';
		}
		else{
			resolvedReason = '';
		}
		return resolvedReason;
    }

    public static String getOrsStatus(Boolean isResolved){
        String orsStatus= '';
		if(isResolved){
			orsStatus =  'Close';
		}
		else{
			orsStatus = 'Open';
		}
		return orsStatus;
    }

    public static List<String> getCaseItems(SAETTSCaseWrapper caseWrapper,Boolean isResolved){
        List<String> caseItems = new List<String>();
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemsMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        relatedCaseItemsMap = caseWrapper.relatedCaseItemsMap;
        system.debug('Related Case Items Map'+ relatedCaseItemsMap);
        if(relatedCaseItemsMap != null && !relatedCaseItemsMap.isEmpty()){
            for(SAETTSCaseWrapper.ACETCaseItem caseItem :  relatedCaseItemsMap.Values()){
                if(caseItem.isResolved == isResolved){
                    caseItems.add(caseItem.uniqueKey);
                }
             }
        }
        return caseItems;

    }

    public static String getExtId(SAETTSCaseWrapper caseWrapper){
        String extId = '';
        if (!String.isEmpty(caseWrapper.TaxId)) {
		   	extId = caseWrapper.TaxId;
		}
		if (caseWrapper.mnf == 'mnf') {
			extId = caseWrapper.mnfExternalId;
		}
	    if (caseWrapper.providerNotFound != null && caseWrapper.providerNotFound) {
			extId = caseWrapper.pnfExternalId;
		}
       return extId;
    }

     @AuraEnabled
    public static void insertCaseItems(String caseId, String caseWrapper){
         SAETTSCaseWrapper caseWrap = (SAETTSCaseWrapper) JSON.deserialize(caseWrapper, SAETTSCaseWrapper.class);
         List<String> resolvedCaseItems = new List<String>();
         List<String> unResolvedCaseItems = new List<String>();
         Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemsMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
         relatedCaseItemsMap = caseWrap.relatedCaseItemsMap;
         system.debug('Related Case Items Map'+ relatedCaseItemsMap);
         if(relatedCaseItemsMap != null && !relatedCaseItemsMap.isEmpty()){
              for(SAETTSCaseWrapper.ACETCaseItem caseItems :  relatedCaseItemsMap.Values()){
                    if(caseItems.isResolved){
                       resolvedCaseItems.add(caseItems.uniqueKey);
                    }
                    else{
                       unResolvedCaseItems.add(caseItems.uniqueKey);
                    }
              }
         }
         system.debug('Resolved Case Items'+resolvedCaseItems);
         system.debug('UnResolved Case Items'+unResolvedCaseItems);
	     String extID = ' ';
		 if (!String.isEmpty(caseWrap.TaxId)) {
			extID = caseWrap.TaxId;
		 }
		 if (caseWrap.mnf == 'mnf') {
			extID = caseWrap.mnfExternalId;
		 }
		 if (caseWrap.providerNotFound) {
			extID = caseWrap.pnfExternalId;
		 }

        if(resolvedCaseItems != null && !resolvedCaseItems.isEmpty()){
        	createCaseItems(true,'',caseId,caseWrap.policyNumber,resolvedCaseItems,extID,caseWrap);
        }
        if(unResolvedCaseItems != null && !unResolvedCaseItems.isEmpty()){
           createCaseItems(false,'',caseId,caseWrap.policyNumber,unResolvedCaseItems,extID,caseWrap);
        }


    }



	//US3644559 - Sravan - End




     @AuraEnabled
    public static  Object CreateORSRecordClaim(SAETTSCaseWrapper caseWrapper,   List < Case > caseRecord , List < SAE_Reason_Codes__mdt > saeReasonCodes) {

         ORSResultWrapper  resultWrapper = new  ORSResultWrapper();

        if (!isEndUser()) {
            if (!Test.isRunningTest()) {
                //Temporarily removing end user logic
                return resultWrapper;
            }
        }

        //US3644559 - Sravan - Start
	    Boolean isResolved = true;
        //US3644559 - Sravan - End




            String caseNumber = '';

            if (caseRecord != null && caseRecord.size() > 0) {
                caseNumber = String.valueOf(caseRecord.get(0).CaseNumber);
				acetCaseId= caseRecord.get(0).Id;
            }

            List < String > orsCaseComments = new List < String > ();
            // Case Comments
            String caseCommentDefault = 'ORS Created for ACET Case No. ' + caseNumber;
            system.debug('caseWrapper::' + caseWrapper);

            // Sub-Provider Info

            ACET_ORSRequestWrapper.Provider provider = new ACET_ORSRequestWrapper.Provider();

            ACET_ORSRequestWrapper.ProviderName providerName = new ACET_ORSRequestWrapper.ProviderName();
            providerName.firstName = caseWrapper.plFirstName;
            providerName.lastName = caseWrapper.plLastName;
            providerName.firstInitial = caseWrapper.plFirstInitial;
            provider.providerName = providerName;

            provider.mpin = caseWrapper.plMpin;
            provider.providerID = caseWrapper.plProviderID;
            ACET_ORSRequestWrapper.Address address = new ACET_ORSRequestWrapper.Address();
            address.state = caseWrapper.plState;
            address.street1 = caseWrapper.plStreet1;
            address.street2 = caseWrapper.plStreet2;
            address.zip = caseWrapper.plZip;
            address.city = string.isNotBlank(caseWrapper.providerInfoCity) ? caseWrapper.providerInfoCity : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            provider.address = address;
            ACET_ORSRequestWrapper.Phone providerphone = new ACET_ORSRequestWrapper.Phone();
            Map < String, String > providerPhoneMap = new Map < String, String > ();
            providerPhoneMap = getPhoneNumber(caseWrapper.phoneNumber);
            if (providerPhoneMap != null) {
                if (providerPhoneMap.containsKey('AreaCode')) {
                    providerphone.areaCode = providerPhoneMap.get('AreaCode');
                }
                if (providerPhoneMap.containsKey('Number')) {
                    providerphone.number_Z = providerPhoneMap.get('Number');
                }
            }
            provider.phone = providerphone;
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
            provider.taxId = caseWrapper.plTaxId;
            provider.taxPrefix = caseWrapper.plTaxPrefix;
            provider.taxSuffix = caseWrapper.plTaxSuffix;

            ACET_ORSRequestWrapper.Pcp pcp = new ACET_ORSRequestWrapper.Pcp();
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
            ACET_ORSRequestWrapper.ProviderName pcpProviderName = new ACET_ORSRequestWrapper.ProviderName();
            pcpProviderName.firstName = caseWrapper.pcpFirstName;
            pcpProviderName.lastName = caseWrapper.pcpLastName;
            pcpProviderName.firstInitial = string.isNotBlank(caseWrapper.pcpFirstName) ? caseWrapper.pcpFirstName.substring(0, 1) : '';
            pcp.providerName = pcpProviderName;
            pcp.mpin = caseWrapper.pcpMpin;
            pcp.providerID = caseWrapper.pcpProviderID;

            ACET_ORSRequestWrapper.Address pcpAddress = new ACET_ORSRequestWrapper.Address();
            pcpAddress.state = caseWrapper.pcpState;
            pcpAddress.street1 = caseWrapper.pcpStreet1;
            pcpAddress.street2 = caseWrapper.pcpStreet2;
            pcpAddress.zip = caseWrapper.pcpZip;
            pcp.address = pcpAddress;

            ACET_ORSRequestWrapper.Phone pcpPhone = new ACET_ORSRequestWrapper.Phone();
            pcp.phone = pcpPhone;
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
            pcp.taxId = caseWrapper.pcpTaxId;
            pcp.taxPrefix = caseWrapper.pcpTaxPrefix;
            pcp.taxSuffix = caseWrapper.pcpTaxSuffix;

            // Provider Details
            ACET_ORSRequestWrapper.ProviderInfo providerInfo = new ACET_ORSRequestWrapper.ProviderInfo();
            providerInfo.commonProviderID = caseWrapper.providerId;
            providerInfo.contractNumber = '';
            providerInfo.degreeName = caseWrapper.degree;
            providerInfo.ipa = '';
            providerInfo.npis = new List < String > {
                caseWrapper.providerNPI
                    };

            providerInfo.tpsmIndicator = caseWrapper.providerTpsm;

            system.debug('Phone Number: ' + caseWrapper.phoneNumber);
            providerInfo.provider = provider;
            providerInfo.pcp = pcp;
            providerInfo.providerValidatedFlag = 'Y';

            ACET_ORSRequestWrapper.CallerName callerName = new ACET_ORSRequestWrapper.CallerName();

            //US2740876 - Contact First Name and Last Name Entry Fields - Populate Contact Name and ORS Cases - Sravan
            if (caseWrapper.OriginatorContactName != null && String.isNotBlank(caseWrapper.OriginatorContactName)) {
                List < String > originatorFullName = new List < String > ();
                originatorFullName = caseWrapper.OriginatorContactName.split(' ');
                if (originatorFullName.Size() > 1) {
                    callerName.firstName = originatorFullName[0];
                    callerName.lastName = originatorFullName[1];
                } else if (originatorFullName.Size() == 1) {
                    callerName.firstName = originatorFullName[0];
                }
            }


            ACET_ORSRequestWrapper.Originator originator = new ACET_ORSRequestWrapper.Originator();
            originator.providerId = caseWrapper.providerId;
            originator.callerName = callerName;
            originator.originatorTin = caseWrapper.TaxId;
            originator.originatorTinSuffix = '';
            originator.callerAddress = new ACET_ORSRequestWrapper.CallerAddress();
            originator.originatorMpin = caseWrapper.providerMpin;

            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
            ACET_ORSRequestWrapper.Cti cti = new ACET_ORSRequestWrapper.Cti();
            ACET_ORSRequestWrapper.DayPhone dayPhone = new ACET_ORSRequestWrapper.DayPhone();
            ACET_ORSRequestWrapper.EveningPhone eveningPhone = new ACET_ORSRequestWrapper.EveningPhone();

            originator.cti = cti;
            originator.dayPhone = dayPhone;
            originator.eveningPhone = eveningPhone;

            ACET_ORSRequestWrapper.OtherInfo otherInfo = new ACET_ORSRequestWrapper.OtherInfo();
            otherInfo.agencyName = '';

            ACET_ORSRequestWrapper.Employer empInfp = new ACET_ORSRequestWrapper.Employer();
            empInfp.employerName = '';
            empInfp.employerNumber = '';
            empInfp.employerState = '';
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - End



            ACET_ORSRequestWrapper.Member member = new ACET_ORSRequestWrapper.Member();
            //US2887985: Tech: Create ORS Change to Microservice - Sravan
            if (caseWrapper.SubjectAge != null && String.isNotBlank(caseWrapper.SubjectAge)) {
                String subjectAge = caseWrapper.SubjectAge;
                member.age = Integer.valueOf(subjectAge.replaceAll('[^0-9]', ''));
            } else {
                member.age = 0;
            }
            member.dateOfBirth = SAEUtils.formatDateFutureDate(caseWrapper.SubjectDOB);
            member.dateOfDeath = '';

            member.neonIndicator = 'N';
            member.memberNumber = caseWrapper.EEID;
            ACET_ORSRequestWrapper.MemberName memberName = new ACET_ORSRequestWrapper.MemberName();
            memberName.middleInitial = caseWrapper.middleInitial != null && string.isNotBlank(caseWrapper.middleInitial) ? caseWrapper.middleInitial.substring(0, 1) : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga - Changed as part of US2887985 - Sravan
            member.memberName = memberName;
            member.groupName = string.isNotBlank(caseWrapper.groupName) ? caseWrapper.groupName : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            // Group number modification
            member.groupNumber = caseWrapper.SubjectGroupId;
            member.otherGroupNumber = caseWrapper.SubjectGroupId;
            //ORS Policy-not populating
            member.policy = caseWrapper.policyNumber != '' && caseWrapper.policyNumber != null ? caseWrapper.policyNumber : (String.isNotBlank(caseWrapper.MisdirectReason) ? '' : '0' + caseWrapper.SubjectGroupId);
                member.alternateId = caseWrapper.EEID;
            member.benefitPackageCode = caseWrapper.benefitPackage;
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
            ACET_ORSRequestWrapper.Address memberAddress = new ACET_ORSRequestWrapper.Address();
            memberAddress.state = caseWrapper.plState;
            memberAddress.street1 = caseWrapper.memStreet1;
            memberAddress.street2 = caseWrapper.memStreet2;
            memberAddress.zip = caseWrapper.memZip;
            memberAddress.city = '';
            member.address = memberAddress;
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - End

            ACET_ORSRequestWrapper.Phone memberPhone = new ACET_ORSRequestWrapper.Phone();
            Map < String, String > memberPhoneMap = new Map < String, String > ();
            memberPhoneMap = getPhoneNumber(caseWrapper.subjectPhoneNumber);
            if (memberPhoneMap != null) {
                if (memberPhoneMap.containsKey('AreaCode')) {
                    memberPhone.areaCode = memberPhoneMap.get('AreaCode');
                }
                if (memberPhoneMap.containsKey('Number')) {
                    memberPhone.number_Z = memberPhoneMap.get('Number');
                }
            }
            member.phone = memberPhone;
            member.riderCodes = new List < String > {
                ''
                    };
                        ACET_ORSRequestWrapper.ServicesQuoted servicesQuoted = new ACET_ORSRequestWrapper.ServicesQuoted();
            member.servicesQuoted = servicesQuoted;

            ACET_ORSRequestWrapper.FaxNumber faxNumber = new ACET_ORSRequestWrapper.FaxNumber();
            member.faxNumber = faxNumber;
            member.totalNonCoverageCount = 0;
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - End

            //Missed Mapping
            member.relationshipCode = caseWrapper.RelationshipCode;
            ACET_ORSRequestWrapper.DependentName dependentName = new ACET_ORSRequestWrapper.DependentName();
            //Added by Vinay for Dependent Number Mapping
            if (caseWrapper.SubjectType == 'Member') {
                // added the above if condition for member name will map only for Member flow (Edited by Thanish - DE348406 - 20th Jul 2020)
                if (String.isNotBlank(caseWrapper.SubjectId)) {
                    //member.dependentNumber = caseWrapper.SubjectId; // Commented as part of dependent number is change as part of US2784325
                    if (String.isNotBlank(caseWrapper.SubjectName)) {
                        List < String > fullName = new List < String > ();
                        fullName = caseWrapper.SubjectName.split(' ');
                        if (fullName.Size() > 1) {
                            dependentName.firstName = fullName[0];
                            dependentName.lastName = fullName[1];
                        }
                    }
                }
                if (String.isNotBlank(caseWrapper.subjectFirstName) && String.isNotBlank(caseWrapper.subjectLastName)) {
                    member.memberName.firstName = caseWrapper.subjectFirstName.substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                    member.memberName.lastName = caseWrapper.subjectLastName;
                } else {
                    if (String.isNotBlank(caseWrapper.SubjectName)) {
                        List < String > fullName = new List < String > ();
                        fullName = caseWrapper.SubjectName.split(' ');
                        if (fullName.Size() > 1) {
                            member.memberName.firstName = fullName[0].substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga;
                            member.memberName.lastName = fullName[1];
                        } else {
                            member.memberName.firstName = fullName[0].substring(0, 1); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga;
                        }
                    }

                }
            }
            member.dependentName = dependentName;
            //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan-End
            member.dependentNumber = string.isNotBlank(caseWrapper.dependentNumber) ? caseWrapper.dependentNumber : ''; //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga


            // Issue main object
            ACET_ORSRequestWrapper.Issue issue = new ACET_ORSRequestWrapper.Issue();
            //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            issue.payer = string.isNotBlank(caseWrapper.payerId) ? caseWrapper.payerId : '';

            issue.providerInfo = providerInfo;
            issue.contactMethodCode = 'P';
            issue.directionCode = 'I';
            originator.originatorTypeCode = 'PR';
            if (!caseRecord.isEmpty()) {
                if (caseRecord.get(0).Originator_Type__c == 'Other' && finalContactTypeToORSCodeMap.get(caseWrapper.OtherOrginatorType) != NULL)
                    originator.originatorTypeCode = finalContactTypeToORSCodeMap.get(caseWrapper.OtherOrginatorType);
                else if (caseRecord.get(0).Originator_Type__c == 'Member' || caseRecord.get(0).Originator_Type__c == 'Provider')
                    originator.originatorTypeCode = finalContactTypeToORSCodeMap.get(caseRecord.get(0).Originator_Type__c);
            }
            issue.originator = originator;
            issue.otherInfo = otherInfo;
            issue.contactElapseTime = 0;
            issue.contactId = '';

            issue.employer = empInfp;
            issue.member = member;
            ACET_ORSRequestWrapper.CarbonCopies carbonCopies = new ACET_ORSRequestWrapper.CarbonCopies();
            ACET_ORSRequestWrapper.RoutedTo routedTo = new ACET_ORSRequestWrapper.RoutedTo();
            ACET_ORSRequestWrapper.ResolvedBy resolvedBy = new ACET_ORSRequestWrapper.ResolvedBy();
            ACET_ORSRequestWrapper.IssueHandling issueHandling = new ACET_ORSRequestWrapper.IssueHandling();
            issueHandling.carbonCopies = new List < ACET_ORSRequestWrapper.CarbonCopies > {
                carbonCopies
                    };
                        issueHandling.routedTo = routedTo;
            issueHandling.resolvedBy = resolvedBy;
            issue.issueHandling = issueHandling;
            ACET_ORSRequestWrapper.Grievance grievance = new ACET_ORSRequestWrapper.Grievance();
            issue.grievance = grievance;
            issue.issueElapseTime = 0;

            ACET_ORSRequestWrapper.Claim claim = new ACET_ORSRequestWrapper.Claim();
            if(caseWrapper.claimNumber=='No Results Found'){
              claim.claimNumber = '0000000000';
            }else
            {
              claim.claimNumber = caseWrapper.claimNumber;
            }
            claim.serviceDate = caseWrapper.serviceDate;
            ACET_ORSRequestWrapper.Drafts drafts = new ACET_ORSRequestWrapper.Drafts();
            ACET_ORSRequestWrapper.Atg atg = new ACET_ORSRequestWrapper.Atg();
            atg.drafts = new List < ACET_ORSRequestWrapper.Drafts > {
                drafts
                    };
                        claim.atg = atg;
            issue.claim = claim;

            ACET_ORSRequestWrapper.CellPhone cellPhone = new ACET_ORSRequestWrapper.CellPhone();
            ACET_ORSRequestWrapper.Creator creator = new ACET_ORSRequestWrapper.Creator();
            ACET_ORSRequestWrapper.Fax fax = new ACET_ORSRequestWrapper.Fax();
            ACET_ORSRequestWrapper.HomePhone homePhone = new ACET_ORSRequestWrapper.HomePhone();
            ACET_ORSRequestWrapper.OtherPhone otherPhone = new ACET_ORSRequestWrapper.OtherPhone();
            ACET_ORSRequestWrapper.WorkPhone workPhone = new ACET_ORSRequestWrapper.WorkPhone();

            ACET_ORSRequestWrapper.FollowUp followUp = new ACET_ORSRequestWrapper.FollowUp();
            followUp.cellPhone = cellPhone;
            followUp.creator = creator;
            followUp.fax = fax;
            followUp.homePhone = homePhone;
            followUp.otherPhone = otherPhone;
            followUp.workPhone = workPhone;



            issue.followUp = followUp;
            issue.logoLookups = new List < ACET_ORSRequestWrapper.LogoLookups > {
                new ACET_ORSRequestWrapper.LogoLookups()
                    };
                        issue.serviceRequest = new ACET_ORSRequestWrapper.ServiceRequest();


            if (saeReasonCodes != null && saeReasonCodes.size() > 0) {
                issue.reasonCategory = saeReasonCodes.get(0).Category_API__c;
                issue.reasonCode = saeReasonCodes.get(0).Reason_API__c;
            }


            issue.priority = 'N';

            issue.status = caseRecord.get(0).Status == 'Closed' ? 'C' : 'O';

            if (issue.status == 'C' && caseWrapper.ttsType != null && caseWrapper.ttsType == 'System Unavailable') {
                caseCommentDefault = 'ORS Issue created when System unavailable for ACET Case :- ' + caseNumber;
            }

            orsCaseComments.add(caseCommentDefault);


            //US3149404 - Sravan - Start
            String relatedCaseItemComments = '';
            if(caseWrapper.relatedCaseItems != null && String.isNotBlank(caseWrapper.relatedCaseItems)){
                Integer length = caseWrapper.relatedCaseItems.length();
                if (length > 71) {
                    Integer noOfIterations = (Integer) length / 71;
                    for (Integer i = 0; i <= noOfIterations; i++) {
                        if (length > (i * 71) + 71) {
                            orsCaseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, (i * 71) + 71));
                            relatedCaseItemComments = caseWrapper.relatedCaseItems.subString(i * 71, (i * 71) + 71);
                        } else {
                            orsCaseComments.add(caseWrapper.relatedCaseItems.subString(i * 71, length));
                            relatedCaseItemComments = caseWrapper.relatedCaseItems.subString(i * 71, length);
                        }
                    }
                } else {
                    orsCaseComments.add(caseWrapper.relatedCaseItems);
                    relatedCaseItemComments = caseWrapper.relatedCaseItems;
                }
            }
            //US3149404 - Sravan - End
            system.debug('ORS Comments'+ orsCaseComments );
            issue.comments = orsCaseComments;


            // US2098648 - Benefit ORS
            issue.caseNumber = caseNumber;
            String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId'); //673/JR2
            List < String > businessSegmentList = new List < String > ();
            businessSegmentList = (List < String > ) Cache.Session.get('local.TOPSProfileInfo.businessGroups');
            List < String > searchInputParams = new List < String > ();
            if (!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            } else {
                // Thanish - 17th Jun 2020 - Code Coverage
                if (!Test.isRunningTest()) {
                    ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                    loginflow.validateTopsCredentials();
                    topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
                    if (businessSegmentList == null) {
                        businessSegmentList = (List < String > ) Cache.Session.get('local.TOPSProfileInfo.businessGroups');
                    }
                    if (!String.isBlank(topsUserId)) {
                        searchInputParams = topsUserId.split('/');
                    }
                }
            }
            //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            if (businessSegmentList != null && !businessSegmentList.isEmpty() && businessSegmentList.contains('STANDARD')) {
                issue.businessSegmentName = 'STANDARD';
            } else {
                issue.businessSegmentName = '';
            }
            ACET_ORSRequestWrapper.OrsSourceSystemParameters sysPar = new ACET_ORSRequestWrapper.OrsSourceSystemParameters();
            if (!searchInputParams.isempty()) {
                sysPar.logonOffice = searchInputParams[0];
                sysPar.logonId = searchInputParams[1];
            }

            //Added by Vinay

            ACET_ORSRequestWrapper.controlModifiers controlModifiers = new ACET_ORSRequestWrapper.controlModifiers();
            controlModifiers.orsSourceSystemParameters = sysPar;

            ACET_ORSRequestWrapper.Meta metaInfo = new ACET_ORSRequestWrapper.Meta();
            metaInfo.controlModifiers = controlModifiers;

            ACET_ORSRequestWrapper.Data dataObj = new ACET_ORSRequestWrapper.Data();
            dataObj.issue = issue;

            ACET_ORSRequestWrapper acetORS = new ACET_ORSRequestWrapper();
            acetORS.meta = metaInfo;
            acetORS.data = dataObj;

            String orsRequest = '';

            // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
            HttpResponse responseStr;


            acetORS.data.issue.status = 'C';
            orsRequest = '';

            if (caseWrapper.ttsType == 'Issue Routed') {
                List < String > caseComments = new List < String > ();
                caseComments.add(caseCommentDefault);

                //Ketki Claims ORS case creation
                if( caseWrapper.claimCaseStatus != null && caseWrapper.claimCaseStatus != ''){
                    acetORS.data.issue.status = caseWrapper.claimCaseStatus;
                }
                if( caseWrapper.claimComments != null && caseWrapper.claimComments.size() > 0){
                    System.debug('Adding claim comments to ORS comments '+ caseWrapper.claimComments);
                    if(caseWrapper.AddInfoOrginSubType == 'Claims Project 20+ Claims'){
                        caseComments.add(relatedCaseItemComments);
                    }
                    else{
                    caseComments.addAll(caseWrapper.claimComments);
                }

                }
                //Ketki Claims ORS case creation  end
                acetORS.data.issue.comments = caseComments;

                System.debug('Ketki log: SAECaseCreationController officeAPI :: '+ caseWrapper.officeAPI);
            	System.debug('Ketki log: SAECaseCreationController: departmentAPI :: '+caseWrapper.departmentAPI);
            	System.debug('Ketki log: SAECaseCreationController: teamAPI :: '+ caseWrapper.teamAPI);
                System.debug('Ketki log: SAECaseCreationController: associateId :: '+ caseWrapper.associateId);

                if((caseWrapper.officeAPI!= null && caseWrapper.officeAPI != '')  &&
                   	(caseWrapper.departmentAPI!= null && caseWrapper.departmentAPI != '') &&
                   (caseWrapper.teamAPI!= null && caseWrapper.teamAPI != '')){
                            acetORS.data.issue.IssueHandling.routedTo.officeId = caseWrapper.officeAPI;
                            acetORS.data.issue.IssueHandling.routedTo.departmentCode = caseWrapper.departmentAPI;
                            acetORS.data.issue.IssueHandling.routedTo.teamCode = caseWrapper.teamAPI;
                       		acetORS.data.issue.IssueHandling.routedTo.associateId = caseWrapper.associateId;
                            isResolved = false;//US3644559 - Sravan
                 }



                Object reqObjResolved = addCreateIssueAttributes(acetORS);
                orsRequest = JSON.serialize(reqObjResolved);

                //orsRequest = orsRequest.replace('null', '""').replace('number_Z', 'number').replace('--', '');
				orsRequest = orsRequest.replace('number_Z', 'number').replace('--', '');
        		system.debug('The claim request body'+ orsRequest);

                StateInfo response = new StateInfo();
                response.httpRequest =  (HttpRequest)ACET_ORSWebservice.createORSIssueRequest(orsRequest) ;
                response.isResolved = isResolved;
                return response;

            } else {
           		 	return null;
            }


    }

   public static ORSResultWrapper createORSRecordClaimResponse( HttpResponse responseStr, String policyNumber, String claimNumber , boolean isResolved ){

        ORSResultWrapper resultWrapper = new ORSResultWrapper();

        String returnId = '';


        try{

                //US3068040 Jitendra to make another callout to ORS System if Status Code is 409
                if(responseStr.getStatusCode() == 409) {
                    System.debug(' Inside 409 ');
                    //responseStr = (HttpResponse) ACET_ORSWebservice.createORSIssue(orsRequest);
                }

                if (responseStr.getStatusCode() != 200) {
                    ORSResultWrapper errorObject = new ORSResultWrapper();
                    //US3644559 - Sravan - Start
					 errorObject.relatedGroupNumber = policyNumber;
					 errorObject.relatedclaimNumber = claimNumber;
					 if(isResolved){
					   errorObject.isResolved = true;
                     }
                     else{
                       errorObject.isResolved = false;
                     }
					//US3644559 - Sravan - End
                    errorObject.resultStatus = responseStr.getStatusCode();
                    if (responseStr.getStatusCode() == 400) {
                        errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    } else if (responseStr.getStatusCode() == 404) {
                        errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                    } else if (responseStr.getStatusCode() == 500) {
                        errorObject.resultStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    } else {
                        errorObject.resultStatusMessage = 'Unexpected error occured while creating ORS case. Error Code: ' + String.valueOf(responseStr.getStatusCode());
                    }
                    return errorObject;
                }



                if (responseStr != null) {
                    if (responseStr.getStatusCode() == 200) {
                        ORSResponseWrapper orsResponse = (ORSResponseWrapper) JSON.deserialize(responseStr.getBody(), ORSResponseWrapper.class);
                        resultWrapper.resultStatus = 200;
                        resultWrapper.resultStatusMessage = 'Success';
                        returnId = orsResponse.data.createIssueOutput.issueId;
                        system.debug('Calim Response'+orsResponse);
						//US3644559 - Sravan - Start
							resultWrapper.relatedGroupNumber = policyNumber;
							resultWrapper.relatedclaimNumber = claimNumber;
						if(isResolved){
							resultWrapper.isResolved = true;
                        }
                        else{
							resultWrapper.isResolved = false;
                        }
						//US3644559 - Sravan - End
                        resultWrapper.orsReturnId = returnId;

                    }
                }

         	return resultWrapper;
         } catch (Exception ex) {
            System.debug('ORS Case Creation ' + ex.getStackTraceString());
            ORSResultWrapper errorObject = new ORSResultWrapper();
            errorObject.resultStatus = 999;
            errorObject.resultStatusMessage = 'Unexpected error occured while creating ORS case. Error Code: 999';
            //US3644559 - Sravan - Start
			errorObject.relatedGroupNumber = policyNumber;
			errorObject.relatedclaimNumber = claimNumber;
			if(isResolved){
			   errorObject.isResolved = true;
            }
            else{
               errorObject.isResolved = false;
            }
            return errorObject;
        }

    }

    // ORS Wrappers Start
    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
    public class ORSResponseWrapper {
        public Meta meta;
        public Data data;

    }
    public class Meta {
        public List < Warnings > warnings;
    }
    public class Warnings {
        public String code;
        public String title;
        public String detail;
        public String field;
    }
    public class Data {
        public CreateIssueOutput createIssueOutput;
    }
    public class CreateIssueOutput {
        public String contactId;
        public String issueId;
    }

    public class ORSResultWrapper {
        @AuraEnabled
        public Integer resultStatus;
        @AuraEnabled public String resultStatusMessage;
        @AuraEnabled public String orsReturnId;
		@AuraEnabled public String relatedGroupNumber;//US3644559 - Sravan
		@AuraEnabled public String relatedclaimNumber;//US3644559 - Sravan
		@AuraEnabled public Boolean isResolved;//US3644559 - Sravan



    }
    // End

    // US2737680 - End User ORS Creation - Sanka
    // Returning true if the logged user is 'End User'
    // @AuraEnabled - Incase needed
    @AuraEnabled
    public static Boolean isEndUser() {
        Boolean isValid = false;
        try {
            List < User > loggedUser = [SELECT Id, User_Type__c FROM User WHERE Id =: UserInfo.getUserId()];
            if (loggedUser.size() > 0 && loggedUser.get(0).User_Type__c == 'End User') {
                isValid = true;
            } else {
                isValid = false;
            }
        } catch (Exception e) {
            isValid = false;
        }
        return isValid;
    }

    //US2887985: Tech: Create ORS Change to Microservice - Sravan
    @TestVisible
    private static Object addCreateIssueAttributes(ACET_ORSRequestWrapper acetORS) {
        String orsReq = JSON.serialize(acetORS);
        Map < String, Object > requestMap = (Map < String, Object > ) JSON.deserializeUntyped(orsReq);
        String orsdata = JSON.serialize(requestMap.get('data'));
        Map < String, Object > orsMap = (Map < String, Object > ) JSON.deserializeUntyped(orsdata);
        orsMap.put('createdByApplicationIndicator', 'H');
        Object dataObject = (Object) orsMap;
        requestMap.put('data', dataObject);
        return (Object) requestMap;
    }

    //US2887985: Tech: Create ORS Change to Microservice - Sravan
    @TestVisible
    private static Map < String, String > getPhoneNumber(String phoneNumber) {
        Map < String, String > phoneMap = new Map < String, String > ();
        if (phoneNumber != null && String.isNotBlank(phoneNumber)) {
            //To check special characters in phone number
            String finalNumber = phoneNumber.replaceAll('[^0-9]', '');
            system.debug('Final Number' + finalNumber);
            if (finalNumber != null && String.isNotBlank(finalNumber)) {
                if (finalNumber.length() == 10) {
                    String areaCode = finalNumber.subString(0, 3);
                    String numberValue = finalNumber.subString(3, 10);
                    phoneMap.put('AreaCode', areaCode);
                    phoneMap.put('Number', numberValue);
                } else if (finalNumber.length() == 7) {
                    phoneMap.put('AreaCode', '');
                    phoneMap.put('Number', finalNumber);
                }
            }
        }
        return phoneMap;
    }

    /* Create Facets Record
        @param String strCaseWrapper : Stringfied value of strCaseWrapper
        @param String strCaseId : String Value of CaseId
        Return Type : Boolean If True its create Facets record is successful else Facets Creation is Failed
    */
    @AuraEnabled
    public static String createFacetsRecord(String strCaseWrapper, String strCaseId) {
        String isFacetsEnabled = System.Label.ACET_FacetsEngineTrigger;
        if(!isFacetsEnabled.equalsIgnoreCase('true')){
            return '';
        }
        return (String)ACET_FacetsWebservice.ProcessFacetsRecord(strCaseWrapper, strCaseId);
    }

    public static List<String> commentsValidation(List<String> commentsList) {

        for(string str: commentsList){
            str.replace('\u2014', '-');
        }
        return commentsList;
    }


    public static void saveChildCase(case parentCase, string strRecord,case queriedCase){
        try{
            system.debug('==strRecord='+strRecord);
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> childMap = new Map<string,SAETTSCaseWrapper.SRSourceCodeInfo>();
            if(caseWrapper.SRClaimMap != null && !caseWrapper.SRClaimMap.isEmpty()){
                childMap = processMap(strRecord);
            }

            if( childMap != null && !childMap.isEmpty() && queriedCase != null ){
                List<case> lstofChildCases = new List<case>();
                lstofChildCases = getProcessedChildCases(childMap,parentCase,queriedCase,caseWrapper);
                if(!lstofChildCases.isEmpty()){
                    PDRelatedCases(lstofChildCases,childMap,queriedCase);
                }
            }
        }
        catch(Exception e){
            system.debug('@e@'+e.getMessage());
            system.debug('@e strack@'+e.getStackTraceString());
        }
    }

    public static void PDRelatedCases(List<case>lstofChildCases ,Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> childMap,case queriedCase){
        Group queue = [SELECT Id, DeveloperName FROM Group where DeveloperName = 'CPM_Spire_Intake' AND Type = 'Queue'];
        insert lstofChildCases;
        List<Case> lstToUpdate = new List<Case>();
        List<Project_Submission_Detail__c> lstOfPSDs = new List<Project_Submission_Detail__c>();
        for(case cr:  lstofChildCases){
            Project_Submission_Detail__c psd = new Project_Submission_Detail__c();
            psd.Case__c = cr.id;
            string sCode = '';
            switch on cr.Type__c{
                when 'M&R COSMOS' {  sCode = 'CO' ;}
                when 'E&I UNET' {  sCode = 'CS' ;}
                when 'C&S CSP Facets' {  sCode = 'AP' ;}
                when else {}
            }
            List<string> lstClaims = childMap.get(sCode).ClaimsInfo;
            if(childMap.get(sCode) != NULL && !lstClaims.isEmpty()){
                psd.Beginning_Date__c = Date.valueof(childMap.get(sCode).BeginDOS) ;
                psd.Ending_Date__c = Date.valueof(childMap.get(sCode).EndDOS);
                psd.Issue_Description__c = childMap.get(sCode).comment;
                lstClaims = getprocessedList(lstClaims,3);
                psd.Claim_Examples__c = string.join(lstClaims, ', ');
            }

            if(queue != null){
                cr.ownerId = queue.Id;
                lstToUpdate.add(cr);
            }
            lstOfPSDs.add(psd);
        }
        insert lstOfPSDs;
        if(!lstToUpdate.isEmpty()){
            update lstToUpdate;
        }
        queriedCase.PC_ResurrectedLevel__c = lstofChildCases.size();
        update queriedCase;
    }


    public static List<case> getProcessedChildCases(Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> childMap,case parentCase, case queriedCase, SAETTSCaseWrapper caseWrapper){
        List<case> lstofChildCases = new List<case>();
        Id recordtypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'case' AND Name = 'Claim Project Management'].Id;
        for(string str: childMap.keyset()){
            Case childObj = new Case();
            childObj.ParentId = parentCase.Id;
            childObj.Status = 'New';
            childObj.RecordTypeId = recordtypeId ;
            childObj.Submitting_Department__c = 'Spire Call Advocate';
            childObj.PC_Referral_Number__c = queriedCase.caseNumber;
            childObj.Retro_Reason_Code__c = 'Unknown';
            childObj.Topic__c = 'Provider Driven';
            switch on str{
                when 'CO'{ childObj.Type__c = 'M&R COSMOS'; }
                when 'CS' { childObj.Type__c = 'E&I UNET'; }
                when 'AP' { childObj.Type__c = 'C&S CSP Facets'; }
                when else {}
            }
            childObj.PC_Contact_Type__c = 'External';
            childObj.PC_External_Contact_Name__c = caseWrapper.OriginatorContactName;
            childObj.PC_External_Contact_Phone__c = caseWrapper.contactNumber;
            childObj.PC_External_Contact_Email__c = childMap.get(str).email;
            childObj.Origin = 'Spire';
            childObj.PC_Project_Description__c =  caseWrapper.issueId;
            childObj.PC_Provider_Name__c = caseWrapper.OriginatorName;
            childObj.Provider_Type__c = (string.isNotBlank( caseWrapper.providerFilterType) && caseWrapper.providerFilterType == 'P') ? 'Physician' : 'Facility / Group';
            childObj.PC_Provider_State__c = caseWrapper.plState;
            childObj.PC_Provider_ID__c = caseWrapper.plProviderID;
            childObj.PC_Provider_TIN__c	 = caseWrapper.plTaxId;
            lstofChildCases.add(childObj);
        }
        return lstofChildCases;
    }

    public static  Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> processMap(string strRecord){
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
        system.debug('==caseWrapper.SRClaimMap=='+caseWrapper.SRClaimMap);
        Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> processMap = new Map<String,SAETTSCaseWrapper.SRSourceCodeInfo>();
        Map<string,SAETTSCaseWrapper.SRSourceCodeInfo> existingMap = caseWrapper.SRClaimMap;
        string coComment = '';
        for(string str : existingMap.keyset()){
            if(str == 'CO - Physician'){
                if(processMap.get('CO') != NULL){
                    List<string> existingClaimsList = processMap.get('CO').ClaimsInfo;
                    existingClaimsList.addAll(existingMap.get(str).ClaimsInfo);
                    SAETTSCaseWrapper.SRSourceCodeInfo exSR =  processMap.get('CO');
                    exSR.ClaimsInfo = existingClaimsList;
                    exSR.comment = getValueoff(coComment,exSR.comment);
                    processMap.put('CO',exSR);
                }
                else{
                    processMap.put('CO',existingMap.get(str));
                }

            }
            else if(str == 'CO - Hospital'){

                if(processMap.get('CO') != NULL){
                    List<string> existingClaimsList = processMap.get('CO').ClaimsInfo;
                    coComment =  processMap.get('CO').comment;
                    existingClaimsList.addAll(existingMap.get(str).ClaimsInfo);
                    SAETTSCaseWrapper.SRSourceCodeInfo exSR =  existingMap.get(str);
                    exSR.ClaimsInfo = existingClaimsList;
                    processMap.put('CO',exSR);
                }
                else{
                    processMap.put('CO',existingMap.get(str));
                }

            }
            else{
                processMap.put(str, existingMap.get(str));
            }
        }
        system.debug('@processMap@'+processMap);
        return processMap;
    }

    public static String getValueoff(String value,string comment){
        return String.isNotBlank(value)?value:comment;
    }

    public static list<string> getprocessedList(List<string> lstInput, Integer n){
        Integer count = 0;
        List<string> lstToReturn = new List<String>();
        for(string str: lstInput){
            if(count == n) break;
            else{lstToReturn.add(str);count = count+1;}
        }
        system.debug('@lstToReturn@'+lstToReturn);
        return lstToReturn;
    }
}