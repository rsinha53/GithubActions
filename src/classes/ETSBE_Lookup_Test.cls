@isTest
public class ETSBE_Lookup_Test {
    static testmethod void lookupMethod(){
        ETSBE_LookupContrl.fetchLookUpValues('test','User');
    }
}