({
    loadTtsTopics:function(component, event, helper) {
   // Save Case Consolidation - US3424763
     let lstTopics = !$A.util.isEmpty(component.get("v.topicOptions")) ? component.get("v.topicOptions") : [];
     let initialTopic = !$A.util.isEmpty(component.get("v.Topic")) ? component.get("v.Topic") : lstTopics[0];
     if (lstTopics.length == 0) lstTopics.push(initialTopic);
       let lstTypes = ['--None--'];

     let caseVal = component.get('v.caseWrapper');
     caseVal.AddInfoTopic = initialTopic;
     component.set('v.caseWrapper', caseVal);
     component.set("v.Topic", initialTopic);

   component.set("v.topicOptions", lstTopics);
       var calltopicstr = initialTopic;
       var action = component.get("c.getTTSFilterMapKeyStr");
       action.setParams({
           "callTopic": calltopicstr,
           "isRoutingAllowed": component.get("v.isRoutingAllowed")
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
           // lstTypes.push(result[i]);
                       // Save Case Consolidation - US3424763
                       if (component.get("v.onlyRoute") && result[i] == 'Issue Routed') {
                           lstTypes.push(result[i]);
                       } else if (component.get("v.omitRoute") && result[i] != 'Issue Routed') {
                       lstTypes.push(result[i]);
                       } else if (!component.get("v.onlyRoute") && !component.get("v.omitRoute")) {
                           lstTypes.push(result[i]);
                       }
                   }
                   lstTypes = lstTypes.sort();
                   component.set('v.typeOptions', lstTypes);
                   if(lstTypes.length==1 && component.get('v.Topic')!=undefined && component.get('v.Topic')!=null && component.get('v.Topic')=='View Member Eligibility')
                   {
                       var SubmitId = component.find("SubmitId");
                       SubmitId.focus();
                   }
               }
               this.hideCaseSpinner(component);
           }else{
               this.hideCaseSpinner(component);
           }

       });
       $A.enqueueAction(action);
   },
   loadSubType : function(component, event, helper) {
       var calltopicstr = component.get("v.cseTopic");
       var calltypestr = component.get("v.cseType");
       var lstSubtype = ['--None--'];
       this.showCaseSpinner(component);
       

       var action = component.get("c.getTTSFilterMapValueStr");
       action.setParams({
           "callTopic": calltopicstr,
           "keystr": calltypestr
       });

       action.setCallback(this, function(a) {
           var state = a.getState();
           if(state == "SUCCESS"){
       var result = a.getReturnValue();
               // US2091974 - Sanka - Case Creation
               if (!$A.util.isUndefined(result)) {
                   if (!$A.util.isEmpty(result)) {
                   for(var i=0; i < result.length; i++) {
                       if(result[i] !== 'None') {
                           lstSubtype.push(result[i]);
                       }
                   }
                   }
                   lstSubtype = lstSubtype.sort();
                   component.set('v.subtypeOptions', lstSubtype);

                   let selectedValue =  component.get("v.cseType");
                   var subTypeList=component.get('v.subtypeOptions');
                   var typeList=component.get('v.typeOptions');
                   if(selectedValue!='--None--' && lstSubtype.length>1 && component.get('v.Topic')!=undefined && component.get('v.Topic')!=null && component.get('v.Topic')=='View Member Eligibility')
                   {
                       var subType = component.find("csesubtype");
                       subType.focus();
                   }
                   else if(selectedValue!='--None--' && lstSubtype.length==1 && component.get('v.Topic')!=undefined && component.get('v.Topic')!=null && component.get('v.Topic')=='View Member Eligibility')
                   {
                       var SubmitId = component.find("SubmitId");
                       SubmitId.focus();
                   }
                   else if(typeList.length==1  && component.get('v.Topic')!=undefined && component.get('v.Topic')!=null && component.get('v.Topic')=='View Member Eligibility')
                   {
                       var SubmitId = component.find("SubmitId");
                       SubmitId.focus();
                   }
               }
               this.hideCaseSpinner(component);
           }else{
               this.hideCaseSpinner(component);
           }
       });
       $A.enqueueAction(action);
   },
   caseCreation : function(component, event, helper) {

       var ttsType = component.find("csetype").get("v.value");
       var ttsSubType = component.find("csesubtype").get("v.value");
       //US2038277 - Autodoc Integration - Sanka
       let caseVal = component.get('v.caseWrapper');
       caseVal.ttsType = ttsType;
       caseVal.ttsSubType = ttsSubType;

       caseVal.freeFormCommentsVal = component.get("v.freeFormCommentsVal");//_setandgetComments.getCaseComments(caseVal.AddInfoTopic+caseVal.Interaction);
       var autodocHidden = document.getElementById("autodocHidden").value;
       autodocHidden = autodocHidden.replace("<div></div>","");

       // US2320729 - Thanish - 4th Mar 2020 - remove provider search results fixed height from autodoc.
       // autodocHidden = autodocHidden.replace(/100%/g, "auto").replace(/640px/g, "auto");
       // US2271237
       autodocHidden = autodocHidden.replace(/640px/g, "auto");

       var caseItems = document.getElementById("autodocCaseItemsHidden").value;
       caseVal.AutoDoc = autodocHidden;
       caseVal.AutoDocCaseItems = caseItems;

       //US2396656 - Make SRN field empty when there is no case item avilable in the object
       if (!$A.util.isUndefinedOrNull(caseVal) && !$A.util.isUndefinedOrNull(caseVal.AutoDocCaseItems) && !$A.util.isUndefinedOrNull(caseVal.TaxId)) {
           //Flow - Provider search
           if ($A.util.isEmpty(caseVal.AutoDocCaseItems) && !$A.util.isEmpty(caseVal.TaxId)) {
           // Variable - AutoDocCaseItems part of old autodoc framework and not in use - below line commented
               //caseVal.TaxId = '';
           }
       }

       //US3068299 - Sravan - 21/11/2020 - Start
      if(component.get("v.isFacetsEnabled") == 'TRUE' && ((!$A.util.isUndefinedOrNull(component.get("v.facetFlowPolicies")) && !$A.util.isEmpty(component.get("v.facetFlowPolicies"))) || (caseVal.AddInfoTopic == 'Member Not Found'  && ttsType == 'Issue Routed'))){//US2951245 - Sravan
           caseVal.createFacetsCase = true;
       }
       else{
           caseVal.createFacetsCase = false;
       }
      if((!$A.util.isUndefinedOrNull(component.get("v.orsFlowPolicies")) && !$A.util.isEmpty(component.get("v.orsFlowPolicies"))) || caseVal.AddInfoTopic == 'Provider Details' || caseVal.AddInfoTopic == 'Provider Not Found' || (caseVal.AddInfoTopic == 'Member Not Found' && ttsType != 'Issue Routed')|| caseVal.SubjectType == 'Provider' || caseVal.MisdirectReason != null){
           caseVal.createORSCase = true;
       }
       else{
           caseVal.createORSCase = false;
       }
       //US3068299 - Sravan - 21/11/2020 - End

       //US3182779 - Sravan - Start
       helper.filterExchangePolicies(component,event,helper);
       //US3182779 - Sravan - End

       //US3149404 - Sravan - Start
       //US3138410 - Sravan
       var finalPolicyMap = component.get("v.finalPolicyMap");
       var providerDetailItems = component.get("v.providerDetailItems");
       if(caseVal.AddInfoTopic != 'Member Not Found'){
           caseVal.relatedCaseItems = ''; 
       }
       if(!$A.util.isUndefinedOrNull(finalPolicyMap) && !$A.util.isEmpty(finalPolicyMap)){
           var allRelatedCaseItemMap = {};
           for(var key in finalPolicyMap){
			   console.log('Policy Key'+ key);
			   var relatedCaseItemMap = {};
			   relatedCaseItemMap = finalPolicyMap[key].relatedCaseItemsMap;
			   allRelatedCaseItemMap[finalPolicyMap[key].selectedGroup] = relatedCaseItemMap;
			   for(var caseItemKey in relatedCaseItemMap){
				   console.log('Case Item Key'+ caseItemKey);
                   var SkipPaCheck = false;
                   if(relatedCaseItemMap[caseItemKey].uniqueKey == 'PA Check' && ttsType == 'System Unavailable'){
                         SkipPaCheck = true;
                   }
                   if(!SkipPaCheck){
               if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
						caseVal.relatedCaseItems = 'External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
               }
               else{
					   caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
					}
                    }
               }
           }
           caseVal.allrelatedCaseItemMap = allRelatedCaseItemMap;
       }
      else{
          //US3353397 - Sravan - Start
           var relatedCaseItemMap = component.get("v.relatedCaseItemMap");

           console.log('Provider Case Items'+ JSON.stringify(relatedCaseItemMap));
           var providerDetailItems = component.get("v.providerDetailItems");
           if(caseVal.AddInfoTopic == 'Provider Details'){
			   var caseItemMap = {};
               if(!$A.util.isUndefinedOrNull(providerDetailItems) && !$A.util.isEmpty(providerDetailItems)){
                   for(var key in providerDetailItems){
                       if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                           caseVal.relatedCaseItems = 'External ID '+providerDetailItems[key];
                       }
                       else{
                           caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+providerDetailItems[key];
                       }
					   var caseItem = {};
					   caseItem.uniqueKey = providerDetailItems[key];
					   caseItem.isResolved =  true;
					   caseItem.topic = caseVal.AddInfoTopic;
                       countProvider = countProvider+1;
					   caseItemMap[0] = caseItem;
                   }

           }
           if(!$A.util.isUndefinedOrNull(relatedCaseItemMap) && !$A.util.isEmpty(relatedCaseItemMap)){

               var count = 0;
               for(var key in relatedCaseItemMap){
				   console.log('Provider Deatail Map'+ JSON.stringify(relatedCaseItemMap[key]));
				   var relatedCaseItem = relatedCaseItemMap[key];
				   for(var relatedKey in relatedCaseItem){
                   if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                          caseVal.relatedCaseItems = relatedCaseItem[relatedKey].uniqueKey;
                   }
                   else{
                          caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+relatedCaseItem[relatedKey].uniqueKey;
                        }
                    count = count + 1;
				        var caseItem = {};
				        caseItem.uniqueKey = relatedCaseItem[relatedKey].uniqueKey;
				        caseItem.isResolved =  relatedCaseItem[relatedKey].isResolved;
				        caseItem.topic = caseVal.AddInfoTopic;
				    caseItemMap[count] = caseItem;
                   }
                }
               }
           }
		   caseVal.relatedCaseItemsMap = caseItemMap;
		   console.log('caseItemMap'+ JSON.stringify(caseItemMap));


          //US3353397 - Sravan - End
      }
      //US3691709 - Sravan
      if(component.get("v.isProviderSnapProviderLookUp")){
        var providerSnapProviderCaseItems = component.get("v.relatedCaseItemMap");
        var providercaseItemMap = {};
        if(!$A.util.isUndefinedOrNull(providerDetailItems) && !$A.util.isEmpty(providerDetailItems)){
            var countProvider = 0;
            for(var key in providerDetailItems){
                if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                    caseVal.relatedCaseItems = 'External ID '+providerDetailItems[key];
                }
                else{
                    caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+providerDetailItems[key];
                }
                var caseItem = {};
                caseItem.uniqueKey = providerDetailItems[key];
                caseItem.isResolved =  true;
                caseItem.topic = caseVal.AddInfoTopic;
                countProvider = countProvider+1;
                providercaseItemMap[countProvider] = caseItem;
            }
         }
     if(!$A.util.isUndefinedOrNull(providerSnapProviderCaseItems) && !$A.util.isEmpty(providerSnapProviderCaseItems)){

          for(var key in providerSnapProviderCaseItems){
             console.log('Provider Deatail Map'+ JSON.stringify(providerSnapProviderCaseItems[key]));
             var relatedProviderCaseItem = providerSnapProviderCaseItems[key];
             for(var relatedKey in relatedProviderCaseItem){
                  if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                    caseVal.relatedCaseItems ='External ID '+ relatedProviderCaseItem[relatedKey].uniqueKey;
                  }
                  else{
                    caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+relatedProviderCaseItem[relatedKey].uniqueKey;
                  }
                  var caseItem = {};
                  caseItem.uniqueKey = relatedProviderCaseItem[relatedKey].uniqueKey;
                  caseItem.isResolved =  relatedProviderCaseItem[relatedKey].isResolved;
                  caseItem.topic = caseVal.AddInfoTopic;
                  providercaseItemMap[relatedKey+1] = caseItem;
             }
         }
     }
    caseVal.relatedCaseItemsMap = providercaseItemMap;
}
//US3691709 - Sravan
if(caseVal.AddInfoTopic == 'Member Not Found'){
            var index = 0; // US3653469 - Krish - 9th Aug 2021
    var caseItemForMemberNotFound= {};
    var memberNotFoundCaseItems = component.get("v.memberNotFoundCaseItems");
    if(!$A.util.isUndefinedOrNull(memberNotFoundCaseItems) && !$A.util.isEmpty(memberNotFoundCaseItems)){
        for(var key in memberNotFoundCaseItems){
          if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                caseVal.relatedCaseItems = 'External ID '+memberNotFoundCaseItems[key];
          }
          else{
                caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+memberNotFoundCaseItems[key];
          }
          var caseItem = {};
          caseItem.uniqueKey = memberNotFoundCaseItems[key];
          caseItem.isResolved =  true;
          caseItem.topic = caseVal.AddInfoTopic;
                    // caseItemForMemberNotFound[0] = caseItem; // US3653469 - Adding Case items for all plan types - Krish - 9th Aug 2021
                    caseItemForMemberNotFound[index++] = caseItem; // US3653469 - Adding Case items for all plan types - Krish - 9th Aug 2021
     }
        caseVal.relatedCaseItemsMap = caseItemForMemberNotFound;
    }

}
//US3691709 - Sravan
    if(caseVal.AddInfoTopic == 'Provider Not Found'){
        var providerNotFoundMap = component.get("v.providerNotFoundMap");
        var providerNotFoundCaseItems = {}
        if(!$A.util.isUndefinedOrNull(providerNotFoundMap) && !$A.util.isEmpty(providerNotFoundMap)){
            for(var providerKey in providerNotFoundMap){
                if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                    caseVal.relatedCaseItems = 'External ID '+providerNotFoundMap[providerKey];
                }
                else{
                    caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+' External ID '+providerNotFoundMap[providerKey];
                }
                var caseItem = {};
                caseItem.uniqueKey = providerNotFoundMap[providerKey];
                caseItem.isResolved =  true;
                caseItem.topic = caseVal.AddInfoTopic;
                providerNotFoundCaseItems[0] = caseItem;
            }
        }

        caseVal.relatedCaseItemsMap = providerNotFoundCaseItems;
    }
       //US3149404 - Sravan - End

       var autoDocPacheck = caseVal.savedAutodoc;
       var parseAutodoc = JSON.parse(autoDocPacheck);
       var PACheckExtId="PA Check";
       var isPAcheck = false;
       for(var i=0; i< parseAutodoc.length; i++){
           //var autoDocValueRow = parseAutodoc[i];
           if(!$A.util.isUndefinedOrNull(parseAutodoc[i])){
               if(!$A.util.isUndefinedOrNull(parseAutodoc[i].componentName) && !$A.util.isUndefinedOrNull(parseAutodoc[i].caseItemExtId)){
                   if(parseAutodoc[i].componentName=="Provider and Member Information" && (parseAutodoc[i].caseItemExtId == "PA Check" || parseAutodoc[i].caseItemExtId == "OPTUMHEALTH AUTH")){
                       isPAcheck = true;
                       for(var j=0; j< parseAutodoc[i].cardData.length; j++){//var key in parseAutodoc[i].cardData
                           var fieldData = parseAutodoc[i].cardData[j];
                           if(fieldData.fieldName=="OPTUMHEALTH AUTH" && fieldData.checked){
                               parseAutodoc[i].caseItemExtId ="OPTUMHEALTH AUTH";
                               parseAutodoc[i].caseItemsExtId = "OPTUMHEALTH AUTH";
                               PACheckExtId="OPTUMHEALTH AUTH";
                               break;
                           }
                       }
                   }
               }
           }

        }
       
       if(PACheckExtId == "OPTUMHEALTH AUTH") {  
           for(var i=0; i< parseAutodoc.length; i++){
               if(!$A.util.isUndefinedOrNull(parseAutodoc[i])){
                   if((!$A.util.isUndefinedOrNull(parseAutodoc[i].componentName) && parseAutodoc[i].componentName=="Date of Service and Place of Service") ||
                      (!$A.util.isUndefinedOrNull(parseAutodoc[i].autodocHeaderName) && parseAutodoc[i].autodocHeaderName=="Authorization Results")){
                       if(!$A.util.isUndefinedOrNull(parseAutodoc[i].caseItemsExtId) && parseAutodoc[i].caseItemsExtId == "PA Check"){
                           parseAutodoc[i].caseItemsExtId = "OPTUMHEALTH AUTH";
                       }
                   }
               }
           }  
       }

        caseVal.savedAutodoc = JSON.stringify(parseAutodoc);

        var topic_benefits =component.get('v.Topic');
        if(topic_benefits == 'Plan Benefits' && ttsType == 'System Unavailable')
        {
            if(isPAcheck){
                if($A.util.isUndefinedOrNull(caseVal.relatedCaseItems) || $A.util.isEmpty(caseVal.relatedCaseItems)){
                    caseVal.relatedCaseItems = "External ID "+PACheckExtId;
                }else{
                    caseVal.relatedCaseItems = caseVal.relatedCaseItems+','+"External ID "+PACheckExtId;
                }
            }

        }

        var strWrapper = JSON.stringify(caseVal);
        
        //Preventing case creation before routing screen-Sravan
        component.set("v.caseWrapper",caseVal);


		//chandra-Start
        var topic=component.get('v.Topic');
        //Chandra US2904624
        if(topic == 'View Claims' && ttsType == 'Issue Routed' && (ttsSubType == 'Paid Correctly, Pre-Appeal Reconsideration' || ttsSubType=='Stop Pay and Reissue'))
        {
            helper.navigateToORSRoutingScreen(component);
        }
        else if(topic == 'View Claims' && ttsType == 'Issue Routed')
        {
            helper.navigateToORSRoutingScreen(component);
        }
        //chandra-End
       else if(ttsType == 'Issue Routed' && ttsSubType == 'Network Management Request' && caseVal.createORSCase == true)
        {	//Navigating to routing screen
			helper.navigateToORSRoutingScreen(component);
       } else if(component.get("v.isFacetsEnabled") == 'TRUE' && ttsType == 'Issue Routed' && (ttsSubType == 'COB Investigation Initiated' || ttsSubType == 'Eligibility Investigation Initiated' || ttsSubType == 'Network Management Request') && caseVal.createFacetsCase == true ) {
          //Navigating to routing screen
          helper.navigateToFacetsRoutingScreen(component);
		}
		else{
        var action = component.get("c.saveTTSCase");
        action.setParams({
        	'strRecord': strWrapper,
            'isProvider': component.get("v.isProvider")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // component.set('v.IsCaseSaved', false);
                var response = response.getReturnValue();

                // US2718112 - Thanish - 2nd Jul 2020
                var caseCreatedEvt = component.getEvent("ACETCaseCreated");
                caseCreatedEvt.setParams({"caseId" : response });
                caseCreatedEvt.fire();

                //alert(response);
               /* var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": response,
                  "slideDevName": "Detail"
                });
                navEvt.fire();*/
                // DE322503 - Resetting button autodoc during case save - Sarma    
                var clickEvent = $A.get("e.c:ACET_ButtonAutodocResetEvent");
                var pagefeature = component.get("v.pagefeature");
                clickEvent.setParams({
                    "AutodocPageFeature": pagefeature
                });
                clickEvent.fire(); 

              //US3068299 - Sravan - 21/11/2020 - This method is used for both ORS and FACETS
               component.set("v.caseId",response);
              helper.createExternalCases(component, event, helper);


           } else if (state === "INCOMPLETE") {

           } else if (state === "ERROR") {
               var errors = response.getError();
               if (errors) {
                   if (errors[0] && errors[0].message) {
                       console.log("Error message: " + errors[0].message);
                   }
               } else {
                   console.log("Unknown error");
               }
           }
       });
       $A.enqueueAction(action);
       }
   },
   //US1851066	Pilot - Case - Save Button & Case Creation Validations - 15/10/2019 - Sarma
   fireSaveCaseValidations: function(cmp, event, helper) {
       var typeList = cmp.get('v.typeOptions');
       var subTypeList = cmp.get('v.subtypeOptions');
       var selectedType = cmp.get('v.cseType');
       var selectedSubType = cmp.get('v.cseSubtype');
       var isValidationSuccess = true;

       if(typeList.length > 1){
           if(selectedType == '' || selectedType == '--None--' || selectedType == 'None' || selectedType == undefined || selectedType == null){
               isValidationSuccess = false;
               $A.util.addClass(cmp.find('csetype'), 'slds-has-error');
               cmp.set('v.isShowTypeError', true);
           } else {
               cmp.set('v.isShowTypeError', false);
               $A.util.removeClass(cmp.find('csetype'), 'slds-has-error');
           }
       } else{
           cmp.set('v.isShowTypeError', false);
           $A.util.removeClass(cmp.find('csetype'), 'slds-has-error');
       }

       if(subTypeList.length > 1){
           if(selectedSubType == '' || selectedSubType == '--None--' || selectedSubType == 'None' || selectedSubType == undefined || selectedSubType == null){
               isValidationSuccess = false;
               $A.util.addClass(cmp.find('csesubtype'), 'slds-has-error');
               cmp.set('v.isShowSubTypeError', true);
           } else{
               cmp.set('v.isShowSubTypeError', false);
               $A.util.removeClass(cmp.find('csesubtype'), 'slds-has-error');
           }
       } else{
           cmp.set('v.isShowSubTypeError', false);
           $A.util.removeClass(cmp.find('csesubtype'), 'slds-has-error');
       }

       return isValidationSuccess;
   },

   // US1934396 - Thanish - 17th Feb 2020
   // returns true if atleast one autodoc checkbox is checked for the section whose page feature is passed, otherwise false.
   checkAutodocSelection: function(pagefeature) {
       let componentList = document.getElementsByClassName(pagefeature);

        if(!$A.util.isEmpty(componentList)) {
            let component;
            for(component of componentList) {
                let elementList = component.getElementsByClassName("autodoc");

               let element;
               for(element of elementList) {
                   //US2396656 - Exclude table header checkbox as an auto doc
                   if (element.parentNode.tagName != "TH") {
                   if((element.getAttribute("type") == "checkbox") && element.checked) {
                       return true;
                   }
               }
           }
       }
       }

       return false;
   },

   showCaseSpinner: function (cmp) {
       var spinner = cmp.find("case-spinner");
       $A.util.removeClass(spinner, "slds-hide");
       $A.util.addClass(spinner, "slds-show");
   },

    hideCaseSpinner: function (cmp) {
        var spinner = cmp.find("case-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

   // Create ORS
   navigateToCase: function(component, caseId){
       // US2815284 - Sanka
       this.callRefreshEvent(component);

       //US1851066	Pilot - Case - Save Button & Case Creation Validations - 15/10/2019 - Sarma
       let cmpEvent = component.getEvent("closeModalBox");
       cmpEvent.fire();

       //DE273498 - Closing tts modal box - 23/10/2019 - Sarma
       component.set("v.isModalOpen", false);

       // US2037798	Pilot - Create Additional  TTS for View Member Eligibility - 23/10/2019 - Sarma
       component.set('v.isButtonDisabled',false);

       var toastEvent = $A.get("e.force:showToast");
       toastEvent.setParams({
           "title": "Success!",
           "message": "The case record has been created successfully.",
           "type": "success"
       });

        // US2718112 - Thanish - 2nd Jul 2020
        // localStorage.removeItem("rowCheckHold");
        window.localStorage.clear();

        //US1921739
        if(!$A.util.isEmpty(caseId)){
            toastEvent.fire();
        }

        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            url: '#/sObject/'+caseId+'/view',
            focus: true
        });
    },
    
    navigateToORSRoutingScreen: function (component) {
        //alert(component.get("v.isMemberLookup"));
        console.log('Case Wrapper'+ JSON.stringify(component.get("v.caseWrapper")));
        component.set('v.isButtonDisabled', false);
        localStorage.removeItem("rowCheckHold");
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_ServiceRequestRouting" // c__<comp Name>
                                },
                                "state": {
                        "c__caseWrapper": component.get("v.caseWrapper"),
                        "c__isProvider": component.get("v.isProvider"),
                        "c__isMemberLookup":component.get("v.isMemberLookup"),
			            "c__ttsTopic": component.get("v.Topic"),
                        "c__pagefeature": component.get("v.pagefeature"),
                        "c__AutodocKey": component.get("v.autodocUniqueId"), // DE376017 - Thanish - 22nd Oct 2020
                        "c__uhcProduct": component.get("v.uhcProduct"),
                        "c__freeFormCommentsVal": component.get("v.freeFormCommentsVal"),
                        "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"), //DE347387
                        "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"), //DE347387
						"c__ttsType":component.find("csetype").get("v.value"),//chandra US2904624
						"c__ttsSubType": component.find("csesubtype").get("v.value"),//chandra US2904624
                       "c__finalPolicyMap":component.get("v.finalPolicyMap"),//US3068299 - Sravan - 21/11/2020
                       "c__memberMap":component.get("v.memberMap"),//US3068299 - Sravan - 21/11/2020
                      "c__memberPolicyNumberMap": component.get("v.memberPolicyNumberMap"),//US3117073 - Sravan - 29/12/2020
                     "c__flowDetails": component.get("v.flowDetails"),//US3259671 - Sravan - 16/03/2021
                     "c__isFacetsCase": false, //US3068299 - Sravan - 21/11/2020
                     "c__mapClaimSummaryDetails": JSON.stringify(component.get("v.mapClaimSummaryDetails"))

                    }
                },
                focus: true
            }).then(function (response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function (tabInfo) {
                    let cmpEvent = component.getEvent("closeModalBox");
                    cmpEvent.fire();
                    component.set("v.isModalOpen", false);
                    var focusedTabId = tabInfo.tabId;
                    var tabLabel = "Service Request Routing";
                    workspaceAPI.setTabLabel({
                        tabId: focusedTabId,
                        label:tabLabel
                    });
                    workspaceAPI.setTabIcon({                    
                        tabId: focusedTabId,
                        icon: "utility:send",
                        iconAlt: "Service Request Detail"                    
                    });
                });
               
            }).catch(function (error) {
                console.log(error);
            });
        });
       //$A.util.addClass(component.find("hidePopup"), "slds-hide");
    },

    // US2928159 - Thanish - 2nd Oct 2020
    checkCaseItemStatus: function (cmp) {
        var caseType = cmp.get("v.cseType");
        var autodocValue = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var allResolved = true;
        var caseWrapper = cmp.get("v.caseWrapper");
        var checkedTablesCount = 0; // DE435930 - Thanish - 22nd Apr 2021
        // US350783 - Case Consolidation - Validations
        var researchTypes = ['View Member Eligibility', 'Provider Lookup', 'View Claims'];
        var omitResearch = researchTypes.includes(caseWrapper.AddInfoTopic) ? true : false;
        if(!$A.util.isEmpty(autodocValue)){
            for(var i=0; i<autodocValue.length; i++){
               if(autodocValue[i].type == "table" && !$A.util.isEmpty(autodocValue[i].selectedRows) && autodocValue[i].componentName != "Household" ){//DE397183 - Sravan
                    if(!autodocValue[i].ignoreAutodocWarningMsg || caseWrapper.AddInfoTopic != 'View Member Elibility'){ 
                        checkedTablesCount++; // DE435930 - Thanish - 22nd Apr 2021
                        for(var j=0; j<autodocValue[i].selectedRows.length; j++) {
                            if(!autodocValue[i].selectedRows[j].resolved){
                                allResolved = false;
                                break;
                            }
                        }
                    }
                }
                if(!allResolved){
                    break;
                }
        }
        }
       //US3071655  - Sravan
       if((caseType=='Issue Resolved' || caseType=='System Unavailable') && !allResolved){ // DE391781 - Thanish - 20th Jan 2021
                        cmp.set("v.showResolvedMessage", true);
                        cmp.set("v.enableAutodocWarningMessage",true);
                        return false;

        } else if((caseType == 'Issue Routed' || caseType == 'Research') && (checkedTablesCount > 0) && allResolved && !omitResearch){ // DE435930 - Thanish - 22nd Apr 2021
                        cmp.set("v.showUnResolvedMessage", true);
                        cmp.set("v.enableAutodocWarningMessage",true);
                        return false;

        } else{
        return true;
        }
    },

    // US2581517 - Thanish - 11th May 2020
    processSelectedAutodoc: function (component, event, helper) {
        window.setTimeout($A.getCallback(function(){
            helper.showCaseSpinner(component);
            var pagefeature = component.get("v.pagefeature");
            var pagenum = component.get("v.pageNumber");

            if (pagenum != undefined) {
                window.lgtAutodoc.storePaginationData(pagenum, component.get("v.AutodocKey"));
            }
            window.lgtAutodoc.saveAutodoc(pagefeature, component.get("v.AutodocKey"));

            helper.hideCaseSpinner(component);
        }),1);
    },

   //US3068299 - Sravan - 21/11/2020
   filterPolicies: function(component, event, helper){
      var selectedPolicies = component.get("v.selectedPolicies");
      var orsFlowPolicies = [];
      var facetFlowPolicies = [];
      if(!$A.util.isUndefinedOrNull(selectedPolicies) && !$A.util.isEmpty(selectedPolicies)){
          for(var selectedKey in selectedPolicies){
              if(!$A.util.isUndefinedOrNull(selectedPolicies[selectedKey].selectedSourceCode) && !$A.util.isEmpty(selectedPolicies[selectedKey].selectedSourceCode)){
                    if(selectedPolicies[selectedKey].selectedSourceCode == 'AP'){
                        facetFlowPolicies.push(selectedPolicies[selectedKey]);
                        }
                        else{
                        orsFlowPolicies.push(selectedPolicies[selectedKey]);
                    }
                }
            }
            if(!$A.util.isUndefinedOrNull(facetFlowPolicies) && !$A.util.isEmpty(facetFlowPolicies)){
                component.set("v.facetFlowPolicies",facetFlowPolicies);
            }
            if(!$A.util.isUndefinedOrNull(orsFlowPolicies) && !$A.util.isEmpty(orsFlowPolicies)){
                component.set("v.orsFlowPolicies",orsFlowPolicies);
            }
            helper.framePolicyMaps(component, event, helper);
        }
    },
    //US3068299 - Sravan - 21/11/2020
    framePolicyMaps: function(component,event, helper){
        var finalPolicyMap = {};
        var facetFlowPolicies =  component.get("v.facetFlowPolicies");
        var orsFlowPolicies =  component.get("v.orsFlowPolicies");
        //Load Facet Map
        if(!$A.util.isUndefinedOrNull(facetFlowPolicies) && !$A.util.isEmpty(facetFlowPolicies)){
            for(var facetKey in facetFlowPolicies){
                var fkey = facetFlowPolicies[facetKey].selectedGroup+facetFlowPolicies[facetKey].selectedSourceCode+facetFlowPolicies[facetKey].memberId;
                    finalPolicyMap[fkey] = facetFlowPolicies[facetKey];    
                }
            }
        //Load ORS Map
        if(!$A.util.isUndefinedOrNull(orsFlowPolicies) && !$A.util.isEmpty(orsFlowPolicies)){
            for(var orsKey in orsFlowPolicies){
               //US2637492 - Member Snapshot - Add DIV to CO Source Code - Sravan - Start
                var selectedSourceCode = orsFlowPolicies[orsKey].selectedSourceCode;
               var fetchSourceCode = [];
               if(!$A.util.isUndefinedOrNull(selectedSourceCode) && !$A.util.isEmpty(selectedSourceCode)){
                   if(selectedSourceCode !=  '--'){
                       fetchSourceCode = selectedSourceCode.split('-');
                   }
               }
               if(!$A.util.isUndefinedOrNull(fetchSourceCode) && !$A.util.isEmpty(fetchSourceCode)){
                    var key = orsFlowPolicies[orsKey].selectedGroup+fetchSourceCode[0].trim()+orsFlowPolicies[orsKey].memberId;
                        finalPolicyMap[key] =  orsFlowPolicies[orsKey];
                    }
                }
            }
        if(!$A.util.isUndefinedOrNull(finalPolicyMap) && !$A.util.isEmpty(finalPolicyMap)){
            component.set("v.finalPolicyMap",finalPolicyMap);
        }

		console.log('Final Filtered Policies'+ JSON.stringify(component.get("v.finalPolicyMap")));

    },

    //US3068299 - Sravan - 21/11/2020
    createExternalCases: function(component, event, helper){

        var caseWrapper = component.get("v.caseWrapper");
        var finalPolicyMap = component.get("v.finalPolicyMap");
		var memberMap = component.get("v.memberMap");
       console.log('Member Map In Case Creation'+ JSON.stringify(memberMap));
        if(!$A.util.isUndefinedOrNull(finalPolicyMap) && !$A.util.isEmpty(finalPolicyMap)){
            for(var key in finalPolicyMap){
                if(finalPolicyMap.hasOwnProperty(key)){
                    caseWrapper.SubjectGroupId = finalPolicyMap[key].selectedGroup;
                    caseWrapper.SubjectId =  finalPolicyMap[key].memberId;
					caseWrapper.policyNumber = finalPolicyMap[key].selectedGroup;
					caseWrapper.strSourceCode = finalPolicyMap[key].selectedSourceCode;
					caseWrapper.strMemberId = finalPolicyMap[key].memberId;
                   //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - Start
                   var memberPolicyNumberMap = component.get("v.memberPolicyNumberMap");
                   console.log('memberPolicyNumberMap'+ JSON.stringify(memberPolicyNumberMap));
                   console.log('finalPolicyMap[key].selectedGroup'+ finalPolicyMap[key].selectedGroup);
                   if(!$A.util.isUndefinedOrNull(memberPolicyNumberMap) && !$A.util.isEmpty(memberPolicyNumberMap)){
                        if(memberPolicyNumberMap.hasOwnProperty(finalPolicyMap[key].selectedGroup)){
                            caseWrapper.policyNumber = memberPolicyNumberMap[finalPolicyMap[key].selectedGroup];
                        }
                   }
                   //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - End

                   //US3149404 - Sravan - Start
				    var relatedCaseItemMap = finalPolicyMap[key].relatedCaseItemsMap;
					caseWrapper.relatedCaseItemsMap = relatedCaseItemMap;
					if(!$A.util.isUndefinedOrNull(relatedCaseItemMap) && !$A.util.isEmpty(relatedCaseItemMap)){
						caseWrapper.relatedCaseItems = '';
						for(var caseItemKey in relatedCaseItemMap){
							if($A.util.isUndefinedOrNull(caseWrapper.relatedCaseItems) || $A.util.isEmpty(caseWrapper.relatedCaseItems)){
								caseWrapper.relatedCaseItems = 'External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
							}
							else{
								caseWrapper.relatedCaseItems = caseWrapper.relatedCaseItems+','+' External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
							}
						}
					}
                   //US3149404 - Sravan - End


                    if(finalPolicyMap[key].selectedSourceCode != 'AP'){
                        //caseWrapper.allowOpenCaseCreation = finalPolicyMap[key].isUnResolved;
                        //caseWrapper.allowCloseCaseCreation = finalPolicyMap[key].isResolved;
                    }
                    var topic_benefits =component.get('v.Topic');//csetype
                    var ttsType = caseWrapper.ttsType;//component.get('v.csetype');
                    if(topic_benefits == 'Plan Benefits' && ttsType == 'System Unavailable')
                    {


                        var autoDocPacheck = caseWrapper.savedAutodoc;
                        //caseWrapper.relatedCaseItems = caseWrapper.relatedCaseItems+','+"External ID PA Check"
                        var parseAutodoc = JSON.parse(autoDocPacheck);
                        var PACheckExtId="PA Check";
                        var isPACheck = false;
                        for(var i=0; i< parseAutodoc.length; i++){
                            var autoDocValueRow = parseAutodoc[i];
                            if(!$A.util.isUndefinedOrNull(autoDocValueRow)){
                                if(!$A.util.isUndefinedOrNull(autoDocValueRow.componentName) && !$A.util.isUndefinedOrNull(autoDocValueRow.caseItemExtId)){
                                    if(autoDocValueRow.componentName=="Provider and Member Information" && (autoDocValueRow.caseItemExtId == "PA Check" || autoDocValueRow.caseItemExtId == "OPTUMHEALTH AUTH")){
                                        isPACheck = true;
                                        for(var j=0; j< autoDocValueRow.cardData.length; j++){
                                            var fieldData = autoDocValueRow.cardData[j];
                                            if(fieldData.fieldName=="OPTUMHEALTH AUTH" && fieldData.checked){
                                                PACheckExtId="OPTUMHEALTH AUTH";
                                                break;
                                            }
                                        }
                                    }
                                }
                            }

                        }
                        if(isPACheck){
                            if($A.util.isUndefinedOrNull(caseWrapper.relatedCaseItems) || $A.util.isEmpty(caseWrapper.relatedCaseItems)){
                                caseWrapper.relatedCaseItems = "External ID "+PACheckExtId;
                            }else{
                                caseWrapper.relatedCaseItems = caseWrapper.relatedCaseItems+','+"External ID "+PACheckExtId;
                            }
                        }

                    }

                    component.set("v.caseWrapper",caseWrapper);
                    if(finalPolicyMap[key].selectedSourceCode != 'AP'){
                        //ORS Flow
                        helper.createOrsCase(component, event, helper);
                    }
                    else{
                        helper.createCaseItemsForApPolicy(component, event, helper);
                        if(component.get("v.isFacetsEnabled") == 'TRUE') {
                        //FACETS FLOW
                            helper.createFacetsCase(component, event, helper);
                        } else {
                            helper.navigateToCase(component, component.get("v.caseId"));
                        }
                    }

                }
            }
        }
        else{
            //ORS Flow
            helper.createOrsCase(component, event, helper);
        }
    },


    //US2423120 - Sravan
    //Separated the ors case creation logic
    createOrsCase: function(component, event, helper){
        console.log('ORS INVOKED');
        var caseWrapper = component.get("v.caseWrapper");
        var caseId = component.get("v.caseId");
        var strWrapper = '';
        if((!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper))){
            strWrapper =  JSON.stringify(caseWrapper);
        }
        // US2098648 - Sanka - ORS creation
        //Creating ORS in a different fucntion - DML and Web Service cannot be in a single transaction
        var actionORS = component.get("c.CreateORSRecord");
        actionORS.setParams({
            'strRecord': strWrapper,
            'caseId': caseId
        });
        actionORS.setCallback(this, function(responseORS) {
            var state = responseORS.getState();
            var responseList = responseORS.getReturnValue();
            // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
            if (state === "SUCCESS") {
                if(responseList.length > 0){
                    if(responseList[0].resultStatus != 200){
                        this.fireErrorToastMessage(responseList[0].resultStatusMessage);
                    }
                }
				helper.navigateToCase(component, caseId);
               }else{
                this.fireErrorToastMessage("Unexpected error occured. Please try again. If problem persists contact help desk.");
				helper.navigateToCase(component, caseId);
            }
        });
        $A.enqueueAction(actionORS);
        // End
    },

    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
    fireErrorToastMessage: function (message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Error in Save Case!",
			"message": message,
			"type": "error",
			"mode": "pesky",
			"duration": "10000"
		});
		toastEvent.fire();
	},

   //Create FACETS Case
  createFacetsCase : function(objComponent, objEvent, objHelper) {
       let action = objComponent.get("c.createFacetsRecord");
       action.setParams({
           strCaseWrapper : JSON.stringify(objComponent.get("v.caseWrapper")),
           strCaseId : objComponent.get("v.caseId")
       });
       action.setCallback(this, function(response) {
           let objResponse, strTitle,strMessage;
           let toastEvent = $A.get("e.force:showToast");
           if(response && response.getState() == 'SUCCESS') {
               objResponse = response.getReturnValue();
               strTitle = '';
               if(objResponse) {
                   objResponse = JSON.parse(objResponse);
                   if(objResponse.strResponse) {
                       strMessage = objResponse.strResponse;
                   } else {
                       strMessage = '';
                   }
                   if(objResponse.isSuccess == true ) {
                       strTitle = 'success';
                   } else {
                       strTitle = 'error'
                   }
               }
           } else {
               strTitle = 'error';
               strMessage = 'Facets Case Creation Failed'
           }
           toastEvent.setParams({
               "title": "Info !!",
               "message": strMessage,
               "type": strTitle
           });
           toastEvent.fire();
           objHelper.navigateToCase(objComponent, objComponent.get("v.caseId"));
       });
       $A.enqueueAction(action);
   },

   //Navigate to Facets Routing Screen
   navigateToFacetsRoutingScreen : function(objComponent, objEvent, objHelper) {
       var workspaceAPI = objComponent.find("workspace");
       workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
           workspaceAPI.openSubtab({
               parentTabId: enclosingTabId,
               pageReference: {
                       "type": "standard__component",
                       "attributes": {
                           "componentName": "c__ACET_ServiceRequestRouting" // c__<comp Name>
                       },
                       "state": {
                       "c__caseWrapper": objComponent.get("v.caseWrapper"),
                       "c__isFacetsCase": true, //US3075630
                       "c__ttsTopic": objComponent.get("v.Topic"), //US3075630
                       "c__providerDetailsForRoutingScreen": objComponent.get("v.providerDetailsForRoutingScreen"),
                       "c__finalPolicyMap":objComponent.get("v.finalPolicyMap"),//US3068299 - Sravan - 21/11/2020
                       "c__memberMap":objComponent.get("v.memberMap"),//US3068299 - Sravan - 21/11/2020
                       "c__flowDetails": objComponent.get("v.flowDetails"),//US3376212 - Sravan - 31/03/2021
                       "c__isProvider": objComponent.get("v.isProvider"),//US3376212 - Sravan - 31/03/2021
                       "c__isExchangePolicy": objComponent.get("v.isExchangePolicy"),//US3376212 - Sravan - 31/03/2021
                       "c__freeFormCommentsVal": objComponent.get("v.freeFormCommentsVal"),//US3376212 - Sravan - 31/03/2021
                       "c__policyState": objComponent.get("v.state"),//US3182829 - Sravan - 09/04/2021
                       "c__memberNotFoundDetails":objComponent.get("v.memberNotFoundDetails"),//US3376219 - Srava - 12/04/2021
                       "c__flowDetailsForRoutingScreen": objComponent.get("v.flowDetailsForRoutingScreen"),//US3376212 - Sravan - 31/03/2021
					   "c__AutodocKey": objComponent.get("v.autodocUniqueId"),
                       "c__mapClaimSummaryDetails": JSON.stringify(objComponent.get("v.mapClaimSummaryDetails"))//DE478270 - Sravan - 16/08/2021
                   }
               },
               focus: true
           }).then(function (response) {
               workspaceAPI.getTabInfo({
                   tabId: response
               }).then(function (tabInfo) {
                   let cmpEvent = objComponent.getEvent("closeModalBox");
                   cmpEvent.fire();
                   objComponent.set("v.isModalOpen", false);
                   var focusedTabId = tabInfo.tabId;
                   var tabLabel = "Service Request Routing";
                   workspaceAPI.setTabLabel({
                       tabId: focusedTabId,
                       label:tabLabel
                   });
                   workspaceAPI.setTabIcon({
                       tabId: focusedTabId,
                       icon: "utility:send",
                       iconAlt: "Service Request Detail"
                   });
               });
           }).catch(function (error) {
               console.log(error);
           });
       });
   },

   //US3068299 - Sravan - 21/11/2020
   getSelectedPolicies: function(component, event, helper){
       var autoDoc = [];
		var selectedPoliciesList = [];
       var caseWrapper = component.get("v.caseWrapper");
       if(!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper)){
               // Save Case Consolidation - External Id Issue
				var autodocUniqueId = component.get("v.autodocUniqueId");
				let idToTopic = new Map([
					['View Member Eligibility', autodocUniqueId],
					['View Authorizations', autodocUniqueId + 'Auth'],
					['Plan Benefits', autodocUniqueId + 'Financials'],
					['View PCP Referrals', autodocUniqueId + 'Referrals'],
					['Provider Lookup', autodocUniqueId + 'providerLookup'],
					['View Claims', autodocUniqueId + 'claim'],
                    ['Provider Details',autodocUniqueId+'providerDetails'],
                    ['Member Not Found',autodocUniqueId],
                ['Provider Not Found', autodocUniqueId],
                ['View Appeals', autodocUniqueId + 'appeals']

				]);
                if(component.get("v.omitRoute")){
                    autoDoc = _autodoc.getAutodoc(idToTopic.get(caseWrapper.AddInfoTopic));
                }

                if(component.get("v.onlyRoute")){
                    autoDoc = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
                }

                if(caseWrapper.AddInfoTopic == 'Provider Not Found'){
                    autoDoc = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
                }
                var providerDetailAutoDoc = _autodoc.getAutodoc(autodocUniqueId+'providerDetails');
                console.log('The Auto Doc Value'+ JSON.stringify(autoDoc));

			if(!$A.util.isUndefinedOrNull(autoDoc) && !$A.util.isEmpty(autoDoc)){
				var i = 0;
               var policyRowData = {};
                var policyResMap = {};
               var memberRowData = {};
				var policyRowMap = {};
				var memberRowMap = {};
               var topicData = {};
				var planBenefitsMap = {};
				var planBenefitsList = [];
				var providerDetailItemsMap = {};
                var memberNotFoundCaseItems = {};
                var mnfCaseItemsIndex = 0; // US3653469 - Krish - 9th Aug 2021
                var providerNotFound = {};
                var isProviderSnapProviderLookUp = false;
                var count = 0;
                var countProvider = 0;
                var skip = true;
               for(var key in autoDoc){
                    if(autoDoc[key].hasOwnProperty('componentName')){
                   //To capture policy information
                   if(autoDoc[key].componentName == 'Policies'){                       
						i= i+1;
                       if(!$A.util.isUndefinedOrNull(autoDoc[key].selectedRows) && !$A.util.isEmpty(autoDoc[key].selectedRows)){
                           for(var selectedKey in autoDoc[key].selectedRows){
                                    policyResMap[i] = autoDoc[key].selectedRows[selectedKey].resolved;
                               policyRowData[i] =  autoDoc[key].selectedRows[selectedKey].rowColumnData;
                           }
                       }
                   }
					//To capture member information
                   if(autoDoc[key].componentName == 'Member Details'){
                       memberRowData[i] = autoDoc[key].cardData;
                   }

					//To capture view authorization information or view referrals information or provider lookup information
                        /*if (autoDoc[key].componentName == 'Authorization Results' || autoDoc[key].componentName == 'Referral Results' || autoDoc[key].componentName == 'Provider Lookup Results') {
                        topicData[i] = autoDoc[key].selectedRows;
                        }*/

					//To capture view authorization information or view referrals information or provider lookup information or claim information
                    if (autoDoc[key].componentName == 'Authorization Results' || autoDoc[key].componentName == 'Referral Results' || autoDoc[key].componentName == 'Provider Lookup Results' || autoDoc[key].componentName == 'Claim Results' || autoDoc[key].componentName == 'Appeal Results') {
                        topicData[i] = autoDoc[key].selectedRows;    
                    }
                    //To capture provider lookup information for only provider
                    if(i == 0){
                        if(caseWrapper.AddInfoTopic != 'Provider Details'){
                        if(!$A.util.isUndefinedOrNull(providerDetailAutoDoc) && !$A.util.isEmpty(providerDetailAutoDoc) && skip){
                           for(var providerkey in providerDetailAutoDoc){
                                if(providerDetailAutoDoc[providerkey].hasOwnProperty('componentName')){
                                    if(providerDetailAutoDoc[providerkey].componentName.includes('Facility :') || providerDetailAutoDoc[providerkey].componentName.includes('Physician/Other :')){
                                        countProvider = countProvider+1;
                                        providerDetailItemsMap[countProvider] = providerDetailAutoDoc[providerkey].cardData[0].fieldValue;
                                    }
                                }
                                skip = false;
                                break;
                           }
                        }
                        if(autoDoc[key].hasOwnProperty('componentName')){

                            if(autoDoc[key].componentName.includes('Facility :') || autoDoc[key].componentName.includes('Physician/Other :')){
                                countProvider = countProvider+1;
							    providerDetailItemsMap[countProvider] = autoDoc[key].cardData[0].fieldValue;
                            }
                            if(autoDoc[key].componentName == 'Provider Lookup Results'){
                               isProviderSnapProviderLookUp = true;
                                component.set("v.isProviderSnapProviderLookUp",isProviderSnapProviderLookUp);
                                topicData[i] = autoDoc[key].selectedRows;
                            }
                        }
                        if(!$A.util.isUndefinedOrNull(providerDetailItemsMap) && !$A.util.isEmpty(providerDetailItemsMap)){
                            component.set("v.providerDetailItems",providerDetailItemsMap);
                        }
                        }
                    }
                    //To capture member not found information

                    if(caseWrapper.AddInfoTopic == 'Member Not Found'){
                        if(autoDoc[key].componentName.includes('Plan Type:')){
                                memberNotFoundCaseItems[mnfCaseItemsIndex] = autoDoc[key].uniqueId;  // US3653469 -adding case items for all plan type -  Krish - 9th Aug 2021
                                mnfCaseItemsIndex++; // US3653469 - Krish - 9th Aug 2021
                        }
                        component.set("v.memberNotFoundCaseItems",memberNotFoundCaseItems);
                    }

                        //To capture provider lookup information for only provider
                        if(i == 0){
                        if(caseWrapper.AddInfoTopic != 'Provider Details'){
                        if(!$A.util.isUndefinedOrNull(providerDetailAutoDoc) && !$A.util.isEmpty(providerDetailAutoDoc) && skip){
                           for(var providerkey in providerDetailAutoDoc){
                                if(providerDetailAutoDoc[providerkey].hasOwnProperty('componentName')){
                                    if(providerDetailAutoDoc[providerkey].componentName.includes('Facility :') || providerDetailAutoDoc[providerkey].componentName.includes('Physician/Other :')){
                                        countProvider = countProvider+1;
                                        providerDetailItemsMap[countProvider] = providerDetailAutoDoc[providerkey].cardData[0].fieldValue;
                                    }
                                }
                                skip = false;
                                break;
                           }
                        }
                        if(autoDoc[key].hasOwnProperty('componentName')){

                            if(autoDoc[key].componentName.includes('Facility :') || autoDoc[key].componentName.includes('Physician/Other :')){
                                countProvider = countProvider+1;
							    providerDetailItemsMap[countProvider] = autoDoc[key].cardData[0].fieldValue;
                            }
                            if(autoDoc[key].componentName == 'Provider Lookup Results'){
                               	isProviderSnapProviderLookUp = true;
                                component.set("v.isProviderSnapProviderLookUp",isProviderSnapProviderLookUp);
                                topicData[i] = autoDoc[key].selectedRows;
                            }
                        }
                        if(!$A.util.isUndefinedOrNull(providerDetailItemsMap) && !$A.util.isEmpty(providerDetailItemsMap)){
                            component.set("v.providerDetailItems",providerDetailItemsMap);
                        }
                    }
                    }
                    //To capture member not found information

                    if(caseWrapper.AddInfoTopic == 'Member Not Found'){
                        if(autoDoc[key].componentName.includes('Plan Type:')){
                            // memberNotFoundCaseItems[i] = autoDoc[key].uniqueId; // Repeated block 
                        }
                        component.set("v.memberNotFoundCaseItems",memberNotFoundCaseItems);
                        }

                    }

					//To capture plan benefits infromation
                    if(caseWrapper.AddInfoTopic == 'Plan Benefits'){
                        console.log('Plan Benefits AutoDoc'+ JSON.stringify(autoDoc[key]));
						if(autoDoc[key].hasOwnProperty('autodocHeaderName')){
							if(autoDoc[key].autodocHeaderName.includes('Benefit Accumulations:')){
								planBenefitsList.push(autoDoc[key].caseItemExtId);
							}
                        if(autoDoc[key].autodocHeaderName == 'Financials'){
	                            planBenefitsList.push('Financials');
                        }
                        if(autoDoc[key].autodocHeaderName == 'Benefit Details' && !$A.util.isUndefinedOrNull(autoDoc[key].cardData) && !$A.util.isEmpty(autoDoc[key].cardData)){
								planBenefitsList.push('Benefit Details');
                        }
						}
						else{
							if(autoDoc[key].hasOwnProperty('caseItemExtId')){
								if(autoDoc[key].caseItemExtId.includes(' - Benefit Details') && !$A.util.isUndefinedOrNull(autoDoc[key].cardData) && !$A.util.isEmpty(autoDoc[key].cardData)){
									planBenefitsList.push(autoDoc[key].caseItemExtId);
									}
								}
							}
                        if(autoDoc[key].hasOwnProperty('componentName')){
                            if(autoDoc[key].componentName == 'Date of Service and Place of Service' ){
                                planBenefitsList.push('PA Check');
                            }
                        }

						planBenefitsMap[i] = planBenefitsList;
						}

					//To capture provider details information
					if(caseWrapper.AddInfoTopic == 'Provider Details'){
                        if(autoDoc[key].hasOwnProperty('componentName')){
						if(autoDoc[key].componentName.includes('Facility :') || autoDoc[key].componentName.includes('Physician/Other :')){
							providerDetailItemsMap[i] = autoDoc[key].cardData[0].fieldValue;
                    }
						if(autoDoc[key].componentName == 'C&S Contract Summary' ){
                            count = count+ 1;
                            topicData[count] = autoDoc[key].selectedRows;
                        }
                        if(autoDoc[key].componentName == 'E&I Contract Summary'){
                            count = count+ 1;
                            topicData[count] = autoDoc[key].selectedRows;
                        }
                        if(autoDoc[key].componentName == 'M&R Contract Summary'){
                            count = count+ 1;
                            topicData[count] = autoDoc[key].selectedRows;
                        }
                        if(autoDoc[key].componentName == 'PHS Contract Summary'){
                            count = count+ 1;
                            topicData[count] = autoDoc[key].selectedRows;
                            }
						if(!$A.util.isUndefinedOrNull(providerDetailItemsMap) && !$A.util.isEmpty(providerDetailItemsMap)){
                            component.set("v.providerDetailItems",providerDetailItemsMap);
                        }
                   }
					}


                    //To capture provider not found information
                    if(caseWrapper.AddInfoTopic == 'Provider Not Found'){
                        if(autoDoc[key].hasOwnProperty('componentName')){
                            if(autoDoc[key].componentName.includes('Provider :')){
                                providerNotFound[i] = autoDoc[key].cardData;
                            }
				}
                    }


                }



				//To frame related case item map
               if(!$A.util.isUndefinedOrNull(topicData) && !$A.util.isEmpty(topicData)){
                    component.set("v.topicData",topicData); 
                }
               if(caseWrapper.AddInfoTopic != 'Plan Benefits' && caseWrapper.AddInfoTopic != 'View Member Eligibility' &&  caseWrapper.AddInfoTopic !=  'Member Not Found'){
                    this.getRelatedCaseItems(component, event, helper);
               }

               //To frame provider not case items
               var providerNotFoundMap = {};
               if(!$A.util.isUndefinedOrNull(providerNotFound) && !$A.util.isEmpty(providerNotFound)){
                   for(var keyVal in providerNotFound){
                       var cardRow= providerNotFound[keyVal];
                       for(var cardKey in cardRow){
                           if(cardRow[cardKey].fieldName == 'Tax ID (TIN)'){
                                providerNotFoundMap[keyVal] = cardRow[cardKey].fieldValue;
                           }
                       }
                   }
                   component.set("v.providerNotFoundMap",providerNotFoundMap);

               }

				//To frame policy row map
               if(!$A.util.isUndefinedOrNull(policyRowData) && !$A.util.isEmpty(policyRowData)){
                   for(var rowKey in policyRowData){
                       if(!$A.util.isUndefinedOrNull(policyRowData[rowKey]) && !$A.util.isEmpty(policyRowData[rowKey])){
                           var rowValues =  policyRowData[rowKey];
                           var policyDetails = {};
                           for(var individualRowKey in rowValues){
                               console.log('Individual Policy Value'+ rowValues[individualRowKey].fieldLabel);
                               if(rowValues[individualRowKey].fieldLabel == 'Group #'){
                                   policyDetails.selectedGroup = rowValues[individualRowKey].fieldValue;
                               }
                               if(rowValues[individualRowKey].fieldLabel == 'SOURCE'){
                                   policyDetails.selectedSourceCode = rowValues[individualRowKey].fieldValue;
                               }
                               if(rowValues[individualRowKey].fieldLabel == 'PLAN'){
                                   policyDetails.selectedPlan = rowValues[individualRowKey].fieldValue;
                               }
                               if(!$A.util.isUndefinedOrNull(policyResMap[rowKey])){
                               		policyDetails.isResolved = policyResMap[rowKey];
                               }
                               else{
                                  policyDetails.isResolved = true;
							   }
                               policyDetails.memberId = '';
							   policyDetails.relatedCaseItemsMap = {};
                               policyRowMap[rowKey] = policyDetails;
                           }
                       }
                   }
               }
               console.log('Policy Row Map'+ JSON.stringify(policyRowMap));

				//To frame member row map
               if(!$A.util.isUndefinedOrNull(memberRowData) && !$A.util.isEmpty(memberRowData)){
                   for(var memberRowKey in memberRowData){

                       if(!$A.util.isUndefinedOrNull(memberRowData[memberRowKey]) && !$A.util.isEmpty(memberRowData[memberRowKey])){
                           var memberRowValues = memberRowData[memberRowKey];
                           for(var individualMember in memberRowValues){
                               if(memberRowValues[individualMember].fieldName == 'Member ID'){
                                   memberRowMap[memberRowKey] = memberRowValues[individualMember].fieldValue;
                               }
                               }
                               }
                               }
                               }



               console.log('Member Row Map'+ JSON.stringify(memberRowMap));

				//To frame final policy row map
               if(!$A.util.isUndefinedOrNull(policyRowMap) && !$A.util.isEmpty(policyRowMap)){
					var reCaseItemMap = component.get("v.relatedCaseItemMap");
                   for(var finalRowKey in policyRowMap){
						var relatedCaseItemMap = {};
                           if(!$A.util.isUndefinedOrNull(policyRowMap[finalRowKey].selectedPlan) && !$A.util.isEmpty(policyRowMap[finalRowKey].selectedPlan)){
							//Cases should not be created for non-medical policies
                               if(!policyRowMap[finalRowKey].selectedPlan.includes('Non Medical')){
								if(!$A.util.isUndefinedOrNull(memberRowMap) && !$A.util.isEmpty(memberRowMap)){
                                   var finalMemberRowKey = parseInt(finalRowKey);
                                   var finalResultsRowKey = parseInt(finalMemberRowKey);
                                   policyRowMap[finalRowKey].memberId = memberRowMap[finalMemberRowKey];
									//View Member Eligibility Topic
									if(caseWrapper.AddInfoTopic == 'View Member Eligibility'){
										var caseItem = {};
										var caseItemMap = {};
										var finalSourceCode = '';
										var fetchSourceCode = [];
										fetchSourceCode = policyRowMap[finalRowKey].selectedSourceCode.split('-');
										finalSourceCode = fetchSourceCode[0].trim();
										caseItem.uniqueKey = policyRowMap[finalRowKey].selectedGroup+'/'+finalSourceCode+'/'+policyRowMap[finalRowKey].memberId;
										console.log('The Resolved CheckBox'+ policyRowMap[finalRowKey].isResolved);
                                        caseItem.isResolved = policyRowMap[finalRowKey].isResolved;
										caseItem.topic = caseWrapper.AddInfoTopic;
										caseItemMap[finalRowKey] = caseItem;
										policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
                                            }
									//View Authorizations Topic
									if(caseWrapper.AddInfoTopic == 'View Authorizations'){
										if(!$A.util.isUndefinedOrNull(reCaseItemMap[finalResultsRowKey]) && !$A.util.isEmpty(reCaseItemMap[finalResultsRowKey])){
											policyRowMap[finalRowKey].relatedCaseItemsMap = reCaseItemMap[finalResultsRowKey];
											var relatedCaseItemsMapSize = reCaseItemMap[finalResultsRowKey].size;
                                            }
                                            else{
											if(!caseWrapper.hasOwnProperty('caseItems')){
												var caseItem = {};
												var caseItemMap = {};
												caseItem.uniqueKey = 'Authorizations';
												caseItem.isResolved =  true;
												caseItem.topic = caseWrapper.AddInfoTopic;
												caseItemMap[finalRowKey] = caseItem;
												policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
											}
									    }
									}
									//View PCP Referrals Topic
									if(caseWrapper.AddInfoTopic == 'View PCP Referrals'){
										if(!$A.util.isUndefinedOrNull(reCaseItemMap[finalResultsRowKey]) && !$A.util.isEmpty(reCaseItemMap[finalResultsRowKey])){
											policyRowMap[finalRowKey].relatedCaseItemsMap = reCaseItemMap[finalResultsRowKey];
										}
										else{
											if(!caseWrapper.hasOwnProperty('caseItems')){
												var caseItem = {};
												var caseItemMap = {};
												caseItem.uniqueKey = 'Referrals';
												caseItem.isResolved =  true;
												caseItem.topic = caseWrapper.AddInfoTopic;
												caseItemMap[finalRowKey] = caseItem;
												policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
											}
									    }
									}
									//Provider Lookup Topic
									if(caseWrapper.AddInfoTopic == 'Provider Lookup'){
										if(!$A.util.isUndefinedOrNull(reCaseItemMap[finalResultsRowKey]) && !$A.util.isEmpty(reCaseItemMap[finalResultsRowKey])){
											policyRowMap[finalRowKey].relatedCaseItemsMap = reCaseItemMap[finalResultsRowKey];
										}
										else{
												if(!caseWrapper.hasOwnProperty('caseItems')){
												var caseItem = {};
												var caseItemMap = {};
												caseItem.uniqueKey = 'Provider Not Found';
												caseItem.isResolved =  true;
												caseItem.topic = caseWrapper.AddInfoTopic;
												caseItemMap[finalRowKey] = caseItem;
												policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
											}
											else if($A.util.isUndefinedOrNull(caseWrapper.caseItems) || $A.util.isEmpty(caseWrapper.caseItems)){
												var caseItem = {};
												var caseItemMap = {};
												caseItem.uniqueKey = 'Provider Not Found';
												caseItem.isResolved =  true;
												caseItem.topic = caseWrapper.AddInfoTopic;
												caseItemMap[finalRowKey] = caseItem;
												policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
											}

										}
									}

									//Plan Benefits Topic
									if(caseWrapper.AddInfoTopic == 'Plan Benefits'){
										if(!$A.util.isUndefinedOrNull(planBenefitsMap) && !$A.util.isEmpty(planBenefitsMap)){
											if(!$A.util.isUndefinedOrNull(planBenefitsMap[finalRowKey]) && !$A.util.isEmpty(planBenefitsMap[finalRowKey])){
												var planBenefitItems = planBenefitsMap[finalRowKey];
												var caseItemMap = {};
												for(var key in planBenefitItems){
													var caseItem = {};
													caseItem.uniqueKey = planBenefitItems[key];
		                                            caseItem.isResolved =  true;
					                                caseItem.topic = caseWrapper.AddInfoTopic;
					                                caseItemMap[key] = caseItem;
												}
												policyRowMap[finalRowKey].relatedCaseItemsMap = caseItemMap;
											}
												}
													}

									//View Claims Topic
									if(caseWrapper.AddInfoTopic == 'View Claims'){
										if(!$A.util.isUndefinedOrNull(reCaseItemMap) && !$A.util.isEmpty(reCaseItemMap)){
											if(!$A.util.isUndefinedOrNull(reCaseItemMap[finalResultsRowKey]) && !$A.util.isEmpty(reCaseItemMap[finalResultsRowKey])){
												policyRowMap[finalRowKey].relatedCaseItemsMap = reCaseItemMap[finalResultsRowKey];
												}
											}
									    }
                                    
                                    //View Appeals Topic
                                    if (caseWrapper.AddInfoTopic == 'View Appeals') {
                                        if (!$A.util.isUndefinedOrNull(reCaseItemMap) && !$A.util.isEmpty(reCaseItemMap)) {
                                            if (!$A.util.isUndefinedOrNull(reCaseItemMap[finalResultsRowKey]) && !$A.util.isEmpty(reCaseItemMap[finalResultsRowKey])) {
                                                policyRowMap[finalRowKey].relatedCaseItemsMap = reCaseItemMap[finalResultsRowKey];
                                            }
                                        }
                                    }
									}
                                   selectedPoliciesList.push(policyRowMap[finalRowKey]);

                           }
                       }
                   }
               }

				console.log('Final Policies'+ JSON.stringify(selectedPoliciesList));
				if(!$A.util.isUndefinedOrNull(selectedPoliciesList) && !$A.util.isEmpty(selectedPoliciesList)){
       component.set("v.selectedPolicies",selectedPoliciesList);
       helper.filterPolicies(component, event, helper);
				}
			}
		}

   },

   //US3149404 - Sravan - Start
  //US3138410 - Sravan
  getRelatedCaseItems : function(component, event, helper){
    var topicData = component.get("v.topicData");
	var caseWrapper = component.get("v.caseWrapper");
    console.log('Topic Data'+ JSON.stringify(topicData));
    if(!$A.util.isUndefinedOrNull(topicData) && !$A.util.isEmpty(topicData)){
        var relatedCaseItemsMap = {};
        for(var key in topicData){
            var topicResult =  topicData[key];
			var caseItemMap = {};
            if(!$A.util.isUndefinedOrNull(topicResult) && !$A.util.isEmpty(topicResult)){
                for(var resultKey in topicResult){
                    var caseItem = {};
					caseItem.uniqueKey = topicResult[resultKey].caseItemsExtId;
					if(caseWrapper.AddInfoTopic == 'View Authorizations' || caseWrapper.AddInfoTopic == 'View PCP Referrals'){
						caseItem.isResolved =  true;
                   }
                   else{
						caseItem.isResolved =  Boolean(topicResult[resultKey].resolved);
                   }
					caseItem.topic = caseWrapper.AddInfoTopic;
					caseItemMap[resultKey] = caseItem;
                }
				relatedCaseItemsMap[key] = caseItemMap;
            }
        }
        console.log('Related CaseItem Map'+ JSON.stringify(relatedCaseItemsMap));
        component.set("v.relatedCaseItemMap",relatedCaseItemsMap);
    }
  },
  //US3149404 - Sravan - End

    // US2815284 - Sanka
    callRefreshEvent: function (cmp) {
        var caseWrapper = cmp.get("v.caseWrapper");
        var appEvent = $A.get("e.c:ACET_CaseHistoryRefreshEvt");
        appEvent.setParams({
            "uniqueId": caseWrapper.refreshUnique
        });
        appEvent.fire();
    // US3507751 - Save Case Consolidation
    if (cmp.get("v.omitRoute")) {
           var openedTopicUniqueIds = cmp.get("v.openedTopicUniqueIds");
           openedTopicUniqueIds.forEach(uniqueId => {
               var refreshEvent = $A.get("e.c:ACET_AutoDocRefreshEvent");
               refreshEvent.setParams({
                   autodocUniqueId: uniqueId
               });
               refreshEvent.fire();
               _autodoc.clearAutoDoc(uniqueId); // DE456923 - Thanish - 30th Jun 2021
           });
        } else if (cmp.get("v.onlyRoute")) {
            var refreshEvent = $A.get("e.c:ACET_AutoDocRefreshEvent");
            refreshEvent.setParams({
                    autodocUniqueId: cmp.get("v.autodocUniqueId")
            });
            refreshEvent.fire();
            _autodoc.clearAutoDoc(cmp.get("v.autodocUniqueId")); // DE456923 - Thanish - 30th Jun 2021
        }
    },

    //US3182779 - Sravan - Start
    filterExchangePolicies : function(component, event, helper){
        var finalPolicyMap = component.get("v.finalPolicyMap");
        for(var key in finalPolicyMap){
            if(finalPolicyMap[key].selectedGroup.includes('ONEX') || finalPolicyMap[key].selectedGroup.includes('OFEX')){
                component.set("v.isExchangePolicy",true);
            }
        }
    },
    //US3182779 - Sravan - End

    //US3644559 - Sravan - Start
    createCaseItemsForApPolicy: function(component,event,helper){
      var insertCaseItems = component.get("c.insertCaseItems");
      insertCaseItems.setParams({
           caseId : component.get("v.caseId"),
           caseWrapper : JSON.stringify(component.get("v.caseWrapper"))
       });
      insertCaseItems.setCallback(this, function(response){
          var state = response.getState();
          if(state == 'SUCCESS'){

          }
          else{
              console.log('Error in case items creation for ap policies');
          }
      });
      $A.enqueueAction(insertCaseItems);
     }
    //US3644559 - Sravan - End
});