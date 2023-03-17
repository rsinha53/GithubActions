//Created By:Sumit
@isTest
public class ACETStateControllerTTest{
 
 @isTest
 static void testData(){
  ACETStateController objstate = new ACETStateController ();
  objstate.getStateOptions();
  objstate.state = 'test';
 }
}