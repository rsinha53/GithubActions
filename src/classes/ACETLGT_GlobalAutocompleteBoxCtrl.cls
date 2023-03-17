public class ACETLGT_GlobalAutocompleteBoxCtrl {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList, string detailpagename, string originatortype) {        
        system.debug('-----In Controller---->'+detailpagename+ searchKeyWord + '<----->'+ObjectName+'<------>'+ExcludeitemsList);
        String searchKey = '%' + searchKeyWord + '%';
 
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        
        List<sObject> topics = ACETCallTopicsPicklistUtility.getCallTopics(detailpagename , 'Member', lstExcludeitems, searchKey);
        System.debug('topics : ' + topics.size());

        return topics;
    }
}