@IsTest public with sharing class SNI_FL_ForgotPasswordControllerTest {
  	@IsTest
    public static void validateInvalidUser() {
    	System.assertEquals(SNI_FL_ForgotPasswordController.forgotPassword('12345', '/myfamilylink/s/login/CheckPasswordResetEmail').ErrorMessage,'Please enter a valid email address.'); 
    }
    
    @IsTest
    public static void validateValidUser(){
       System.assertEquals(SNI_FL_ForgotPasswordController.forgotPassword('fl_eagles_test788822@optum.com', '/myfamilylink/s/login/CheckPasswordResetEmail').ErrorMessage,null); 
    }
    
    @IsTest
    public static void validateValidException(){
       System.assert(SNI_FL_ForgotPasswordController.forgotPassword(null, null).ErrorMessage != null);
    }
    
    @IsTest
    public static void validateExperienceID(){
        System.assert(SNI_FL_ForgotPasswordController.setExperienceId('hiimbob') != null); 
    }
}