({
    init: function (cmp, event, helper) {
        
        console.log('=======GETTING REMOVED HERE=======');
        cmp.set("v.Spinner", true);
        localStorage.removeItem("rowCheckHold");
        var uInf = window.localStorage.getItem('uProfile');
        console.log('uInfssd :: '+uInf);
        if (uInf == 'hideSave'){
            cmp.set("v.showSave", "false");
            cmp.set("v.showMisdirect", "false");
            
        }   
        setTimeout(function(){ 
            var HighlightPanelInfo =  cmp.get("v.highlightPanel");

  cmp.set("v.highlightPanelstring",JSON.stringify(HighlightPanelInfo));
}, 5);
          
        var topicslst = [];
        var topicstr = cmp.get('v.cseTopic');
        cmp.set("v.cseTopicHolder", topicstr);
        topicslst.push(topicstr);
        console.log('TTS topic list'+topicstr);
        cmp.set('v.topicOptions', topicslst);
        var calltopicstr = cmp.get("v.cseTopic"); 
        console.log('==========TOPIC=1======>>'+ cmp.find("csetopic"));
        console.log('==========TOPIC=======>>'+ calltopicstr);
        if(topicstr=='Member Overview'){
            var action = cmp.get("c.isSNIUser");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var isSNIUser = response.getReturnValue();
                    console.log('>>isSNIUser::: '+isSNIUser);
                    cmp.set("v.showSENSButton", isSNIUser);
                }
            });
            $A.enqueueAction(action);
        }
        var action = cmp.get("c.getTTSFilterMapKeyStr");
        
        
        action.setParams({
            "callTopic": calltopicstr
        });
        var lstDefault = ['None'];
        
        cmp.set('v.typeOptions', lstDefault );
        cmp.set('v.subtypeOptions', lstDefault );
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    //alert('Inside TTS'+JSON.stringify(result));
                    var lst = ['None'];
                    for(var i=0; i < result.length; i++)
                        lst.push(result[i]);
                    cmp.set('v.typeOptions', lst );
                    cmp.set("v.Spinner", false);
                }
            }
        });
        $A.enqueueAction(action);
        
        //US1935707
        //cmp.set("v.showSave", "false");
        var action = cmp.get("c.getProfileUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                 if(storeResponse.Profile != undefined && storeResponse.Profile.Name =='ECM Back Office Agent'){
                    cmp.set("v.showrelatedcases",false);
                }else{
                                        cmp.set("v.showrelatedcases",true);

                }
                console.log('storeResponse::: '+storeResponse);
                cmp.set("v.userInfo", storeResponse);
                helper.checkProfileType(cmp, event, helper);
                if(cmp.get("v.showPCPButton")){
                	helper.checkPCPButtonAccess(cmp, event, helper);
                }
            }
        });
        $A.enqueueAction(action);
        
	    var action = cmp.get("c.getTaskRecordType");
		var dName=cmp.get("v.developerName");
        action.setParams({
            "devName": dName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                console.log('>>storeResponse::: '+storeResponse);
                cmp.set("v.taskRecordTypeId", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        


    },
    loadType: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        var topicstr = params.topicstr;
        var topicslst = [];
        console.log('------IN 333-------');
        topicslst.push(topicstr);
        console.log('TTS topic list'+topicstr);
        cmp.set('v.topicOptions', topicslst);
        var calltopicstr = params.topicstr; 
        
        var action = cmp.get("c.getTTSFilterMapKeyStr");
        
        
        action.setParams({
            "callTopic": calltopicstr
        });
        var lstDefault = ['None'];
        
        cmp.set('v.typeOptions', lstDefault );
        cmp.set('v.subtypeOptions', lstDefault );
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    //alert('Inside TTS'+JSON.stringify(result));
                    var lst = ['None'];
                    for(var i=0; i < result.length; i++)
                        lst.push(result[i]);
                    cmp.set('v.typeOptions', lst );
                    cmp.set("v.Spinner", false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    onTopicChange : function(component, event, helper) {
        //alert('---TESTING----');
        component.find("csetype").set("v.disabled", false); 
        var calltopicstr = component.get("v.cseTopic");        
        var action = component.get("c.getTTSFilterStr");
        action.setParams({
            "callTopic": calltopicstr
        });
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            //alert('Inside TTS'+JSON.stringify(result));
            
        });
        $A.enqueueAction(action);
    },
    onTypeChange : function(component, event, helper) {
        component.set("v.Spinner", true);
        component.find("csesubtype").set("v.disabled", false);
        //component.set('v.topicOptions', topicslst);
        var calltopicstr = component.get("v.cseTopic");  
        var calltypestr = component.get("v.cseType");
        
        //	US2434175: Follow up required validation by Madhura
        if(calltypestr == 'Issue Resolved'){
        	component.set("v.flwupDisabled", true);
            component.set("v.flwupRequired", false);
        }
        else
            component.set("v.flwupDisabled", false);
        var subtypecmp = component.find("csesubtype");
        $A.util.removeClass(subtypecmp, "slds-has-error");  
        component.find("subTypeError").set("v.errors", null);
                
        helper.checkValidTypes(component, event, helper, calltypestr);
        
        
        var action = component.get("c.getTTSFilterMapValueStr");
        action.setParams({
            "callTopic": calltopicstr,
            "keystr": calltypestr
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    //alert('Inside TTS'+JSON.stringify(result));
                    var lst = ['None'];
                    for(var i=0; i < result.length; i++){
                        console.log('result[i] ::: '+result[i] );
                        if (result[i] != "None" && result[i]!="*")
                        	lst.push(result[i]);
                    }    
                    component.set('v.subtypeOptions', lst );
                    component.set("v.Spinner", false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    openModal: function(component, event, helper) {
                component.set("v.Spinner",true);

        //var x = document.getElementsByClassName("onePanelManagerScoped")[0];
        //var pagenum = component.get("v.pageNum");
        //if(pagenum != undefined)
        //window.lgtAutodoc.storePaginationData(pagenum);
        //var y = document.getElementById("modalSection1");
        //console.log(y);
        //console.log(y.classList);

        //component.set("v.isOnshoreError",true);
        //var val = component.get("v.isOnshoreError");
        //console.log("onshore ++ "+val);
        var isMemberDetailPage =component.get("v.isOriginatorModal");
        var hlgtInfo = component.get("v.highlightPanel");
        var onshoreValue;
        var onshoreType = component.get("v.onshoreRestrictionDisp");
        
        if(onshoreType ){
        if(hlgtInfo != undefined && hlgtInfo != null && Object.values(hlgtInfo).join('')!=''){
        console.log('+++onshore++'+hlgtInfo.onshoreValue);
         onshoreValue = hlgtInfo.onshoreValue;
        //console.log("onshore ++ "+onshoreType);
        }
        else{
            onshoreValue = 'No'; // TBD Remove after implementing Highlightspanel on topics.
        }
        }

        //if((onshoreType  == '') || (onshoreType == undefined)){
        console.log(' :: '+component.get("v.isOriginatorModal"));
     //Dimpy US2904956: Capture Case Details 
        if(component.get("v.noAutoDoc")){
          
                var orginatorId = component.get("v.originator");
                var numbers = /^[-+]?[0-9]+$/;
                //debugger;                
            if(component.get("v.originator") && orginatorId != "undefined" && component.get('v.motionValidCnd')){
                    console.log(' originator 1:: ');
                    component.set("v.isModalOpen", true);

                }else{
                    console.log(' originator 2:: ');
                   var showOriginatorError = component.getEvent("showOriginatorError");
                     console.log(' showOriginatorError 2:: ' + showOriginatorError);
										   
                    if(component.get('v.motionValidCnd')){
                        showOriginatorError.fire();	
                    }
					
                    //US3120970 Start
                    if(component.get("v.developerName")=='Motion' && component.get('v.motionValidCnd') == false){
                        component.set("v.isModalOpen", false);
                        
                        var showValidationErrorEvt = $A.get("e.force:showToast");
                        showValidationErrorEvt.setParams({                
                            message : 'At least one action in DERM Inquiry or CONSOLE Inquiry must be selected OR Comments must be provided',
                            duration: '10000',                
                            type: 'error',
                            mode: 'dismissible'
                        });
                        showValidationErrorEvt.fire();
                      //US3120970 End 
                        
                    }
									
								   
                }  
        }
           
      else  if(onshoreValue != 'Yes' && onshoreValue != 'No' && isMemberDetailPage){
            component.set("v.OnshoreRestTrigger",true);
            console.log("onshore ++ "+component.get("v.OnshoreRestTrigger"));
        }else{
            if(component.get("v.isMemberOtherInquiryModal")){
                helper.validateMemberOtherInquiry(component, event, helper);
            }else if(component.get("v.isPharmacyModal")){
                helper.validatePharmacy(component, event, helper);
            }else if(component.get("v.isConsumerDashboardModal")){
                helper.validateConsumerDashboard(component, event, helper);
            }else if(component.get("v.isConsumerAccountsModal")){
                helper.validateConsumerAccounts(component, event, helper);    
            }else if(component.get("v.isOriginatorModal")){


                var orginatorId = component.get("v.OriginatorId");
                var numbers = /^[-+]?[0-9]+$/;
                
                if(component.get("v.originatorSelected") && orginatorId != undefined &&
                   ((orginatorId.match(numbers) && orginatorId.length>9) || !orginatorId.match(numbers))){
                    console.log(' originator 1:: ');
                    component.set("v.isModalOpen", true);

                }else{
                    console.log(' originator 2:: ');
                    var showOriginatorError = component.getEvent("showOriginatorError");
                    
                    showOriginatorError.fire();
                }
            }else{  
                component.set("v.isModalOpen", true);
            }
            var modal = component.find("modalSection1");

            $A.util.addClass(modal, "onePanelManagerScoped");

            //component.set("v.originatorSelected", false);

            
           // console.log('-----==---->'+component.find("autodocSec").getElement());
        }
        
        // Dimpy US2904956: Capture Case Details 
        
                        if(component.get("v.noAutoDoc"))
                             helper.getdoccontent(component, event, helper);
                             else {
                             helper.getautodoccontent(component, event, helper);
                             }
    },
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        
        component.set("v.isModalOpen", false);
        component.set("v.cseType","None");
        component.set("v.cseSubtype","None");
        //Reset the FollowUp Required Values : Added By Nadeem
        component.set("v.flwupDisabled", false);
	component.set("v.flwupRequired", false);
	component.set("v.migIssueRequired", false);
    //US2357303 Begin
    component.set("v.escalatedRequired", false);
    component.set("v.complaintRequired", false);
    //US2357303 End
    },
    openAlertsModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        
//		helper.getAllMemberAlerts(component, event, helper);
        component.set("v.isMemberAlertModalOpen", true);
    },
    loadAllAlerts: function(component, event, helper) {
        // Set isModalOpen attribute to true
        
        //component.set("v.isMemberAlertModalOpen", true);
		helper.getAllAlerts(component, event, helper);
    },
    closeAlertsModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isMemberAlertModalOpen", false);
    },
    
    // This is used when misdirect is clicked to navigate to Misdirect page
    misdirect : function(component,event, helper) {
        console.log('~~~Misdirect');
        
        //Close opend Tabs
        //helper.closeViewAuthTabs(component, event, helper);
        
        //var intType = component.get("v.InteractionType");
        console.log(component.get("v.cseTopic"));
        console.log(component.get("v.int"));
        console.log(component.get("v.int.Interaction_Type__c"));
        console.log(component.get("v.intId"));
        console.log(component.get("v.srk"));
        console.log(component.get("v.sourceOrig"));
        console.log(component.get("v.isRestrict"));
        var intType,intId,srk,isRestrict,cseTopic,cseType,cseSubtype;
        var hlgtInfo = component.get("v.highlightPanel");
        console.log('=====misdirect highlight'+hlgtInfo);
        cseTopic = component.get("v.cseTopic");
        
        cseTopic = (cseTopic == 'None')?'':cseTopic;
        
        intId = component.get("v.intId");
        srk = component.get("v.srk");
        isRestrict = (component.get("v.isRestrict"))?true:false;
        
        if(intId != undefined){
            intType =  component.get("v.int.Interaction_Type__c");
        }
        else{
            intType = component.get("v.sourceOrig");
        }
        console.log('Passing'+isRestrict+intType+intId+srk+cseTopic+cseType+cseSubtype);
        var pageReference=  {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__ACETLGT_MisdirectedCall"
            },
            "state": {
                "c__cseTopic":cseTopic,
                "c__intType" : intType,
                "c__intId" : intId,
                "c__srk" : srk,
                "c__isRestrict" : isRestrict,
                "c__highlightsPanelInfo": JSON.stringify(hlgtInfo)
            }
        };
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            console.log('~~~tabId'+tabId);
            // For Misdirect on Search Pages to open as primary tab
            if(!tabId){
                workspaceAPI.openTab({
                    pageReference: pageReference,
                    focus: true
                }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Cancel'
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "utility:end_call",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
                 var appEvent = component.getEvent("misdirectEvent");
                   //appEvent.setParams({});
                   appEvent.fire();
       
                
            }
            // For Misdirect on any page other than Search Tab to open as subtab
            else{
                console.log('~~~tabId non Search'+tabId+cseTopic);
                var topicTabId;
                
                // To get tab Id to close the topic tab
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    topicTabId = response.tabId;
                    console.log(topicTabId);
                   
                });
                
                // Open Misdirect page in a subtab
                workspaceAPI.openSubtab({
                    parentTabId: tabId,
                    pageReference: pageReference,
                    focus: true
                }).then(function(response) {
                    console.log('opensubtab tabID ~~~'+response);
                    
                    workspaceAPI.focusTab({tabId : response});
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Cancel"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: response,
                        icon: "utility:end_call",
                        iconAlt: "Misdirect"
                    });    
                    
                    //Close the Topic tab after opening Misdirect from Topic 
                    if(!cseTopic.includes('Overview'))
                        workspaceAPI.closeTab({
                            tabId: topicTabId
                        });
                });
            }
        });
        
    },
    
    submitDetails: function(component, event, helper) {
		//alert(component.get("v.pageNum"));
		console.log('==========TOPIC=1======>>'+ component.find("csetopic").get("v.value"));
		event.getSource().set("v.label", "Submitting...");
        event.getSource().set("v.disabled", true);
        
        
        if(component.get("v.noAutoDoc")){           
        	helper.submitCase(component, event, helper);           
        } else {
           setTimeout(function(){
                helper.submitCase(component, event, helper);
            }, 1); 
        }
        //event.getSource().set("v.onclick", "");    
        
    },
    
    // originator changed event handling
    handleOriginatorChanged: function(component, event, helper) {
        component.set("v.originatorSelected", false);
        var originatorId = component.get("v.OriginatorId"); //DE310475 - Abhinav
        //alert("====>>>>"+ originatorId);
        if(originatorId != null && originatorId != 'null' && originatorId != undefined && originatorId != 'Third Party'){
        	component.set("v.originatorSelected", true);
        }
    },
    
    createPCPReferral: function(component, event, helper){
    	var baseLink = component.get("v.createPCPLink");
//        console.log('baseLink'+baseLink);
        window.open(baseLink,'_blank', 'location=yes,menubar=yes,titlebar=yes,toolbar=yes,width=1200, height=800 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');    
    },
    handleRelatedCases_Support_event: function(component, event, helper){
        var parentcaseid = event.getParam("parentcaseid");
        component.set("v.parentcaseid",parentcaseid);
    },
    updateBookOfBusinessTypeCode:function(cmp,event,helper){
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            var tabIdParam = event.getParam('tabId');
            if(tabId == tabIdParam){
                cmp.set('v.bookOfBusinessTypeCode',event.getParam('bookOfBusinessTypeCode'));
            }
        })
        .catch(function(error) {
            console.log(error);
        });        
    },
    openSENSApplication :  function(cmp,event,helper){
        var SENSevent = cmp.getEvent("SENSevent");
        SENSevent.setParams({
            });
        SENSevent.fire();
    },
    openConsolePage : function(component, event, helper){       
		var action = component.get("c.getConsoleURL");
       		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var homePageNewslabel = response.getReturnValue();
               
                window.open(homePageNewslabel);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action); 
       
    },
    openDermPage : function(component, event, helper){ 
        var showErrorMsg= false;
		var ErrorMsg= '';
		
        var membernotfound=component.get("v.isMembernotfound");
        
        if(membernotfound){
            showErrorMsg = true;
            ErrorMsg=$A.get("$Label.c.Motion_Individual_Error_Message");
        }
        else if(component.get("v.memberregisterId") == '' || component.get("v.memberregisterId") == null){
            showErrorMsg = true;
            ErrorMsg=$A.get("$Label.c.Motion_Derm_Member_Error_Message");
        }
        if(showErrorMsg){                
            var advToastEvent = $A.get("e.force:showToast");
            advToastEvent.setParams({                
                message : ErrorMsg,
                duration: '10000',                
                type: 'error',
                mode: 'dismissible'
            });
            advToastEvent.fire();                 
        }
        //isValidSuccess = this.validateDermfields(component);
        if(!showErrorMsg){
        	var action = component.get("c.getDermURL");
       		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var homePageNewslabel = response.getReturnValue();
                homePageNewslabel = homePageNewslabel+'?memberID='+component.get("v.memberregisterId");
                window.open(homePageNewslabel);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
            
        }
    },
    updateSaveButton: function(component, event, helper){ 
        component.set('v.showSave',!event.getParam('validation'));
    },
    callEZcomm: function(component, event, helper){ 
        component.set('v.widget','EZCOMM');
        helper.showEZCommPopUp(component, event, helper);
    },
    callContactHistory: function(component, event, helper){ 
        component.set('v.widget','DCH');
        helper.showEZCommPopUp(component, event, helper);
    }
    
})