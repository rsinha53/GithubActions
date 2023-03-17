@isTest
private class ComboboxFieldCtrl_Test {
    @isTest static void getComboboxRecords_Test() {
        Account acc = new Account(
            Name = 'Test'
        );
        Insert acc;
        ComboboxFieldCtrl.getComboboxRecords('Account', 'Name', 'Name', 'Name!=null');
        ComboboxFieldCtrl.getComboboxRecords('Account', 'Name', '', 'Name!=null');

        ComboboxFieldCtrl.getComboboxRecords('Account', 'Name', 'Name', '');
        ComboboxFieldCtrl.getComboboxRecords('Account', 'Name', '', '');
    }

    @isTest static void getComboboxRecords_Test1() {
        ORS_Routing_Information__mdt data = new ORS_Routing_Information__mdt(
            DeveloperName = 'Test',
            Topic__c='Provider Lookup',
            Advocate_Role__c='All',
            State__c='UT,TX',
            Team__c='Central & West C&W'
        );
        //Insert data;
        Map<String,Object>  result=ComboboxFieldCtrl.getZones('TX');
        System.debug('result>>>ketki'+result+'zone>>'+result.get('zone'));
        System.assertEquals('Central & West C&W', result.get('zone'));
    }
}