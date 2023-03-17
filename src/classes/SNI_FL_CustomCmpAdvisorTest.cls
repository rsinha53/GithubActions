@isTest
public class SNI_FL_CustomCmpAdvisorTest {
@isTest static void SNI_FL_CustomCmpAdvisorMethod(){
    account accFam = new account();
     string recTypeId = [select id from recordtype where name= 'Family'].id;
     accFam.recordtypeid = recTypeId;
     accFam.Name = 'FamilyCustAdv1';
     insert accFam;
    Member_Information__c n=new Member_Information__c();
    n.Account__c=accFam.Id;
     n.Onshore_Restriction__c = 'Yes';
     n.UHG_Restriction__c = 'Yes';
insert n;
     Family_Overview__c famOverV = new Family_Overview__c();
     famOverV.Onshore_Restriction__c = 'Yes';
     famOverV.UHG_Restriction__c = 'Yes';
     famOverV.Account__c = accFam.id;
     insert famOverV;
     ContentVersion contentVersion = new ContentVersion(
                Title = 'test',
                PathOnClient = 'test.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
       		 );
        	insert contentVersion;    
        
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            List<ContentDocumentLink> cdlst = new List<ContentDocumentLink>();                     
            ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.LinkedEntityId = famOverV.Id;
            cdl1.ContentDocumentId = documents[0].Id;
            cdl1.Visibility = 'AllUsers';
            cdlst.add(cdl1);
            insert cdlst;
            List<Id> contdoclst = new List<Id>();
            contdoclst.add(documents[0].Id);    
    
    List<ContentDocument> lstCD = SNI_FL_CustomCmpAdvisor.getFiles(famOverV.id);
    List<ContentDocument> lstCD1 = SNI_FL_CustomCmpAdvisor.getallFiles(famOverV.id);
    string attch = SNI_FL_CustomCmpAdvisor.DownloadAttachment(famOverV.id);
    List<ID> lstid = new List<ID>{famOverV.id};
    List<Id> lstIds1 = SNI_FL_CustomCmpAdvisor.AllUserFiles(lstid);
    List<Id> lstIds3 = SNI_FL_CustomCmpAdvisor.AllUserFiles(contdoclst);
    SNI_FL_CustomCmpAdvisor.editDocumentName(documents[0].Id,'test');
    SNI_FL_CustomCmpAdvisor.deleteFiles(documents[0].Id);
     SNI_FL_CustomCmpAdvisor.getUpdatedDocs(contdoclst,accFam.Id,famOverV.Id,'test');
         SNI_FL_CustomCmpAdvisor.getUpdatedDocs(contdoclst,accFam.Id,n.Id,'test');

}
 
   
}