/**
* Author: Hasara Disanayaka
* Date Created: 01/03/2020
* Date Modified:
* Purpose: 
* 
**/
public without sharing class ADBEligibilityExtendedRequestWrapper { 
    @AuraEnabled public List<Member> member{ get; set; } 
    @AuraEnabled public String relationship{ get; set; }
    @AuraEnabled public String firstName{ get; set; } 
    @AuraEnabled public String lastName{ get; set; } 
    @AuraEnabled public String dob{ get; set; } 
    @AuraEnabled public String memberID{ get; set; } 
    @AuraEnabled public String city{ get; set; } 
    @AuraEnabled public String zip{ get; set; } 
    @AuraEnabled public String state{ get; set; } 
    @AuraEnabled public String street1{ get; set; } 
    @AuraEnabled public String street2{ get; set; }
    public class Member { 
        @AuraEnabled public String memRelationship { get; set; }
        @AuraEnabled public String memFirstName{ get; set; } 
        @AuraEnabled public String memLastName { get; set; }
        @AuraEnabled public String memDob { get; set; }
    } 
    @AuraEnabled public String verbalLanguagePreference{ get; set; }
}