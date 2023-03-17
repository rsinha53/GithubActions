@isTest
public class PersonAccountWizardTest {
	@isTest
    public static void getPicklistTest() {
        Map<String,String> picklistVal = PersonAccountWizard.getPicklist();
    }
    @isTest
    public static void personAccountSaveTest() {
        String accData = '[{"firstname":"Charlies child 8","lastname":"Shein 8","DOB":"2022-05-24","relationship":"Subscriber/Recipient"},{"firstname":"Charlie 3","lastname":"Shein 4","DOB":"2022-05-12","relationship":"Non-Policy Caregiver"}]';
        string fname = 'test';
        String lname = 'lastName';
        String dbirth = '2022-05-24';
        String em = 'test@test.com';
        String mid = '2983672';
        String pid = '83729833';
        String acid = PersonAccountWizard.personAccountSave(accData,fname,lname, dbirth, em, mid, pid);
}
}