({
    doInit : function(cmp, event, helper) {
        helper.fetchMockStatus(cmp);
        cmp.set("v.adminType",cmp.get("v.pageReference").state.c__AdminType);
        cmp.set("v.CustmrAdmin",cmp.get("v.pageReference").state.c__AdminInfo);
        cmp.set("v.ProducerInfo",cmp.get("v.pageReference").state.c__ProducerInfo);
        cmp.set("v.FlowType",cmp.get("v.pageReference").state.c__FlowType);
        cmp.set("v.uhgAccess",cmp.get("v.pageReference").state.c__UHGRestricted);
        cmp.set("v.ContactId",cmp.get("v.pageReference").state.c__ContactId);
        cmp.set("v.selectedGroupInfo",cmp.get("v.pageReference").state.c__GroupInfo); 
        cmp.set("v.selectedMemberInfo",cmp.get("v.pageReference").state.c__MemberInfo);
        cmp.set("v.updateCaseInfo",cmp.get("v.pageReference").state.c__UpdateCaseInfo);
        cmp.set("v.isMockEnabled",cmp.get("v.pageReference").state.c__isMockEnabled);
        cmp.set("v.disableTopic",cmp.get("v.pageReference").state.c__disableTopic);
        
        console.log(cmp.get("v.selectedMemberInfo"));
        var SubjectData ;
 var producerid='';
            var groupid ='';
        if( cmp.get("v.adminType") == 'Member'){
            cmp.set("v.SearchType","Member");
        }
        if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedMemberInfo"))
           && $A.util.isEmpty(cmp.get("v.selectedMemberInfo")) == false){
             SubjectData = cmp.get("v.selectedMemberInfo");
            cmp.set("v.memberTabId", SubjectData.memberID);
            
             cmp.set("v.memberId", SubjectData.memberID);
            cmp.set("v.memberFN", SubjectData.firstName);
             cmp.set("v.memberLN", SubjectData.lastName);
              if (!$A.util.isEmpty(SubjectData.DOB)) {
            	var dobMem = SubjectData.DOB.split('/');
            	cmp.set("v.xRefId", SubjectData.firstName+SubjectData.lastName +SubjectData.DOB+ SubjectData.memberID);
              }
         
            helper.processMemberData(cmp, event, helper);
            helper.processSubjectCardData(cmp, event, helper);
            cmp.set("v.SearchType","Member");
            
           
             if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedGroupInfo"))){
                 cmp.set("v.displayGroup",true);
                 groupid = cmp.get("v.selectedGroupInfo").groupId;
                 cmp.set("v.groupId",groupid);
             }
            else{
                  cmp.set("v.displayGroup",false);
             }
             if(!$A.util.isUndefinedOrNull(cmp.get("v.ProducerInfo")) && !$A.util.isEmpty(cmp.get("v.ProducerInfo"))){
				cmp.set('v.ProducerId', cmp.get('v.ProducerInfo').producerID);
                 producerid = cmp.get('v.ProducerInfo').producerID;
                 helper.handleProducerData(cmp,event);
                 cmp.set("v.displayProducer",true);
             }else{
                  cmp.set("v.displayProducer",false);
             }
            
            
             helper.getMemberCaseHistory(cmp,producerid,groupid,SubjectData.memberID,cmp.get("v.xRefId"),cmp.get("v.SearchType"));

            
        }
        if(($A.util.isUndefinedOrNull(cmp.get("v.selectedMemberInfo")) == true
            || $A.util.isEmpty(cmp.get("v.selectedMemberInfo")) == true)
           && !$A.util.isUndefinedOrNull(cmp.get("v.selectedGroupInfo"))){
             var groupdata = cmp.get("v.selectedGroupInfo");
            cmp.set("v.SearchType","Group");
            cmp.set("v.groupId",groupdata.groupId);
            cmp.set("v.xRefId",groupdata.groupId);
            
            if(!$A.util.isUndefinedOrNull(cmp.get("v.ProducerInfo")) && !$A.util.isEmpty(cmp.get("v.ProducerInfo"))){
                cmp.set('v.ProducerId', cmp.get('v.ProducerInfo').producerID);
                
            	helper.getMemberCaseHistory(cmp,cmp.get('v.ProducerInfo').producerID,groupdata.groupId,'',cmp.get("v.xRefId"),cmp.get("v.SearchType"));
                helper.handleProducerData(cmp,event);
                 cmp.set("v.displayGroupProducer",true);
                cmp.set("v.displayProducer",true);
            }else{
                helper.getMemberCaseHistory(cmp,'',groupdata.groupId,'',cmp.get("v.xRefId"),cmp.get("v.SearchType"));
                cmp.set("v.displayProducer",false);
            }
        }
        if(!$A.util.isUndefinedOrNull(cmp.get("v.ProducerInfo"))
          && $A.util.isUndefinedOrNull(cmp.get("v.selectedGroupInfo")) == true
          && ($A.util.isUndefinedOrNull(cmp.get("v.selectedMemberInfo")) == true
            || $A.util.isEmpty(cmp.get("v.selectedMemberInfo")) == true)){
             cmp.set("v.SearchType","Producer");
            console.log(cmp.get("v.ProducerInfo").ProducerID);
            cmp.set("v.xRefId", cmp.get('v.ProducerInfo').producerID);
            cmp.set('v.ProducerId', cmp.get('v.ProducerInfo').producerID);
             helper.getMemberCaseHistory(cmp,cmp.get('v.ProducerInfo').producerID,'','',cmp.get("v.xRefId"),cmp.get("v.SearchType"));
            helper.handleProducerData(cmp,event);
           console.log('testtststs');
            //cmp.set("v.ProducerId" ,cmp.get("v.ProducerInfo").ProducerID);
        }
       
        if(!$A.util.isUndefinedOrNull(cmp.get("v.pageReference").state.c__InteractionRecord)){
            cmp.set("v.interactionRec",cmp.get("v.pageReference").state.c__InteractionRecord);
        }
        if(!$A.util.isUndefinedOrNull(cmp.get("v.pageReference").state.c__SpecialInstructionInfo)){
        	cmp.set("v.specialInstructionsInfo",cmp.get("v.pageReference").state.c__SpecialInstructionInfo);
        }
        if(!$A.util.isUndefinedOrNull(cmp.get("v.pageReference").state.c__isHouseHoldMemClicked)){
        	cmp.set("v.isHouseHoldMemClicked",cmp.get("v.pageReference").state.c__isHouseHoldMemClicked);
        }        
        var custObj = cmp.get("v.CustmrAdmin");
        var intObj = cmp.get("v.interactionRec");
        var memObj = cmp.get("v.selectedMemberInfo");
        if(custObj.Originator_Type__c == "Member"){
            console.log('Is Member');
            var intMemberInfo = {
                "interactionId":intObj.Id,
                "firstName":memObj.firstName,
                "lastName":memObj.lastName,
                "DOB":memObj.DOB,
                "phoneNumber":"",
                "email":"",
                "memberId":memObj.memberID,
                "groupId":"",
                "adminType":custObj.adminType
            };
            cmp.set("v.interactionMemberInfo", intMemberInfo);
            console.log("INTERACTION CREATION4: " + JSON.stringify(cmp.get("v.interactionMemberInfo")));
        }
        
       var tabEvent = $A.get("e.c:ETSBE_TabName");
        tabEvent.setParams({"SearchType":cmp.get("v.SearchType"),"TabName":''});
        tabEvent.fire();
    },
    fireTranIdFunctions : function(component, event, helper) {
        helper.callHouseHoldWS(component, event, helper);
        helper.callCobdWS(component, event, helper);
    },
    navigateToInteraction: function(component, event, helper){
        console.log('interaction clicked');
        var intId = event.currentTarget.getAttribute("data-intId");
        console.log(intId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
})