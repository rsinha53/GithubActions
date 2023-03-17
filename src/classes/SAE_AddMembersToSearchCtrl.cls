public class SAE_AddMembersToSearchCtrl {
    
    @AuraEnabled(cacheable=true) 
    public static SAEProviderSearch.SearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID,
                                                                String providerFN, String providerLN, String providerNPI, String providerFlow){
        System.debug('memberId@@ ' + memberId + ' @@memberDOB@@ ' + memberDOB + ' @@@firstName ' + firstName + ' @@lastName@@ ' + lastName + ' @@groupNumber@@ ' 
        + groupNumber + ' @@searchOption@@ ' + searchOption + ' @@payerID@@ ' + payerID);
        return SAEProviderSearch.findMembers(memberId, memberDOB, firstName, lastName, groupNumber, searchOption, payerID,providerFN,providerLN,providerNPI,providerFlow);
    }
    
    @AuraEnabled
    public static List<State__mdt> getStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        return stateList;
    }

}