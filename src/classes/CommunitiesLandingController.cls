/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
/*
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}
*/
/*
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        string cacLanding = system.Label.CACLandingPageURL;
    String communityUrl = cacLanding; //URL of new page
     return new PageReference(communityUrl);  
   }
    
    public CommunitiesLandingController() {}
}
*/

public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        Network mynetwork = [SELECT ID FROM Network WHERE Name = 'Care Advisor Connect'];
        ConnectApi.Community mycommunity = ConnectApi.Communities.getCommunity(mynetwork.id);
        String communityUrl = mycommunity.siteURL;
        system.debug('***'+communityUrl); 
        return new PageReference(communityUrl);
   }
    
    public CommunitiesLandingController() {}
}