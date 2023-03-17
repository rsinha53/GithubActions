({
    doInit : function(component, event, helper) {
        
        var encodedId = component.get("v.memberId");
        var decodedMemberId = "";
        if(encodedId != undefined) {
            var decodedId = helper.decodeMemberId(helper, encodedId);
            console.log('decoded ID::', decodedId);
            if(decodedId !="" && decodedId != null){
                decodedMemberId = decodedId.substring(2, 11);
            }
            component.set("v.decodedMemberId", decodedMemberId); 
            helper.callFIMService(component);
        }
        
        if('M' == component.get("v.memberGender")) {
            component.set("v.memberGender", 'Male');
        } else {
            component.set("v.memberGender", 'Female');
        }
        
        //	US2225119 - hide subject if subject = caller
        if(component.get("v.memberDateofBirth") == component.get("v.callerDateofBirth")) {
            component.set("v.sameCallerSubject", true);
        }else{
            component.set("v.sameCallerSubject", false);
        }
       
        //set memberDateofBirth as selectedmemberDOB when loading.. and it will change when a member is selcted in eligibility subtab
        component.set('v.selectedMemberDOB',component.get('v.memberDateofBirth'));
        console.log('selectedMemberDOB from dashboard parent : ', component.get('v.selectedMemberDOB'));
        var age = helper.calculateAge(component,event,helper,component.get('v.memberDateofBirth'));
        console.log('selected member age'+age);
        if(age>=13){
            component.set('v.memberAgeAboveThirteen',true);
        }else{
            component.set('v.memberAgeAboveThirteen',false);
        }
        helper.callAlertsApi(component, event, helper);
		var memDob = component.get("v.memberDateofBirth");
        helper.getPopupDetails(component, event, helper,memDob);											
    },
    handleComponentEvent : function(component, event, helper){
        var rxDetails = event.getParam("rxDetails");
        component.set("v.rxDetails", rxDetails);
    },
    
    handleRefresh : function(component,event,helper){
        var memfn = event.getParam("memFirstName");
        var memln = event.getParam("memLastName");
        var memdob = event.getParam("memDob");
        var cardVisibility = event.getParam("cardVisibility");
        var memberRelation = event.getParam("memberRelation");
        console.log('memberRelation of selected member'+memberRelation);
        if(memdob !=  null && memdob.includes('-')){
            var memdobSplt = memdob.split('-');
            var memdobFrmtd = memdobSplt[1]+ '/' +memdobSplt[2]+ '/' +memdobSplt[0];
        }
        component.set('v.memberFirstName',memfn);
        component.set('v.memberLastName',memln);

        component.set('v.selectedMemberDOB',memdobFrmtd);
        console.log('refresh details: member first name-'+memfn+'::memebr lst name-'+memln+'::member dob-'+memdobFrmtd);
        
        console.log('calling caller profile init');
        var callerProfileCard = component.find('callerProfileCard');
        //callerProfileCard.memberRefresh();
        
        var age = helper.calculateAge(component,event,helper,memdobFrmtd);
        console.log('selected member age'+age);
        if(age>=13){
            component.set('v.memberAgeAboveThirteen',true);
        }else{
            component.set('v.memberAgeAboveThirteen',false);
        }
                
        //	US2225119 - hide subject if subject = caller
        //	resuing the same code here to hide/show the Subject card
        if(component.get("v.selectedMemberDOB") == component.get("v.callerDateofBirth")) {
            component.set("v.sameCallerSubject", true);
        }else{
            component.set("v.sameCallerSubject", false);
        }
        if(memberRelation == 'Subscriber'){
            component.set('v.selectedMemberSubscriber',true);
        }else{
            component.set('v.selectedMemberSubscriber',false);
        }
        
        component.set('v.isEligProfShow',cardVisibility);
        
        // Reset EPMP Flag values
        component.set('v.prefMsg',"");
        component.set('v.prefFlag',""); 
        component.set('v.emailMsg',"");
        component.set('v.emailFlag',""); 
        component.set('v.phoneMsg',"");
        component.set('v.phoneFlag',"");
        component.set("v.isMemberPrefFlagsExist", "");
		var memDob = component.get("v.selectedMemberDOB");
        helper.getPopupDetails(component, event, helper,memDob);														
        helper.callAlertsApi(component, event, helper);
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    // Show Eligibility Card
    showCard : function(component, event, helper) {
        component.set("v.isEligProfShow","false");
    },
    
    // Hide Eligibility Card
    hideCard : function(component, event, helper) {
        component.set("v.isEligProfShow","true");
    },
    
    //Get Hover section for Master Flag in Eligibility Profile
    handleMouseOverMasterFlag: function(component, event, helper){
        component.set("v.togglehoverMasterFlag",true);
    },
    
    //Remove Hover section for Master Flag in Eligibility Profile
    handleMouseOutMasterFlag : function(component, event, helper){
        component.set("v.togglehoverMasterFlag",false);
    },
    
    /*setMemEliData  : function(cmp, event) {  
        var rxDetails = event.getParam("rxDetails"); 
        var selectedMemberAge = event.getParam("selectedMemberAge"); 
        var displayPops = event.getParam("displayPops"); 
        var transactionId = event.getParam("transactionId"); 
        var employerName = event.getParam("employerName");
        cmp.set("v.rxDetails", rxDetails); 
        cmp.set("v.selectedMemberAge", selectedMemberAge); 
        cmp.set("v.displayPops", displayPops); 
        cmp.set("v.transactionId", transactionId);    
        cmp.set("v.employerName", employerName);												
    },*/
	
	getEmpName  : function(cmp, event) {   
        var employerName = event.getParam("employerName");  
        cmp.set("v.employerName", employerName);
    }
})