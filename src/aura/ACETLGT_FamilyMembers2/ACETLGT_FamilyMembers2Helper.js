({
    showfamilyMemberships : function(component, event, helper) {
        helper.showSpinner2(component, event, helper);
        var action = component.get("c.getFamilyMembershipResults");
        var groupNumber = component.get("v.groupNumber");
        var effectiveDate = component.get("v.effectiveDate");
        var srk = component.get("v.identifier");
        console.log('SRK-->'+srk);
        console.log('@@@'+ component.get("v.effectiveDate"));
        console.log('@@@'+ component.get("v.groupNumber"));
        console.log('!!!'+ component.get("v.covLine"));
        var covLine,covLineGrp,covLineTest;
        var covLine = JSON.stringify(component.get("v.covLine"));
        /*Below log is for covLine
           {"image":"active","BenefitPlanId":"MNS0000003","CoverageLevel":"FAM","CoverageType":"MEDICAL","CoverageTypeCode":"M","daysGap":230,
            "EffectiveDate":"10/1/2018","EndDate":"9/30/2019","GroupName":"GRAHAM CAPITAL MANAGEMENT LP","GroupNumber":"1168520",
            "GUID":"07623ffe-de4d-46b6-8531-37ca164cf9df","isActive":true,"isFuture":false,"isPreferred":true,"isSubscriber":true,
            "PolicyNumber":"","Product":"CT NJ NY OHI Oxford Direct HSA","ProductType":"","relationShipCode":"18","SourceCode":"CR","SurrogateKey":"642281208"}*/
        
        var result = true;
        
        //action.setStorable();
        if(result && groupNumber != undefined && srk != undefined){
            console.log('~~~~family ~~~~~'+srk+'///'+groupNumber+'///'+effectiveDate+'///'+covLine+'>>>>');
            
            console.log('!!! callout')
            component.set("v.Memberdetail");
            
            // Setting the apex parameters
            action.setParams({
                srk: srk,
                groupNumber: groupNumber,
                effectiveDate: effectiveDate
            });
            
            //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('~~~~----state---'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log("result from service ---> " + result);
                    console.log('~~~~~------result--------'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                            component.set("v.Memberdetail",result.resultWrapper);
                            console.log(JSON.stringify(result.resultWrapper));
                            var appEvent = $A.get("e.c:ACETLGT_FamilyMembersEvent");
                            
                            //var appEvent = component.getEvent("famevent");
                            console.log('------In 2nd event----'+ result.resultWrapper.FamilyMembers);
                            console.log('------In appEvent----'+ result.resultWrapper);
                            appEvent.setParams({
                                "familyMemberList" : result.resultWrapper.FamilyMembers
                            });
                            appEvent.fire();
                            /*for(var i = 0; i < result.length; i++){
                                res[i].CreatedDate = $A.localizationService.formatDateTime(res[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                                newlst.push(res[i]);
                            }*/
                        }  
                    }
                } else if(state == "ERROR"){
                    component.set("v.Memberdetail");
                }
                helper.hideSpinner2(component, event, helper);
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
        return result;
    },
	hideSpinner2: function(component, event, helper) {        
        window.setTimeout($A.getCallback(function(){
            component.set("v.Spinner", false);
        }),1)
        console.log('Hide');
        //window.setTimeout($A.getCallback(function(){
    	// Your async code here
    	//helper.hideSpinner();
		//}), 1)
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
    },
    
    navigateToDetail: function(component,event,helper,intId,Name,lastName,firstName,addr,sc,gen,ssn,Id,scr,srk,dob,IsMember,eid,int,intType,coverages,intOrigType,isOnshore,isSelSubscriber,grpNum,ussInfo,specialtyBenefits,affiliationIndicator){
        
        //US1928298: Originator US
        var workspaceAPI = component.find("workspace");
        var coverages2 = JSON.stringify(coverages);
        var addr2 = encodeURIComponent(addr);
        
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({																																																																																																															
            "url": "/lightning/cmp/c__ACETLGT_MemberDetail?c__Name="+Name+"&c__lastName="+lastName+"&c__firstName="+firstName+"&c__sc="+sc+"&c__gen="+gen+"&c__addr="+addr2+"&c__fullssn="+window.btoa(ssn)+"&c__Id="+Id+"&c__scr="+scr+"&c__SRK="+srk+"&c__SRKKeyChain="+srk+"&c__grpnum="+grpNum+"&c__subjectdob="+dob+"&c__IsMember="+IsMember+"&c__individualIdentifier="+eid+"&c__coverages="+window.btoa(coverages2)+"&c__InteractionType="+intType+"&c__InteractionId="+intId+"&c__Interaction="+int+"&c__InteractionOrigType="+intOrigType+"&c__isOnshore="+isOnshore+"&c__subscriber="+isSelSubscriber+"&c__usInfo="+ussInfo+"&c__affiliationIndicator="+affiliationIndicator+"&c__specialtyBenefits="+specialtyBenefits,
            "isredirect" : true
        });
        evt.fire();
        
    }
})