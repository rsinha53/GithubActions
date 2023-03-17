global class ACET_SpecialityValuesScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        updateSpecialityValues();
    }
    
    @future(callout=true)
    public static void updateSpecialityValues() {
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_SpecialityServiceEndPoint').Value__c;
        Integer totalRecords = 0;
        Integer offset = 0;
        Integer noOfRows = 50;
        String responseBody = '';
        Integer statusCode = 0;
        HttpResponse httpResponse = new HttpResponse();
        List<ACET_SpecialityResultWrapper.Records> specialityValuesList = new List<ACET_SpecialityResultWrapper.Records>();
        do {
            String requestParameters = '?app-nm=acet&atrribute-set=specialty&active_ind=A&start='+String.valueOf(offset);
            Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(endpoint + requestParameters);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpResponse = h.send(httpRequest);
            responseBody = httpResponse.getBody();
            statusCode = httpResponse.getStatusCode();
            if (statusCode == 200) {
                ACET_SpecialityResultWrapper specialityResponse = ACET_SpecialityResultWrapper.parse(responseBody);
                offset = specialityResponse.metadata.offset + specialityResponse.metadata.psize;
                noOfRows = specialityResponse.metadata.psize;
                totalRecords = specialityResponse.metadata.total;
                for (ACET_SpecialityResultWrapper.Records specialityRecord : specialityResponse.records) {
                 	specialityValuesList.add(specialityRecord);
                }
            }
        } while (offset < totalRecords);
        
        if(!specialityValuesList.isEmpty()) {
            String specialityValues = JSON.serialize(specialityValuesList);
            specialityValues = '{"records":' + specialityValues + '}';
            ACET_CreateOrUpdateStaticResource.createOrUpdateStaticResource('SpecialityDropdownValues', 'application/json', 'PUBLIC', specialityValues);   
        }
    }
}