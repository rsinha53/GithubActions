public class ACETLGT_ThirdPartyContactsController {


    @AuraEnabled
    public static Boolean setInteractions(string intId, string tpId){

        system.debug('intID ::: '+intId+ ' :: tpId :: '+tpId);
        Boolean isSuccess = false;
        Interaction__c intRec = [Select Id, Name, Third_Party__c, Originator__c From Interaction__c Where Id=: intId];
        if (intRec != null){
            intRec.Third_Party__c = tpId;
            intRec.Originator__c = NULL;
            upsert intRec;

            if (intRec != null)
                isSuccess = true;                
        }       

        return isSuccess;

    }

    @AuraEnabled
    public static List<Third_Party_Originator__c> queryThirdParties(String SubjectId){   
        system.debug('---3.1-->subj'+ SubjectId);
        List<Third_Party_Originator__c> TPOriginatorList = [select id,Third_Party__r.id,Third_Party__r.LastName__c,Third_Party__r.First_Name__c,Third_Party__r.FullName__c,Third_Party__r.Phone_Number__c , Name, Third_Party__r.Tax_ID__c,Third_Party__r.Group_Name__c, Third_Party__r.Other_Originator__c, Other_Originator__c  from Third_Party_Originator__c where Subject__c =:SubjectId ORDER BY Third_Party__r.Lastmodifieddate DESC ];
        system.debug('---3.2-->'+ TPOriginatorList);
        return TPOriginatorList;
        
    }
    
    @AuraEnabled
    public static List<Third_Party_Originator__c> addNewThirdParty(String FirstName, String LastName, String originatortype,string PhoneNum, String GroupName, string SubjectId, string InteractionId, string tdId){        
        system.debug('---3.3-->'+ FirstName+'----->'+ LastName+'----->'+ originatortype+ '------>'+PhoneNum+'--->'+SubjectId+'--->'+InteractionId+':: '+tdId);
        
        if (tdId != null && tdId != ''){
            
            List<Third_Party__c> tprecs = [select first_name__c, Lastname__c, Phone_Number__c, Group_Name__c, FullName__c, Other_Originator__c from Third_Party__c where Id=: tdId limit 1];
            if (!tprecs.isEmpty()){
                Third_Party__c tprec =tprecs[0];
                tprec.First_Name__c = FirstName;
                tprec.LastName__c = LastName;
                tprec.Other_Originator__c = originatortype;
                tprec.Phone_Number__c = PhoneNum;
                tprec.Group_Name__c = GroupName;
                tprec.FullName__c = FirstName + ' '+ LastName;
                
                upsert tprec;
            }

            
        }else{
            Third_Party__c newThirdParty = new Third_Party__c();
            newThirdParty.first_name__c = FirstName;
            newThirdParty.Lastname__c = LastName;
            newThirdParty.Phone_Number__c  =  PhoneNum;
            newThirdParty.Group_Name__c = GroupName;
            newThirdParty.FullName__c =   FirstName + ' '+ LastName  ;
            //Using this to associate with Case and Third Party
            newThirdParty.Other_Originator__c = originatortype;
            insert newThirdParty;
    
            system.debug('---3.4-->'+ newThirdParty);
            Third_Party_Originator__c TPOriginator= new Third_Party_Originator__c();
            TPOriginator.Subject__c =SubjectId;
            TPOriginator.Third_Party__c = newThirdParty.Id;
            TPOriginator.third_party__r = newThirdParty;
            
            system.debug('---3.5-->'+ newThirdParty.Id);
            //Third_Party__c tpRec = [Select Id, Name From Third_Party__c Where Id=:newThirdParty.Id];
            //system.debug('tpRec :: '+tpRec.Id);
            TPOriginator.Name = originatortype;
            TPOriginator.Other_Originator__c = originatortype;
    
            insert TPOriginator;
    
            system.debug('---3.5-->'+ TPOriginator);
        }
        
        
        List<Third_Party_Originator__c> TPOriginatorList = [select id,Third_Party__r.id,Third_Party__r.LastName__c,Third_Party__r.First_Name__c,Third_Party__r.FullName__c,Third_Party__r.Phone_Number__c , Name, Third_Party__r.Tax_ID__c,Third_Party__r.Group_Name__c,Third_Party__r.Other_Originator__c, Other_Originator__c from Third_Party_Originator__c where Subject__c =:SubjectId ORDER BY Third_Party__r.Lastmodifieddate DESC ];
        system.debug('---3.6-->'+ TPOriginatorList);

        //Set Third Party info to Interaction        
        //Interaction__c IntRecord = [Select Id, Name, Third_Party__c From Interaction__c Where Id =:InteractionId];
        
        return TPOriginatorList;
        
    }
    
    @AuraEnabled
    public static List<Map<String,String>> getOtherOriginatorPicklistValues(String objectName, String fieldName){
        List<Map<String,String>> originatorList = new List<Map<String,String>>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(fieldName).getDescribe().getPickListValues();
        originatorList.add(new Map<String, String>{'value' => '', 'label' => '--None--'});       
        for (Schema.PicklistEntry pv : picklistValues) {           
                   
            originatorList.add(new Map<String, String>{'value' => pv.getValue(), 'label' => pv.getLabel()});
        }
        
        return originatorList;
    }
}