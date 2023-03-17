public class ACET_ProviderLookupDetailController {
    // US3691213
    private static String caseItemsExtId { get; set; }
    @AuraEnabled
    public static ACET_ProviderLookupDetailController.SnapshotDataData getProviderData(String providerId, String taxId, String adrseq, String providerType, contactDetails contactWrapper) {
        ACET_ProviderLookupDetailController.SnapshotDataData returnWrapper = new ACET_ProviderLookupDetailController.SnapshotDataData();
        try{        
            // US3691213
            if (contactWrapper != null && !String.isEmpty (contactWrapper.caseItemsExtId) && contactWrapper.isProviderLookup) {
                caseItemsExtId = contactWrapper.caseItemsExtId;
            } else {
                caseItemsExtId = taxId;
            }

        SAE_ProviderSnapshotWrapper.ReturnResponse provData = SAE_ProviderSnapshotController.getProviderData(providerId, taxId, adrseq);
        // US3291540 - Sanka
        if(provData.isSuccess){
            returnWrapper.isSuccess = true;
            returnWrapper.statusCode = 200;
        }else{
            returnWrapper.isSuccess = false;
            returnWrapper.statusCode = provData.StatusCode;
        }
            // End

        // Provider Card Data
            SAE_ProviderSnapshotWrapper.ProviderCardWrapper providerCardDetails = provData.ProviderCardDetails;

            returnWrapper.physicianDetails = setProviderCardData (providerCardDetails, providerType, contactWrapper);
        //Additional Details
        SAE_ProviderSnapshotWrapper.AdditionalDetailCard additionalDetails = provData.AdditionalDetails;
        returnWrapper.additionalDetails = setAdditionalDetails(additionalDetails, providerType);
        // Credentialling
        if (providerType != 'Facility') {
            List < SAE_ProviderSnapshotWrapper.CredentialCard > credDetails = provData.Credentials;
            returnWrapper.credDetails = setCredentialData(credDetails);
        }
        // Speciality
            List<SAE_ProviderSnapshotWrapper.SpecialityCardWrapper> specialityRecords = provData.SpecialityRecords;
            returnWrapper.specialityDetails = setSpecialityData (specialityRecords, providerType);
            
    }catch(Exception e){
        System.debug('exception::'+e.getStackTraceString());
        returnWrapper.isSuccess = false;
        returnWrapper.errorMessage = e.getMessage() + ' ' + e.getLineNumber();
    }
        return returnWrapper;

    }

    // Set Provider Card Details
    public static ACET_AutoDocUtil.CardDetails setProviderCardData(SAE_ProviderSnapshotWrapper.ProviderCardWrapper ProviderCardDetails, String providerType, contactDetails contactWrapper) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_3-of-12';
        // US3691213
        providerDetails.caseItemsExtId = caseItemsExtId;
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if (providerType != 'Facility') {
            providerDetails.componentName = 'Physician/Other : ' + ProviderCardDetails.ProviderName;
            providerDetails.reportingHeader = 'Physician/Other';
            // 1st Row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(true, false, true, 'Tax ID (TIN)', ProviderCardDetails != null && ProviderCardDetails.TaxId != null ? ProviderCardDetails.TaxId : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(true, false, true, 'NPI', ProviderCardDetails != null && ProviderCardDetails.NPI != null ? ProviderCardDetails.NPI : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Provider ID/MPIN', ProviderCardDetails != null && ProviderCardDetails.ProviderId != null ? ProviderCardDetails.ProviderId : '--', 'outputText',true));//US2990280 - Sravan
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Provider ID', ProviderCardDetails != null && ProviderCardDetails.MedicareProviderId != null && ProviderCardDetails.MedicareProviderId.trim() != '' ? ProviderCardDetails.MedicareProviderId : '--', 'outputText',true));
            // 2nd Row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medical Group', ProviderCardDetails != null && ProviderCardDetails.MedicalGroup != null ? ProviderCardDetails.MedicalGroup : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Address', ProviderCardDetails != null && ProviderCardDetails.Address != null ? ProviderCardDetails.Address : '--', 'unescapedHtml',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Phone #', ProviderCardDetails != null && ProviderCardDetails.PhoneNumber != null ? ProviderCardDetails.PhoneNumber : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Patient Range', ProviderCardDetails != null && ProviderCardDetails.PatientRange != null ? String.join(ProviderCardDetails.PatientRange, ',') : '--', 'outputText',true));
            // 3rd row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Premium Designation', ProviderCardDetails != null && ProviderCardDetails.PremiumDesignation != null ? ProviderCardDetails.PremiumDesignation : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Premium Speciality', ProviderCardDetails != null && ProviderCardDetails.PremiumSpeciality != null ? ProviderCardDetails.PremiumSpeciality : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Effective-Cancel', ProviderCardDetails != null && ProviderCardDetails.EffectiveDate != null ? ProviderCardDetails.EffectiveDate : '--', 'outputText',true));//US2990280 - Sravan
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
            // 4th row
            /*
            //US2491365 - Avish
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Contact Name', contactWrapper != null && contactWrapper.contactName != '' ? contactWrapper.contactName : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Contact Number', contactWrapper != null && contactWrapper.contactNumber != '' ? contactWrapper.contactNumber : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Ext', contactWrapper != null && contactWrapper.contactExt != '' ? contactWrapper.contactExt : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', '')); */
        } else {
            providerDetails.componentName = 'Facility : ' + ProviderCardDetails.ProviderName;
            providerDetails.reportingHeader = 'Facility';
            // 1st Row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(true, false, true, 'Tax ID (TIN)', ProviderCardDetails != null && ProviderCardDetails.TaxId != null ? ProviderCardDetails.TaxId : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(true, false, true, 'NPI', ProviderCardDetails != null && ProviderCardDetails.NPI != null ? ProviderCardDetails.NPI : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Provider ID/MPIN', ProviderCardDetails != null && ProviderCardDetails.ProviderId != null ? ProviderCardDetails.ProviderId : '--', 'outputText',true));//US2990280 - Sravan
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Provider ID', ProviderCardDetails != null && ProviderCardDetails.MedicareProviderId != null && ProviderCardDetails.MedicareProviderId.trim() != '' ? ProviderCardDetails.MedicareProviderId : '--', 'outputText',true));
            // 2nd Row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medical Group', ProviderCardDetails != null && ProviderCardDetails.MedicalGroup != null ? ProviderCardDetails.MedicalGroup : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Address', ProviderCardDetails != null && ProviderCardDetails.Address != null ? ProviderCardDetails.Address : '--', 'unescapedHtml',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Phone #', ProviderCardDetails != null && ProviderCardDetails.PhoneNumber != null ? ProviderCardDetails.PhoneNumber : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
        }

        providerDetails.cardData = cardData;

        return providerDetails;
    }

    public static ACET_AutoDocUtil.CardDetails setAdditionalDetails(SAE_ProviderSnapshotWrapper.AdditionalDetailCard additionalDetails, String providerType) {
        ACET_AutoDocUtil.CardDetails providerCardDetails = new ACET_AutoDocUtil.CardDetails();
        providerCardDetails.type = 'card';
        providerCardDetails.componentOrder = 5;
        providerCardDetails.componentName = 'Additional Details';
        providerCardDetails.noOfColumns = 'slds-size_2-of-12';
        // US3691213
        providerCardDetails.caseItemsExtId = caseItemsExtId;
        System.debug('additionalDetails::' + additionalDetails);
        String medicareAssignment = providerType != 'Facility' && additionalDetails != null && additionalDetails.MedicareId != null && additionalDetails.MedicareId.toString() != '' ? 'Yes' : 'No';

        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if (providerType != 'Facility') {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Language', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'PCP Role', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TPSM Level', additionalDetails != null && additionalDetails.TPSMLevel != null ? additionalDetails.TPSMLevel : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'EPS', additionalDetails != null && additionalDetails.EPS != null ? additionalDetails.EPS : '--', 'outputText',true));
            // US2843980: Facility & Physician - Updates to Fields in Additional Details Card - Changing order of EPS Date and PTI
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'EPS Date', additionalDetails != null && additionalDetails.epsDate != null ? additionalDetails.epsDate : '--', 'outputText',true));
            //2nd row
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Gender', additionalDetails != null && additionalDetails.Gender != null ? additionalDetails.Gender : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'DEA/DABP', additionalDetails != null && additionalDetails.DeaDabp != null ? String.join(additionalDetails.DeaDabp, ',') : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Medicare Assignment', medicareAssignment, 'outputText',true));
            // Hover Text
            ACET_AutoDocUtil.FieldDetails hoverPTI = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'PTI', additionalDetails != null && additionalDetails.pti != null ? additionalDetails.pti : '--', 'hoverText',true);
            hoverPTI.popupId = 'ptipopup';
            hoverPTI.description = 'See below for description:';
            hoverPTI.descriptionList = new List < String > {
                'Y = Select the physician/practitioner record.',
                'N = Select the group record.',
                'E = Select the individual record if found, otherwise select the group record.',
                'M = Multiple groups exist for a physician or allied health professional.',
                'O = This value will only be used for 100% Non-Par groups.',
                'G = Select the individual if PAR, if not select the group'
            };
            hoverPTI.moveLeft = '-250';
            hoverPTI.moveRight = '-405';
            cardData.add(hoverPTI);
        } else {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TPSM Level', additionalDetails != null && additionalDetails.TPSMLevel != null ? additionalDetails.TPSMLevel : '--', 'outputText',true));
            ACET_AutoDocUtil.FieldDetails hoverPTI = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'PTI', additionalDetails != null && additionalDetails.pti != null ? additionalDetails.pti : '--', 'hoverText',true);
            // Hover Text
            hoverPTI.popupId = 'ptipopup';
            hoverPTI.description = 'See below for description:';
            hoverPTI.descriptionList = new List < String > {
                'Y = Select the physician/practitioner record.',
                'N = Select the group record.',
                'E = Select the individual record if found, otherwise select the group record.',
                'M = Multiple groups exist for a physician or allied health professional.',
                'O = This value will only be used for 100% Non-Par groups.',
                'G = Select the individual if PAR, if not select the group'
            };
            hoverPTI.moveLeft = '-250';
            hoverPTI.moveRight = '-405';
            cardData.add(hoverPTI);
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'EPS', additionalDetails != null && additionalDetails.EPS != null ? additionalDetails.EPS : '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Eps Date', additionalDetails != null && additionalDetails.epsDate != null ? additionalDetails.epsDate : '--', 'outputText',true));
        }

        //UI 
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
        //2nd row
        //UI
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, false, '', '', ''));
        providerCardDetails.cardData = cardData;

        return providerCardDetails;
    }

    // Credentialling
    public static ACET_AutoDocUtil.TableDetails setCredentialData(List < SAE_ProviderSnapshotWrapper.CredentialCard > credDetails) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Credentialing';
		affTable.showComponentName= true;
        affTable.autodocHeaderName = 'Credentialing';
        affTable.tableHeaders = new List < String > {
            'QUALIFICATIONS',
            'DEGREE SCHOOL NAME',
            'RESIDENCY'
        };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (credDetails != null) {
            for (integer i = 0; i < credDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = credDetails[i].Qualification;
                // US3691213
                tableRow.caseItemsExtId = caseItemsExtId;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].Qualification,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].SchoolName != '' ? credDetails[i].SchoolName : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].Residency != '' ? credDetails[i].Residency : '--',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }

    public static ACET_AutoDocUtil.TableDetails setSpecialityData(List < SAE_ProviderSnapshotWrapper.SpecialityCardWrapper > SpecialityRecords, String providerType) {
        ACET_AutoDocUtil.TableDetails specTable = new ACET_AutoDocUtil.TableDetails();
        specTable.type = 'table';
        specTable.componentName = 'Specialty';
        specTable.autodocHeaderName = 'Specialty';
        specTable.componentOrder = 2;
		specTable.showComponentName = true;
        if (providerType == 'Facility') {
            specTable.tableHeaders = new List < String > {
                'SPECIALTY',
                'PRIMARY'
            };
        } else {
            specTable.tableHeaders = new List < String > {
                'SPECIALTY',
                'BOARD CERTIFICATION',
                'CANCEL DATE',
                'PRIMARY'
            };
        }
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (SpecialityRecords != null) {
            for (integer i = 0; i < SpecialityRecords.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = SpecialityRecords[i].Speciality;
                // US3691213
                tableRow.caseItemsExtId = caseItemsExtId;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', SpecialityRecords[i].Speciality,true));
                if (providerType != 'Facility') {
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', SpecialityRecords[i].BoardCertification != '' ? SpecialityRecords[i].BoardCertification : '--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', SpecialityRecords[i].CancelDate != '' ? SpecialityRecords[i].CancelDate : '--',true));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', SpecialityRecords[i].IsPrimary != '' ? SpecialityRecords[i].IsPrimary : '--',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            specTable.tableBody = tableRows;
        }
        return specTable;
    }

    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getAffiliationData(String providerId, String taxId) {
        ACETWSCalloutResult calloutRes = SAE_ProviderSnapshotController.getAffData(providerId, taxId);
        List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > affData = (List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > ) calloutRes.Response;
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.statusCode = calloutRes.statusCode;
        try{
            affTable.type = 'table';
            affTable.componentOrder = 4;
            affTable.showComponentName = false;
            affTable.componentName = 'Active Affiliations';
            affTable.autodocHeaderName = 'Active Affiliations';
            affTable.tableHeaders = new List < String > {
                'NAME',
                'PROVIDER ID/MPIN', //US2990280 - Sravan
                'EFFECTIVE DATE',
                'AFFILIATION TYPE',
                'ADMIT PRIVILEGE'
            };
            List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
            if (affTable != null && affData != null) {
                for (SAE_ProviderSnapshotWrapper.ActiveAffWrapper aff: affData) {
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = aff.Name;
                    // US3691213
                    tableRow.caseItemsExtId = caseItemsExtId;
                    List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', aff.Name,true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', aff.ProviderId,true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', aff.EffectiveDate,true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', aff.AffiliationType,true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', aff.AdmittingPriv,true));
                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                }
            }
            
            if (affData == null || affData.isEmpty()) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = 'No records found.';
                // US3691213
                tableRow.caseItemsExtId = caseItemsExtId;
                tableRow.isNoRecords = true;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'No records found.',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
            
        } catch(exception e) {
            system.debug('exception'+e.getStackTraceString());
            affTable.statusCode = 999;
        }
        return affTable;
    }

    // Card Data
    public class SnapshotDataData {
        @AuraEnabled public ACET_AutoDocUtil.CardDetails physicianDetails;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails additionalDetails;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails specialityDetails;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails credDetails;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails activeAffDetails;
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String errorMessage;
        // US3291540 - Sanka
        @AuraEnabled public Integer statusCode;
    }

    public class contactDetails {
        @AuraEnabled public String contactNumber{get; set;}
        @AuraEnabled public String contactName{get; set;}
        @AuraEnabled public String contactExt{get; set;}
        // US3691213
        @AuraEnabled public String caseItemsExtId { get; set; }
        @AuraEnabled public Boolean isProviderLookup { get; set; }
    }

    @AuraEnabled
    public static Boolean getInstanceType() {
        Boolean isSandbox;
        Organization OrgData  =[SELECT IsSandbox FROM Organization LIMIT 1];
        isSandbox = OrgData.IsSandbox;
        return isSandbox;
    }

    @AuraEnabled
    public static string getIPAValue(string strInput){
        return ACET_ProviderStatusCtrl.processIPAString(strInput);
    }
}