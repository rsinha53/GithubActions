@isTest(seealldata=true)
public class ACETLGT_caseHistoryTest {
    public static testMethod void caseHistoryTestMethod() {
        case ca = TestDataFactory.createCaseandCaseItem();
        string caseidstring = String.valueOf(ca.id);
        ACETLGT_caseHistory.getCaseHistoryResults('stringsrk123');
        ACETLGT_caseHistory.getCaseComments(ca.id);
        ACETLGT_caseHistory.getCommentResults(caseidstring);
        ACETLGT_caseHistory.getExternalId(ca.id);
    }
     public static testMethod void caseHistoryTestMethodOne() {
        case ca = TestDataFactory.createCaseandCaseItem();
        string caseidstring = String.valueOf(ca.id);
        ACETLGT_caseHistory.getCaseHistoryResults('string,srk123');
        ACETLGT_caseHistory.getCaseComments(ca.id);
        ACETLGT_caseHistory.getCommentResults(caseidstring);
        ACETLGT_caseHistory.getExternalId(ca.id);
    }
      public static testMethod void ACETLGT_QuickLinksTestMethod() {
        ACETLGT_QuickLinks.CIRRUSURL='CIRRUSURLstr';
       
        
    }

}