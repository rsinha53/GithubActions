public class ACETLGT_QuickLinks {
    /*
	@AuraEnabled
    public static List<Bookmark_Links__c> getQuickLinksList(){
        
        List<Bookmark_Links__c> quickList = [SELECT Display_Name__c , URL__c FROM 
                              						Bookmark_Links__c ORDER BY Display_Name__c ];
        return quickList;
  
    }
    */
    
    
        
    
    @AuraEnabled public static string CIRRUSURL {get;set;}
    /*@AuraEnabled public string landingPageinCirrus{get;set;}
    @AuraEnabled public string subjectTyp{get;set;}
    @AuraEnabled public static string topicName{get;set;}
    
    @AuraEnabled public string MemberId='';    */
    
    
    @AuraEnabled
    public static Bookmark_Links__c[] getQuickLinksList() {

            String strProfName = [ SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId() ].Name;
            return [ SELECT Name, Display_Name__c, Profiles__c, URL__c, Active__c FROM Bookmark_Links__c 
            WHERE Active__c = true AND Profiles__c INCLUDES(:strProfName) ORDER BY Display_Name__c ];

    }
    
    
    @AuraEnabled
    public static String GenerateCIRRUS() {

        
        //Call CIRRUS Method
        return ACETLGT_CirrusControllerLoad.GenerateCIRRUSURL('', 'memberDetail', 'Member','', '');
        

    } 
    
    
    
}