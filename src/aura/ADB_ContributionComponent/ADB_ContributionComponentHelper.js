({
// check account dynamically : US2693051 - Sunil Vennam
checkAccount: function(component, event, helper) {
    
   // var contributionTestData = component.get("v.contributionDataJSONStringValue");
    
    //component.set("v.contributionTestData", JSON.parse(contributionTestData) );
},
    
    updateContributions : function(component,event,helper,accountName){
        component.set('v.highlightTab','one');
        var contributionsCurrentYr = {};
        var contributionsPriorYr = {};
        console.log('new account slected'+accountName);
        var contributions = component.get('v.FinOverviewData.account');
        
        if(contributions != null){
            contributions.forEach(function(item,index){
                if(item.accountTypeCode == accountName){
                    var acPlnYrs = item.accountPlanYear;
                    if(acPlnYrs != null){
                        acPlnYrs.forEach(function(itr,indx){
                            console.log('account itr'+JSON.stringify(itr));
                            if(itr.yearType == 'Current'){
                                contributionsCurrentYr["employeeContributionAmountYTD"] = itr.employeeContributionAmountYTD;
                                contributionsCurrentYr["employeeElectedAmountTotal"] = itr.employeeElectedAmountTotal;
                                contributionsCurrentYr["employeeBalance"] = itr.employeeBalance;
                                
                                contributionsCurrentYr["employerContributionLessIncentiveAmountTotal"] = itr.employerContributionLessIncentiveAmountTotal;
                                contributionsCurrentYr["employerContributionAmountYTD"] = itr.employerContributionAmountYTD;
                                contributionsCurrentYr["employerBalance"] = itr.employerBalance;
                                console.log('itr.employerContributionIndicator'+itr.employerContributionIndicator);
                                if(itr.employerContributionIndicator == "true"){
                                    console.log('employer true');
                                    component.set("v.cyEmployer",true);
                                }else if(itr.employerContributionIndicator == "false"){
                                    console.log('employer false');
                                    component.set("v.cyEmployer",false);
                                }
                                if(accountName == 'HSA'){
                                    component.set("v.cyEmployer",true);
                                	component.set("v.cyEmployer",true);
                                }
                                component.set("v.contributionsCurrentYr",contributionsCurrentYr);
                            }else  if(itr.yearType == 'Prior'){
                                contributionsPriorYr["employeeContributionAmountYTD"] = itr.employeeContributionAmountYTD;
                                contributionsPriorYr["employeeElectedAmountTotal"] = itr.employeeElectedAmountTotal;
                                contributionsPriorYr["employeeBalance"] = itr.employeeBalance;
                                
                                contributionsPriorYr["employerContributionLessIncentiveAmountTotal"] = itr.employerContributionLessIncentiveAmountTotal;
                                contributionsPriorYr["employerContributionAmountYTD"] = itr.employerContributionAmountYTD;
                                contributionsPriorYr["employerBalance"] = itr.employerBalance;
                                if(itr.employerContributionIndicator == "true"){
                                    component.set("v.is_PYEmployer",true);
                                }else if(itr.employerContributionIndicator == "false"){
                                    component.set("v.is_PYEmployer",false);
                                }
                                if(accountName == 'HSA'){
                                    component.set("v.is_PYEmployer",false);
                                	component.set("v.is_PYEmployer",false);
                                }
                                component.set("v.contributionsPriorYr",contributionsPriorYr);
                            }
                        });
                    }
                }
                
            });
        }
    }
})