/********************************************************************************* 
Class Name     : HSIDUserRegistrationHandlerTest.cls
Description    : created Test class for HSIDUserRegistrationHandler
Created By     : Venkata Mounika Ravipudi 
Created Date   : 14/10/2022

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            

*********************************************************************************/
@isTest
public class HSIDUserRegistrationHandlerTest {    
    
    static testMethod void Method1(){
        Test.startTest();
        map<String,String> provMap = new map<String,String>();
        contact c= new contact(LastName='sss');
        insert c;        
        provMap.put('personcontact',c.Id);
        
        Auth.UserData au= new Auth.UserData(c.Id,null,Null,NUll,'ttr@gmail.com',Null,'abcdefgha',Null,Null,Null,provMap);
        HSIDUserRegistrationHandler hs= new HSIDUserRegistrationHandler();
        hs.updateUser(c.Id,c.Id, au);
        hs.createUser(c.Id, au);
        Test.stopTest();
    }
}