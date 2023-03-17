/*------------------------------------------------------------
Author:        Pratikshya Satapathy
Description:   Request processor class for the service request "Get Documents"   

Test Class:   
History
Date            Author              	  Comments
-------------------------------------------------------------
26-10-2022		Manmeet Kaur			  Modified
------------------------------------------------------------*/
public class SENSAPI_GetDocumentsReqProcessor implements IRestRequestProcessor {
    
    public SENSAPI_GetDocumentsRequest request;
    public SENSAPI_GetDocumentsResponse responseDetails;
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        try{   
            responseDetails = new SENSAPI_GetDocumentsResponse();
            initProcessor(requestStructure);
            if(String.isNotBlank(request.memberSensId) && String.isNotBlank(request.subscriberId)){
                String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                List<SNI_FL_Care_Team_Member__c> careTeamMemberId = SENSAPI_Utility.getSpecificCareTeamMemberForFamily(request.memberSensId, subscriberId);
                if(careTeamMemberId.size() > 0){
                    string latest = request.latest;
                    string oldest = request.oldest;
                    integer count = request.count;
                    integer offset = request.offset;
                    Id memberSensId = request.memberSensId  ;
                    list<id> memViewIds = new list<id>();
                    list<contentdocument> cdFam = new list<contentdocument>();
                    list<contentdocumentlink> clinkFam = new list<contentdocumentlink>();
                    map<Id,Id> memberInfoToAccountMap = new map<Id,Id>();
                    String qry;
                    Integer totalRecords;
                    
                    List<user> uslist = [SELECT Id,isActive,contactId
                                         FROM User
                                         WHERE contact.accountId =:memberSensId LIMIT 1];
                    
                    if(uslist.size()>0  && uslist[0].isActive == true && uslist[0].contactId!=NULL){   
                        Set<Id> authorizedIds = new  Set<Id>();
                        //To get all the members who has authorized for their info to be shared with the requester
                        for(SNI_FL_Members_ROI__c roi : [SELECT SNI_FL_Account__c
                                                         FROM SNI_FL_Members_ROI__c
                                                         WHERE SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c =: memberSensId
                                                         AND SNI_FL_Status__c = 'Active']){
                            authorizedIds.add(roi.SNI_FL_Account__c);    
                        }
                        authorizedIds.add(memberSensId);
                        //Querying Member Info records because documents are linked to member info records
                        for(Member_Information__c mem : [SELECT id,Account__c
                                                         FROM Member_Information__c
                                                         WHERE Account__c in:authorizedIds]){
                            memViewIds.add(mem.Id);
                            memberInfoToAccountMap.put(mem.Id,mem.Account__c);
                        }
                        if(memViewIds.size()>0){
                            //Querying all the documents
                            clinkFam = [SELECT id,LinkedEntityId,ContentDocumentId
                                        FROM ContentDocumentLink
                                        WHERE LinkedEntityId in:memViewIds
                                        AND Visibility='AllUsers'];
                            set<Id> documentsIdset = new set<Id>();
                            for(contentDocumentLink cdl : clinkFam){
                                documentsIdset.add(cdl.ContentDocumentId);
                            }  
                            qry = 'SELECT Id,Title,fileType,createdDate,contentSize,LastModifiedDate,OwnerId FROM ContentDocument WHERE '
                                + 'Id IN:documentsIdset'; 
                            if(String.isNotBlank(oldest)){
                                DateTime old = (DateTime)JSON.deserialize('"'+oldest+'"', DateTime.class);
                                qry = qry + ' AND CreatedDate>=:old';
                            }
                            if(String.isNotBlank(latest)){
                                DateTime ltst = (DateTime)JSON.deserialize('"'+latest+'"', DateTime.class);
                                qry = qry + ' AND CreatedDate<=:ltst';
                            }
                            totalRecords = database.query(qry).size();                                
                            qry = qry + ' ORDER BY CreatedDate DESC';
                            if(count!=null){
                                qry = qry + ' LIMIT '+ count;
                            }
                            if(offset!=null){
                                qry = qry + ' OFFSET '+ offset;
                            }
                            cdFam = database.query(qry);
                        }else {
                            //No family overview and member information is present
                            responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.MEMBER_INFO_MISSING);
                        }
                        if(cdFam.size()>0){
                            //populating success response
                            populateDocumentsInformation(cdFam,clinkFam,memberInfoToAccountMap);
        					responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(true,200, totalRecords);

                        }else{
                            //No document is uploaded
                            responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(true,200,0); 
                            responseDetails.documentList = new List<SENSAPI_GetDocumentsResponse.docClass>();
                        }
                    }else{
                        //Invalid SENS User Id
                        responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.USER_INACTIVE);
                    }
                }else{
                    responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.INVALID_USER_DETAILS);
                }
            }else{
                //Invalid SENS User Id
                responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false,400,SENSAPI_Constant.REQUIREDFIELD_MISSING);
            }
            
        }catch(Exception ex) {
            responseDetails.status = new SENSAPI_GetDocumentsResponse.API_Status(false, 500, ex.getMessage() + ex.getStackTraceString());            
        }  
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    public void populateDocumentsInformation(List<contentdocument>docs, List<contentdocumentlink>clinks,Map<Id,Id> memberInfoToAccountMap){
         
        List<SENSAPI_GetDocumentsResponse.docClass> documentList = new List<SENSAPI_GetDocumentsResponse.docClass>();
        list<Id> contentDocId = new list<Id>();
        map<Id,Id> contentdoclinkId = new map<Id,Id>();
        map<Id,String> downloadMap = new map<Id,String>();
        
        for(contentdocumentlink clink :clinks){
           contentdoclinkId.put(clink.contentdocumentid,memberInfoToAccountMap.get(clink.linkedentityid));
        }
        
        for(contentdocument doc :docs){
           contentDocId.add(doc.id);
        }
        for(contentdistribution cd:[SELECT 
                                    ContentDocumentId,
                                    ContentDownloadUrl
                                    FROM 
                                    ContentDistribution WHERE ContentDocumentId IN:contentDocId]){
            downloadMap.put(cd.ContentDocumentId,cd.ContentDownloadUrl);
        }        
        for(contentdocument cd : docs){
            SENSAPI_GetDocumentsResponse.DocClass doc = new SENSAPI_GetDocumentsResponse.DocClass();
            doc.documentId = cd.Id;
            doc.title = cd.Title;
            doc.ownerSensId = cd.OwnerId;
            doc.lastModifiedDate = cd.lastModifiedDate;
            doc.downloadURL = downloadMap.get(cd.id);
            doc.docType = cd.fileType;
            doc.contentSize = cd.contentSize;
            doc.createdDate = cd.createdDate;
            doc.policyMemberSensId  = contentdoclinkId.get(cd.Id);
            documentList.add(doc);
        }
		responseDetails.documentList = documentList;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetDocumentsRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception(SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }        
    }
}