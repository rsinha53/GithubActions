// Sanka Dharmasena - 11.09.2019
// US1816890
public class SAE_ProviderSnapshotController {
     public static Boolean isClaims=false;
     @AuraEnabled
    public static SAE_ProviderSnapshotWrapper.ReturnResponse getProviderDataForClaim(String providerId, String taxId, Boolean isClaim) {
       isClaims=isClaim;
        return SAE_ProviderSnapshotController.getProviderData(providerId,taxId,'');
    }
    @AuraEnabled
    public static SAE_ProviderSnapshotWrapper.ReturnResponse getProviderData(String providerId, String taxId, String adrseq) {
        String cmnUrl='?app-nm=acet&active-ind=BOTH&start=0&count=50&prov-id=' + providerId + '&tax-id-nbr=' + taxId;
        String url =cmnUrl + '&attribute-set=summary_0002';
        String urlDetail =cmnUrl + '&attribute-set=Detail_0001';
        if(!isClaims){
        url =url+ '&adr-seq=' + adrseq ;
        urlDetail =urlDetail+  '&adr-seq=' + adrseq;
        }
        SAE_ProviderSnapshotWrapper.ReturnResponse returnResponse = new SAE_ProviderSnapshotWrapper.ReturnResponse();
        try {
            SAE_ProviderCardCtrl.ProviderDetails reqParams = new SAE_ProviderCardCtrl.ProviderDetails();
            reqParams.IsSnapshot = true;
            reqParams.SnapshotParameters = url;
            Map < String, Object > provData = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParams, false);

            // US1958736 - Thanish - 11th Feb 2020
            // send provider detail call
            SAE_ProviderCardCtrl.ProviderDetails reqParamsDetail = new SAE_ProviderCardCtrl.ProviderDetails();
            reqParamsDetail.IsSnapshot = true;
            reqParamsDetail.SnapshotParameters = urlDetail;
            Map < String, Object > provDataDetail = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParamsDetail, false);
            ACET_ProviderDetailResponse detailResponse = new ACET_ProviderDetailResponse();

            // parse provider detail response if the call is success
            if (provDataDetail.get('statusCode') == 200) {
                String jsonString = provDataDetail.get('providerResponseJSON').toString();
                detailResponse = ACET_ProviderDetailResponse.parse(jsonString);
            }
            // End of Code - US1958736 - Thanish - 11th Feb 2020

            if (provData.get('statusCode') == 200) {
                String DataString = provData.get('providerResponseJSON').toString();
                //DataString = DataString.replace('PhysicianFacilitySummary0002Response', 'PhysicianFacilitySummary0002Response');

                SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse(DataString);

                if (responseDes.PhysicianFacilitySummary0002Response != null && !responseDes.PhysicianFacilitySummary0002Response.isEmpty()) {
                    SAE_ProviderSnapshotWrapper.ProviderCardWrapper provCard = new SAE_ProviderSnapshotWrapper.ProviderCardWrapper();
                    List < SAE_ProviderSnapshotWrapper.SpecialityCardWrapper > spCardList = new List < SAE_ProviderSnapshotWrapper.SpecialityCardWrapper > ();
                    List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > activeAffList = new List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > ();

                    //Provider Card Info
                    SAE_ProviderResponse.PhysicianFacilityInformation physicianInfo = responseDes.PhysicianFacilitySummary0002Response.get(0).physicianFacilityInformation;

                    //US1816853
                    Boolean isPysician = physicianInfo.providerType == 'P' ? true : false;
                    if (isPysician) {
                        provCard.ProviderName = physicianInfo.firstName + ' ' + physicianInfo.middleName + ' ' + physicianInfo.lastName + ' ' + physicianInfo.suffix;
                        provCard.PremiumSpeciality = '';
                    } else {
                        provCard.ProviderName = physicianInfo.facilityName;
                    }

                    provCard.TaxId = physicianInfo.taxId.taxId;
                    provCard.NPI = physicianInfo.npi.get(0).npi;
                    provCard.ProviderId = physicianInfo.providerId;
                    provCard.MedicareProviderId = physicianInfo.medicareId.get(0).medicareId;
                    provCard.DeaDabp = new List < String > ();
                    if (detailResponse.svcResponse != null) {
                        for (ACET_ProviderDetailResponse.Dea dea: detailResponse.svcResponse.physicianFacilityInformation.dea) {
                            if (dea.deaNumber != ' ') {
                                provCard.DeaDabp.add(dea.deaNumber);
                            }

                        }
                    }

                    provCard.MedicalGroup = physicianInfo.taxId.corporateOwnerLastName;
                    provCard.Address = SAE_ProviderSnapshotController.createAddress(physicianInfo.address, false);
                    //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                    provCard.AddressCity = '';
                    provCard.EffectivePhoneNumber = '';
                    if (physicianInfo.address != null && physicianInfo.address.postalAddress != null && physicianInfo.address.postalAddress.city != null) provCard.AddressCity = physicianInfo.address.postalAddress.city;
                    if (physicianInfo.phone != null) {
                        try {
                            for (SAE_ProviderResponse.Phone phn: (List < SAE_ProviderResponse.Phone > ) physicianInfo.phone) {
                                if (phn.primaryPhoneIndicator != null && phn.phoneNumber != null && phn.primaryPhoneIndicator == 'P') provCard.EffectivePhoneNumber = phn.phoneNumber;
                            }
                        } catch (Exception e) {
                            system.debug('== Exception at phoneNumber Mapping' + e.getMessage());
                        }
                    }
                    provCard.PhoneNumber = physicianInfo.phone.get(0).areaCode + '-' + physicianInfo.phone.get(0).phoneNumber.substring(0, 3) + '-' + physicianInfo.phone.get(0).phoneNumber.substring(3);

                    // US1958736 - Thanish - 11th Feb 2020
                    /* if((physicianInfo.qualityEfficiencyValues.efficiencyRatingCode != '') || (physicianInfo.qualityEfficiencyValues.qualityRatingDescription != '') ||
                        (physicianInfo.qualityEfficiencyValues.qualityRatingCode != '') || (physicianInfo.qualityEfficiencyValues.efficiencyRatingDescription != '')) {
                         provCard.PremiumDesignation = 'Y';
                     } else {
                         provCard.PremiumDesignation = 'N';
                     }*/
                    //Added by Vinay 09/21
                    String qRatingdCd = physicianInfo.qualityEfficiencyValues.qualityRatingCode;
                    String eRatingCd = physicianInfo.qualityEfficiencyValues.efficiencyRatingCode;
                    if ((qRatingdCd == 'Q03' || qRatingdCd == 'Q02') && (eRatingCd == 'E03' || eRatingCd == 'E02')) {
                        provCard.PremiumDesignation = 'Y';
                    } else if (qRatingdCd == ' ' || eRatingCd == ' ') {
                        provCard.PremiumDesignation = '--';
                    } else {
                        provCard.PremiumDesignation = 'N';
                    }


                    if (detailResponse.svcResponse != null) {
                        List < ACET_ProviderDetailResponse.OfficeLimitations > officeLimitList = detailResponse.svcResponse.physicianFacilityInformation.officeLimitations;
                        List < String > rangeList = new List < String > ();
                        for (ACET_ProviderDetailResponse.OfficeLimitations officeLimit: officeLimitList) {
                            if (!String.isBlank(officeLimit.patientBeginAge) || !String.isBlank(officeLimit.patientEndAge)) {
                                rangeList.add(officeLimit.patientBeginAge + ' - ' + officeLimit.patientEndAge);
                            }
                        }
                        provCard.PatientRange = rangeList;
                    } else {
                        provCard.PatientRange = new List < String > ();
                    }
                    // End of Code - US1958736 - Thanish - 11th Feb 2020

                    //US1816853
                    provCard.TPSMLevel = physicianInfo.taxId.tpsm.tpsmInd;
                    provCard.pti = physicianInfo.taxId.ptiIndicator;
                    provCard.EPS = physicianInfo.taxId.epsTypeCode + ',' + physicianInfo.taxId.epsTypeDescription;
                    provCard.epsDate = SAEUtils.formatDate(physicianInfo.taxId.epsDate);

                    //Speciality card info
                    for (SAE_ProviderResponse.Specialty_Z spec: physicianInfo.specialty) {
                        SAE_ProviderSnapshotWrapper.SpecialityCardWrapper swrap = new SAE_ProviderSnapshotWrapper.SpecialityCardWrapper();
                        swrap.Speciality = spec.specialty.value;
                        if (spec.specialtyContractOrg.get(0).primaryCode == 'P') {
                            swrap.IsPrimary = 'Y';

                            //US1816853
                            if (isPysician) {
                                provCard.PremiumSpeciality = provCard.PremiumSpeciality == '' ? spec.specialty.value : provCard.PremiumSpeciality;

                                // US1958736 - Thanish - 11th Feb 2020
                                swrap.BoardCertification = '';
                                if (detailResponse.svcResponse != null) {
                                    for (ACET_ProviderDetailResponse.Specialty detailSpecialty: detailResponse.svcResponse.physicianFacilityInformation.specialty) {
                                        if (swrap.Speciality == detailSpecialty.specialty.value) {
                                            swrap.BoardCertification = detailSpecialty.boardCertification.value;
                                            break;
                                        }
                                    }
                                }

                                // Not Mapped Yet
                                swrap.CancelDate = '';
                            }

                        } else {
                            swrap.IsPrimary = 'N';
                        }

                        spCardList.add(swrap);
                    }

                    //US1816853
                    SAE_ProviderSnapshotWrapper.AdditionalDetailCard addDetails = new SAE_ProviderSnapshotWrapper.AdditionalDetailCard();
                    if (isPysician) {
                        //Additional Details
                        addDetails.TPSMLevel = physicianInfo.taxId.tpsm.tpsmInd;
                        addDetails.Gender = physicianInfo.gender;
                        addDetails.Language = '';
                        addDetails.PCPRole = '';
                        addDetails.DeaDabp = new List < String > ();
                        addDetails.MedicareId = new List < String > ();
                        // US1958736 - Thanish - 11th Feb 2020
                        if (detailResponse.svcResponse != null) {
                            for (ACET_ProviderDetailResponse.Dea dea: detailResponse.svcResponse.physicianFacilityInformation.dea) {
                                addDetails.DeaDabp.add(dea.deaNumber);
                            }

                            for (ACET_ProviderDetailResponse.MedicareId medicare: detailResponse.svcResponse.physicianFacilityInformation.medicareId) {
                                if (medicare.medicareId != null) {
                                    addDetails.MedicareId.add(medicare.medicareId);
                                }
                            }
                        }

                        // US2409557 - Sanka - 21.07.2020
                        addDetails.pti = physicianInfo.taxId.ptiIndicator;
                        addDetails.EPS = physicianInfo.taxId.epsTypeCode + ',' + physicianInfo.taxId.epsTypeDescription;
                        addDetails.epsDate = SAEUtils.formatDate(physicianInfo.taxId.epsDate);

                        //returnResponse.AdditionalDetails = addDetails;

                        // Qualifications
                        List < SAE_ProviderSnapshotWrapper.CredentialCard > Credentials = new List < SAE_ProviderSnapshotWrapper.CredentialCard > ();

                        for (SAE_ProviderResponse.Degrees deg: physicianInfo.degrees) {
                            SAE_ProviderSnapshotWrapper.CredentialCard cred = new SAE_ProviderSnapshotWrapper.CredentialCard();
                            cred.Qualification = deg.degreeCode;
                            cred.SchoolName = '';
                            cred.Residency = '';

                            Credentials.add(cred);
                        }

                        returnResponse.Credentials = Credentials;
                    } else {
                        addDetails.TPSMLevel = physicianInfo.taxId.tpsm.tpsmInd;
                        addDetails.pti = physicianInfo.taxId.ptiIndicator;
                        addDetails.EPS = physicianInfo.taxId.epsTypeCode + ',' + physicianInfo.taxId.epsTypeDescription;
                        addDetails.epsDate = SAEUtils.formatDate(physicianInfo.taxId.epsDate);
                    }
                    returnResponse.AdditionalDetails = addDetails;

                    //Active Affliations - Not Available

                    returnResponse.StatusCode = 200;
                    returnResponse.isSuccess = true;
                    returnResponse.ProviderCardDetails = provCard;
                    returnResponse.SpecialityRecords = spCardList;
                    returnResponse.ActiveAffs = activeAffList;
                }
            } else {
                string message = '';
                if (provData.get('statusCode') == 400) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                    returnResponse.StatusCode = 400;
                } else if (provData.get('statusCode') == 404) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                    returnResponse.StatusCode = 404;
                } else if (provData.get('statusCode') == 500) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    returnResponse.StatusCode = 500;
                } else if (provData.get('statusCode') == 100) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN100);
                    returnResponse.StatusCode = 100;
                }

                returnResponse.StatusMessage = message;
                returnResponse.isSuccess = false;
                returnResponse.ProviderCardDetails = new SAE_ProviderSnapshotWrapper.ProviderCardWrapper();
                returnResponse.SpecialityRecords = new List < SAE_ProviderSnapshotWrapper.SpecialityCardWrapper > ();
                //returnResponse.ActiveAffs = new List<SAE_ProviderSnapshotWrapper.ActiveAffWrapper>();*/
                system.debug('returnResponse' + returnResponse);
            }
        } catch (Exception e) {
            returnResponse.StatusCode = 999;
            returnResponse.StatusMessage = e.getMessage();
            returnResponse.isSuccess = false;
        }

        return returnResponse;
    }

    //Address Callout
    @AuraEnabled
    public static SAE_ProviderSnapshotWrapper.AdditionalAddressCard getAddresses(String providerId, String taxId, Integer start, Integer endCount) {
        String url = '?app-nm=acet&active-ind=BOTH&start=' + start + '&count=' + endCount + '&prov-id=' + providerId + '&tax-id-nbr=' + taxId + '&attribute-set=summary_0002';

        SAE_ProviderCardCtrl.ProviderDetails reqParams = new SAE_ProviderCardCtrl.ProviderDetails();
        reqParams.IsSnapshot = true;
        reqParams.SnapshotParameters = url;
        Map < String, Object > provData = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParams, false);
        String DataString = provData.get('providerResponseJSON').toString();
        //DataString = DataString.replace('PhysicianFacilitySummary0002Response', 'PhysicianFacilitySummary0002Response');

        SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse(DataString);

        Integer recordCount = Integer.valueOf(responseDes.metadata.total);

        List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > returnResponse = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();

        List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > primaryAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
        List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > comboAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
        List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > billingAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
        List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > servicingAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();

        SAE_ProviderSnapshotWrapper.AdditionalAddressCard returnCard = new SAE_ProviderSnapshotWrapper.AdditionalAddressCard();

        if (responseDes.PhysicianFacilitySummary0002Response != null && !responseDes.PhysicianFacilitySummary0002Response.isEmpty()) {
            for (SAE_ProviderResponse.PhysicianFacilitySummary0002Response resp: responseDes.PhysicianFacilitySummary0002Response) {
                SAE_ProviderResponse.Address returnAddress = resp.physicianFacilityInformation.address;
                SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper addr = new SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper();

                addr.AddressType = returnAddress.addressTypeDescription;
                addr.IsFreeStandingFacility = '';
                addr.Address = SAE_ProviderSnapshotController.createAddress(returnAddress, true);
                addr.Country = returnAddress.postalAddress.county;
                addr.PhoneNumber = resp.physicianFacilityInformation.phone.get(0).areaCode + '-' + resp.physicianFacilityInformation.phone.get(0).phoneNumber.substring(0, 3) + '-' + resp.physicianFacilityInformation.phone.get(0).phoneNumber.substring(3);

                //Active Indicator - US2068884
                if (returnAddress.addressContractOrg.size() > 0) {
                    String CancelDate = returnAddress.addressContractOrg.get(0).contrOrgCancDate;
                    System.debug(CancelDate);
                    if (!String.isBlank(CancelDate) && CancelDate != null) {
                        Date dt = Date.valueOf(CancelDate);
                        if (dt >= System.today()) {
                            addr.ActiveClass = 'action:approval';
                            addr.ActiveStatus = 'Active';
                        } else {
                            addr.ActiveClass = 'action:close';
                            addr.ActiveStatus = 'Inactive';
                        }
                    } else {
                        addr.ActiveClass = 'standard:empty';
                        addr.ActiveStatus = 'N/A';
                    }
                }

                for (SAE_ProviderResponse.ElectronicCommunication ecom: resp.physicianFacilityInformation.electronicCommunication) {
                    if (ecom.communicationTypeCode == 'E') {
                        addr.Email = addr.Email == '' ? ecom.communicationAddress : addr.Email;
                    } else {
                        addr.FAXNumber = addr.FAXNumber == '' ? ecom.communicationAddress : addr.FAXNumber;
                    }
                }

                if (returnAddress.addressTypeCode == 'D') {
                    comboAddrs.add(addr);
                } else if (returnAddress.addressTypeCode == 'H') {
                    billingAddrs.add(addr);
                } else if (returnAddress.addressTypeCode == 'L') {
                    servicingAddrs.add(addr);
                } else {
                    //Not sure
                    primaryAddrs.add(addr);
                }
            }

            returnResponse.addAll(primaryAddrs);
            returnResponse.addAll(comboAddrs);
            returnResponse.addAll(billingAddrs);
            returnResponse.addAll(servicingAddrs);

            returnCard.AdditionalAdresses = returnResponse;

            if (start == 0) {
                returnCard.prevOffsetBottom = 0;
                returnCard.currOffsetBottom = 0;
                returnCard.nextOffsetBottom = endCount;
            } else {
                returnCard.prevOffsetBottom = start - endCount;
                returnCard.currOffsetBottom = start;
                returnCard.nextOffsetBottom = (start + endCount) >= recordCount ? 0 : (start + endCount);
            }

            returnCard.totalRecordCount = recordCount;
            returnCard.recordsInCurrentPage = returnResponse.size();
        }

        return returnCard;
    }

    //US2465288 - Avish
    @AuraEnabled
    public static List < ACETGetCases.CaseWrapper > getRelatedCasesHistory(String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType) {
        List < ACETGetCases.CaseWrapper > caseWrapperlst = new List < ACETGetCases.CaseWrapper > ();
        caseWrapperlst = ACETGetCases.getRelatedCases(taxMemberID, xRefIdIndividual, toggleOnOff, flowType);
        return caseWrapperlst;
    }

    @AuraEnabled
    public static List < Case > getMemberRelatedCases(String taxID) {
        System.debug('###getMemberCases METHOD');
        List < Case > caseLst = new List < Case > ();
        if (String.isNotBlank(taxID)) {
            caseLst = [SELECT id, Originator_Type__c, CreatedDate, ID__c, CaseNumber, Status, Subject_Name__c, TaxID__c FROM CASE where TaxID__c =: taxID]; //and Subject_Name__c =: firstName
        }
        System.debug('###caseLst ' + caseLst.size());
        return caseLst;
    }

    public static String createAddress(SAE_ProviderResponse.Address address, boolean needBreaks) {
        String returnAddr = '';
        if (needBreaks) {
            returnAddr = address.postalAddress.addressLine1 != '' ? address.postalAddress.addressLine1 + ', ' : '';
            returnAddr = address.postalAddress.addressLine2 != '' ? returnAddr + address.postalAddress.addressLine2 + ', ' : returnAddr;
            returnAddr = address.postalAddress.city != '' ? returnAddr + address.postalAddress.city + ', ' : returnAddr;
            returnAddr = address.postalAddress.state != '' ? returnAddr + address.postalAddress.state + ', ' : returnAddr;
            returnAddr = address.postalAddress.zip != '' ? returnAddr + address.postalAddress.zip : returnAddr;
            // returnAddr = address.postalAddress.zip4 != '' ? returnAddr + address.postalAddress.zip4 : returnAddr;
        } else {
            returnAddr = address.postalAddress.addressLine1 + '<br/>' +
                (address.postalAddress.addressLine2 != '' ? (address.postalAddress.addressLine2 + '<br/>') : '') +
                address.postalAddress.city + ', ' +
                address.postalAddress.state + '<br/>' +
                address.postalAddress.zip;
            // address.postalAddress.zip4;
        }

        return returnAddr;
    }

    public class SearchResultWrapper {
        @Auraenabled
        public string service;
        public SearchResultWrapper(String service) {
            this.service = service;
        }
    }

    @AuraEnabled
    public static SearchResultWrapper getAddressData(String providerId, String taxId, Integer start, Integer endCount, Boolean filtered, Boolean onlyActive) {
        String service;
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();

        SAE_AdditionalAddressService adsService = new SAE_AdditionalAddressService();
        adsService.init(providerId, taxId, start, endCount, filtered, onlyActive);
        service = JSON.serialize(adsService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');

        return new SearchResultWrapper(JSON.serialize(service));
    }

    @AuraEnabled
    public static SearchResultWrapper getAffliationData(String providerId, String taxId, Integer start, Integer endCount) {
        String service;
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();

        SAE_ProviderAffiliationService affsService = new SAE_ProviderAffiliationService();
        affsService.init(providerId, taxId, start, endCount);
        service = JSON.serialize(affsService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');

        return new SearchResultWrapper(JSON.serialize(service));
    }

    @AuraEnabled
    public static ACETWSCalloutResult getAffData(String providerId, String taxId) {
        SAE_ProviderAffiliationService sae = new SAE_ProviderAffiliationService();
        sae.init(providerId, taxId, 1, 50);

        ACETWSCalloutResult ss = sae.queryPaginatedData(1, 50, 0);
        // List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > returnWrapper = (List < SAE_ProviderSnapshotWrapper.ActiveAffWrapper > ) ss.Response;
        return ss;
    }

    //US2465288 - Avish
    public class CaseWrapper {
        @AuraEnabled public string OriginatorType {
            get;
            set;
        }
        @AuraEnabled public string CreatedDate {
            get;
            set;
        }
        @AuraEnabled public string ID {
            get;
            set;
        }
        @AuraEnabled public string IDType {
            get;
            set;
        }
        @AuraEnabled public string CaseNumber {
            get;
            set;
        }
        @AuraEnabled public string TopicReason {
            get;
            set;
        }
        @AuraEnabled public string Status {
            get;
            set;
        }
        @AuraEnabled public string recordID {
            get;
            set;
        }
    }
}