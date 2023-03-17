({
    doInit : function(component, event, helper) {
        var intId = component.get("v.intId");
    },
    handleMemberChange: function(component, event, helper) {
        console.log('Matchmembid'+component.get("v.memId"));
        if(component.get("v.familymemberlist") && component.get("v.familymemberlist")!=null){
        	helper.updatecallersubdetails(component,event,helper,true,component.get("v.memId")); 
        }else{
             setTimeout(function(){ 
                 helper.updatecallersubdetails(component,event,helper,true.component.get("v.memId")); 
             }, 1000);
        }
    },
    callTTSChildMethods : function(component, event, helper) {
        
        var childComponent = component.find("cComp");
        childComponent.childMethodForloadType('Member Overview');
        console.log('------IN 222-------');
        
    },
    navigateToRecord : function(component, event, helper) {
        console.log('navigateto record');
        var intId = event.currentTarget.getAttribute("data-intId");
        
        console.log('-----'+intId);
        //var navLink = component.find("navLink");
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
    getBundleAlerts: function(component,event,helper){
    	var intId = component.get("v.intId");
        //alert('----In renderer----->'+intId);
        if(intId != undefined ){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
            var bundleId = component.get("v.bundleId");
            console.log('TESTINGBUNDLEID1: ' + bundleId);
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'Detail',bundleId);
            //alert('---1---'+intId +'-----'+memID +'-----'+GrpNum );
        }
    },
    
    handleOriginator: function(cmp,event,helper){
        console.log('originatorIdchange '+cmp.get("v.originatorId"));
        if(cmp.get("v.familymemberlist") && cmp.get("v.familymemberlist")!=null && cmp.get("v.originatorId")){
        	helper.updatecallersubdetails(cmp,event,helper,false,cmp.get("v.memId")); 
        }else{
             setTimeout(function(){ 
                 helper.updatecallersubdetails(cmp,event,helper,false,cmp.get("v.memId")); 
             }, 2000);
        }
    },
    
    handlehighlightPanel: function(cmp,event,helper){
        var originatorId = cmp.get("v.OriginatorId");
        var thirdParty= cmp.get("v.highlightPanel");
        if(!$A.util.isUndefinedOrNull(originatorId) && originatorId.substring(0,3)!=='003'){       
            var callerdetails = {};
            callerdetails.FirstName = thirdParty.originatorName;
            callerdetails.LastName = '';
            callerdetails.Gender = '';
            callerdetails.DOB = '';
            callerdetails.MembId = '';
            callerdetails.PolicyId ='';
            callerdetails.Relation = thirdParty.originatorRel;
            cmp.set("v.callerdetails",callerdetails);    
        }
    },
    
    handleCoveragesFamilyEvent: function(cmp, event, helper){
        var params = event.getParam("arguments");
        if(!$A.util.isUndefinedOrNull(params)){       
            if(cmp.get("v.familymemberlist") && cmp.get("v.familymemberlist")!=null){
                helper.updatecallersubdetails(cmp,event,helper,true,params.selcovmemid); 
            }else{
                 setTimeout(function(){ 
                     helper.updatecallersubdetails(cmp,event,helper,true,params.selcovmemid); 
                 }, 1000);
            }
        }
    },
    
})