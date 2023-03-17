// US2830355 - Thanish - 21st Sep 2020
// US2981549 - Krishnanshu - 22nd Oct 2020 - Auto Doc - Reporting - Contract Summary
public class ACET_ProviderContractSummaryController {
    static final string COMMON_ERROR_MESSAGE_CNS = 'Unexpected Error Occurred with the C&S Contracts. Please try again. If problem persists please contact the help desk.';
    static final string COMMON_ERROR_MESSAGE_ENI = 'Unexpected Error Occurred with the E&I Contracts. Please try again. If problem persists please contact the help desk.';
    static final string COMMON_ERROR_MESSAGE_MNR = 'Unexpected Error Occurred with the M&R Contracts. Please try again. If problem persists please contact the help desk.';
    static final string COMMON_ERROR_MESSAGE_All = 'No Contract Summary Active UHN Results';
    static final string COMMON_ERROR_MESSAGE = 'NO RECORDS';

    // contract table details in new autodoc framework data structure
    public class ContractTable {
        @AuraEnabled public String type;
        @AuraEnabled public String autodocHeaderName;
        @AuraEnabled public String componentName; //US2981549
        @AuraEnabled public Boolean isResolvedReportable; //US2981549
        @AuraEnabled public Integer componentOrder;
        @AuraEnabled public Boolean showComponentName;
        @AuraEnabled public Boolean isSortable;
        @AuraEnabled public Boolean caseItemsEnabled;
        @AuraEnabled public List < String > tableHeaders;
        @AuraEnabled public List < HoverHeader > tableHoverHeaders;
        @AuraEnabled public List < Row > tableBody;
        // response status variables
        @auraEnabled public boolean success;
        @auraEnabled public string message;
        @auraEnabled public ApexPages.Severity severity;
        @auraEnabled public integer statusCode;

        public ContractTable() {
            type = 'table';
            autodocHeaderName = '';
            componentName = '';
            componentOrder = 0;
            showComponentName = false;
            isSortable = true;
            caseItemsEnabled = true;
            tableHeaders = new List < String > ();
            tableHoverHeaders = new List < HoverHeader > ();
            tableBody = new List < Row > ();
            isResolvedReportable = false; //US2981549
            // response status variables initialization
            success = true;
            message = 'Success';
            severity = ApexPages.Severity.CONFIRM;
            statusCode = 200;
        }
    }

    public class HoverHeader {
        @AuraEnabled public String popupId;
        @AuraEnabled public String headerValue;
        @AuraEnabled public String hoverDescription;
        @AuraEnabled public String hoverWidth;
        @AuraEnabled public Boolean hasHover;
        @AuraEnabled public Boolean alignRight;
        @AuraEnabled public List < String > hoverDescriptionList;

        public HoverHeader() {
            hoverDescriptionList = new List < String > ();
            hasHover = false;
            alignRight = true;
        }
    }

    public class Row {
        @AuraEnabled public Boolean checked;
        @AuraEnabled public Boolean resolved;
        @AuraEnabled public Boolean linkDisabled;
        @AuraEnabled public Boolean checkBoxDisabled;
        @AuraEnabled public String caseItemsExtId;
        @AuraEnabled public String uniqueKey;
        @AuraEnabled public List < RowData > rowColumnData;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails contractDetails;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails timelyFiling;

        // US3468218 - Fee Schedule Integration
        @AuraEnabled public FeeScheduleData feeScheduleData;

        public Row() {
            rowColumnData = new List < RowData > ();
        }
    }

    public class RowData {
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String titleName;
        @AuraEnabled public Boolean isOutputText;
        @AuraEnabled public Boolean isLink;
        @AuraEnabled public Boolean isIcon;
        @AuraEnabled public String iconName;
        @AuraEnabled public Boolean isNoRecords;
        @AuraEnabled public String tdStyle;
        @AuraEnabled public Boolean isReportable; // US2981549 Adding field for reporting 

        public RowData(String fL, String fV, String tN, Boolean oT, Boolean iL, Boolean iI, String tS) {
            fieldLabel = fL;
            fieldValue = fV;
            titleName = tN;
            isOutputText = oT;
            isLink = iL;
            isIcon = iI;
            tdStyle = tS;
        }
        //new constructor of isReportable field
        public RowData(String fL, String fV, String tN, Boolean oT, Boolean iL, Boolean iI, String tS, Boolean iR) {
            fieldLabel = fL;
            fieldValue = fV;
            titleName = tN;
            isOutputText = oT;
            isLink = iL;
            isIcon = iI;
            tdStyle = tS;
            isReportable = iR;
        }
    }

    // US3468218 - Fee Schedule Integration
    public class FeeScheduleData
    {
        @AuraEnabled public String prodCode;
        @AuraEnabled public String prodOffId;
        @AuraEnabled public String taxId;
        @AuraEnabled public String provId;
        @AuraEnabled public String market;
        @AuraEnabled public String mktType;
        @AuraEnabled public String ipa;
        @AuraEnabled public String feeSchedNo;
    }

    @AuraEnabled
    public static Map < String, ContractTable > getAllContracts(string providerId, string taxId, string addressId, string addressSeq) {
        ContractTable cnsTable = ACET_ProviderContractSummaryController.getCNSContractsData(providerId, taxId, addressId, false);
        ContractTable eniTable = ACET_ProviderContractSummaryController.getENIContractsData(providerId, taxId, addressSeq, false);
        ContractTable mnrTable = ACET_ProviderContractSummaryController.getMNRContractsData(providerId, taxId, addressId, false);

        Map < String, ContractTable > tableMap = new Map < String, ContractTable > ();
        tableMap.put('cnsTable', cnsTable);
        tableMap.put('eniTable', eniTable);
        tableMap.put('mnrTable', mnrTable);

        return tableMap;
    }

    @auraEnabled
    public static ContractTable getCNSContractsData(string providerId, string taxId, string addressId, boolean isActive) {
        ContractTable cnsTable = new ContractTable();

        // get c and s contract data from api
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getCAndSContracts(providerId, taxId, addressId, isActive);

        if (calloutResult.Success) {
            // cast callout result to c and s contract response
            ACET_CAndSContractsResponse contractResponse = (ACET_CAndSContractsResponse) calloutResult.Response;
            cnsTable.autodocHeaderName = 'C&S Contract Summary';
            cnsTable.componentName = 'C&S Contract Summary'; //US2981549
            cnsTable.tableHeaders = new List < String > {
                'CONTRACT ID',
                'STATUS',
                'NETWORK ID',
                'NETWORK PREFIX',
                'EFFECTIVE-CANCEL',
                'TYPE',
                'NEW PATIENTS?'
            };

            String headerPopupId = String.valueof(DateTime.now().getTime());

            HoverHeader contractId = new HoverHeader();
            contractId.popupId = headerPopupId + 'contractId';
            contractId.headerValue = 'CONTRACT ID';
            cnsTable.tableHoverHeaders.add(contractId);

            HoverHeader status = new HoverHeader();
            status.popupId = headerPopupId + 'status';
            status.headerValue = 'STATUS';
            cnsTable.tableHoverHeaders.add(status);

            HoverHeader networkId = new HoverHeader();
            networkId.popupId = headerPopupId + 'networkId';
            networkId.headerValue = 'NETWORK ID';
            cnsTable.tableHoverHeaders.add(networkId);

            HoverHeader networkPrefix = new HoverHeader();
            networkPrefix.popupId = headerPopupId + 'networkPrefix';
            networkPrefix.headerValue = 'NETWORK PREFIX';
            cnsTable.tableHoverHeaders.add(networkPrefix);

            HoverHeader effectiveCancel = new HoverHeader();
            effectiveCancel.popupId = headerPopupId + 'effectiveCancel';
            effectiveCancel.headerValue = 'EFFECTIVE-CANCEL';
            cnsTable.tableHoverHeaders.add(effectiveCancel);

            HoverHeader type = new HoverHeader();
            type.popupId = headerPopupId + 'type';
            type.headerValue = 'TYPE';
            cnsTable.tableHoverHeaders.add(type);

            HoverHeader newPatients = new HoverHeader();
            newPatients.popupId = headerPopupId + 'newPatients';
            newPatients.hasHover = true;
            newPatients.headerValue = 'NEW PATIENTS?';
            newPatients.hoverWidth = '430px';
            newPatients.hoverDescription = 'See below for description:';
            newPatients.hoverDescriptionList.add('N - No new patients accepted');
            newPatients.hoverDescriptionList.add('Y - New patients are being accepted');
            newPatients.hoverDescriptionList.add('E - New patients accepted on exception basis only');
            newPatients.hoverDescriptionList.add('R - Accepting new patients with restrictions (age, gender, etc).');
            cnsTable.tableHoverHeaders.add(newPatients);

            try {
                // additional pti hover details
                List < String > addPtiDescList = new List < String > ();
                addPtiDescList.add('Y - Individual');
                addPtiDescList.add('N - Group');
                addPtiDescList.add('E - Either Individual or Group');
                addPtiDescList.add('M - Multiple Group Records');
                addPtiDescList.add('G - Group Contract');
                addPtiDescList.add('O - Non Par Group');

                // capitaion hover details
                List < String > capitationDescList = new List < String > ();
                capitationDescList.add('C - Capitated');
                capitationDescList.add('F - Fee for Service');

                // index to generate cns ID
                integer index = 0;

                if (contractResponse.communityandstate != null) {
                    for (ACET_CAndSContractsResponse.Communityandstate communityAndState: contractResponse.communityandstate) {
                        // initialize and populate contract data
                        Row row = new Row();
                        row.checked = false;
                        row.resolved = false;
                        row.linkDisabled = false;
                        row.checkBoxDisabled = false;
                        row.caseItemsExtId = communityAndState.ovtn_contr_id;

                        // generate cns ID
                        row.uniqueKey = 'cns' + index;
                        index++;

                        // --- Contract Summary ---
                        // populate contract id field
                        row.rowColumnData.add(new RowData('CONTRACT ID', communityAndState.ovtn_contr_id, '', true, false, false, '', true));
                        // determine and populate contract active status
                        if (!String.isBlank(communityAndState.ovtn_canc_dt)) {
                            String[] dateStringArray = communityAndState.ovtn_canc_dt.split('-');
                            Date cancelDate = Date.newInstance(Integer.valueOf(dateStringArray[0]), Integer.valueOf(dateStringArray[1]), Integer.valueOf(dateStringArray[2]));
                            if (cancelDate.daysBetween(Date.today()) < 0) {
                                RowData cStatus = new RowData('STATUS', 'Active', 'Active', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:approval';
                                row.rowColumnData.add(cStatus);
                            } else {
                                RowData cStatus = new RowData('STATUS', 'Inactive', 'Inactive', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:close';
                                row.rowColumnData.add(cStatus);
                            }
                        } else {
                            RowData cStatus = new RowData('STATUS', 'Undefined', 'Undefined', false, false, true, 'text-align: center;', true);
                            cStatus.iconName = 'standard:macros';
                            row.rowColumnData.add(cStatus);
                        }
                        // populate network id (api gap)
                        row.rowColumnData.add(new RowData('NETWORK ID', '--', '', true, false, false, '', true));
                        // populate network prefix (api gap)
                        row.rowColumnData.add(new RowData('NETWORK PREFIX', '--', '', true, false, false, '', true));
                        // populate Effective/Cancel field
                        row.rowColumnData.add(new RowData('EFFECTIVE-CANCEL', SAEUtils.formatDate(communityAndState.ovtn_eff_dt) + ' - ' + SAEUtils.formatDate(communityAndState.ovtn_canc_dt), '', false, true, false, '', true));
                        // determine and populate contract type
                        if (communityAndState.ovtn_pcp_ind == 'S') {
                            row.rowColumnData.add(new RowData('TYPE', 'Specialist', '', true, false, false, '', true));
                        } else if (communityAndState.ovtn_pcp_ind == 'P') {
                            row.rowColumnData.add(new RowData('TYPE', 'PCP', '', true, false, false, '', true));
                        } else {
                            row.rowColumnData.add(new RowData('TYPE', '--', '', true, false, false, '', true));
                        }
                        // populate New Patients? field
                        row.rowColumnData.add(new RowData('NEW PATIENTS', (String.isEmpty(communityAndState.ovtn_acpt_new_ptnt_ind) ? communityAndState.ovtn_acpt_new_ptnt_ind : '--'), '', true, false, false, '', true));

                        // --- Contract Details --- (api gap)
                        ACET_AutoDocUtil.CardDetails cDetails = new ACET_AutoDocUtil.CardDetails();
                        cDetails.type = 'card';
                        cDetails.componentName = 'C&S Contract Details : ' + communityAndState.ovtn_contr_id;
                        cDetails.noOfColumns = 'slds-size_1-of-5';
                        cDetails.componentOrder = 0;
                        List < ACET_AutoDocUtil.FieldDetails > cardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate additional pti
                        ACET_AutoDocUtil.FieldDetails additionalPti = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional PTI', '--', 'hoverText');
                        additionalPti.popupId = String.valueof(DateTime.now().getTime());
                        additionalPti.isNubbinLeft = true;
                        additionalPti.description = 'See below for description:';
                        additionalPti.descriptionList = addPtiDescList;
                        additionalPti.isReportable = true; // US2981549
                        additionalPti.popupWidth = '180px';
                        cardDataList.add(additionalPti);
                        // populate capitation
                        ACET_AutoDocUtil.FieldDetails capitaion = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Capitaion', '--', 'hoverText');
                        capitaion.popupId = String.valueof(DateTime.now().getTime());
                        capitaion.isNubbinLeft = true;
                        capitaion.description = 'See below for description:';
                        capitaion.descriptionList = capitationDescList;
                        capitaion.isReportable = true; // US2981549
                        capitaion.popupWidth = '150px';
                        cardDataList.add(capitaion);
                        // populate precert reduction field
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Precert Reduction', '--', 'outputText', true));
                        // populate reduction % field
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reduction %', '--', 'outputText', true));
                        // populate claim type
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Claim Type', '--', 'outputText', true));

                        cDetails.cardData = cardDataList;
                        row.contractDetails = cDetails;

                        // --- Timely Filing --- (api gap)
                        ACET_AutoDocUtil.CardDetails tFiling = new ACET_AutoDocUtil.CardDetails();
                        tFiling.type = 'card';
                        tFiling.componentName = 'C&S Timely Filing : ' + communityAndState.ovtn_contr_id;
                        tFiling.noOfColumns = 'slds-size_1-of-3';
                        tFiling.componentOrder = 0;
                        List < ACET_AutoDocUtil.FieldDetails > tfCardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate initial claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Initial Claim', '--', 'outputText', true));
                        // populate appeal field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal', '--', 'outputText', true));
                        // populate reconsideration field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reconsideration', '--', 'outputText', true));
                        // populate additional information field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional Information', '--', 'outputText', true));
                        // populate corrected claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Corrected Claim', '--', 'outputText', true));

                        tFiling.cardData = tfCardDataList;
                        row.timelyFiling = tFiling;

                        cnsTable.tableBody.add(row);
                    }
                }
                if (index == 0) {
                    // initialize and populate empty contract data
                    Row row = new Row();
                    row.checked = false;
                    row.resolved = false;
                    row.linkDisabled = false;
                    row.checkBoxDisabled = false;
                    row.uniqueKey = 'cns' + index;
                    row.caseItemsExtId = COMMON_ERROR_MESSAGE_All;
                    RowData rd = new RowData(COMMON_ERROR_MESSAGE,COMMON_ERROR_MESSAGE_All, '', false, false, false, '');
                    rd.isNoRecords = true;
                    row.rowColumnData.add(rd);
                    cnsTable.tableBody.add(row);
                }
                return cnsTable;

            } catch (Exception ex) {
                cnsTable = new ContractTable();
                cnsTable.success = false;
                cnsTable.message = COMMON_ERROR_MESSAGE_CNS;
                cnsTable.severity = calloutResult.MessageSeverity;
                cnsTable.statusCode = calloutResult.statusCode;
                return cnsTable;
            }
        } else {
            cnsTable = new ContractTable();
            cnsTable.success = false;
            cnsTable.message = COMMON_ERROR_MESSAGE_CNS;
            cnsTable.severity = calloutResult.MessageSeverity;
            cnsTable.statusCode = calloutResult.statusCode;
            return cnsTable;
        }
    }

    @auraEnabled
    public static ContractTable getENIContractsData(string providerId, string taxId, string addressSeq, boolean isActive) {
        ContractTable eniTable = new ContractTable();

        // get e and i contract data from api
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getEAndIContracts(providerId, taxId, addressSeq, null, null, null, isActive);

        if (calloutResult.Success) {
            // cast callout result to e and i contract response
            ACET_EAndIContractsResponse contractResponse = (ACET_EAndIContractsResponse) calloutResult.Response;
            eniTable.autodocHeaderName = 'E&I Contract Summary';
            eniTable.componentName = 'E&I Contract Summary'; //US2981549
            eniTable.tableHeaders = new List < String > {
                'CONTRACT ID',
                'STATUS',
                'ORG',
                'PRODUCT',
                'MARKET TYPE',
                'MARKET #',
                'IPA',
                'EFFECTIVE-CANCEL',
                'TYPE',
                'NEW PATIENTS?'
            };
            eniTable.isResolvedReportable = true; //US2981549

            String headerPopupId = String.valueof(DateTime.now().getTime());

            HoverHeader contractId = new HoverHeader();
            contractId.popupId = headerPopupId + 'contractId';
            contractId.headerValue = 'CONTRACT ID';
            eniTable.tableHoverHeaders.add(contractId);

            HoverHeader status = new HoverHeader();
            status.popupId = headerPopupId + 'status';
            status.headerValue = 'STATUS';
            eniTable.tableHoverHeaders.add(status);

            HoverHeader org = new HoverHeader();
            org.popupId = headerPopupId + 'org';
            org.hasHover = true;
            org.headerValue = 'ORG';
            org.alignRight = false;
            org.hoverWidth = '600px';
            org.hoverDescription = 'See below for description:';
            org.hoverDescriptionList.add('HPHC - Harvard Pilgrim');
            org.hoverDescriptionList.add('UHN - UnitedHealthcare, CSP/GSP, NHP, River Valley, Beacon LBS, National Provider (Product code-CON), Nexus ACO, Charter/Navigate/Compass');
            org.hoverDescriptionList.add('UBH - United Behavioral Health');
            org.hoverDescriptionList.add('ACN - OptumHealth Physical Health (Formerly ACN [American Chiropractic Network] Group) American Chiropractic Network');
            org.hoverDescriptionList.add('MEDI - Medica');
            eniTable.tableHoverHeaders.add(org);

            HoverHeader product = new HoverHeader();
            product.popupId = headerPopupId + 'product';
            product.headerValue = 'PRODUCT';
            eniTable.tableHoverHeaders.add(product);

            HoverHeader mrktType = new HoverHeader();
            mrktType.popupId = headerPopupId + 'mrktType';
            mrktType.headerValue = 'MARKET TYPE';
            eniTable.tableHoverHeaders.add(mrktType);

            HoverHeader mrktNum = new HoverHeader();
            mrktNum.popupId = headerPopupId + 'mrktNum';
            mrktNum.headerValue = 'MARKET #';
            eniTable.tableHoverHeaders.add(mrktNum);

            HoverHeader ipa = new HoverHeader();
            ipa.popupId = headerPopupId + 'ipa';
            ipa.headerValue = 'IPA';
            eniTable.tableHoverHeaders.add(ipa);

            HoverHeader effCancel = new HoverHeader();
            effCancel.popupId = headerPopupId + 'effCancel';
            effCancel.headerValue = 'EFFECTIVE-CANCEL';
            eniTable.tableHoverHeaders.add(effCancel);

            HoverHeader type = new HoverHeader();
            type.popupId = headerPopupId + 'type';
            type.headerValue = 'TYPE';
            eniTable.tableHoverHeaders.add(type);

            HoverHeader newPatients = new HoverHeader();
            newPatients.popupId = headerPopupId + 'newPatients';
            newPatients.hasHover = true;
            newPatients.headerValue = 'NEW PATIENTS?';
            newPatients.hoverWidth = '400px';
            newPatients.hoverDescription = 'See below for description:';
            newPatients.hoverDescriptionList.add('O - Open Panel, Accepting Patients');
            newPatients.hoverDescriptionList.add('C - Closed Panel, Not Accepting Patients');
            newPatients.hoverDescriptionList.add('X - Closed - No Override');
            newPatients.hoverDescriptionList.add('G - Member chooses the group assoc record as PCP');
            eniTable.tableHoverHeaders.add(newPatients);

            try {
                // additional pti hover details
                List < String > addPtiDescList = new List < String > ();
                addPtiDescList.add('Y - Individual');
                addPtiDescList.add('N - Group');
                addPtiDescList.add('E - Either Individual or Group');
                addPtiDescList.add('M - Multiple Group Records');
                addPtiDescList.add('G - Group Contract');
                addPtiDescList.add('O - Non Par Group');

                // contract arrangement hover details
                List < String > contrArrangeList = new List < String > ();
                contrArrangeList.add('0 - Nationally Accessible Provider');
                contrArrangeList.add('1 - CSP/GSP');

                // capitaion hover details
                List < String > capitationDescList = new List < String > ();
                capitationDescList.add('C - Capitated');
                capitationDescList.add('F - Fee for Service');

                // index to generate eni ID
                integer index = 0;
                if (contractResponse.employerandindividual != null) {
                    for (ACET_EAndIContractsResponse.Employerandindividual employerAndIndividual: contractResponse.employerandindividual) {
                        // initialize and populate contract data
                        Row row = new Row();
                        row.checked = false;
                        row.resolved = false;
                        row.linkDisabled = false;
                        row.checkBoxDisabled = false;
                        row.caseItemsExtId = employerAndIndividual.pnc_contr_id;
                        // generate ENI ID
                        row.uniqueKey = 'eni' + index;
                        index++;

                        // --- Contract Summary ---
                        // populate contract id field
                        row.rowColumnData.add(new RowData('CONTRACT ID', employerAndIndividual.pnc_contr_id, '', true, false, false, '', true));
                        // determine and populate contract active status
                        if (!String.isBlank(employerAndIndividual.pnc_canc_dt)) {
                            String[] dateStringArray = employerAndIndividual.pnc_canc_dt.split('-');
                            Date cancelDate = Date.newInstance(Integer.valueOf(dateStringArray[0]), Integer.valueOf(dateStringArray[1]), Integer.valueOf(dateStringArray[2]));
                            if (cancelDate.daysBetween(Date.today()) < 0) {
                                RowData cStatus = new RowData('STATUS', 'Active', 'Active', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:approval';
                                row.rowColumnData.add(cStatus);
                            } else {
                                RowData cStatus = new RowData('STATUS', 'Inactive', 'In Active', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:close';
                                row.rowColumnData.add(cStatus);
                            }
                        } else {
                            // assigning null value to summary status if the api did not return any value
                            RowData cStatus = new RowData('STATUS', 'Undefined', 'Undefined', false, false, true, 'text-align: center;', true);
                            cStatus.iconName = 'standard:macros';
                            row.rowColumnData.add(cStatus);
                        }
                        // populate org field
                        row.rowColumnData.add(new RowData('ORG', employerAndIndividual.cdk_contr_org_cd, '', true, false, false, '', true));
                        // populate product field
                        row.rowColumnData.add(new RowData('PRODUCT', employerAndIndividual.pnc_prd_grp_desc, '', true, false, false, '', true));
                        // populate market type field
                        row.rowColumnData.add(new RowData('MARKET TYPE', employerAndIndividual.pnc_mkt_typ_cd, '', true, false, false, '', true));
                        // populate market number field
                        row.rowColumnData.add(new RowData('MARKET #', employerAndIndividual.pnc_mkt_nbr + '-' + employerAndIndividual.pnc_mkt_desc, '', true, false, false, '', true));
                        // populate ipa field
                        if (employerAndIndividual.pnc_ipa_nbr.length() == 1) {
                            row.rowColumnData.add(new RowData('IPA', '00' + employerAndIndividual.pnc_ipa_nbr + ',' + employerAndIndividual.pnc_ipa_desc, '', true, false, false, '', true));
                        } else {
                            row.rowColumnData.add(new RowData('IPA', employerAndIndividual.pnc_ipa_nbr + ', ' + employerAndIndividual.pnc_ipa_desc, '', true, false, false, '', true));
                        }
                        // populate Effective/Cancel field
                        row.rowColumnData.add(new RowData('EFFECTIVE-CANCEL', SAEUtils.formatDate(employerAndIndividual.pnc_eff_dt) + ' - ' + SAEUtils.formatDate(employerAndIndividual.pnc_canc_dt), '', false, true, false, '', true));
                        // determine and populate contract type
                        if (employerAndIndividual.pnc_prov_contr_role_cd == 'S') {
                            row.rowColumnData.add(new RowData('TYPE', 'Specialist', '', true, false, false, '', true));
                        } else if (employerAndIndividual.pnc_prov_contr_role_cd == 'P') {
                            row.rowColumnData.add(new RowData('TYPE', 'PCP', '', true, false, false, '', true));
                        } else {
                            row.rowColumnData.add(new RowData('TYPE', '', '', true, false, false, '', true));
                        }
                        // populate new patients field
                        row.rowColumnData.add(new RowData('NEW PATIENTS', String.isNotBlank(employerAndIndividual.pnc_acpt_ptnt_cd) ? employerAndIndividual.pnc_acpt_ptnt_cd : '--', '', true, false, false, '', true));

                        // --- Contract Details ---
                        ACET_AutoDocUtil.CardDetails cDetails = new ACET_AutoDocUtil.CardDetails();
                        cDetails.type = 'card';
                        cDetails.componentName = 'E&I Contract Details : ' + employerAndIndividual.pnc_contr_id;
                        cDetails.noOfColumns = 'slds-size_1-of-5';
                        cDetails.componentOrder = 0;
                        // US3691213
                        cDetails.caseItemsExtId = employerAndIndividual.pnc_contr_id;
                        cDetails.reportingHeader = 'E&I Contract Details';
                        List < ACET_AutoDocUtil.FieldDetails > cardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate additional pti (api gap)
                        ACET_AutoDocUtil.FieldDetails additionalPti = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional PTI', '--', 'hoverText', true);
                        additionalPti.popupId = String.valueof(DateTime.now().getTime());
                        additionalPti.isNubbinLeft = true;
                        additionalPti.description = 'See below for description:';
                        additionalPti.descriptionList = addPtiDescList;
                        additionalPti.popupWidth = '200px';
                        cardDataList.add(additionalPti);
                        // populate claim type (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Claim Type', '--', 'outputText'));
                        // populate contract arrangement field
                        ACET_AutoDocUtil.FieldDetails contArrange = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Contract Arrangement', employerAndIndividual.pnc_contr_arng_cd + '-' + employerAndIndividual.pnc_contr_arng_desc, 'hoverText', true);
                        contArrange.popupId = String.valueof(DateTime.now().getTime());
                        contArrange.isNubbinLeft = false;
                        contArrange.description = 'See below for description:';
                        contArrange.descriptionList = contrArrangeList;
                        contArrange.popupWidth = '200px';
                        cardDataList.add(contArrange);
                        //populate site field
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Site', String.isNotBlank(employerAndIndividual.pnc_contr_grp_cd) ? employerAndIndividual.pnc_contr_grp_cd : '--', 'outputText', true));
                        // populate enw field
                        ACET_AutoDocUtil.FieldDetails enw = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'ENW', employerAndIndividual.pnc_enw_opt_out_ind, 'hoverText', true);
                        enw.popupId = String.valueof(DateTime.now().getTime());
                        enw.isNubbinLeft = true;
                        enw.description = 'W500 Additional Network Benefit. This program provides members access to additional providers outside the member\'s primary network for Urgent, Emergent and Gap Exceptions. For the program to be in effect, group must have this include in their benefit (dependent on 2015 COC). With this program we will providing cost reductions for members.';
                        enw.popupWidth = '300px';
                        cardDataList.add(enw);
                        // populate capitation (api gap)
                        ACET_AutoDocUtil.FieldDetails capitaion = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Capitaion', '--', 'hoverText', true);
                        capitaion.popupId = String.valueof(DateTime.now().getTime());
                        capitaion.isNubbinLeft = true;
                        capitaion.description = 'See below for description:';
                        capitaion.descriptionList = capitationDescList;
                        capitaion.popupWidth = '150px';
                        cardDataList.add(capitaion);
                        // populate fee schedule field
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Fee Schedule', employerAndIndividual.pnc_fee_sched_nbr, 'outputText', true));
                        // populate precert reduction field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Precert Reduction', '--', 'outputText', true));
                        // populate reduction % field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reduction %', '--', 'outputText', true));

                        cDetails.cardData = cardDataList;
                        row.contractDetails = cDetails;

                        // US3468218 - Fee Schedule Integration
                        FeeScheduleData fdata = new FeeScheduleData();
                        fdata.prodCode = employerAndIndividual.pnc_prd_grp_desc;
                        fdata.prodOffId = employerAndIndividual.pnc_prdct_ofr_id;
                        fdata.taxId = employerAndIndividual.tax_id_nbr;
                        fdata.provId = employerAndIndividual.prov_id;
                        fdata.market = employerAndIndividual.pnc_mkt_nbr;
                        fdata.mktType = employerAndIndividual.pnc_mkt_typ_cd;
                        fdata.ipa = employerAndIndividual.pnc_ipa_nbr;
                        fdata.feeSchedNo = employerAndIndividual.pnc_fee_sched_nbr;

                        row.feeScheduleData = fdata;
                        // end

                        // --- Timely Filing ---
                        ACET_AutoDocUtil.CardDetails tFiling = new ACET_AutoDocUtil.CardDetails();
                        tFiling.type = 'card';
                        tFiling.componentName = 'E&I Timely Filing : ' + employerAndIndividual.pnc_contr_id;
                        tFiling.noOfColumns = 'slds-size_1-of-3';
                        tFiling.componentOrder = 0;
                        // US3691213
                        tFiling.caseItemsExtId = employerAndIndividual.pnc_contr_id;
                        tFiling.reportingHeader = 'E&I Timely Filing';
                        List < ACET_AutoDocUtil.FieldDetails > tfCardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate initial claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Initial Claim', employerAndIndividual.pnc_tmly_fl_day_nbr, 'outputText', true));
                        // populate appeal field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal', '--', 'outputText', true));
                        // populate reconsideration field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reconsideration', '--', 'outputText', true));
                        // populate additional information field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional Information', '--', 'outputText', true));
                        // populate corrected claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Corrected Claim', '--', 'outputText', true));

                        tFiling.cardData = tfCardDataList;
                        row.timelyFiling = tFiling;

                        eniTable.tableBody.add(row);
                    }
                }
                if (index == 0) {
                    // initialize and populate empty contract data
                    Row row = new Row();
                    row.checked = false;
                    row.resolved = false;
                    row.linkDisabled = false;
                    row.checkBoxDisabled = false;
                    row.uniqueKey = 'eni' + index;
                    row.caseItemsExtId = COMMON_ERROR_MESSAGE_All;
                    RowData rd = new RowData(COMMON_ERROR_MESSAGE,COMMON_ERROR_MESSAGE_All, '', false, false, false, '');
                    rd.isNoRecords = true;
                    row.rowColumnData.add(rd);
                    eniTable.tableBody.add(row);
                }
                return eniTable;

            } catch (Exception ex) {
                eniTable = new ContractTable();
                eniTable.success = false;
                eniTable.message = COMMON_ERROR_MESSAGE_ENI;
                eniTable.severity = calloutResult.MessageSeverity;
                eniTable.statusCode = calloutResult.statusCode;
                return eniTable;
            }
        } else {
            eniTable = new ContractTable();
            eniTable.success = false;
            eniTable.message = COMMON_ERROR_MESSAGE_ENI;
            eniTable.severity = calloutResult.MessageSeverity;
            eniTable.statusCode = calloutResult.statusCode;
            return eniTable;
        }
    }

    @auraEnabled
    public static ContractTable getMNRContractsData(string providerId, string taxId, string addressId, boolean isActive) {
        ContractTable mnrTable = new ContractTable();

        // get m and r contract data from api
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getMAndRContracts(providerId, taxId, addressId, null, null, isActive);

        if (calloutResult.Success) {
            Map < Integer, String > codeToDecMap = ACET_SpecialityDropDownCtrl.getCOSMOCodeWithDescription();
            // cast callout result to m and r contract response
            ACET_MAndRContractsResponse contractResponse = (ACET_MAndRContractsResponse) calloutResult.Response;
            mnrTable.autodocHeaderName = 'M&R Contract Summary';
            mnrTable.componentName = 'M&R Contract Summary'; // US2981549 
            mnrTable.tableHeaders = new List < String > {
                'CONTRACT ID',
                'STATUS',
                'ORG',
                'DIV',
                'PANEL',
                'PANEL DESCRIPTION',
                'EFFECTIVE-CANCEL',
                'TYPE',
                'SPECIALTY TYPE',
                'NEW PATIENTS?'
            };

            String headerPopupId = String.valueof(DateTime.now().getTime());

            HoverHeader contractId = new HoverHeader();
            contractId.popupId = headerPopupId + 'contractId';
            contractId.headerValue = 'CONTRACT ID';
            mnrTable.tableHoverHeaders.add(contractId);

            HoverHeader status = new HoverHeader();
            status.popupId = headerPopupId + 'status';
            status.headerValue = 'STATUS';
            mnrTable.tableHoverHeaders.add(status);

            HoverHeader org = new HoverHeader();
            org.popupId = headerPopupId + 'org';
            org.hasHover = true;
            org.headerValue = 'ORG';
            org.alignRight = false;
            org.hoverWidth = '600px';
            org.hoverDescription = 'See below for description:';
            org.hoverDescriptionList.add('HPHC - Harvard Pilgrim');
            org.hoverDescriptionList.add('UHN - UnitedHealthcare, CSP/GSP, NHP, River Valley, Beacon LBS, National Provider (Product code-CON), Nexus ACO, Charter/Navigate/Compass');
            org.hoverDescriptionList.add('UBH - United Behavioral Health');
            org.hoverDescriptionList.add('ACN - OptumHealth Physical Health (Formerly ACN [American Chiropractic Network] Group) American Chiropractic Network');
            org.hoverDescriptionList.add('MEDI - Medica');
            mnrTable.tableHoverHeaders.add(org);

            HoverHeader div = new HoverHeader();
            div.popupId = headerPopupId + 'div';
            div.headerValue = 'DIV';
            mnrTable.tableHoverHeaders.add(div);

            HoverHeader panel = new HoverHeader();
            panel.popupId = headerPopupId + 'panel';
            panel.headerValue = 'PANEL';
            mnrTable.tableHoverHeaders.add(panel);

            HoverHeader panelDes = new HoverHeader();
            panelDes.popupId = headerPopupId + 'panelDes';
            panelDes.headerValue = 'PANEL DESCRIPTION';
            mnrTable.tableHoverHeaders.add(panelDes);

            HoverHeader effCancel = new HoverHeader();
            effCancel.popupId = headerPopupId + 'effCancel';
            effCancel.headerValue = 'EFFECTIVE-CANCEL';
            mnrTable.tableHoverHeaders.add(effCancel);

            HoverHeader type = new HoverHeader();
            type.popupId = headerPopupId + 'type';
            type.headerValue = 'TYPE';
            mnrTable.tableHoverHeaders.add(type);

            HoverHeader speType = new HoverHeader();
            speType.popupId = headerPopupId + 'speType';
            speType.headerValue = 'SPECIALTY TYPE';
            mnrTable.tableHoverHeaders.add(speType);

            HoverHeader newPatients = new HoverHeader();
            newPatients.popupId = headerPopupId + 'newPatients';
            newPatients.hasHover = true;
            newPatients.headerValue = 'NEW PATIENTS?';
            newPatients.hoverWidth = '430px';
            newPatients.hoverDescription = 'See below for description:';
            newPatients.hoverDescriptionList.add('N - No new patients accepted');
            newPatients.hoverDescriptionList.add('Y - New patients are being accepted');
            newPatients.hoverDescriptionList.add('E - New patients accepted on exception basis only');
            newPatients.hoverDescriptionList.add('R - Accepting new patients with restrictions (age, gender, etc).');
            mnrTable.tableHoverHeaders.add(newPatients);

            try {
                // additional pti hover details
                List < String > addPtiDescList = new List < String > ();
                addPtiDescList.add('Y - Individual');
                addPtiDescList.add('N - Group');
                addPtiDescList.add('E - Either Individual or Group');
                addPtiDescList.add('M - Multiple Group Records');
                addPtiDescList.add('G - Group Contract');
                addPtiDescList.add('O - Non Par Group');

                // capitaion hover details
                List < String > capitationDescList = new List < String > ();
                capitationDescList.add('C - Capitated');
                capitationDescList.add('F - Fee for Service');

                // index to generate mnr ID
                integer index = 0;
                if (contractResponse.medicareandretirement != null) {
                    for (ACET_MAndRContractsResponse.Medicareandretirement medicareAndRetirement: contractResponse.medicareandretirement) {
                        // initialize and populate contract data
                        Row row = new Row();
                        row.checked = false;
                        row.resolved = false;
                        row.linkDisabled = false;
                        row.checkBoxDisabled = false;
                        row.caseItemsExtId = medicareAndRetirement.cos_contract_num;
                        // generate mnr ID
                        row.uniqueKey = 'mnr' + index;
                        index++;

                        // --- Contract Summary ---
                        // populate contract id field
                        row.rowColumnData.add(new RowData('CONTRACT ID', medicareAndRetirement.cos_contract_num, '', true, false, false, '', true));
                        // determine and populate contract active status
                        if (!String.isBlank(medicareAndRetirement.cos_canc_date)) {
                            String[] dateStringArray = medicareAndRetirement.cos_canc_date.split('-');
                            Date cancelDate = Date.newInstance(Integer.valueOf(dateStringArray[0]), Integer.valueOf(dateStringArray[1]), Integer.valueOf(dateStringArray[2]));
                            if (cancelDate.daysBetween(Date.today()) < 0) {
                                RowData cStatus = new RowData('STATUS', 'Active', 'Active', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:approval';
                                row.rowColumnData.add(cStatus);
                            } else {
                                RowData cStatus = new RowData('STATUS', 'Inactive', 'In Active', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'action:close';
                                row.rowColumnData.add(cStatus);
                            }
                        } else {
                            // assigning null value to summary status if the api did not return any value
                            RowData cStatus = new RowData('STATUS', 'Undefined', 'Undefined', false, false, true, 'text-align: center;', true);
                            cStatus.iconName = 'standard:macros';
                            row.rowColumnData.add(cStatus);
                        }
                        // populate org field (api gap)
                        row.rowColumnData.add(new RowData('ORG', '--', '', true, false, false, '', true));
                        // populate div field
                        row.rowColumnData.add(new RowData('DIV', medicareAndRetirement.cos_div, '', true, false, false, '', true));
                        // populate panel field
                        row.rowColumnData.add(new RowData('PANEL', medicareAndRetirement.cos_panel_num, '', true, false, false, '', true));
                        // populate panel description field
                        row.rowColumnData.add(new RowData('PANEL DESCRIPTION', medicareAndRetirement.cos_panel_desc, '', true, false, false, '', true));
                        // populate Effective/Cancel field
                        row.rowColumnData.add(new RowData('EFFECTIVE-CANCEL', SAEUtils.formatDate(medicareAndRetirement.cos_eff_dt) + ' - ' + SAEUtils.formatDate(medicareAndRetirement.cos_canc_date), '', false, true, false, '', true));
                        // determine and populate contract type
                        if (medicareAndRetirement.cos_role == 'S') {
                            row.rowColumnData.add(new RowData('TYPE', 'Specialist', '', true, false, false, '', true));
                        } else if (medicareAndRetirement.cos_role == 'G') {
                            row.rowColumnData.add(new RowData('TYPE', 'PCP', '', true, false, false, '', true));
                        } else {
                            row.rowColumnData.add(new RowData('TYPE', '--', '', true, false, false, '', true));
                        }
                        // populate specialty type
                        //row.rowColumnData.add(new RowData('SPECIALTY TYPE', medicareAndRetirement.cos_prov_type, '', true, false, false, '', true));
                        if (codeToDecMap != null && codeToDecMap.get(Integer.valueof(medicareAndRetirement.cos_prov_type)) != NULL) {
                            row.rowColumnData.add(new RowData('SPECIALTY TYPE', medicareAndRetirement.cos_prov_type + ' - ' + codeToDecMap.get(Integer.valueof(medicareAndRetirement.cos_prov_type)), '', true, false, false, ''));
                        } else {
                            row.rowColumnData.add(new RowData('SPECIALTY TYPE', medicareAndRetirement.cos_prov_type, '', true, false, false, ''));
                        }

                        // populate new patients field
                        row.rowColumnData.add(new RowData('NEW PATIENTS', medicareAndRetirement.cos_new_pat_ind, '', true, false, false, '', true));

                        // --- Contract Details ---
                        ACET_AutoDocUtil.CardDetails cDetails = new ACET_AutoDocUtil.CardDetails();
                        cDetails.type = 'card';
                        cDetails.componentName = 'M&R Contract Details : ' + medicareAndRetirement.cos_contract_num;
                        // US3691213
                        cDetails.caseItemsExtId = medicareAndRetirement.cos_contract_num;
                        cDetails.reportingHeader = 'M&R Contract Details';
                        cDetails.noOfColumns = 'slds-size_1-of-5';
                        cDetails.componentOrder = 0;
                        List < ACET_AutoDocUtil.FieldDetails > cardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate additional pti (api gap)
                        ACET_AutoDocUtil.FieldDetails additionalPti = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional PTI', '--', 'hoverText', true);
                        additionalPti.popupId = String.valueof(DateTime.now().getTime());
                        additionalPti.isNubbinLeft = true;
                        additionalPti.description = 'See below for description:';
                        additionalPti.descriptionList = addPtiDescList;
                        additionalPti.popupWidth = '180px';
                        cardDataList.add(additionalPti);
                        // populate capitation (api gap)
                        ACET_AutoDocUtil.FieldDetails capitaion = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Capitaion', '--', 'hoverText', true);
                        capitaion.popupId = String.valueof(DateTime.now().getTime());
                        capitaion.isNubbinLeft = true;
                        capitaion.description = 'See below for description:';
                        capitaion.descriptionList = capitationDescList;
                        capitaion.popupWidth = '150px';
                        cardDataList.add(capitaion);
                        // populate fee schedule field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Fee Schedule', '--', 'outputText', true));
                        // populate special agreement field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Special Agreement', '--', 'outputText', true));
                        // populate role field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Role', '--', 'outputText', true));
                        // populate network type field
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Network Type', medicareAndRetirement.cos_network_num, 'outputText', true));
                        // populate audit indicator field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Audit Indicator', '--', 'outputText', true));
                        // populate percert reduction field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Percert Reduction', '--', 'outputText', true));
                        // populate reduction % field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reduction %', '--', 'outputText', true));
                        // populate claim type field (api gap)
                        cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Claim Type', '--', 'outputText', true));

                        cDetails.cardData = cardDataList;
                        row.contractDetails = cDetails;

                        // --- Timely Filing --- (api gap)
                        ACET_AutoDocUtil.CardDetails tFiling = new ACET_AutoDocUtil.CardDetails();
                        tFiling.type = 'card';
                        tFiling.componentName = 'M&R Timely Filing : ' + medicareAndRetirement.cos_contract_num;
                        // US3691213
                        tFiling.caseItemsExtId = medicareAndRetirement.cos_contract_num;
                        tFiling.reportingHeader = 'M&R Timely Filing';
                        tFiling.noOfColumns = 'slds-size_1-of-3';
                        tFiling.componentOrder = 0;
                        List < ACET_AutoDocUtil.FieldDetails > tfCardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                        // populate initial claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Initial Claim', '--', 'outputText', true));
                        // populate appeal field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal', '--', 'outputText', true));
                        // populate reconsideration field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reconsideration', '--', 'outputText', true));
                        // populate additional information field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional Information', '--', 'outputText', true));
                        // populate corrected claim field
                        tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Corrected Claim', '--', 'outputText', true));

                        tFiling.cardData = tfCardDataList;
                        row.timelyFiling = tFiling;

                        mnrTable.tableBody.add(row);
                    }
                }
                if (index == 0) {
                    // initialize and populate empty contract data
                    Row row = new Row();
                    row.checked = false;
                    row.resolved = false;
                    row.linkDisabled = false;
                    row.checkBoxDisabled = false;
                    row.uniqueKey = 'mnr' + index;
                    row.caseItemsExtId = COMMON_ERROR_MESSAGE_All;
                    RowData rd = new RowData(COMMON_ERROR_MESSAGE,COMMON_ERROR_MESSAGE_All, '', false, false, false, '');
                    rd.isNoRecords = true;
                    row.rowColumnData.add(rd);
                    mnrTable.tableBody.add(row);
                }
                return mnrTable;

            } catch (Exception ex) {
                mnrTable = new ContractTable();
                mnrTable.success = false;
                mnrTable.message = COMMON_ERROR_MESSAGE_MNR;
                mnrTable.severity = calloutResult.MessageSeverity;
                mnrTable.statusCode = calloutResult.statusCode;
                return mnrTable;
            }
        } else {
            mnrTable = new ContractTable();
            mnrTable.success = false;
            mnrTable.message = COMMON_ERROR_MESSAGE_MNR;
            mnrTable.severity = calloutResult.MessageSeverity;
            mnrTable.statusCode = calloutResult.statusCode;
            return mnrTable;
        }
    }

    //US2683582
    @auraEnabled
    public static ContractTable getFacetsCSNContractsData(string providerId, string taxId, string addressId, boolean isActive) {
        ContractTable cnsTable = new ContractTable();
        string strCSPProviderValue = '';
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getCAndSContracts(providerId, taxId, addressId, isActive);
        if (calloutResult.Success) {
            // cast callout result to c and s contract response
            ACET_CAndSContractsResponse contractResponse = (ACET_CAndSContractsResponse) calloutResult.Response;
            if (contractResponse != null && contractResponse.communityandstate != null) {
                for (ACET_CAndSContractsResponse.Communityandstate communityAndState: contractResponse.communityandstate) {
                    if (string.isNotBlank(communityAndState.csp_pltfm_prov_id)) {
                        strCSPProviderValue = communityAndState.csp_pltfm_prov_id;
                        break;
                    }
                }

            }
            system.debug('==strCSPProviderValue=' + strCSPProviderValue);
            if (string.isNotBlank(strCSPProviderValue)) {
                cnsTable = processFacetsContractDataResult(strCSPProviderValue);
            } else {
                cnsTable = processInitialTableData();
                integer index = 0;
                Row row = new Row();
                row.checked = false;
                row.resolved = false;
                row.linkDisabled = false;
                row.checkBoxDisabled = false;
                row.caseItemsExtId =COMMON_ERROR_MESSAGE_All ;
                row.uniqueKey = 'cns' + index;
                RowData rd = new RowData(COMMON_ERROR_MESSAGE,COMMON_ERROR_MESSAGE_All, '', false, false, false, '');
                rd.isNoRecords = true;
                row.rowColumnData.add(rd);
                cnsTable.tableBody.add(row);
            }
            return cnsTable;
        } else {
            cnsTable = new ContractTable();
            cnsTable.success = false;
            cnsTable.message = COMMON_ERROR_MESSAGE_CNS;
            cnsTable.severity = calloutResult.MessageSeverity;
            cnsTable.statusCode = calloutResult.statusCode;
            return cnsTable;
        }

        // return cnsTable;
    }

    public static ContractTable processInitialTableData() {
        ContractTable initialCSTable = new ContractTable();
        initialCSTable.autodocHeaderName = 'C&S Contract Summary';
        initialCSTable.componentName = 'C&S Contract Summary'; //US2981549
        initialCSTable.tableHeaders = new List < String > {
            'AGREEMENT ID',
            'AGREEMENT TYPE',
            'STATUS',
            'NETWORK ID',
            'NETWORK PREFIX',
            'EFFECTIVE-CANCEL',
            'PCP?',
            'NEW PATIENTS?'
        };

        String headerPopupId = String.valueof(DateTime.now().getTime());

        HoverHeader contractId = new HoverHeader();
        contractId.popupId = headerPopupId + 'AGREEMENTID';
        contractId.headerValue = 'AGREEMENT ID';
        initialCSTable.tableHoverHeaders.add(contractId);

        HoverHeader aggrementType = new HoverHeader();
        aggrementType.popupId = headerPopupId + 'AGREEMENTTYPE';
        aggrementType.headerValue = 'AGREEMENT TYPE';
        initialCSTable.tableHoverHeaders.add(aggrementType);

        HoverHeader status = new HoverHeader();
        status.popupId = headerPopupId + 'status';
        status.headerValue = 'STATUS';
        initialCSTable.tableHoverHeaders.add(status);

        HoverHeader networkId = new HoverHeader();
        networkId.popupId = headerPopupId + 'networkId';
        networkId.headerValue = 'NETWORK ID';
        initialCSTable.tableHoverHeaders.add(networkId);

        HoverHeader networkPrefix = new HoverHeader();
        networkPrefix.popupId = headerPopupId + 'networkPrefix';
        networkPrefix.headerValue = 'NETWORK PREFIX';
        initialCSTable.tableHoverHeaders.add(networkPrefix);

        HoverHeader effectiveCancel = new HoverHeader();
        effectiveCancel.popupId = headerPopupId + 'effectiveCancel';
        effectiveCancel.headerValue = 'EFFECTIVE-CANCEL';
        initialCSTable.tableHoverHeaders.add(effectiveCancel);

        HoverHeader type = new HoverHeader();
        type.popupId = headerPopupId + 'PCP?';
        type.headerValue = 'PCP?';
        initialCSTable.tableHoverHeaders.add(type);

        HoverHeader newPatients = new HoverHeader();
        newPatients.popupId = headerPopupId + 'newPatients';
        newPatients.hasHover = true;
        newPatients.headerValue = 'NEW PATIENTS?';
        newPatients.hoverWidth = '430px';
        newPatients.hoverDescription = 'See below for description:';
        newPatients.hoverDescriptionList.add('N - No new patients accepted');
        newPatients.hoverDescriptionList.add('Y - New patients are being accepted');
        newPatients.hoverDescriptionList.add('E - New patients accepted on exception basis only');
        newPatients.hoverDescriptionList.add('R - Accepting new patients with restrictions (age, gender, etc).');
        initialCSTable.tableHoverHeaders.add(newPatients);
        return initialCSTable;
    }
    public static ContractTable processFacetsContractDataResult(string CSPProviderId) {
        ContractTable cnsTable = new ContractTable();
        ACET_FacetsGETProviderContractsService facetCNSContractService = new ACET_FacetsGETProviderContractsService();
        ACETWSCalloutResult calloutResult = facetCNSContractService.getContractDetails(CSPProviderId);
        system.debug('==ACETWSCalloutResult' + calloutResult);
        if (calloutResult.Success) {
            Map < string, string > AgrToTypeMap = new Map < String, string > ();
            Map < string, string > AgrToInitalClaimMap = new Map < String, string > ();

            ACET_FacetsGETProviderContractsResponse facetContractResponse = (ACET_FacetsGETProviderContractsResponse) calloutResult.Response;

            cnsTable = processInitialTableData();

            try {
                // additional pti hover details
                List < String > addPtiDescList = new List < String > ();
                addPtiDescList.add('Y - Individual');
                addPtiDescList.add('N - Group');
                addPtiDescList.add('E - Either Individual or Group');
                addPtiDescList.add('M - Multiple Group Records');
                addPtiDescList.add('G - Group Contract');
                addPtiDescList.add('O - Non Par Group');

                // capitaion hover details
                List < String > capitationDescList = new List < String > ();
                capitationDescList.add('C - Capitated');
                capitationDescList.add('F - Fee for Service');

                // index to generate cns ID
                integer index = 0;

                if (facetContractResponse != null && facetContractResponse.data != null && facetContractResponse.data.attributes != null) {
                    if (facetContractResponse.data.attributes.provAgreements != null) {
                        for (ACET_FacetsGETProviderContractsResponse.ProvAgreements pAgr: facetContractResponse.data.attributes.provAgreements) {
                            if (string.isNotBlank(pAgr.agreementId) && string.isNotBlank(pAgr.agreementType.desc_Z)) {
                                AgrToTypeMap.put(pAgr.agreementId, pAgr.agreementType.desc_Z);
                            }
                            if (string.isNotBlank(pAgr.agreementId) && string.isNotBlank(string.valueof(pAgr.claimAcceptMonths))) {
                                AgrToInitalClaimMap.put(pAgr.agreementId, String.valueof(pAgr.claimAcceptMonths));
                            }
                        }
                    }
                    if (facetContractResponse.data.attributes.inNetworkRelations != null) {
                        for (ACET_FacetsGETProviderContractsResponse.InNetworkRelations iAgr: facetContractResponse.data.attributes.inNetworkRelations) {
                            Row row = new Row();
                            row.checked = false;
                            row.resolved = false;
                            row.linkDisabled = false;
                            row.checkBoxDisabled = false;
                            row.caseItemsExtId = iAgr.agreementId;

                            // generate cns ID
                            row.uniqueKey = 'cns' + index;
                            index++;

                            // --- Contract Summary ---
                            // populate contract id field
                            row.rowColumnData.add(new RowData('AGREEMENT ID', iAgr.agreementId, '', true, false, false, '', true));
                            row.rowColumnData.add(new RowData('AGREEMENT TYPE', AgrToTypeMap.get(iAgr.agreementId) != NULL ? AgrToTypeMap.get(iAgr.agreementId) : '--', '', true, false, false, '', true));
                            // determine and populate contract active status
                            if (!String.isBlank(iAgr.termDate)) {
                                String[] dateStringArrayWithT = iAgr.termDate.split('T');
                                String[] dateStringArray = dateStringArrayWithT[0].split('-');
                                Date cancelDate = Date.newInstance(Integer.valueOf(dateStringArray[0]), Integer.valueOf(dateStringArray[1]), Integer.valueOf(dateStringArray[2]));
                                if (cancelDate.daysBetween(Date.today()) < 0) {
                                    RowData cStatus = new RowData('STATUS', 'Active', 'Active', false, false, true, 'text-align: center;', true);
                                    cStatus.iconName = 'action:approval';
                                    row.rowColumnData.add(cStatus);
                                } else {
                                    RowData cStatus = new RowData('STATUS', 'Inactive', 'Inactive', false, false, true, 'text-align: center;', true);
                                    cStatus.iconName = 'action:close';
                                    row.rowColumnData.add(cStatus);
                                }
                            } else {
                                RowData cStatus = new RowData('STATUS', 'Undefined', 'Undefined', false, false, true, 'text-align: center;', true);
                                cStatus.iconName = 'standard:macros';
                                row.rowColumnData.add(cStatus);
                            }

                            // populate network id
                            row.rowColumnData.add(new RowData('NETWORK ID', string.isNotBlank(iAgr.networkID) ? iAgr.networkID : '--', '', true, false, false, '', true));
                            // populate network prefix
                            row.rowColumnData.add(new RowData('NETWORK PREFIX', iAgr.networkPrefix.code + ' - ' + iAgr.networkPrefix.desc_Z, '', true, false, false, '', true));
                            // populate Effective/Cancel field
                            String[] dateStringArrayWithTCanc = string.isNotBlank(iAgr.termDate) ? iAgr.termDate.split('T') : new List < string > ();
                            String[] dateStringArrayWithTEFF = string.isNotBlank(iAgr.effDate) ? iAgr.effDate.split('T') : new List < string > ();
                            row.rowColumnData.add(new RowData('EFFECTIVE-CANCEL', (!dateStringArrayWithTCanc.isEmpty() ? SAEUtils.formatDate(dateStringArrayWithTEFF[0]) : '') + ' - ' +
                                (!dateStringArrayWithTCanc.isEmpty() ? SAEUtils.formatDate(dateStringArrayWithTCanc[0]) : ''), '', false, true, false, '', true));
                            // determine and populate PCP
                            if (string.isNotBlank(iAgr.relationPcp) && iAgr.relationPcp == 'Y') {
                                row.rowColumnData.add(new RowData('PCP?', 'YES', '', true, false, false, '', true));
                            } else {
                                row.rowColumnData.add(new RowData('PCP?', 'NO', '', true, false, false, '', true));
                            }
                            // populate new patients id (api gap)
                            row.rowColumnData.add(new RowData('NEW PATIENTS', '--', '', true, false, false, '', true));

                            // --- Contract Details --- (api gap)
                            ACET_AutoDocUtil.CardDetails cDetails = new ACET_AutoDocUtil.CardDetails();
                            cDetails.type = 'card';
                            cDetails.componentName = 'C&S Contract Details : ' + iAgr.agreementId;
                            cDetails.noOfColumns = 'slds-size_1-of-5';
                            cDetails.componentOrder = 0;
                            List < ACET_AutoDocUtil.FieldDetails > cardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                            // populate additional pti
                            ACET_AutoDocUtil.FieldDetails additionalPti = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional PTI', '--', 'hoverText');
                            additionalPti.popupId = String.valueof(DateTime.now().getTime());
                            additionalPti.isNubbinLeft = true;
                            additionalPti.description = 'See below for description:';
                            additionalPti.descriptionList = addPtiDescList;
                            additionalPti.isReportable = true;
                            // DE432149 - Thanish - 15th Apr 2021
                            additionalPti.popupWidth = '180px';
                            cardDataList.add(additionalPti);
                            // populate capitation
                            ACET_AutoDocUtil.FieldDetails capitaion = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Capitaion', '--', 'hoverText');
                            capitaion.popupId = String.valueof(DateTime.now().getTime());
                            capitaion.isNubbinLeft = true;
                            capitaion.description = 'See below for description:';
                            capitaion.descriptionList = capitationDescList;
                            capitaion.isReportable = true;
                            // DE432149 - Thanish - 15th Apr 2021
                            capitaion.popupWidth = '150px';
                            cardDataList.add(capitaion);
                            // populate precert reduction field
                            cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Precert Reduction', '--', 'outputText', true));
                            // populate reduction % field
                            cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reduction %', '--', 'outputText', true));
                            // populate claim type
                            cardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Claim Type', '--', 'outputText', true));

                            cDetails.cardData = cardDataList;
                            row.contractDetails = cDetails;

                            // --- Timely Filing --- (api gap)
                            ACET_AutoDocUtil.CardDetails tFiling = new ACET_AutoDocUtil.CardDetails();
                            tFiling.type = 'card';
                            tFiling.componentName = 'C&S Timely Filing : ' + iAgr.agreementId;
                            tFiling.noOfColumns = 'slds-size_1-of-3';
                            tFiling.componentOrder = 0;
                            List < ACET_AutoDocUtil.FieldDetails > tfCardDataList = new List < ACET_AutoDocUtil.FieldDetails > ();
                            // populate initial claim field
                            tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Initial Claim', AgrToInitalClaimMap.get(iAgr.agreementId) != NULL ? string.valueof(AgrToInitalClaimMap.get(iAgr.agreementId)) + ' Months' : '--', 'outputText', true));
                            // populate appeal field
                            tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Appeal', '--', 'outputText', true));
                            // populate reconsideration field
                            tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reconsideration', '--', 'outputText', true));
                            // populate additional information field
                            tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Additional Information', '--', 'outputText', true));
                            // populate corrected claim field
                            tfCardDataList.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Corrected Claim', '--', 'outputText', true));

                            tFiling.cardData = tfCardDataList;
                            row.timelyFiling = tFiling;

                            cnsTable.tableBody.add(row);

                        }
                    }
                }

                if (index == 0) {
                    // initialize and populate empty contract data
                    Row row = new Row();
                    row.checked = false;
                    row.resolved = false;
                    row.linkDisabled = false;
                    row.checkBoxDisabled = false;
                    row.uniqueKey = 'cns' + index;
                    row.caseItemsExtId = COMMON_ERROR_MESSAGE_All;
                    RowData rd = new RowData(COMMON_ERROR_MESSAGE,COMMON_ERROR_MESSAGE_All, '', false, false, false, '');
                    rd.isNoRecords = true;
                    row.rowColumnData.add(rd);
                    cnsTable.tableBody.add(row);
                }
                return cnsTable;
            } catch (Exception e) {
                cnsTable = new ContractTable();
                cnsTable.success = false;
                cnsTable.message = COMMON_ERROR_MESSAGE_CNS;
                cnsTable.severity = calloutResult.MessageSeverity;
                cnsTable.statusCode = calloutResult.statusCode;
                return cnsTable;
            }
        } else {
            cnsTable = new ContractTable();
            cnsTable.success = false;
            cnsTable.message = COMMON_ERROR_MESSAGE_CNS;
            cnsTable.severity = calloutResult.MessageSeverity;
            cnsTable.statusCode = calloutResult.statusCode;
            return cnsTable;
        }
        //return cnsTable;
    }
}