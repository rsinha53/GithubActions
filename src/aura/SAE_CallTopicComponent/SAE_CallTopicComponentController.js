({

   displayClaim: function(component, event, helper){

        component.set("v.detailPgName",'Member Snapshot');
        component.set("v.originatorName",'Provider');
        component.set("v.isClaim",true);
		helper.searchHelper(component,event,'View Claims');

   },



    //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan
    processVCCD: function(component, event, helper){
        var isVCCD = event.getParam("isVCCD");
        var callTopicVccd = event.getParam("VCCDQuestionType");
        var pageName = event.getParam("pageName");
        component.set("v.isVCCD",isVCCD);
        component.set("v.VCCDQuestionType",callTopicVccd);
        console.log('callTopicVccd  '+callTopicVccd);
        let strNonEligibleTopic = $A.get("$Label.c.ACETVCCDNonEligibleTopic");
        if(!$A.util.isUndefinedOrNull(pageName) && !$A.util.isEmpty(pageName)){
		//If the funtionality invoked through vccd
		if(!$A.util.isUndefinedOrNull(isVCCD)){
			if(isVCCD){
                var tempSelection = component.get('v.tempSelection');
            tempSelection.push(callTopicVccd);
            component.set('v.tempSelection', tempSelection);
                console.log("strNonEligibleTopic"+strNonEligibleTopic);
                console.log("strNonEligibleTopic"+strNonEligibleTopic.toLowerCase().includes(callTopicVccd.toLowerCase()));
               // if(component.get("v.enableVCCD")){//Commented as part of US2880283 &  US2897253 - Sravan
				if(!$A.util.isUndefinedOrNull(callTopicVccd) && !$A.util.isEmpty(callTopicVccd)){
                    if(strNonEligibleTopic.toLowerCase().includes(callTopicVccd.toLowerCase())){
                        if(component.get("v.enableVCCD")){// US2880283 &  US2897253 - Sravan
                        component.set("v.nonEligibleTopic", true);
                        var nonEligibleCallTopic = [];
                        nonEligibleCallTopic.push('View Claims');
                        component.set("v.nonEligibleCallTopic",nonEligibleCallTopic);
                        component.get("v.nonEligibleTopic",true);
                        component.set("v.isDisableTopic",true);
                        }

                    }
                    else{
                        var getInputkeyWord = callTopicVccd;
                        //US2873801 & US2880283 - Sravan
                        if(!$A.util.isUndefinedOrNull(component.get("v.detailPgName")) && !$A.util.isEmpty(component.get("v.detailPgName"))){
                            console.log('component.get("v.detailPgName")'+ component.get("v.detailPgName"));
                            if(pageName == component.get("v.detailPgName")){
                        helper.searchHelper(component,event,getInputkeyWord);
                    }
                }

                    }
                }
                else{
                    component.set("v.isVCCD",false);
                }
			//}
			}
		}
		}
    },
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        //$A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null );
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    keyPressController : function(component, event, helper) {
        //$A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{
            component.set("v.listOfSearchRecords", null );
        }

    },
    // This function call when the end User Select any record from the result list.
    handleComponentEvent : function(component, event, helper) {

        try {
            component.set("v.SearchKeyWord",null);
            // get the selected object record from the COMPONENT event
            var listSelectedItems =  component.get("v.lstSelectedRecords");
            var selectedAccountGetFromEvent = event.getParam("recordByEvent");
            var ctrlPressed = event.getParam("ctrlPressed");
            listSelectedItems.push(selectedAccountGetFromEvent);
            component.set("v.lstSelectedRecords" , listSelectedItems);

            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');

            if(!ctrlPressed){
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
            }else{
                var forOpen = component.find("searchRes");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');
            }

            // US2465305
            var tempSelection = component.get('v.tempSelection');
            tempSelection.push(selectedAccountGetFromEvent.Name);
            component.set('v.tempSelection', tempSelection);

            setTimeout(function(){
                try {
                    component.find("callTopicId").focus();
                } catch(exception) {
                    console.log(' exception ' + exception);
                }
            });
        } catch (exception) {
            console.log(' exception ' + exception);
        }
    },
        // function for clear the Record Selaction
    clear :function(component,event, helper){
        //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - Start
        var isVCCD = component.get("v.isVCCD");
        var selectedPillId;
        if(!$A.util.isUndefinedOrNull(isVCCD) && !$A.util.isEmpty(isVCCD) && isVCCD){
             component.set("v.isVCCD",false);
             if(!component.get("v.nonEligibleTopic")){
                selectedPillId = event.getSource().get("v.name");
             }
             else{
                component.set("v.isDisableTopic",false);
                component.set("v.nonEligibleTopic",false);
             }
        }
        else{
            selectedPillId = event.getSource().get("v.name");
        }
        //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - Stop
        var AllPillsList = component.get("v.lstSelectedRecords");

        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                // US2465305
                var tempSelection = component.get('v.tempSelection');
                if (tempSelection != undefined && tempSelection.length > 0) {
                    helper.createCallTopicOrderOnClose(component, event, helper, AllPillsList[i].Name);
                    AllPillsList.splice(i, 1);
                    component.set("v.lstSelectedRecords", AllPillsList);
                } else {
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
                    helper.createCallTopicOrderOnClose(component, event, helper, '');
                }
            }
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );

    },
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    handleItemRemove: function (cmp, event) {
        var name = event.getParam("item").name;
        alert(name + ' pill was removed!');
        // Remove the pill from view
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
    },

    handleButtonClick: function (cmp, event,helper){
        var selecteditem = cmp.get("v.lstSelectedRecords");
        console.log("selecteditem>>"+selecteditem);
        cmp.set("v.callTopicLstSelected",selecteditem);
        var hasPlanbenefits = false;
	var hasViewPayments = false;
        var hasProviderLookup = false;
		var hasViewPCPReferrals = false;
        // US1866429 - Sarma : Search Claim  Number UI - 16th Aug 2019 : bool var for event fire
        var hasViewClaims = false;

        // US2061713 Open Topic View Authorization - 9/12/2019 - Sarma
        var hasAuthorizationResults = false;

        // US1955585: MVP - Opening Multiple Topics on a Snapshot Page: KAVINDA - START
        // var callTopicOrder = new Object();
        // var topicOrder = 1;

        for(var i = 0; i < selecteditem.length; i++){
            if(selecteditem[i].Name == "Plan Benefits"){
                hasPlanbenefits = true;
                var topicClick = cmp.getEvent("topicClick");
                topicClick.fire();
                // callTopicOrder.PlanBenefits = topicOrder;
                // ++topicOrder;
            }
            // US1866429 - Sarma : Search Claim  Number UI - 16th Aug 2019 : Show Claim CMP on search
            if(selecteditem[i].Name == "View Claims"){
                hasViewClaims = true;
                var openTopicBtnClick = cmp.getEvent("openTopicBtnClick");
                openTopicBtnClick.fire();
                // callTopicOrder.ViewClaims = topicOrder;
                // ++topicOrder;
            }

			//US1958009- View Payment UI - Search Open Topic
            if(selecteditem[i].Name == "View Payments"){
                hasViewPayments = true;
            //US1958804- Bharat - View Payments Check Search UI Changes updated
                var PaymentSearchEvent = cmp.getEvent("PaymentSearchEvent");
                PaymentSearchEvent.fire();
            }
           //  if(selecteditem[i].Name == "View Payments"){
           //     hasViewPayments = true;
          //  US1958804- Bharat - View Payments Check Search UI Changes
          //     var PaymentSearchEvent = cmp.getEvent("PaymentSearchEvent");
                // PaymentSearchEvent.setParams({
                //    "clickedTopic" : "View Payments"
               // });
           //    PaymentSearchEvent.fire();
        //    }
              //                 if (selecteditem[i].Name == "Provider Lookup") {
              //  hasProviderLookup = true;
              //  var topicClick = cmp.getEvent("topicClick");
              //  topicClick.setParams({
              //      "clickedTopic" : "Provider Lookup"
              //  });
             //   topicClick.fire();
                // callTopicOrder.ProviderLookup = topicOrder;
                // ++topicOrder;
         //   }
            if (selecteditem[i].Name == "Provider Lookup") {
                hasProviderLookup = true;
                var topicClick = cmp.getEvent("topicClick");
                topicClick.setParams({
                    "clickedTopic" : "Provider Lookup"
                });
                topicClick.fire();
                // callTopicOrder.ProviderLookup = topicOrder;
                // ++topicOrder;
            }
            // US3802608 - Thanish - 25th Aug 2021
            if (selecteditem[i].Name == "View Appeals") {
                hasProviderLookup = true;
                var topicClick = cmp.getEvent("topicClick");
                topicClick.setParams({
                    "clickedTopic" : "View Appeals"
                });
                topicClick.fire();
            }
             if (selecteditem[i].Name == "View PCP Referrals") {
                 hasViewPCPReferrals = true;
                var topicClick = cmp.getEvent("topicClick");
                topicClick.setParams({
                    "clickedTopic" : "View PCP Referrals"
                });
                topicClick.fire();

            }

            // US2061713 Open Topic View Authorization - 9/12/2019 - Sarma
            if(selecteditem[i].Name == "View Authorizations"){
                hasAuthorizationResults = true;
                var openAuthorization = cmp.getEvent("OpenAuthorizationResultsClick");
                openAuthorization.fire();
                // callTopicOrder.ViewAuthorizations = topicOrder;
                // ++topicOrder;
            }
            // US2061713 End

        }

        // cmp.set('v.callTopicOrder', callTopicOrder);
        // console.log('callTopicOrder');
        // console.log(cmp.get('v.callTopicOrder'));

		//US2789379 - Sravan
        if(cmp.get("v.isVCCD")){
            var tempSelection = cmp.get("v.tempSelection");
            if(!$A.util.isUndefinedOrNull(tempSelection)){
                if(!$A.util.isUndefinedOrNull(cmp.get("v.VCCDQuestionType")) && !$A.util.isEmpty(cmp.get("v.VCCDQuestionType"))){
                    if(!tempSelection.includes(cmp.get("v.VCCDQuestionType"))){
                        tempSelection.push(cmp.get("v.VCCDQuestionType"));
                        cmp.set("v.tempSelection",tempSelection);
                    }
                }
            }

        }


        //ketki open member snapshot from claim
        var preSelectedTopic = cmp.get("v.preSelectedTopic");
        if(!$A.util.isUndefinedOrNull(preSelectedTopic) && !$A.util.isEmpty(preSelectedTopic)){
             var tempSelection = cmp.get("v.tempSelection");
            if(!$A.util.isUndefinedOrNull(tempSelection)){
                if(!tempSelection.includes(preSelectedTopic)){
                    tempSelection.push(preSelectedTopic);
                    cmp.set("v.tempSelection",tempSelection);
                }
            }
        }
        //ketki open member snapshot from claim end

        // US2465305
        var tempSelection = cmp.get('v.tempSelection');
        var currentSelection = cmp.get('v.currentSelection');
        if(tempSelection.length > 0){
            currentSelection.push(tempSelection);
            cmp.set('v.currentSelection', currentSelection);
        }
        cmp.set('v.tempSelection', []);

        helper.createCallTopicOrder(cmp, event, helper);
	// US1958009- View Payment UI - Search Open Topic
       // if (hasViewPayments) {
          //  var workspaceAPI = cmp.find("workspace");
          //  workspaceAPI.openTab({
              //  pageReference: {
              //      "type": "standard__component",
               //     "attributes": {
               //         "componentName": "c__SAE_PaymentInformation"
              //      }
             //   },
            //    focus: true
         //   }).then(function (tabId) {
            //    workspaceAPI.setTabLabel({
             //       tabId: tabId,
              //      label: "View Payment"
             //   });
             //   workspaceAPI.setTabIcon({
              //      tabId: tabId,
            //        icon: "standard:currency", // none
            //        iconAlt: "View Payment"
           //     });
         //   })
     //   }
    },

	disableTopic : function(component,event,helper){
		var disableTopicBtn = event.getParam("isDisableTopic");
		component.set("v.isDisableTopic",disableTopicBtn)

	},

	// US2384514
    onClickOfEnter : function(cmp, event, helper) {
        if (event.keyCode === 13) {
            // && event.target.className != 'linkField'
            // handleButtonClick
            var func = cmp.get('c.handleButtonClick');
            $A.enqueueAction(func);
        }
    },

    // US2931847 - TECH
    openTopicFromEvent: function (cmp, event, helper) {
        helper.searchHelper(cmp, event, 'Provider Lookup', true);
    },

    //ketki open member snapshot for claim
    selectTopic: function (component, event, helper) {
        var params = event.getParam('arguments');
        var topicName = '';
        if (params) {
            component.set("v.detailPgName",params.detailPgName);
            component.set("v.originatorName",params.originatorName);
        	component.set("v.preSelectedTopic",params.topicName);
        }
        helper.searchHelper(component,event,topicName);
    },
    //ketki open member snapshot for claim end
})