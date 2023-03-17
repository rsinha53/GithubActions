({  
    doInit: function(component, event, helper){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var caseRecords;
        var brokerId;
        var originatorEmail;
        var originatorType;
        var rewardAccno;
         helper.fetchMockStatus(component);
        var params={caseId : component.get('v.recordId')};
         var flowType = '';
        helper.sendRequest(component,'c.getCaseInfoMethod',params).       
        then($A.getCallback(function(records) {
            
            brokerId=records.Broker_ID__c;
            originatorEmail=records.OriginatorEmail__c;
            originatorType=records.Originator_Type__c;
            rewardAccno=records.Reward_Account_Number__c;
            component.set("v.caseData",records);
            
           
            flowType = records.Subject_Type__c;
            //(flowType);
             component.set("v.FlowType",flowType);
            if(flowType == 'Group/Employer'){
                component.set("v.DisplayType",'Group');
            }else{
                 component.set("v.DisplayType",flowType);
            }
            //Set member Details
            var sourceCode='';
            var Name='';
            var DOB='';
            var firstName='';
            var lastName='';
            var memberID='';
            var searchOption='';
            var SSN='';
            var tabName='';
            
            var  memberResultinfo= {
                "sourceCode":records.SourceCode__c,
                "Name":records.Contact.Name,
                "DOB":records.DOB__c,
                "firstName":records.Contact.FirstName,
                "lastName": records.Contact.LastName,
                "memberID":records.ID__c,
                "searchOption":'MemberIDDateOfBirth',
                "SSN":records.Member_SSN__c
            };
            component.set("v.ContactId",records.Contact.Id); 
            if(records.Subject_Type__c == 'Member')
            component.set("v.memberSelected",memberResultinfo);
            
            tabName=records.Contact.Name; 
            
            //Set Special Instructions 
            var resolution = '';                   
            var businessUnit = '';
            var issueCategory = ''; 
            var specialInstructionsInfo = {                                             
                "resolution":records.Special_Instructions_Description__c,
                "businessUnit":records.Special_Instructions_Business_Unit__c,
                "issueCategory":records.Issue_Category_Desc__c
            };
            
            component.set("v.SpecialInstructionsInfo",specialInstructionsInfo);
            
            
            
            //Set Instruction Record
            var id='';
            var Interaction_Type__c='';
            var Name='';
            var Originator_Name__c='';
            var Current_Status__c='';                
            var storeResponse= {                                                          
                "Id":records.Interaction__r.Id,
                "Interaction_Type__c":records.Interaction__r.Interaction_Type__c,
                "Name":records.Interaction__r.Name,
                "Originator_Name__c":records.Interaction__r.Originator_Name__c,
                "Current_Status__c":records.Interaction__r.Current_Status__c
            };
            component.set("v.instructions",storeResponse);
            
            
            //Set contact
            var conId=records.ContactId;
            console.log('conId=='+conId);
            component.set("v.ContactId",conId);             
            
            var params={ "groupId": records.Subject_Group_ID__c,  caseId: records.Id };            
            return helper.sendRequest(component,'c.getSelectedGroupInfo',params);    
            
        }))
        
        .then($A.getCallback(function(records) {
            
            
            component.set("v.groupSelected",JSON.parse(records));
            
            
            var params={ caseId : component.get('v.recordId') };
            
            
         
                return helper.sendRequest(component,'c.fetchOriginatorRecord',params);   
            
             
        }))
        
        .then($A.getCallback(function(records) {
           
            component.set("v.originatorSelected",records);
            
            
            
            if(brokerId!=null || brokerId !=undefined){
                var params={ "producerId" : brokerId };           
                return helper.sendRequest(component,'c.searchBroker',params);
            }
            
            
        }))
        
        .then($A.getCallback(function(records) {

            if(records !=undefined){
            var brokerVar = JSON.parse(records);
            component.set('v.producerSelected',brokerVar[0]);
            }
            helper.navigateTab(component,event,helper);
        }))
        
        .catch(function(errors) {
            console.error('ERROR: ' + errors.message);
        });
        
        
        //Set Tab/Flow Type
       
       
    }
    
    
})