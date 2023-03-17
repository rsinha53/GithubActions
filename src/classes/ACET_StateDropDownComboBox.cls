public class ACET_StateDropDownComboBox {

    @AuraEnabled
    public static List<State__mdt> getStateDetails() {
        List<State__mdt> lstStateCodes = [Select id, Full_Name__c, Label from State__mdt];
        return lstStateCodes;
    }

}