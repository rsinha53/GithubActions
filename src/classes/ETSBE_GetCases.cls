public class ETSBE_GetCases {
    public static List<ETSBE_GetCases.CaseWrapper> getRelatedCases(String producerid,String groupid,String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType){
        List<Case> caseLst = new List<Case>();
        System.debug(Logginglevel.INFO, 'taxMemberID:' + taxMemberID + ' @@xRefIdIndividual@@ ' + xRefIdIndividual);
        System.debug(Logginglevel.INFO, 'toggleOnOff:' + toggleOnOff + ' @@flowType@@ ' + flowType);
        List<ETSBE_GetCases.CaseWrapper> caseWrapperlst = new List<ETSBE_GetCases.CaseWrapper>();
        Id beorecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
		Id beoclosedrecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO Closed').getRecordTypeId();
        if(flowType == 'Member'){
            if(toggleOnOff){
                //Retrieving Member family cases
                if(String.isNotBlank(taxMemberID)){
                    String query = 'SELECT id, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason,Surrogate_Key__c FROM CASE '; 		 
                    query += ' WHERE  Originator_Type__c != null';
                    
                     query += '  and ID__c = :taxMemberID ORDER BY CaseNumber DESC LIMIT 1000';
                    system.debug('query@@@ ' + query);
                    List<Case> caseRespLst = Database.query(query);
                    caseWrapperlst = ETSBE_GetCases.getCases(caseRespLst);
                }
            }else{
                //Retrieving Individual member cases
                System.debug(Logginglevel.INFO, '@@xRefIdIndividual@@ ' + xRefIdIndividual);
                if(String.isNotBlank(xRefIdIndividual)){
                    
                    String query = 'SELECT id, Originator_Type__c,Account.eid__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason,Surrogate_Key__c FROM CASE '; 		 
                    query += ' WHERE Account.eid__c = :xRefIdIndividual  and Originator_Type__c != null  ';
                    
                   
                    query += ' and ID__c = :taxMemberID ORDER BY CaseNumber DESC LIMIT 1000';
                    system.debug('query@@@ ' + query);
                    List<Case> caseRespLst = Database.query(query);
                    caseWrapperlst = ETSBE_GetCases.getCases(caseRespLst);
                }
            }
        }
        if(flowType == 'Group'){
            //to retrieve the Provider or facility Cases
            if(String.isNotBlank(groupid)){
                String query = 'SELECT id, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason FROM CASE '; 		 
                 query += ' WHERE Originator_Type__c != null and (ID__c = :groupid or Subject_Group_ID__c=:groupid)';
                 
                
                query += ' ORDER BY CaseNumber DESC LIMIT 1000';
                
                system.debug('query@@@ ' + query);
                List<Case> caseRespLst = Database.query(query);
                caseWrapperlst = ETSBE_GetCases.getCases(caseRespLst);
            }
        }
        if(flowType == 'Producer'){
            //to retrieve the Provider or facility Cases
            if(String.isNotBlank(producerid)){
                String query = 'SELECT id, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason FROM CASE '; 		 
                query += ' WHERE (ID__c = :producerid or Broker_ID__c = :producerid)  and Originator_Type__c != null ';
               
                query += ' ORDER BY CaseNumber DESC LIMIT 1000';
                //system.debug('query@@@ ' + query);
                List<Case> caseRespLst = Database.query(query);
                caseWrapperlst = ETSBE_GetCases.getCases(caseRespLst);
                
            }
        }

        return caseWrapperlst;
    }
    
    public static List<ETSBE_GetCases.CaseWrapper> getCases(List<Case> caseRespLst){

        List<ETSBE_GetCases.CaseWrapper> caseWrapperlst = new List<ETSBE_GetCases.CaseWrapper>();
        
        if(caseRespLst!= null && caseRespLst.size() > 0){
            for(Case caseObj : caseRespLst){
                CaseWrapper caseWrap = new CaseWrapper();
                caseWrap.OriginatorType = String.valueOf(caseObj.Originator_Type__c);
                caseWrap.CreatedDate =  ACETUtility.format(caseObj.CreatedDate);
               
                String  fullName = caseObj.Subject_Name__c;
                string subjectName;
                if(fullName != null){
                    List<String> subjectList = fullName.split(' ');
                    subjectName = subjectList[0];
                }
              	
                String relationship = '';
                
                if(caseObj.Relationship__c != null){
                    relationship = caseObj.Relationship__c;
                }else{
                    relationship = '--';
                }
                
                if(caseObj.Relationship__c != null || String.isNotBlank(subjectName) || String.isNotBlank(relationship)){
                     // caseWrap.relationship = subjectName +' '+'/'+' '+ relationship;
                }
              
                caseWrap.ID = String.valueOf(caseObj.ORS_Issue_ID__c);
                if(String.isNotBlank(caseWrap.ID)){
                    if(0 == caseWrap.ID.indexOf('D')){
                        caseWrap.IDType = 'ORS';
                    }else{
                        caseWrap.IDType = '--';
                    }
                }else{
                    caseWrap.IDType = '--';
                }
                caseWrap.CaseNumber = String.valueOf(caseObj.CaseNumber);
                
                
                if(String.isNotBlank(caseWrap.ID) && String.isNotBlank(caseWrap.CaseNumber)){
                    caseWrap.TopicReason = caseObj.Original_Subtype__c ==null ?  String.valueOf(caseObj.Topic__c)  :  String.valueOf(caseObj.Topic__c) +' '+'/'+' ' + String.valueOf(caseObj.Original_Subtype__c);
                }
                else if(String.isNotBlank(caseWrap.ID) && String.isBlank(caseWrap.CaseNumber)){
                    caseWrap.TopicReason = String.valueOf(caseObj.Reason) +' '+'/'+' '+ String.valueOf(caseObj.Opportunity_Category__c);
                }else{
                    caseWrap.TopicReason = '';
                }
                caseWrap.Status = String.valueOf(caseObj.Status);
                caseWrap.recordID = String.valueOf(caseObj.id);
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
        //@AuraEnabled public string relationship{get;set;}
        //@AuraEnabled public string subject{get;set;}
    }


}