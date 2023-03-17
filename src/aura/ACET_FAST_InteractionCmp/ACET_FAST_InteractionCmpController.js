({
    doInit: function (component, event, helper) {
        component.find("memberCardSpinnerAI").set("v.isTrue", true);
        var myPageRef = component.get("v.pageReference");
        var accId = myPageRef.state.c__personAccountId;
        var interRecordId = myPageRef.state.c__interactionRecordId;
        var caseRecType = myPageRef.state.c__caseRecordType;
        component.set("v.accountRecId",accId);
        component.set("v.caseRecType",caseRecType);
        //added code to check attribute null value
        
        if($A.util.isEmpty(accId)||$A.util.isEmpty(interRecordId)){
            component.find("memberCardSpinnerAI").set("v.isTrue", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Something went wrong. Please try again!',
                duration:'10000',
                key: 'info_alt',
                type: 'error',
                mode: 'pesky'
            });
            toastEvent.fire();
        }
        var action = component.get("c.getInteractionWrapper");
        action.setParams({
            "personAccId" : accId,
            "interactRecordId" : interRecordId,
            "caseRecordType" : caseRecType
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                
                component.set("v.intWrap",result);
                var markets = [];
                for (var i = 0; i < result.availableMarketList.length; i++) {
                    markets.push({
                        label: result.availableMarketList[i],
                        value: result.availableMarketList[i]
                    });
                }
                component.set("v.availableMarketList", markets);
                
                var products = [];
                for (var i = 0; i < result.availableProductList.length; i++) {
                    products.push({
                        label: result.availableProductList[i],
                        value: result.availableProductList[i]
                    });
                }
                component.set("v.availableProductList", products);
               // component.set("v.dummyChangeAttribute", true);
                component.find("memberCardSpinnerAI").set("v.isTrue", false);
                component.find("alertsAI").alertsMethod();
            }
            else{
                component.find("memberCardSpinnerAI").set("v.isTrue", false);
                helper.showToast(component,event,'There was an exception','ERROR','There was an exception while loading the component',15000);
            }
        });
        $A.enqueueAction(action);
    },
    handleMarketChange: function(component, event, helper){
        component.find("memberCardSpinnerAI").set("v.isTrue", true);
        component.set("v.intWrap.selectedMarketList",component.get("v.selectedMarketList"));
        component.find("memberCardSpinnerAI").set("v.isTrue", false);
    },
    handleProductChange: function(component, event, helper){
        component.find("memberCardSpinnerAI").set("v.isTrue", true);
        component.set("v.intWrap.selectedProductList",component.get("v.selectedProductList"));
        component.find("memberCardSpinnerAI").set("v.isTrue", false);
    },
    validateFields: function(component, event, helper){
        component.find("memberCardSpinnerAI").set("v.isTrue", true); 
        var caseType = component.get('v.caseRecType');
        if(caseType=='Reactive Resolution'){
            
            helper.validateFAST(component, event); 
        }else{
            
            helper.validatePIP(component, event); 
        }
    },
    handleRefChange : function(component, event, helper) {
        var refValue =  event.getSource().get("v.value");
        if(refValue!='' && refValue!=null && refValue!=undefined){
            component.find("noRefId").set("v.value", false);
        }else{
            component.find("noRefId").set("v.value", true);
        }
    },
    handleClaimChange: function(component, event, helper){
        var claimValue =  event.getSource().get("v.value");
        if(claimValue!='' && claimValue!=null && claimValue!=undefined){
            component.find("countUnkownId").set("v.value", false);
        }else{
            component.find("countUnkownId").set("v.value", true);
        }
    },
    goBackToExplorer: function(component, event, helper){
        helper.closeInterActionTab(component, event);
    },
    handleTopicChange: function(component,event, helper){
        component.find("memberCardSpinnerAI").set("v.isTrue", true);
        var topic = component.find("topicId").get("v.value");
        component.find("typeId").set("v.value","");
        component.find("typeId").set("v.disabled",true);
        if(topic!='' && topic!=null && topic!=undefined){
            component.find("typeId").set("v.disabled",false);
            var typeList =[];
            if(topic==='Accounts Receivable' ){   
                typeList.push("Multiple");    
            } else{  
                typeList.push("C&S CSP Facets");
                typeList.push("E&I 3rd Party");
                typeList.push("E&I Oxford Cirrus");
                typeList.push("E&I OXFORD Pulse");
                typeList.push("E&I UNET");
                
                if(topic!='FFA'){
                    typeList.push("Exchange"); 
                    if(topic!='Proactive EWS'){
                        typeList.push("UHC West - NICE");
                    }
                }
            }           
            component.set("v.intWrap.typeList",typeList);
        }
       /* var action = component.get('c.handleTypeChange');
        $A.enqueueAction(action);*/
        component.find("memberCardSpinnerAI").set("v.isTrue", false);
    },
    handleTypeChange: function(component,event, helper){
        component.find("memberCardSpinnerAI").set("v.isTrue", true);
        var type = component.find("typeId").get("v.value");
        component.find("subTypeId").set("v.value","");
        component.find("subTypeId").set("v.disabled",true);
        if(type!='' && type!=null && type!=undefined){
            component.find("subTypeId").set("v.disabled",false);
            var subTypeList = [];            
            if(type==='Community and State' || type==='Employer and Individual' || type==='Medicare and Retirement'){
                subTypeList.push("Claim Research");    
                subTypeList.push("National/Region 5");  
                subTypeList.push("Written Complaint");    
            }
            if(type==='Community and State' || type==='Employer and Individual'){
                subTypeList.push("Exchange");    
            }
            if(type==='Multiple'){
                subTypeList.push("AR"); 
                subTypeList.push("Multiple LOB");  
                subTypeList.push("Pre-Settlement"); 
            }
            component.set("v.intWrap.subTypeList",subTypeList);
        }
        component.find("memberCardSpinnerAI").set("v.isTrue", false);
    },
    formatPhoneNumber: function(component, event, helper) {
        var phoneNo = event.getSource();
        var phoneNumber = phoneNo.get('v.value');
        if(phoneNumber != undefined && phoneNumber.toString().length){
            var s = (""+phoneNumber).replace(/\D/g, '');
            var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
            var formattedPhone = (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            phoneNo.set('v.value',formattedPhone);   
        }
    },
    onchangeSubmitDate : function(component, event, helper){
        helper.validateSubmitDate(component,event); 
    },
    handleLOBChange: function(component,event, helper){
        component.find("platformId").set("v.value", ""); 
    },
    openMisdirectComp: function (cmp, event, helper) {
        helper.openMisDirect(cmp);
    },
})