({
    doInit : function(component, event, helper) {
        console.log('Delegation Value'+ JSON.stringify(component.get("v.delegationValue")));
        console.log('Patrinet Info'+ JSON.stringify(component.get("v.patientInfo")));
    },
    handleOnChange : function(component, event, helper){
        var fieldName = event.getSource().get("v.name");
        var fieldValue = event.getSource().get("v.value");
        var paCheckTabId= component.get('v.paCheckTabId');
        var patientInfo = component.get("v.patientInfo");
        const memberStatesList = ['AZ', 'AK', 'CA','CO','CT','FL','GA','IN','IA','IL','KS','KY','MD','MI','MO', 'MN', 'NC', 'ND', 'OH','OK','OR','SC','SD','TX','VA','WA','WI','NM','District of Columbia/Washington DC','NE','NY','NJ'];
        var delegationValue = component.get("v.delegationValue");
        if(fieldName == 'postAcuteCareServices'+paCheckTabId){
            if(fieldValue == 'No'){
                component.set("v.showExistingProcess",true);
                if(delegationValue != 'No'){
                    component.set("v.showDateOfServiceFunc",true);
                }
            }else{
                if(delegationValue != 'No'){
                    component.set("v.showDateOfServiceFunc",false);
                }
                component.set("v.showExistingProcess",false);

            }
            if(!$A.util.isUndefinedOrNull(patientInfo) && !$A.util.isEmpty(patientInfo)){
                var memberState = patientInfo.State;
                if(!$A.util.isUndefinedOrNull(memberState) && !$A.util.isEmpty(memberState)){
                    var withinMemberState = memberStatesList.includes(memberState);
                    component.set("v.withinMemberState",withinMemberState);
                    if(!withinMemberState){
                        component.set("v.showExistingProcess",true);
                    }
                }
                else{
                    component.set("v.withinMemberState",false);
                    component.set("v.showExistingProcess",true);
                }
            }
        }
        else if(fieldName == 'inclusionList'+paCheckTabId){
            if(fieldValue == 'Yes'){
                component.set("v.showExclusionList",true);
                component.set("v.showExcludedValue",false);
                component.set("v.showExistingProcess",false);
            }
            else{
                component.set("v.showExclusionList",false); 
                component.set("v.showExcludedValue",true);
                component.set("v.showExistingProcess",true);
            }
        }
        else if(fieldName == 'exclusionList'+paCheckTabId){
            if(fieldValue == 'Yes'){
                component.set("v.isExcludedYes",true);
                component.set("v.isExcludedNo",false);
                component.set("v.showExistingProcess",true);
            }
            else{
                component.set("v.isExcludedYes",false); 
                component.set("v.isExcludedNo",true);
                component.set("v.showExistingProcess",false);
            }
        }

        
        
        helper.updateAutoDoc(component, event, helper);
    },
    getIntoAutoDoc : function(component, event, helper){
        helper.handleNaviHealthLink(component, event, helper);
    },
    navigateToFile : function(component, event, helper){
        var url = 'file:///webep1259.uhgres.uhc.com/Links/naviHealth%20Post-Acute%20Prior%20Authorization%20Contract%20Grid.xlsx';
        window.open(url, '_blank');

    }
})