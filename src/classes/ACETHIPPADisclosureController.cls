public without sharing class ACETHIPPADisclosureController {
    private Interaction__c Interaction {get;set;} 
    public String InteractionId {get;set;}
    public Set<String> categories {get;set;}
    public String subDOB {get;set;}
    public String orgDOB {get;set;}
    public Integer callerAge {get;set;}
    private List<ACETHippaCategoryRule__c> hippaRules;
    public ACETHIPPADisclosureController(){

        categories = new Set<String>();
    }

    public void runHippaCategoryRules(){
        system.debug('runHippaCategoryRules called');
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);


        String callerType = Interaction.Originator_Type__c;//Member/provider/Producer/Employer/Broker
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
        
        String callerSubType; //Will be third party originator type
        if(Interaction.Third_Party__c != null){
            List<Third_Party_Originator__c> TPOList = [SELECT Id,Name FROM Third_Party_Originator__c WHERE Third_Party__c = :Interaction.Third_Party__c];
            if(TPOList != null && TPOList.size() > 0)
                callerSubType = TPOList[0].Name;
            orgDependent = null;
        }
        List<String> cstList =new List<String>();
        cstList.add(callerSubType);
        cstList.add('Third Parties');
        Integer callerAge;
 

        categories = new Set<String>();
        system.debug(callerType + ' :: '+cstList + ' :: '+orgDependent );
        hippaRules = [SELECT Caller_SubType__c,Caller_Type__c,General__c,Max_Age__c,Medical__c,Min_Age__c,Sensitive__c
                      FROM ACETHippaCategoryRule__c where
                      (caller_type__c = :callerType and 
                      Caller_subtype__c in :cstList and 
                      Dependent__c = : orgDependent and
                      max_age__c > : subjectAge and
                      min_age__c < : subjectAge)];
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


    }

    public Integer getAgeFromDOB(String dob){
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