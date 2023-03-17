/********************************************************************************
Class Name: PC_CPMCaseTriggerHandlerTest
Purpose: This test class tests all the functionality under controller PC_CPMCaseTriggerHandler.
Developer: Suman
Created On: 7/25/2018 
********************************************************************************/
@isTest
public class PC_CPMCaseTriggerHandlerTest {
    // Below method prepares data required for the testing.
    @testSetup static void setupTestData() {
        List<Routing_Configuration__c> routingList = new List<Routing_Configuration__c>();
        Routing_Configuration__c rt1 = new Routing_Configuration__c();
        rt1.Topic1__c = 'Proactive';
        rt1.Type__c = 'C&S CSP Facets';
        rt1.Subtype__c = 'National';
        rt1.Queue_Name__c = 'CSP NM';
        rt1.Onshore_Restriction__c = 'Yes';
        rt1.ProfileName__c = 'Provider Claims;System Administrator';
        rt1.IsActive__c = true;
        rt1.Priority_Routing__c = 'No';
        rt1.Priority__c = 'Standard';
        rt1.SortOrder__c = 1;
        routingList.add(rt1);
        Routing_Configuration__c rt2 = new Routing_Configuration__c();
        rt2.Topic1__c = 'Proactive';
        rt2.Type__c = 'C&S CSP Facets';
        rt2.Subtype__c = 'CO, HI, MA, MD, MI, MS, NC, NE, NV, RI, WA, WI';
        //rt2.Subtype__c = 'CO, HI, MA, MD, MI, MS, NE, NV, RI, WA, WI';
        rt2.Queue_Name__c = 'CSP Facets MI, NE, WI, MD, WA Proactive';
        rt2.Onshore_Restriction__c = 'No';
        rt2.ProfileName__c = 'Provider Claims;System Administrator';
        rt2.IsActive__c = true;
        rt2.Priority_Routing__c = 'No';
        rt2.Priority__c = 'Standard';
        rt2.SortOrder__c = 2;
        routingList.add(rt2);
        insert routingList;
    }
    
    // Below method checks all the functionality in during case creation with CPM Record type.
    @isTest static void testFunctionalities() {
        // Retrive CPM profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Provider Claims']; 
        // Create User         
        User u = new User(Alias='cpm', Email='standarduserforcpm2@testorg.com', EmailEncodingKey='UTF-8', LastName='CpmTest', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles',
                          UserName='standarduserforcpm3@testorg.com');
        // Get provider claim Record type id
        Id cpmRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Claim Project Management').getRecordTypeId();
        
        System.runAs(u) {
            Test.startTest();
            Case cs = new Case(RecordTypeId=cpmRecordType, Status='New', PC_Contact_Type__c='N/A', Topic__c='Proactive',
                        Type__c='C&S CSP Facets', Subtype__c='National');
            insert cs;
            Case updatedCase = [SELECT Onshore_Restriction__c FROM Case WHERE Id=:cs.Id];
            //System.assertEquals(updatedCase.Onshore_Restriction__c, 'Yes');
            
            cs.Subtype__c = 'CO, HI, MA, MD, MI, MS, NC, NE, NV, RI, WA, WI';
            //cs.Subtype__c = 'CO, HI, MA, MD, MI, MS, NE, NV, RI, WA, WI';
            update cs;
            updatedCase = [SELECT Onshore_Restriction__c FROM Case WHERE Id=:cs.Id];
            System.assertEquals(updatedCase.Onshore_Restriction__c, 'No');
            
            Project_Details__c pd = new Project_Details__c(Parent_Case__c=cs.Id);
            insert pd;
            
            try {
                cs.Status = 'Closed';
                update cs;
            } catch(Exception ex) {
                System.assert(ex.getMessage().contains('Please provide Root Cause and Closure Code on CPM Project Form to close the case.'));
            }
            
            Test.stopTest();
        }
    }
}