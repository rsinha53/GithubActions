// US2186401 - Thanish - 31st Dec 2019
public class ACET_ProviderContractService extends ACETWebService{
    
    static final string COMMON_ERROR_MESSAGE_CNS = 'Unexpected Error Occurred with�the C&S Contracts. Please try again. If problem persists please contact the help desk.';
    static final string COMMON_ERROR_MESSAGE_ENI = 'Unexpected Error Occurred with�the E&I�Contracts. Please try again. If problem persists please contact the help desk.';
    static final string COMMON_ERROR_MESSAGE_MNR = 'Unexpected Error Occurred with�the M&R�Contracts. Please try again. If problem persists please contact the help desk.';

    public override void getEndpoint() {
        GetEndpointDetail('ContractSummary');
    }
    
   // returns fetched C and S contract data from the api
    public ACETWSCalloutResult getCAndSContracts(string providerId, string taxId, string addressId, boolean isActive) {
        getEndpoint();
        // variable to store returning data
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try {
            // generate post api url
            String url = '';
            
            if(isActive) {
                url = RelativeURL + '?' + 'prov-id=' + providerId 
                    + '&app-nm=acet&attribute-set=communityandstate&tax_id_nbr=' + taxId + '&adr_id=' + addressId;
            } else {
                url = RelativeURL + '?' + 'prov-id=' + providerId 
                    + '&app-nm=acet&attribute-set=communityandstate&tax_id_nbr=' + taxId + '&adr_id=' + addressId + '&months-of-inactive-data=24';
            }
    		
            system.debug('RelativeURL::'+RelativeURL);
            system.debug('url::'+url);
            // send request and get response
            Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            httpRequest.setEndpoint(url);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + SAE_ProviderCardCtrl.getAuthToken()); //got token from postman OAuth
            httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setTimeout(12000);
            system.debug('RequestBody' + url);
            httpResponse = h.send(httpRequest);
            Integer statusCode = httpResponse.getStatusCode();

            // check response status
            if (statusCode == 200) {
                // parse response
                ACET_CAndSContractsResponse contractResponse = ACET_CAndSContractsResponse.parse(httpResponse.getBody());

                calloutResult.Success = true;
                calloutResult.Response = contractResponse;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = httpResponse.getStatus();
                calloutResult.MessageSeverity = ApexPages.Severity.CONFIRM;

                return calloutResult;

            } else {
                // send error details when response fails
                calloutResult.Success = false;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = COMMON_ERROR_MESSAGE_CNS;
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

                return calloutResult;
            }

        } catch (Exception ex) {
            // send error details when there is an exception
            calloutResult.Success = false;
            calloutResult.statusCode = 999;
            calloutResult.Message = COMMON_ERROR_MESSAGE_CNS;
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

            return calloutResult;
        }
    }

    // returns fetched E and I contract data from the api
    public ACETWSCalloutResult getEAndIContracts(string providerId, string taxId, string addressSeq, String marketType, String marketSite, String insTypeCode, boolean isActive) { // US2696849 - Thanish - 22nd Jul 2020
        getEndpoint();
        // variable to store returning data
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try {
            // generate post api url
            String url = '';
            
            if(isActive) {
                url = RelativeURL + '?' + 'prov-id=' + providerId  // US2696849 - Thanish - 22nd Jul 2020
                    + '&app-nm=acet&attribute-set=employerandindividual&tax_id_nbr=' + taxId;
            } else {
                url = RelativeURL + '?' + 'prov-id=' + providerId  // US2696849 - Thanish - 22nd Jul 2020
                    + '&app-nm=acet&attribute-set=employerandindividual&tax_id_nbr=' + taxId + '&months-of-inactive-data=24';
            }
            // Sanka - US3464932
            if(addressSeq != null){
                url = url + '&adr-seq=' + addressSeq;
            }
            // US2696849 - Thanish - 23rd Jul 2020
            if(marketType != null){
                url = url + '&mkt-typ-cd=' + marketType;
            }
            if(marketSite != null){
                url = url + '&mkt-nbr=' + marketSite;
            }
            if(insTypeCode != null){
                url = url + '&prdct-ofr-cd=' + insTypeCode;
            }

            // send request and get response
            Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            httpRequest.setEndpoint(url);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + SAE_ProviderCardCtrl.getAuthToken()); //got token from postman OAuth
            httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setTimeout(12000);
            system.debug('RequestBody' + url);
            httpResponse = h.send(httpRequest);
            Integer statusCode = httpResponse.getStatusCode();

            // check response status
            if (statusCode == 200) {
                // parse response
                ACET_EAndIContractsResponse contractResponse = ACET_EAndIContractsResponse.parse(httpResponse.getBody());

                calloutResult.Success = true;
                calloutResult.Response = contractResponse;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = httpResponse.getStatus();
                calloutResult.MessageSeverity = ApexPages.Severity.CONFIRM;

                return calloutResult;

            } else {
                // send error details when response fails
                calloutResult.Success = false;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = COMMON_ERROR_MESSAGE_ENI;
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

                return calloutResult;
            }

        } catch (Exception ex) {
            // send error details when there is an exception
            calloutResult.Success = false;
            calloutResult.statusCode = 999;
            calloutResult.Message = COMMON_ERROR_MESSAGE_ENI;
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

            return calloutResult;
        }
    }
    
    // US2696849 - Thanish - 22nd Jul 2020
    // returns fetched M and R contract data from the api
    public ACETWSCalloutResult getMAndRContracts(string providerId, string taxId, string addressId, string cosDiv, string cosPanNum, boolean isActive) {
        getEndpoint();
        // variable to store returning data
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try {
            // generate post api url
            String url = RelativeURL + '?' + 'prov-id=' + providerId + '&adr-id=' + addressId;
            
            if(isActive) {
                url = url + '&app-nm=acet&attribute-set=medicareandretirement&tax_id_nbr=' + taxId;
            } else {
                url = url + '&app-nm=acet&months-of-inactive-data=24&attribute-set=medicareandretirement&tax_id_nbr='  + taxId;
            }
            if(cosDiv != null){
                url = url + '&cosmos-div=' + cosDiv;
            }
            if(cosPanNum != null){
                url = url + '&cosmos-panel-nbr=' + cosPanNum;
            }

            // send request and get response
            Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            httpRequest.setEndpoint(url);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + SAE_ProviderCardCtrl.getAuthToken()); //got token from postman OAuth
            httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setTimeout(12000);
            system.debug('RequestBody' + url);
            httpResponse = h.send(httpRequest);
            Integer statusCode = httpResponse.getStatusCode();

            // check response status
            if (statusCode == 200) {
                // parse response
                ACET_MAndRContractsResponse contractResponse = ACET_MAndRContractsResponse.parse(httpResponse.getBody());

                calloutResult.Success = true;
                calloutResult.Response = contractResponse;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = httpResponse.getStatus();
                calloutResult.MessageSeverity = ApexPages.Severity.CONFIRM;

                return calloutResult;

            } else {
                // send error details when response fails
                calloutResult.Success = false;
                calloutResult.statusCode = statusCode;
                calloutResult.Message = COMMON_ERROR_MESSAGE_MNR;
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

                return calloutResult;
            }

        } catch (Exception ex) {
            // send error details when there is an exception
            calloutResult.Success = false;
            calloutResult.statusCode = 999;
            calloutResult.Message = COMMON_ERROR_MESSAGE_MNR;
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;

            return calloutResult;
        }
    }
}