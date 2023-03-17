public without sharing class ComboboxFieldCtrl {
	
    @AuraEnabled
	public static Map<String, Object> getComboboxRecords(String objectName, String searchFieldName, String orderBy, String whereCondition) {
		System.debug('@ ComboboxFieldCtrl: getComboboxRecords: ');
        System.debug('objectName: ' + objectName);
        System.debug('searchFieldName: ' + searchFieldName);
         System.debug('whereCondition: ' +JSON.serialize( whereCondition));
		Map<String, Object> reponseData = new Map<String, Object>();
		try {
            String query = '';

            if(orderBy != '') {
                if(String.isNotBlank(whereCondition)){
                    query = 'SELECT ' + searchFieldName + ' FROM ' + objectName +  ' where ' + whereCondition +  ' ORDER BY ' + orderBy + ' LIMIT 50000';
                }
                else{
                    if(searchFieldName != orderBy){//US3181616 - Sravan
                        query = 'SELECT ' + searchFieldName +','+ orderBy +' FROM ' + objectName + ' ORDER BY ' + orderBy + ' LIMIT 50000';
                    }
                else{
                    query = 'SELECT ' + searchFieldName + ' FROM ' + objectName + ' ORDER BY ' + orderBy + ' LIMIT 50000';
                }

                }
            } else {
                if(String.isNotBlank(whereCondition)){
                    query = 'SELECT ' + searchFieldName + ' FROM ' + objectName + ' where ' + whereCondition + ' LIMIT 50000';
                }
                else{
                    query = 'SELECT ' + searchFieldName + ' FROM ' + objectName + ' LIMIT 50000';
                }
            }
			System.debug('@ ComboboxFieldCtrl: getComboboxRecords: query: ' + query);
			List<SObject> allRecords = Database.query(query);
            List<String> comboboxRecords = new List<String>();
            List<String> avoidDuplicates = new List<String>();
            for(SObject so : allRecords) {
                if(! avoidDuplicates.contains((String) so.get(searchFieldName))){
                    comboboxRecords.add((String) so.get(searchFieldName));
                    avoidDuplicates.add((String) so.get(searchFieldName));
                }
            }
			reponseData.put('success', true);
			reponseData.put('comboboxRecords', comboboxRecords);
			System.debug('@ ComboboxFieldCtrl: getComboboxRecords: reponseData: ' + reponseData);
			return reponseData;
		} catch(Exception e) {
			System.debug('@ ComboboxFieldCtrl: getComboboxRecords: Exception caught: ' + e.getMessage() + '_' + e.getLineNumber());
			reponseData.put('success', false);
			reponseData.put('message', 'Something went wrong please refresh page and try again.');
			return reponseData;
		}
	}

     @AuraEnabled
	public static Map<String, Object>  getZones(String stateName) {
        Map<String, Object> reponseData = new Map<String, Object>();
		try {
            String zone = '';

            List<ORS_Routing_Information__mdt> allRecords = [SELECT Id, State__c,Team__c FROM ORS_Routing_Information__mdt where Topic__c = 'Provider Lookup' AND Advocate_Role__c = 'All'];

            for(ORS_Routing_Information__mdt record: allRecords){
                if(record.State__c!=null && record.State__c.contains(stateName)){
                    zone =  record.Team__c;
                    break;
                }
            }
            reponseData.put('success', true);
			reponseData.put('zone', zone);
            return reponseData;
		} catch(Exception e) {
			System.debug('@ ComboboxFieldCtrl: getZones: Exception caught: ' + e.getMessage() + '_' + e.getLineNumber());
			reponseData.put('success', false);
			reponseData.put('zone', '');
            return reponseData;
		}
	}
    
}