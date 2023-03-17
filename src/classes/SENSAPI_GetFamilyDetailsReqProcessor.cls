/*------------------------------------------------------------
Author:        Pratikshya Satapathy
Description:   Request processor class for the service request "Get Family And Member Details"   

Test Class:   League_GetFamilyDetailsReqProcTest
History
Date            Author              Comments
-------------------------------------------------------------
08-08-2022      Pratikshya Satapathy        Created
09-29-2022      Tushar Kaore                Modified
7 NOV 2022      Manmeet Kaur                Modified
------------------------------------------------------------*/
public without sharing class SENSAPI_GetFamilyDetailsReqProcessor implements IRestRequestProcessor{
    
    public SENSAPI_GetFamilyDetailsRequest request;
    SENSAPI_GetFamilyDetailsResponse responseDetails;  
    
    private List<Account> familyMembers; 
    private Account familyAccount; 
    private List<Account> famAccount;
    private Map<Id,AccountContactRelation> relationMap;
    private Map<Id,Account> careTeamAccountsMap;
    private Map<Id,User> accountIdUserMap;
    private Map<Id,Id> userIdAccountIdMap;
    private List<AccountContactRelation> memberInfo;
  private List<User> fetchMemUsers;
    private String email;
  public static User comUser; 
  /*caTool - if this boolean is true that 
   * means request has come from Care Advsior*/
    private static boolean caTool; 
    private static Id registeredUserId;
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        
        responseDetails = new SENSAPI_GetFamilyDetailsResponse();
        try{   
            Boolean userExists = false;
            relationMap = new Map<Id,AccountContactRelation>();
            careTeamAccountsMap = new Map<Id,Account>();
            accountIdUserMap = new Map<Id,User>();
            userIdAccountIdMap = new Map<Id,Id>();
            memberInfo = new List<AccountContactRelation>();
            Set<Id> accountIdSet = new Set<Id>();
            String result;
            initProcessor(requestStructure);
            if(validateRequest(request.subscriberId,request.dateofbirth,request.email,request.origin)){
                Id accountId;
                String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                Date dob = request.dateofbirth;
                email = request.email;
                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                Pattern MyPattern = Pattern.compile(emailRegex);
                if(String.isNotEmpty(email)){
                    Matcher MyMatcher = MyPattern.matcher(email);
                    if (!MyMatcher.matches()) {
                        responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 400, SENSAPI_Constant.EMAIL_ADDRESS_INVALID);
                        RestContext.response.statusCode = responseDetails.status.responseCode;
                        return responseDetails;
                    }
                }
                famAccount = SENSAPI_Utility.getFamilyAccount(subscriberId);
                if(!caTool && famAccount.size()==0){
                    CDB_ACETWebservice.getCDBData(subscriberId,string.valueOf(dob), '', '','', '', '');
                    //query the data again to fetch newly created family from CDB
                    famAccount = SENSAPI_Utility.getFamilyAccount(subscriberId);
                }
                //fetch the family account details
                if(famAccount.size() > 0){
                    responseDetails.FamilyAccount = new SENSAPI_GetFamilyDetailsResponse.FamilyAccount();
                    familyAccount = famAccount[0];
                    for(SNI_FL_Care_Team_Member__c careTeam : familyAccount.SNI_FL_CareTeam_Members__r){
                        Account careTeamAccount = careTeam.SNI_FL_Member__r;
                        careTeamAccountsMap.put(careTeamAccount.Id, careTeamAccount); 
                    }
                    
                    for(AccountContactRelation accr : familyAccount.AccountContactRelations){
                        relationMap.put(accr.Contact.AccountId,accr);
                        accountIdSet.add(accr.Contact.AccountId);
                        if(accr.contact.birthdate == dob){
                            memberInfo.add(accr);
                            accountId = accr.Contact.AccountId;
                        }
                    }
                    familyMembers = SENSAPI_Utility.getMemberAccounts(relationMap.keyset()); 
                    for(Account memAccount : familyMembers){
                        careTeamAccountsMap.put(memAccount.Id, memAccount); 
                    }                                       
                    fetchMemUsers = SENSAPI_Utility.getUsersByAccountIds(accountIdSet);
                    for(User usr: fetchMemUsers){
                        if(usr.accountId == accountId){
                            userExists = true;
                        }
                    }
                    
                    if(!caTool){
                        if(memberInfo.size()==0){
                            responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 400, 'No member record with given DOB');
                            responseDetails.familyAccount = null;
                        }
                        else if(memberInfo.size()==1 && !userExists){
                            result = createCommunityUser(memberInfo[0],email);
                            if(result == 'SUCCESS'){
                                familyAccount = SENSAPI_Utility.getFamilyAccount(subscriberId)[0];
                                fetchMemberUsers();
                                populateDetails();
                                responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(true, 200);
                            }else{
                                responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 500, result);
                                responseDetails.familyAccount = null;
                            }
                        }else if(userExists){
                            fetchMemberUsers();
                            populateDetails();
                            responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(true, 200);
                        }
                    }else{
                        
                        memberInfo.add(new AccountContactRelation());
                        fetchMemberUsers();
                        populateDetails();
                        responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(true, 200);
                    }
                    
                }else{
                    responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 400, SENSAPI_Constant.NO_FAMILY_FOUND);
                }
                
                
            }else{
                responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 400, SENSAPI_Constant.REQUIREDFIELD_MISSING);
            }
            
        }catch(Exception ex) {
            responseDetails.status = new SENSAPI_GetFamilyDetailsResponse.API_Status(false, 500, ex.getMessage() + ex.getStackTraceString());
            responseDetails.familyAccount = null;
        }    
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void populateDetails(){
        populateFamilyDetails();
        populateMemberDetails();
    }
    
    public Map<Id,User> getAccountIdUserMap(){
        return accountIdUserMap;
    }
    
    private void fetchMemberUsers(){
        if( relationMap != null && relationMap?.keySet()?.size() > 0){
            for(User user: fetchMemUsers){
                accountIdUserMap.put(user.AccountId, user);
                userIdAccountIdMap.put(user.Id,user.AccountId); 
            }
        }
        
    }   
    
    private void populateFamilyDetails(){
        
        responseDetails.familyAccount.subscriberId = familyAccount.Member_Id__c;
        responseDetails.familyAccount.sensId = familyAccount.Id;
        responseDetails.familyAccount.alternateId = familyAccount.Alternate_Id__c;
        if(familyAccount.Family_Overview__r != null && familyAccount.Family_Overview__r.size() > 0){
            responseDetails.familyAccount.overviewSensId = familyAccount.Family_Overview__r[0].Id;
        }
        
        SENSAPI_GetFamilyDetailsResponse.CareAdvisorDetails careAdvisor = SENSAPI_Utility.populateCareAdvisor(familyAccount.Owner);
        careAdvisor.status = 'Primary';
        if(familyAccount.Owner.Name != 'Unassigned'){
            responseDetails.familyAccount.careAdvisor = careAdvisor;
        }else{
          responseDetails.familyAccount.careAdvisor = null;  
        }
    }
    
    private void populateMemberDetails(){
        system.debug('care team members:::' + familyAccount.SNI_FL_CareTeam_Members__r);
        if(familyAccount.SNI_FL_CareTeam_Members__r.size()>0){
            for(SNI_FL_Care_Team_Member__c careTeam : familyAccount.SNI_FL_CareTeam_Members__r){
                SENSAPI_GetFamilyDetailsResponse.CareTeam member = new SENSAPI_GetFamilyDetailsResponse.CareTeam();
                AccountContactRelation acr = relationMap.get(careTeam.SNI_FL_Member__c);  
                if(acr != null){
                    member.relationship = acr.Relationship__c;
                }
                
                //adding Member/Care Giver details
                Account memAccount  = careTeam.SNI_FL_Member__r;
                populatePersonAccountDetails(member, memAccount);  
                member.address      = SENSAPI_Utility.populateAddress(memAccount);
                
                //adding details from Care Team record
                populateCareTeamRelatedDetails(member,careTeam); 
                
                //Adding Member ROI Details
                Account familyMemberWithDetails = careTeamAccountsMap.get(memAccount.Id); 
                
                //Adding Member Overview Details 
                if(familyMemberWithDetails != null && familyMemberWithDetails.Members_Information__r != null && familyMemberWithDetails.Members_Information__r.size() > 0){
                    Member_Information__c memberInformation = familyMemberWithDetails.Members_Information__r[0];
                    member.overviewSensId = memberInformation.Id;
                    member.gender = memberInformation.Gender__c; 
                }
                
                //Adding member User Details 
                User memberUser = accountIdUserMap.get(careTeam.SNI_FL_Member__c); 
                if(memberUser != null){
                    member.memberUserSensId = memberUser.Id;
                    member.phone = memberUser.Phone;
                    member.mobile = memberUser.MobilePhone;
                }else if (acr != null && memberInfo[0].Id == acr.Id && registeredUserId!=null){
                    member.memberUserSensId = registeredUserId;
                    member.phone = comuser.Phone;
                    member.mobile = comuser.MobilePhone;
                }
                responseDetails.familyAccount.familyMembers.add(member);
            }
        }else{    
            for(AccountContactRelation acr: familyAccount.AccountContactRelations){
                SENSAPI_GetFamilyDetailsResponse.CareTeam member = new SENSAPI_GetFamilyDetailsResponse.CareTeam();
                Account memAccount = new Account(Id = acr.Contact.AccountId, 
                                                 FirstName = acr.Contact.FirstName!=''?acr.Contact.FirstName:'', 
                                                 MiddleName = acr.Contact.MiddleName!=''?acr.Contact.MiddleName:'',
                                                 LastName = acr.Contact.LastName!=''?acr.Contact.LastName:'',
                                                 PersonBirthdate = acr.Contact.Birthdate!=null?acr.Contact.Birthdate:null,
                                                 PersonEmail = acr.Contact.Account.personEmail!=''?acr.Contact.Account.personEmail:'',
                                                 Preferred_Name__pc = acr.Contact.account.Preferred_Name__pc!=''?acr.Contact.account.Preferred_Name__pc:'',
                                                 Email_Notification__c = acr.Contact.account.Email_Notification__c!=null?acr.Contact.account.Email_Notification__c:false,
                                                 Text_Message_SMS_Notification__c = acr.Contact.account.Text_Message_SMS_Notification__c!=null?acr.Contact.account.Text_Message_SMS_Notification__c:false,
                                                 PersonMailingCity = acr.Contact.account.PersonMailingCity!=''?acr.Contact.account.PersonMailingCity:'',
                                                 PersonMailingPostalCode = acr.Contact.account.PersonMailingPostalCode!=''?acr.Contact.account.PersonMailingPostalCode:'',
                                                 PersonMailingStreet = acr.Contact.account.PersonMailingStreet!=''?acr.Contact.account.PersonMailingStreet:'',
                                                 PersonMailingState = acr.Contact.account.PersonMailingState!=''?acr.Contact.account.PersonMailingState:'',
                                                 PersonMailingCountry = acr.Contact.account.PersonMailingCountry!=''?acr.Contact.account.PersonMailingCountry:'',
                                                 EID__c = acr.Contact.account.EID__c!=''?acr.Contact.account.EID__c:''
                                                );
                populatePersonAccountDetails(member,memAccount);
                member.isPao = memberInfo[0].Id == acr.Id?true:false;
                member.isNonPolicy = false;
                member.status = memberInfo[0].Id == acr.Id?'Registered':'Added';
                member.addedDate = date.today();
                member.invitedDate = memberInfo[0].Id == acr.Id?date.today():null;
                member.registeredDate = memberInfo[0].Id == acr.Id?date.today():null;
                member.removedDate = null; 
                member.relationship = acr.relationship__c;
                member.address = SENSAPI_Utility.populateAddress(memAccount);
                member.email = memberInfo[0].Id == acr.Id?email:member.email;
                Account familyMemberWithDetails = careTeamAccountsMap.get(acr.Contact.AccountId); 
                if(familyMemberWithDetails != null && familyMemberWithDetails.Members_Information__r != null && familyMemberWithDetails.Members_Information__r.size() > 0){
                    Member_Information__c memberInformation = familyMemberWithDetails.Members_Information__r[0];
                    member.overviewSensId = memberInformation.Id;
                    member.gender = memberInformation.Gender__c; 
                }
                
                //Adding member User Details 
                User memberUser = accountIdUserMap.get(acr.Contact.AccountId); 
                if(memberUser != null){
                    member.memberUserSensId = memberUser.Id;
                    member.phone = memberUser.Phone;
                    member.mobile = memberUser.MobilePhone;
                }else if (memberInfo[0].Id == acr.Id && registeredUserId!=null){
                    member.memberUserSensId = registeredUserId;
                    member.phone = comuser.Phone;
                    member.mobile = comuser.MobilePhone;
                }
                responseDetails.familyAccount.familyMembers.add(member);
            }
        }
        
    }
    
    private static void populatePersonAccountDetails(SENSAPI_GetFamilyDetailsResponse.CareTeam member, Account memAccount){
        member.sensId =  memAccount.Id;
        member.firstName    =  memAccount.FirstName;
        member.middleName   =  memAccount.MiddleName;
        member.lastName     =  memAccount.LastName;
        member.dateOfBirth  = memAccount.PersonBirthdate;
        member.email        = memAccount.PersonEmail; 
        member.preferredName    = memAccount.Preferred_Name__pc;  
        member.emailOptIn       = memAccount.Email_Notification__c;  
        member.smsOptIn         = memAccount.Text_Message_SMS_Notification__c;  
        member.enterpriseId         = memAccount.EID__c;
    }
    
    private static void populateCareTeamRelatedDetails(SENSAPI_GetFamilyDetailsResponse.CareTeam member, SNI_FL_Care_Team_Member__c careTeam){
        member.isPao = careTeam.SNI_FL_Primary_Caregiver__c;
        member.isNonPolicy = careTeam.SNI_FL_Non_Policy_Member__c;
        member.status = careTeam.SNI_FL_Status__c;
        member.addedDate = careTeam.SNI_FL_Added_Date__c;
        member.invitedDate = careTeam.SNI_FL_Invited_Date__c;
        member.registeredDate = careTeam.SNI_FL_Registered_Date__c;
        member.removedDate = careTeam.SNI_FL_Removed_Date__c; 
    }
    private static boolean validateRequest(String subscriberId, Date dob, String email, String origin){
        if((string.isBlank(origin) || !origin.equalsIgnoreCase('CATool'))
           && String.isNotBlank(subscriberId) && String.isNotBlank(email) && dob!=null){
            caTool = false;
            return true;
        }else if(string.isNotBlank(origin) && origin.equalsIgnoreCase('CATool') && String.isNotBlank(subscriberId)){
            caTool = true;
            return true;
        }
        return false;
    }
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetFamilyDetailsRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }        
    }
    
    public Static String createCommunityUser(AccountContactRelation accr,String email){
        string msg;
        try{
            Profile flp = [Select Id from Profile where name = 'Care Advisor Connect Community User' LIMIT 1];   
            comUser = New User();
            string randomNumber = string.valueOf(Math.round((Math.random() * (900000) + 100000)));
            comUser.UserName = email;
            comUser.FirstName = accr.contact.FirstName;
            comUser.LastName = accr.contact.LastName;
            comUser.Alias = (String.isNotBlank(accr.contact.LastName)&& accr.contact.LastName.length()>3)?
                      accr.contact.LastName.substring(0,3):accr.contact.firstName.substring(0,3);                          
            comUser.email = randomNumber + email;
            comUser.ContactId = accr.contactId;
            comUser.CommunityNickName = 'FLUser'+string.valueOf(math.random()).substring(0,6);
            comUser.ProfileID = flp.id;
            comUser.TimeZoneSidKey = 'America/Mexico_City';
            comUser.LocaleSidKey = 'en_US';
            comUser.EmailEncodingKey = 'UTF-8';
            comUser.LanguageLocaleKey = 'en_US';
            comUser.alias = 'guest'+ string.valueOf(math.random()).substring(0,2);
            comuser.Suppress_Email_Reset_Time__c= system.now().addMinutes(60).addMinutes(1);
            comuser.Phone = accr.contact.Phone;
            comuser.MobilePhone = accr.contact.MobilePhone;
            Database.SaveResult[] srList = Database.insert(new list<user>{comUser});
            registeredUserId = comUser.Id;
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    msg = 'SUCCESS';
                }else{
                    for(Database.Error err : sr.getErrors()) {
                        msg =  err.getMessage();
                    }
                }
            }
        }catch(Exception ex){
            msg = ex.getMessage();
        }
        return msg;
    }
}