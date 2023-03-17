public class ACET_TestDataFactory {
    
    //Test Runas user
    public static User getUser(String profile){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile]; 
        User userRecord = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                   EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                   LocaleSidKey='en_US', ProfileId = p.Id, 
                                   TimeZoneSidKey='America/Los_Angeles', UserName= profile.deleteWhitespace()+'@testorg.com');   
        return userRecord;     
    }
    
    //Webservice Setting insertion
    public static void createWebServiceSetting(String serviceName, String serviceValue){
        ISL_Webservice_Config__c webServiceRecord = new ISL_Webservice_Config__c(Name = serviceName,
                                                                                  Is_Available__c = true,
                                                                                  Value__c = serviceValue);
        Insert webServiceRecord;
    }
    
    //Case Creation
    public static Case createCase(){
        Case caseRecord = new Case(Status = 'Open');
        insert caseRecord;
        return caseRecord;
    }
    
    //Attachment insertion
    public static void createAttachment(String recordId) {
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;        
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = recordId;
        insert newFileShare;
    }
}