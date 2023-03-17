public with sharing class ACETDocRedeliveryWebservice extends ACETWebservice {
    
    public List<String> searchParameters ;
    public override void GetEndpoint(){  
    }  
    
    public string errorMsg = 'Problem with Document Delivery Webservice: ';
    public Map<String, String> bodyMap;
    public void getrequestBodyMap(){
        bodyMap = new Map<String, String>();
        bodyMap.put('LF',GetRequestFormatByName('DocumentReprintRequestForLF'));
        bodyMap.put('OL',GetRequestFormatByName('DocumentReprintRequestForOL'));
        bodyMap.put('OX',GetRequestFormatByName('DocumentReprintRequestForOX'));
    }
    public String getrequestBodyRedelivery(String bookOfBusinessTypeCode){
        if(bookOfBusinessTypeCode=='LF'){
            return bodyMap.get('LF');
        }else if(bookOfBusinessTypeCode=='OL'){
            return bodyMap.get('OL');
        }
        else{
            return bodyMap.get('OX');
        }
    }
    public ACETWSCalloutResult docRedeliveryWS(ACETDocRedeliveryRequest docRedeliveryReq){     
        
        docRedeliveryReq.docId = docRedeliveryReq.docId.contains('|')?docRedeliveryReq.docId.split('\\|')[0]:docRedeliveryReq.docId;
        searchParameters = new String[] {docRedeliveryReq.redeliveryID,docRedeliveryReq.recepientId,docRedeliveryReq.idQualifier,docRedeliveryReq.recepientType,docRedeliveryReq.docClass,docRedeliveryReq.docId, docRedeliveryReq.fName,docRedeliveryReq.mName,docRedeliveryReq.lName,docRedeliveryReq.suffix,docRedeliveryReq.perAdd1,docRedeliveryReq.perAdd2,docRedeliveryReq.perCity,docRedeliveryReq.perState,docRedeliveryReq.perZip};
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            getrequestBodyMap();
            String body = getrequestBodyRedelivery(docRedeliveryReq.bookOfBusinessTypeCode);
			RequestBody = String.format(body, searchParameters).replaceAll('~', '{');
            //replace data segment FI with IRS when IRS 1095 doc class used
            requestBody = docRedeliveryReq.docClass=='u_1095b'?requestBody.replace('"dataSegment": "FI"','"dataSegment": "IRS"'):requestBody;

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Doc360DocumentReprint', requestBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            switch on response.getStatusCode(){ // DOC360 gives 201 success code
                when 201{
                    String responseBody = response.getBody().replace('type', 'typeZ');
                    ACETReprintJSON2Apex reprintResponse = (ACETReprintJSON2Apex)JSON.deserialize(responseBody, ACETReprintJSON2Apex.class); 
                    oACETWSCalloutResult = processReprintMultiResponse(reprintResponse); 
                }when else{
                    oACETWSCalloutResult = ParseFailureResponse(Response); 
                    oACETWSCalloutResult.Message = errorMsg + oACETWSCalloutResult.Message;                                  
                }
            }
            
        }catch(Exception ex){
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        return oACETWSCalloutResult;    
    }
    
    
    public list<ACETWSCalloutResult> docRedeliveryMultipleWS(list<ACETDocRedeliveryRequest> docRedeliveryReqList){     
        list<String> requestBodyList = new list<String>();
        getrequestBodyMap();
        for(ACETDocRedeliveryRequest docRedeliveryReq: docRedeliveryReqList){
            docRedeliveryReq.docId = docRedeliveryReq.docId.contains('|')?docRedeliveryReq.docId.split('\\|')[0]:docRedeliveryReq.docId;
        	searchParameters = new String[] {docRedeliveryReq.redeliveryID,docRedeliveryReq.recepientId,docRedeliveryReq.idQualifier,docRedeliveryReq.recepientType,docRedeliveryReq.docClass,docRedeliveryReq.docId, docRedeliveryReq.fName,docRedeliveryReq.mName,docRedeliveryReq.lName,docRedeliveryReq.suffix,docRedeliveryReq.perAdd1,docRedeliveryReq.perAdd2,docRedeliveryReq.perCity,docRedeliveryReq.perState,docRedeliveryReq.perZip};
        	String Body = getrequestBodyRedelivery(docRedeliveryReq.bookOfBusinessTypeCode);
            requestBody = String.format(Body, searchParameters).replaceAll('~', '{');
            //replace data segment FI with IRS when IRS 1095 doc class used
            requestBody = docRedeliveryReq.docClass=='u_1095b'?requestBody.replace('"dataSegment": "FI"','"dataSegment": "IRS"'):requestBody;
            requestBodyList.add(requestBody);
        }
        
        requestBody = String.join(requestBodyList,',');
        requestBody = '['+requestBody+']';
        system.debug('@@multibody '+requestBody);
        list<ACETWSCalloutResult> oACETWSCalloutResultList = new list<ACETWSCalloutResult>();
        try{
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Doc360MultipleDocumentReprint', requestBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            switch on response.getStatusCode(){ // DOC360 gives 201 success code
                when 201{
                    String responseBody = response.getBody().replace('type', 'typeZ');
                    ACETReprintMultiResponse reprintResponseList = (ACETReprintMultiResponse)JSON.deserialize(responseBody, ACETReprintMultiResponse.class);
                    for(ACETReprintJSON2Apex reprintResponse: reprintResponseList.reprintResponses){
                        oACETWSCalloutResultList.add(processReprintMultiResponse(reprintResponse));
                    }
                }when else{
                    ACETWSCalloutResult oACETWSCalloutResult = ParseFailureResponse(Response); 
                    oACETWSCalloutResult.Message = errorMsg + oACETWSCalloutResult.Message;      
                    oACETWSCalloutResultList.add(oACETWSCalloutResult);
                }
            } 
        }catch(Exception ex){
            ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResultList.add(oACETWSCalloutResult);
        }
        return oACETWSCalloutResultList;    
    }
    
    public class ACETReprintMultiResponse{
        public list<ACETReprintJSON2Apex> reprintResponses{get;set;}
    }

    public ACETWSCalloutResult processReprintMultiResponse(ACETReprintJSON2Apex reprintResponse){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCommunicationSearchResult selComResult = new ACETCommunicationSearchResult();
        selComResult.resend_Status = String.valueof(reprintResponse.status);
        String receivedDate = reprintResponse.receivedDate!=NULL?String.valueof(reprintResponse.receivedDate):'';
        switch on selComResult.resend_Status{
            when 'Success'{
                String receivedDateVal = receivedDate.contains('T')? receivedDate.split('T')[0]+' '+ receivedDate.split('T')[1].substring(1, receivedDate.split('T')[1].length()):receivedDate;
                selComResult.resend_Date_Time = receivedDateVal;
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = selComResult;   
            }when else{
                String errorDetail = String.isNotBlank(reprintResponse.Error.detail)?String.valueof(reprintResponse.Error.detail):'Internal Server Error';
                oACETWSCalloutResult.Success = false; 
                oACETWSCalloutResult.Message = errorMsg + errorDetail;
                oACETWSCalloutResult.Response = selComResult;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            }
        }
        return oACETWSCalloutResult;
    }
}