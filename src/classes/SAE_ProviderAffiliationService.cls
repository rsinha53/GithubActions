public with sharing class SAE_ProviderAffiliationService extends ACETWebservice {
    public String providerId;
    public String taxId;
    public Integer start;
    public Integer count;

    public void init (String pId, String tId, Integer startNo, Integer countNo) {
        this.providerId = pId;
        this.taxId = tId;
        this.start = startNo;
        this.count = countNo;
    }

    public override void GetEndpoint () {
        //  GetEndpointDetail('findHCPEndpoint');
    }

    public override ACETWSCalloutResult queryPaginatedData (Integer pageNumber, Integer pageSize, Integer startRecord) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult ();
        try {
            Integer startRecordNo = (pageNumber - 1) * pageSize;

            // String url = 'https://gateway-stage.optum.com/api/alpha/pdr/pes/hospital-affiliations/v1.0/search?app-nm=acet&active-ind=BOTH&start='+ startRecordNo +'&count='+ pageSize +'&prov-id='+ providerId +'&tax-id-nbr='+ taxId +'&tax-id-type-cd=T&attribute-set=ProviderAffiliations_0001';
            String url = '';
            String endpoint = ISL_Webservice_Config__c.getValues ('SAE_ProviderAffiliation').value__c;
            String appParams = '?app-nm=acet&active-ind=BOTH&start=' + startRecordNo + '&count=' + pageSize + '&prov-id=' + providerId + '&tax-id-nbr=' + taxId + '&tax-id-type-cd=T&attribute-set=ProviderAffiliations_0001';

            url = endpoint + appParams;

            Http h = new Http ();
            HttpRequest httpRequest = new HttpRequest ();
            HttpResponse httpResponse = new HttpResponse ();

            httpRequest.setEndpoint (url);
            httpRequest.setMethod ('POST');
            httpRequest.setHeader ('Authorization', 'Bearer ' + SAE_ProviderCardCtrl.getAuthToken ()); //got token from postman OAuth
            httpRequest.setHeader ('Content-Type', 'application/x-www-form-urlencoded');
            httpRequest.setHeader ('Accept', 'application/json');
            httpRequest.setTimeout (12000);
            //system.debug ('RequestBody' + url);
            httpResponse = h.send (httpRequest);

            //System.debug ('response -> ' + httpResponse.getBody ());

            Integer statCode = httpResponse.getStatusCode ();

            // statCode = 501;     

            if (statCode == 200) {
                SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse (httpResponse.getBody ());
                List<SAE_ProviderSnapshotWrapper.ActiveAffWrapper> returnWrapper = new List<SAE_ProviderSnapshotWrapper.ActiveAffWrapper> ();

                if (responseDes.svcResponse != null && !responseDes.svcResponse.isEmpty ()) {

                    for (SAE_ProviderResponse.SvcResponse svcResp : responseDes.svcResponse) {
                        for (SAE_ProviderResponse.Hospital_affiliations hosp : svcResp.hospital_affiliations) {
                            //System.debug (hosp.affil_lst_nm);
                            SAE_ProviderSnapshotWrapper.ActiveAffWrapper aff = new SAE_ProviderSnapshotWrapper.ActiveAffWrapper ();
                            aff.Name = !String.isBlank(hosp.affil_lst_nm) ? hosp.affil_lst_nm : '--';
                            aff.ProviderId = !String.isBlank(hosp.affil_prov_id) ? hosp.affil_prov_id : '--';
                            aff.EffectiveDate = '--';
                            aff.AffiliationType = !String.isBlank(hosp.affil_typ_desc) ? hosp.affil_typ_desc : '--';
                            aff.AdmittingPriv = !String.isBlank(hosp.admit_prvlg_desc) ? hosp.admit_prvlg_desc : '--';

                            returnWrapper.add (aff);
                        }
                    }


                }
                	//DE315145
                	if(returnWrapper.size() == 0)
                    {
                        oACETWSCalloutResult.Message = 'No Records Found.';
                    }

                    oACETWSCalloutResult.Response = returnWrapper;
                    oACETWSCalloutResult.Success = true;

                    oACETWSCalloutResult.pageNumber = String.valueOf (pageNumber);
                    oACETWSCalloutResult.pageSize = String.valueOf (pageSize);
                    oACETWSCalloutResult.recordCount = String.valueOf (returnWrapper.size ());
                    oACETWSCalloutResult.totalCount = String.valueOf (returnWrapper.size ());
                    oACETWSCalloutResult.statusCode = 200;
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
                    message = 'Continue';
                } else {
                    message = 'Unexpected Error Occured';
                }

                oACETWSCalloutResult.Message = message;
            }
        } catch (Exception ex) {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage ();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode = 999;
        }

        return oACETWSCalloutResult;
    }
}