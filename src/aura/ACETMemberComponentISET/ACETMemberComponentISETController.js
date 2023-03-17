({
    init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("v.MemberId", pageReference.state.c__MemberId);
        component.set("v.MemberFirstName", pageReference.state.c__MemberFirstName);
        component.set("v.MemberLastName", pageReference.state.c__MemberLastName);
        component.set("v.MemberDOB", pageReference.state.c__MemberDOB);
        component.set("v.GroupNumber", pageReference.state.c__GroupNumber);
        
        var action = component.get('c.findMembers');
        var memberIdVal = pageReference.state.c__MemberId;
        var memberDOBVal = pageReference.state.c__MemberDOB;
        var memberFNVal = pageReference.state.c__MemberFirstName;
        var memberLNVal = pageReference.state.c__MemberLastName;
        var memberGrpNVal = pageReference.state.c__GroupNumber;
        console.log('memberIdVal>> ' + memberIdVal);
        console.log('memberDOBVal>> ' + memberDOBVal);
        console.log('memberFNVal>> ' + memberFNVal);
        console.log('memberLNVal>> ' + memberLNVal);
        console.log('memberGrpNVal>> ' + memberGrpNVal);
        
        var searchOptionVal = "";
        if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && (!$A.util.isEmpty(memberGrpNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameGroupNumberDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal))) {
            searchOptionVal = 'MemberIDName';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDLastNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDFirstNameDateOfBirth';
        } else if ((!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'NameDateOfBirth';
        } else if (memberIdVal != '' && memberDOBVal != '') {
            searchOptionVal = 'MemberIDDateOfBirth';
        }
        component.set("v.searchOptionVal", searchOptionVal);
        action.setParams({
            "memberId": memberIdVal,
            "memberDOB": memberDOBVal,
            "firstName": memberFNVal,
            "lastName": memberLNVal,
            "groupNumber": memberGrpNVal,
            "searchOption": searchOptionVal
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.respStatusCode",result.statusCode);
                console.log('code?>>>> ' + result.statusCode);
                if(result.statusCode == 200){
                    var coverageLines = result.resultWrapper.CoverageLines;
                    console.log(coverageLines);
                    for(var i = 0; i < coverageLines.length; i++) {
                        if(coverageLines[i].ITEhighlightedPolicyId == true) {
                            //US1761826 - UHC/Optum Exclusion UI : END ?
                            component.set("v.tranId", coverageLines[i].transactionId);
                            component.set("v.concatAddress", coverageLines[i].concatAddress);
                        }
                    }
                    component.set("v.memberPolicies",result.resultWrapper.CoverageLines);
                    component.set("v.memberCardData",result.resultWrapper);
                    helper.callHouseHoldWS(component, event, helper);
                    
                    
                }else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                    if((memberIdVal != '' && memberDOBVal != '' && memberFNVal !='') || (!$A.util.isEmpty(memberFNVal) && !$A.util.isEmpty(memberDOBVal) && !$A.util.isEmpty(memberIdVal))){
                        helper.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    }
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan                                                                   

                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/n/Member_Search_SNI"
                    });
                    urlEvent.fire();
                
                } else {
                    if((memberIdVal != '' && memberDOBVal != '' && memberFNVal !='') || (!$A.util.isEmpty(memberFNVal) && !$A.util.isEmpty(memberDOBVal) && !$A.util.isEmpty(memberIdVal))){
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        // US1813580 - Error Message Translation
                        component.set('v.serviceMessage', result.message);
                        helper.fireToast(result.message);
                    }
                    
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan

                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/n/Member_Search_SNI"
                    });
                    urlEvent.fire();
                }
            }else{
                if((memberIdVal != '' && memberDOBVal != '' && memberFNVal !='') || (!$A.util.isEmpty(memberFNVal) && !$A.util.isEmpty(memberDOBVal) && !$A.util.isEmpty(memberIdVal))){
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/n/Member_Search_SNI"
                    });
                    //urlEvent.fire();
                }
            }
                
        });
        $A.enqueueAction(action);
        
    },
        setShowSpinner:function (cmp, event,helper) {
            console.log('in setShowSpinner for ISET')
        var sniNotElligible= event.getParam("sniNotElligible"); //US2216710 :Code Added By Chandan
        cmp.set("v.showSpinner", false);
        console.log( cmp.get("v.showSpinner"));
        //US2216710 :Code Added By Chandan - Start
        if(sniNotElligible){
            //cmp.openModel(cmp, event,helper); 
            cmp.set("v.isModalOpen", true);
        } //US2216710 :Code Added By Chandan - End
            else{ 
            setTimeout(function(){
                var workspaceAPI = cmp.find("workspace");
                
                workspaceAPI.getAllTabInfo().then(function(response) {
                console.log('tab response333=');
                console.log(response);
                console.log('tab title='+response[0].title);
                if(response.length>0){
                for(var i=0; i< response.length;i++){
                 if(response[i].title == 'Loading...') {
                     workspaceAPI.closeTab({
                        tabId: response[i].tabId
                    });
                  }
                 }
                }
                }).catch(function(error) {
                         console.log(error);
                })
        
        },5000);
            }
    },
     closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.showMemDetailsModal",false);
          component.set("v.showMemDetailsModalSecnd",false);
    },
    
    submitDetails: function(component, event, helper) {
        try{
            helper.showGlobalSpinner(component); 
            var houseDetail = component.find('house');
            var memberDOBVal;
            var memberIdVal;
            var plcId;
            console.log("v.houseHoldData:"+component.get("v.houseHoldData"));
            var houseHoldList =component.get("v.houseHoldData");
            var sniEligible=false;
            console.log('householdlist= in submit method');
            console.log(houseHoldList);
            for(var i=0; i< houseHoldList.length;i++){
                
                if(houseHoldList[i].isMainMember == true) {
                    plcId = houseHoldList[i].policyId;
                    memberDOBVal = houseHoldList[i].dob;
                    memberIdVal = houseHoldList[i].memberId;
                }
            }
            var policyIdVar;
            plcId = plcId.toString();
            if (plcId.length < 9) {
                policyIdVar = ('0000000000' + plcId).slice(-9);
         }
         else{
                policyIdVar = plcId;
         }
        var advFullName =component.get("v.advFullName")
        var assignedToVal ; //=component.get("v.assignedToVal")
        var action = component.get("c.fetchLoginUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                console.log('storeResponse');
                console.log(storeResponse);
                console.log('storeResponse.Name')
                console.log(storeResponse.Name)
                assignedToVal=storeResponse.FederationIdentifier;
                console.log('assignedToVal@@@@@='+assignedToVal);
                houseDetail.createAccount(houseHoldList,memberDOBVal,memberIdVal,advFullName,sniEligible,policyIdVar,plcId,assignedToVal);

                
            }
        });
        $A.enqueueAction(action);
        //console.log('assignedToVal!!!!!!!!='+assignedToVal);
        component.set("v.isModalOpen", false);
              setTimeout(function(){
                var workspaceAPI = component.find("workspace");
                
                workspaceAPI.getAllTabInfo().then(function(response) {
                console.log('tab response333=');
                console.log(response);
                console.log('tab title='+response[0].title);
                if(response.length>0){
                for(var i=0; i< response.length;i++){
                 if(response[i].title == 'Loading...') {
                     workspaceAPI.closeTab({
                        tabId: response[i].tabId
                    });
                  }
                 }
                }
                }).catch(function(error) {
                         console.log(error);
                })
        
        },5000);
       }
       catch(e) {
           component.set("v.isModalOpen", false);
           console.log("Error happened:"+e.message);
           var errMsg = 'Unexpected error occurred. Please try again.';
            component.set('v.showServiceErrors', true);
            if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                component.set("v.mnf", 'mnf');
                component.set("v.checkFlagmeberCard",false);
            }
            component.set('v.serviceMessage', errMsg);
            helper.fireToast(errMsg);
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
            
        }
    }
})