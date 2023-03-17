public without sharing class ACET_SpecialityDropDownCtrl {

    public List<Records> records;

	public class Records {
		@AuraEnabled public String active_ind;
		@AuraEnabled public String code;
		@AuraEnabled public String description;
		@AuraEnabled public String shrt_description;
		@AuraEnabled public String full_description;
    }
    
    public static ACET_SpecialityDropDownCtrl parse(String json) {
		return (ACET_SpecialityDropDownCtrl) System.JSON.deserialize(json, ACET_SpecialityDropDownCtrl.class);
    }
    
	public class ComboboxRecord implements Comparable {
 
		@AuraEnabled public Boolean selected;
		@AuraEnabled public String label;
		@AuraEnabled public String value;
	 
		public ComboboxRecord(Boolean s, String l, String v) {
			selected = s;
			label = l;
			value = v;
		}
	 
		public Integer compareTo(Object objToCompare) {
			ComboboxRecord cmbRec = (ComboboxRecord)objToCompare;
			if (label == cmbRec.label){
				return 0;
			}
			else if (label > cmbRec.label){
				return 1;
			}
			else{
				return -1;        
			}
		}
	}
    
    @AuraEnabled
	public static Map<String, Object> getComboboxRecords() {
		System.debug('@ ACET_SpecialityDropDownCtrl: getComboboxRecords: ');
        
		Map<String, Object> reponseData = new Map<String, Object>();
		try {
            String responseJSONString = [SELECT Body FROM StaticResource WHERE Name = 'SpecialityDropdownValues' LIMIT 1].Body.toString();        
            //System.debug('@ ACET_SpecialityDropDownCtrl: getComboboxRecords: responseJSONString: ' + responseJSONString);
            ACET_SpecialityDropDownCtrl spddObj = parse(responseJSONString);
            
            List<ComboboxRecord> comboboxRecords = new List<ComboboxRecord>();
            for(Records r : spddObj.records) {
                comboboxRecords.add(new ComboboxRecord(false, r.full_description, r.code));
			}
			comboboxRecords.sort();
			reponseData.put('success', true);
			reponseData.put('comboboxRecords', comboboxRecords);
			System.debug('@ ACET_SpecialityDropDownCtrl: getComboboxRecords: reponseData: ' + reponseData);
			return reponseData;
		} catch(Exception e) {
			System.debug('@ ACET_SpecialityDropDownCtrl: getComboboxRecords: Exception caught: ' + e.getMessage() + '_' + e.getLineNumber());
			reponseData.put('success', false);
			reponseData.put('message', 'Something went wrong please refresh page and try again.');
			return reponseData;
		}
	}

    @AuraEnabled
    public static  Map<Integer,String> getCOSMOCodeWithDescription(){
         Map<Integer,String> codeToDecMap = new Map<Integer,String>();
        for(COSMOS_Specialty_Code__mdt cs : [select Specialty_Code__c, Specialty_Description__c FROM COSMOS_Specialty_Code__mdt ]){
            if(cs.Specialty_Code__c != null && cs.Specialty_Description__c != null){
                codeToDecMap.put(Integer.valueof(cs.Specialty_Code__c),String.valueof(cs.Specialty_Description__c));
            }
        }
        system.debug('=codeToDecMap='+codeToDecMap);
        system.debug('=codeToDecMakeyp='+codeToDecMap.keyset());
        return codeToDecMap;
    }

}