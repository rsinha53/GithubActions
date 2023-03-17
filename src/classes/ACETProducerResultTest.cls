@isTest(SeeAllData=false)
public class ACETProducerResultTest
{
   static testMethod void ACETProducerResultTesttMethod() 
    {    
        Interaction__c interaction = new Interaction__c();
        Contact procontact = new Contact();   
        ACETProducerResult producerResult = new ACETProducerResult();
        producerResult.Interaction = interaction;
       // producerResult.EmailAdd = 'sample@gmail.com';
        producerResult.Subject = procontact;
        producerResult.tax_SSN = '1234567';
        producerResult.tax_id = '12-123';
        producerResult.primaryContactName = 'Test contact';
       // producerResult.phoneNum = '1234567891';
        producerResult.taxSSNType = 'TIN';
        producerResult.effectiveStartDate = '1-2-1017';
       // producerResult.faxNumber = '900-900-1234';
        producerResult.groupName = 'Employee and Broker';
        producerResult.CompanyName = 'Broker';
        producerResult.contactType = 'indivisual';
        producerResult.interactionId = '1234562345';
        producerResult.Id = '00112345';
       // producerResult.Subject = 'Broker';
        producerResult.firstName = 'JIM';
        producerResult.lastname = 'Hieath';
        producerResult.MiddleInitial = 'ken';
        producerResult.producerId = 'ProID';
        producerResult.ProducerType = 'indivisual';
        producerResult.legacyBrokerCode = 'Message';
        producerResult.type = 'Billing';
        producerResult.producerEffectiveStartDate = '1/1/2017';
        producerResult.producerEffectiveEndDate = '1/1/2018';
    }    
    
     static testMethod void ACETProducerResultTesttMethod1() 
        {
        
            Interaction__c interaction = new Interaction__c();
            Contact procontact = new Contact();   
            ACETProducerResult producerResult = new ACETProducerResult();
        
            ACETProducerResult.ACETProducerDemography adress = new ACETProducerResult.ACETProducerDemography();
            adress.addressType = 'm';
            adress.streetAddress = 'test address';
            adress.city = 'test city';
            adress.state = 'test state';
            adress.zip = 'test zip';
            adress.phone = '123456789';
            adress.country = 'US';
            producerResult.addressInfo = adress;
            list<ACETProducerResult.ACETProducerDemography> addrlst = new list<ACETProducerResult.ACETProducerDemography>();
            addrlst.add(adress);
            producerResult.addresslist = addrlst;
        }  
        
       
}