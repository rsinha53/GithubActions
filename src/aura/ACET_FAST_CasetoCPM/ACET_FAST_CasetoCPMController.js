({
    doInit : function(component, event, helper) {
        var action=component.get("c.initializeCaseWrapper");
        var caseRecID = component.get("v.recordId");    
        action.setParams({"caseId":caseRecID});
        
        action.setCallback(this, function(response){ 
            var state = response.getState(); 
            if (state == "SUCCESS")
            {  
                var res = response.getReturnValue();
                component.set("v.cpmWrap",res);
            }else{
                //toast message error place 
            }
        });
        $A.enqueueAction(action);
        
    },
    HandleTopic: function(component, event, helper){
        var selectedTopic = event.getSource().get("v.value");
        component.set("v.cpmWrap.caseRec.Type__c",'');
        component.set("v.cpmWrap.caseRec.Subtype__c",'');
        component.set("v.cpmWrap.subTypeList",[]);
        switch(selectedTopic) {
            case '':
                component.set("v.cpmWrap.typeList",[]);
                break;
            case 'Proactive':
                component.set("v.cpmWrap.typeList",['C&S Cosmos', 'C&S CSP Facets', 'C&S RV Facets','E&I Oxford Cirrus', 'E&I OXFORD Pulse', 'E&I RV Facets', 'E&I UNET','M&R COSMOS', 'M&R CSP Facets','PHS Legacy NICE']);
                break;
            case 'Provider Driven':
                component.set("v.cpmWrap.typeList",['C&S Cosmos', 'C&S CSP Facets', 'C&S RV Facets','E&I Oxford Cirrus', 'E&I OXFORD Pulse', 'E&I RV Facets', 'E&I UNET','M&R COSMOS', 'M&R CSP Facets','PHS Legacy NICE']);
                break;
        }
    },
    HandleType: function(component, event, helper){
        var selectedType = event.getSource().get("v.value");
        component.set("v.cpmWrap.caseRec.Subtype__c",'');
        component.set("v.cpmWrap.subTypeList",[]);
        switch(selectedType) {
            case '':
                component.set("v.cpmWrap.subTypeList",[]);
                break;
            case 'C&S Cosmos':
                component.set("v.cpmWrap.subTypeList",['All States','Report Analyst']);
                break;
            case 'C&S CSP Facets':
                component.set("v.cpmWrap.subTypeList",['All Other States','AZ','CO, HI, MA, MD, MI, MS, NE, NV, RI, WA, WI', 'IA', 'KS NF','LA','MI, NE, WI, MD, WA','MO','National','Report Analyst','TX NF', 'TN NF']);
                break;
            case 'C&S RV Facets':
                component.set("v.cpmWrap.subTypeList",['All States']);
                break;
            case 'E&I Oxford Cirrus':
                component.set("v.cpmWrap.subTypeList",['All States', 'Report Analyst']);
                break;
            case 'E&I OXFORD Pulse':
                component.set("v.cpmWrap.subTypeList",['All States', 'Report Analyst']);
                break;
            case 'E&I RV Facets':
                component.set("v.cpmWrap.subTypeList",['All States']);
                break;
            case 'E&I UNET':
                component.set("v.cpmWrap.subTypeList",['Domestic','National','OGS','Report Analyst']);
                break;  
            case 'M&R COSMOS':
                component.set("v.cpmWrap.subTypeList",['Domestic','National','OGS','Report Analyst']);
                break;
            case 'M&R CSP Facets':
                component.set("v.cpmWrap.subTypeList",['All Other States','AZ','CO, HI, MA, MD, MI, MS, NE, NV, RI, WA, WI','IA', 'KS NF', 'LA', 'MO', 'National', 'Report Analyst','TX NF', 'TN NF']);
                break; 
            case 'PHS Legacy NICE':
                component.set("v.cpmWrap.subTypeList",['All Other States','National']);
                break;
        }
    },
    handleNext: function(component, event, helper){
        helper.scrollTop(component,event);
        if(helper.validateFirstScreen(component, event)){
            component.set("v.cpmWrap.isFirstScreen",false);   
        }
    },
    handlePrevious: function(component, event, helper){
        helper.scrollTop(component,event);
        component.set("v.cpmWrap.isFirstScreen",true);
    },
    validateFields: function(component, event, helper){
        console.log('outside if');
        if(helper.validateSecondScreen(component, event)){
            console.log('inside if');
            helper.submitRecord(component, event);
        }
    }
})