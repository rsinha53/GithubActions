global class HSIDUserRegistrationHandler implements Auth.RegistrationHandler{
global User createUser(Id portalId, Auth.UserData data){
    system.debug('inside create user---'+data);
    List<User> usrLst = new List<User>();
    String ContId = data.attributeMap.get('personcontact');
    usrLst = [select id,Name from User where isActive = true and ContactId =:ContId];
    User u = new User();
    if(usrLst.size() > 0)
    u = usrLst[0];
    
    Profile p = [SELECT Id FROM profile WHERE name='Care Advisor Connect Community User'];
    if(usrLst.size() == 0){
        u.username = data.username;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        u.UserRoleId = null;
        String alias = data.username;
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.emailEncodingKey = 'UTF-8';
        u.Digital_Onboarding__c = true;
        u.ContactId = data.attributeMap.get('personcontact');
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
    }
    return u;
}

global void updateUser(Id userId, Id portalId, Auth.UserData data){
    system.debug('inside update user--');
    System.debug('userId--->' +userId);
    List<User> usrLst = new List<User>();
    usrLst = [select id,Name,isActive from User where Id =: userId];
    if(usrLst.size() > 0 && usrLst[0].isActive == false && usrLst[0].contactId != null){
    //usrLst[0].isActive = true;
    //update usrLst[0];
    }
    /*User u = new User(id=userId);
    u.username = data.username + '@salesforce.com';
    u.email = data.email;
    u.lastName = data.lastName;
    u.firstName = data.firstName;
    String alias = data.username;
    if(alias.length() > 8) {
        alias = alias.substring(0, 8);
    }
    u.alias = alias;
    u.LanguageLocaleKey = 'en_US';
    u.LocaleSidKey = 'en_US';*/
    
}
}