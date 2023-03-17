//RxMeds Feature: This apex class will take care of all the functionalities related to RxMeds feature.
//Author Name : Aarti Garg
public without sharing class SNI_FL_RXMedsFL {
    
    @AuraEnabled
    public static RxMedWrapperReturn FetchRXMed(String familyId){
        list<RxMedWrapper> lstRxMedwrapper = new list<RxMedWrapper>();
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
       
        RxMedWrapperReturn objRxMedWrapperReturn = new RxMedWrapperReturn();
           try{
              System.debug('****familyId---'+familyId);
      		  Family_Overview__c[] familyOverView = [select Name,id from Family_Overview__c where Account__c =: familyId]; 
              List<Family_Link_Rx_Medication__c> fl_rxLst=  [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c from Family_Link_Rx_Medication__c where Status__c ='Active' and Family__c IN :familyOverView order by CreatedDate desc] ; 
           
               for( Family_Link_Rx_Medication__c f :fl_rxLst)
              {
                   RxMedWrapper rx = new RxMedWrapper();
                    rx.RxMedID = f.Id;
                    rx.RxName = f.Name;
                    rx.PillSize = f.Pill_Size__c;
                    rx.Directions = f.Directions__c;
                    rx.RxNumber = f.Rx_Number__c;
                    rx.RefillDate =f.Refill_Date__c;
                     rx.Pharmacy=f.Pharmacy__c;
                     rx.PharmacyPhoneNumber= f.Pharmacy_Phone_Number__c;
                    lstRxMedwrapper.add(rx);
                
              }
            
            objRxMedWrapperReturn.lstRxMedWrap = lstRxMedwrapper;
            objRxMedWrapperReturn.ErrorOccured = ErrorOccured;
            objRxMedWrapperReturn.ErrorMessage = ErrorMessage;
            objRxMedWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RXMedsFL',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }
        return objRxMedWrapperReturn;
    }
    
             
       @AuraEnabled
    public static SingleRxMedWrapperReturn getRxMedsBySelectedID(String familyRxID){
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        boolean isFLAccOwner =false;
        RxMedWrapper rx = new RxMedWrapper();
         SingleRxMedWrapperReturn objRXWrapperReturn = new SingleRxMedWrapperReturn();
        
        try{
            Family_Link_Rx_Medication__c frx= [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c 
                      from Family_Link_Rx_Medication__c where Id =: familyRxID] ; 
           	rx.RxMedID = frx.Id;
            rx.RxName = frx.Name;
            rx.PillSize = frx.Pill_Size__c;
            rx.Directions = frx.Directions__c;
            rx.RxNumber = frx.Rx_Number__c;
            rx.RxMedID = frx.Id;
            rx.RefillDate = frx.Refill_Date__c;
             rx.Pharmacy = frx.Pharmacy__c;
             rx.PharmacyPhoneNumber = frx.Pharmacy_Phone_Number__c;
            objRXWrapperReturn.selectedRxMed = rx;
            objRXWrapperReturn.ErrorOccured = ErrorOccured;
            objRXWrapperReturn.ErrorMessage = ErrorMessage;
            objRXWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RXMedsFL',e);
            ErrorOccured = true;
            ErrorMessage = e.getMessage();
        }
        
        return objRXWrapperReturn;
    }   
      @AuraEnabled
    public static boolean updateRxMedsByID(String rxID, string RxName, string RxPillSize,string rxDirections,string rxNum,Date rxRefillDate, String rxPharmacyAdd, String RxPharmacyPhone){
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        try{
            Family_Link_Rx_Medication__c RxMed= [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c 
                      from Family_Link_Rx_Medication__c where Id =: rxID limit 1] ; 
              if(RxMed != null){
                RxMed.Name = RxName;
                  
	    			RxMed.Pill_Size__c = (IsEmptyOrNull(RxPillSize)) ? '':RxPillSize;
                    RxMed.Directions__c = (IsEmptyOrNull(rxDirections)) ? '':rxDirections;
                    RxMed.Rx_Number__c = (IsEmptyOrNull(rxNum)) ? '':rxNum;
                    if(rxRefillDate != null)
                    {
                	RxMed.Refill_Date__c=  rxRefillDate;
                    }
                    RxMed.Pharmacy__c = (IsEmptyOrNull(rxPharmacyAdd)) ? '':rxPharmacyAdd;
                    RxMed.Pharmacy_Phone_Number__c = (IsEmptyOrNull(RxPharmacyPhone)) ? '':RxPharmacyPhone;
		        	RxMed.Status__c = 'Active';
		        	Update RxMed;
                return true;
            }
            else{
                return false;
            }

        }
        catch(Exception ex){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RxMedsFL',ex);
        	ErrorOccured = true;
        	ErrorMessage = ex.getMessage();
            return false;
        }
    }
    @AuraEnabled
    public static boolean deleteRxMedByID(String rxID)
    {
         
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        try{
             Family_Link_Rx_Medication__c RxMed= [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c 
                      from Family_Link_Rx_Medication__c where Id =: rxID limit 1] ; 
              if(RxMed != null){
                RxMed.Status__c = 'Removed';
                update RxMed;
                return true;
            }
            
            else{
                return false;
            }
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_RXMedsFL',e);
        	ErrorOccured = true;
        	ErrorMessage = e.getMessage();
            return false;
        }
    }
    
     @AuraEnabled
    public static boolean IsEmptyOrNull(String value){
         return (value == null || String.isEmpty(value) || String.isBlank(value));
    }

     public class RxMedWrapperReturn {
        @AuraEnabled
        public list<RxMedWrapper> lstRxMedWrap{get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }
    
    public class SingleRxMedWrapperReturn {
        @AuraEnabled
        public RxMedWrapper selectedRxMed {get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }
    
    public class RxMedWrapper {
        @AuraEnabled
        public String RxMedID {get;set;}
         @AuraEnabled
        public String RxName {get;set;}
        @AuraEnabled
        public string PillSize{get;set;}
        @AuraEnabled
        public string Directions{get;set;}
        @AuraEnabled
        public string RxNumber{get;set;}
        @AuraEnabled
        public Date RefillDate{get;set;}
         @AuraEnabled
        public string Pharmacy{get;set;}
        @AuraEnabled
        public string PharmacyPhoneNumber{get;set;}
       
    }
}