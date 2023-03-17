public class ACETAuthorizationDetailResult {
 //Inpatient
    public String Authorization_Number { set; get; }
    public String Authorization_Type { set; get; }
    public String Case_Status { set; get; }
    public String Case_Reason_Desc { set; get; }
    public string Expected_Admission_Date { set; get; }
    public string Actual_Admission_Date { set; get; }
    public string Expected_Discharge_Date { set; get; }
    public string Actual_Discharge_Date { set; get; }
    public String Pre_Determination { set; get; }
    public String Review_Priority { set; get; }
    public String Discharge_Location { set; get; }
    public String Coverage_Type { set; get; }
    public String caseOwner {get;set;}

    public list<authProviderDetail> authProviderDetails { set; get; }
    public class authProviderDetail {
        //public String Provider_NonFacility_Role { set; get; }
        public String Provider_Facility_Role { set; get; }
        public String Provider_ID { set; get; }
        public String Facility_Service_Provider_Status { set; get; }
        //public String NonFacility_Service_Provider_Status { set; get; }
        public string TIN { set; get; }
        public string Address_1 { set; get; }
        public string City { set; get; }
        public string State { set; get; }
        public string ZIP { set; get; }
        public string Speciality { set; get; }
    }
    public list<notification> notifications { set; get;}
    public class notification {
        public string Notification_Type { set; get; }
        public string Notified_Date_Time { set; get; }
    }
    public string Facility_Authorization_Number { set; get; }
    public String POS { set; get; }
    public String Service_Detail { set; get; }
    public string Service_Desc { set; get; }
    public string Facility_Provider_Status { set; get; }
    public string Facility_Decision_Outcome { set; get; }
    public string Facility_Decision_Sub_Type { set; get; }
    public string Facility_Decision_Rendered_Date { set; get; }
    public string Facility_Claim_Remark_Code { set; get; }
    public string Facility_Gap_Outcome { set; get; }
    public string Facility_Decision_Reason { set; get; }
    public string Facility_Decision_Comment { set; get; }
    public List<BedDayDec> bedDayDecision {get;set;}
    
    public class BedDayDec{
      public String bedDatesStart {get;set;}
      public String bedDatesStop {get;set;}
      public String bedTypeCode {get;set;}
      public String bedTypeDescription {get;set;}
      public String revenueCode {get;set;}
      public String revenueDescription{get;set;}
      public String decisionReasonCode {get;set;}
      public String decisionReasonDescription {get;set;}
      public String systemClaimRemarkCode {get;set;}
      public String systemClaimRemarkDescription {get;set;}
      public String decisionOutcomeCode {get;set;}
      public String decisionOutcomeDescription {get;set;}
      public String decisionUpdateDateTime {get;set;}
    }
    
    
    public list<authServiceDetail> authServiceDetails { set; get; }
    public class authServiceDetail {
        public string Service_Authorization_Number { set; get; }
        public String Procedure_Code { set; get; }
        public String Procedure_Description { set; get; }
        public string Proc_Text { set; get; }
        public string Expected_Procedure_Date { set; get; }
        public string Actual_Procedure_Date { set; get; }
        public string Service_StartDate {get;set;}
        public string Service_StopDate {get;set;}
        public string Service_Provider_Status { set; get; }
        public string Service_Decision_Outcome { set; get; }
        public string Service_Decision_Sub_Type { set; get; }
        public string Service_Decision_Rendered_Date { set; get; }
        public string Service_Claim_Remark_Code { set; get; }
        public string Service_Gap_Outcome { set; get; }
        public string Service_Decision_Reason { set; get; }
        public string Service_Decision_Comment { set; get; }
    }
public list<diagnosis> diagnosisList { set; get;}
    public class diagnosis { 
    public String Dx_Code { set; get; }
    public String Dx_Description { set; get; }
    }
    
public list<notes> notesList { set; get;} 
    public class notes{
    public String Create_Date { set; get; }
    public String Created_By { set; get; }
    public String Department { set; get; }
    public String Note_Type { set; get; }
    public String Subject_Type { set; get; }
    public String Note_details { set; get; }
    }
    public String Name { set; get; }
    public String Role { set; get; }
    public String Medical_Record_Number { set; get; }
    public String Contact_Department { set; get; }
    public String Fax { set; get; }
    public String Primary_Phone { set; get; }
    public String Email_Address{ set; get; }
    
    public String Authorization_Number_3  { set; get; }
    public String Seq_No { set; get; }
    public String Letter_Gen_ID { set; get; }
    public String Create_Dt { set; get; }
    
    
    //Outpatient Facility
    public String Service_Start_Date { set; get; }
    //authServices.nonFacilityProcedure.serviceEffDates.startDate
    public String Service_End_Date { set; get; }
    //authServices.nonFacilityProcedure.serviceEffDates.stopDate
    
    public String Expiration_Date { set; get; }
    //GAP in Service

    //Outpatient
    
    
    
}