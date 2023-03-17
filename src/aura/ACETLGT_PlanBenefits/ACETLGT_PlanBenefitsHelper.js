({
    getCoverageInfoBenefits : function(component,event,helper) {
      
        
        var covInfoBenefits = component.get("v.coverageData");
        var eHBIndicatorVal;
        if(covInfoBenefits != undefined){
        var surrogateKey = covInfoBenefits.SurrogateKey;
            var bundleId = covInfoBenefits.benefitBundleOptionId;
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var benstartDate = component.get("v.COStartDate");
            var benendDate =  component.get("v.COEndDate");
            
            var selectedPlnObj = {};
            selectedPlnObj.benefitBundleOptionId = bundleId;
            selectedPlnObj.contractOptionStartDate = benstartDate;
            selectedPlnObj.contractOptionEndDate = benendDate;
            component.set('v.selectedPlanObj',selectedPlnObj);
            
            var groupNumber = covInfoBenefits.GroupNumber; 
            var action = component.get("c.getSearchResults"); 
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': '',
                'groupNumber': groupNumber,
                'accumAsOf': '',
                'SitusState' : component.get('v.SitusState'),
                'customerPurchaseId' : component.get("v.cpid")
                
            };
                  

            action.setParams(reqParams);
                      

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       console.log(result.resultWrapper);
                       console.log(result.varriableCoverageMap);
                       console.log(result.benefitDisplayMap);
                       //console.log(result.tierTypeCodeList.toString());
                       //console.log(result.tierTypeIdentifierList.toString());
                       component.set("v.planInfoList",result.resultWrapper); 
                       component.set("v.networkScheduleList",result.networkScheduleList);
                       component.set("v.memberPlanBenefitList",result.resultBenefitWrapper);
                       component.set("v.OONReimbursementList",result.resultOONReimbursementWrapper);
                       component.set('v.eHBIndicator',result.eHBIndicator);
                       component.set('v.benefitCodeKeyMap',result.benefitCodeKeyMap);
                       component.set('v.varriableCoverageMap',result.varriableCoverageMap);
                       component.set('v.benefitDisplayMap',result.benefitDisplayMap);
                       component.set('v.tierTypeCodeList',result.tierTypeCodeList);
                       component.set('v.tierTypeIdentifierList',result.tierTypeIdentifierList);
		       component.set('v.existsOnRiderPlanMap',result.existsOnRiderPlanMap);
		        
                }
                   
                 setTimeout(function(){ 
                    component.set("v.Spinner",false);
                }, 1);   
                 setTimeout(function(){
                    var tabKey = component.get("v.AutodocKey");
                    //alert(tabKey);
                    window.lgtAutodoc.initAutodoc(tabKey);
                },2);  
                } else if (state === "ERROR") {
                   component.set("v.Spinner",false);
                }
                
            });
            $A.enqueueAction(action);
            
        }else{
            component.set("v.Spinner",false);
        }
    },
   navigatePlanBenefitDetail :function(component,event,helper,planId,productId,planTypeCode,timePeriodQualifier,administeredByName,pcpRequiredIndicator,gatedProductIndicator,legalSubsidiary,planMetallicLevel,effctDt,expiryDt,benefitBOId) {
          debugger;
         var workspaceAPI = component.find("workspace");
         var fundingArrangement = component.get('v.fundingArrangement');
         var hsaPlan = component.get('v.hsaPlan');
         var networkScheduleList = component.get('v.networkScheduleList');
         var pagerefaranceobj = component.get("v.pageReference");
		 var bookOfBusinessTypeCode = component.get("v.bookOfBusinessTypeCode"); //US3582935 : Added By Manish
         workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACETLGT_PlanBenefitDetail"
                            },
                            "state": {
                                "c__memberId":component.get("v.memberid"),
                                "c__gId":component.get("v.grpNum"),
                                "c__srk":component.get("v.srk"),
                                "c__intId": component.get("v.intId"),
                                "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
                                "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
                                "c__planId": planId,
                                "c__productId" : productId,
                                "c__planTypeCode": planTypeCode,
                                "c__timePeriodQualifier": timePeriodQualifier,
                                "c__administeredByName": administeredByName,
                                "c__pcpRequiredIndicator": pcpRequiredIndicator,
                                "c__networkScheduleList": networkScheduleList,
                                "c__coverageBenefits": component.get('v.coverageData'),
                                "c__legalSubsidiary":legalSubsidiary,
                                "c__planMetallicLevel" :planMetallicLevel,
                                "c__fundingArrangement" :fundingArrangement,
                                "c__hsaPlan" : hsaPlan,
                                "c__memberPlanBenefitList" : component.get('v.memberPlanBenefitList'),
                                "c__OONReimbursementList" : component.get('v.OONReimbursementList'),
                                "c__SitusState" : component.get('v.SitusState'),
                                "c__pcpRequiredIndicator" : pcpRequiredIndicator,
                                "c__gatedProductIndicator" : gatedProductIndicator,
                                "c__eHBIndicator" : component.get("v.eHBIndicator"),
                                "c__benefitCodeKeyMap" : component.get("v.benefitCodeKeyMap"),
                                "c__varriableCoverageMap" : component.get("v.varriableCoverageMap"),
                                "c__benefitDisplayMap" : component.get("v.benefitDisplayMap"),
                                "c__tierTypeCodeList" : component.get('v.tierTypeCodeList'),
                                "c__tierTypeIdentifierList" : component.get('v.tierTypeIdentifierList'),
                                "c__AutodocKey":component.get("v.AutodocKey"),
                                "c__existsOnRiderPlanMap" : component.get("v.existsOnRiderPlanMap"),
                                "c__selectedStrtDt" : effctDt,
                                "c__selectedEndDt" :expiryDt,
                                "c__selectedBundleId" : benefitBOId,
								"c__bookOfBusinessTypeCode" : bookOfBusinessTypeCode //US3582935 : Added By Manish								
                                }
                        }
                    }).then(function(response) {
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function(tabInfo) {
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label: "Plan Benefits Detail"
                            });
                            workspaceAPI.setTabIcon({
                                tabId: tabInfo.tabId,
                                icon: "standard:people",
                                iconAlt: "Member"
                            });
                        });
                    }).catch(function(error) {
                        console.log(error);
                    });
                });
},
    
    updatetCoverageInfoBenefits : function(component,event,helper,coStrtDt,coEndDt,benefitBOId,purchaseId) {
      
        var startDt = coStrtDt;
        var endDt = coEndDt;
        var covInfoBenefits = component.get("v.coverageData");
        console.log('covInfoBenefits'+JSON.stringify(covInfoBenefits));
        var eHBIndicatorVal;
        if(covInfoBenefits != undefined){
        var surrogateKey = covInfoBenefits.SurrogateKey;
            var bundleId = benefitBOId;
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var benstartDate = startDt;
            var benendDate =  endDt;
            var groupNumber = covInfoBenefits.GroupNumber; 
                        console.log('surrogateKey::'+surrogateKey+'::bundleId'+bundleId+'::enrollerSRK'+enrollerSRK+'::benstartDate'+benstartDate+'::benendDate'+benendDate+'::groupNumber'+groupNumber+'::cpid'+purchaseId);
            var action = component.get("c.getSearchResults");
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': '',
                'groupNumber': groupNumber,
                'accumAsOf': '',
                'SitusState' : component.get('v.SitusState'),
                'customerPurchaseId' : purchaseId
                
            };
                  

            action.setParams(reqParams);
                      

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       console.log(result.resultWrapper);
                       console.log(result.varriableCoverageMap);
                       console.log(result.benefitDisplayMap);
                       //console.log(result.tierTypeCodeList.toString());
                       //console.log(result.tierTypeIdentifierList.toString());
                       component.set("v.planInfoList",result.resultWrapper); 
                       component.set("v.networkScheduleList",result.networkScheduleList);
                       component.set("v.memberPlanBenefitList",result.resultBenefitWrapper);
                       component.set("v.OONReimbursementList",result.resultOONReimbursementWrapper);
                       component.set('v.eHBIndicator',result.eHBIndicator);
                       component.set('v.benefitCodeKeyMap',result.benefitCodeKeyMap);
                       component.set('v.varriableCoverageMap',result.varriableCoverageMap);
                       component.set('v.benefitDisplayMap',result.benefitDisplayMap);
                       component.set('v.tierTypeCodeList',result.tierTypeCodeList);
                       component.set('v.tierTypeIdentifierList',result.tierTypeIdentifierList);
		       component.set('v.existsOnRiderPlanMap',result.existsOnRiderPlanMap);
		        
                }
                   
                 setTimeout(function(){ 
                    component.set("v.Spinner",false);
                }, 1);   
                 setTimeout(function(){
                    var tabKey = component.get("v.AutodocKey");
                    //alert(tabKey);
                    window.lgtAutodoc.initAutodoc(tabKey);
                },2);  
                } else if (state === "ERROR") {
                   component.set("v.Spinner",false);
                }
                
            });
            $A.enqueueAction(action);
            
        }else{
            component.set("v.Spinner",false);
        }
    },
})