@isTest
private class SAEUtils_Test {
    
    static testMethod void searchMember() {
        //Test
        Test.startTest();

        SAEUtils.formatDate('01-01-1990');
        SAEUtils.formatDate('');
        SAEUtils.formatDate('01-01');
        SAEUtils.formatDateRequest('01-01-1990');
        SAEUtils.formatDateRequest('');
        SAEUtils.formatDateRequest('01-01');
        SAEUtils.formatDateFutureDate('01-01-1990');
        SAEUtils.formatDateFutureDate('');
        SAEUtils.formatDateFutureDate('01-01');
        SAEUtils.getAgeFromBirthday('01-01-1990');
        SAEUtils.getAgeFromBirthday('1990-01-01'); 
        String org=SAEUtils.getOrgName();
        System.assertNotEquals(null, org);
        /*
        Interaction__c ips=SAEUtils.createAccountContact('MURPHY','Jr','RUDZEK','1234567890','1234567890','15432123','','','',true,true,true,'upc',false,'joial','Param','');
        System.assertNotEquals(null, ips.Id);
        Interaction__c ips1=SAEUtils.createAccountContact('MURPHY','Jr','RUDZEK','1234567890','1234567890','15432123','','','',false,true,true,'mnf',false,'joial','Param','');
         System.assertNotEquals(null, ips1.Id);
        Interaction__c ips2=SAEUtils.createAccountContact('MURPHY','Jr','RUDZEK','1234567890','1234567890','15432123','','','',false,false,false,'mnf',true,'joial','Param','');
        System.assertNotEquals(null, ips2.Id);
        Interaction__c ips4=SAEUtils.createAccountContact('MURPHY','Jr','RUDZEK','1234567890','1234567890','15432123','','','',false,false,false,'mnf',false,'joial','Param','');
         System.assertNotEquals(null, ips4.Id);
         */
        // US2631703 - Durga- 08th June 2020
        VCCD_Response__c vcr= new VCCD_Response__c(ani__c = '1234567890',MSID__c = 'test123'); 
        insert vcr;
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();//US2903847
        fd.contactExt = '123';
        fd.contactName = 'cfn cln';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';
        Interaction__c ir1 =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', false, false, false, 'mnf', false,'test', 'tes1','',false,'',fd);
        Interaction__c noproviderTruewithmnf =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', true, false, false, 'mnf', false,'test', 'tes1','',true,vcr.id,fd);
        Interaction__c noproviderTruewithoutmnf =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', true, false, false, 'test', false,'test', 'tes1','',true,vcr.id,fd);
        Interaction__c providerNFTrue =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', false, true, false, 'test', false,'test', 'tes1','',true,vcr.id,fd);
        Interaction__c isOtherSearchTrue =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', false, false, false, 'test', true,'test', 'tes1','',true,vcr.id,fd);
        fd.isGenesys = true;//US2903847
        Map<String,Object> IVRInfoMap = new Map<string,Object>{'QuestionType__c'=>'C1','SubjectDOB__c'=>'19660116'};
        fd.IVRinfo = IVRInfoMap;
        Interaction__c IVRInteraction =SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', false, false, false, 'test', true,'test', 'tes1','',false,'',fd);
        Third_Party__c thirdParty = new Third_Party__c();
        thirdParty.First_Name__c = 'FName';
        thirdParty.LastName__c = 'LName';
        insert thirdParty;
        List<Account> acc=TestDataFactory.CreateBulkPersonAccount();
      	 Interaction__c ips3=SAEUtils.createInteraction('Provider',acc[0],'',thirdParty,'');
        Interaction__c ips4=SAEUtils.createInteraction('Provider',acc[0],'mnf',thirdParty,'');
        SAEUtils.getMockStatus();
         //US2631703 - Durga- 08th June 2020
        /*
        Third_Party__c thirdParty = new Third_Party__c();
        thirdParty.First_Name__c = 'FName';
        thirdParty.LastName__c = 'LName';
        insert thirdParty;
        List<Account> acc=TestDataFactory.CreateBulkPersonAccount();
      	 Interaction__c ips3=SAEUtils.createInteraction('Provider',acc[0],'',thirdParty,'');
        System.assertNotEquals(null, ips3.Id);
        Interaction__c ips5=SAEUtils.createInteraction('Provider',acc[0],'mnf',thirdParty,'');
         System.assertNotEquals(null, ips5.Id);
        */ 
        String str=SAEUtils.getStaticResponse('getStaticResponseMock');
        System.assertNotEquals(null,str);
        //13 FEB 2020
        System.assertNotEquals(null, SAEUtils.getAgeFromBirthDate('1990-01-01'));           
        Interaction__c inte = TestDataFactory.createInteraction();   
        System.assertNotEquals(null, inte.Id);       
        System.assertNotEquals(null,  SAEUtils.queryInteraction(inte.Id));
		      
        Test.stopTest();
    }
    
    @isTest
    public static void testUrlMethods1(){
        Tool_Tip__c toolTip = new Tool_Tip__c();
        toolTip.Value__c = 'Test';
        toolTip.Tool_Tip_Type__c = 'Delegated';
        insert toolTip;
        SAEUtils.getSopLink();
        SAEUtils.getToolTip('Test',true);
    }

    @isTest
    public static void testUrlMethods2(){
        Tool_Tip__c toolTip = new Tool_Tip__c();
        toolTip.Value__c = 'Test1';
        toolTip.Tool_Tip_Type__c = 'Delegated';
        insert toolTip;
        SAEUtils.getSopLink();
        SAEUtils.getToolTip('Test1',false);
    }

}