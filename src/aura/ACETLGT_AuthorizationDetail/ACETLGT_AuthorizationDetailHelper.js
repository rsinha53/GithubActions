({
	getAuthDetail : function(component,event,helper,srk,authid,authno,authpredet) {
		console.log('Inside getAuth' +srk+authid);
        var auth =component.get("v.authType");
        var authjsonstring =component.get("v.authjsonstring");
        console.log('!!!!'+auth+authjsonstring);
        
        var action = component.get("c.getAuthorizations");
        //action.setStorable();
        
        action.setParams({
            AuthId: authid,
            srk : srk,
            authType: auth,
            jsonString: authjsonstring
        });
        
        action.setCallback(this, function(a) {
            
            var state = a.getState();
            console.log('----state---'+state);
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.log('------result--------'+result);
                if($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    
                    if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                        console.log('!!!Auth Detial'+result.resultWrapper);
                        console.log('!!!Auth Detial'+JSON.stringify(result.resultWrapper));
                        component.set("v.detailResult",result.resultWrapper);
						component.set("v.detailResult.Authorization_Number",authno);
                        component.set("v.detailResult.Pre_Determination",authpredet);
                        
                    }
                    if (!$A.util.isEmpty(result.searchResultWrapper) && !$A.util.isUndefined(result.searchResultWrapper)){
                        console.log('!!!Auth Detial selected'+JSON.stringify(result.searchResultWrapper));
                        component.set("v.searchResult",result.searchResultWrapper);
                    }
                }else {
                        helper.displayToast('Error!', result.ErrorMessage);
                    }
                var tabKey = component.get("v.AutodocKey") + component.get("v.GUIkey"); 
                setTimeout(function(){
                    //alert("====");
                    window.lgtAutodoc.initAutodoc(tabKey);
                },1);
            }else if(state == "ERROR"){
                component.set("v.detailResult");
                component.set("v.searchResult");
            }
        });
        $A.enqueueAction(action);
        
        
	},
    
    getICUEURL : function(component, event, helper) {
        
        var ICUEURL = component.get("v.ICUEURL");
        console.log('icueURL New :: '+ICUEURL);
        //window.open(baseLink,'_blank', 'location=yes,menubar=yes,titlebar=yes,toolbar=yes, width=1200, height=800 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');
        window.open(ICUEURL, 'ICUE', 'location=yes,menubar=yes,titlebar=yes,toolbar=yes, width=1200, height=800 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');
        
    }, 
    displayToast: function(title, messages){
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