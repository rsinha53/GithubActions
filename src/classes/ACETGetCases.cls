public class ACETGetCases {
    public static List<ACETGetCases.CaseWrapper> getRelatedCases(String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType){
        List<Case> caseLst = new List<Case>();
        System.debug(Logginglevel.INFO, 'taxMemberID:' + taxMemberID + ' @@xRefIdIndividual@@ ' + xRefIdIndividual);
        System.debug(Logginglevel.INFO, 'toggleOnOff:' + toggleOnOff + ' @@flowType@@ ' + flowType);
        List<ACETGetCases.CaseWrapper> caseWrapperlst = new List<ACETGetCases.CaseWrapper>();
        if(flowType == 'Member'){
            if(toggleOnOff){
                //Retrieving Member family cases
                if(String.isNotBlank(taxMemberID)){
                    String query = 'SELECT id,Facets_Issue_ID__c, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason,Surrogate_Key__c FROM CASE ';
                    query += ' WHERE ID__c = :taxMemberID ORDER BY CaseNumber DESC LIMIT 1000';
                   //system.debug('query@@@ ' + query);
                    List<Case> caseRespLst = Database.query(query);
                    caseWrapperlst = ACETGetCases.getCases(caseRespLst);
                }
            }else{
                //Retrieving Individual member cases
                System.debug(Logginglevel.INFO, '@@xRefIdIndividual@@ ' + xRefIdIndividual);
                if(String.isNotBlank(xRefIdIndividual)){
                    String query = 'SELECT id,Facets_Issue_ID__c, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason,Surrogate_Key__c FROM CASE ';
                    query += ' WHERE Surrogate_Key__c = :xRefIdIndividual ORDER BY CaseNumber DESC LIMIT 1000';
                    //system.debug('query@@@ ' + query);
                    List<Case> caseRespLst = Database.query(query);
                    caseWrapperlst = ACETGetCases.getCases(caseRespLst);
                }
            }
        }else{
            //to retrieve the Provider or facility Cases
            if(String.isNotBlank(taxMemberID)){
                String query = 'SELECT id,Facets_Issue_ID__c, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason FROM CASE ';
                query += ' WHERE TaxID__c = :taxMemberID ORDER BY CaseNumber DESC LIMIT 1000';
                //system.debug('query@@@ ' + query);
                List<Case> caseRespLst = Database.query(query);
                caseWrapperlst = ACETGetCases.getCases(caseRespLst);
            }
        }
        
        return caseWrapperlst;
    }
    
    public static List<ACETGetCases.CaseWrapper> getCases(List<Case> caseRespLst){

        List<ACETGetCases.CaseWrapper> caseWrapperlst = new List<ACETGetCases.CaseWrapper>();
        
        if(caseRespLst!= null && caseRespLst.size() > 0){
            Date beforeSixMonths = System.today().addMonths(-6);
            Date beforeSixtyDays = System.today().addDays(-60);
            for(Case caseObj : caseRespLst){
                CaseWrapper caseWrap = new CaseWrapper();
                caseWrap.OriginatorType = String.valueOf(caseObj.Originator_Type__c);
                caseWrap.CreatedDate = caseObj.CreatedDate.format('MM/dd/yyyy hh:mm a');
               	system.debug('createdDate is:::' + caseWrap.CreatedDate);
                String  fullName = caseObj.Subject_Name__c;
                string subjectName;
                if(fullName != null){
                    List<String> subjectList = fullName.split(' ');
                    //subjectName = subjectList[0];
                    subjectName = fullName;
                }else{
                    subjectName = '--';
                }
              
                String relationship = '';
                
                if(caseObj.Relationship__c != null){
                    relationship = caseObj.Relationship__c;
                }else{
                    relationship = '--';
                }
                
                if(caseObj.Relationship__c != null || String.isNotBlank(subjectName) || String.isNotBlank(relationship)){
                      caseWrap.relationship = subjectName +' '+'/'+' '+ relationship;
                }
              Map<String, String> idsMap = new Map<String, String>();
                if(caseObj.ORS_Issue_ID__c != null){
                    caseWrap.ID = String.valueOf(caseObj.ORS_Issue_ID__c);
                    String ORSIDs = String.valueOf(caseObj.ORS_Issue_ID__c);
                    String[] ORSIDList = ORSIDs.split(',');
                    String IdTypeStr;
                    for(String Orsid: ORSIDList){
                        idsMap.put(Orsid,'ORS');
                        IdTypeStr = IdTypeStr == null ? 'ORS' : IdTypeStr + ',' + IdTypeStr;
                    }
                    //caseWrap.IDType = IdTypeStr;
                    caseWrap.IDType = 'ORS';
                }

                if(caseObj.Facets_Issue_ID__c != null){
                    caseWrap.ID = caseWrap.ID != null ? caseWrap.ID +','+ String.valueOf(caseObj.Facets_Issue_ID__c) : String.valueOf(caseObj.Facets_Issue_ID__c);
                    String FacetsIDs = String.valueOf(caseObj.Facets_Issue_ID__c);
                    String[] FacetsIDList = FacetsIDs.split(',');
                    String FacetsIdTypeStr;
                    for(String FacetsID: FacetsIDList){
                        idsMap.put(FacetsID,'FACETS');
                        FacetsIdTypeStr = FacetsIdTypeStr == null ? 'FACETS' : FacetsIdTypeStr + ',' + FacetsIdTypeStr;
                    }
                    //caseWrap.IDType = caseWrap.IDType != null ? caseWrap.IDType +','+ FacetsIdTypeStr : FacetsIdTypeStr;
                    caseWrap.IDType = 'FACETS';
                }
                caseWrap.idMap = idsMap;
                if(caseObj.ORS_Issue_ID__c == null && caseObj.Facets_Issue_ID__c == null){
                    caseWrap.ID = '--';
                }

                /*if(String.isNotBlank(caseWrap.ID)){
                    if(0 == caseWrap.ID.indexOf('D')){
                        caseWrap.IDType = 'ORS';
                    }else{
                        caseWrap.IDType = '--';
                    }
                }else{
                    caseWrap.IDType = '--';
                }*/

                caseWrap.CaseNumber = String.valueOf(caseObj.CaseNumber);
                
                
                if(String.isNotBlank(caseWrap.ID) && String.isNotBlank(caseWrap.CaseNumber)){
                    caseWrap.TopicReason = caseObj.Original_Subtype__c ==null ?  String.valueOf(caseObj.Topic__c)  :  String.valueOf(caseObj.Topic__c) +' '+'/'+' ' + String.valueOf(caseObj.Original_Subtype__c);
                }else{
                    caseWrap.TopicReason = '--';
                }
                caseWrap.Status = String.valueOf(caseObj.Status);
                caseWrap.recordID = String.valueOf(caseObj.id);
                caseWrap.isSixMonths = beforeSixMonths < caseObj.CreatedDate ? true : false;
                caseWrap.isSixtyDays = beforeSixtyDays < caseObj.CreatedDate ? true : false;
                caseWrap.isSprireCase =  true;
                caseWrap.isProvider = caseWrap.OriginatorType == 'Provider' ? true : false;
                caseWrapperlst.add(caseWrap);
            }
            
        }
        
        return caseWrapperlst;
    }
    
    public class CaseWrapper{
        @AuraEnabled public string OriginatorType {get;set;}
        @AuraEnabled public string CreatedDate{get;set;}
        @AuraEnabled public string ID{get;set;}
        @AuraEnabled public string IDType{get;set;}
        @AuraEnabled public string CaseNumber{get;set;}
        @AuraEnabled public string TopicReason{get;set;}
        @AuraEnabled public string Status{get;set;}     
        @AuraEnabled public string recordID{get;set;}
        @AuraEnabled public string relationship{get;set;}
        @AuraEnabled public string subject{get;set;}

        //US2619021
        @AuraEnabled public Boolean isProvider{get;set;}
        @AuraEnabled public Boolean isSixMonths{get;set;}

        @AuraEnabled public Boolean isSixtyDays{get;set;}
        @AuraEnabled public Boolean isSprireCase{get;set;}

        @AuraEnabled public Map<String, String> idMap{get;set;}
    }

}