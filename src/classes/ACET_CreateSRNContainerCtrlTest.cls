@isTest
public class ACET_CreateSRNContainerCtrlTest {

    static testMethod void testMethod1() {
        
        List<Spire_Auth_Entry_Grid__mdt> spireGrid=ACET_CreateSRNContainerCtrl.getAuthGridData();
        system.assertNotEquals(null, spireGrid);
    }
}