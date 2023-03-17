/********************************************************************************
Class Name: PC_TestUtility
Purpose: This class helps to generate dummy test data for Test Classes.
Developer: Suman Kundu
Created On: 10/25/2018 
********************************************************************************/
@IsTest
public with sharing class PC_TestUtility {
    /**
     * @name         :   getUser
     * @description  :   This method returns a dummy user instance.
     * @param        :   String profileName, String email
     * @return       :   User
     * @author       :   Suman Kundu
     * @createddate  :   10/25/2018
     **/
    public static User getUser(String profileName, String email) {
        // Retrive profile details
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName]; 
        // Create User         
        return new User(Alias='prov100', UserName=email, Email=email, EmailEncodingKey='UTF-8', LastName='ACETTest',
                        LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles');
    }
    /**
     * @name         :   getRecordTypeId
     * @description  :   This method returns the record type id from provided sobject and record type name.
     * @param        :   String sobjectName, String recTypeName
     * @return       :   Id
     * @author       :   Suman Kundu
     * @createddate  :   10/25/2018
     **/
    public static Id getRecordTypeId(String sobjectName, String recTypeName) {
        return Schema.getGlobalDescribe().get(sobjectName).getDescribe()
                     .getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
    }
    /**
     * @name         :   getCase
     * @description  :   This method prepares, creates and returns an Case instance.
     * @param        :   String recTypeName, Boolean isResurrected, Integer resurrectionLevel, 
                         Id orgCaseId, Id res1CaseId, Id res2CaseId
     * @return       :   Case
     * @author       :   Suman Kundu
     * @createddate  :   10/25/2018
     **/
    public static Case getCase(String recTypeName, Boolean isResurrected, Integer resurrectionLevel, 
                               Id orgCaseId, Id res1CaseId, Id res2CaseId) {
        // Get required Record type id
        Id recTypeId = PC_TestUtility.getRecordTypeId('Case', recTypeName);
        Case cs = new case();
        cs.RecordTypeId = recTypeId;
        cs.Status = 'New'; 
        //cs.PC_Type_of_Request__c = 'Escalation'; 
        cs.PC_Is_There_Active_PRs__c = 'No';
        cs.PC_Provider_Region__c = 'Central';
        //cs.PC_RESCU_Provider_State__c = 'IN'; 
        cs.Submitting_Department__c = 'OHPH'; 
        //cs.PC_Delegated_Type__c = 'Non - Delegated';
        //cs.PC_Line_of_Business__c = 'E&I'; 
        //cs.PC_Reason_for_Resurrect__c = 'BSAR Error';
        
        // Prepares case instance according to condition
        if (isResurrected) {
            //cs.PC_MPIN_Count__c = 1; 
            //cs.PC_MPIN_1__c = '123456789'; 
            cs.PC_Provider_TIN__c = '123456789';
            cs.PC_ResurrectedLevel__c = resurrectionLevel;
            
			/*
			* US3705044: Will be removed as part of RESCU removal
			*
			if (resurrectionLevel >= 1) {
               cs.PC_Original_Case__c = orgCaseId;
            }
            if (resurrectionLevel >= 2) {
                cs.PC_Resurrected_Case_1__c = res1CaseId;				
            }
            if (resurrectionLevel == 3) {
                cs.PC_Resurrected_Case_2__c = res2CaseId;				
            }
			*/			
        } else {
            cs.PC_ResurrectedLevel__c = 0;
        }
        insert cs;
        return cs;
    }
    
   
    /**
     * @name         :   getRoutingConfig
     * @description  :   This method returns a dummy routing configuration.
     * @param        :   String queueName, String region
     * @return       :   Routing_Configuration__c
     * @author       :   Suman Kundu
     * @createddate  :   11/23/2018
     **/
    public static Routing_Configuration__c getRoutingConfig(String queueName, String region) {
        Routing_Configuration__c config = new Routing_Configuration__c();
        config.IsActive__c = true;
        config.PC_Provider_Region__c = region;
        config.Queue_Name__c = queueName;
        config.SortOrder__c = 1100;
        config.Topic1__c = 'RESCU';
        config.Priority_Routing__c = 'No';
        insert config;
        return config;
    }
    /**
     * @name         :   getDummyLayoutContent
     * @description  :   This method returns dummy case layout content.
     * @param        :   None
     * @return       :   String
     * @author       :   Suman Kundu
     * @createddate  :   10/26/2018
     **/
    public static String getDummyLayoutContent() {
        return '[  '+
                '   {  '+
                '      "columns":"2",'+
                '      "heading":"Fields",'+
                '      "layoutRows":[  '+
                '         {  '+
                '            "layoutItems":[  '+
                '               {  '+
                '                  "editable":"false",'+
                '                  "label":"Case Record Type",'+
                '                  "layoutComponents":{  '+
                '                     "displayLines":"1",'+
                '                     "tabOrder":"30",'+
                '                     "type":"Field",'+
                '                     "value":"RecordTypeId"'+
                '                  },'+
                '                  "placeholder":"false",'+
                '                  "required":"false"'+
                '               },'+
                '               {  '+
                '                  "editable":"true",'+
                '                  "label":"Provider Region",'+
                '                  "layoutComponents":{  '+
                '                     "displayLines":"1",'+
                '                     "tabOrder":"43",'+
                '                     "type":"Field",'+
                '                     "value":"PC_Provider_Region__c"'+
                '                  },'+
                '                  "placeholder":"false",'+
                '                  "required":"true"'+
                '               }'+
                '            ],'+
                '            "numItems":"2"'+
                '         }, {  '+
                '            "layoutItems":[  '+
                '               {  '+
                '                  "editable":"false",'+
                '                  "label":"",'+
                '                  "placeholder":"true",'+
                '                  "required":"false"'+
                '               },'+
                '               {  '+
                '                  "editable":"true",'+
                '                  "label":"AEP",'+
                '                  "layoutComponents":{  '+
                '                     "displayLines":"1",'+
                '                     "tabOrder":"58",'+
                '                     "type":"Field",'+
                '                     "value":"AEP__c"'+
                '                  },'+
                '                  "placeholder":"false",'+
                '                  "required":"false"'+
                '               }'+
                '            ],'+
                '            "numItems":"2"'+
                '         }'+
                '      ],'+
                '      "rows":"2",'+
                '      "useCollapsibleSection":"false",'+
                '      "useHeading":"false"'+
                '   }, {  '+
                '      "columns":"2",'+
                '      "heading":"Header",'+
                '      "layoutRows":[  '+
                '          {  '+
                '            "layoutItems":[  '+
                '               {  '+
                '                  "editable":"true",'+
                '                  "label":"AEP",'+
                '                  "layoutComponents":{  '+
                '                     "displayLines":"1",'+
                '                     "tabOrder":"58",'+
                '                     "type":"Field",'+
                '                     "value":"AEP__c"'+
                '                  },'+
                '                  "placeholder":"false",'+
                '                  "required":"false"'+
                '               },'+
                '              {  '+
                '                  "editable":"false",'+
                '                  "label":"",'+
                '                  "placeholder":"true",'+
                '                  "required":"false"'+
                '               }'+
                '            ],'+
                '            "numItems":"2"'+
                '         }'+
                '     ],'+
                '      "rows":"2",'+
                '      "useCollapsibleSection":"false",'+
                '      "useHeading":"true"'+
                '   }'+
                ']';
    }
}