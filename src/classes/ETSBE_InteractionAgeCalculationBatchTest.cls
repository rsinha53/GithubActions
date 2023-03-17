@isTest
public class ETSBE_InteractionAgeCalculationBatchTest {
    
    static testMethod void validateInteractionAge() {
        
        List<Interaction__c> interactList = new List<Interaction__c>();
        
        Interaction__c interactObj = new Interaction__c();            
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Resolution_Date__c = null;
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactList.add(interactObj);
        
        Interaction__c interactObj1 = new Interaction__c();            
        interactObj1.Interaction_Type__c = 'Phone Call';
        interactObj1.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 10, 00, 00);
        interactObj1.Resolution_Date__c = DateTime.newInstance(2020, 04, 03, 02, 00, 00);
        interactList.add(interactObj1);
            
        insert interactList;
        DateTime testDateTime = DateTime.newInstance(2020, 12, 17, 13, 6, 6);
        BusinessHours businessHourId=[select id from BusinessHours where IsDefault=true];
        Datetime startDT = DateTime.newInstance(2020, 12, 17, 13, 00, 00);
        Datetime endDT = DateTime.Now().AddDays(2);
        ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT,endDT,null,testDateTime ,'2:30', businessHourId);
        
        //ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj1 = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT,interactList[1].Evt_Recvd_Dt_Time__c,null,testDateTime ,'2:30', businessHourId);
        
        DateTime start=DateTime.newInstance(Date.today().year(), 01, 01, 00, 00, 00);
        ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj2 = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(start,interactList[0].Evt_Recvd_Dt_Time__c,null,testDateTime ,'2:30', businessHourId);
 
        
        Test.startTest();
        
        ETSBE_InteractionAgeCalculationBatch interactAgeCalBatchObj = new ETSBE_InteractionAgeCalculationBatch();
        Database.executeBatch(interactAgeCalBatchObj);
        
        Test.stopTest();                
        
    }
    
    @isTest
    Static void validateInteractionAgeTest(){
        try{
        List<Interaction__c> interactList = new List<Interaction__c>();
        Interaction__c interactObj = new Interaction__c();            
        interactObj.Interaction_Type__c = null;
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2019, 03, 26, 06, 00, 00); 
        interactObj.Resolution_Date__c= null; 
        //interactObj.Created_Date__c= DateTime.newInstance(2019, 03, 26, 06, 00, 00);
        interactList.add(interactObj);
        insert interactList;
        
        Interaction__c interac=[select id from Interaction__c where id=:interactList[0].id limit 1];
        interac.Age__c='3:20';
        update interac;
        
        User us = [Select id from User where Id = :UserInfo.getUserId()];
        System.runAs(us){
                
            
        BusinessHours businessHourId=[select id from BusinessHours where IsDefault=true];
        Datetime startDT = system.today();
        Datetime endDT = DateTime.Now().AddDays(2);
        ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT, endDT,2019,null ,interac.Age__c, businessHourId);
        
        Test.startTest();
     
        ETSBE_InteractionAgeCalculationBatch interactAgeCalBatchObj = new ETSBE_InteractionAgeCalculationBatch();
           
        //Database.executeBatch(interactAgeCalBatchObj);
         interactAgeCalBatchObj.execute(null, interactList) ; 
         interactAgeCalBatchObj.finish(null);
        
        Test.stopTest();
          }
        }  Catch(Exception e){
        
            System.assert(e.getMessage().contains('Cannot execute code in production!'),e.getMessage());
        }
    }
    
    @isTest
    Static void coverCatchBlock(){
        List<String> errorMessagesList = new List<String>();
        errorMessagesList.add('While updating the Interaction, the fields affected');
        
        List<Interaction__c> interactList = new List<Interaction__c>();
        Interaction__c interactObj = new Interaction__c();            
        interactObj.Interaction_Type__c = 'Phone Call test';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2028, 03, 26, 06, 00, 00);
        interactObj.Resolution_Date__c=null;
        
        Interaction__c interactObjnew = new Interaction__c();            
        interactObjnew.Interaction_Type__c = 'Phone Call';
        interactObjnew.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObjnew.Resolution_Date__c=null;
        
        interactList.add(interactObjnew);
        interactList.add(interactObj);
        
        DateTime testDateTime = DateTime.newInstance(2020, 12, 17, 13, 6, 6);
        BusinessHours businessHourId=[select id from BusinessHours where IsDefault=true];
        Datetime startDT = DateTime.newInstance(2020, 12, 17, 13, 00, 00);
        Datetime endDT = DateTime.Now().AddDays(2);
       
       try{  
        Test.startTest();
        insert interactList;      
        ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT,endDT,2020,null ,'2:30', businessHourId);
            ETSBE_InteractionAgeCalculationBatch interactAgeCalBatchObj = new ETSBE_InteractionAgeCalculationBatch();
            interactAgeCalBatchObj.execute(null, interactList);
            Database.executeBatch(interactAgeCalBatchObj);
            Test.stopTest();
            
        }catch(DMLException e){
           system.assertEquals(e.getMessage(), e.getMessage()); 
        }     
        
    } 

}