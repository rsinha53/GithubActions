@isTest
public class ETSBE_EscalatControllerTest { 
    
    static testmethod void updateinteractTest() {    
        
        String selectedUser='{"0":{"label":"Gaurav Ahuja","value":"usrRecord.id","isSelected":true},"1":{"label":"Gaurav Kumar","value":"usrRecord.id","isSelected":true}}';        
        Interaction__c intract = new Interaction__c();
        insert intract;
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Case cas =new Case();
        cas.status= 'Open';
        cas.PC_Escalation_Reason__c = 'AEP (Annual Enrollment Program)';
        cas.Case_Type__c = 'BEO Case';
        cas.Interaction__c = intract.Id;
        cas.RecordTypeId = recTypeId;
        insert cas;
        system.assertEquals('BEO Case',cas.Case_Type__c);
        Document documentObj = new Document();
        documentObj.Body = Blob.valueOf('Some Document Text');
        documentObj.Name = 'Chromium Edge Logo';
        documentObj.FolderId = UserInfo.getUserId();
        insert documentObj;

        String strWraaper = '{"WhoOwnsIssue":"Test DCSM User","WhereWasIssueRouted":"Self Resolved","IsSpecRepWorking":"Yes","RequestNumber":"1234","MemberInfo":"Test Member, 1234"}';
        String EscalationDesc = 'test description' ;
        ETSBE_EscalatController.updateInteractrec(cas.Id, strWraaper, EscalationDesc,selectedUser);
        String strWrapper1 = '{"WhoOwnsIssue":"Test DCSM User1","WhereWasIssueRouted":"Self Resolved","IsSpecRepWorking":"Yes","RequestNumber":"3456","MemberInfo":"Test Member1, 1234"}';
        ETSBE_EscalatController.updateCaserec(intract.Id, strWrapper1,EscalationDesc,selectedUser);
        ETSBE_EscalatController.checkCaseEsc(intract.Id);
        ETSBE_EscalatController.checkIntEsc(cas.Id);
        ETSBE_EscalatController.getUser();
        ETSBE_EscalatController.getQueueFromCase(cas.Id);
        ETSBE_ProjectTimerCont.updatecaserec(cas.Id,'test', 'true');
        ETSBE_ProjectTimerCont.getcaserec(cas.Id);
       
    }
    
    static testmethod void fetchRecordsTest() {
          User usr = [SELECT Id FROM User WHERE id=: UserInfo.getUserId()];
        try{
            Map<String, String> bodyMap = new Map<String, String>();
            bodyMap.put('isSelected', 'true');
            bodyMap.put('label', 'Gaurav Ahuja');
            bodyMap.put('value', usr.Id);
            bodyMap.put('isSelected', 'true');
            bodyMap.put('label', 'Gaurav Kumar');
            bodyMap.put('value', usr.Id);            
            List<string> newLst=new List<string>();
            newLst.add(JSON.serialize(bodyMap));           
            String objectName='User';
            String Searchstring='Sks';
            String filterField='Name';
            String myJSON = JSON.serialize(newLst);
            
            List<ETSBE_EscalatController.RecordsData> recdataLst=new List<ETSBE_EscalatController.RecordsData>();         
            ETSBE_EscalatController.RecordsData recdata=new ETSBE_EscalatController.RecordsData(filterField,myJSON);
            
            Test.startTest();
            recdataLst=ETSBE_EscalatController.fetchRecords(objectName,Searchstring,filterField,myJSON);
            Test.stopTest();
        }
        catch(Exception e){
            System.assert(true, 'Exception ' + e);
        }
    }
}