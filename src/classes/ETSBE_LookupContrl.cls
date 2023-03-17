public without sharing class ETSBE_LookupContrl {
	 @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
       
        List<Profile> excludeProfiles=[Select id,Name from Profile where Name='Family Link Provider User' OR Name='FamilyLink Community User'];
 
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name ,Profile.Name,FederationIdentifier,Role_Name__c,BEO_Specialty__c,Profile_Name__c from ' +ObjectName + ' where (Name LIKE: searchKey or FederationIdentifier LIKE:searchKey)'
                  + 'AND Profile.Id NOT IN : excludeProfiles' ;
        sQuery += ' order by createdDate DESC limit 5';
        system.debug('......'+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}