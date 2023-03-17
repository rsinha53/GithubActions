public with sharing class SAECaseCommentTriggerHandler {
     
    public static void handleBeforeInsert(List<CaseComment> caseCommentList){
        string department='';
        string casetype='';
        Set<Id> parentCase=new Set<Id>();
        Map<Id,Case> mapCase=new Map<Id,Case>();
        String profileName;
        Id profileId= userinfo.getProfileId();
        // Added below if condition to skip the query exception for SF Connection user
        String loggeduser = Userinfo.getFirstName()+' '+Userinfo.getLastName();
        
        if(loggeduser!=null && loggeduser!='Connection User'){
            profileName=[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
        }
        system.debug('ProfileName: '+profileName);
        
        for (CaseComment t: caseCommentList)
        {
            parentCase.add(t.ParentId);
        }
        
        List<Case> lstCase=[Select Id,Case_Type__c, Department__c ,RecordType.Name from case where Id in :parentCase ];
        
        Integer countCasecomment=[select count() from caseComment where parentid IN :parentCase];
        
        for(case c: lstCase){    
            mapCase.put(c.Id,c);
            casetype=c.Case_Type__c;
            department=c.Department__c;
        } 
        
        for(CaseComment t: caseCommentList){      
            if(mapCase.containskey(t.ParentId)){           
                if((mapCase.get(t.ParentId).RecordType.Name =='SAE Provider'  || mapCase.get(t.ParentId).RecordType.Name =='SAE Provider Closed') && profileName != 'Provider Service')
                {
                    t.addError('Case comments on SAE cases are not allowed to be added by non SAE users.');       
                }
            }   
            /*************Insert Case Comment:US2799435************/
            if(casetype!=null && department!=null){
                if(loggeduser!='Connection User'){
                    if(countCasecomment==0 && casetype=='BEO Case' && (department.containsIgnoreCase('OptumRx PSS') || department.containsIgnoreCase('Client Advocate'))){
                        t.addError('Case Comments cannot be added as Optum Rx validation is pending');
                    }
                }            
            }
            /*************Update published field:US2624661************/
            /* 2020_09_11 commented out by Jacob Wagoner to revert commit 7fcc8a100e4303a84bea1adad35d72ca4503175f, US2624661 not deploying 2020_09_15
            if(casetype=='BEO Case' && t.IsPublished!=true){
                t.IsPublished=true;
            } 
            */           
        }
    }
}