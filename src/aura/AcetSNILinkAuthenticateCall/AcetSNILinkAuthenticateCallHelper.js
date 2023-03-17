({
    getProviderDetails: function (cmp) {
        var appEvent = $A.get("e.c:ACETLinkGetProviderDetailsAE");
        appEvent.setParams({
            "requestedCmp": "AuthenticateCall"
        });
        appEvent.fire();
    },
    
    navigateToInteractionHelper:function(cmp,event,helper,flagMNFnav){
        //helper.openInteractionOverview(cmp,event,helper);
        //var memConId = cmp.find('memContactId');
        //var memConVal = memConId.get('v.value');
        /*var controlAuraIds =  [];
        
        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');                
        var memPhoneNum = cmp.find('memPhoneNumber');
        var memState = cmp.find('stateMemId');
        
        console.log('memFNameId@@@ ' + memFNameId);
        $A.util.removeClass(memFNameId, "hide-error-message"); 
        $A.util.removeClass(memLNameId, "hide-error-message"); 
        $A.util.removeClass(memPhoneNum, "hide-error-message"); 
        $A.util.removeClass(memState, "hide-error-message"); 
        console.log('memLNameId@@@ ' + memLNameId);
        
        //if(!$A.util.isEmpty(memConVal)){
        if(cmp.get('v.disableMemberSec') == true){
           
            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","memContactId","inputDOB","stateMemId"];
        }else{
             
            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","inputDOB","stateMemId"];
        }
        var memFN = cmp.find('memFirstNameId').get('v.value'); 
        var memLN = cmp.find('memLastNameId').get('v.value'); 
        var memPhNo = cmp.find('memPhoneNumber').get('v.value'); 
        var contactMNFId = cmp.find('memContactId').get('v.value'); 
        var memDOB = cmp.find('inputDOB').get('v.value'); 
        
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        var isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp='';
            console.log('controlAuraId@@ ' + controlAuraId);
            console.log('controlAuraIdValue@@ ' + $A.util.isEmpty(controlAuraId));
            if(!$A.util.isEmpty(controlAuraId)){
                if(controlAuraId == 'stateMemId'){
                    console.log('controlAuraIdIf@@>> ' + controlAuraId);
                    var tempState = cmp.find('stateMemId').find('provStateId').get("v.value");
                    console.log('tempState11### ' + tempState + ' @@@$value@@@ ' + $A.util.isEmpty(tempState));
                    var elem = cmp.find('stateMemId').find('provStateId');
                    if($A.util.isEmpty(tempState)){
                        cmp.find('stateMemId').find('provStateId').reportValidity();                       
                        return false;
                    }else{
                        return true;
                    }
                    
                }else{    
                    console.log('controlAuraIdElseState@@ ' + controlAuraId);
                    inputCmp = cmp.find(controlAuraId); 
                    
                    inputCmp.reportValidity();
                }
                //form will be invalid if any of the field's valid property provides false value.
                return true;
            }else{
                console.log('controlAuraIdElse@@ ' + controlAuraId);
                inputCmp = cmp.find(controlAuraId);
                inputCmp.reportValidity();
                //form will be invalid if any of the field's valid property provides false value.
                return false;
            }
            //displays the error messages associated with field if any
            
        },true);
        console.log('isAllValid>>>> ' + isAllValid);
        if(!$A.util.isEmpty(memConVal)){
            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB) && !$A.util.isEmpty(contactMNFId))){ 
                    isAllValid = true;               
                } else {                
                    isAllValid = false;                      
                }
            }else{
                isAllValid = false;
            }
        }else{
            
            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB))){ 
                    isAllValid = true;               
                } else {                
                    isAllValid = false;                 
                }
            }else{
                isAllValid = false;
            }
        }
        
        if(isAllValid != undefined && isAllValid != false && flagMNFnav){
            helper.openInteractionOverview(cmp,event,helper);
        }*/
    },
    
    // Fix - DE246060 - Sanka Dharmasena - 10.07.2019
    /*checkOpnedTab: function (component) {
        var workspaceAPI = component.find("workspace");
        var memSearch = [];
        
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.state.c__tabOpened) {
                        memSearch.push(response[i].pageReference.state.c__memberUniqueId);
                    }
                }
            }
        });
        component.set("v.memberSearches", memSearch);
    }*/
    
})