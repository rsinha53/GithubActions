({
    doInit : function(component, event, helper) {
        var myPageRef = window.location.pathname;
        
        //console.log('v.displayedSection='+component.get("v.displayedSection"));
        //console.log('myPageRef11='+myPageRef);
        if(myPageRef && myPageRef.includes('settings')){
            
            component.set("v.displayedSection","settingSec");
        }
        
        var action = component.get('c.getUserData');        
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            //console.log('data'+data.affliations);
            component.set("v.ProviderWrapper", data);
            if(data.affliations != '') {
                //alert(data.affliations[0].id)
                if(data.affliations.length > 1){
                    component.set('v.programname',data.affliations[0].id);
                    component.set('v.dropdown',true);
                } else { 
                    
                    component.set('v.dropdown',false);
                    component.set('v.programname',data.affliations[0].id);
                }
                var evt = $A.get("e.c:Result");
                evt.setParams({ "Pass_Result": data.affliations[0].id});
                evt.fire() ;               
            }
            
        });
        
        $A.enqueueAction(action);
        
        var ShowResultValue = event.getParam("Pass_Result"); 
        var program = component.get('v.programname');
        console.log("***program*** " + ShowResultValue);
         /* Added by ACDC - If remove any code please inform ACDC team */
         var userIdValue = $A.get("$SObjectType.CurrentUser.Id");
         component.set('v.userIdValue', userIdValue);
         var action = component.get('c.markNewMessageIcon');
         action.setParams({
             "userIdValue": userIdValue
         })
         action.setCallback(this, function(response) {
             var state = response.getState();           
             if (state == "SUCCESS") {
                 
                 console.log('ttes',response.getReturnValue()) 
                 component.set('v.isNewMessageAvailable', response.getReturnValue());
             }
         });
         $A.enqueueAction(action);
    },
    
    
    onProgramChange : function(component,event,helper){
        var st = component.get('v.programname');
        var evt = $A.get("e.c:Result");
        evt.setParams({ "Pass_Result": st});
        evt.fire();
    },
    
    
    getMobileNavUI : function(component, event, helper) {
        var mobileNavigationUI = document.getElementsByClassName("navigation");
        if (mobileNavigationUI[0].classList.contains("mobile-show")) {
            mobileNavigationUI[0].classList.add("mobile-hide");
            mobileNavigationUI[0].classList.remove("mobile-show");
            if(screen.width < 576){
                var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                    divElmnt[0].classList.remove("mobile_scroll");
                }
            }
        }
        else{
            mobileNavigationUI[0].classList.add("mobile-show");
            mobileNavigationUI[0].classList.remove("mobile-hide");
            if(screen.width < 576){
                var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
                if(divElmnt.length >0){
                    divElmnt[0].classList.add("mobile_scroll");
                }
            }
        }
    },
    
    
    
    displayHome : function(component,event,helper){
        console.log('displayDashboard-------');
        if(screen.width < 576){
            
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
            
            var tabGreyUI = document.getElementsByClassName("navigation-ul");
            for(var a = 0; a<tabGreyUI[0].childNodes.length; a++){
                if (tabGreyUI[0].childNodes[a].classList.contains("active")) {
                    tabGreyUI[0].childNodes[a].classList.remove("active");
                    tabGreyUI[0].childNodes[a].classList.add("inactive");
                }
            }
            var dashboardId = document.getElementById("Dashboard");
            dashboardId.parentNode.classList.remove("inactive");
            dashboardId.parentNode.classList.add("active");
            console.log(dashboardId.parentNode.parentNode.parentNode.parentNode);
            if (dashboardId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                dashboardId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                dashboardId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.fetchHome",true);
        component.set("v.refreshHome",true);
        component.set("v.displayedSection","homeSec");
    },
    
    
    
    displayMemberTeam : function(component,event,helper){
        if(screen.width < 576){
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
            var SupportId = document.getElementById("members");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.displayedSection","memberSec");
        
    },
    
    displayMessage : function(component,event,helper){
        console.log('displayMessage-------');
        console.log(screen.width);
        if(screen.width < 576){
            var SupportId = document.getElementById("Messages");
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.displayedSection","messagesSec");
        
         /* Added by AC/DC */
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
    
    handleRedirectToMessages: function(component, event, helper){
        var a = component.get('c.displayMessage');
        $A.enqueueAction(a);
        var memName = event.getParam("memberName");
        var memId = event.getParam("memberId");
		component.set('v.memberNameToMessages', memName);
        component.set('v.memberIdToMessages', memId);
    },
    
    /*displayCareTeamMobile : function(component,event,helper){
        if(screen.width < 576){
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
            var SupportId = document.getElementById("members");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.displayedSection","memberSec");
    },*/
    
    /* displayMessage : function(component,event,helper){
                component.set("v.isChatView", false);

      
        if(screen.width < 576){
            var SupportId = document.getElementById("Messages");
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.displayedSection","messagesSec");
        
    },*/
    
    
    /*  displaySupport : function(component,event,helper){
       
        if(screen.width < 576){
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
            var tabGreyUI = document.getElementsByClassName("navigation-ul");
            var SupportId = document.getElementById("Support");
            console.log(SupportId.parentNode.parentNode.parentNode.parentNode);
            if (SupportId.parentNode.parentNode.parentNode.parentNode.classList.contains("mobile-show")) {
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.add("mobile-hide");
                SupportId.parentNode.parentNode.parentNode.parentNode.classList.remove("mobile-show");
            }
        }
        component.set("v.displayedSection","supportSec");
    },*/
    
    
    
    
    /*  displayCasesMobile : function(component,event,helper){
        var a = component.get('c.getMobileNavUI');
        $A.enqueueAction(a);
        if(screen.width < 576){
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
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
    },*/
    
    /*  displayCases : function(component,event,helper){
      
        if(screen.width < 576){
            var divElmnt = document.getElementsByClassName("mobile-navigation-display-grid-2");
            if(divElmnt.length >0 && divElmnt[0].classList.contains("mobile_scroll")){
                divElmnt[0].classList.remove("mobile_scroll");
            }
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
    }*/
    
    
})