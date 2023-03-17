public without sharing class ADBMemberProgramsService {
    public static ADBMemberProgramsServiceResponseWrapper callMemberProgramsAPI(String firstName, String lastName, String XrefId, String XrefPartitionId){
        ADBMemberProgramsServiceResponseWrapper rw = new ADBMemberProgramsServiceResponseWrapper();
        ADBMemberProgramsServiceRequestWrapper request = new ADBMemberProgramsServiceRequestWrapper();
        request.availableProgramsRequest = new ADBMemberProgramsServiceRequestWrapper.availableProgramsRequest();
        request.availableProgramsRequest.sourceMemberId = XrefId;
        request.availableProgramsRequest.sourceMemberIdType = 'CDB';
        request.availableProgramsRequest.xrefPartitionID = XrefPartitionId;
        request.availableProgramsRequest.firstName = firstName;
        request.availableProgramsRequest.lastName = lastName;
        request.availableProgramsRequest.dateOfBirth = '';
        request.availableProgramsRequest.state = '';
        request.availableProgramsRequest.memberId = '';
        try {    
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMemberProgramsAPIEndpoint', JSON.serialize(request), null);
            HttpResponse response = wsCallOutFW.getResponse();    

                // Mocked Bethel Williams response with one program
                // Mocked Evelyn Rivera response with multiple program
                if (firstName.toLowerCase().equals('bethel') || firstName.toLowerCase().equals('evelyn')) {
                    String memberMockData = 'ADBMemberProgramsMockResponse' + firstName.toUpperCase();
                    StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
                    response.setBody(mock.body.toString());
                    response.setStatusCode(200);
                }

                if(response.getStatusCode() == 200){

                    String res = response.getBody();

                    // Determine if programs response is of type List
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res);
                    Map<String, Object> availableProgramsResponse = (Map<String, Object>)responseMap.get('availableProgramsResponse');
                    System.debug('availableProgramsResponseTypeList === ' + availableProgramsResponse.get('availableProgramsResponseTypeList'));

                    Boolean isList = (availableProgramsResponse.get('availableProgramsResponseTypeList') instanceof List<Object>);

                    /*  If a member has multiple programs, the programs will return as an array and the flow will sucessfully complete.
                        If a member has only one program, the elements in the list will be converted in the invoking method getReadPopulationDetails()
                        before it is set to v.PopulationDetails
                        */
                    if (isList) {
                        rw = ADBMemberProgramsServiceResponseWrapper.parse(res);
                        if (rw.availableProgramsResponse != null && rw.availableProgramsResponse.statusMessage != null) {
                            system.debug('error === ' + rw.availableProgramsResponse.statusMessage.statusMessage);
                            rw.systemErrorMessage = rw.availableProgramsResponse.statusMessage.statusMessage;
                        }
                    } else {
                        res = res.replace('"availableProgramsResponse"', '"singleAvailableProgramsResponse"');
                        res = res.replace('"availableProgramsResponseTypeList"', '"singleAvailableProgramsResponseList"');
                        rw = ADBMemberProgramsServiceResponseWrapper.parse(res);
                        if (rw.singleAvailableProgramsResponse != null && rw.singleAvailableProgramsResponse.statusMessage != null) {
                            system.debug('error === ' + rw.singleAvailableProgramsResponse.statusMessage.statusMessage);
                            rw.systemErrorMessage = rw.singleAvailableProgramsResponse.statusMessage.statusMessage;
                        }
                    }
                } else {
                    rw.systemErrorMessage = 'An error occurred retrieving member programs';
                }
        }
        catch(Exception ex) {
            System.debug('ERROR : ADBAllProgramController.getReadPopulationAPIDetails() : ' + ex.getMessage());
        }
        return rw;
    }  
}