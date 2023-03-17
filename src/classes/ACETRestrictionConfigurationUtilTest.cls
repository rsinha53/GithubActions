@isTest
public class ACETRestrictionConfigurationUtilTest {
    static testMethod void testPreparingConfigurations1(){
        list<string> agentTypes = new list<string>{'Onshore','Offshore'};
        list<string> topics = new list<string>{'Commissions','Enroll Member'};
        list<Restriction_Configuration__c> configs = new list<Restriction_Configuration__c>();
        for(string agentType : agentTypes){
            for(string topic : topics){
                configs.add(getRestrictionConfiguration(agentType,'Yes','01',topic,true));
            }
        }
        configs.add(getRestrictionConfiguration('Offshore','No','01','Create Authorization',true));
        insert configs;
        
        Test.startTest();
        map<string,boolean> restrictionConfigs = ACETRestrictionConfigurationUtil.getRestrictionConfigurations('Offshore','01');
        for(string s : restrictionConfigs.keySet()){
            if(s != 'Create Authorization' )
            	system.assert(restrictionConfigs.get(s));
            else
                system.assert(restrictionConfigs.get(s)==false);
        }
        Test.stopTest();
    }
    
    static testMethod void testPreparingConfigurations2(){
        list<string> agentTypes = new list<string>{'Onshore','Offshore'};
        list<string> topics = new list<string>{'Commissions','Enroll Member'};
        list<Restriction_Configuration__c> configs = new list<Restriction_Configuration__c>();
        for(string agentType : agentTypes){
            for(string topic : topics){
                configs.add(getRestrictionConfiguration(agentType,'Yes','01',topic,true));
            }
        }
        configs.add(getRestrictionConfiguration('Offshore','No','01','Create Authorization',true));
        insert configs;
        
        Test.startTest();
        map<string,boolean> restrictionConfigs = ACETRestrictionConfigurationUtil.getRestrictionConfigurations(null,'01');
        
        Test.stopTest();
    }
    
    public static Restriction_Configuration__c getRestrictionConfiguration(string agentType,
                                                                   	string restrictedTopic,
                                                                    string restrictionType,
                                                                    string topic,
                                                                    boolean isActive){
        Restriction_Configuration__c obj = new Restriction_Configuration__c();
        obj.Agent_Type__c = agentType;
        obj.Restricted_Topic__c = restrictedTopic;
        obj.Restriction_Type__c = restrictionType;
        obj.Topic__c = topic;
        obj.Is_Active__c = isActive;
        return obj;
    }
}