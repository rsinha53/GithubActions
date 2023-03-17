({
    //Dimpy US2904956: Capture Case Details 
    getdoccontent: function(component, event, helper){
        component.set("v.Spinner",true);
        setTimeout(function(){  
            var pagenum = component.get("v.pageNum");
            
            var caseitemsstr = document.getElementById("autodocCaseItemsHidden").value;
            var  caseitemsarrayone =[];
            caseitemsarrayone = caseitemsstr.split("||");
            var caseitemsarrayfinal =[];
            for(var i=0;i<caseitemsarrayone.length;i++){
                caseitemsarrayfinal.push(caseitemsarrayone[i].split("::").shift());
            }
            component.set("v.ExternalIDs",caseitemsarrayfinal);
            /////////////////////////////////////
            //Harkunal:06/14/2021:TA1074512:Start
            //Related cases were not displaying as Motion do not have external Id and a query on ACETLGT_RelatedCasesController.apxc is fecthing >50k records in production.
            //Below code added to make list emply for Motion if external Id is unavailable so that query will not be executed 
            /////////////////////////////////////  
            var ext= component.get('v.ExternalIDs');          
            if(component.get("v.developerName")=='Motion'){
                          if(ext ==null || ext== "" ){
                				ext.splice(0,1);
                	}  
            }
            ///////////////////////////////////
            //Harkunal:06/14/2021:TA1074512:End
            ///////////////////////////////////
          
            component.set("v.Spinner",false);    
            
            var childCmp = component.find("relatedcasescmp");
            if(!$A.util.isEmpty(childCmp)){
                childCmp.initrelatedcases();
            }
            
            
        }, 10);
        
        
    },
    getautodoccontent: function(component, event, helper){
        component.set("v.Spinner",true);
      setTimeout(function(){  
      var pagenum = component.get("v.pageNum");
        var pageId = component.get("v.AutodocKey");
        var pagefeature = component.get("v.pagefeature");
        console.log("-----pagenum---->>"+ pagenum);
        console.log("-----pageId---->>"+ pageId);
        if (pagenum != undefined  && pageId != undefined)
            window.lgtAutodoc.storePaginationData(pagenum,pageId);
if(pagefeature != undefined && pageId != undefined)
               window.lgtAutodoc.saveAutodoc(pagefeature, pageId);
        else
            window.lgtAutodoc.saveAutodoc(pagefeature);
        var caseitemsstr = document.getElementById("autodocCaseItemsHidden").value;
       var  caseitemsarrayone =[];
  caseitemsarrayone = caseitemsstr.split("||");
   var caseitemsarrayfinal =[];
  for(var i=0;i<caseitemsarrayone.length;i++){
   caseitemsarrayfinal.push(caseitemsarrayone[i].split("::").shift());
   }
   component.set("v.ExternalIDs",caseitemsarrayfinal);
    /////////////////////////////////////
    //Harkunal:06/14/2021:TA1074512:Start
    //Related cases were not displaying as Motion do not have external Id and a query on ACETLGT_RelatedCasesController.apxc is fecthing >50k records in production.
    //Below code added to make list emply for Motion if external Id is unavailable so that query will not be executed 
    /////////////////////////////////////  

    var ext= component.get('v.ExternalIDs');
    if(component.get("v.developerName")=='Motion'){
                    if(ext ==null || ext== "" ){
                        ext.splice(0,1);
            }  
    }
    ///////////////////////////////////
    //Harkunal:06/14/2021:TA1074512:End
    ///////////////////////////////////

    component.set("v.Spinner",false);    
    
    var childCmp = component.find("relatedcasescmp");
    if(!$A.util.isEmpty(childCmp)){
    childCmp.initrelatedcases();
        }
        
}, 10);
   

},
	getAllMemberAlerts : function(component, event, helper) {
		var intId = component.get("v.intId");
        var memID = component.get("v.memberId");
        var GrpNum = component.get("v.groupId");
        var action = component.get("c.getAllMemberAlerts");
       // alert('------'+intId +'-----'+memID +'-----'+GrpNum );
        
        action.setParams({
            "intId": intId,
            "memberId": memID,
            "groupNumber": GrpNum
        });
         
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            if(result != undefined && result != null && result != ''){
                component.set("v.memberAlerts", result);
                component.set("v.alertsSize", result.length);
            }	
            else{
                component.set("v.alertsSize", 0);
            }
                
        });
        $A.enqueueAction(action);
	},
    submitCase : function(component, event, helper){
      var followUp = component.get("v.flwupRequired");
        console.log('>>>> followup checkbox'+component.get("v.flwupRequired"));  
      event.getSource().set("v.label", "Submitting...");
      event.getSource().set("v.disabled", true);
      var pagenum = component.get("v.pageNum");
        var pageId = component.get("v.AutodocKey");
        console.log("-----pagenum---->>"+ pagenum);
        console.log("-----pageId---->>"+ pageId);
     //   if (pagenum != undefined  && pageId != undefined)
       //     window.lgtAutodoc.storePaginationData(pagenum,pageId);
        console.log("-----1---->>");
        //Close opend Tabs
        var topic = component.get('v.cseTopic');
        console.log("-----01---->>"+ topic);
        if(topic == $A.get("$Label.c.ACETCallTopicViewAuthorizations")){
            console.log("-----001---->>");
			helper.closeViewAuthTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicHSAAccount")){
            console.log("-----001---->>");
			helper.closeHSAAccountTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicViewPCPReferrals")){
            console.log("-----001---->>");
            helper.closeReferralDetailTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicViewClaims")){
            console.log("-----001---->>");
			helper.closeClaimDetailTabs(component, event, helper);
	}else if(topic == $A.get("$Label.c.ACETCallTopicViewPayments")){
            console.log("-----001---->>");
			helper.closePaymentFlowTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicProviderLookup")){
              console.log("-----001---->>");
              helper.closeProviderLookupTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicPlanBenefits")) {
              console.log("-----001---->>");
              helper.closePlanBenefitTabs(component, event, helper);
        }else if(topic == $A.get("$Label.c.ACETCallTopicIDCardRequest")) {
            helper.closeIdCardImageTabs(component);
        }
              console.log("-----0001---->>");
        

		console.log("-----2---->>");
        var pagefeature = component.get("v.pagefeature");
        console.log("-----Pagefeature---->>"+ pagefeature);
        component.set("v.Spinner", true);
    	//window.lgtAutodoc.saveStateAutodocOnSearch();
        //window.lgtAutodoc.saveAutodoc(pagefeature);
        //alert("====Pagefeature=====>"+ pagefeature);
        
       /* if(pagefeature != undefined && pageId != undefined)
        	window.lgtAutodoc.saveAutodoc(pagefeature, pageId);
        else
            window.lgtAutodoc.saveAutodoc(pagefeature);*/
		event.getSource().set("v.disabled", true);
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        
        var int = component.get("v.intId"); 
        var csetopic = component.get("v.cseTopicHolder");
        var csetype = component.get("v.cseType");
        var srk = component.get("v.srk");
        var csesubtype = component.get("v.cseSubtype");
        var comments = component.get("v.comments");
        //US2442061 : Migration Issue
        var migIssueChecked = component.get("v.migIssueRequired");
        console.log('=======>>Migration Issue >>>>'+migIssueChecked);
        //US2357303 Begin
        var escalatedChecked = component.get("v.escalatedRequired");
        console.log('=======>>Escalation Issue >>>>'+escalatedChecked);
        var complaintChecked = component.get("v.complaintRequired");
        console.log('=======>>Complaint Issue >>>>'+complaintChecked);
        //US2357303 End
        //US2442061 : Disaster / Epidemic Value
        var disasterEpidemicValue = component.get('v.disasterEpidemicValue');
        console.log('=======>>Disaster Epidemic Value >>>>'+disasterEpidemicValue);
        
        //Get Component Names
        var topiccmp = component.find("csetopic");        
        var typecmp = component.find("csetype");
        var subtypecmp = component.find("csesubtype");
        var subtypeops = component.get("v.subtypeOptions");
        var typeops = component.get("v.typeOptions");
        var caseDataWrapper = component.get("v.caseDataWrapper");
        var hlgtInfo = component.get("v.highlightPanel");
        
        console.log('=======>>Interaction>>>>'+int);
        console.log('=======>>csetopic--csetype>>>>'+csetopic+'<<--->>'+component.get("v.cseTopicHolder"));
        console.log('=======>>csesubtype>>>>'+csesubtype);
        
        csetopic = (csetopic == 'None')?'':csetopic;
        csetype = (csetype == 'None')?'':csetype;
        csesubtype = (csesubtype == 'None')?'':csesubtype;
        console.log('topiccmp:::'+JSON.stringify(topiccmp));
        console.log('topiccmp:::'+topiccmp.get("v.value"));
        console.log('csetopic:::'+csetopic);
        console.log('csetype:::'+csetype);
        console.log('csesubtype:::'+csesubtype);
        
        console.log('typecmp:::'+typecmp);
        console.log('subtypeops::'+subtypeops+':::'+subtypeops.length);
        
        //US1935709 : Run Validation
        if (!$A.util.isEmpty(csetopic)){
            
            
            if ($A.util.isEmpty(csetype) && typeops.length > 1){                
                $A.util.addClass(typecmp, "slds-has-error");                
                component.find("typeError").set("v.errors", [{message:"Error: You must select a Type."}]);
                //helper.displayToast("Error:", "You must select a Type.", component, helper, event);
                if (!$A.util.isEmpty(csesubtype)){
                	$A.util.removeClass(subtypecmp, "slds-has-error"); 
                	component.find("subTypeError").set("v.errors", null);
                }
                event.getSource().set("v.label", "Submit");
                event.getSource().set("v.disabled", false);
                return;
            
            }else if ($A.util.isEmpty(csesubtype) && subtypeops.length > 1){    
                //Check the Eligible subtypes
                //Check subtype is disabled or not
                //helper.checkValidTypes(component, event, helper, csetype);
                var retType = component.get("v.validTypeForSub");
                console.log('retType:::'+retType);
                //if (!retType){
                if (retType == "false"){
                    
                    $A.util.removeClass(typecmp, "slds-has-error");  
                    component.find("typeError").set("v.errors", null);
                
                    $A.util.addClass(subtypecmp, "slds-has-error");
                    component.find("subTypeError").set("v.errors", [{message:"Error: You must select a Subtype."}]);
                    event.getSource().set("v.label", "Submit");
                	event.getSource().set("v.disabled", false);
                    //helper.displayToast("Error:", "You must select a Subtype.", component, helper, event);  
                    return;
                }
            }else{
                $A.util.removeClass(subtypecmp, "slds-has-error"); 
                event.getSource().set("v.disabled", true);
                component.find("subTypeError").set("v.errors", null);
                
            }
            
        }
        console.log('--------------------->'+document.getElementById("autodocCaseItemsHidden").value);
		var dName=(component.get("v.developerName"));
        var autodocHidden = '';
        if(dName==='Motion' || dName==='Rollstone'){
        	var autoDocStr =  _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
			autodocHidden = JSON.stringify(autoDocStr);
        }else{
        	autodocHidden = document.getElementById("autodocHidden").value;//component.get("v.autodocHidden");    
        }
        
            var autodocCaseCommentsHidden = document.getElementById("autodocCommentHidden").value;//component.get("v.autodocCaseItemsHidden");
            var autodocCaseItemsHidden = document.getElementById("autodocCaseItemsHidden").value;//component.get("v.autodocCaseItemsHidden");
        	console.log('---------autodocHidden------------------------>'+autodocHidden);
        	console.log('---------autodocCaseItemsHidden--------------->'+autodocCaseItemsHidden);
        //var hlgtInfo = component.get("v.highlightsPanel");
            
        var action = component.get("c.createCase");
        	var caseDataWrapperStr = JSON.stringify(caseDataWrapper);
       		
        console.log('!!!! hlg create case before'+JSON.stringify(hlgtInfo));
        if(component.get("v.noAutoDoc")){
			var whoId = component.get("v.SubjectId");
       }
        else {
          var whoId = hlgtInfo.subjectID;
        }
        	var SubjectId = component.get("v.SubjectId");
        	var originator = component.get("v.originator");
            console.log('InteractionId::::::'+ int);
			 console.log('SubjectId::::::'+ SubjectId);
        console.log('whoId::::::'+ whoId);
			 console.log('originator::::::'+ originator);
			 console.log('csetopic::::::'+ csetopic);
			 console.log('csetype::::::'+ csetype);
			 console.log('csesubtype::::::'+ csesubtype);
			 console.log('srk::::::'+ srk);
			 console.log('comments::::::'+ comments);
			 console.log('autodocData::::::'+ autodocHidden);
			 console.log('autodocCaseItemsData::::::'+ autodocCaseItemsHidden);
			 console.log('autodocCaseCommentsHidden::::::'+ autodocCaseCommentsHidden);
			 console.log('caseDataWrapper::::::'+ caseDataWrapperStr);
			 console.log('highlightsPanelInfo::::::'+ hlgtInfo);
			var parentcaseid = component.get("v.parentcaseid");
        	//alert('----Tracking Orig----4---'+originator);
            action.setParams({
                "InteractionId": int,
                "SubjectId": SubjectId,
                "originator": originator,
                "csetopic": csetopic,
                "csetype": csetype,
                "csesubtype": csesubtype,
                "migIssueChecked":migIssueChecked,
                //US2357303 Begin
                "escalatedChecked":escalatedChecked,
                "complaintChecked":complaintChecked,
                //US2357303 End
                "disasterEpidemicValue":disasterEpidemicValue,
                "srk": srk,
                "comments":comments,
                "autodocData": autodocHidden,
                "autodocCaseItemsData": autodocCaseItemsHidden,
                "autodocCaseComment": autodocCaseCommentsHidden,
                "caseDataWrapper": caseDataWrapperStr,
                "highlightsPanelInfo": hlgtInfo,
                "parentcaseid": parentcaseid,
                "bookOfBusinessTypeCode" : component.get('v.bookOfBusinessTypeCode')
            });
            
            action.setCallback(this, function(a) {
                var stt = a.getState();
                console.log('stt :: '+stt);
                if (stt === "ERROR"){
                    var errs = a.getError();
                    console.log('ERROR :: '+errs[0].message);
                }
                var result = a.getReturnValue();
                console.log('Inside Created Case'+JSON.stringify(result));
                var cseTopic = component.get("v.cseTopic");
                
                var workspaceAPI = component.find("workspace");
                component.set("v.isModalOpen", false);
                component.set("v.cseType", 'None');
                component.set("v.cseSubtype", 'None');
                var isFlwup = component.get("v.flwupRequired");
                var taskRecordTypeId = component.get("v.taskRecordTypeId");
                console.log('>>isflw>> Task Rec'+isFlwup+taskRecordTypeId);
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    
                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        console.log(tabId);
                        console.log('=======GETTING REMOVED HERE=====1==');
                        localStorage.removeItem("rowCheckHold");
						//Added by dimpy to not close the tab for optum finacial when coming from detail page
						if(component.get("v.noAutoDoc") == false){
                        //To keep only detail page open and close the topic tab when case is saved and navigate to case detail page in subtab
                         if(!cseTopic.includes('Overview')){
                            workspaceAPI.closeTab({
                                tabId: tabId
                            });
                        } }
                        //	DE343655: Madhura : 07/02/2020
                        //	clear the comment box comment once the Save is success
                        $("." + pagefeature, $("[data-autodoc-comments='true']")).val("");
                        
                        component.set("v.Spinner", false);
                        console.log('>>Inside before subtab'+isFlwup);
                        if(!isFlwup){
                        workspaceAPI.openSubtab({
                                url: '/lightning/r/Case/'+result.Id+'/view',
                                focus: true
                            });
                        }else{
                            console.log('parent'+tabId);
                            
                            workspaceAPI.openSubtab({
                            url: '/lightning/r/Case/'+result.Id+'/view',
                                focus: false
                            })
                            var taskurl ='';
                            if(component.get('v.isMembernotfound')){
                             	taskurl = '/lightning/o/Task/new?defaultFieldValues=WhatId='+result.Id+'&recordTypeId='+taskRecordTypeId;  
                            }else{
                             	taskurl= '/lightning/o/Task/new?defaultFieldValues=WhoId='+whoId+',WhatId='+result.Id+'&recordTypeId='+taskRecordTypeId;   
                            }				
                             	workspaceAPI.openSubtab({
                                    parentTabId: tabId,
                                    url: taskurl,									
                            focus: true
                        });
                        }
                    });
                }
                
            });
            $A.enqueueAction(action);  
    },
    getAllAlerts : function(component, event, helper) {
       
		var params = event.getParam('arguments');
        var intId = params.param1;
        var memID = params.param2;
        var GrpNum = params.param3;
        var pageType = params.param4;
        var bundleId = params.param5;
        console.log('!!!param4'+pageType);
        var action = component.get("c.getAllMemberAlerts");
        
        //alert('------'+intId +'-----'+memID +'-----'+GrpNum+'-----'+bundleId );
        action.setParams({
            "intId": intId,
            "memberId": memID,
            "groupNumber": GrpNum,
            "bundleId":bundleId
        });
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            //alert('Inside call back2'+JSON.stringify(result));
            if(result != undefined && result != null && result != ''){
                component.set("v.memberAlerts", result);
                component.set("v.alertsSize", result.length);
                
                //alert('$$$$$$$$');
                if(result.length > 0 && pageType == 'Detail')
					component.set("v.isMemberAlertModalOpen", true);
                else
                    component.set("v.isMemberAlertModalOpen", false);
                
            }	
            else{
                component.set("v.alertsSize", 0);
                component.set("v.isMemberAlertModalOpen", false);
              //  alert('==========>'+result.length);
            }
                
        });
        $A.enqueueAction(action);
	},
    
    //US1935709 : Display Toast
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
        
    },
    
    checkValidTypes: function(component, event, helper, typeval){
        var retType = false;
        var action = component.get("c.getOptumExlusions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                console.log('From server: ' + response.getReturnValue());
                var returnTypeList = response.getReturnValue();
                for(var i=0; i < returnTypeList.length; i++){
                    console.log('returnTypeList[i]:::'+returnTypeList[i].MasterLabel);
                    if (returnTypeList[i].MasterLabel == typeval){                         
                        component.set("v.validTypeForSub", "true");
                        console.log('VALUE::'+component.get("v.validTypeForSub"));
                        //helper.setValue(component, event, helper);
                        break;
                    }else{
                        component.set("v.validTypeForSub", "false");
                    }   
                }
                
            }else if (state === "ERROR") {                
            }	
            
        });
        $A.enqueueAction(action); 
        
        
    },
    
    setValue: function(component, event, helper){
        var setValues = component.get("v.validTypeForSub");
        component.set("v.validTypeForSub2", "true");
        console.log('setValues::'+setValues);
        //console.log('setValues2::'+component.get("v."););
    },
    
    
    validateConsumerAccounts: function(component, event, helper){

        var accCallTypeList = component.get("v.valList");
        var accAccTypeList = component.get("v.accTypeList");
		var comm = component.get("v.comments");

        var isOtherSelected = false;
        for (var i in accCallTypeList) {
            if(accCallTypeList[i] === 'Other'){
                isOtherSelected = true;
            }
            
        }
        if(!isOtherSelected){
        if(accCallTypeList.length === 0){
            component.set("v.isPharmacyListEmptyError",true);
        }else if(accCallTypeList.length != 0){
            component.set("v.isPharmacyListEmptyError",false);
        }else{

        }

        if(accAccTypeList.length === 0){
            component.set("v.isAccountListEmptyError",true);
        }else if(accAccTypeList.length != 0){
            component.set("v.isAccountListEmptyError",false);
        }else{

        }
            
        if((comm === undefined) || (comm === '')){
  			  component.set("v.isCommentSetError",false);
        }else{
           component.set("v.isCommentSetError",false);
        }   
            
        if((accAccTypeList.length != 0 && accCallTypeList.length != 0)){
            component.set("v.isPharmacyListEmptyError",false);
            component.set("v.isAccountListEmptyError",false);

            component.set("v.isModalOpen", true);
        }
            
            
        }else if(isOtherSelected){
            
        	if(accCallTypeList.length === 0){
            	component.set("v.isPharmacyListEmptyError",true);
        	}else if(accCallTypeList.length != 0){
            	component.set("v.isPharmacyListEmptyError",false);
        	}else{
                
        	}
            
        	if(accAccTypeList.length === 0){
            	component.set("v.isAccountListEmptyError",true);
        	}else if(accAccTypeList.length != 0){
            	component.set("v.isAccountListEmptyError",false);
        	}else{

        	}
            
            if((comm === undefined) || (comm === '')){
                component.set("v.isCommentSetError",true);    
            }else{
                component.set("v.isCommentSetError",false);
                
                if((accAccTypeList.length != 0 && accCallTypeList.length != 0)){
            		component.set("v.isPharmacyListEmptyError",false);
            		component.set("v.isAccountListEmptyError",false);

            		component.set("v.isModalOpen", true);
        		}
            }

            
        }else{
        
        }

    },
    validateMemberOtherInquiry: function(component, event, helper){
        ///////////////////////////////////////////////////////////////////// 
        
        var commentId = component.get("v.AutodocKey")+'comments';
        var comVal = component.get("v.isCommentsHasValue");
        var ddVal = component.get("v.isDropDownHasValue");
          
				if(component.get("v.isDropDownHasValue")=='None' && comVal.length <1){ 

                    component.set("v.isCommentSetError",true);
                    component.set("v.isSetDropDownError",true);

                }else if(component.get("v.isDropDownHasValue")=='None' && (comVal =='')){

                    component.set("v.isCommentSetError",true);
                    component.set("v.isSetDropDownError",true);
                }else if(comVal ==undefined && component.get("v.isDropDownHasValue")==undefined){

                    component.set("v.isCommentSetError",true);
                    component.set("v.isSetDropDownError",true);

                }else if((comVal ==undefined || comVal =='' 
                 				&& (component.get("v.isDropDownHasValue")!='None') && (component.get("v.isDropDownHasValue")!=undefined))){

                    component.set("v.isCommentSetError",true);
                }else if((comVal ==undefined || comVal !='' 
                 				&& (component.get("v.isDropDownHasValue")=='None') || (component.get("v.isDropDownHasValue")==undefined))){

                    component.set("v.isSetDropDownError",true);
                }else {
                    component.set("v.isModalOpen", true);
                }
    },
    validateConsumerDashboard: function(component, event, helper){
        
        var val_opportunity = component.get("v.opportunity");
        var val_ncName = component.get("v.ncName"); 
		var vcTime = component.get("v.vcTime");
        var programsSelected = component.get("v.programsSelected");	//	US2528274 : Madhura 6/24/2020
        component.set("v.isProgramsListEmpty",false);
        
        var vcDate_val = component.get("v.vcDate");
        var minDate_val = $A.localizationService.formatDate(new Date(), "YYYY/MM/DD, HH:mm:ss.SSS");
        console.log('=====minDate_val=====>>'+minDate_val);
        console.log('=====DT=====>>'+new Date());
        var nowdate = new Date().getDate();
        var nowtime = new Date().getTime();
        var minDate = new Date(minDate_val);
        var vcDate = $A.localizationService.formatDate(vcDate_val, "YYYY/MM/DD");
        var todayDate = new Date(vcDate);
        
        var val_vcDate = component.get("v.show_vcDateError");
        var val_vcTime = component.get("v.show_vcTimeError");
		console.log('=====vcTime=====>>'+vcTime);
        console.log('=====vcDate_val=====>>'+vcDate_val);
        console.log('=====minDate=====>>'+minDate);
        if((vcTime == null) || (vcTime == undefined) || vcTime ==''){
            //Set Bool Value to False : To be passed to TTS
            
            component.set("v.isValid_VCD_PriorTime",false);
            component.set("v.isValid_VCD_Time",false);
        }else{
            component.set("v.isValid_VCD_Time",true);
            component.set("v.isValid_VCD_PriorTime",true);
        }
            
	    console.log('-----todaydate-1---'+todayDate.getTime() );
        console.log('-----todaydate-2---'+ nowtime);
        console.log('-----todaydate-2---'+ minDate.getTime());
        if((vcDate_val == '' ) || (vcDate_val == undefined ) || (vcDate_val == null )) {
            console.log('blank'+vcDate_val);
            //Set Bool value to false to send to : TTS
            component.set("v.isValid_VCD_PriorDate",false);
            component.set("v.isValid_VCD_Date",false);
        }
        else if(todayDate.getDate() == nowdate){
			console.log('Same date');
	    if(vcTime != null){
                var currentTime = minDate_val.split(',')[1].trim().substr(0,2).concat(minDate_val.split(',')[1].trim().substr(3,2));
                var EnteredTime = vcTime.substr(0,2).concat(vcTime.substr(3,2));
                console.log(EnteredTime + currentTime);
                if(parseInt(EnteredTime) >= parseInt(currentTime)){
                    component.set("v.isValid_VCD_Time",true);
                    component.set("v.isValid_VCD_PriorTime",true);
                }else{
                    
                    component.set("v.isValid_VCD_PriorTime",false);
                    component.set("v.isValid_VCD_Time",false);
                }
            }
            component.set("v.isValid_VCD_Date",true);
            component.set("v.isValid_VCD_PriorDate",true);
                
		}else if(todayDate.getTime() > nowtime){
            console.log('greater than');
            //Error Date Validation
            component.set("v.isValid_VCD_Date",true);
            component.set("v.isValid_VCD_PriorDate",true);
            //$A.util.removeClass(dateCmp, "slds-has-error");
        }else if(todayDate.getTime() < nowtime){
            console.log('less than');
            //Error Date Validation  
            component.set("v.isValid_VCD_PriorDate",false);
            component.set("v.isValid_VCD_Date",false); 
		}
		
		else{
			//Set Bool value to true to send to : TTS
            component.set("v.isValid_VCD_Date",true);
            component.set("v.isValid_VCD_PriorDate",true);
        }
        
        var opportunityDropdown = component.get("v.isValid_VCD_Opportunity");
        var appointmentRadioBtn = component.get("v.isValid_VCD_Appointment");
        var date = component.get("v.isValid_VCD_Date");
        var time = component.get("v.isValid_VCD_Time");
        var priordate = component.get("v.isValid_VCD_PriorDate");
        var priortime = component.get("v.isValid_VCD_PriorTime");
        var ncName = component.get("v.isValid_VCD_ncName");
        
        //	US2528274 by Madhura to validate if at least one program is being selected 6/24/2020
        if((programsSelected.length === 0) || component.get("v.programsSelected")===null || component.get("v.programsSelected")==undefined){
            component.set("v.isProgramsListEmpty",true);
        }
        if(!opportunityDropdown){
            component.set("v.isCDDropdownSetError",true);
            
            console.log('Set opp error');
        }else {
            if(appointmentRadioBtn){
				console.log('appointment check');
                
                if(priordate && date){
                    component.set("v.show_vcPriorDateError",false); 
                    component.set("v.show_vcDateError",false);
                    console.log('Valid Date No error');
                }else if(!priordate && !date){
                    if((vcDate_val == '' ) || (vcDate_val == undefined ) || (vcDate_val == null) ){
                        console.log('Blank : Invalid Date'+vcDate_val);
                        component.set("v.show_vcPriorDateError",false); 
                        component.set("v.show_vcDateError",true);
                    }else{
						console.log('Enter current or future date');
                        component.set("v.show_vcPriorDateError",true); 
                        component.set("v.show_vcDateError",false);
                    }
                }
                
                if(priortime && time){
                    component.set("v.show_vcPriorTimeError",false); 
                    component.set("v.show_vcTimeError",false);
                    console.log('Valid Time No error');
                }else if(!priortime && !time){
                    if((vcTime == '' ) || (vcTime == undefined ) || (vcTime == null) ){
                        console.log('Blank : Invalid Time'+vcTime);
                        component.set("v.show_vcPriorTimeError",false); 
                        component.set("v.show_vcTimeError",true);
                    }else{
						console.log('Enter current or future time');
                        component.set("v.show_vcPriorTimeError",true); 
                        component.set("v.show_vcTimeError",false);
                    }
                }
               
                if((!ncName ) && (val_ncName.length == 0)){
                    console.log('Name check');
                    component.set("v.show_ncNameError",true);
                    
                }else
                    component.set("v.show_ncNameError",false);
                
                if((time) && (date) && (ncName) && priordate && priortime && !component.get("v.isProgramsListEmpty")){
                    component.set("v.isModalOpen", true);
                }
            }else{
                if(!component.get("v.isProgramsListEmpty")) {
                    component.set("v.isModalOpen", true);
                }
            }
        }
    },
    validatePharmacy: function(component, event, helper){

        var pharmacyComment = component.get("v.PharmacyCommentsValue");
        var pharmacyCSRF = component.get("v.PharmacyCSRFValue");
        var pharmacyBoolYes = component.get("v.PharmacyCSRFYes");
        var pharmacyBoolNo = component.get("v.PharmacyCSRFNo");
        
        console.log('pharmacyComment : ', pharmacyComment);
        console.log('pharmacyCSRF : ', pharmacyCSRF);
        console.log('pharmacyBoolYes : ', pharmacyBoolYes);
        console.log('pharmacyBoolNo : ', pharmacyBoolNo);

        var pharmacyArrayVal = component.get("v.valList");
        
        var pharmacyList = component.get("v.valList");
         var pharmacyCSRFEmptyCheck = ($A.util.isEmpty(component.get("v.PharmacyCommentsValue")));
        if((pharmacyComment == undefined) && (component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined) && (pharmacyList.length > 0)) {
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharCheckSetError",true);
            component.set("v.isPharmacyListEmptyError",false);            
        }else if((pharmacyComment == undefined) && (component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined) && (pharmacyList.length === 0)) {
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharCheckSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
        }else if((pharmacyComment === '' ) && (component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined) && (pharmacyList.length === 0)) {
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharCheckSetError",true);
            component.set("v.isPharmacyListEmptyError",true);    
        }else if((pharmacyComment == undefined) && (component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined) && (component.get("v.PharmacyCSRFValue")==='') && (pharmacyList.length > 0)) {   
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharCheckSetError",true);
        }else if((pharmacyComment === '') && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (component.get("v.PharmacyCSRFValue")!='') && (pharmacyList.length > 0)) {   
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
        }else if((pharmacyComment === '') && (component.get("v.PharmacyCSRFYes")==false) && (component.get("v.PharmacyCSRFNo")==true) && (component.get("v.PharmacyCSRFValue")!='') && (pharmacyList.length === 0)) {   
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
        }else if((pharmacyComment != null)  && (component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined) && (pharmacyList.length === 0)){          
            component.set("v.isPharCheckSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
        }else if((pharmacyComment != null)  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (component.get("v.PharmacyCSRFValue")=='') && (pharmacyList.length === 0) && ( component.get("v.PharmacyCSRFValue")=='')){
        	component.set("v.isPharCSRFSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
            console.log('1');
        }else if((pharmacyComment != null)  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (component.get("v.PharmacyCSRFValue")!=null) && (pharmacyList.length === 0)){
            component.set("v.isPharmacyListEmptyError",true);
            component.set("v.isPharCSRFSetError",false);
            console.log('2');
        }else if((pharmacyComment == undefined)  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (component.get("v.PharmacyCSRFValue")=='') && (pharmacyList.length === 0)){
            component.set("v.isPharCommentSetError",true);
			component.set("v.isPharCSRFSetError",true);
            component.set("v.isPharmacyListEmptyError",true);
            console.log('3');
        }else if((pharmacyComment == undefined)  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (component.get("v.PharmacyCSRFValue")!=undefined && component.get("v.PharmacyCSRFValue")!=null) && (pharmacyList.length === 0)){
            component.set("v.isPharCommentSetError",true);
			component.set("v.isPharCSRFSetError",false);
            component.set("v.isPharmacyListEmptyError",true);
            console.log('4');
        }else if((pharmacyComment != '')  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (pharmacyList.length != 0) && ( component.get("v.PharmacyCSRFValue")=='')){
            component.set("v.isPharCSRFSetError",true);
            console.log('5');
        }else if((component.get("v.PharmacyCommentsValue")==null) || (component.get("v.PharmacyCommentsValue")=='') || (component.get("v.PharmacyCommentsValue")==undefined)){
            component.set("v.isPharCommentSetError",true);
        }else if((component.get("v.PharmacyCSRFYes")==undefined) && (component.get("v.PharmacyCSRFNo")==undefined)){ 
            component.set("v.isPharCheckSetError",true);
        }else if((pharmacyComment == '') && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (pharmacyList.length === 0)) {
            component.set("v.isPharmacyListEmptyError",true);
            component.set("v.isPharCommentSetError",true);
            component.set("v.isPharCSRFSetError",true);
            console.log('6');
        }else if((pharmacyList.length === 0) || component.get("v.valList")===null || component.get("v.valList")==undefined){
            component.set("v.isPharmacyListEmptyError",true);

        }else if((pharmacyComment != null)  && (component.get("v.PharmacyCSRFYes")==true) && (component.get("v.PharmacyCSRFNo")==false) && (pharmacyList.length != 0) && (component.get("v.PharmacyCSRFValue")!=null)&& (pharmacyCSRF.length===6)){          
            component.set("v.isModalOpen", true);
	    	component.set("v.isPharmacyListEmptyError",false);
        }else if((pharmacyComment != null)  && (component.get("v.PharmacyCSRFYes")==false) && (component.get("v.PharmacyCSRFNo")==true) && (pharmacyList.length != 0) ){          
            component.set("v.isModalOpen", true);
            component.set("v.isPharmacyListEmptyError",false);
        }else if((pharmacyCSRFEmptyCheck==true) && (component.get("v.PharmacyCSRFYes")==false) && (component.get("v.PharmacyCSRFNo")==true) && (pharmacyList.length != 0)){    
            component.set("v.isPharmacyListEmptyError",true);
            component.set("v.isPharCommentSetError",true);
			component.set("v.isPharCSRFSetError",true);
            console.log('7');    
        }else{
            
        }

    },

    //US1935707: Research user - User doesnt see misdirect button
    checkProfileType: function(component, event, helper){
    	console.log('here checkprofiletype');
        console.log(component.get('v.userInfo'));
        
        var userProfileName = component.get("v.userInfo").Profile_Name__c;
        if (userProfileName == $A.get("$Label.c.ACETResearchUserProfile")){
            component.set("v.showSave", "false");
            component.set("v.showMisdirect", "false");
            window.localStorage.setItem('uProfile', 'hideSave');
		}
    },
    
    //US2132858: Close View Auth Tabs upon Misdirect and TTS Save
    closeViewAuthTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                
                for (var i=0; i<tabInfo.length; i++){                    
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 

                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            

                            if (tabInfo[i].subtabs[j].title.includes("Auth -")){                             
                                workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    
    checkPCPButtonAccess: function(component, event, helper){
    	var userInfo = component.get("v.userInfo");
	    console.log('PCP access'+userInfo.Role_Name__c+userInfo.Profile_Name__c);
	    
	    var action = component.get("c.buttonAccessPCP");
	    //action.setStorable();
	    
	    action.setParams({
	        userRole : userInfo.Role_Name__c
	    });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (state === "SUCCESS") {
	            var storeResponse = response.getReturnValue();                
	            console.log('storeResponse'+storeResponse);    
	            if(userInfo.Profile_Name__c != 'Research User' && storeResponse == 'true'){
	                component.set("v.PCPallowedUser",'true');
	                helper.getPCPCreateURL(component, event, helper);
            	}
	            else{
	                component.set("v.PCPallowedUser",'false');
                }
            }
	    });
	    $A.enqueueAction(action);
    },
    
    getPCPCreateURL: function(component, event, helper){
    	var action = component.get("c.PCPCreateURL");
    	var memID = component.get("v.memberId");
	    //action.setStorable();
	    action.setParams({
	        memberID : memID
	    });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (state === "SUCCESS") {
	        	var storeResponse = response.getReturnValue();                
	            component.set("v.createPCPLink", storeResponse);
	        }
	    });
	    $A.enqueueAction(action);
    },
     closeProviderLookupTabs: function(component, event, helper){
        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            if (tabInfo.length > 0){                
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            
							console.log("-----001-9--->>");
                            console.log(tabInfo[i].subtabs[j].title);
                            if (!$A.util.isEmpty(tabInfo[i].subtabs[j].customTitle) && !$A.util.isUndefined(tabInfo[i].subtabs[j].customTitle)){
                                if (tabInfo[i].subtabs[j].customTitle.includes("Prov -") || tabInfo[i].subtabs[j].customTitle.includes("-") ){                             
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                            }
                        }
                    }
                }
            }
        });
    },
    
    // Close Referral Detail Tabs upon Misdirect and TTS Save
     closeReferralDetailTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            
                            if (!$A.util.isEmpty(tabInfo[i].subtabs[j].customTitle) && !$A.util.isUndefined(tabInfo[i].subtabs[j].customTitle)){
                                if (tabInfo[i].subtabs[j].customTitle.includes("Referral -")){                             
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    
    // Close Claim Detail Tabs upon Misdirect and TTS Save
     closeClaimDetailTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        console.log("-----001-1--->>");
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                console.log("-----001-2--->>");
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
                        console.log("-----001-3--->>");
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){
                            console.log("-----001-4--->>"+tabInfo[i].subtabs[j].title); 
                            if (!$A.util.isEmpty(tabInfo[i].subtabs[j].customTitle) && !$A.util.isUndefined(tabInfo[i].subtabs[j].customTitle)){
                                if (tabInfo[i].subtabs[j].customTitle.includes("Claim -")){      
                                    console.log("-----001-5--->>");
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                                if (tabInfo[i].subtabs[j].customTitle.includes("Document -")){      
                                    console.log("-----001-6--->>");
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                                if (tabInfo[i].subtabs[j].customTitle.includes("Payments")){      
                                    console.log("-----001-6--->>");
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                            }
                        }
                        
                    }
                }
                
            }
        });
    },
    
    
    
    //US2132858: Close HSA Bank Account Tabs upon Misdirect and TTS Save
    closeHSAAccountTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                
                for (var i=0; i<tabInfo.length; i++){                    
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 

                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            

                            if (tabInfo[i].subtabs[j].title.includes("HSA -")){                             
                                workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    
    closePaymentFlowTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        console.log("-----001-1--->>");
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                console.log("-----001-2--->>");
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
                        console.log("-----001-3--->>");
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){
							console.log("-----001-4--->>");                            
                            if (tabInfo[i].subtabs[j].title.includes("Claim -") || tabInfo[i].subtabs[j].title.includes("Claims Search")){      
                                console.log("-----001-5--->>");
                                workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    // Close plan benefit Tabs upon Misdirect and TTS Save
     closePlanBenefitTabs: function(component, event, helper){
		console.log("-----001-6--->>");
        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                console.log("-----001-7--->>");
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
						console.log("-----001-8--->>");
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            
							console.log("-----001-9--->>");
                            console.log(tabInfo[i].subtabs[j].title);
                            if (!$A.util.isEmpty(tabInfo[i].subtabs[j].customTitle) && !$A.util.isUndefined(tabInfo[i].subtabs[j].customTitle)){
                                if (tabInfo[i].subtabs[j].customTitle.includes("Plan Benefits Detail")){                             
                                    workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                                }
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
   
    //US2460281: Lightnig Id cards - close Id card image tabs when case is saved
    // By Madhura : 17 June 2020
    closeIdCardImageTabs: function(component) {
        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {            
            if (tabInfo.length > 0){                
                for (var i=0; i<tabInfo.length; i++){
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){
                            if (tabInfo[i].subtabs[j].title.includes("Id Card Image")){                             
                                workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                            }
                        }                        
                    }
                }                
            }
        });
    },
    showEZCommPopUp: function(component,event, helper) {
        console.log('eZCommType---------'+component.get('v.widget'));
        console.log('bookOfBusiness---'+component.get('v.bookOfBusinessTypeCode'));
        console.log('highlightsPanelInfo---'+component.get("v.highlightPanel"));
        var action = component.get("c.getEZCommURL");
        action.setParams({
            "widget": component.get('v.widget'),
            "bookOfBusiness": component.get('v.bookOfBusinessTypeCode'),
            "highlightsPanelInfo": component.get("v.highlightPanel"),
            "memFirstName" : component.get("v.memFirstName"),
            "memLastName" : component.get("v.memLastName"),
            "memDOB" : component.get("v.memDOB"),
            "groupId" : component.get("v.groupId"),
            "memberId" : component.get("v.memberId"),
            "landingPageOnMemberDetail" : component.get("v.landingPageOnMemberDetail")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                console.log('EZComm result'+result);
                console.log(result);
                if (!($A.util.isUndefinedOrNull(result))) {
                    var EZCommOrDCHUrl = result;
                    if(component.get('v.widget') == 'EZCOMM') {
                      window.open(EZCommOrDCHUrl, 'EZCommWindow', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
                    }else if(component.get('v.widget') == 'DCH') {
                       window.open(EZCommOrDCHUrl, 'DCHWindow', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1'); 
                    }
                }	
            }else {
               console.log('state' +state);
            }   
          });
        $A.enqueueAction(action);    
    }
})