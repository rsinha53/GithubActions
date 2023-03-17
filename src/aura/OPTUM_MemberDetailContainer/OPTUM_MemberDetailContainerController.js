({
    doInit: function (component, event, helper) {
		
		//DE432638 Autodoc selection stays in memory
		let today = new Date();
        let uniqueString = today.getTime();
        component.set('v.autodocUniqueId', uniqueString);
        component.set('v.autodocUniqueIdCmp', uniqueString);
		
        var perACCID = component.get("v.recordId");
		var action = component.get("c.getPlatformCacheResponse");
        action.setParams({
            "personAccID": perACCID
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if($A.util.isUndefinedOrNull(responseValue)){

                }else{
                    for(var key in responseValue){

                        if(key == 'MEMBERDETAILS'){
                            component.set("v.memberDetails", responseValue['MEMBERDETAILS']);
                        }else if(key == 'INTERACTION'){
                            component.set("v.optumInt", responseValue['INTERACTION']);
        component.set("v.SubjectId", component.get("v.optumInt.Originator__c"));     
                        }else if(key == 'ACCOUNT'){
                            component.set("v.optumEID", JSON.stringify(responseValue['ACCOUNT'].EID__c));
                        }

                    }
	   //Added by Dimpy US2904971: Create New Case
        helper.fetchInteraction(component, event, helper);
		helper.getUserInfo(component, event, helper);
       //Added by Iresh DE411196: To fix the space between Middle name and Last name
		helper.getMiddleName(component, event, helper);
	var originators = [
            
            { value:  (component.get("v.memberDetails.member.firstName"))+' '+(component.get("v.middleName"))+(component.get("v.memberDetails.member.lastName")), label: (component.get("v.memberDetails.member.firstName"))+' '+(component.get("v.middleName"))+(component.get("v.memberDetails.member.lastName")) },
            { value: $A.get("$Label.c.ACETThirdParty"), label: $A.get("$Label.c.ACETThirdParty") },
         ];
      component.set("v.FamilyMembersList", originators);
     var orgtr =(component.get("v.memberDetails.member.firstName"))+' '+(component.get("v.middleName"))+(component.get("v.memberDetails.member.lastName"));
        component.set("v.OriginatorId", orgtr);
                }
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
            }



        });
        $A.enqueueAction(action);

         },
	
   openNewTab: function(component, event, helper){
      helper.openTab(component , event ,helper);
    },         

    updateData: function (component, event, helper) {
        component.set("v.accountList", event.getParam("accountList"));
        component.set("v.rowIndex", event.getParam("index"));
        component.set("v.accountType", event.getParam("accountType"));
        helper.fireEvent(component, event, helper);

    },

    //Added by Dimpy US2904971: Create New Case
    handleShowOriginatorError: function (component, event, helper) {
        var showOriginatorError = $A.get("e.c:OPTUM_ShowOriginatorErrorMsgEvt");
        showOriginatorError.fire();
    },

    //Added by Dimpy US2904971: Create New Case
    handleOriginatorValue: function (component, event, helper) {
        component.set("v.OriginatorId", event.getParam("valueSelected"));

    },
    
    //Added by Dimpy US2881441: Apply sort on HSA Account
    FireEvent: function (component, event, helper){
        var appEvent = $A.get("e.c:OPTUM_SelectedTransactionEvent");
                    appEvent.setParams({
                    "transactions": event.getParam("transactions"),
                   
                });
                appEvent.fire();
    },
	//Added by prasad: US2967182 Originator screen
     handleShowOriginatorErrstop: function(component,event,helper){
        component.set("v.showOriginatorErrorFired",true);
    },
   onOriginatorChange: function(cmp,event,helper){
        var originatorval = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
        if((cmp.get("v.SubjectId") != undefined || originatorval != undefined) || !$A.util.isEmpty(originatorval)){
        cmp.set("v.originatorval",originatorval); 
        cmp.get("v.optumInt.Originator_Name__c")
        var name =  (cmp.get("v.memberDetails.member.firstName"))+' '+(cmp.get("v.middleName"))+(cmp.get("v.memberDetails.member.lastName"));
       
        if(name == originatorval){
        originatorval =cmp.get("v.SubjectId");
        }
        
        var tpRel = cmp.get("v.tpRelation");
         var action = cmp.get("c.updateIntOriginator");
            action.setParams({
                originatorId : originatorval,
        subjectID : cmp.get("v.SubjectId"),
        tpRel  : tpRel
               
            });
            
            action.setCallback(this, function(response) {
             var state = response.getState();
             if (state == "SUCCESS") {
             var storeResponse = response.getReturnValue();
             console.log("higlight response" + storeResponse);
             cmp.set("v.highLightPanel",storeResponse);
        }});
        $A.enqueueAction(action);
        
        
        
        
        }
    }, 
          handleCaseEvent : function(cmp, event) {
        var isModal = event.getParam("isModalOpen");
        console.log("===>>>==3==>>>---"+ isModal);
        cmp.set("v.isModalOpen", isModal);
    }, 
    onClickOfEnter : function(component,event, helper) {
        if (event.which == 13){
            console.log('hits :: '+component.find('GlobalAutocomplete').get("v.listOfSearchRecords"));
            if (component.find('GlobalAutocomplete').get("v.listOfSearchRecords") == null){
                var a = component.get('c.showDetails');
                $A.enqueueAction(a);
            }
        }
    },
     
  handleClaimEvent : function(component, event, helper) {
        console.log("in originator" + event.getParam("data"));
         var appEvent = $A.get("e.c:OPTUM_SelectedClaimRowEventChild");        
        appEvent.setParams({"data" : event.getParam("data") });
        
        appEvent.fire();
    },
	 //Added by Prasad	US3029205: Create Originator - Third party popup
   handleTPEvent : function(cmp, event) {
        var lblThirdParty = $A.get("$Label.c.ACETThirdParty");
        var isModal = event.getParam("isTPModalOpen");
        var orgi = event.getParam("originator");
        var tpRel = event.getParam("tpRelation");
        cmp.set("v.tpRelation",tpRel);
        cmp.set("v.isTPModalOpen", isModal);
        var isOrgiNotPresent = true;
        var famlist = cmp.get("v.FamilyMembersList");
        if(orgi != undefined && orgi != null && orgi != ''){
            if(famlist != undefined && famlist != null && famlist != '')
                famlist.splice(famlist.length - 1, 1);
            if(famlist != undefined){
                famlist.forEach(function(element) {
                    if(element.value == orgi  )
                        isOrgiNotPresent = false;
                });
                if(isOrgiNotPresent){
                    famlist.push( { value: orgi , label: orgi} );
                }
            }
            if (famlist.filter(function(e) { return e.value === lblThirdParty; }).length <= 0) {
                famlist.push( { value: lblThirdParty , label: lblThirdParty} );	
            }
            cmp.set("v.FamilyMembersList", famlist);
            cmp.set("v.originator", orgi);
            
           if (orgi != lblThirdParty && cmp.get("v.OriginatorId")!=null && !cmp.get("v.OriginatorId").startsWith('003') ){     
                cmp.set("v.OriginatorId", orgi);
                cmp.set("v.tpRelation",null);
            } 
            //Observation : 
            if (orgi == lblThirdParty) {
                cmp.set("v.OriginatorId", null);  
               cmp.set("v.originator", null); 
              cmp.set("v.tpRelation",null);
            } 
        }else{
            cmp.set("v.OriginatorId", null);  
            cmp.set("v.originator", null); 
           cmp.set("v.tpRelation",null);
        }
    },
	//Added by Dimpy for case comments
	handleCaseComments: function(cmp, event, helper){
        var caseComment = event.getParam("caseComment");   
        cmp.set("v.comments",caseComment); },
		
	//Added by Dimpy for freeze issue	
    onTabFocused : function(component, event, helper) {
        component.set("v.accountList","");
		component.set("v.accountList", component.get("v.accountListTemp"));
	}
      
})