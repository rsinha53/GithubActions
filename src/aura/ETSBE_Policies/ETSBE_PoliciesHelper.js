({
    getMemberPolicyNetworkDetails: function (cmp, transactionId, indexNo, helper) {
        cmp.set('v.loaded', true);
        var action = cmp.get("c.getMemberPolicyNetworkInfo");
       // alert(transactionId);
        action.setParams({
            transactionId: transactionId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            helper.hidePolicySpinner(cmp);
            if (state === "SUCCESS") {
                //US1888880
            	helper.hidePolicySpinner(cmp);
                var responseData = response.getReturnValue();
                var tableData = cmp.get("v.data");
                // responseData.networkStatus = "Out of Network";
                if (responseData.statusCode == 200) {
                    if (responseData.networkStatus == "In-Network") {
                        tableData[indexNo].providerStatusIcon = "action:approval";
                        tableData[indexNo].providerStatusIconVariant = "";
                        tableData[indexNo].providerStatus = "INN";
                    } else if (responseData.networkStatus == "Out-of-Network") {
                        tableData[indexNo].providerStatusIcon = "utility:warning";
                        tableData[indexNo].providerStatusIconVariant = "warning";
                        tableData[indexNo].providerStatus = "OON";
                    }
                } else if (responseData.statusCode == 400) {
                    // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
                    //this.fireToastMessage("Error!", responseData.statusMessage.replace(". ", ". \n"), "error", "dismissible", "10000");
                    if(responseData.faultCode != undefined && responseData.faultCode != '' && responseData.statusMessage != undefined && responseData.statusMessage != ''){
                        this.fireToastMessage("Error!", (responseData.statusMessage + '('+responseData.faultCode+')'), "error", "dismissible", "10000");
                    }
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                } else {
                    // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
                    // helper.fireToast(responseData.statusMessage);
                    if(responseData.faultCode != undefined && responseData.faultCode != '' && responseData.statusMessage != undefined && responseData.statusMessage != ''){
                        this.fireToastMessage("Error!", (responseData.statusMessage + '('+responseData.faultCode+')'), "error", "dismissible", "10000");
                    }
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                }
                cmp.set("v.data", tableData);

                //test
                //var tableData1 = cmp.get("v.data");
                //console.log('Event Status 1-> ' + tableData1[indexNo].providerStatus);
                helper.fireNetworkStatusEvent(cmp,indexNo);


            } else if (state === "ERROR") {
                //US1888880
            	helper.hidePolicySpinner(cmp);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            //US1974546 - Coverage Level Integration
            //Sanka Dharmasena - 28/08/2019
            helper.getCoverageLevel(cmp, transactionId, indexNo, helper);

            cmp.set('v.loaded', false);
        });
        $A.enqueueAction(action);

        //Fire financial event
    },

    //	helper method to call web service with selected transaction id
    firePolicyClick: function (component, event, helper) {
        var selectedTransId = event.currentTarget.getAttribute("data-trid");
        var selectedContAddress = event.currentTarget.getAttribute("data-contaddress");
        var selectedGroup = event.currentTarget.getAttribute("data-group");
        console.log('click event : ', selectedContAddress);
        //Sanka -
        var originPage = component.get("v.AutodocPageFeature");
        var clickEvent = $A.get("e.c:ETSBE_PolicyClick");
        clickEvent.setParams({
            "transaction_id": selectedTransId,
            "contact_address": selectedContAddress,
            "data_group":selectedGroup,
            "show_spinner":true,
            "originPage": originPage
        });
        clickEvent.fire();

    },

    getPolicyDataIntoAlert : function(component,event,helper){
        debugger;
        var providerTabId = component.get("v.providerTabId");
        var memberTabId = component.get("v.memberTabId");
        var selectedGroup = event.currentTarget.getAttribute("data-group");
        var clickEvent = component.getEvent("SAE_PolicyClickforAlerts");
        clickEvent.setParams({
            "data_group":selectedGroup
           
        });
        clickEvent.fire();
    },

    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function (x) {
                return primer(x[field])
            } :
            function (x) {
                return x[field]
            };
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    executeFilter: function (component, event, helper) {
        var filterIsActive = component.get('v.filterIsActive');
        var filterIsMedicalOnly = component.get('v.filterIsMedicalOnly');
        var policyList = component.get('v.dataORG');
        var newData = [];

        if (filterIsActive && !filterIsMedicalOnly) {

            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && filterIsMedicalOnly) {

            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus == "true");
                    if (IsMedicalClaim) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (filterIsActive && filterIsMedicalOnly) {
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsMedicalClaim && IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && !filterIsMedicalOnly) {

            for (var k in policyList) {
                newData.push(policyList[k]);
            }
        }
        console.log('New Data -> ' + JSON.stringify(newData));
        component.set('v.data', newData);
        //
        var highlightedRecordAvailable = false;
        for (var i in newData) {
            if (newData[i].SelectedItem == true) {
                highlightedRecordAvailable = true;
		//US1901028 - Sarma - Member CDHP Integration
                this.fireNetworkStatusEvent(component, i);
            }
        }
        if (!highlightedRecordAvailable && newData.length > 0) {
            //US2166406 - Sanka
            var originPage = component.get("v.AutodocPageFeature");
            var clickEvent = $A.get("e.c:ETSBE_PolicyClick");
            clickEvent.setParams({
                "transaction_id": newData[0].transactionId,
                "contact_address": newData[0].concatAddress,
                "originPage": originPage
            });
            clickEvent.fire();
            this.fireNetworkStatusEvent(component, 0);
            for (var i in policyList) {
                policyList[i].SelectedItem = false;
            }
            //if (newData.length > 0) {
            newData[0].SelectedItem = true;
            /*** DE294039  Added by Avish**/
            helper.hidePolicySpinner(component);
            var srnEvent = $A.get("e.c:ETSBE_AuthSRNCreateEvent");
            srnEvent.setParams({
                "termedFlag": policyList[k].termedFlag,
                "memberTabId": component.get("v.memberTabId")
            });
            srnEvent.fire();
            /*** DE294039 Ends***/
            //}
        }

        //US2038277 - Autodoc Integration - Sanka
        //if(!component.get("v.initialLoading"))
        //{
          // setTimeout(function(){
            //window.lgtAutodoc.refreshPolicyTable();
            //var componentId = component.get('v.componentId');

              // var tabKey = component.get("v.AutodocKey");

           // window.lgtAutodoc.initAutodoc(tabKey);
        	//},1);
        //}

    },

    handleCheckBoxesOnload: function(component,event,helper){
        var filterIsActive = component.get('v.filterIsActive');
        var filterIsMedicalOnly = component.get('v.filterIsMedicalOnly');
        var policyList = component.get('v.dataORG');
        var newData = [];
        var activeFound = false;
        var medicalFound = false;
        for(var k in policyList){
            if(policyList[k].planStatus == "true"){
                activeFound = true;
            }
            if(policyList[k].Plan.startsWith("Medical")){
                medicalFound = true;
            }

        }

        if (policyList.length == 0) {
            helper.fireToastMessage("error!", 'No policies found.', "error", "dismissible", "10000");
            var appEvent = $A.get("e.c:SAE_DisableTopicWhenNoPolicies");
            appEvent.setParams({
                "isDisableTopic": false
            });
            appEvent.fire();
        }

        if(!activeFound){
            helper.fireToastMessage("Warning!", 'No active policies available.', "warning", "dismissible", "10000");

        }
        if(!medicalFound){
            helper.fireToastMessage("Warning!", 'No medical policies available.', "warning", "dismissible", "10000");

        }
        component.set("v.filterIsActive", activeFound);
        component.set("v.filterIsMedicalOnly", medicalFound);
    },

    fireNetworkStatusEvent : function (component,indexNo){
        var tableData = component.get("v.data");
        var selectedpolicy = tableData[indexNo].financials;
        var providerStatus = tableData[indexNo].providerStatus;
        var eligibleDates = tableData[indexNo].eligibleDates;
        console.log('Event Status 1-> ' + tableData[indexNo].providerStatus);
        console.log('Event Status 1-> ' + JSON.stringify(tableData[indexNo].financials));
        //
        var networkEvent = component.getEvent("networkStatus");
        networkEvent.setParams({
            "selectedPolicy" : selectedpolicy,
            "networkStatus" : providerStatus,
            "eligibleDates" : eligibleDates
        });

        networkEvent.fire();
    },//US1888880 - Malinda : Spinner-show method
    showPolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },//US1888880 - Malinda : Spinner-hide method
    hidePolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    },
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },

    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    //US1761826 - UHC/Optum Exclusion UI - START
    fetchOptumExclusionGroupIds : function(component, event, helper) {
        console.log('calling helper onload method..');
        let action = component.get("c.getOptumExlusions");
        action.setCallback( this, function( response ) {
            let state = response.getState();
            if( state === "SUCCESS") {
                console.log('###POLICY-EXCLUSIONS', response.getReturnValue() );
                component.set( "v.lstExlusions", response.getReturnValue() );
            } else {
                console.log('##UNKNOWN-STATE:',state);
            }
        });
        $A.enqueueAction(action);
	},
    fireShowComponentEvent:function(component, event, helper, visible) {
        let shoHideEvent = $A.get("e.c:SAE_HideComponentsForExclusions");
        shoHideEvent.setParams({
            "hide_component": visible
        });
        shoHideEvent.fire();
    },
    //US1761826 - UHC/Optum Exclusion UI - END
    //TTS Modal Case Creation : US1852201 : START
    loadTtsTopics:function(cmp, event, helper) {
        var topicslst = ['View Member Eligibility'];
        var typelst = ['--None--'];
        //var subtypelst = ['--None--'];
        //var topicstr = cmp.get('v.cseTopic');
        //topicslst.push(topicstr);
        //console.log('##TOPIC-LIST:',topicslst);
        cmp.set('v.topicOptions', topicslst);
        //cmp.set('v.subtypeOptions', subtypelst);
        var calltopicstr = 'View Member Eligibility';
        var action = cmp.get("c.getTTSFilterMapKeyStr");
        action.setParams({
             "callTopic": calltopicstr
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.log(result);
                //console.log('###TYPE:',JSON.stringify(result));
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                   	var lst = [];
                    for(var i=0; i < result.length; i++) {
                    	typelst.push(result[i]);
                        cmp.set('v.typeOptions', typelst );
                    }
					helper.loadSubType(cmp, event, helper,calltopicstr,typelst[1]);
                }
            }

        });
        $A.enqueueAction(action);
    },

    loadSubType : function(component, event, helper,topic,type) {
        var calltopicstr = component.get("v.cseTopic");
        var calltypestr = component.get("v.cseType");
        var lstSubtype = ['--None--'];
        var action = component.get("c.getTTSFilterMapValueStr");
        action.setParams({
            "callTopic": topic,
            "keystr": type
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {                    //alert('Inside TTS'+JSON.stringify(result));

                    for(var i=0; i < result.length; i++)
                    lstSubtype.push(result[i]);
                    component.set('v.subtypeOptions', lstSubtype);
                }
            }
        });
        $A.enqueueAction(action);
    },

    //US1974546 - Coverage Level Integration
    //Sanka Dharmasena - 28/08/2019
    getCoverageLevel: function (cmp, transactionId, indexNo, helper) {
        var action = cmp.get("c.getCoverageLevel");
        action.setParams({
            transactionId: transactionId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var responseData = response.getReturnValue();
                var tableData = cmp.get("v.data");
                if (responseData.StatusCode == 200) {
                    tableData[indexNo].CoverageType = responseData.CoverageLevel;
                    //USS2221006 - START
                    //---------------------------------- DE289300 : START --------------------------------------------------------------------
                    if (!$A.util.isUndefinedOrNull(responseData.GroupNumber) && !$A.util.isUndefinedOrNull(tableData[indexNo].GroupNumber)) {                        
                        let wordTocheck = 'Unable to determine';
                        if ($A.util.isEmpty(tableData[indexNo].GroupNumber) || tableData[indexNo].GroupNumber.includes(wordTocheck)) {
                            tableData[indexNo].GroupNumber = responseData.GroupNumber;
                        }                            
                    }
                    //---------------------------------- DE289300 : END --------------------------------------------------------------------
                    //USS2221006 - END

                    cmp.set("v.data", tableData);
                }
                helper.hidePolicySpinner(cmp);
            }
        });
        $A.enqueueAction(action);
    },

     // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    setPoliciesCountAndData: function (cmp) {
        var caseWrapper = cmp.get('v.caseWrapper');
        caseWrapper.PolicyCount = (cmp.get('v.data') == undefined ? 0 : cmp.get('v.data').length);
        caseWrapper.CaseCreationFrom = 'Member_Snapshot_Policies';
        cmp.set('v.caseWrapper', caseWrapper);
    }
})