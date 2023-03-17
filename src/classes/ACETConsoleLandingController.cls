public class ACETConsoleLandingController{
    public ACETConsoleLandingController(){
        //pageRedirectToConsole();
    }
    public pagereference pageRedirectToConsole(){
        string classicURL = URL.getSalesforceBaseUrl().toString();
        String lightningURL = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('----classicURL----'+classicURL);
        system.debug('----lightningURL----'+lightningURL);
        List<PermissionSetAssignment> permissionSetAssgnList = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId=: UserInfo.getUserId() AND PermissionSet.Name='Lightning_Experience'];
        string baseURL;
        pagereference pgConsole;
        if(permissionSetAssgnList.size() > 0){
            baseURL = lightningURL + '/lightning/n/LGT_Member_Search';
             pgConsole = new pagereference(baseURL);
        }else{
            baseURL = lightningURL;
             pgConsole = new pagereference(baseURL+'/console');
        }
        pgConsole.setRedirect(true);
        return pgConsole;
    }
}