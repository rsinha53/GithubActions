/**
* Author: Shoven Shrivastava
* Description : Controller class to be used by Dahsboard to get data from web services.
* AuraEnabled : True
* Date Created: 8/6/2019
*/

public without sharing class ADBOpportunityController {
   
        // Constant variables
    final static String ACTIVE_POLICY = 'Active Policy';  
    /*
* Input parameter: memberId
* Output parameter: List of Opportunities
*/ 
    // Function to get functional role - DE355671 - sunil vennam
    @AuraEnabled
    public static String getfunctionalRole(String userId, Boolean isIntegration){
        String role = '';
        String user_ID = '';
        System.debug('userId-opp---->'+userId);
        
        user_ID = getUser(userId,isIntegration);
        if(user_ID!=null){
            role = ADBFunctionalRoleService.checkAgentDataExists(user_ID);
        }
        return role;
    }
    Public Static String getUser(String userId, Boolean isInt){
        String msid='';
        if(isInt){
            msid = userId;
        }else{
            User u = [SELECT FederationIdentifier FROM user WHERE id=:userinfo.getuserid()];
            msid = u.FederationIdentifier;
        }
        return msid;
    }
    @AuraEnabled
    public static ADBOpportunityCardWrapper getOpportunities(String userId, String memberId,string memberTypeId, integer noOfOffers, String functionRole, Boolean isIntegration){
        ADBOpportunityRequestWrapper request = new ADBOpportunityRequestWrapper();
        //added functional Role: US2620797 - sunil vennam
        // Actual Web service call
        String agentMsid = getUser(userId,isIntegration);
        request.userId = agentMsid;						
        request.memberId = memberId;
        request.memberIdType = memberTypeId;
        request.numberOfOffers = string.valueOf(noOfOffers);
        request.userRole = functionRole;
        ADBOpportunityCardWrapper offersWrapper = new ADBOpportunityCardWrapper();
        try {       
            offersWrapper = ADBOpportunityWebService.getOpportunities(request);
            offersWrapper.Role = functionRole;
            system.debug('offer wrapper:::'+ offersWrapper);
        } catch(Exception ex) {
            System.debug('ERROR : ADBOpportunityCardWrapper.getOpportunities() : ' + ex.getMessage());
            offersWrapper.statusCode = 500;
            offersWrapper.statusMessage = ex.getMessage();
            offersWrapper.responseMessage = 'Offer Information cannot be retrieved. Open a Help Desk ticket.';
        }
        return offersWrapper;
    }  
    @AuraEnabled
    public static ADBOpportunitySaveResponseWrapper getSaveOpportunities(String memberId, ADBOpportunity offerResponseList, String evntName,String todoLink,String firstName , string lastName, String DOB,String userId,string subscriberId,String nbaParentId, String blacklistDays, String userComments){
        system.debug('offerResponseList controller'+ offerResponseList);
        // Actual Web service call
        ADBOpportunitySaveRequestWrapper req = new ADBOpportunitySaveRequestWrapper();
        req.memberId = memberId;
        ADBOpportunitySaveResponseWrapper saveWrapper =  new ADBOpportunitySaveResponseWrapper();
        try {
                saveWrapper = ADBOpportunityWebService.getSaveOpportunities(req, offerResponseList, evntName, blacklistDays, userId, userComments);
                system.debug('savewrapper' + saveWrapper);
            	saveWrapper.todoLink = todoLink;
            	if(!todoLink.equals('REFRESH_DASHBOARD')){
                	String redirectUrl = ADBICUESSOUtilController.generateRedirectUrl(todoLink, subscriberId, '', firstName, lastName, userId, DOB,'',evntName,nbaParentId);
                	saveWrapper.redirectionUrl = redirectUrl;
                }
        } catch(Exception ex) {
            System.debug('ERROR : ADBOpportunityCardWrapper.getSaveOpportunities() : ' + ex.getMessage());
        }
        return saveWrapper;
    }        
    
    @AuraEnabled
    public static String launchConsumerDashboard(String memberId, String fName, String lName, String dtFormat, String groupNumber, String surrogateKey) {
        User u = [SELECT FederationIdentifier FROM User WHERE Id =: UserInfo.getUserId()];
        system.debug('>>>'+surrogateKey+u.FederationIdentifier+memberId+fName+lName+dtFormat+groupNumber);                                           
        String baseURL;
        if(!System.Test.isRunningTest()) {
        	baseURL = ACETURLEncryptionUtility.getEncryptedConsumerDashURL(u.FederationIdentifier, memberId, fName,
                                                                              lName, dtFormat, groupNumber, surrogateKey);
        } else {
            baseURL = 'http://succsess';
        }
        return baseURL;
    }
}