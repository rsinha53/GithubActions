@IsTest
public class ACETLGT_GlobalAutocompleteBoxTest {
    public testmethod static void test(){
        ACETLGT_GlobalAutocompleteBoxCtrl.fetchLookUpValues('','Account',new List<sObject>{new Account()},'','');
    }
}