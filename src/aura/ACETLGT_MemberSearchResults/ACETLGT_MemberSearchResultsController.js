({
   doInit: function(component, event, helper) {
      /*// this function call on the component load first time     
      // get the page Number if it's not define, take 1 as default
      var page = component.get("v.page") || 1;*/
      var Type = component.get("v.InteractionType"); 
 	  console.log('Type'+Type);
       
       window.localStorage.setItem('uProfile', 'showSave');
       
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var usrInfo = response.getReturnValue();
                if(usrInfo.Agent_Type__c == 'Offshore')
	                component.set("v.isOnshore",false);//isOnshore = 'false';
                else
                    component.set("v.isOnshore",true);//isOnshore = 'true';
               
            }
        });
        $A.enqueueAction(action);
    
   },
   /* 
   navigate: function(component, event, helper) {
      // this function call on click on the previous page button  
      var page = component.get("v.page") || 1;
      // get the previous button label  
      var direction = event.getSource().get("v.label");
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      
   },
   
   onSelectChange: function(component, event, helper) {
      var page = 1;
   },
   */ 
    hideNotes: function(component, event, helper) {
       
       var element = document.getElementsByClassName("sfdc-share-button");
       alert('---element--->'+element);
  	   if(element != undefined)
       element.setAttribute("style", "display: none;");
       
    },
 	navMemberDetail : function(component, event, helper) {
	  var isOnshore= component.get("v.isOnshore");
        console.log('~~~~isOnshore'+isOnshore);
        
        console.log('user info ::: '+component.get("v.usInfo").Profile_Name__c);
      //US1935707 : Research user  
      var userInfo = component.get("v.usInfo");
      var intId; 
      var cov;
      var grpnum;
      var guid = event.currentTarget.getAttribute("data-guid");
      var Name = event.currentTarget.getAttribute("data-fullName");
      var lastName = event.currentTarget.getAttribute("data-lastName");
      var firstName = event.currentTarget.getAttribute("data-firstName");
      var fullssn = event.currentTarget.getAttribute("data-fullssn");
      var Id =  event.currentTarget.getAttribute("data-memberId");
      var scr = event.currentTarget.getAttribute("data-scrId");
      var addr = event.currentTarget.getAttribute("data-addr");
      var gen =  event.currentTarget.getAttribute("data-gen");
      var sc = event.currentTarget.getAttribute("data-sc");
      var srk = event.currentTarget.getAttribute("data-srk");
      var srkKeyChain = event.currentTarget.getAttribute("data-srkkeychain");
      var subjectdob =  event.currentTarget.getAttribute("data-dob");
      var coverage = component.get("v.dataList");
      var IsMember =  true;
      var individualIdentifier = event.currentTarget.getAttribute("data-EID");
      var intType = event.currentTarget.getAttribute("data-intType");
      var affiliationIndicator = event.currentTarget.getAttribute("data-affiliationIndicator");
	  var vccdparams = component.get("v.vccdParams");
        var bookOfBusinessTypeCode = '';
        var specialtyBenefits=[],specBenefits = [];
      console.log('=======> keychain'+srkKeyChain+'========srk'+srk); 
      //alert("-------co--->"+coverage.length);
      console.log("-------guid--->"+guid);
        
        for(var i=0;i<coverage.length;i++){
            if(coverage[i].firstName == firstName && coverage[i].Id == Id && coverage[i].lastName == lastName && coverage[i].dob == subjectdob ){
                cov = coverage[i].CoverageLines;
                specBenefits = coverage[i].specialtyBenefits;
            } 
        }
        console.log('xxxxxx'+JSON.stringify(specBenefits));
      for(var i=0;i<cov.length;i++){
          if(cov[i].isPreferred == true){
              grpnum = cov[i].GroupNumber;
              bookOfBusinessTypeCode = cov[i].bookOfBusinessTypeCode;
          }
      }
      var action = component.get("c.createInteraction");
      action.setParams({
         "interactionType": intType,
         "userProfile": component.get("v.usInfo").Profile_Name__c
      });
      
      action.setCallback(this, function(a) {
         var result = a.getReturnValue();
         //alert(result.Id);
         helper.navigate(component,event,helper,result.Id,Name,lastName,firstName,addr,sc,gen,fullssn,Id,scr,srk,srkKeyChain,subjectdob,IsMember,individualIdentifier,result,intType,cov,result.Originator_Type__c,isOnshore,grpnum,userInfo,affiliationIndicator,vccdparams,bookOfBusinessTypeCode,JSON.stringify(specBenefits));
    
      });
      $A.enqueueAction(action);
   }
     
})