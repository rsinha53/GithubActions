({
    helperMethod : function() {
        
    },
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky",
            "duration": "1000"
        });
        toastEvent.fire();
    },
    searchInExistingMembers : function(component, event, helper){
        debugger;
        var memberData = event.getParam('arguments');
        var memberWrapper = component.get("v.memberDetails");
        var actionValue = component.get('c.SaveSearchInACET');
        actionValue.setParams({
            "memberDetails": memberWrapper.selectedMemberDetails,
            "memberId" :memberWrapper.memberId ,// component.get("v.memberId"),
            "policyId": memberWrapper.policyId, //component.get("v.policyId"),
            "accountId" : memberWrapper.accountId,
            "exisRelationShip" : memberWrapper.nameRelationMap,
            "assignTo" : memberWrapper.assignTo,
            "houseHoldData" : memberWrapper.houseHoldList,
            "groupNumber" : memberData.groupNumber,
            //new  arrgumentent addition for workorder- added by ankit
            "WoId" : memberData.workorderId
            
        }); 
        actionValue.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('state--HouseholdDatehelper-->'+JSON.stringify(state));
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //console.log('storeResponse--HouseholdDatehelper-->'+JSON.stringify(storeResponse.newMemberMatch));
                if(!$A.util.isUndefined(storeResponse.newMemberMatch) && !$A.util.isUndefined(storeResponse.isAcetSearch)){
                    var acetMemResult = storeResponse.newMemberMatch;
                    var tempMap = [];
                    var pol = ' - Policy Number: '+storeResponse.policyId+' ';
                    //alert('storeResponse--storeResponse.policyId-->'+JSON.stringify(storeResponse.policyId));
                    for(var key in acetMemResult)
                    {
                        var rows =acetMemResult[key];
                        //var policyidd = pol[key];
                        //alert(policyidd);
                        var nameSplit =key.toString().split('~');
                        var keyName = '';
                        for(var str in nameSplit){
                            keyName  += nameSplit[str]+' ';
                        }
                        keyName  +=pol;
                        //var NotMatch = {Name: 'Add new member to family'};
                        //rows.push(NotMatch);
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.Account) {
                            row.Assigned_Advisor__c = row.Account.Assigned_Advisor__c;
                            }
                            if (row.Contact) {
                                row.Name = row.Contact.Name;
                                row.DateOfBirth = $A.localizationService.formatDate(row.Contact.Birthdate, "M/d/yyyy");
                                row.serviceMember = key;
                            }
                            else{
                                row.serviceMember = key;  
                            }
                        }
                        tempMap.push({
                            key : keyName,
                            value : rows
                            //policyidpopc : pol
                        });
                        component.set("v.showMemDetailsModalSecnd", true);
                    }
                    storeResponse.newMemberMatch =tempMap;
                    //storeResponse.newAddressMatch =tempMap; // Address Match 
                    component.set("v.memberDetails",storeResponse);
                    debugger;
                    var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                     setEvent.fire();
                }
                else if(!$A.util.isEmpty(storeResponse.accountId)){
                    var IdsPersonFamilyAccount = storeResponse.accountId.split('@');
                    //console.log(document.location.pathname.indexOf("/lightning/"));
                    var workspaceAPI = component.find("workspace");
                     var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                     setEvent.fire();
                    if(document.location.pathname.indexOf("/lightning/") != 0){
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": IdsPersonFamilyAccount[2],
                        });
                        navEvt.fire();
                    }else{
                           workspaceAPI.openTab({
                            url: '/lightning/r/Account/'+IdsPersonFamilyAccount[1]+'/view',
                            focus: true
                        }).then(function(response) {
                            var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                            setEvent.fire();
                    }).catch(function(error) {
                  });
                }
              }
            }
            else{
                 var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                 setEvent.fire();
                 helper.fireToast('Unexpected error occurred. Please try again.');
            }
        });
        $A.enqueueAction(actionValue);
    },
    searchInACETMembers : function(component, event, helper){
        var memberData = event.getParam('arguments');
        var memberWrapper = component.get("v.memberDetails");
        var actionValue = component.get('c.SaveUpdateAcetMember');
        actionValue.setParams({
            "memberDetails": memberWrapper.selectedMemberDetails,
            "memberId" : memberWrapper.memberId ,
            "policyId": memberWrapper.policyId ,
            "accountId" : memberWrapper.accountId,
            "exisRelationShip" : memberWrapper.nameRelationMap,
            "assignTo" : memberWrapper.assignTo,
             "houseHoldData" : memberWrapper.houseHoldList,
            "groupNumber" : memberData.groupNumber,
            //new  arrgumentent addition for workorder- added by ankit 
            "WoId" : memberData.workorderId
        }); 
        actionValue.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if( storeResponse != null && storeResponse != 'error'){
                    var IdsPersonFamilyAccount = storeResponse.split('@');
                    //console.log(document.location.pathname.indexOf("/lightning/"));
                    var workspaceAPI = component.find("workspace");
                    var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                     setEvent.fire();
                    if(document.location.pathname.indexOf("/lightning/") != 0){
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": IdsPersonFamilyAccount[2],
                        });
                        navEvt.fire();
                        
                    }else{
                        workspaceAPI.openTab({
                            url: '/lightning/r/Account/'+IdsPersonFamilyAccount[1]+'/view',
                            focus: true
                            
                        }).then(function(response) {
                            var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                            setEvent.fire();
                    }).catch(function(error) {
                        
                    });
                }
                }
                 else{
                 var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                 setEvent.fire();
                 helper.fireToast('Unexpected error occurred. Please try again.');
            }
            }
            else{
                 var setEvent = component.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                 setEvent.fire();
                 helper.fireToast('Unexpected error occurred. Please try again.');
            }
        });
        $A.enqueueAction(actionValue);
    }
})