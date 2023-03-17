/* 
 * @name         :   ACETRestrictionConfigurationUtil
 * @description  :   This component is designed to populate the call topics with restrictions on each detail pages.
 * @author       :   Pavan Kumar Annaldas
 * @createddate  :   16-11-2017
 * @lastmodifiedby:
 *
 */
public class ACETRestrictionConfigurationUtil {
 
    public static map<string,boolean> getRestrictionConfigurations(string agentType, string restrictionType) {
        map<string, boolean> restricitionMapping = new map<string, boolean>();
        list<Restriction_Configuration__c> restrictionConfigurationsList = new list<Restriction_Configuration__c>();
        
        if(string.isBlank(agentType)) {
            for(user u : [select id,Agent_Type__c from user where id=:userInfo.getUserId() limit 1]) {
                agentType = u.Agent_Type__c;
            }
        }
        if(String.isNotBlank(restrictionType)) {
            string qry = 'select id, Agent_Type__c,Restricted_Topic__c,Restriction_Type__c,Topic__c from Restriction_Configuration__c';
            qry = qry + '  Where Is_Active__c= true AND Agent_Type__c=:agentType '; 
            if(!string.isBlank(restrictionType)){
                qry = qry + '  AND Restriction_Type__c=:restrictionType ';
            }
            restrictionConfigurationsList = database.query(qry);
            if(restrictionConfigurationsList != null && !restrictionConfigurationsList.isEmpty()) {
                for(Restriction_Configuration__c obj : restrictionConfigurationsList){
                    if(obj.Restricted_Topic__c == 'Yes')
                        restricitionMapping.put(obj.Topic__c,true);
                    else
                        restricitionMapping.put(obj.Topic__c,false);
                }   
            }
        }
        return restricitionMapping; 
    }
    
}