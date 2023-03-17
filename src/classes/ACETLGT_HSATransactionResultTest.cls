@IsTest
public class ACETLGT_HSATransactionResultTest {
    public testmethod static void test(){
        ACETLGT_HSATransactionResult htr = new ACETLGT_HSATransactionResult();
        System.debug(htr.amount);
        System.debug(htr.status);
        System.debug(htr.transactionType);
        System.debug(htr.description);
        System.debug(htr.transactionDate);
    }

}