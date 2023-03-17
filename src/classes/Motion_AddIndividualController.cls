public class Motion_AddIndividualController {
    public Motion_AddIndividualController() {

    }
    public class MotionIndividualPickLists {
        @AuraEnabled public List<State> lstStatusValues{get;set;}
    }
    public class State implements Comparable{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
 
        public State(String sLabel, String sValue){
            label = sLabel;
            value = sValue;
        }
        public Integer compareTo(Object objToCompare){
            return label.CompareTo(((State)objToCompare).label);
        }
    }    
    @AuraEnabled
    public static MotionIndividualPickLists motionAddIndividualPickListValues(){
        MotionIndividualPickLists mbrSearchLovs = new MotionIndividualPickLists();
        
        mbrSearchLovs.lstStatusValues = getStateValues();       
        return mbrSearchLovs;
    }
    public static List<State> getStateValues(){
        List<State> lstStatevalues = new List<State>();
        State objsts;
        for(State__mdt sts : [Select Id, MasterLabel,DeveloperName from State__mdt ORDER BY Masterlabel]){
            objsts = new State(sts.MasterLabel, sts.DeveloperName);
            lstStatevalues.add(objsts);
        }
        return lstStatevalues;    
    }
    /*@AuraEnabled 
    public static Interaction__c createThirdPartyRecord(String firstName, String lastName, string emailaddress, string phone, String groupname, string groupnumber, string dob, String state, string zip, string inttype){
        system.debug('$#$#$#'+dob);
        Interaction__c interaction;
            String fmtDOB = ACETLGT_CreateConstituents.formatDatewithslash(dob);

        //system.debug('fmtDOB'+fmtDOB);
        Third_Party__c thirdaccount = new Third_Party__c();
         thirdaccount = new Third_Party__c(
            LastName__c = lastName,
            First_Name__c   = firstName,
            Email__c = emailaddress,
            Phone_Number__c = phone,
            Group_Name__c = groupname,
            DOB__c = (fmtDOB != null?Date.valueOf(fmtDOB):null),
            Group_Number__c = groupnumber,
            Mailing_State__c = state,
            Mailing_PostalCode__c=zip
            
        );
        
        try{ 
        
                Database.insert(thirdaccount);
                
                if(thirdaccount.Id != null ){
                    interaction = MOTION_CreatePersonAccountInteractions.createInteraction(inttype, 'Other', null, thirdaccount.id);
                    
                    if(interaction.Id != null){
                        interaction= MOTION_CreatePersonAccountInteractions.queryInteraction(interaction.Id);
                        System.debug('Interaction record created successfully: '+ interaction.Id);
                    }
                }
           }catch(Exception ex){
                System.debug(ex.getMessage());
           }
  
        return interaction;
    }*/
}