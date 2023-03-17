public class ACETLGT_AuthorizationDetailResult {
    //Inpatient
    @AuraEnabled public String Authorization_Number { set; get; }
    @AuraEnabled public String Authorization_Type { set; get; }
    @AuraEnabled public String Case_Status { set; get; }
    @AuraEnabled public String Case_Reason_Desc { set; get; }
    @AuraEnabled public string Expected_Admission_Date { set; get; }
    @AuraEnabled public string Actual_Admission_Date { set; get; }
    @AuraEnabled public string Expected_Discharge_Date { set; get; }
    @AuraEnabled public string Actual_Discharge_Date { set; get; }
    @AuraEnabled public String Pre_Determination { set; get; }
    @AuraEnabled public String Review_Priority { set; get; }
    @AuraEnabled public String Discharge_Location { set; get; }
    @AuraEnabled public String Coverage_Type { set; get; }
    @AuraEnabled public String caseOwner {get;set;}
    
    @AuraEnabled public list<authProviderDetail> authProviderDetails { set; get; }
    public class authProviderDetail {
        //public String Provider_NonFacility_Role { set; get; }
        @AuraEnabled public String Provider_Facility_Role { set; get; }
        @AuraEnabled public String Provider_ID { set; get; }
        @AuraEnabled public String Facility_Service_Provider_Status { set; get; }
        //public String NonFacility_Service_Provider_Status { set; get; }F
        @AuraEnabled public string TIN { set; get; }
        @AuraEnabled public string Address_1 { set; get; }
        @AuraEnabled public string City { set; get; }
        @AuraEnabled public string State { set; get; }
        @AuraEnabled public string ZIP { set; get; }
        @AuraEnabled public string Speciality { set; get; }
    }
    @AuraEnabled public list<notification> notifications { set; get;}
    public class notification {
        @AuraEnabled public string Notification_Type { set; get; }
        @AuraEnabled public string Notified_Date_Time { set; get; }
    }
    @AuraEnabled public list<authFacilityDetail> authFacilityDetails { set; get;}
    public class authFacilityDetail {
        @AuraEnabled public string Facility_Authorization_Number { set; get; }
        @AuraEnabled public String POS { set; get; }
        @AuraEnabled public String Service_Detail { set; get; }
        @AuraEnabled public string Service_Desc { set; get; }
        @AuraEnabled public string Facility_Provider_Status { set; get; }
        @AuraEnabled public string Facility_Decision_Outcome { set; get; }
        @AuraEnabled public string Facility_Decision_Sub_Type { set; get; }
        @AuraEnabled public string Facility_Decision_Rendered_Date { set; get; }
        @AuraEnabled public string Facility_Claim_Remark_Code { set; get; }
        @AuraEnabled public string Facility_Gap_Outcome { set; get; }
        @AuraEnabled public string Facility_Decision_Reason { set; get; }
        @AuraEnabled public string Facility_Decision_Comment { set; get; }
    }
    @AuraEnabled public string Facility_Authorization_Number { set; get; }
    @AuraEnabled public String POS { set; get; }
    @AuraEnabled public String Service_Detail { set; get; }
    @AuraEnabled public string Service_Desc { set; get; }
    @AuraEnabled public string Facility_Provider_Status { set; get; }
    @AuraEnabled public string Facility_Decision_Outcome { set; get; }
    @AuraEnabled public string Facility_Decision_Sub_Type { set; get; }
    @AuraEnabled public string Facility_Decision_Rendered_Date { set; get; }
    @AuraEnabled public string Facility_Claim_Remark_Code { set; get; }
    @AuraEnabled public string Facility_Gap_Outcome { set; get; }
    @AuraEnabled public string Facility_Decision_Reason { set; get; }
    @AuraEnabled public string Facility_Decision_Comment { set; get; }
    
    @AuraEnabled public List<BedDayDec> bedDayDecision {get;set;}
    
    
    public class BedDayDec{
        @AuraEnabled public String bedDatesStart {get;set;}
        @AuraEnabled public String bedDatesStop {get;set;}
        @AuraEnabled public String bedTypeCode {get;set;}
        @AuraEnabled public String bedTypeDescription {get;set;}
        @AuraEnabled public String revenueCode {get;set;}
        @AuraEnabled public String revenueDescription{get;set;}
        @AuraEnabled public String decisionReasonCode {get;set;}
        @AuraEnabled public String decisionReasonDescription {get;set;}
        @AuraEnabled public String systemClaimRemarkCode {get;set;}
        @AuraEnabled public String systemClaimRemarkDescription {get;set;}
        @AuraEnabled public String decisionOutcomeCode {get;set;}
        @AuraEnabled public String decisionOutcomeDescription {get;set;}
        @AuraEnabled public String decisionUpdateDateTime {get;set;}
    }
    
    
    @AuraEnabled public list<authServiceDetail> authServiceDetails { set; get; }
    public class authServiceDetail {
        @AuraEnabled public string Service_Authorization_Number { set; get; }
        @AuraEnabled public String Procedure_Code { set; get; }
        @AuraEnabled public String Procedure_Description { set; get; }
        @AuraEnabled public string Proc_Text { set; get; }
        @AuraEnabled public string Expected_Procedure_Date { set; get; }
        @AuraEnabled public string Actual_Procedure_Date { set; get; }
        @AuraEnabled public string Service_StartDate {get;set;}
        @AuraEnabled public string Service_StopDate {get;set;}
        @AuraEnabled public string Service_Provider_Status { set; get; }
        @AuraEnabled public string Service_Decision_Outcome { set; get; }
        @AuraEnabled public string Service_Decision_Sub_Type { set; get; }
        @AuraEnabled public string Service_Decision_Rendered_Date { set; get; }
        @AuraEnabled public string Service_Claim_Remark_Code { set; get; }
        @AuraEnabled public string Service_Gap_Outcome { set; get; }
        @AuraEnabled public string Service_Decision_Reason { set; get; }
        @AuraEnabled public string Service_Decision_Comment { set; get; }
    }
    @AuraEnabled public list<diagnosis> diagnosisList { set; get;}
    public class diagnosis { 
        @AuraEnabled public String Dx_Code { set; get; }
        @AuraEnabled public String Dx_Description { set; get; }
    }
    
    @AuraEnabled public list<notes> notesList { set; get;} 
    public class notes{
        @AuraEnabled public String Create_Date { set; get; }
        @AuraEnabled public String Created_By { set; get; }
        @AuraEnabled public String Department { set; get; }
        @AuraEnabled public String Note_Type { set; get; }
        @AuraEnabled public String Subject_Type { set; get; }
        @AuraEnabled public String Note_details { set; get; }
    }
    @AuraEnabled public String Name { set; get; }
    @AuraEnabled public String Role { set; get; }
    @AuraEnabled public String Medical_Record_Number { set; get; }
    @AuraEnabled public String Contact_Department { set; get; }
    @AuraEnabled public String Fax { set; get; }
    @AuraEnabled public String Primary_Phone { set; get; } 
    @AuraEnabled public String Email_Address{ set; get; }
    
    @AuraEnabled public String Authorization_Number_3  { set; get; }
    @AuraEnabled public String Seq_No { set; get; }
    @AuraEnabled public String Letter_Gen_ID { set; get; }
    @AuraEnabled public String Create_Dt { set; get; }
    
    
    //Outpatient Facility
    @AuraEnabled public String Service_Start_Date { set; get; }
    //authServices.nonFacilityProcedure.serviceEffDates.startDate
    @AuraEnabled public String Service_End_Date { set; get; }
    //authServices.nonFacilityProcedure.serviceEffDates.stopDate
    
    @AuraEnabled public String Expiration_Date { set; get; }
    //GAP in Service
    
    //Outpatient
    
    
    
}