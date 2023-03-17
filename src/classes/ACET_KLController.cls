Public With Sharing class ACET_KLController {
    
     @AuraEnabled
     Public Static List<KL_Data__c> getKLData(String key, String codeType)
     {
        List<KL_Data__c> klData=new List<KL_Data__c>();
         try
         {
            key += '%';
             if(codeType.equalsIgnoreCase('ProcedureCode'))
             {
                 klData=[select id, Name,Code_Type__c,Code_Description__c from KL_Data__c where (Name LIKE :key) AND (Code_Type__c='CPT' OR Code_Type__c='HCPCS') ORDER BY Name LIMIT 500];
             }else if(codeType.equalsIgnoreCase('DiagnosisCode')) {
                 klData=[select id, Name,Code_Type__c,Code_Description__c from KL_Data__c where (Name LIKE :key) AND (Code_Type__c='ICD10 Diagnosis') ORDER BY Name LIMIT 500];
             }
			 Map<String,KL_Data__c> klClone=new Map<String,KL_Data__c>();
             if(klData.size()>0)
             {
                 for(KL_Data__c kld:klData)
                 {
                     klClone.put(kld.Name,kld);
                     if(klClone.size()>=500)
                     {
                       break;  
                     }
                     
                 }
                klData= klClone.values();
             }
             return klData;
         }
         catch(exception e)
         {
              return klData;
         }
     }
}