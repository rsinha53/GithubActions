public class ACETLGT_HIPAADisclosureController {
 
    @AuraEnabled
    public static List<String> getHipaaCategories(String interactionId, String subDOB, String orgDOB, String orgRel){
        system.debug('runHippaCategoryRules called');
        Integer callerAge; boolean isTPRel = true;
        List<ACETHippaCategoryRule__c> hippaRules;
        Set<String> categories = new Set<String>();
        List<String> lstCategories = new List<String>();	// to return from the Aura Enabled method
        Interaction__c interaction = ACETMemberQueryUtil.queryInteraction(interactionId);

        List<ACETRelationshipCodes__c> relations = ACETRelationshipCodes__c.getall().values();
        for(ACETRelationshipCodes__c rel:relations){
            if(orgRel == rel.Description__c)
                isTPRel = false;
        }
        system.debug('>>'+isTPRel+orgRel);
        String callerType = interaction.Originator_Type__c;//Member/provider/Producer/Employer/Broker
        if(callerType.contains('Employer')){
            callerType = 'Employer';
        }
        Integer subjectAge = getAgeFromDOB(subDOB);
        system.debug('subjectAge >> '+subjectAge);
        system.debug('orgDOB >> '+orgDOB);
        String orgDependent;
        if(!String.isEmpty(orgDOB)){
            callerAge = getAgeFromDOB(orgDOB);
            orgDependent = callerAge >= 18 ? 'Adult Dependent' : 'Minor Dependent';
        }else{
            orgDependent = null; 
        }
        if(subDOB == orgDOB)
            orgDependent = 'Self Dependent';
        
        String callerSubType; //Will be third party originator type
        system.debug('>>>>'+Interaction.Originator__c);
        if(Interaction.Third_Party__c != null && isTPRel){
            List<Third_Party_Originator__c> TPOList = [SELECT Id,Name FROM Third_Party_Originator__c WHERE Third_Party__c = :Interaction.Third_Party__c];
            if(TPOList != null && TPOList.size() > 0)
                callerSubType = TPOList[0].Name;
            orgDependent = null;
        }
        List<String> cstList =new List<String>();
        //if(callerSubType!='')
        	cstList.add(callerSubType);
        cstList.add('Third Parties');
        //Integer callerAge;
 		
        system.debug(callerType + ' :: '+cstList + ' :: '+orgDependent + ' :: '+subjectAge );
        hippaRules = [SELECT Caller_SubType__c,Caller_Type__c,General__c,Max_Age__c,Medical__c,Min_Age__c,Sensitive__c
                      FROM ACETHippaCategoryRule__c where
                      (caller_type__c = :callerType and 
                      Caller_subtype__c in :cstList and 
                      Dependent__c = : orgDependent and
                      max_age__c > : subjectAge and
                      min_age__c <= : subjectAge)];
        system.debug(hippaRules);
        if(!hippaRules.isEmpty()){
            for(ACETHippaCategoryRule__c rule : hippaRules){
                    if(rule.General__c){
                        categories.add('General');
                    }
                    if(rule.Medical__c){
                        categories.add('Medical');
                    }
                    if(rule.Sensitive__c){
                        categories.add('Sensitive');
                    }                
            }           
        }
        
        lstCategories.addAll(categories);
        return lstCategories;
    }
    
    public static Integer getAgeFromDOB(String dob){
        String dateWithDash;
        Date d;
        if(dob != null && dob.contains('/')){
            dateWithDash = ACETUtility.formatMMDDYYYYwithSlashToYYYYMMDDwithDash(dob);
        }
        if(dob != null && dob.contains('-')){
            dateWithDash = dob;
        }  
        if(dateWithDash != null) {    
            d = Date.valueOf(dateWithDash);        
            return Integer.valueOf(d.daysBetween(Date.today())/365); 
        }
        else
            return null;       
    }
}