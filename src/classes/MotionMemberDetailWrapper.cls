public class MotionMemberDetailWrapper {
    public class HighlightsPanel{
        @AuraEnabled public String deptCode;
        @AuraEnabled public String deviceModel;
        @AuraEnabled public String dob;
        @AuraEnabled public String email;
        @AuraEnabled public String dermId;
        @AuraEnabled public Address address = new Address();        
    }
    public class DigitalTherapeutic{
        @AuraEnabled public String activityOptin;
        @auraenabled public String activityEligible;
    }
    public class DeviceInfo{
        @AuraEnabled public String deviceModel;
        @AuraEnabled public String lastSyncStepDateTime;
        @AuraEnabled public String lastSyncAppVersion;
        @AuraEnabled public String firmwareVersion;
        @AuraEnabled public String syncFrequency;
        @AuraEnabled public String timeZone;
        
    }
    
     public class MemberNotFound {
         @AuraEnabled public String fname;
		@AuraEnabled public String lname;
        // @AuraEnabled public String Address;
         @AuraEnabled public String SourceCode;
         @AuraEnabled public String dob;
         @AuraEnabled public String EmailAddress;
         @AuraEnabled public String GroupName;
         @AuraEnabled public String GroupNumber;
         @AuraEnabled public String memberId;
         @AuraEnabled public String Zip;
         @AuraEnabled public String State;
         @AuraEnabled public String Phone;
    }
    
    public class MemberNotFoundHighlightsHeader{
        @AuraEnabled public String fullName;
        @AuraEnabled public String intId;
        @AuraEnabled public String intName;
    }
   
    
    public class Address{
        @AuraEnabled public String address1;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String zipcode;
    }
    
   //public class MemberRecord {
        
        public String RegisteredMemberID;
        public String EligibleMemberID;
        public String FirstName;
        public String LastName;
        public String EmailAddress;
        public String BirthDate;
        public String SSN;
        public String Gender;
        public String Phone;
    	public String HomePhone;
        public String Address;
        public String City;
        public String State;
        public String ZipCode;
        public String Role;
        public String GroupName;
        public String LookupRuleGroupID;
    	public String OfferCode;
        public String ClientName;
        public String Height;
        public String Weight;
        public String Status;
        public String ProgramStartDate;
        public String CancelledDateTime;
        public String DependentCode;
    	public String Relationship;
        public String PlanType;
        public String MaxDailyEarnings;
        public String TimeZone;
        public String MonthlyEmail;
        public String WeeklyEMail;
        public String OptOutAllEmails;
        public String SyncFrequency;
        public String FraudTier;
        public String FraudLockout;
        //public Integer DoNotLockAccount;
        public String AlternateActivityEligible;
        public String  AlternateActivityOptInStatus;
        
        
    //}
    public class MemberConsoleInfo{
        public String LastSyncStepDateTime;
        public String LastSyncAppVersion;
        public String FirmwareVersion;
        public String DeviceModelPaired;
    }
    
    
    //@AuraEnabled public MemberDermInfo  memberdermInfo;// = new MemberDermInfo();
    //@AuraEnabled public List<MemberRecord> memberRecord;
    @AuraEnabled public MemberConsoleInfo memberconsoleInfo;// = new MemberConsoleInfo();
    // @AuraEnabled public MemberNotFound membernotFound;
    //public List<ConsoleMemberRecord> consoleMemberRecord;
    
    
    
}