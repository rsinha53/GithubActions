@isTest
public class ACET_FAST_TeamMemberListViewTest {
    @isTest
    public static void getListView()
    {
        List<String> objectNames = new List<String>{'Case','Task'};
         ACET_FAST_TeamMemberListViewController.listValues(objectNames);
       
    }

}