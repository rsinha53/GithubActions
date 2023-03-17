public without Sharing class ACETLGT_ProviderUtility {
     public static Map<String,set<String>> getClasifications(String providerType){        
        List<Provider_Taxonomy__mdt> providerTaxonomyMdt = new List<Provider_Taxonomy__mdt>([select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt where Provider_Type__c =: providerType order by Classification__c asc]);        
        map<String,set<String>> calisificationByProvider = new map<String,set<String>>();
        for(Provider_Taxonomy__mdt prodTax :providerTaxonomyMdt){            
            if(calisificationByProvider.get(prodTax.Provider_Type__c) != null){
                calisificationByProvider.get(prodTax.Provider_Type__c).add(prodTax.Classification__c);
            }else{
                calisificationByProvider.put(prodTax.Provider_Type__c, new set<string>{prodTax.Classification__c});
            }
        }        
       return calisificationByProvider;
    }
    public static  map<string,set<string>> getSpecilities(String providerType){   
        List<Provider_Taxonomy__mdt> providerTaxonomyMdt = new List<Provider_Taxonomy__mdt>([select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt where Provider_Type__c =: providerType order by Speciality__c asc]);        
        map<string,set<string>> specialityByProviderAndClasification = new map<string,set<string>>();
        
        for(Provider_Taxonomy__mdt prodTax :providerTaxonomyMdt){       
            
            string key = prodTax.Provider_Type__c+''+prodTax.Classification__c;
            if(specialityByProviderAndClasification.get(key) != null){
                specialityByProviderAndClasification.get(key).add(prodTax.speciality__c);
            }else{
                specialityByProviderAndClasification.put(key, new set<string>{prodTax.speciality__c});
            }
        }        
        
        return specialityByProviderAndClasification;
    } 
}