({ 
     fetchMockStatus : function(component) { 
        let action = component.get("c.getMockStatus");
        action.setCallback( this, function(response) {
            let state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.isMockEnabled", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sendRequest : function(component, methodName, params ){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get(methodName);
            console.log(params);
            action.setParams(params);
            action.setCallback(self, function(res) {
                var state = res.getState();
                if(state === 'SUCCESS') {
                    resolve(res.getReturnValue());
                    //var responseRecords=res.getReturnValue();
                    //console.log('responseRecords==='+res.getReturnValue());
                } else if(state === 'ERROR') {
                    reject(action.getError())
                }
            });
            $A.enqueueAction(action);
        }));
        
    },
    navigateTab :  function(component, methodName, params ){
       
        debugger;
        var custmrAdmininfo = component.get("v.originatorSelected");
         if(custmrAdmininfo.Originator_Type__c == 'Other Originator'){
             component.set("v.originatorText",custmrAdmininfo.Other_Originator_Type__c + '   ' + custmrAdmininfo.Last_Name__c + ', ' + custmrAdmininfo.First_Name__c + '   ' + custmrAdmininfo.Phone_Number__c + '   ' + custmrAdmininfo.Email__c);
         }
        else {
            component.set("v.originatorText",custmrAdmininfo.Originator_Type__c + '   ' + custmrAdmininfo.Last_Name__c + ', ' + custmrAdmininfo.Phone_Number__c + '   ' + custmrAdmininfo.Email__c);
        }
         if(custmrAdmininfo == null || custmrAdmininfo == undefined){
            custmrAdmininfo = {"adminType":"Member"};
            console.log('HERE IS CUSTOMER ADMIN FOR PASSING2: ' + JSON.stringify(custmrAdmininfo));
        }
        var groupinfo = component.get("v.groupSelected");
        
        var producerinfo = '';

        var tabName='';
        
        if(!$A.util.isUndefinedOrNull(component.get("v.producerSelected")) && !$A.util.isEmpty(component.get("v.producerSelected"))){
				producerinfo      =       component.get("v.producerSelected");
                 component.set("v.displayProducer",true);
             }else{
                  component.set("v.displayProducer",false);
             }
                       /* if(!$A.util.isUndefinedOrNull(producerinfo) && !$A.util.isEmpty(producerinfo)){
                            if(producerinfo.producerCompanyName != '') {
                                component.set('v.TabName', producerinfo.producerCompanyName.toUpperCase());
                            }else{
                                component.set('v.TabName', producerinfo.producerIndividualName.lastName.toUpperCase());   
                            }
                            
                        } */
        				var prodinfo = component.get("v.producerSelected");
        if(prodinfo == null){
            prodinfo = '';
        }
        				var membResinfo = component.get("v.memberSelected");
      
        if(membResinfo == null){
            membResinfo = '';
        }
        				if(!$A.util.isUndefinedOrNull(prodinfo) && !$A.util.isEmpty(prodinfo) && component.get("v.FlowType") == 'Producer'){
                            
                            if(prodinfo.producerCompanyName != '') {
                                component.set('v.TabName', prodinfo.producerCompanyName);
                            }else{
                                component.set('v.TabName', prodinfo.producerIndividualName.lastName);   
                            }
                        }
        if(groupinfo.groupId == null){
            groupinfo = undefined;
        }
                        if(!$A.util.isUndefinedOrNull(groupinfo) && !$A.util.isEmpty(groupinfo) && component.get("v.FlowType") == 'Group/Employer'){
                            component.set('v.TabName', groupinfo.groupName.toUpperCase());
                        } 
                         if(!$A.util.isUndefinedOrNull(membResinfo) && !$A.util.isEmpty(membResinfo)&& component.get("v.FlowType") == 'Member'){
                            component.set('v.TabName', membResinfo.lastName);
                        }
        //('k'+membResinfo.lastName);
                        /*if(!$A.util.isUndefinedOrNull(memberResultinfo) && !$A.util.isEmpty(memberResultinfo)){
                            component.set('v.TabName', memberResultinfo.lastName.toUpperCase());
                        }*/
        var typeText = component.get('v.originatorText');
        typeText = typeText.trim();
         var isMember = '';
        if(typeText.toLowerCase() == 'member'){
            isMember = "Member";
            custmrAdmininfo = {"Originator_Type__c":"Member"};
        }
        //(custmrAdmininfo);
         var workspaceAPI = component.find("workspace");
         workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_GeneralInfo"
                },
                "state": {
                    "c__MemberInfo" : membResinfo,
                    "c__AdminInfo" : custmrAdmininfo,
                    "c__ContactId": component.get("v.ContactId"),
                    "c__GroupInfo": groupinfo,
                    "c__InteractionRecord": component.get("v.instructions"),
                    "c__searchType":component.get("v.FlowType"),
                    "c__ProducerInfo" :prodinfo,
                    "c__AdminType":isMember,
                    "c__isMockEnabled":component.get("v.isMockEnabled"),
                    "c__disableTopic":true
                    
                   
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label:component.get('v.TabName')
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
                
            });          
            
        }); 
    }
    
    
})