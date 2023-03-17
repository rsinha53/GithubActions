@isTest
public class ACETLGT_createACETConstituentsTest {
    
    public static testMethod void TestMethodOne(){
        
        Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        
        List<Address> adresses = new List<Address>();
        ACETLGT_MemberSearchCoveragesResult.FamilyMember fm = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
        fm.fullName = 'testfullname';
        fm.SFrecId = 'testt';
        fm.FirstName = 'testfname';
        fm.LastName = 'testlname';
        fm.MiddleInitial = 'testMiddleInitial';
        fm.Relationship = 'testRelationship';
        fm.Gender = 'male';  
        fm.DOB = string.valueOf(date.today());
        fm.suffix = 'Mr.';
        fm.EID = 'eid';
        fm.Age = '28';
        fm.FamilyId = 'testFamilyId';
        fm.subscriberIndividualId='testFamilyId';
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        fm.ESRK='testFamilyId';
        fm.selected = false;
        fm.effectiveDate = Date.today();
        fm.termDate = Date.today();
        fm.reinstDate = Date.today();
        fm.CoverageStatus= 'teeest';
        fm.memberStatus = 'testFamilyId';
        
        fm.groupNumber= 'testFamilyId';
        fm.benefitBundleOptionId = 'testFamilyId';  
        fm.accountid =   acc.Id;
        
        fm.srk = 'testFamilyId';
        fm.Relationshiplabel = 'testFamilyId';
        
        
        Test.startTest();
        string eid = 'test';
        Map<String,String> relationshipmap = new Map<String,String>();
        relationshipmap.put('key','value');
        ACETLGT_createACETConstituents.getContacts(acc.Id);
        ACETLGT_createACETConstituents.getPersonAccounts(eid);
        ACETLGT_createACETConstituents.createAccount('testFname','testLname',String.valueOf(date.today()),eid,'testSRKKey,Chain','testinteractionId');
        ACETLGT_createACETConstituents.createMemberAndFamilyMembers(fm,eid,relationshipmap);
        ACETLGT_createACETConstituents.getPersonAccountRecordType();
        Test.stopTest();
        
    }
    
    public static testMethod void TestMethodFour(){
        
        Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        
        List<Address> adresses = new List<Address>();
        ACETLGT_MemberSearchCoveragesResult.FamilyMember fm = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
        fm.fullName = 'testfullname';
        fm.SFrecId = 'testt';
        fm.FirstName = 'testfname';
        fm.LastName = 'testlname';
        fm.MiddleInitial = 'testMiddleInitial';
        fm.Relationship = 'testRelationship';
        fm.Gender = 'male';  
        fm.DOB = string.valueOf('4/24/2015');
        fm.suffix = 'Mr.';
        fm.EID = 'eid';
        fm.Age = '28';
        fm.FamilyId = 'testFamilyId';
        fm.subscriberIndividualId='testFamilyId';
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        fm.ESRK='testFamilyId';
        fm.selected = false;
        fm.effectiveDate = Date.today();
        fm.termDate = Date.today();
        fm.reinstDate = Date.today();
        fm.CoverageStatus= 'teeest';
        fm.memberStatus = 'testFamilyId';
        
        fm.groupNumber= 'testFamilyId';
        fm.benefitBundleOptionId = 'testFamilyId';  
        fm.accountid =   acc.Id;
        
        fm.srk = 'testFamilyId';
        fm.Relationshiplabel = 'testFamilyId';
        
        Contact con = new Contact(lastName = 'test',accountId = acc.id);
        insert con;
        
        Case cs = new Case (ContactId = con.id,subject = 'Text',Surrogate_Key__c = 'testSRKKeyChain');
        insert cs;
        
        Test.startTest();
        string eid = 'test';
        Map<String,String> relationshipmap = new Map<String,String>();
        relationshipmap.put('key','value');
        ACETLGT_createACETConstituents.getContacts(acc.Id);
        ACETLGT_createACETConstituents.getPersonAccounts(eid);
        ACETLGT_createACETConstituents.createAccount('testFname','testLname',String.valueOf(date.today()),eid,'testSRKKeyChain','testinteractionId');
        ACETLGT_createACETConstituents.createMemberAndFamilyMembers(fm,eid,relationshipmap);
        ACETLGT_createACETConstituents.getPersonAccountRecordType();
        Test.stopTest();
        
    }    
    public static testMethod void TestMethodtwo(){
        
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.EID__c  = '1280825';
        insert acc;
        
        string eid = '1280825';
        
        List<Address> adresses = new List<Address>();
        ACETLGT_MemberSearchCoveragesResult.FamilyMember fm = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
        fm.fullName = 'testfullname';
        fm.SFrecId = 'testt';
        fm.FirstName = 'testfname';
        fm.LastName = 'testlname';
        fm.MiddleInitial = 'testMiddleInitial';
        fm.Relationship = 'testRelationship';
        fm.Gender = 'male';  
        fm.DOB = string.valueOf(date.today());
        fm.suffix = 'Mr.';
        fm.EID = eid;
        fm.Age = '28';
        fm.FamilyId = 'testFamilyId';
        fm.subscriberIndividualId='testFamilyId';
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        fm.ESRK='testFamilyId';
        fm.selected = false;
        fm.effectiveDate = Date.today();
        fm.termDate = Date.today();
        fm.reinstDate = Date.today();
        fm.CoverageStatus= 'teeest';
        fm.memberStatus = 'testFamilyId';
        
        fm.groupNumber= 'testFamilyId';
        fm.benefitBundleOptionId = 'testFamilyId';  
        fm.accountid =   acc.Id;
        
        fm.srk = 'testFamilyId';
        fm.Relationshiplabel = 'testFamilyId';
        
        
        
        
        
        Test.startTest();
        
        Map<String,String> relationshipmap = new Map<String,String>();
        relationshipmap.put('key','value');
        
        ACETLGT_createACETConstituents.createMemberAndFamilyMembers(fm,eid,relationshipmap);
        
        Test.stopTest();
        
    }
    
    public static testMethod void TestMethodthree(){
        
        
        
        string eid = '1280825';
        
        List<Address> adresses = new List<Address>();
        ACETLGT_MemberSearchCoveragesResult.FamilyMember fm = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
        fm.fullName = 'testfullname';
        fm.SFrecId = 'testt';
        fm.FirstName = 'testfname';
        fm.LastName = 'testlname';
        fm.MiddleInitial = 'testMiddleInitial';
        fm.Relationship = 'testRelationship';
        fm.Gender = 'male';  
        fm.DOB = string.valueOf(date.today());
        fm.suffix = 'Mr.';
        fm.EID = eid;
        fm.Age = '28';
        fm.FamilyId = 'testFamilyId';
        fm.subscriberIndividualId='testFamilyId';
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        fm.ESRK='testFamilyId';
        fm.selected = false;
        fm.effectiveDate = Date.today();
        fm.termDate = Date.today();
        fm.reinstDate = Date.today();
        fm.CoverageStatus= 'teeest';
        fm.memberStatus = 'testFamilyId';
        
        fm.groupNumber= 'testFamilyId';
        fm.benefitBundleOptionId = 'testFamilyId'; 
        
        fm.srk = 'testFamilyId';
        fm.Relationshiplabel = 'testFamilyId';
        
        Test.startTest();
        
        Map<String,String> relationshipmap = new Map<String,String>();
        relationshipmap.put('key','value');
        
        ACETLGT_createACETConstituents.createMemberAndFamilyMembers(fm,eid,relationshipmap);
        Test.stopTest();
        
    }
}