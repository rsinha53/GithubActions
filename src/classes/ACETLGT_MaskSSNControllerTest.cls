@isTest
public class ACETLGT_MaskSSNControllerTest {
    @IsTest
    Public static void LightningMisdirectedMethod()
    {
		Test.startTest();
        ACETLGT_MaskSSNController am = new ACETLGT_MaskSSNController();
        ACETLGT_MaskSSNController.insertEventLog('Member Detail','SSN','12345678901','888776666');
		Test.stopTest();
    }
}