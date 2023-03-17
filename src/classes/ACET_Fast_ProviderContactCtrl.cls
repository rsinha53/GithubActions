/*
ACET_Fast_ProviderContactCtrl
Test Class Name:  ACET_Fast_ProviderContactCtrl_Test
Author: Manohar Reddy
Description: This class is used for to add Explore page values to Person Account and Third party object. 
11/09/2020 - Manohar Reddy - Initial
*/

public without sharing class ACET_Fast_ProviderContactCtrl {
    @AuraEnabled
    public static ACET_Fast_ProviderContactCtrl.ResultWrapper saveProviderContact(string wrapperStringJSON){
        ACET_Fast_ProviderContactCtrl.ResultWrapper finalResult = new  ACET_Fast_ProviderContactCtrl.ResultWrapper();
        WrapperClass exploreWrapVar = (WrapperClass)JSON.deserialize(wrapperStringJSON, WrapperClass.class);
        String returnValue='';
        try{
            system.debug('exploreWrapVar.accountRec --> ' + exploreWrapVar.accountRec);
            system.debug('exploreWrapVar.noAccountTaxId --> ' + exploreWrapVar.noAccountTaxId);
            if(exploreWrapVar.accountInteractionWrap.taxidornpi == '' || exploreWrapVar.accountInteractionWrap.taxidornpi == null){
                exploreWrapVar.accountInteractionWrap.taxidornpi = exploreWrapVar.noAccountTaxId;
                system.debug('exploreWrapVar.accountInteractionWrap.taxidornpi --> ' + exploreWrapVar.accountInteractionWrap.taxidornpi);
            }
            
            // Dummy Interaction Record
            Interaction__c interRec = new Interaction__c();
            interRec.Interaction_Type__c = 'Email';
            insert interRec;

            //INSERT A THIRD PARTY RECORD
            insertThirdPartyRec(exploreWrapVar);

            //INSERT A RECORD IN PERSON ACCOUNT WHEN WE HAVE CORPORATE OWNER LAST NAME
            if((exploreWrapVar.accountInteractionWrap.corporateOwnerLastName != '' && exploreWrapVar.accountInteractionWrap.corporateOwnerLastName != null)&&
               (exploreWrapVar.accountInteractionWrap.taxidornpi != '' && exploreWrapVar.accountInteractionWrap.taxidornpi != null))
            {
                string lastName = exploreWrapVar.accountInteractionWrap.corporateOwnerLastName;
                string taxId = exploreWrapVar.accountInteractionWrap.taxidornpi;
                string eid = exploreWrapVar.accountInteractionWrap.corpMPIN + exploreWrapVar.accountInteractionWrap.taxidornpi;
                string recordTypeID = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');  
                map<string, account> uniquenameAccountMap = new map<string, account>();
                for(Account acc : [SELECT id,Tax_Id__c,RecordTypeId,FirstName,LastName,EID__c FROM Account WHERE RecordTypeId =: recordTypeID AND EID__c LIKE :'%' + taxId LIMIT 1000]){
                    uniquenameAccountMap.put((acc.LastName + '-' + acc.Tax_Id__c),acc);
                }
                string providerVal = lastName+ '-' + taxId;
                system.debug('providerVal -> ' + providerVal);
                if(!uniquenameAccountMap.containsKey(providerVal)){
                    exploreWrapVar.accountRec.RecordTypeId = recordTypeID;
                    exploreWrapVar.accountRec.LastName = lastName;
                    exploreWrapVar.accountRec.Tax_Id__c = taxId;
                    exploreWrapVar.accountRec.EID__c = eid;
                    insert exploreWrapVar.accountRec;
                    system.debug('accountRec with Corporate owner last name - ' + exploreWrapVar.accountRec);
                    system.debug('Record ID with Corporate owner last name - ' + exploreWrapVar.accountRec.Id);
                    returnValue = exploreWrapVar.accountRec.Id;
                } 
                // Updating Account Record with Provider Contact details 
                else{
                    Account accMatchedRec=uniquenameAccountMap.get(providerVal);
                    accMatchedRec.Provider_Contact_Email__c = exploreWrapVar.accountRec.Provider_Contact_Email__c;
                    accMatchedRec.Provider_Contact_Phone__c = exploreWrapVar.accountRec.Provider_Contact_Phone__c;
                    accMatchedRec.Provider_Contact_Preference__c = exploreWrapVar.accountRec.Provider_Contact_Preference__c;
                    accMatchedRec.Provider_Contact__c = exploreWrapVar.accountRec.Provider_Contact__c;
                    accMatchedRec.Par_Provider__c = exploreWrapVar.accountRec.Par_Provider__c;
                    accMatchedRec.EID__c = eid;
                    update accMatchedRec;
                    system.debug('accMatchedRec - ' + accMatchedRec);
                    system.debug('accMatchedRec - ' + accMatchedRec.Id);
                    returnValue = accMatchedRec.Id;
                }
            }
            
            //INSERT A RECORD IN PERSON ACCOUNT WHEN WE DON'T HAVE CORPORATE OWNER LAST NAME
            if((exploreWrapVar.accountInteractionWrap.corporateOwnerLastName == '' || exploreWrapVar.accountInteractionWrap.corporateOwnerLastName == null))
            {
                returnValue = insertPersonAccRecWithOutCorp(exploreWrapVar);
            }

            finalResult.interctionRecordId = interRec.id;
            finalResult.accountRecordId = returnValue;
            system.debug('finalResult==>'+finalResult); 
            return finalResult;
        }
        catch(exception ex){
            system.debug('Exception Message'+ex.getMessage());
            returnValue=ex.getMessage();
            finalResult.errorMessage = returnValue;
            system.debug('finalResult==>'+finalResult);  
            return finalResult;
        }        
    }

    public static void insertThirdPartyRec(WrapperClass exploreWrapVar){
                    //INSERT A THIRD PARTY RECORD -- "No Provider To Search"
                    system.debug('exploreWrapVar.noAccountInteractionWrap.isNoProviderToSearch --> ' + exploreWrapVar.noAccountInteractionWrap.isNoProviderToSearch);
                    if(exploreWrapVar.noAccountInteractionWrap.isNoProviderToSearch == 'true'){
                        Third_Party__c thirdPartRec = new Third_Party__c();
                        thirdPartRec.FullName__c = exploreWrapVar.accountInteractionWrap.firstName + ' ' +
                            exploreWrapVar.accountInteractionWrap.lastName;
                        thirdPartRec.First_Name__c = exploreWrapVar.accountInteractionWrap.firstName;
                        thirdPartRec.LastName__c = exploreWrapVar.accountInteractionWrap.lastName;
                        thirdPartRec.Tax_ID__c = exploreWrapVar.noAccountTaxId;
                        thirdPartRec.Provider_Type__c = exploreWrapVar.accountInteractionWrap.providerType;
                        thirdPartRec.Provider_Speciality__c = exploreWrapVar.accountInteractionWrap.providerSpeciality;
                        insert thirdPartRec;
                        system.debug('thirdPartRec - ' + thirdPartRec);
                        system.debug('Record ID - ' + thirdPartRec.Id);
                    }
                    
                    //INSERT A THIRD PARTY RECORD -- "Provider Not Found"
                    system.debug('exploreWrapVar.accountInteractionWrap.isProviderNotFound --> ' + exploreWrapVar.accountInteractionWrap.isProviderNotFound);
                    if(exploreWrapVar.accountInteractionWrap.isProviderNotFound  == 'true'){
                        Third_Party__c thirdPartRec = new Third_Party__c();
                        thirdPartRec.FullName__c = exploreWrapVar.accountInteractionWrap.firstName + ' '+
                            exploreWrapVar.accountInteractionWrap.lastName;
                        thirdPartRec.First_Name__c = exploreWrapVar.accountInteractionWrap.firstName;
                        thirdPartRec.LastName__c = exploreWrapVar.accountInteractionWrap.lastName;
                        thirdPartRec.Filter_Type__c = exploreWrapVar.accountInteractionWrap.filterType;
                        thirdPartRec.Practicing_Status__c = exploreWrapVar.accountInteractionWrap.practicingStatus;
                        thirdPartRec.State__c = exploreWrapVar.accountInteractionWrap.state;
                        thirdPartRec.Zip_Code__c = exploreWrapVar.accountInteractionWrap.zip;
                        insert thirdPartRec;
                        system.debug('Provider Not Found thirdPartRec - ' + thirdPartRec);
                        system.debug('Provider Not Found Record ID - ' + thirdPartRec.Id);
                    }
    }

    public static String insertPersonAccRecWithOutCorp(WrapperClass exploreWrapVar){
        string recordTypeID = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');
        exploreWrapVar.accountRec.RecordTypeId = recordTypeID;
        exploreWrapVar.accountRec.LastName = 'No Provider Name Found';
        if(exploreWrapVar.accountInteractionWrap.taxidornpi != '' && exploreWrapVar.accountInteractionWrap.taxidornpi != null){
            exploreWrapVar.accountRec.Tax_Id__c = exploreWrapVar.accountInteractionWrap.taxidornpi;
        }
        if(exploreWrapVar.accountInteractionWrap.isProviderNotFound  == 'true'){
            exploreWrapVar.accountRec.Tax_Id__c = '999999999';
        }
        system.debug('exploreWrapVar.caseRecordType --> ' + exploreWrapVar.caseRecordType);
        system.debug('exploreWrapVar.noAccountTaxId --> ' + exploreWrapVar.noAccountTaxId);
        
        //US2994299 - in sprint 3 - for PIP, when no provider to search check box is checked and user does not enter values then tax id will be 999999999 AND Name will be 'No Provider Name Found.  
        if(exploreWrapVar.noAccountInteractionWrap.isNoProviderToSearch == 'true' && exploreWrapVar.caseRecordType == 'Proactive Action' && 
           (exploreWrapVar.noAccountTaxId == '' || exploreWrapVar.noAccountTaxId == null)){
               exploreWrapVar.accountRec.Tax_Id__c = '999999999';
           }
        insert exploreWrapVar.accountRec;
        system.debug('accountRec when NO Provider - ' + exploreWrapVar.accountRec);
        system.debug('Record ID when NO Provider - ' + exploreWrapVar.accountRec.Id);

        return exploreWrapVar.accountRec.Id;
    }
    
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName)
    { 
        //Get record type id based on record type developer name
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
    
    public class WrapperClass{
        @AuraEnabled
        public Account accountRec {get;set;}
        @AuraEnabled
        public ACET_Fast_ProviderContactCtrl.ProviderAccountWrapper accountInteractionWrap {get;set;}
        @AuraEnabled
        public ACET_Fast_ProviderContactCtrl.ProviderAccountWrapper noAccountInteractionWrap {get;set;}
        @AuraEnabled
        public string noAccountTaxId {get;set;}
        @AuraEnabled
        public string caseRecordType {get;set;}
        
        public WrapperClass(){
            accountRec = new Account();
            accountInteractionWrap= new ACET_Fast_ProviderContactCtrl.ProviderAccountWrapper();
            noAccountInteractionWrap= new ACET_Fast_ProviderContactCtrl.ProviderAccountWrapper();
        }
    }    
    
    public class ProviderAccountWrapper{
        public string firstName;
        public string lastName;
        public string taxidornpi;
        public string providerType;
        public string providerSpeciality;
        public string noSearchtaxIdOrNPI;
        public string isNoProviderToSearch;  
        public string corporateOwnerLastName;
        public string corpMPIN;
        public string isProviderNotFound;
        public string filterType;
        public string practicingStatus;
        public string state;
        public string zip;
    }
    public class ResultWrapper{
        @AuraEnabled
        public string accountRecordId{get;set;}
        @AuraEnabled
        public string interctionRecordId{get;set;}
        @AuraEnabled
        public string errorMessage{get;set;}
    }
}