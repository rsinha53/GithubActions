public with sharing class ACETLGT_HoldRestrictionsWebservice extends ACETWebservice{
    public override void GetEndpoint()
    {
        GetEndpointDetail('HoldRestrictions');
    }
    
    public ACETLGT_HoldRestrictionsWebservice () {
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
        getEndpoint();
        GetRequestBody(groupId,memberId,startDate, holdLevel, holdCode);
        //GetRequestBody('1198480','02323710500','2019-02-13', 'All', 'All');
        system.debug('>>>RequestBody'+RequestBody );
        HttpResponse response = Send(OAuthConfig);
        system.debug('response ---->'+response.getBody());
        ACETLGT_MemberSearchCoveragesResult memDetail = new ACETLGT_MemberSearchCoveragesResult();
        memDetail.holdCodeList = new List<ACETLGT_MemberSearchCoveragesResult.holdCodeInfo>();
        List<ACETLGT_HoldRestrictionsJSON2Apex.holdCodeInfo> tempHoldCodeList = new List<ACETLGT_HoldRestrictionsJSON2Apex.holdCodeInfo>();
        if(response.getStatusCode() == 200){
            system.debug('>>>Status code 200');
            if(response.getBody() != null){
                String responseBody = response.getBody().replace('\"type\":', '\"type_z\":');
                responseBody = responseBody.replace('\"id\":', '\"id_z\":');
                ACETLGT_HoldRestrictionsJSON2Apex json2Apex = (ACETLGT_HoldRestrictionsJSON2Apex)JSON.deserialize(responseBody, ACETLGT_HoldRestrictionsJSON2Apex.class);
                system.debug('JSON2Apex : ' + json2Apex);
                ACETLGT_HoldRestrictionsJSON2Apex.selectHoldRest holdRest = (json2Apex.selectHoldRestrictionsResponse != null)?json2Apex.selectHoldRestrictionsResponse.selectHoldRestrictions:null;
                if(holdRest != null && holdRest.holdList != null){
                    for(ACETLGT_HoldRestrictionsJSON2Apex.holdCodeInfo holdCodeItem:holdRest.holdList){
                        ACETLGT_MemberSearchCoveragesResult.holdCodeInfo holdItem = new ACETLGT_MemberSearchCoveragesResult.holdCodeInfo();
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
            calloutResult.Message = 'Error';
            calloutResult.Response = 'Web Service or External System is temporarily unavailable.';
        }
        
        return calloutResult;   
    
    } 
}