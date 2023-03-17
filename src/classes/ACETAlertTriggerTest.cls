@isTest
private class ACETAlertTriggerTest {

    @testSetup
    static void setupTestData() {
        List<Alert__c> alerts = new List<Alert__c>{
            new Alert__c(
        		Alert_Title__c = 'Title',
                End_Date__c = Date.today().addDays(5),
                Effective_Date__c = date.today(),
                Alert_Comments__c = 'Comment',
                Type__c = 'Group'
            ),
            new Alert__c(
        		Alert_Title__c = 'Title 2',
                End_Date__c = Date.today().addDays(5),
                Effective_Date__c = date.today(),
                Alert_Comments__c = 'Comment',
                Type__c = 'Group'
            )
        };
        
        insert alerts;
    }
    
    @isTest static void testDuplicateInsertion() {
        Alert__c alert = new Alert__c(
            Alert_Title__c = 'Title',
            End_Date__c = Date.today().addDays(5),
            Effective_Date__c = date.today(),
            Alert_Comments__c = 'Comment',
            Type__c = 'Group'
        );
        try {
            insert alert;
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('This is a duplicate entry.  An alert already exists'));
        }
    }
    
    @isTest static void testDuplicateAlertTitleUpdate() {
        Alert__c alert = [SELECT Alert_Title__c FROM Alert__c WHERE Alert_Title__c = 'Title 2' LIMIT 1];
        try {
            alert.Alert_Title__c = 'Title';
            update alert;
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('This is a duplicate entry.  An alert already exists'));
        }
    }
    
    @isTest static void testDuplicateAlertRangeLower() {
        Alert__c alert = new Alert__c(
        		Alert_Title__c = 'Title',
                End_Date__c = Date.today().addDays(5),
                Effective_Date__c = date.today().addDays(-2),
                Alert_Comments__c = 'Comment',
                Type__c = 'Group'
            );
        try {
            insert alert;
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('This is a duplicate entry.  An alert already exists'));
        }
    }
    
    @isTest static void testDuplicateAlertRangeUpper() {
        Alert__c alert = new Alert__c(
        		Alert_Title__c = 'Title',
                End_Date__c = Date.today().addDays(5),
                Effective_Date__c = date.today().addDays(2),
                Alert_Comments__c = 'Comment',
                Type__c = 'Group'
            );
        try {
            insert alert;
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('This is a duplicate entry.  An alert already exists'));
        }
        ACETAlertTriggerHandler.getDuplicates(new List<String>{'a','b','c','a','b'}, 'abc');
    }
}