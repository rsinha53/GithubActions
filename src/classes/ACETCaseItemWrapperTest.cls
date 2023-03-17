@isTest
public class ACETCaseItemWrapperTest{

    testmethod static void Test(){
        ACETCaseItemWrapper objCont = new ACETCaseItemWrapper();
        objCont.isresolved =false;
        objCont.isunresolved =True;
        objCont.keyfieldId ='';
        objCont.topic ='';
        objCont.caseobj = new Case();
    }
}