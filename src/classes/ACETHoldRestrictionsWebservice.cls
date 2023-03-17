public with sharing class ACETHoldRestrictionsWebservice extends ACETWebservice{
    public override void GetEndpoint()
    {
        GetEndpointDetail('HoldRestrictions');
    }
    
    public ACETHoldRestrictionsWebservice () {
        super('Stargate');
    } 
    
    public String formatDate(String dateString){
        if(dateString == null) return null;

        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];

            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 

            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    
    private void GetRequestBody(String groupId,String memberId, String startDate, String holdLevel, String holdCode)
    {
        RequestBody = '{"selectHoldRestrictionsRequest":{\n'
                    +'"groupNumber": "'+groupId+'",'
                    +'"memberId": "'+memberId+'",'
                    +'"startDate": "'+startDate+'",'
                    +'"endDate": "",'
                    +'"holdLevel": "'+holdLevel+'",'
                    +'"holdCode": "'+holdCode+'"'
                    +'}}';
                
    }
    
    public ACETWSCalloutResult holdRestriction(String memberId, string groupId, String startDate, String holdLevel, String holdCode){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            getEndpoint();
            GetRequestBody(groupId,memberId,startDate, holdLevel, holdCode);
            //GetRequestBody('1198480','02323710500','2019-02-13', 'All', 'All');
            system.debug('>>>RequestBody'+RequestBody );
            HttpResponse response = Send(OAuthConfig);
            //response.setStatusCode(404);
            system.debug('response ---->'+response.getBody());
            ACETMemberDetail memDetail = new ACETMemberDetail();
            memDetail.holdCodeList = new List<ACETMemberDetail.holdCodeInfo>();
            List<ACETHoldRestrictionsJSON2Apex.holdCodeInfo> tempHoldCodeList = new List<ACETHoldRestrictionsJSON2Apex.holdCodeInfo>();

            if(response.getStatusCode() == 200){
                system.debug('>>>Status code 200');
                if(response.getBody() != null){
                    String responseBody = response.getBody().replace('\"type\":', '\"type_z\":');
                    responseBody = responseBody.replace('\"id\":', '\"id_z\":');
                    ACETHoldRestrictionsJSON2Apex json2Apex = (ACETHoldRestrictionsJSON2Apex)JSON.deserialize(responseBody, ACETHoldRestrictionsJSON2Apex.class);
                    system.debug('JSON2Apex : ' + json2Apex);
                    ACETHoldRestrictionsJSON2Apex.selectHoldRest holdRest = (json2Apex.selectHoldRestrictionsResponse != null)?json2Apex.selectHoldRestrictionsResponse.selectHoldRestrictions:null;
                    if(holdRest != null && holdRest.holdList != null){
                        for(ACETHoldRestrictionsJSON2Apex.holdCodeInfo holdCodeItem:holdRest.holdList){
                            ACETMemberDetail.holdCodeInfo holdItem = new ACETMemberDetail.holdCodeInfo();
                            holdItem.holdCode = (holdCodeItem.holdCode != null)?holdCodeItem.holdCode:'';
                            holdItem.holdDescription = (holdCodeItem.holdDescription!= null)?holdCodeItem.holdDescription:'';
                            holdItem.effectiveDate = (holdCodeItem.effectiveDate!= null)?formatDate(holdCodeItem.effectiveDate):'';
                            holdItem.expirationDate = (holdCodeItem.expirationDate != null)?formatDate(holdCodeItem.expirationDate):'';
                            holdItem.holdNote = (holdCodeItem.holdNote != null)?holdCodeItem.holdNote:'';
                            holdItem.holdRestriction = (holdCodeItem.holdRestriction != null)?holdCodeItem.holdRestriction:new List<String>();
                            holdItem.holdRestriction.sort();
                            holdItem.holdLevel = (holdCodeItem.holdLevel != null)?holdCodeItem.holdLevel:'';
                            memDetail.holdCodeList.add(holdItem);
                        }
                    } 
                }
                 calloutResult.Success = true;
                 calloutResult.Message = '';
                 calloutResult.Response = memDetail;
            }else
            {
                calloutResult.Success = false;
                //calloutResult.Message = 'Error';
                calloutResult.statusCode = response!=null?response.getStatusCode():null;
                //calloutResult.Response = 'Web Service or External System is temporarily unavailable.';
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in holdRestriction. Details: ' + ex.getstackTraceString()); 
            calloutResult.Success = false;
            calloutResult.Message = ex.getMessage();
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.statusCode=999;
        }
        
        return calloutResult;   
    
    } 
}