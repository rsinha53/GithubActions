//US2841187: This apex class return the fields of Rx Meds Custom object associated with current Family
//Author Name : Derek DuChene
public class SNI_FL_RxMedicationsController {
	@AuraEnabled
    public static String getUserProfile(){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        return profileName;
    }
    
    @AuraEnabled
    public static List<Family_Link_Rx_Medication__c> fetchRxMedications(String recordID)
    {
        List <Family_Link_Rx_Medication__c> fo = new  List <Family_Link_Rx_Medication__c>();
        try {
            if(recordID !=NULL)
            {
                fo= [select Id, Name, Pill_Size__c, Directions__c, Rx_Number__c, Refill_Date__c, Pharmacy__c, Pharmacy_Phone_Number__c from Family_Link_Rx_Medication__c where Status__c ='Active' and Family__c=: recordID order by CreatedDate desc];
                
            }
            return fo;
        }
        catch(Exception e){ return null;}
    }
    
    @AuraEnabled
    public static Family_Link_Rx_Medication__c editRxMed(Family_Link_Rx_Medication__c selRxMed) {
        if(selRxMed!=NULL) {
            upsert selRxMed;
        }
        return selRxMed;
    }
    
    @AuraEnabled
    public static Family_Link_Rx_Medication__c removeRxMed(Family_Link_Rx_Medication__c selRxMed) {
        if(selRxMed!=NULL) {
        	selRxMed.Status__c = 'Removed';
            upsert selRxMed;
        }
        return selRxMed;
    }
}