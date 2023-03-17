trigger DO_Advisor_Assignment on DigitalOnboardingAdvisorAssignment__c (before insert, before update,after delete) {
    if(Trigger.isInsert || Trigger.isUpdate){
        for(DigitalOnboardingAdvisorAssignment__c doa: trigger.new){
            doa.User_Id__c = doa.Name__c;
        } 
    }
    if(Trigger.isDelete){
        integer i = 0;
        list<DigitalOnboardingAdvisorAssignment__c> listdoa = [select name, name__c from DigitalOnboardingAdvisorAssignment__c order by name asc];
        Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
        if(listdoa.size()>0){ 
            if(roundRobin!=null && roundRobin.Last_Assigned_Advisor__c!=''&& roundRobin.Last_Assigned_Advisor__c!=null){
                for(DigitalOnboardingAdvisorAssignment__c doa: trigger.old){
                    if(roundRobin.Last_Assigned_Advisor__c == doa.Name){
                        if(listdoa.size()==1){
                            if(roundRobin.Last_Assigned_Advisor__c>listdoa[0].Name){  
                                roundRobin.Last_Assigned_Advisor__c=listdoa[0].Name;
                            }else{
                                roundRobin.Last_Assigned_Advisor__c='';
                            }
                            update roundRobin;
                        }else{
                            for(DigitalOnboardingAdvisorAssignment__c mainDOA:listdoa){
                                i+=1;
                                if(roundRobin.Last_Assigned_Advisor__c>mainDOA.name){
                                    if(listdoa.size()==i){
                                        roundRobin.Last_Assigned_Advisor__c=mainDOA.name;
                                        break;
                                    }
                                }else{
                                    if(i==1){
                                       roundRobin.Last_Assigned_Advisor__c=listdoa[listdoa.size()-1].name; 
                                       break; 
                                    }else{
                                       roundRobin.Last_Assigned_Advisor__c=listdoa[i-2].name; 
                                       break;
                                    }
                                }
                            }
                            update roundRobin;
                        }
                    }
                }
            }
        }else{
            roundRobin.Last_Assigned_Advisor__c='';
            update roundRobin;
        }
    }
}