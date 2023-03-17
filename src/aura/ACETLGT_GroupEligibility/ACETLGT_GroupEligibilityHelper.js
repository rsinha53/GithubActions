({
    getEligibilities : function(component, event, helper) {
        var contractOptionId = component.get("v.contractOptionId");
        var contractOptionEffDate = component.get("v.contractOptionEffDate");
        var contractOptionStatus = component.get("v.contractOptionStatus");
        
        var action = component.get("c.getEligibilities");
        var errormsg = '';
        action.setParams({
            groupNumber : component.get("v.grpNum"),
            contractOptionStatus : contractOptionStatus,
            contractOptionEffDate : contractOptionEffDate,
            contractOptionId : contractOptionId,
            covEffDate : component.get("v.benEffDate"),
            covEndDate : component.get("v.benEndDate"),
            isMemberFlow : component.get("v.isMemberFlow")
        });
        
        //Setting the Callback
        action.setCallback(this, function(response) {
            //get the response state
            var state = response.getState();              
            console.log('state : ', state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                errormsg = result.ErrorMessage;
                if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                component.set("v.isShowPopulation", result.isShow);
                component.set("v.populationsList", result.populationsList);
                component.set("v.isPop", result.isPop);
                component.set("v.datesList", result.datesList);
                component.set("v.dateSelected", result.dateSelected);
        		component.set("v.populationSelected", result.populationSelected);
				component.set("v.selectedPolicyContract", result.groupPolicyResultsList);	//Active Contracts                
                
                //	Group Settings building up starts
                var map = result.grpsettingsResultMap;
                var parsingWarpper=[];

                //Iterate over the key for Outer Map
                Object.keys(map).forEach(function(key) {                    
                    var individualElement = {};
                    individualElement.Id = key;
                    individualElement.Value = [];
                    var innerMapObject = map[key];
                    
                    //Iterate over the key for Inner  Map
                    Object.keys(innerMapObject).forEach(function(key2) {
                        console.log(key2);
                        var innerIndivididualElement ={};
                        innerIndivididualElement.Key = key2;
                        innerIndivididualElement.Value = innerMapObject[key2];
                        
                        individualElement.Value.push(innerIndivididualElement);
                    });  
                    parsingWarpper.push(individualElement);                                        
                });
                component.set("v.groupSettingsObj", parsingWarpper);
                
                
                                                                                
                component.set("v.allGroupInsuringResults", result.allGroupInsuringResults);
                var mappings1 = [];
                for(var key in result.settingsResultMap) {
                    mappings1.push({key:key, value:result.settingsResultMap[key]});
                }
                component.set("v.settingsResultMap", mappings1);
                //	Group Settings building up ends
                
                component.set("v.internalContacts",result.resultWrapper.groupInternalContactInfoList);
                                
                helper.getInsuringRules(component);
            } else{
                helper.displayToast('Error!', errormsg, component, helper, event);
            }

            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
    getInsuringRules : function(component) {
        var currentRules = component.get("v.selectedPolicyContract");
        var contractOptionId = component.get("v.contractOptionId");
        var contractOptionEffDate = component.get("v.contractOptionEffDate");
        var contractOptionStatus = component.get("v.contractOptionStatus");
        var dateSelected = component.get("v.dateSelected");
        var populationSelected = component.get("v.populationSelected");
        var rules = [];
        
        if(currentRules != null && currentRules != undefined) {
            currentRules.forEach(function(element) {
                if(contractOptionId == element.policyConId && contractOptionStatus == element.policyActualStatus &&  contractOptionEffDate == element.effectiveDate && element.insurRules != null){
                    element.insurRules.forEach(function(rule) {
                        if(element.population == '') {
                            if(dateSelected == rule.effectiveDate && rule.insrules!=null){
                                rule.insrules.forEach(function(insRule) {
                                    rules.push(insRule);                   
                                });
                            }
                        } else {
                            // For Population Insuring rules
                            if(element.population != '' && rule.hasPopulation == true) {
                                if(populationSelected == rule.population && dateSelected == rule.effectiveDate && rule.insrules!=null){
                                    rules = [];
                                    rule.insrules.forEach(function(insRule) {
                                        if(insRule.pop != '' && populationSelected == insRule.pop){
                                            rules.push(insRule);     
                                        }                                                      
                                    });                                    
                                }
                            }
                            if(rules.length == 0){                                
                                if(element.population != '' && rule.hasPopulation == false){
                                    if(dateSelected == rule.effectiveDate && rule.insrules!=null){
                                        rule.insrules.forEach(function(insRule) {	//ir
                                 			rules.push(insRule);                      
                                        });
                                    }
                                }
                            }
                        }
                    });
                    console.log("element.insurRules : ", element.insurRules);
                }
            });
        }

        component.set("v.insuringRules", rules);
        var tabKey = component.get("v.AutodocKey");

		setTimeout(function(){
			window.lgtAutodoc.initAutodoc(tabKey);
		},1);
    },
    displayToast: function(title, messages, component, helper, event){
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        
        return;
        
    }
})