/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageUtil
Description    : Route logic to SNI_FL_ProviderMessageReadAgent and SNI_FL_ProviderMessageReadBackupAdvisor clases
Created By     : Sameera - ACDC US3075477,US3078403,US3121134
Created Date   : 12/16/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderMessageUtil {
   
    

    /**
     * 
     * @param inObjectParameters 
     * @return `List<ProviderData>`
     * @author Sameera/Vamsi
     * @deprecated Retrive provider messaging related to dropdown data
     */
    @AuraEnabled
    public static List<ProviderData> retrieveProviderData(Object inObjectParameters){
        
        try {
            
            Map<Object,Object> inputData = (Map<Object,Object>)inObjectParameters;
            String label = (String)inputData.get('label'); 

            //Executes for backup agent provider message popup
            if(!(((inputData.get('isBackupAgentView') instanceof Boolean) && ((Boolean)inputData.get('isBackupAgentView')==false)) || ((inputData.get('isBackupAgentView') instanceof String) && ((String)inputData.get('isBackupAgentView')=='false')))?false:true){

                switch on label{
                    when 'Programs'{
                        //Program drop down for backup advisor view
                        SNI_FL_ProviderMessageReadBackupAdvisor agentObj = new SNI_FL_ProviderMessageReadBackupAdvisor(inputData);
                        return agentObj.getProviderAffliations();
                    }
                    
                    when 'Related To'{
                        SNI_FL_ProviderMessageReadBackupAdvisor agentObj = new SNI_FL_ProviderMessageReadBackupAdvisor(inputData);
                        return agentObj.getRelatedMembers();
                    }

                    when 'To'{
                        SNI_FL_ProviderMessageReadBackupAdvisor agentObj = new SNI_FL_ProviderMessageReadBackupAdvisor(inputData);
                        return agentObj.getMessagingToUsers();
                    }
                }

            }
            //Executes for member level provider messaging popup
            else if((String)inputData.get('familyId')!=NULL)
            {
                switch on label{
                    when 'Programs'{
                        //program dropdown for person account view
                        SNI_FL_ProviderMessageReadAgent agentObj = new SNI_FL_ProviderMessageReadAgent(inputData);
                        return agentObj.getProviderAffliations();
                    }
                    when else{
                       
                        //To dropdown for person account view
                        SNI_FL_ProviderMessageReadAgent agentObj = new SNI_FL_ProviderMessageReadAgent(inputData);
                        return agentObj.getMessagingToUsers();
                    }
                }
                
            }
            //Executes for my message level provier messaging popup
            else{
                
                switch on label{
                    when 'Programs'{
                        //program dropdown for my message view
                      SNI_FL_ProviderMessageReadAgent agentObj = new SNI_FL_ProviderMessageReadAgent(inputData);
                      return agentObj.getProviderAffliations();
                       
                    }
                    when 'Related To'{
                        //Related To dropdown for Messagin view
                        SNI_FL_ProviderMessageReadAgent agentObj = new SNI_FL_ProviderMessageReadAgent(inputData);
                       return agentObj.getRelatedMembers();
                    }
                    when else{
                       SNI_FL_ProviderMessageReadAgent agentObj = new SNI_FL_ProviderMessageReadAgent(inputData);
                       return agentObj.getMessagingToUsers();
                    }
                }
            }
            
        
            return null;
            
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            return null;
        }

    }

    /**
     * Sameera - ACDC  US3128709,US3128731
     * @param inObjectParameters 
     */    
    @AuraEnabled
    public static void createProviderMessage(Object inObjectParameters){
        try {
            
            Boolean isSuccess = false;//Sameera ACDC US3131863
            Map<Object,Object> inputData = (Map<Object,Object>)inObjectParameters;
            String messageBody = (String)inputData.get('messageBody');
            String subject = (String)inputData.get('subject');
            String uploadedFiledID = (String)inputData.get('fileId');
            List<String> userList = SNI_FL_ProviderNewMessageController.getRecipientList((List<Object>)inputData.get('recipients'));
            Integer value = uploadedFiledID!= NULL?1:0;

            Switch on  value{

                when 1{
                    //US3376756 - sameera(added null argument at the end)
                    isSuccess = SNI_FLDirectMessageConnectAPI.postAFeedElementWithAttachment(messageBody,subject,userList,uploadedFiledID,null,inputData,null);

                }
                when else{
                    //US3376756 - sameera(added null argument at the end)
                    isSuccess = SNI_FLDirectMessageConnectAPI.postAFeedElementWithoutAttachment(messageBody,subject,userList,null,inputData,null);
                }
            }

             //Sameera ACDC US3131863
            if(isSuccess){
                SNI_FL_ProviderCustomNotification.sendNewMessageCustonNotification(messageBody,subject,SNI_FL_ProviderNewMessageController.advisors);
                SNI_FLDirectMessageUtil.sendEmailOrSMSNotifications(userList);//Blinker US305042

            }

        } 
        catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
    }
    
    /**
     *  @author Pavithra US3124954
     * @param inObjectParameters 
     * @return  `List<ProviderData>`
     */
    @AuraEnabled
    public static List<ProviderData> retrieveFamilyLinkProviderData(Object inObjectParameters){
        
        try {
            
            Map<Object,Object> inputData = (Map<Object,Object>)inObjectParameters;
            String label = (String)inputData.get('label');            
            //Executes for Family Link provider messaging                 
            switch on label{                
                when 'Related To'{
                    //Related To dropdown for Family Link provider messaging
                    SNI_FL_ProviderMessageFamilyLink agentObj = new SNI_FL_ProviderMessageFamilyLink(inputData);
                    return agentObj.getRelatedMembers();
                }
                when 'To'{
                    //To dropdown for Family Link provider messaging
                    SNI_FL_ProviderMessageFamilyLink agentObj = new SNI_FL_ProviderMessageFamilyLink(inputData);
                    return agentObj.getMessagingToUsers();
                }
                
            }                                    
            return null;
            
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            return null;
        }
  
    }

    //Wrapper class that send data to NewProviderMessagePopup dropdown
    public class ProviderData {
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String userType{get;set;}
        @AuraEnabled public String memberId{get;set;}
    }

    /**
     * 
     * @param lstrecords 
     * @param accessType 
     * @returns `List<sObject>`
     * @author Sameera
     * @description enforce apex security for fields and objects
     */    
    public static List<sObject> enforceApexSecurity(List<sObject> lstrecords,String accessType){
        try{

            if(accessType == 'READABLE'){
                SObjectAccessDecision decision = Security.stripInaccessible(System.AccessType.READABLE,lstrecords,true);
                return decision.getRecords();
            }
            return null;
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return null;
        }
    }  

    //Author:Pavithra - ACDC
    //US3213590 - Display MemberId in SENS
    //Retrieve string value
    @AuraEnabled
    public static String getMemberIdByAccountId(String accountID){
        return SNI_FL_ProviderMessageReadAgent.getMemberIdByAccountId(accountID);
    }

    //Author:Pavithra - ACDC    
    //US3213590 - Display MemberId in SENS
    //Retrieve string value
    @AuraEnabled
    public static String getMemberNameByAccountId(String accountID){
        return SNI_FL_ProviderMessageReadAgent.getMemberNameByAccountId(accountID);
    }
    
}