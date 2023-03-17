({
    getOrderHistory: function(component,event,helper){
        
        	var startDate = component.get("v.startDate");
        	var endDate = component.get("v.endDate");
        	var familyId = component.get("v.idValue");

        	console.log('Values ::::'+startDate+' '+endDate+' '+familyId);
        
            //Make Second Call for Order History
            var actionSecondCall = component.get("c.getFamilyMemberHistory");
            // Add callback behavior for when response is received
            if(familyId != undefined){
                      
            // Setting the apex parameters
            actionSecondCall.setParams({
                ordHistStartdate: startDate, 
                ordHistEnddate: endDate,
                selectedFamilyId: familyId
            });
            
            actionSecondCall.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var result = response.getReturnValue();

                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                        if($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.responseValueMap) && !$A.util.isUndefined(result.responseValueMap)){
                            var retMap = result.responseValueMap;
                            var arrayMapKeys = [];
                            for(var i in retMap){
                                arrayMapKeys.push({key: i, value: retMap[i]});
                            }
                            
                            component.set("v.orderHistoryMap", arrayMapKeys);
                            //call autodock function here !!!
                            var tabKey = component.get("v.AutodocKey")+ component.get("v.idValue");
                            
                            setTimeout(function(){
                                window.lgtAutodoc.initAutodoc(tabKey);
                                
                            },1);
                        } else {
                            helper.displayToast('Error!', result.ErrorMessage, component, helper, event);
                        }
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                }
            
            });
            // Send action off to be executed
            $A.enqueueAction(actionSecondCall);
        }
    },
    loadDocument : function(component, helper, reqDate) {
        var action = component.get("c.findDocument");
        var groupNumber = component.get("v.groupNumber");
        var textField;
        var memberId = component.get("v.idValue");
        var currIndex;
        //groupNumber ='1293901';
        //memberId = '34040135100';
        var parameters = [];
        textField = 'groupNumber,'+groupNumber;
        parameters.push(textField); 
        textField = 'memberId,'+memberId.substr(0,9);
        parameters.push(textField); 
        textField = 'MemberSequenceNumberOrDivision,'+memberId.substr(memberId.length - 2);
        parameters.push(textField); 
        textField = 'clientNumber,3134';
        parameters.push(textField);         
        textField = 'printDateFilter,ALLCARDS';
        parameters.push(textField); 
        var params = JSON.stringify(parameters);
        action.setParams({
            params: params,
            reqDate : reqDate
        });
        action.setCallback(this,function(result) {
            //get the response state
            var state = result.getState();
            if(state == "SUCCESS") {
                var result = result.getReturnValue();                               
                if($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result) && !$A.util.isUndefined(result) && !$A.util.isEmpty(result.documentId) && !$A.util.isUndefined(result.documentId)) {
                    component.set("v.docId",result.documentId);
                    helper.showImage(component);
                }else{
					var errormsg = result.ErrorMessage;
                	helper.displayToast('Error!', errormsg, component, helper, event);
                }                    
           	}
        });
        $A.enqueueAction(action);
    },
    showImage : function(component) {
        var documentId = component.get("v.docId");
        var isDocSizeMoreThanOneMB = 'false';
        var docContentType = 'application/pdf';
        var isIdCard = 'true';
        var docName = 'Id Card';	//	TODO
        var docType = '';	// TODO
        var workspaceAPI = component.find("workspace");       
        var uniqueKey = component.get("v.idValue");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_Document"
                    },
                    "state": {
                        "uid": uniqueKey,
                        "c__docId": documentId,
                        "c__docContentType" : docContentType,
                        "c__docName": docName,
                        "c__isDocSizeMoreThanOneMB":isDocSizeMoreThanOneMB,
                        "c__performAction":"1",
                        "c__isIdCard": isIdCard
    }    
                },
                focus: true
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "Id Card Image"
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