({
    onEventClick : function(component, event, helper) {
        var selectedEvent = event.target;
        var eventType = selectedEvent.getAttribute("data-eventType");
        var originalOffers = component.get("v.originalOffers");	//	get initially loaded offer list
        var categorizedOffers = [];	//	to maintain offers with selected category
        
        //	iterate over original offers and set only offers from selected category
        if(originalOffers && originalOffers.length) {
            originalOffers.forEach(function(value, index, array) {
                if(value.offerCategory == eventType){
                    categorizedOffers.push(value);
                }
            });
        }
        
        //	setting display configurations ; offer list, default row count and more button
        component.set("v.displayOffers", categorizedOffers);
        component.set("v.listEndCount", 3);
        component.set("v.isMoreButtonVisible", "true");
    },
    
    // Function to check if policy is terminated
    /*policyCheck : function(component, event, helper) {
        var memberId = component.get("v.decodedMemberId");
        //var memberId = "474706605";
        //var memberdob = "1958-05-05";
		var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var policy = component.get("v.policy");												   
        var DOB = component.get("v.memberDOB");
        // change date format as per the request
        if(DOB != undefined){
            var memberDOB = DOB.split("/");
            var memberdob = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        } 
        
        // Call v2 service to get the enddate of policy
        var action = component.get("c.getEnddatefromV2Service");
        action.setParams({ memberId : memberId,
                          memberDob : memberdob,
                          memFirstName:memFirstName,
                          memLastName:memLastName,
                          policy:policy
                         });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log('response end date & status::', response);
                if(response!=null){
                    var policyStatus = response.policyStatus;
                    var errorMessage = response.errorMessage;
                    if(errorMessage == "terminated"){
                        component.set("v.isError", true);
                        component.set("v.isTerminated", true);
                        component.set("v.isInfoMsg", true);
                        component.set("v.errorMessage", "Members' Policy is Terminated");
                        component.set("v.isServicePending", false);	//	hide the spinner
                    }else{
                        helper.getRole(component, event, helper);
                        setTimeout(function(){
                            var tabKey = component.get("v.AutodocKey");
                            if(tabKey != undefined)
                            	window.lgtAutodoc.initAutodoc(tabKey);
                        },1);
                    }
                }
                else{
                    component.set("v.isError", true);
                    component.set("v.errorMessage", "Offer Information cannot be retrieved. Open a Help Desk ticket.");
                }
            }
        });
        
        $A.enqueueAction(action);
    },*/
    // Function to get functional role - DE355671 - sunil vennam
    getRole : function(component, event, helper) {
        var userId = component.get("v.agentUserId");
        //var userId = 'aballa';
        var isIntegration = component.get("v.isIntegrationUser");
        var action = component.get("c.getfunctionalRole");
        action.setParams({ userId : userId,
                          isIntegration : isIntegration});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log('Functional Role :::::', response);
                component.set("v.functionalRole", response);
                helper.getOpportunities(component, event, helper,isIntegration);
            }else{
                component.set("v.isError", true);
                component.set("v.errorMessage", "Offer Information cannot be retrieved. Open a Help Desk ticket.");
                component.set("v.isServicePending", false);
            }
        });
        $A.enqueueAction(action);
    },
    //	get more opportunities from the service
    getOpportunities : function(component, event, helper,isIntegration) {   
        component.set("v.isServicePending", true);	//	show the spinner
        var currentOpportunities = component.get("v.displayOffers");
        var showUpdateVal = component.get('v.showUpDate');
        var action = component.get("c.getOpportunities");
        //var cdb_XREFID = "82384376" ; //424922789 //562912759
        var cdb_XREFID = component.get("v.memberXrefId");
        var functionRole = component.get("v.functionalRole");
        var memberIdType = component.get("v.memberTypeId");
        var noOfOffers = component.get("v.noOfOffers");
		var userId = component.get("v.agentUserId");											
        console.log('cdb_XREFID ::: ',cdb_XREFID);
        console.log('cdb_XREFID ::: '+memberIdType+' '+showUpdateVal+' '+noOfOffers)
        action.setParams({ memberId : cdb_XREFID,
                          memberTypeId : memberIdType,
                          noOfOffers : noOfOffers,
                          functionRole: functionRole,
                          userId: userId,
                          isIntegration : isIntegration});			   
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                                
                var offersWrapper = response.getReturnValue();	// get the response
                console.log('offerswrapper', offersWrapper);
                var offers = offersWrapper.offers;	//	get the offers(opportunities) list
                //	maintain the original offer list separately to send as a SLI request
                component.set("v.responseOfferList", offers);
                
                //	if the service returned with a success reponse, apply other logics and display
                if(offersWrapper.statusCode == 200) {
                    //	iterate over the newly retrieved opportunities and push them to the list
                    
                    if(offers && offers.length) {
                        offers.forEach(function(value, index, array) {
                            var eve = value.event;
                            var description = value.description;
                            var todo = value.todo;
                            var maxLength = 45;
                            if(description.length > maxLength){
                                var res1 = description.substring(0, maxLength-3);
                                var res2 = "...";
                                var text = res1.concat(res2);
                                value.description = text;
                            }
                            else{
                                value.descriptionHoverOver = null;
                            }
                            
                            if(todo.length > maxLength){
                                var res1 = todo.substring(0, maxLength-3);
                                var res2 = "...";
                                var text = res1.concat(res2);
                                value.todo = text;
                            }
                            else{
                                value.todoHoverOver = null;
                            }
                            currentOpportunities.push(value);
                        });
                    }
                    //Error message code - US2264164
                    else{
                        
                        component.set("v.isError", true);
                        
                        var message = offersWrapper.responseMessage;
                        console.log('Response Message :', message);
                        if(message!=null){
                            if(component.get("v.policyTerminated") == true) {
                                component.set("v.isInfoMsg", true);
                                component.set("v.errorMessage", "Member's Policy is Terminated");
                            } else if (message.includes("No offers available") == true && component.get("v.policyTerminated") == false) {
                                component.set("v.isInfoMsg", true);
                                component.set("v.errorMessage", "You have no opportunities to offer this member.");
                            } else {
                                component.set("v.errorMessage", "Offer Information cannot be retrieved. Open a Help Desk ticket.");
                            }
                        }
                    }
                    //Error message code - US2264164
                    
                    
                    //	bind the compiled new list with UI
                    component.set("v.displayOffers", currentOpportunities);
                    
                    //	maintain the original offer list separately
                    component.set("v.originalOffers", currentOpportunities);
                    //	update the cap value to list length so the table will show all the records
                    component.set("v.listEndCount", 3);
                    
                    // initialize value for count
                    helper.initializeValue(component, event, helper);
                }
                else{
                    component.set("v.isError", true);
                    component.set("v.errorMessage", "Offer Information cannot be retrieved. Open a Help Desk ticket.");
                }
                
                setTimeout(function(){
                    var tabKey = component.get("v.AutodocKey");
                    if(tabKey != undefined)
                    	window.lgtAutodoc.initAutodoc(tabKey);
                    
                },1);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            component.set("v.isError", true);
                            component.set("v.errorMessage", "Offer Information cannot be retrieved. Open a Help Desk ticket.");
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            component.set("v.isServicePending", false);	//	hide the spinner
        });
        
        $A.enqueueAction(action);
    },
    
    
    //	get top opportunities from the service : 
    //	TODO : to be removed
    getTopOpportunities : function(component, event, helper) {
        var parCount = 0;
        var medCount = 0;
        var clnCount = 0;
        var finCount = 0;
        var totalCount = 0;
        var action = component.get("c.getTopOpportunities");
        action.setParams({ memberId : component.get("v.memberXrefId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Opportunities = response.getReturnValue();
                component.set("v.displayOffers", Opportunities);
                
                if(Opportunities && Opportunities.length) {
                    Opportunities.forEach(function(value, index, array) {
                        
                        if(value.event == "PAR"){
                            parCount=parCount+1;
                        }
                        else if(value.event == "MED"){
                            medCount=medCount+1;
                        }
                            else if(value.event == "CLN"){
                                clnCount=clnCount+1;
                            }
                                else if(value.event == "FIN"){
                                    finCount=finCount+1;
                                }
                    });
                }
                
                /*	COMMENTING OUT FOR NOW FOR BUSINESS DEMO
                        component.set("v.parmacyCount", parCount);
                        component.set("v.medicalCount", medCount);
                        component.set("v.clinicalCount", clnCount);
                        component.set("v.financialCount", finCount);
                        component.set("v.totalCount",parCount+medCount+clnCount+finCount);
                        */
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
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
        });
        $A.enqueueAction(action);
    },
    
    //	toggle comment Ok button
    toggleOkButton : function(component, inputText) {
        if(!$A.util.isEmpty(inputText)){
            component.set('v.isOkButtonDisabled',false);
        }   
        else{
            component.set('v.isOkButtonDisabled',true);
        }
    },
    
    // handle save button visibility
    checkboxClickEvent : function(component, event, helper) {
        var values = document.getElementsByClassName("itemCheckboxes");
        for (var i = 0; i < values.length; i++){
            if(values[i].checked){
                component.set('v.isSaveButtonDisabled',false);
                break;
            }
            else{
                component.set('v.isSaveButtonDisabled',true);
            }
        }
    },
    
    // open comment box 
    commentBoxHandler: function(component, event, helper){
        //	track the index of the selected row
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_index");
        
        component.set('v.listIndex', listIndex);	// set current index to be used in 'Ok' button handler
        var disposision = document.getElementById('dropdown' + listIndex);
        
        //	set the current item's comment into the comment box
        var dataList = component.get("v.displayOffers");
        var item = dataList[listIndex];
        
        component.set("v.isCommentBoxVisible", true);                        
        component.set("v.removeOpportunityComment", item.removeOpportunityComment);
        
        helper.toggleOkButton(component, component.get('v.removeOpportunityComment'));
        
    },
    
    dispositionChange: function(component, event, helper){
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_index");
        component.set('v.listIndex', listIndex);
        
        // get old value of selected disposition 
        var oldDisposition = component.get("v.selectedValue");
        var lstDisposition = component.get("v.listOfDisposision");
        var strDisposition = lstDisposition.join("");
        
        // convert list to string
        var lengthValue = strDisposition.length;
        
        // when all dropdowns are deselected, disable Save button
        if(lengthValue == 0){
            component.set('v.isSaveButtonDisabled',true);
        }
        // at lease one dropdown is selected, enable Save button
        else{
            component.set('v.isSaveButtonDisabled',false);
        }
        component.set("v.listOfDisposition", strDisposition);
    },
    
    // initialize value for count
    initializeValue: function(component, event, helper) {
        var moreData = component.get("v.displayOffers");
        var parCount = 0;
        var medCount = 0;
        var clnCount = 0;
        var finCount = 0;
        var totalCount = 0;
        
        if(moreData && moreData.length) {
            moreData.forEach(function(value, index, array) {
                if(value.offerCategory == "PAR"){
                    parCount = parCount+1;
                }
                else if(value.offerCategory == "MED"){
                    medCount = medCount+1;
                }
                    else if(value.offerCategory == "CLN"){
                        clnCount = clnCount+1;
                    }
                        else if(value.offerCategory == "FIN"){
                            finCount = finCount+1;
                        }
            });
            
            var totalCount = parCount+ medCount + clnCount + finCount ;
            
            component.set("v.parmacyCount", parCount);
            component.set("v.medicalCount", medCount);
            component.set("v.clinicalCount", clnCount);
            component.set("v.financialCount", finCount);
            component.set("v.totalCount", totalCount);
        }
    },
    
    handleonmouseover: function(component, event, helper) {
        component.set('v.isHoverVisible',true);
        component.set('v.hoverRow', parseInt(event.target.dataset.index));
        component.set('v.hoverCol', parseInt(event.target.dataset.column));
    },
    
    handleonmouseout: function(component, event, helper) {
        component.set('v.isHoverVisible',false); 
    },
    
    saveDispositions: function(component, event, helper) {
        //	Adding Spinner - 7/20/2020 Madhura
        component.set("v.isServicePending", true);
        
        // get index of selected disposition 
        var listIndex = component.get("v.listIndex");
        console.log('list index::',listIndex);
        
        // get agent userid to pass as a request
        var userid = component.get("v.agentUserId");
        //var userid = 'aballa';
        // Attributes for SSO disposition - Sunil Vennam
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var userComments = component.get("v.removeOpportunityComment");

        // get offer to set params
        var offerResponse = component.get("v.originalOffers")[listIndex];
        var disposition = document.getElementById('dropdown' + listIndex).value;
        console.log('disposition', disposition);
        
        //get all dispositions for the offer submitted
        var offerDispositions = offerResponse["disposition"];
        var dispTodoLnk,blacklistDays;
        var mdfdDis = disposition;
        if(disposition == 'Accept'){
            mdfdDis = 'TellMeMore';
        }
        else if(disposition == 'Maybe_Later'){
            mdfdDis = 'MaybeLater';
        }
            else if(disposition == 'Decline'){
                mdfdDis = 'NoInterest'; 
            }
                else if(disposition == 'Not_Appropriate'){
                    mdfdDis = 'RemoveOff';
                }
        offerDispositions.forEach(function(dis){
            if(dis.dispName == mdfdDis){
                dispTodoLnk = dis.todoLink;
            } 
            if(dis.dispName=='RemoveOff' && dis.nbaStatusReason=='ClInApp'){
                blacklistDays = dis.blacklistDays;
            }
        });
        var nbaParentId = offerResponse["nbaParentId"];
        
        var action = component.get("c.getSaveOpportunities");
        
        //var cdb_XREFID = "82384376";
        var cdb_XREFID = component.get("v.memberXrefId");
        console.log('memberId'+cdb_XREFID+'offerResponseList::'+offerResponse+'evntName::'+disposition+'todoLink::'+dispTodoLnk+'firstName::'+memFirstName+'lastName::'+memLastName+'DOB::'+memDob+'userId::'+userid+'subscriberId::'+memberId);
        action.setParams({ memberId : cdb_XREFID , 
                          offerResponseList : offerResponse,
                          evntName : mdfdDis,
                          todoLink : dispTodoLnk,
                          firstName: memFirstName,
                          lastName:  memLastName,
                          DOB: memDob,
                          userId:  userid,
                          subscriberId:  memberId,
                          nbaParentId : nbaParentId,
                          blacklistDays: blacklistDays,
                          userComments: userComments});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('opportunities',result);
                if(result!=null){
                    
                    if(result.todoLink != 'REFRESH_DASHBOARD'){
                        var redirectionUrl = result.redirectionUrl;
                        console.log('redirectionUrl'+redirectionUrl);
                        if(redirectionUrl != null && redirectionUrl != ''){
                            window.open(redirectionUrl);
                        }
                    }
                    //	setting below attributes as blank  as the card is getting refreshed
                    var blankOffers = [];
                    component.set("v.displayOffers", blankOffers);
                    component.set("v.originalOffers", blankOffers);
                    component.set('v.listIndex', '');
                    $A.enqueueAction(component.get('c.onInit'));
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
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
            component.set("v.isServicePending", false);	//hiding the spinner
        });
        $A.enqueueAction(action);
    }, 
    
    getDashboardURL : function(component, event, helper) {
		    var srk = component.get("v.memberXrefId");
        var hlp = component.get("v.highlightPanel");
        var memberId,groupNumber,fName,lName,birthDateOG,tempBirthDateArr,tempBirthDate;
        if(hlp != undefined && hlp != null){
           memberId = hlp.MemberId;
           groupNumber = hlp.GroupNumber;
           fName = component.get("v.subject_firstName");
           lName = component.get("v.subject_lastName");
           birthDateOG = hlp.MemberDOB.split(' ')[0];
          if(birthDateOG != null) {
              tempBirthDateArr = birthDateOG.split('/');
  			      tempBirthDate = tempBirthDateArr[2] + '-' + tempBirthDateArr[0] + '-' + tempBirthDateArr[1];
          }
        }
        console.log('>>>'+srk+'/'+memberId+'/'+groupNumber+'/'+fName+'/'+lName+'/'+tempBirthDate+'/'+birthDateOG);
        var action = component.get("c.launchConsumerDashboard");
        action.setParams({
            memberId : memberId,
            fName : fName,
            lName : lName,
            dtFormat : tempBirthDate,
            groupNumber : groupNumber,            
            surrogateKey: srk
        });
        action.setCallback(this, function(response) {
            //get the response state
            var state = response.getState();              
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                console.log('>>DashURL'+result);
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                	window.open(result, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
            } else if (state == "ERROR") {
                console.log('error');
            }
        });
        $A.enqueueAction(action);
	} 
})