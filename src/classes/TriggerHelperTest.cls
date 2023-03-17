@isTest
public class TriggerHelperTest {
	@istest()
    static void HelperTest(){  
        TriggerHelper.isDupExist('Test');
        TriggerHelper.isSync();
        quickAccessController qc = new quickAccessController();
        qc.QuickLinksList = new List<QuickLinks>();
    }
}