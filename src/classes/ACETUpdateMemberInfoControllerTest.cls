@isTest
private class ACETUpdateMemberInfoControllerTest{

  static testMethod void updateMemberTestMethodSave()
  {
    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];

        boolean check = true;
           Map<String, String> mapISLWSConfigs = new Map<String, String>();
            mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
            mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
            mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
            mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
            mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
            mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
            mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
            mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
            mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
            mapISLWSConfigs.put('d1_UpdateIndividualMemberEndpoint', '/api/alpha/eisl/individuals/membership/v1.0/update');
            mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
            mapISLWSConfigs.put('ISLStageTimeout', '3000');

        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);

        insert lstISLWSConfigs;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.UpdateIndividualJSON());
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETUpdateMemberInfoController acetUM = new ACETUpdateMemberInfoController();

                ACETUpdateIndividualWebService updIndividual = new ACETUpdateIndividualWebService();
                ACETWSCalloutResult callOutResult;
                callOutResult = updIndividual.updateMembers('41310808400','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'test','','','','','','','');

                  callOutResult = updIndividual.updateMembers('48092711900','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'test','','','','','','','');

                  callOutResult = updIndividual.updateMembers('48092711922','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'test','','','','','','','');

        String str1 = '[{"id": "' + 'PhoneNumber'+ '"}]' ;
        Interaction__c interaction =  TestDataFactory.createInteraction();
        string email2='test111@test.com';
        string phone='9090909090';
        integer phonenumber = 1234512345;
        string PrimaryIndicator='yes';

        String myJSON = JSON.serialize(acetUM);

       //Make a callout using email only
        ACETUpdateIndividualWebService updIndividual2 = new ACETUpdateIndividualWebService();
        ACETWSCalloutResult callOutResult2;
        callOutResult2 = updIndividual2.updateMembers('41310808400','' ,'2268479', 'Smyth','Christine','', '','','F','1964-10-14','18', 'Y', 'test111@test.com','12', null,'test','','','','','','','');

     // callOutResult = updIndividual.updateMembers('48092711900','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'test','','','','','');

     // callOutResult = updIndividual.updateMembers('48092711922','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'test','','','','','');

        ApexPages.currentPage().getParameters().put('InteractionId',interaction.id);
        ApexPages.currentPage().getParameters().put('ContactId',contactRec.id);
        ApexPages.currentPage().getParameters().put('Id','0058999712107');
        ApexPages.currentPage().getParameters().put('SRK','test');
        ApexPages.currentPage().getParameters().put('email',email2);
        ApexPages.currentPage().getParameters().put('phn',myJSON );




        ACETUpdateMemberInfoController.emailWrapper emwrap=new ACETUpdateMemberInfoController.emailWrapper(email2);
        emwrap.email='test2222@test.com';
        emwrap.emailTypeStr='test';
        emwrap.selected=true;
        list<ACETUpdateMemberInfoController.emailWrapper > emailWrprList = new list<ACETUpdateMemberInfoController.emailWrapper >();
        emailWrprList.add(emwrap);

       List<ACETMemberDetail.phone> amdlist=new List<ACETMemberDetail.phone>();


         ACETMemberDetail.Phone  amd = new ACETMemberDetail.Phone();
         amd.PhoneNumber='9090909090';
         amd.PhoneNumberType='Home';
         amd.primaryIndicator='Yes';
         amdlist.add(amd);
         ACETMemberDetail.Phone  amd1 = new ACETMemberDetail.Phone();
         amd1.PhoneNumber='9090909090';
         amd1.PhoneNumberType='Work';
         amd1.primaryIndicator='No';

         ACETMemberDetail.Phone  amd2 = new ACETMemberDetail.Phone();
         amd2.PhoneNumber='9090909090';
         amd2.PhoneNumberType='Mobile';
         amd2.primaryIndicator='No';

         ACETMemberDetail.Phone  amd3 = new ACETMemberDetail.Phone();
         amd3.PhoneNumber='9090909090';
         amd3.PhoneNumberType='';
         amd3.primaryIndicator='Yes';

         ACETUpdateMemberInfoController.PhoneWrapper phwrap=new ACETUpdateMemberInfoController.PhoneWrapper(amd,true,true);
         ACETUpdateMemberInfoController.PhoneWrapper phwrap1=new ACETUpdateMemberInfoController.PhoneWrapper(amd1,true,true);
         ACETUpdateMemberInfoController.PhoneWrapper phwrap2=new ACETUpdateMemberInfoController.PhoneWrapper(amd2,true,true);
         ACETUpdateMemberInfoController.PhoneWrapper phwrap3=new ACETUpdateMemberInfoController.PhoneWrapper(amd3,true,true);

         phwrap.makeReadOnly=true;
         phwrap.makePrimaryIndiReadOnly=true;
         phwrap.PhoneNumberType='Work';

         list<ACETUpdateMemberInfoController.PhoneWrapper> phoneWrprList1 = new list<ACETUpdateMemberInfoController.PhoneWrapper>();
         phoneWrprList1.add(phwrap);
         phoneWrprList1.add(phwrap1);
         phoneWrprList1.add(phwrap2);
         phoneWrprList1.add(phwrap3);

        phwrap.getPrimaryIndicator();

        phwrap.getPhoneNumberTypeOption();

         phwrap.selectedValueMap=new map<Integer,String>();
         phwrap.selectedValueMap.put(0,'Home');
         phwrap.selectedValueMap.put(1,'Work');
         phwrap.selectedValueMap.put(2,'Fax');
         phwrap.selectedValueMap.put(3,'Mobile');
         phwrap.getPhoneNumberTypeOption();

         acetUM.phoneWrprList=new list<ACETUpdateMemberInfoController.PhoneWrapper>();
         acetUM.phoneWrprList.addall(phoneWrprList1);
        //acetUM.phoneWrprList=phoneWrprList1;

    acetUM.email=email2;
    acetUM.emailWrpr=emailWrprList;
    acetUM.subject= contactRec;
    acetUM.phonenumber  = phonenumber ;
//   acetUM.calloutresult.success = true;




        //Populating General Information into Member detail
        ACETMemberDetail md = new ACETMemberDetail();
        md.MemberID = '7293281';
        md.FirstName = 'Connie';
        md.LastName = 'Grimm';
        md.MiddleInitial = 'A';
        md.DOB  = '01/01/1960';
        md.Gender  = 'Female';
        md.SSN = '123-45-6789';
        md.Email = 'test@gmail.com';


         ACETMemberDetail md1 = new ACETMemberDetail();
        md1.MemberID = '7293280';
        md1.FirstName = 'Connie';
        md1.LastName = 'Grimm';
        md1.MiddleInitial = 'A';
        md1.DOB  = '01/01/1960';
        md1.Gender  = 'Female';
        md1.SSN = '123-45-6789';
        md1.Email = 'test@gmail.com';



        //Populating address Information into Member detail
        ACETMemberDetail.Address singleAddr = new ACETMemberDetail.Address();
        List<ACETMemberDetail.Address> mulitpleAddr = new List<ACETMemberDetail.Address>();
        singleAddr.addressLine1 = 'test street 1';
        singleAddr.addressLine2 = 'test street 2';
        singleAddr.city = 'test city';
        singleAddr.state = 'MN';
        singleAddr.zip = '012345';
        singleAddr.addressType = 'Permanent';
        mulitpleAddr.add(singleAddr);

        md.Addresses =  mulitpleAddr;

   /*     ACETUpdateMemberInfoController.emailWrapper adWrp= new ACETUpdateMemberInfoController.emailWrapper();
        List<ACETUpdateMemberInfoController.emailWrapper> mulitpleAdWrp = new List<ACETUpdateMemberInfoController.emailWrapper>();

        adWrp.address = singleAddr;
        adWrp.selected = true;
        mulitpleAdWrp.add(adWrp);

        acetUM.addrsWrpr = mulitpleAdWrp; */

        //Populating Phone Information into Member detail
        ACETMemberDetail.Phone singlePhone = new ACETMemberDetail.Phone();
        List<ACETMemberDetail.Phone > mulitplePhone = new List<ACETMemberDetail.Phone>();

        singlePhone.PhoneNumber = '999-888-7777';
        singlePhone.PhoneNumberType = 'Primary';
        singlePhone.PrimaryIndicator= 'Primary';
        mulitplePhone.add(singlePhone);

        md.Phones = mulitplePhone;

        acetUM.MemberDetail = md;

        Test.startTest();


        acetUM.updateMember();

        ACETMemberDetail.Phone  amd4 = new ACETMemberDetail.Phone();
         amd4.PhoneNumber='PrimaryIndicator';
         amd4.PhoneNumberType='PrimaryIndicator';
         amd4.primaryIndicator='PrimaryIndicator';


        List<ACETUpdateMemberInfoController.addInfoWrapper> addinfowraplst =  new List<ACETUpdateMemberInfoController.addInfoWrapper>();
        ACETUpdateMemberInfoController.PhoneWrapper phwrap12  = new ACETUpdateMemberInfoController.PhoneWrapper(amd4,true,true);
        ACETUpdateMemberInfoController.addInfoWrapper addinfowrap  = new ACETUpdateMemberInfoController.addInfoWrapper();
        addinfowrap.updateTypeStr ='test';
        addinfowrap.selected = false;
        addinfowrap.getUpdateType();
        addinfowraplst.add(addinfowrap);

        list<ACETUpdateMemberInfoController.PhoneWrapper> phoneWrprList12 = new list<ACETUpdateMemberInfoController.PhoneWrapper>();
        phoneWrprList12.add(phwrap12);
        acetUM.phoneWrprList=phoneWrprList1;
          string phn ='PrimaryIndicator';
        acetUM.notResearchUser = true;
        String hpAdditionInfoStr = 'test';
        acetUM.isPhoneChecked = true;
        boolean isEmailChecked = true;
        acetUM.rowToRemove= 0;
        acetUM.removeInfoRow= 0;
        acetUM.isClickedLaunchCirrus= false;
        acetUM.MemberAddress= 'test';

        acetUM.memberData();
        if(acetUM.phoneWrprList!=null && acetUM.phoneWrprList.size()==0)
           acetUM.phoneWrprList.addall(phoneWrprList1);
        acetUM.addPhRow();
        acetUM.getPhoneNumberType();
        acetUM.getEmailType();
        acetUm.addEmailRow();
        acetUm.addInfoRow();
        acetUm.getAdditionalUpdates();
        acetUm.removePhoneRow();
        acetUm.removeAddInfoRow();

 //     acetUm.addInfoWrapper();
        updIndividual.formatDate('10/10/2011');
        ACETUpdIndividualMemResJSON2Apex json2Apex = new ACETUpdIndividualMemResJSON2Apex();
        ACETUpdIndividualMemResJSON2Apex.cls_UpdateIndividualMembershipResponse indiTest = new ACETUpdIndividualMemResJSON2Apex.cls_UpdateIndividualMembershipResponse();

        ACETUpdIndividualMemResJSON2Apex.cls_response clsRes = new ACETUpdIndividualMemResJSON2Apex.cls_response();
        indiTest.response = clsRes;
        clsRes.responseCode = '200';
        clsRes.responseDesc = 'test';



        /*ACETUpdateMemberInfoController.PhoneWrapper phnWrp = new ACETUpdateMemberInfoController.PhoneWrapper(singlePhone);
        List<ACETUpdateMemberInfoController.PhoneWrapper> mulitplePhnWrp  = new List<ACETUpdateMemberInfoController.PhoneWrapper>();

        phnWrp.Phone = singlePhone;
        phnWrp.selected = true;
        mulitplePhnWrp.add(phnWrp);

        acetUM.phoneWrpr = mulitplePhnWrp;

        acetUM.MemberDetail = md;
        acetUM.checkedFirstName = true;
        acetUM.checkedLastName = true;
        acetUM.checkedMiddleInitial = true;
        acetUM.checkedDOB = true;
        acetUM.checkedGender  = true;
        acetUM.checkedSSN = true;
        acetUM.checkedEmail = true;
        acetUM.isSubscriber = true;
        acetUM.checkedEffectiveDate = true;
        acetUM.checkedDateofHire = true;
        acetUM.checkedTermination = true;
        acetUM.checkedDateOfMarriage = true;
        acetUM.checkedPlan = true;
        acetUM.checkedFax = true;

        acetUM.updateMember();
        acetUM.memberData();
        acetUM.getPhoneNumberType();
        acetUM.getEmailType();
        acetUM.getStateOptions();
        acetUM.addPhRow();
        acetUM.addEmailRow();

        acetUM.isClickedUpdate = true;
        acetUM.isSuccess = true;
        acetUM.notResearchUser = true;
        acetUM.MemberID= '7293281';
      */
    Test.stopTest();
  }
  public static ACETUpdIndividualMemResJSON2Apex parse(String json){
        return (ACETUpdIndividualMemResJSON2Apex) System.JSON.deserialize(json, ACETUpdIndividualMemResJSON2Apex.class);
    }
    static testMethod void testParse() {
        ACETUpdIndividualMemResJSON2Apex test = new ACETUpdIndividualMemResJSON2Apex();
        String json=        '{"UpdateIndividualMembershipResponse": {'+
        '       "response": {'+
        '           "responseCode": "422",'+
        '           "responseDesc": " STS0003-Member [1] - Record(s) updated. ERR2209-Member Provider Assignment: Member Provider ID: 0: Date range overlaps with existing record(s) of the same Provider Assignment Type. ERR422-Unable to process request"'+
        '       }'+
        '   }'+
        ' }';
        ACETUpdIndividualMemResJSON2Apex obj = parse(json);
        System.assert(obj != null);
    }




}