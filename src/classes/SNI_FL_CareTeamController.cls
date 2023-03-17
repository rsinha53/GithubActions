public without sharing class SNI_FL_CareTeamController {
    @AuraEnabled
    public static careTeamWrapperReturn getCareTeamMembers(String famAccId){
        list<careTeamWrapper> lstCTwrapper = new list<careTeamWrapper>();
		list<careTeamWrapper> lstCTwrapperNew = new list<careTeamWrapper>();
        boolean ErrorOccured = false;
        boolean isFLAccOwner =false;
        String FLAccOwnerCtmId = '';
        String FLAccOwnerMemName = '';
        Id userId =UserInfo.getUserId();
        User u = [select id, contactId,contact.accountId from User where id = : userId];
        string loggedInAccId = u.contact.accountId;
        
        try{
            if(famAccId != null){
                list<SNI_FL_Care_Team_Member__c> lstcurCT = [SELECT Id,SNI_FL_Primary_Caregiver__c,Email__c,SNI_FL_Non_Policy_Member__c,SNI_FL_Status__c,SNI_FL_Family__c,SNI_FL_Family__r.Id,SNI_FL_Member__c,SNI_FL_Member__r.Name,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName,SNI_FL_Member__r.PersonBirthdate,SNI_FL_Member__r.PersonMailingAddress,SNI_FL_Member__r.Member_ID__c,SNI_FL_Member__r.FamilyLink_Registration_Date__c From SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c =: famAccId and SNI_FL_Not_Visible_in_Familylink__c != true and SNI_FL_Status__c!='Removed'];
                list<string> lstCtids = new list<string>();
                for(SNI_FL_Care_Team_Member__c curCTrec : lstcurCT){
                lstCtids.add(curCTrec.id);
                }
                //Id famAcc = Id.valueOf(famAccId);
                map<string,string> mapRoiRecs = SNI_FL_ROIUtility.getROIMembersMap(lstCtids,famAccId);
                List<SNI_FL_ROIUtility.ROIReturnWrapper> roiWrapper = SNI_FL_ROIFormController.getSignROIMembers(lstCtids,famAccId,true,false);
			   boolean isPCGfound = false;
                //for(SNI_FL_Care_Team_Member__c curCT : [SELECT Id,SNI_FL_Primary_Caregiver__c,SNI_FL_Non_Policy_Member__c,SNI_FL_Status__c,SNI_FL_Family__c,SNI_FL_Family__r.Id,SNI_FL_Member__c,SNI_FL_Member__r.Name,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName,SNI_FL_Member__r.PersonBirthdate,SNI_FL_Member__r.FamilyLink_Registration_Date__c From SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c =: famAccId and SNI_FL_Not_Visible_in_Familylink__c != true]){
                for(SNI_FL_Care_Team_Member__c curCT : lstcurCT){
                    careTeamWrapper ctw = new careTeamWrapper();
                    ctw.primaryCaregiver = curCT.SNI_FL_Primary_Caregiver__c; 
                    date famRegDate = curCT.SNI_FL_Member__r.FamilyLink_Registration_Date__c;
                    ctw.createDate = famRegDate != null ? famRegDate.month()+'/'+famRegDate.day()+'/'+famRegDate.year() : null;
                    ctw.name = curCT.SNI_FL_Member__r.Name;
                    ctw.Id = curCT.Id;
                    ctw.membId = curCT.SNI_FL_Member__c;
                    ctw.membfrstname = curCT.SNI_FL_Member__r.FirstName;
                    ctw.memblstname = curCT.SNI_FL_Member__r.LastName;
                    ctw.status = curCT.SNI_FL_Status__c;
                    ctw.email = curCT.Email__c;
                    ctw.isNonPolicyMem = curCT.SNI_FL_Non_Policy_Member__c;
                    Integer ageNum=SNI_FL_ROIUtility.calculateAge(curCT.SNI_FL_Member__r.PersonBirthdate,System.today()); 
                    //Integer ageNum = curCT.SNI_FL_Member__r.PersonBirthdate != null ? system.today().year() - curCT.SNI_FL_Member__r.PersonBirthdate.year() : null;
                    ctw.personDob = curCT.SNI_FL_Member__r.PersonBirthdate;
                    ctw.MailAdd = curCT.SNI_FL_Member__r.PersonMailingAddress;
                    ctw.personMemID = '';
                    Id  conId = [Select id,AccountId  from contact where AccountId=:ctw.membId LIMIT 1].Id;
                    for(Account a : [SELECT Id,Member_Id__c,(SELECT Id,AccountId,ContactId FROM AccountContactRelations WHERE ContactId=:conId) FROM Account WHERE Id IN(SELECT AccountId FROM AccountContactRelation WHERE ContactId=:conId) AND Member_Id__c != Null]){
                        if(a.AccountContactRelations.size()>0){
                            ctw.personMemID =a.Member_Id__c;
                        }                                   
                    }
                    ctw.isChild = false;
                    ctw.age = null;
                   if(ageNum != null){
                       ctw.age = ageNum;
                       if(ageNum < 13)
                           ctw.isChild = true;
                       else
                           ctw.isChild = false;
                   }
                   if(curCT.SNI_FL_Primary_Caregiver__c == true && curCT.SNI_FL_Member__c!=null && loggedInAccId.equals(curCT.SNI_FL_Member__c)){
                        FLAccOwnerCtmId = curCT.Id;
                        FLAccOwnerMemName=curCT.SNI_FL_Member__r.Name;
                      isFLAccOwner = true;
                   }
                   if( curCT.SNI_FL_Primary_Caregiver__c != true && curCT.SNI_FL_Member__c!=null && loggedInAccId.equals(curCT.SNI_FL_Member__c)){
					   ctw.isloggedInUser = true;
                   }
                    /* buttons show/hide */
                    System.debug('mapRoiRecs='+mapRoiRecs);
                    if(mapRoiRecs.containsKey(ctw.id)){
                      string roiVal = mapRoiRecs.get(ctw.id);
                        system.debug('isFLAccOwner----'+isFLAccOwner);
                        system.debug('ctw isChild----'+ctw.isChild);
                        system.debug('ctw status----'+ctw.status);
                        // if(ctw.status !='Added' && ctw.status != 'Invited' ){
                        if(curCT.SNI_FL_Primary_Caregiver__c || ctw.isChild || ( ctw.status !='Added' && ctw.status != 'Invited')){
                            ctw.showHideInvbtns = false;
							ctw.inviteStatus = 'FAO';
                        }
                        else{
                            system.debug('----ctw membfrstname--'+ctw.membfrstname+'---ctw memblstname-----'+ctw.memblstname);
                            system.debug('from else cw status-------'+ctw.status);
                            system.debug('from else roiVal-------'+roiVal);
                            ctw.showHideInvbtns = true;
                            if(roiVal == 'Completed' ){   //if(ctw.status == 'Invited' ){
                                ctw.inviteStatus = 'Resend';
                            }
							else if(roiVal != 'Completed' && ctw.status == 'Invited'){
                                ctw.inviteStatus = 'EditInviteRoiCompltd';
                            }
                            else if(ctw.status == 'Added' && roiVal == 'Partial'){
                                ctw.inviteStatus = 'EditInvite';
                            }
                            else if(ctw.status == 'Added' && roiVal == 'Not Started'){
                                ctw.inviteStatus = 'Invite';
                            }
                        }
                       /* SNI_FL_ROIUtility.ROIInviteWrapReturn roiRec = mapRoiRecs.get(ctw.id);
                        ctw.showResend = roiRec.showResend;
                        ctw.invite = roiRec.invite;
                        ctw.editInvite = roiRec.editInvite;*/
                    }
                    /*  buttons show/hide */
                   if(curCT.SNI_FL_Primary_Caregiver__c){
                        lstCTwrapperNew.add(ctw);
                        if(lstCTwrapper.size()>0)
                            lstCTwrapperNew.addall(lstCTwrapper);
                        isPCGfound = true;
                    }
                    else{
                        if(isPCGfound){
                            lstCTwrapperNew.add(ctw);   
                        }
                        else{    
                            lstCTwrapper.add(ctw);   
                        }
                    }
                    // for sign auth
                   for(SNI_FL_ROIUtility.ROIReturnWrapper roiWrap : roiWrapper){
                        if(roiWrap.ctmId ==curCT.Id){
                          ctw.signROIStatus = roiWrap.isAuthROIdone;
                          ctw.expiryDate = roiWrap.expiryDate;
                        }
                    }
                    //
                }
            }
        }
        Catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_CareTeamController',e);
            ErrorOccured = true;
        }
        system.debug('lstCTwrapper-----'+lstCTwrapper);               
        careTeamWrapperReturn objcareTeamWrapperReturn = new careTeamWrapperReturn();
		if(lstCTwrapperNew.size()>0){
            objcareTeamWrapperReturn.lstCareTeamWrap = lstCTwrapperNew;
        }
        else{
            objcareTeamWrapperReturn.lstCareTeamWrap = lstCTwrapper;
        }
        objcareTeamWrapperReturn.ErrorOccured = ErrorOccured;
        objcareTeamWrapperReturn.isFLAccOwner = isFLAccOwner;
        objcareTeamWrapperReturn.FLAccOwnerCtmId = FLAccOwnerCtmId;
        objcareTeamWrapperReturn.FLAccOwnerMemName = FLAccOwnerMemName;
        return objcareTeamWrapperReturn;
    }
    public class careTeamWrapperReturn {
        @AuraEnabled
        public list<careTeamWrapper> lstCareTeamWrap{get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public boolean isFLAccOwner{get;set;} //FL Account Owner check 
        @AuraEnabled
        public string FLAccOwnerCtmId{get;set;}
        @AuraEnabled
        public string FLAccOwnerMemName{get;set;}
    }
     public class careTeamWrapper {       
        @AuraEnabled
        public boolean primaryCaregiver{get;set;}
        @AuraEnabled
        public string createDate{get;set;}
        @AuraEnabled
        public string name{get;set;}
        @AuraEnabled
        public Integer age{get;set;}
        @AuraEnabled
        public boolean isChild{get;set;}
        @AuraEnabled
        public boolean isloggedInUser{get;set;} //Non FL Account Owner check 
        @AuraEnabled
        public string Id{get;set;}//CareTeamId
        @AuraEnabled
        public string membId{get;set;} //Person Account Id
		@AuraEnabled
        public string membfrstname{get;set;}
        @AuraEnabled
        public string memblstname{get;set;}
        @AuraEnabled
        public string status{get;set;}
		@AuraEnabled
        public boolean isNonPolicyMem{get;set;}
        @AuraEnabled
        public date personDob{get;set;}
        @AuraEnabled
        public Address MailAdd {get;set;}
        @AuraEnabled
        public string personMemID {get;set;}
        @AuraEnabled
        public boolean showHideInvbtns{get;set;}
         @AuraEnabled
        public string inviteStatus{get;set;}
        @auraEnabled
        public string signROIStatus{get;set;}
        @auraEnabled
        public String expiryDate{get;set;}
        @auraEnabled
        public String email{get;set;}
       /* @AuraEnabled
        public boolean showResend {get;set;}
        @AuraEnabled
        public boolean invite {get;set;}
        @AuraEnabled
        public boolean editInvite {get;set;}*/
    }
    public static integer calculateAge(Date BirthDay){
        integer age ;
        if(BirthDay != null){
             age = system.today().year() - BirthDay.year();
           // age = string.valueOf(ageNum)+'y';
        }
        return age;
    }
    @AuraEnabled
    public static careTeamWrapperReturn updateCareTeam(String careTeamId){
       careTeamWrapperReturn objcareTeamWrapperReturn = new careTeamWrapperReturn(); 
       boolean ErrorOccured = false;
       List<String> careTeamList = new List<String>();
       try{
           careTeamList.add(careTeamId);
           system.debug('careTeamList=='+careTeamList);
           SNI_FL_DeleteAccountController.careTeamUpdateStatus(careTeamList);
        }
       Catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_CareTeamController',e);
            ErrorOccured = true;
        }
        objcareTeamWrapperReturn.ErrorOccured = ErrorOccured;
        return objcareTeamWrapperReturn;
    }
    @AuraEnabled
    public static careTeamWrapperReturn updateUserRec(String careTeamMemId,String familyId){
       careTeamWrapperReturn objcareTeamWrapperReturn = new careTeamWrapperReturn(); 
       boolean ErrorOccured = false;
       List<String> careTeamList = new List<String>();
       try{
           careTeamList.add(careTeamMemId);
           system.debug('careTeamList=='+careTeamList);
           SNI_FL_DeleteAccountController.updateUserRec(careTeamList,familyId);
        }
       Catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_CareTeamController',e);
            ErrorOccured = true;
        }
        objcareTeamWrapperReturn.ErrorOccured = ErrorOccured;
        return objcareTeamWrapperReturn;
    }
}