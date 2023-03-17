/************************************
    * Createdby: Prasad kammella
    * @Classname: OPTUM_ConnectedAppPluginWEX
    * @Return Type: Map< String, String >
    * Description: Description:US3381292 -'WEX' Deep Link - Member Level - Member Page
    ************************************/
global with sharing class OPTUM_ConnectedAppPluginWEX extends Auth.ConnectedAppPlugin {
  global override Map< String, String > customAttributes(Id userId, Id connectedAppId, Map< String, String > formulaDefinedAttributes, 
                                                      Auth.InvocationContext context)  {
        list<account> acclist= [Select Id, Name, EID__c, SRK_KeyChain__c, ParticipantAdminAlias__c, ParticipantEmployeeExternalId__c, ParticipantEmployerCode__c, lastmodifiedby.name,lastmodifiedbyId from Account where lastmodifiedbyId=:userId order by lastmodifieddate Desc limit 1 ];                                                
                 formulaDefinedAttributes.put( 'ParticipantEmployeeExternalId', acclist[0].ParticipantEmployeeExternalId__c );
                 formulaDefinedAttributes.put( 'ParticipantEmployerCode', acclist[0].ParticipantAdminAlias__c );
                 formulaDefinedAttributes.put( 'ParticipantAdminAlias', acclist[0].ParticipantEmployerCode__c );                    
        return formulaDefinedAttributes;                                          
    }
}