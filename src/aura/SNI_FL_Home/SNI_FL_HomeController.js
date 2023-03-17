({
    doInit : function(component, event, helper) {

		var myPageRef = window.location.pathname;
        //component.set("v.displayedSection","");
        console.log('v.displayedSection='+component.get("v.displayedSection"));
        console.log('myPageRef11='+myPageRef);
        if(myPageRef && myPageRef.includes('settings')){
           console.log('myPageRef='+myPageRef);
           component.set("v.displayedSection","settingSec");
           
        }
        
        /*AC/DC Added by Pavithra */
       var userIdValue = $A.get("$SObjectType.CurrentUser.Id");
       component.set('v.userIdValue', userIdValue);
       var action = component.get('c.markNewMessageIcon');
       action.setParams({
           "userIdValue": userIdValue
           })
       action.setCallback(this, function(response) {
           var state = response.getState();           
           if (state == "SUCCESS") {
               component.set('v.isNewMessageAvailable', response.getReturnValue());
           }
       });
        /*
         // HSID Members/policy holders Reset password page 
        // 
        var action2 = component.get('c.HSIDmemUrls');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS" && response.getReturnValue()) {
                console.log('>>>>>>is member or not<<<<<<<'+response.getReturnValue());
                component.set('v.displayedSection1', response.getReturnValue());
               
            }
            
        });        
        $A.enqueueAction(action2); */
       $A.enqueueAction(action);

	},
    getMobileNavUI : function(component, event, helper) {

        var mobileNavigationUI = document.getElementsByClassName("navigation");
        if (mobileNavigationUI[0].classList.contains("mobile-show")) {
            mobileNavigationUI[0].classList.add("mobile-hide");
            mobileNavigationUI[0].classList.remove("mobile-show");
			if(screen.width < 500){
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                     divElmnt[0].classList.remove("mobile_scroll");
                    }
                }
        }
        else{
            mobileNavigationUI[0].classList.add("mobile-show");
            mobileNavigationUI[0].classList.remove("mobile-hide");
			if(screen.width < 500){
                var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                if(divElmnt.length >0){
                    divElmnt[0].classList.add("mobile_scroll");
                }
            }
        }
    },
	 displayCareTeam : function(component,event,helper){
        
        if(screen.width < 500){
             /* added by ravi -- for sroll*/
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                     divElmnt[0].classList.remove("mobile_scroll");
                    }
            /* added by ravi -- for sroll*/
            /*var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }*/
            var SupportId = document.getElementById("Careteam");
            /*SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");*/
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        /*else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var SupportId = document.getElementById("CareteamDT");
            SupportId.parentNode.classList.add("activeTab");
       } */
        console.log('care Team completed--');
        component.set("v.displayedSection","careTeamSec");
        
    },
	 displayCareTeam : function(component,event,helper){
        
        if(screen.width < 500){
             /* added by ravi -- for sroll*/
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                     divElmnt[0].classList.remove("mobile_scroll");
                    }
            /* added by ravi -- for sroll*/
            var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }
            var SupportId = document.getElementById("Careteam");
            SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
         else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var SupportId = document.getElementById("CareteamDT");
            SupportId.parentNode.classList.add("activeTab");
       }
        
        component.set("v.displayedSection","careTeamSec");
        
    },
    displaySupport : function(component,event,helper){
        console.log('displaySupport-------');
        if(screen.width < 500){
			/* added by ravi -- for sroll*/
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                     divElmnt[0].classList.remove("mobile_scroll");
                    }
            /* added by ravi -- for sroll*/
            var tabGreyUI = document.getElementsByClassName("navigation-ul");
            /*for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }*/
            var SupportId = document.getElementById("Support");
            /*SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");*/
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
		/* else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var SupportId = document.getElementById("SupportDT");
            SupportId.parentNode.classList.add("activeTab");
       }*/
        component.set("v.displayedSection","supportSec");
    },
    displayDashboard : function(component,event,helper){
        console.log('displayDashboard-------');
        if(screen.width < 500){
			/* added by ravi -- for sroll*/
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                      divElmnt[0].classList.remove("mobile_scroll");
                    }
            /* added by ravi -- for sroll*/
            /*var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }*/
            var dashboardId = document.getElementById("Dashboard");
            /*dashboardId.parentNode.classList.remove("inactive");
            dashboardId.parentNode.classList.add("active");*/
            console.log(dashboardId.parentNode.parentNode.parentNode.parentNode);
            if (dashboardId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                dashboardId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                dashboardId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
		/*else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var DashboardDTId = document.getElementById("DashboardDT");
            DashboardDTId.parentNode.classList.add("activeTab");
        }
		*/
		component.set("v.fetchDashBoard",true);
        component.set("v.refreshDashBoard",true);
        component.set("v.displayedSection","dashboardSec");
    },
    displayRecords : function(component,event,helper){
		component.set("v.refreshDashBoard",false);
        console.log('displayRecords-------');
        console.log(screen.width);
        if(screen.width < 500){
            /* added by ravi -- for sroll*/
                  var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                    if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                     divElmnt[0].classList.remove("mobile_scroll");
                    }
            /* added by ravi -- for sroll*/
            /*var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }*/
            var recordsId = document.getElementById("Records");
            /*SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);*/
            if (recordsId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                recordsId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                recordsId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        /* else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var SupportId = document.getElementById("SupportDT");
            SupportId.parentNode.classList.add("activeTab");
       } */
       component.set("v.displayedSection","recordsSec");
    },
    displayCases : function(component,event,helper){


        if(screen.width < 500){
            /* added by ravi -- for sroll*/
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
            /* added by ravi -- for sroll*/
            var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }
            var SupportId = document.getElementById("Tasks");
            SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
            for(var a = 0; a<chngTabColor.length; a++){
                if (chngTabColor[a].classList.contains("activeTab")) {
                    chngTabColor[a].classList.remove("activeTab");
                }
            }
            var SupportId = document.getElementById("CasesDT");
            SupportId.parentNode.classList.add("activeTab");
        }
        component.set("v.displayedSection","casesSec");

         /* Added by ACDC - If remove any code please inform ACDC team */
        var selectedFamilyId = component.get('v.selectFamilyId');
        var userIdValue = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userIdValue);
        var action = component.get('c.deleteReadCases');
        action.setParams({
            "userIdValue": userIdValue,
            "familyId":selectedFamilyId
            })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set('v.isNewCaseAvailable', false);
            }else{
                console.log('deleteReadCases error');
            }
        });
        $A.enqueueAction(action);

    },
    
    /*Start
    Added by Sameera AC/DC**/
    displayMessage : function(component,event,helper){
        component.set("v.isChatView", false);
        console.log('displayMessage-------');
        console.log(screen.width);
        if(screen.width < 500){
            /*var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }*/
            var SupportId = document.getElementById("Messages");
            /*SupportId.parentNode.classList.remove("inactive");
            SupportId.parentNode.classList.add("active");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);*/
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
       /* else{
            var chngTabColor = document.getElementsByClassName("changeTabBgColor");
             for(var a = 0; a<chngTabColor.length; a++){
                 if (chngTabColor[a].classList.contains("activeTab")) {
                          chngTabColor[a].classList.remove("activeTab");
                       }
            }
            var SupportId = document.getElementById("SupportDT");
            SupportId.parentNode.classList.add("activeTab");
       }*/
       component.set("v.displayedSection","messagesSec");
       
       /*AC/DC Added by Pavithra */
       var userIdValue = $A.get("$SObjectType.CurrentUser.Id");
       component.set('v.userIdValue', userIdValue);
       var action = component.get('c.deleteReadMessages');
       action.setParams({
           "userIdValue": userIdValue
           })
       action.setCallback(this, function(response) {
           var state = response.getState();           
           if (state == "SUCCESS") {               
               component.set('v.isNewMessageAvailable', false);
           }else{
               
           }
       });
       $A.enqueueAction(action);
        
    },
    displayMarketPlace : function(component,event,helper){
        var marketplaceLink="/myfamilylink/s/marketplace";
        window.open(
              marketplaceLink, "_blank");
    },
    BtnHandleClick:function (component, event, helper) {
        /* var evnt = $A.get("e.force:navigateToComponent");
        console.log('outsidebutton'+evnt);
        evnt.setParams({
            componentDef  : "c:FamilyLink_Messages"
   		 });
        evnt.fire();
        console.log('afterbutton');*/
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        console.log('@',+pageReference);
        event.preventDefault();
        navService.navigate(pageReference);
        console.log(navService.navigate(pageReference));
    },
    setCurrentFamily : function(component, event) {
        var selectFamId = event.getParam("familyAccId");
        var selectFamOwner = event.getParam("familyAccountOwner");
        component.set("v.selectFamilyId", selectFamId);
        component.set("v.familyAccountOwner",selectFamOwner);
        //Added by ACDC Team
        var selectedFamilyId = component.get('v.selectFamilyId'); 
        var userIdValue = component.get('v.userIdValue');
        var caseAction = component.get('c.markNewCaseNotification');        
        caseAction.setParams({
            "userIdValue": userIdValue,
            "familyId":selectedFamilyId
            });
            caseAction.setCallback(this, function(response) {
            var state = response.getState();           
            if (state == "SUCCESS") {
                component.set('v.isNewCaseAvailable', response.getReturnValue());
            }
        });
        $A.enqueueAction(caseAction);
    },
    handleMessageEvent : function(component, event, helper){
        let startMessage = event.getParam('startMessage');
        if(startMessage == true){
            let displayMessage = component.get('c.displayMessage');
            $A.enqueueAction(displayMessage);
        }
    }
})