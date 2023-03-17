@isTest
public class PolicyNumberutilTest {
    static testmethod void getTTSFilterTest1(){
        test.starttest();
        PolicyNumberutil.validatePolicyNumber('703352');
         PolicyNumberutil.validatePolicyNumber('500200');
        test.stoptest();
    }
}