@isTest
public with sharing class MOTION_MemberSearchControllerTest {
    @IsTest
    static void motion_MemberSearchMT(){
        try{
            // Test data setup
            Case cs = new Case(Origin = 'Phone Call', Status = 'Working', Motion_Eligible_Member_ID_Text__c = '123456', Motion_Registered_Member_ID_Text__c = '454848');
            insert cs;
            
            Test.startTest();        
            MOTION_MemberSearchController.getInteractionTypes();
            MOTION_MemberSearchController.getStatusValues();
            MOTION_MemberSearchController.memberSearchPickListValues();
            MOTION_MemberSearchController.getCases(1, 1, NULL, NULL,false);
            MOTION_MemberSearchController.getCases(1, 1, '123456', '454848',true);
			MOTION_MemberSearchController.getCases(1, 1, '', '',false);
            Test.stopTest(); 
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
    }
    @IsTest
    static void motion_basicMemberSearchMT(){
        // string todaysdate = String.valueof(Date.today());
        try{  
            // Test.setMock(HttpCalloutMock.class, new Motion_MemberInfoMockTest4()); 
            MOTION_MemberSearchController.getBasicSearchResults('Phone Call', 'Mary', 'John','','');
        }catch(Exception ex){}
        
        
    }
    @isTest
    static void motion_advancedMemberSearchMT(){
        
        try{
            Test.setMock(HttpCalloutMock.class, new Motion_MemberInfoMockTest4()); 
            MOTION_MemberSearchController.getAdvanceSearchResults('Phone Call', 'Mary', 'John','', '','','','', '','');
        }catch(Exception Ex){}
        
        
    }
	@isTest
    static void fetchInteractionTest(){
        Interaction__c intrec = TestDataFactory.createInteraction();
		MOTION_MemberSearchController.getcaseTypes('Motion Inquiry');
        MOTION_MemberSearchController.getcaseTypes('');
        MOTION_MemberSearchController.getTaskRecordTypeId('Motion_Task');	 
    }
    
	@isTest
    static void WebEmailCaseMemberSearchFuncTest(){
        Third_Party__c testTP = new Third_Party__c();
        testTP.FullName__c = 'test Party';
        testTP.First_Name__c = 'test';
        testTP.LastName__c = 'Party';
        testTP.Group_Name__c = 'GrpName';
        testTP.Phone_Number__c = '1234567890';
        insert testTP;
        
        Interaction__c intrec = TestDataFactory.createInteraction();
        intrec.Third_Party__c = testTP.Id;
        update intrec;
        string interactionId = intrec.Id;
        
        case testCase = TestDataFactory.createCase();
        string caseId = testCase.Id;
		
        Account perAcc = TestDataFactory.CreatePersonAccount();
        string perAccId = perAcc.Id;
		
        //MOTION_MemberSearchController.searchAndCreateMotionPersonAccount('123456', '', 'Fname', 'Lname', 'test@test.com', '','Web' );
        MOTION_MemberSearchController.getThirdparty('firstName', 'lastName', 'test@test.com', '7897897979', 'groupname', '1111', '', '', '13245', 'web');
        MOTION_MemberSearchController.updatedCase(false, '', '', '', '', '', 'tpSelected', interactionId, caseId, '', '', '', false, false, false, 'Other', 'fullName', '', '', 'test@test.com', '123456', '', 'GroupName', '1111');
        MOTION_MemberSearchController.updatedCase(true, '', '', '', '', '', 'tpSelected', interactionId, caseId, '', '', '', false, false, false, 'Other', 'fullName', '', '', 'test@test.com', '123456', '', 'GroupName', '1111');
        MOTION_MemberSearchController.updatedCase(true, perAccId, '', '', '','', 'memberOrigin', interactionId, caseId, '', '', '', false, false, false, 'Other', 'fullName', '', '', 'test@test.com', '123456', '', 'GroupName', '1111');
    }
}