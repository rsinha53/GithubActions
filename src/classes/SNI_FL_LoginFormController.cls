/*
* Author: Team Eagles
* Description: handling the login functionality on FamilyLink
* Date Modified: 08/12/2020
*/
global class SNI_FL_LoginFormController {
    
    public SNI_FL_LoginFormController() {
        
    }
    
    public class LoginWrapper {
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public String loginErrorMessage {get;set;}
        @AuraEnabled
        public Boolean isUsernamePasswordEnabled {get;set;}
        @AuraEnabled
        public Boolean isSelfRegistrationEnabled {get;set;}
        @AuraEnabled
        public String forgotPasswordUrl {get;set;}
        @AuraEnabled
        public String selfRegistrationUrl {get;set;}
    }

    @AuraEnabled
    public static LoginWrapper login(String username, String password, String startUrl) {
        LoginWrapper wrapper = new LoginWrapper();
        boolean ErrorOccured = false;
        try{
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            aura.redirect(lgn);
            wrapper.loginErrorMessage = null;
        }
        catch (Exception ex) {
            if (ex.getMessage() == 'Enter a value in the User Name field.') {
                ex.setMessage('Enter a value in the Username field.');
            } else if(ex.getMessage() != 'Enter a value in the Password field.' && ex.getMessage() != 'Your login attempt has failed. Make sure the username and password are correct.') {
                System.debug('ERROR MESSAGE: ' + ex.getMessage());
                CreateErrorLog(ex);
                ErrorOccured = false;
            } 
            wrapper.loginErrorMessage = ex.getMessage();
        }
        wrapper.ErrorOccured = ErrorOccured;
        return wrapper;
    }
    
    @AuraEnabled
    public static LoginWrapper getIsUsernamePasswordEnabled() {
        LoginWrapper wrapper = new LoginWrapper();
        boolean ErrorOccured = false;
        try{
        	Auth.AuthConfiguration authConfig = getAuthConfig();
            system.debug('authConfig--'+authConfig);
            system.debug('authConfig.getUsernamePasswordEnabled()--'+authConfig.getUsernamePasswordEnabled());
            wrapper.isUsernamePasswordEnabled = authConfig.getUsernamePasswordEnabled();
        } catch(Exception ex) {
            system.debug('ex--'+ex);
            CreateErrorLog(ex);
            ErrorOccured = true;
        }
        wrapper.ErrorOccured = ErrorOccured;
        return wrapper;
    }

    @AuraEnabled
    public static LoginWrapper getIsSelfRegistrationEnabled() {
        LoginWrapper wrapper = new LoginWrapper();
        boolean ErrorOccured = false;
        try{
            Auth.AuthConfiguration authConfig = getAuthConfig();
            wrapper.isSelfRegistrationEnabled = authConfig.getSelfRegistrationEnabled();
        } catch(Exception ex) {
            CreateErrorLog(ex);
            ErrorOccured = true;
        }
        wrapper.ErrorOccured = ErrorOccured;
        return wrapper;
    }
    
    @AuraEnabled
    public static LoginWrapper getSelfRegistrationUrl() {
        LoginWrapper wrapper = new LoginWrapper();
        boolean ErrorOccured = false;
        try{
            Auth.AuthConfiguration authConfig = getAuthConfig();
            if (authConfig.getSelfRegistrationEnabled()) {
            	wrapper.selfRegistrationUrl = authConfig.getSelfRegistrationUrl();
            } else {
                wrapper.selfRegistrationUrl = null;
            }
        } catch(Exception ex) {
            CreateErrorLog(ex);
            ErrorOccured = true;
        }
        wrapper.ErrorOccured = ErrorOccured;
        return wrapper;
    }

    @AuraEnabled
    public static LoginWrapper getForgotPasswordUrl() {
        LoginWrapper wrapper = new LoginWrapper();
        boolean ErrorOccured = false;
        try{
            Auth.AuthConfiguration authConfig = getAuthConfig();
            wrapper.forgotPasswordUrl = authConfig.getForgotPasswordUrl();
        } catch(Exception ex) {
            CreateErrorLog(ex);
            ErrorOccured = true;
        }
        wrapper.ErrorOccured = ErrorOccured;
        return wrapper;
    }
    
    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
    }

    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }
    }   
  
    public static void CreateErrorLog(Exception ex){
        //Original functionality for error handling here: AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_LoginFormController',ex);
        //functionality added here because AcetUtility.CreateAndRedirectToError has a query for the User which isn't available before the user is logged in
        String errorline =(ex.getLineNumber()).format();
        String errormessage =ex.getMessage();
        String errortype =ex.getTypeName();
        Application_Error_Log__c err =  ACETUtility.CreateApplicationExcepLog('ACET','FamilyLink','SNI_FL_LoginFormController','',errorline,errormessage,errortype) ;
	if(err != null){
	        Database.Insert(err,false) ;
	}
    }
}