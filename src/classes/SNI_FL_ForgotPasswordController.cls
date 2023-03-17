/**
 * This global apex class is used for forgotPassword.cmp to validate whether the username is valid or not
 * 
 * @author - Charnkiat Sukpanichnant
 * 
 **/
global class SNI_FL_ForgotPasswordController {
    
    //This class creating an object to detect any unahandle exception occurring on the page.
    public class ExceptionWrapper {
        
        //indicate whether unknown error has occurred or not
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        
        //message string information
        @AuraEnabled
        public String ErrorMessage {get; set;}
        
    }

    
    /**
     * This auraEnabled method is used when end-user clicked on 'Reset Password' button on forgotpassword page
     **/
	@AuraEnabled
    public static ExceptionWrapper forgotPassword(String emailaddress, String checkEmailUrl) {
        boolean ErrorOccured = false;
		ExceptionWrapper wrapper = new ExceptionWrapper();
        try {   
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            if(!Site.isValidUsername(emailaddress)) {
                wrapper.ErrorOccured = ErrorOccured;
                wrapper.ErrorMessage = 'Please enter a valid email address.';
                return wrapper;
            }
            else{
                Site.forgotPassword(emailaddress);
                if(!Test.isRunningTest())
                {
                    aura.redirect(checkEmailRef);
                }
                wrapper.ErrorOccured = ErrorOccured;
                wrapper.ErrorMessage = null;
                return wrapper;
            }           
        }
        catch (Exception ex) {
            if(!ex.getMessage().equals ('Please enter a valid email address.')){
                String errorline =(ex.getLineNumber()).format();
                String errormessage =ex.getMessage();
                String errortype =ex.getTypeName();
                Application_Error_Log__c err =  ACETUtility.CreateApplicationExcepLog('ACET','FamilyLink','SNI_FL_ForgotPasswordController','',errorline,errormessage,errortype) ;
                Database.Insert(err,false) ;
                wrapper.ErrorOccured = true;
                wrapper.ErrorMessage = errormessage;
                return wrapper;
            }
            else{
                wrapper.ErrorOccured = ErrorOccured;
                wrapper.ErrorMessage = 'Please enter a valid email address.';
                return wrapper;
            }
        }
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
}