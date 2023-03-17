//Added by Mounika
public class PolicyNumberutil {    
    Public Static List<	Policy_Number__mdt> policyNumber {get;set;}
    
    public static string validatePolicyNumber( string str){
        map<string,string> policyMap= new map<string,string>(); 
        List<Policy_Number__mdt> policyNumber = Policy_Number__mdt.getAll().values();
        for(Policy_Number__mdt pn : policyNumber){
            policyMap.put(pn.MasterLabel,pn.Output_Policy_Number__c);
        }
        for (String polN : policyMap.keySet())
        {
            if(str.contains(polN)){
                return policyMap.get(polN);
            }
        } 
        return str;
    }
}