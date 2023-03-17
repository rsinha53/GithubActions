public class SAE_AdditionalAddressService extends ACETWebservice {
    public String providerId;
    public String taxId;
    public Integer start;
    public Integer count;
    public Boolean filtered;
    public Boolean onlyActive;

    public void init (String pId, String tId, Integer startNo, Integer countNo, Boolean filtered, Boolean onlyActive) {
        this.providerId = pId;
        this.taxId = tId;
        this.start = startNo;
        this.count = countNo;
        this.filtered = filtered;
        this.onlyActive = onlyActive;
    }

    public override void GetEndpoint()
    {
        //  GetEndpointDetail('findHCPEndpoint');
    }

    public override ACETWSCalloutResult queryPaginatedData (Integer pageNumber, Integer pageSize, Integer startRecord) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult ();

        try {

            Integer startRecordNo = (pageNumber - 1)*pageSize;

            if(startRecordNo < 0){
                startRecordNo = 0;
            }

            String activeInd = this.onlyActive ? 'ACTIVE' : 'BOTH';

            String url = '?app-nm=acet&active-ind='+ activeInd +'&start=' + startRecordNo + '&count=' + pageSize + '&prov-id=' + providerId + '&tax-id-nbr=' + taxId + '&attribute-set=summary_0002';

            SAE_ProviderCardCtrl.ProviderDetails reqParams = new SAE_ProviderCardCtrl.ProviderDetails ();
            reqParams.IsSnapshot = true;
            reqParams.SnapshotParameters = url;
            Map<String, Object> provData = SAE_ProviderCardCtrl.getProviderSearchResponse (reqParams, false);

            Integer statCode = Integer.valueOf (provData.get ('statusCode'));

            //DataString = DataString.replace('PhysicianFacilitySummary0002Response', 'PhysicianFacilitySummary0002Response');
            if (statCode == 200) {
            String DataString = provData.get ('providerResponseJSON').toString ();
            SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse (DataString);

            Integer recordCount = Integer.valueOf (responseDes.metadata.total);

            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> returnResponse = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();

            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> primaryAddrs = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> comboAddrs = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> billingAddrs = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> servicingAddrs = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();

            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> primaryAddrsInactive = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> comboAddrsInactive = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> billingAddrsInactive = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();
            List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> servicingAddrsInactive = new List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> ();

            SAE_ProviderSnapshotWrapper.AdditionalAddressCard returnCard = new SAE_ProviderSnapshotWrapper.AdditionalAddressCard ();

            if (responseDes.PhysicianFacilitySummary0002Response != null && !responseDes.PhysicianFacilitySummary0002Response.isEmpty ()) {
                for (SAE_ProviderResponse.PhysicianFacilitySummary0002Response resp : responseDes.PhysicianFacilitySummary0002Response) {
                    SAE_ProviderResponse.Address returnAddress = resp.physicianFacilityInformation.address;
                    SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper addr = new SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper ();

                    addr.AddressType = returnAddress.addressTypeDescription;
                    addr.IsFreeStandingFacility = '';
                    addr.Address = SAE_ProviderSnapshotController.createAddress (returnAddress, true);
                    addr.Country = returnAddress.postalAddress.county;
                    addr.PhoneNumber = resp.physicianFacilityInformation.phone.get (0).areaCode + '-' + resp.physicianFacilityInformation.phone.get (0).phoneNumber.substring (0, 3) + '-' + resp.physicianFacilityInformation.phone.get (0).phoneNumber.substring (3);

                    //Active Indicator - US2068884
                    if (returnAddress.addressContractOrg.size () > 0) {
                        String CancelDate = returnAddress.addressContractOrg.get (0).contrOrgCancDate;
                            // System.debug (CancelDate);
                        if (!String.isBlank (CancelDate) && CancelDate != null) {
                            Date dt = Date.valueOf (CancelDate);
                            if (dt >= System.today ()) {
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

                    for (SAE_ProviderResponse.ElectronicCommunication ecom : resp.physicianFacilityInformation.electronicCommunication) {
                        if (ecom.communicationTypeCode == 'E') {
                            addr.Email = addr.Email == '' ? ecom.communicationAddress : addr.Email;
                        } else {
                            addr.FAXNumber = addr.FAXNumber == '' ? ecom.communicationAddress : addr.FAXNumber;
                        }
                    }

                    if (returnAddress.addressTypeCode == 'D') {
                        if(addr.ActiveStatus == 'Active'){
                        comboAddrs.add (addr);
                        }else{
                            comboAddrsInactive.add (addr);
                        }
                    } else if (returnAddress.addressTypeCode == 'H') {
                        if(addr.ActiveStatus == 'Active'){
                        billingAddrs.add (addr);
                        }else{
                            billingAddrsInactive.add (addr);
                        }
                    } else if (returnAddress.addressTypeCode == 'L') {
                        if(addr.ActiveStatus == 'Active'){
                        servicingAddrs.add (addr);
                        }else{
                            servicingAddrsInactive.add (addr);
                        }
                    } else {
                        //Not sure
                        if(addr.ActiveStatus == 'Active'){
                        primaryAddrs.add (addr);
                        }else{
                            primaryAddrsInactive.add (addr);
                        }
                    }
                }

                if(this.filtered){
                    returnResponse.addAll (comboAddrs);
                    returnResponse.addAll (servicingAddrs);
                    if(!this.onlyActive){
                    returnResponse.addAll (comboAddrsInactive);
                    returnResponse.addAll (servicingAddrsInactive);
                    }
                }else{
                returnResponse.addAll (primaryAddrs);
                returnResponse.addAll (comboAddrs);
                returnResponse.addAll (billingAddrs);
                returnResponse.addAll (servicingAddrs);
                    if(!this.onlyActive){
                    returnResponse.addAll (primaryAddrsInactive);
                    returnResponse.addAll (comboAddrsInactive);
                    returnResponse.addAll (billingAddrsInactive);
                    returnResponse.addAll (servicingAddrsInactive);
                }
                }

                oACETWSCalloutResult.Response = returnResponse;
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.pageNumber = String.valueOf(pageNumber);
                oACETWSCalloutResult.pageSize = String.valueOf(pageSize);
                //oACETWSCalloutResult.recordCount = String.valueOf(recordCount);
                oACETWSCalloutResult.recordCount = String.valueOf(returnResponse.size());
                oACETWSCalloutResult.totalCount = String.valueOf(recordCount);
                    oACETWSCalloutResult.statusCode = statCode;
                // oACETWSCalloutResult.totalPages = Pagination.totalPages;
            }
            } else {
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                oACETWSCalloutResult.statusCode = statCode;

                String message = '';

                if (statCode == 400) {
                    // Not Valid for Provider
                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                    message = 'Bad Request';
                } else if (statCode == 404) {
                    // Not Valid for Provider
                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                    message = 'Not Found';
                } else if (statCode == 500) {
                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
                } else if (statCode == 100) {
                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN100);
                } else {
                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
                }

                oACETWSCalloutResult.Message = message;
            }
        } catch (Exception ex) {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode = 999;

            // For Dev Debugging
            String DevError = SAEConstants.debugMsg;
            DevError.replace ('{ClassName}', 'SAE_AdditionalAddressService')
                .replace ('{LineNumber}', String.valueOf (ex.getLineNumber ()));
            System.debug (DevError);
        }

        return oACETWSCalloutResult;
    }
}