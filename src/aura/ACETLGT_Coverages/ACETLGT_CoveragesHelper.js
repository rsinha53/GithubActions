({
    
    //New Code
    showfamilyMemberships : function(component, helper, srk, Esrk, groupNumber, effectiveDate, endDate, benefitPlanId,originatorType,isActive,isTermed,memberId,beneffDate,benendDate,planOptionId,customerPurchaseId,LatestCOStartDate,LatestCOEndDate,Product) {
        console.log('SSS in showfamilyMemberships');
        console.log('isActive::'+isActive+'-'+isTermed);
        
        var isOnshore = component.get("v.isOnshore");
        console.log('~~~Onshore in show family'+isOnshore+endDate);
        
        var action = component.get("c.getFamilyMembershipResults");
        console.log('~~~~Cov comp family ~~~~~'+srk+'///'+groupNumber+'///'+effectiveDate+'////'+endDate+'///'+benefitPlanId+'??'+beneffDate+'??'+benendDate+'??'+planOptionId);
        var resultflag = true;
        //originatorType='Member';
        //action.setStorable();
        
        var appEvent = component.getEvent("famEvent");
        if(resultflag && groupNumber != undefined && srk!=undefined){
            console.log('!!! callout from coverage helper')
            component.set("v.Memberdetail");
            var eidVal = component.get("v.EID");
            console.log('----14--'+memberId);
            // Setting the apex parameters
            action.setParams({
                srk: srk,
                Esrk: Esrk,
                groupNumber: groupNumber,
                effectiveDate: effectiveDate,
                endDate: endDate,
                benefitPlanId: benefitPlanId,
                memberId: memberId,
                EID: eidVal
            });
        	    
            localStorage.setItem(memberId+'_effectiveDate', effectiveDate);
            	//Setting the Callback
            	action.setCallback(this,function(a){
                console.log('SSS calling Service');
                //get the response state
                var state = a.getState();
                console.log('~~~~----state from coverage helper---'+state);
                //check if result is successfull
                
				
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log('SSS Inside success');
                    console.log('~~~~~------result from coverage helper--------'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                            component.set("v.MemberdetailwithGroupData",result.resultWrapper);
                            if(!$A.util.isUndefinedOrNull(result.sniEligibility)){
                                var status  = result.sniEligibility=='not eligible'? 'Not Eligible':
                           result.sniEligibility=='eligible'? 'Eligible': 
                         result.sniEligibility=='engaged'? 'Engaged':result.sniEligibility;
                               component.set('v.SNIStatus',status);
                          var highlightPanelObj = component.get('v.highlightPanel');
                         if(highlightPanelObj){
                         highlightPanelObj.SpecialNeedsStatus = status;
                          component.set('v.highlightPanel',highlightPanelObj);
                           }  
                            }
                            if (!$A.util.isEmpty(result.resultWrapper.PreferredCoverageInfo) && !$A.util.isUndefined(result.resultWrapper.PreferredCoverageInfo)){
                                //console.log('INSIDE check22::'+result.resultWrapper.PreferredCoverageInfo);
                                //console.log('INSIDE check22::'+result.resultWrapper.PreferredCoverageInfo.isActive);
                                result.resultWrapper.PreferredCoverageInfo.isActive = isActive;
                                result.resultWrapper.PreferredCoverageInfo.isTermed = isTermed;
                                result.resultWrapper.PreferredCoverageInfo.EndDate = endDate;
                                result.resultWrapper.PreferredCoverageInfo.BenEffectiveDate = beneffDate;
                                result.resultWrapper.PreferredCoverageInfo.BenEndDate = benendDate;
                                
                                
                                
                            }
                            
                            var plan = result.resultWrapper.BenefitPlanId ;
                            var bundle = result.resultWrapper.BundleOptionID;
                            
                            console.log('isActive22::'+isActive+'-'+isTermed);
                            for(var objKey in result.resultWrapper.FamilyMembers){
                                var obj = result.resultWrapper.FamilyMembers[objKey];
                                if(obj.Relationship == 'Self'){
                                    var dat = obj.DOB.split('/');
                                    var memId = memberId;
                                    dat = (parseInt(dat[2])>=10?dat[2]:'0'+dat[2])+'-'+
                                        (parseInt(dat[0])>=10?dat[0]:'0'+dat[0])+'-'+
                                        (parseInt(dat[1])>=10?dat[1]:'0'+dat[1]);
                                    localStorage.setItem(memId+'_memDOB',dat);
                                    localStorage.setItem(memId+'_memDOBUnFormatted',obj.DOB);
                                    localStorage.setItem(memId+'_memFirstName',obj.FirstName);
                                    localStorage.setItem(memId+'_memLastName',obj.LastName);
                                    localStorage.setItem(memId+'_memPolicyId',obj.groupNumber);
                                    component.set('v.memId',memberId);
                                }
                            }
                            appEvent.setParams({
                                "familyMemberList" : result.resultWrapper.FamilyMembers,
                                "otherContactList" : result.resultWrapper.ROIContacts,
                                "MemberDetail" : result.resultWrapper,
                                "groupNumber" : groupNumber,
                                "sniEligibility":status,
                                "customerPurchaseId":customerPurchaseId,
                                "COStartDate":LatestCOStartDate,
                                "COEndDate":LatestCOEndDate,
                                "Product":Product,
                                "membIdselected":memberId
                            });
                            appEvent.fire();
                            console.log('getFamily Event fired'+plan+'--'+bundle);
                            //helper.showGroupDetails(component, helper,groupNumber,effectiveDate,endDate,plan,bundle,originatorType,isOnshore,planOptionId);
                            helper.showGroupDetails(component, helper,groupNumber,beneffDate,benendDate,plan,bundle,originatorType,isOnshore,planOptionId);
                        }else{
                            helper.showLevelFunded(component,event,helper); //US3584878
                            appEvent.setParams({
                                "familyMemberList" : null,
                                "otherContactList" : null,
                                "MemberDetail" : null,
                                "groupNumber" : null,
                                "error" : result.ErrorMessage
                            });
                            appEvent.fire();
                            component.set("v.Memberdetail");
                        }  
                    }
                    else
                     helper.showLevelFunded(component,event,helper); //US3584878
                } 
                else if(state == "ERROR"){
                    console.log('SSS Inside error');
                    helper.showLevelFunded(component,event,helper); //US3584878
                    appEvent.setParams({
                                "familyMemberList" : null,
                                "otherContactList" : null,
                                "MemberDetail" : null,
                                "groupNumber" : null,
                                "error" : ''
                            });
                    appEvent.fire();
                    component.set("v.Memberdetail");
                }
                else if (state == "INCOMPLETE") // Discuss this with Ranjit. This is new error condition - Shoven
                {
                    console.log('SSS Incomplete - No Response from server');
                    helper.showLevelFunded(component,event,helper); //US3584878
                    appEvent.setParams({
                                "familyMemberList" : null,
                                "otherContactList" : null,
                                "MemberDetail" : null,
                                "groupNumber" : null,
                                "error" : ''
                            });
                            appEvent.fire();
                    		component.set("v.Memberdetail");
                }
                
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
        
       	console.log(resultflag); 
        return resultflag;
    },
    showGroupDetails : function(component, helper, groupNumber,effectiveDate,endDate, benefitPlanId, bundleId,originatorType,isOnshore,planOptionId) {
        console.log('~~~~Cov comp group ~~~~~'+groupNumber+originatorType);
        console.log('~~~~Cov Line group ~~~~~'+effectiveDate+'--'+endDate+'--'+benefitPlanId+'--'+bundleId+planOptionId);
        var actionGroup = component.get("c.getGroupDetailsResults");
        
        if(groupNumber != undefined){
            //actionGroup.setStorable();
            
            component.set("v.MemberdetailFromGroup");
            // Setting the apex parameters
            actionGroup.setParams({
                groupNumber: groupNumber,
                effectiveDate: effectiveDate,
                endDate: endDate,
                benefitPlanId: benefitPlanId,
                bundleId: bundleId,
                originatorType: originatorType,
                isOnshore:isOnshore,
                planOptionId:planOptionId
            });
            
            //Setting the Callback
            actionGroup.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('~~~~----state from coverage helper group---'+state);
                //check if result is successfull
                var cmpEvent = component.getEvent("groupInfoEvent");
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log('~~~~~------result from coverage helper group--------'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                            component.set("v.MemberdetailfromGroup",result.resultWrapper);
                            component.set('v.parentPEOId',result.resultWrapper.parentPEOId);
                            console.log(JSON.stringify(result.resultWrapper.coverageGroupInfo));
                            // Triggering event to pass family Mem names to originator component
                            //var appEvent = $A.get("e.c:ACETLGT_FamilyMembersEvent");
                            
                            //US3584878 Start
                            var bookOfBusinessTypeCode = (!result.resultWrapper.bookOfBusinessTypeCode) ? '' : result.resultWrapper.bookOfBusinessTypeCode;
                            var bookOfBusinessTypeDesc = (!result.resultWrapper.bookOfBusinessTypeDesc) ? '' : result.resultWrapper.bookOfBusinessTypeDesc;
                            component.set('v.bookOfBusinessTypeCode', bookOfBusinessTypeCode);
                            component.set('v.bookOfBusinessTypeDesc', bookOfBusinessTypeDesc);
                            helper.showLevelFunded(component,event,helper);
			    //US3584878 End
                            console.log('------In appEvent from coverage helper grp----'+ result.resultWrapper);
                            cmpEvent.setParams({
                                "MemberDetailFromGroup" : result.resultWrapper.coverageGroupInfo,
								"customerPurchases" : result.resultWrapper.customerPurchase
                            });
                            cmpEvent.fire();
                            var parentPEOIdEvent = $A.get("e.c:ACETLGT_ParentPEOIdEvent");
                            parentPEOIdEvent.setParams({
                                "parentPEOId" :result.resultWrapper.parentPEOId
                            });
                            parentPEOIdEvent.fire();
                        }else{
                            helper.showLevelFunded(component,event,helper); //US3584878
                            cmpEvent.setParams({
                                "MemberDetailFromGroup" : null,
                                "errorMessage" : result.ErrorMessage
                            });
                            cmpEvent.fire();
                            component.set("v.MemberdetailFromGroup");
                        }  
                    }
                    else
                     helper.showLevelFunded(component,event,helper); //US3584878
                } else if(state == "ERROR"){
                    helper.showLevelFunded(component,event,helper); //US3584878
                    cmpEvent.setParams({
                                "MemberDetailFromGroup" : null,
                        		"errorMessage" : result.ErrorMessage
                            });
                    cmpEvent.fire();
                    component.set("v.MemberdetailFromGroup");
                }
                
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(actionGroup);
        }
        //return result;    
        
    },
    hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('Hide');
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
    },
    //US3584878: This Function will display Book of Business info
    showLevelFunded: function(component, event, helper)
    {
        var bookOfBusinessTypeCode = component.get('v.bookOfBusinessTypeCode');
        var bookOfBusinessTypeDesc = component.get('v.bookOfBusinessTypeDesc');
        var customerPurchaseId = component.get('v.customerPurchaseId');
    	console.log('bookOfBusinessTypeCode --> ' + bookOfBusinessTypeCode);
        console.log('bookOfBusinessTypeDesc --> ' + bookOfBusinessTypeDesc);
    	console.log('customerPurchaseId --> ' + customerPurchaseId);
    	var bookOfBusinessTypeCodeValue = bookOfBusinessTypeCode;
    	var workspaceAPI = component.find("MemberSearchResults");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            var appEvent = $A.get("e.c:ACETLGT_BookOfBusinessTypeCodeUpdateEvent");
            appEvent.setParams({bookOfBusinessTypeCode : bookOfBusinessTypeCodeValue?bookOfBusinessTypeCodeValue:'ER',
                                tabId : tabId,
                                customerPurchaseId:customerPurchaseId
                               });
            appEvent.fire();
        })
        .catch(function(error) {
            console.log(error);
        });

		if(!bookOfBusinessTypeCode || bookOfBusinessTypeCode == 'ER')
        {
            component.set('v.bookOfBusinessError',true);
            component.set('v.levelFundedMessage',null);
        }
		else
        {
            component.set('v.bookOfBusinessError',false);
            component.set('v.levelFundedMessage',bookOfBusinessTypeDesc+'<br/>');
        }
	}
    
})