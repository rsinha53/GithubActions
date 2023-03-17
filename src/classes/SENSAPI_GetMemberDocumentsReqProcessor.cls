/*------------------------------------------------------------
Author:        Geeta Koli
Description:   Request processor class for the service request "Get Member Documents"   

Test Class:   SENSAPI_GetMemberDocsReqProcessorTest
History
Date            Author              	  Comments
-------------------------------------------------------------
24-11-2022      Geeta Koli                Created
------------------------------------------------------------*/

public class SENSAPI_GetMemberDocumentsReqProcessor  implements IRestRequestProcessor{
    
    
    public SENSAPI_GetDocumentsRequest request;
    public SENSAPI_GetDocumentsResponse responseDetails;
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        try{   
            responseDetails = new SENSAPI_GetDocumentsResponse();
            initProcessor(requestStructure);
            if(String.isNotBlank(request.memberSensId) && String.isNotBlank(request.subscriberId)){
                    string latest = request.latest;
                    string oldest = request.oldest;
                    integer count = request.count;
                    integer offset = request.offset;
                    Id memberSensId = request.memberSensId;
                    list<id> accIds = new list<id>();
                    list<id> familyAccountIds = new list<id>();
                    map<id,id> documentsids = new map<id,id>();
                    list<id> memViewIds = new list<id>();
                    list<contentdocument> cdFam = new list<contentdocument>();
                    list<contentdocumentlink> clinkFam = new list<contentdocumentlink>();
                    map<id,id> memberInfoToAccountMap = new map<id,id>();
                    String qry;
                	String query;
                    Integer totalRecords;
                    
                    request.subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                    
                    List<user> uslist = [SELECT contactId,contact.accountId,IsActive
                                         FROM User
                                         WHERE contact.accountid =:memberSensId LIMIT 1];
                    
                    if(uslist.size()>0 && uslist[0].IsActive == true ){   
                        Set<Id> authorizedIds = new  Set<Id>();

                        list<AccountContactRelation> acrList = [SELECT AccountId,contact.accountid FROM 
                                                                AccountContactRelation 
                        										WHERE Account.Member_Id__c =: request.subscriberId];
                        Boolean validatePersonAcc = false;
                        for(AccountContactRelation acr : acrList){
                            if(acr.Contact.AccountId == memberSensId){
                                validatePersonAcc = true;
                            }
                        }
                        if(validatePersonAcc == true){
                            for(AccountContactRelation acr : acrList){
                                authorizedIds.add(acr.Contact.AccountId);
                            }
                        }
                        if(authorizedIds.size() > 0){
                            //Querying Member Info records because documents are linked to member info records
                            list<Member_Information__c> memView = [SELECT id,Account__c
                                                                   FROM Member_Information__c
                                                                   WHERE Account__c in:authorizedIds];
                            for(Member_Information__c mem : memView){
                                memViewIds.add(mem.id);
                                memberInfoToAccountMap.put(mem.id,mem.Account__c);
                            }
                            if(memView.size()>0){
                                //Querying all the documents
                                clinkFam = [SELECT id,LinkedEntityId, LinkedEntity.name,ContentDocumentId,Visibility,ContentDocument.OwnerId
                                            FROM ContentDocumentLink
                                            WHERE LinkedEntityId in:memViewIds AND Visibility='AllUsers']; 
                                //AND ContentDocument.OwnerId =: uslist[0].Id
                                for(contentdocumentlink cdl : clinkFam){
                                    documentsids.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
                                }  
                                set<id> documentsIdset = documentsids.keyset();
                                query = 'SELECT Id FROM ContentDocument WHERE '
                                    + 'id in:documentsIdset and OwnerId = \''+uslist[0].Id+'\'';
                                if(String.isNotBlank(oldest)){
                                    DateTime old = (DateTime)JSON.deserialize('"'+oldest+'"', DateTime.class);
                                    query = query + ' and createddate>=:old';
                                }
                                if(String.isNotBlank(latest)){
                                    DateTime ltst = (DateTime)JSON.deserialize('"'+latest+'"', DateTime.class);
                                    query = query + ' and createddate<=:ltst';
                                }
                                totalRecords = database.query(query).size(); 
                                
                                qry = 'SELECT Id,Title,description,filetype,createddate,createdby.name,contentsize,LastModifiedDate,Owner.Name,OwnerId,LastModifiedBy.Name,owner.userroleid,owner.userrole.name FROM ContentDocument WHERE '
                                    + 'id in:documentsIdset and OwnerId = \''+uslist[0].Id+'\''; 
                                if(String.isNotBlank(oldest)){
                                    DateTime old = (DateTime)JSON.deserialize('"'+oldest+'"', DateTime.class);
                                    qry = qry + ' and createddate>=:old';
                                }
                                if(String.isNotBlank(latest)){
                                    DateTime ltst = (DateTime)JSON.deserialize('"'+latest+'"', DateTime.class);
                                    qry = qry + ' and createddate<=:ltst';
                                }         
                                qry = qry + ' order by createddate desc';
                                if(count!=null){
                                    qry = qry + ' LIMIT '+ count;
                                }
                                if(offset!=null){
                                    qry = qry + ' OFFSET '+ offset;
                                }
                                System.debug('qry>>'+qry);
                                cdFam = database.query(qry);
                                System.debug('cdFam>>'+cdFam);
                            }else {
                                //No family overview and member information is present
                                responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.MEMBER_INFO_MISSING);
                            }
                            
                            if(cdFam.size()>0){
                                //populating success response
                                //responseDetails = new SENSAPI_GetDocumentsResponse(cdFam,clinkFam,memberInfoToAccountMap,totalRecords);
                                List<SENSAPI_GetDocumentsResponse.DocClass> docList = generateGetDocumentsResponse(cdFam,clinkFam,memberInfoToAccountMap,totalRecords);
                                if(docList.size() > 0){
                                    responseDetails.documentList = docList;
                                }
                                responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(true,200, totalRecords);
                            }else{
                                //No document is uploaded
                                responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(true,200,0); 
                                responseDetails.documentList = new List<SENSAPI_GetDocumentsResponse.docClass>(); 
                            }
                        }else{
                            responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.INVALID_USER_DETAILS);
                        }
                    }else{
                        //Invalid SENS User Id
                        responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.USER_INACTIVE);
                    }
            }else{
                //Invalid SENS User Id
                responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.REQUIREDFIELD_MISSING);
            }
            
        }catch(Exception ex) {
            system.debug('enter catch exception'+ex.getMessage());
            responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false, 500, ex.getMessage() + ex.getStackTraceString());            
        }  
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetDocumentsRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception(SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }        
    }
    
    /*private Boolean validateRequest(){
        Boolean isValid = true;
        if(!String.isBlank(request.subscriberId)){
            List<Account> acc = SENSAPI_Utility.getFamilyAccountForSubscriberId(request.subscriberId);
            if(acc.size() == 0){
                isValid = false;
            }
        }
        if(!isValid){
            responseDetails.status = responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.NO_FAMILYACCOUNT);
        }
        return isValid;
    }*/
    
    public List<SENSAPI_GetDocumentsResponse.DocClass> documentList;
    
    public List<SENSAPI_GetDocumentsResponse.DocClass> generateGetDocumentsResponse(list<contentdocument>docs, list<contentdocumentlink>clinks,map<id,id> memberInfoToAccountMap, Integer docCount){
        
        List<SENSAPI_GetDocumentsResponse.DocClass> documentList = new List<SENSAPI_GetDocumentsResponse.DocClass>();
        list<id>contentdocId = new list<id>();
        map<id,id>contentdoclinkId = new map<id,id>();
        map<id,string>downloadMap = new map<id,string>();
        
        for(contentdocumentlink clink :clinks){
            contentdoclinkId.put(clink.contentdocumentid,memberInfoToAccountMap.get(clink.linkedentityid));
        }
        
        for(contentdocument doc :docs){
            contentdocId.add(doc.id);
        }
        list<contentdistribution> cdr =[Select Id,ContentDocumentId,ContentDownloadUrl,DistributionPublicUrl from 
                                        ContentDistribution where ContentDocumentId in:contentdocId];
        for(contentdistribution cd:cdr){
            downloadMap.put(cd.ContentDocumentId,cd.ContentDownloadUrl);
        }
        
        for(contentdocument cd : docs){
            SENSAPI_GetDocumentsResponse.DocClass doc = new SENSAPI_GetDocumentsResponse.DocClass();
            doc.documentId = cd.id;
            doc.title = cd.title;
            doc.ownerSensId = cd.ownerId;
            doc.lastModifiedDate = cd.lastmodifieddate;
            doc.downloadURL = downloadMap.get(cd.id);
            doc.docType = cd.filetype;
            doc.contentSize = cd.contentsize;
            doc.createdDate = cd.createddate;
            doc.policyMemberSensId  = contentdoclinkId.get(cd.id);
            documentList.add(doc);
        }
        return documentList;
    }
}