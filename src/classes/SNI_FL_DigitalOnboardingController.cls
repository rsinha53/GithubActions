global without sharing class SNI_FL_DigitalOnboardingController {
    
    /* Onclick of verifyscreen/OTP confirmation creating community user along with landing on Member Dashboard */
    @AuraEnabled
    public static String registerUser(String startTime,String OTPcode,String email,String mobilePhone,Boolean smsNotifications,String dob,String userName,String password,String firstName,String lastName, String personAcctId) {
        system.debug('personAcctId--'+personAcctId);
        Datetime startTimes = Datetime.valueOf(startTime);
        Datetime endTime = system.now();//End time
        string returnValue = '';
        Integer intDays =  startTimes.Date().daysBetween(endTime.Date());
        datetime sameDayEndtime = startTimes.addDays(intDays);
        decimal diffMinutes = ((endTime.getTime())/1000/60) - ((sameDayEndtime.getTime())/1000/60);
        if(diffMinutes <= 15){
            if(personAcctId != null && personAcctId != ''){
                Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
                String userId;
                String nickname = ((firstName != null && firstName.length() > 0) ? firstName:'') + lastName;
                nickname += String.valueOf(Datetime.now()).replace('-','').replace(' ','').replace(':','');
                User usr = new User();
                usr.Username = email;
                usr.Email = email;
                usr.MobilePhone = mobilePhone;
                usr.FirstName = firstName;
                usr.LastName = lastName;
                usr.CommunityNickname = nickname;
                usr.TimeZoneSidKey = 'America/Mexico_City';
                usr.Digital_Onboarding__c = true;
                system.debug('usr---'+usr);
                userId = Site.createExternalUser(usr, personAcctId, password);
                system.debug('userId---'+userId);
                if (userId != null || test.isRunningTest()) { 
                    callEHUBUpdateAPI(personAcctId);
                    if(mobilePhone != null && mobilePhone != '' && smsNotifications){
                        set<Id>  listOfUserIds = new set<Id>();
                        listOfUserIds.add(userId);
                        SNI_FL_WelcomeMsg_Notification.sendSMSNotifications(listOfUserIds);
                    }
                    ApexPages.PageReference lgn = Site.login(userName, password, '/');
                    aura.redirect(lgn);
                    returnValue = 'Successful';
            }
            else {
                    returnValue = 'Failed';
                System.debug('else');
                }
            } else {
                returnValue = 'Failed'; 
            }
        }
        else {
            returnValue = 'Expired';
        }
        return returnValue;
    }
    /* Verify screen Onclick of Verify button OTP generation */
    @AuraEnabled
    public static wrapperOTP verificationCodeGeneration(String phoneNumber,String emailId,String emailCheckBox,String smsCheckBox){
        wrapperOTP wc = new wrapperOTP();
        /* 6 digit OTP generation */
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 6);
        wc.randomNumber = randomNumber;
        system.debug('otp is::' +randomNumber);
        /* 15 mins expiry check*/
        Datetime startTime = system.now();// Start time
        wc.startTime = string.valueof(startTime);
        String subject = 'Care Advisor Connect: Verification Code';
        string label = 'notification_center_verification';
        SNI_FL_Notification_Center sendNotification = New SNI_FL_Notification_Center();
        if(smsCheckBox =='true'){
        //send Your Verification code SMS when smsCheckBoxBoxbox and emailCheckBoxbox is checked or only smsCheckBoxBoxbox is checked
        sendNotification.sendEmailorSMSNotification('','','',smsCheckBox,phoneNumber,randomNumber,'notification_center_verification');
        }
        if(emailCheckBox =='true' && smsCheckBox =='false'){
        //send Your Verification code SMS when smsCheckBoxBoxbox and emailCheckBoxbox is checked or only smsCheckBoxBoxbox is checked
        sendNotification.sendEmailorSMSNotification(emailId,subject,emailCheckBox,'','',randomNumber,'notification_center_verification');
        }
        return wc;
    }
    /* Onclick of Check Eligibility  */
    @AuraEnabled 
    public static String verifyUser(String firstName,String lastName,String dob,String memberId,String policyId) {
    String searchparameter = 'MemberIDDateOfBirth';
    String response;
        Date newDOB = Date.valueOf(dob);
        String accountId;
        String eligibilityStatus;
        try {
            ACETSNILinkMemberSearch.SearchResultWrapper srWrapper = new ACETSNILinkMemberSearch.SearchResultWrapper();
        	srWrapper = CDB_ACETWebservice.getCDBData(memberId,dob, firstName, lastName,'', '', '');
            if (srWrapper.statusCode == 200) {
                if(String.isBlank(srWrapper.houseHoldResultWrapper.memberDetails.accountId)){
                            return 'Error';
                        } else {
                            list<string> objectids = new list<string>();
                            objectids = srWrapper.houseHoldResultWrapper.memberDetails.accountId.split('@');
                            Set<Id> newObjectId = new Set<Id>();
                            Set<Id> newContactId = new Set<Id>();
                            Set<Id> newAccountId = new Set<Id>();
                            for (String ab : objectids) {
                                if (ab.startsWith('00')) {
                                    if (ab.startsWith('003')){
                                        newContactId.add(ab);
                                    }
                                    if (ab.startsWith('001')){
                                        newAccountId.add (ab);
                                    }
                                    newObjectId.add(ab);
                                }
                            }
                            
                            String famAccId = null;
                            for (string Ids : newObjectId) {
                                famAccId = Ids;
                                break;
                            }
                            if(newObjectId.size()>0){
                                Id secondId;
                                if(newAccountId.size()>0){
                                    Map<Id, Account> contactIds = new Map<Id, Account>([select personcontactId, firstName, LastName,personcontact.BirthDate  from account where Id IN:newAccountId and RecordType.Name != 'Family']);
                                    for (Id a: contactIds.keySet()) {
                                     
                                        if (contactIds.get(a).FirstName != null && contactIds.get(a).LastName != null && contactIds.get(a).personcontact.BirthDate != null && contactIds.get(a).FirstName == firstName && contactIds.get(a).LastName == lastName && contactIds.get(a).personcontact.BirthDate == newDOB) {
                                            secondId = a;
                                        }
                                    }
                                   
                                }
                                if(newContactId.size()>0){
                                    Map<Id, Account> paccountId = new Map<Id, Account>([select Id, firstName, LastName,personcontact.BirthDate from account where personcontactId IN:newContactId and RecordType.Name != 'Family']);
                                    for (Id a: paccountId.keySet()) {
                                       
                                        if (paccountId.get(a).FirstName != null && paccountId.get(a).LastName != null && paccountId.get(a).personcontact.BirthDate != null && paccountId.get(a).FirstName == firstName && paccountId.get(a).LastName == lastName && paccountId.get(a).personcontact.BirthDate == newDOB) {
                                            secondId = a;
                                        }
                                    }
                                   
                                   
                                }
                                return accountValidation(famAccId,secondId,memberId, policyId, firstName, lastName, newDOB);
                                
                            }else{
                                return accountValidation(famAccId,null,memberId, policyId, firstName, lastName, newDOB);  
                            }
                        }
            } else {
                return 'Error';
            }
        /*ACETSNILinkMemberSearch.SearchResultWrapper srw = ACETSNILinkMemberSearch.findSNIDetails(memberId, policyId, firstName, lastName, dob);
        if(srw != null){
            eligibilityStatus = srw.SNIresultWrapper.sniEligibility;
            if(eligibilityStatus == 'eligible' || eligibilityStatus == 'engaged'){
                String advisorFullName = srw.SNIresultWrapper.advisorFullName;
                String assignedTo = srw.SNIresultWrapper.assignedTo;
                String lob = srw.SNIresultWrapper.lob;
                String productTypes = srw.SNIresultWrapper.productTypes;
                String serviceGroup = srw.SNIresultWrapper.serviceGroup;
                try{
                    ACETSNILinkMemberSearch.SearchResultWrapper transactionWrapper = ACETSNILinkMemberSearch.findMembers(memberId, dob, firstName, lastName, policyId, searchparameter);
                    if(transactionWrapper.resultWrapper.CoverageLines.size() == 1){
                        String transactionId = transactionWrapper.resultWrapper.Coveragelines[0].transactionId;
                        String groupNumber = transactionWrapper.resultWrapper.CoverageLines[0].GroupNumber;
                        String returnedPolicyId;
                        ACETSNILinkMemberSearch.SearchResultWrapper hhDataResult = ACETSNILinkMemberSearch.getHouseholdData(transactionId);
                        //This policy logic was taken from the ACETLinkMemberCardHelper.js
                        //because getSaveHouseHoldData required a policyid and policyOriginalId
                        ACETHouseHoldWrapper.HouseHold[] myHouseHold = hhDataResult.houseHoldResultWrapper.householdlist;
                        //getSaveHouseHoldData needs the dob in the original MM/DD/YYYY format
                        for(Integer i=0; i< myHouseHold.size();i++){
                            if(myHouseHold[i].isMainMember == true) {
                                returnedPolicyId = myHouseHold[i].policyId;
                            }
                        }
                        String formattedPolicyId;
                        if (returnedPolicyId.length() < 9) {
                            formattedPolicyId = ('0000000000' + returnedPolicyId).right(9);
                        }
                        else{
                            formattedPolicyId = returnedPolicyId;
                        }
                        Date newDOB = Date.valueOf(dob);
                        //String dobFormat = newDOB.format();
                        String dobFormat = ACETUtility.format(newDOB); // Vishal : ICU Date Format Change
                        ACETHouseHoldWrapper.memberDetails sniSaveHouseholdData = ACETSNISaveHouseholdData.getSNISaveHouseholdData(myHouseHold,dobFormat,null,memberId,advisorFullName,eligibilityStatus,formattedPolicyId,returnedPolicyId,assignedTo, lob, productTypes, serviceGroup, groupNumber);
                        if(String.isBlank(sniSaveHouseholdData.accountId)){
                            return 'Error';
                        } else {
                            list<string> objectids = new list<string>();
                            objectids = sniSaveHouseholdData.accountId.split('@');
                            if(objectids.size()>2){
                                return accountValidation(objectids[1],objectids[2],memberId, policyId, firstName, lastName, newDOB);
                            }else{
                                return accountValidation(objectids[1],null,memberId, policyId, firstName, lastName, newDOB);  
                            }
                        }
                    } else {
                        return 'Error';
                    }
                    
                } catch (Exception e){
                    return 'Error';
                }
            } else {
                return 'Error';
            }
        } else {
            return 'Error';
}*/ }
        catch(Exception e){
            return 'Error';
        }
    }
    public class wrapperOTP{
        @AuraEnabled
        public String randomNumber{get;set;}
        @AuraEnabled
        public String startTime{get;set;}
    }
    @AuraEnabled
    public static String accountValidation(string firstId, string secondId,String memberId,String policyId,String firstName,String lastName,Date dob){
        Boolean isMultiPolicy = False;
        Boolean isUserPresent = False;
        Id contactId;
        Id paccountId;
        if(secondId == null){
            if(firstId != null){
                list<AccountcontactRelation> acrList = [select Id, accountId, contact.account.Id,contactId,contact.account.FirstName,contact.account.LastName,contact.account.PersonBirthdate,policy_ID__c, member_ID__c
                                                        from accountcontactrelation where accountId = :firstId and contact.account.PersonBirthdate=:dob];
                //system.debug('acrList--'+acrList);
                for(AccountcontactRelation acr1 :acrList){
                    if(acr1.contact.account.FirstName+'' == firstName && acr1.contact.account.LastName+'' == lastName){
                        contactId = acr1.contactId;
                        paccountId = acr1.contact.account.Id;
                    }
                }
            }else{return 'Error';}
        }else{
            Id objectId = Id.valueof(secondId);
            if((objectId.getSobjectType()+'') == 'Account'){
                contactId = [select personcontactId from account where Id =:objectId].personcontactId;
                paccountId = objectId;
                //system.debug('contactId--'+contactId);
            }
            if((objectId.getSobjectType()+'') == 'Contact'){
                paccountId = [select Id from account where personcontactId =:objectId].Id;
                contactId = objectId;
                //system.debug('paccountId--'+paccountId);
            }
        }
        if(contactId != null){
            list<AccountcontactRelation> acr = [select Id, accountId, contactId, policy_ID__c, member_ID__c
                                                from accountcontactrelation where contactId = :contactId ];
            if(acr.size()>1){
                isMultiPolicy = True;
            }
        }
        if(!isMultiPolicy){
            list<user> usr = [select Id from user where contactId = :contactId AND isActive = true];
            if(usr.size()>0){
                isUserPresent = True;
            }
        }
        if(!isMultiPolicy && !isUserPresent && firstId != null){
            list<family_overview__c> fo = [select Id, First_Family_Contact_Into_Center__c from family_overview__C where account__c =:firstId];
            if(fo.size()>0){
                if(fo[0].First_Family_Contact_Into_Center__c==''||fo[0].First_Family_Contact_Into_Center__c==null){
                    fo[0].First_Family_Contact_Into_Center__c = 'Digital Onboard';
                    update fo[0];
                }
            }
        }
        if(!isMultiPolicy && !isUserPresent && contactId != null){
            return paccountId;
        }else{
            if(isUserPresent){
                return 'Error-UserPresent';
            }
            else{
                return 'Error';
            }
        }
    }     
   
    /*- Check If Active User with Email is in System -*/
    @AuraEnabled
    public static Boolean emailInUse(String emailAddress){
        try {
            User existingUser = [SELECT Id FROM User WHERE Email =: emailAddress AND isActive = true  AND USERTYPE = 'PowerCustomerSuccess' LIMIT 1];
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    @AuraEnabled
    public static string setNotificationPreferences(boolean emailcheck, boolean phcheck, String personAccountId){
        if(!String.isBlank(personAccountId)){
            Account updateAccount = new Account();
            updateAccount.Id = personAccountId;
            updateAccount.SNI_FL_Terms_of_use__pc = true;
            updateAccount.Email_Notification__c = emailcheck;
            updateAccount.Text_Message_SMS_Notification__c = phcheck;
            try{
                update updateAccount;
                return 'success';
            } catch (Exception e){
                return 'error';
            }
            
        }
        return 'error';
    }
    @AuraEnabled
    public static String getOrgName(){
        String returnString = 'false';
        String orgName = ACETUtility.GetOrgName();
        if(orgName != 'prd'){
            Digital_Onboarding_SMS_Verification__c vCode = Digital_Onboarding_SMS_Verification__c.getOrgDefaults();
            if(vCode.Code__c != null){
                returnString = vCode.Code__c;
            }
        }
        return returnString;
    }
    @AuraEnabled
    public static void callEHUBUpdateAPI(string personAccount)
    { 
        boolean isUserNameFound = False;
        integer i = 0;
        list<account> accList = new list<account>();
        list<AccountcontactRelation> acr = [select Id, accountId,account.Assigned_Advisor__c, contactId, policy_ID__c, member_ID__c
                                                from accountcontactrelation where contact.AccountId = :personAccount];
        system.debug('acr--'+acr);
        if(acr.size()==1 && acr[0].account.Assigned_Advisor__c == 'Unassigned'){
            list<family_Overview__c> fo = [select Id, Designation__c,First_Family_Contact_Into_Center__c from family_Overview__c where Account__c =:acr[0].accountId];
            if(fo.size()>0){
                fo[0].Designation__c = 'Assigned';
				fo[0].Family_Needs__c = 'Low'; 
                if(RecursiveTriggerHandler.HSIDPlguinFlg)
                fo[0].First_Family_Contact_Into_Center__c = 'Digital Onboard'; 
                update fo[0];
                system.debug('fo--'+fo);
                list<DigitalOnboardingAdvisorAssignment__c> doa = [select Id, Name__c, Name from DigitalOnboardingAdvisorAssignment__c order by Name asc];
                Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
                if(doa.size()>1){
                    if(roundRobin!=null && roundRobin.Last_Assigned_Advisor__c!=''&& roundRobin.Last_Assigned_Advisor__c!=null){
                        for(DigitalOnboardingAdvisorAssignment__c doa1:doa){
                            i+=1;
                            if(isUserNameFound){
                                roundRobin.Last_Assigned_Advisor__c = doa1.Name;
                                Account acc = new Account(Id = acr[0].accountId, OwnerId=doa1.Name__c, Special_Needs_Status__c='Engaged',EHub_Update_Check__c=True);
                                accList.add(acc);
                                break;
                            }
                            if(doa1.name == roundRobin.Last_Assigned_Advisor__c){
                                isUserNameFound = True;
                                if(doa.size()==i){
                                    roundRobin.Last_Assigned_Advisor__c = doa[0].Name;
                                    Account acc = new Account(Id = acr[0].accountId, OwnerId=doa[0].Name__c, Special_Needs_Status__c='Engaged',EHub_Update_Check__c=True);
                                    accList.add(acc);
                                    break;
                                }
                            }
                        }
                    }else{
                        roundRobin.Last_Assigned_Advisor__c = doa[0].Name;
                        Account acc = new Account(Id = acr[0].accountId, OwnerId=doa[0].Name__c, Special_Needs_Status__c='Engaged',EHub_Update_Check__c=True);
                        accList.add(acc);
                    }
                }else{
                    if(doa.size()==1){
                        roundRobin.Last_Assigned_Advisor__c = doa[0].Name;
                        Account acc = new Account(Id = acr[0].accountId, OwnerId=doa[0].Name__c, Special_Needs_Status__c='Engaged',EHub_Update_Check__c=True);
                        accList.add(acc);
                    }
                }
                system.debug('accList--'+accList);
                if(accList.size()>0){
                    Upsert roundRobin;
                    update accList;
                    futureUpdateCallout(accList[0].Id);
                    // Bell Notification to New Advsior:
                    Account updatedAccList = [SELECT Id, Name, OwnerId, Member_Id__c, Policy_Id__c FROM Account WHERE Id =: accList[0].Id LIMIT 1];
                    Account newPersonAccount = [SELECT Id, Name, PersonBirthdate FROM Account WHERE Id =: personAccount LIMIT 1];
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    //You have a newly assigned and registered member on Care Advisor Connect through Digital Onboarding. Member Policy [xxx], Member ID [xxx], Member DOB [xxx]
                    notification.setBody('You have a newly assigned and registered member on Care Advisor Connect through Digital Onboarding. Member Policy ' + updatedAccList.Policy_Id__c + ', Member ID ' + updatedAccList.Member_ID__c + ', Member DOB ' + ACETUtility.format(newPersonAccount.PersonBirthdate)); // Vishal : ICU Date Format Change       
                    notification.setTitle('New Assignment');
                    notification.setSenderId(Userinfo.getUserId());
                    CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'SNI_FL_AdvisorAssigned'];
                    notification.setNotificationTypeId(type.id);
                    notification.setTargetId(newPersonAccount.Id); // target object id
                    notification.send(new Set<String> { String.valueOf(updatedAccList.OwnerId) });
                }
            }
        }
    }
    @future(callout=true)
    public static void futureUpdateCallout(Id accountId){
        ACETEligibilityUpdController.updateEHub(accountId,'Account');
    }
}