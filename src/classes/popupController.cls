public class popupController {
	@AuraEnabled  
    public static String firstMethod() {  
        string urlstr = URL.getSalesforceBaseUrl().toExternalForm();
        return urlstr;   
    }
}