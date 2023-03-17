({
	init: function (cmp, event, helper) {
       // console.log("===FamilyMembersList====>>"+ cmp.get(v.FamilyMembersList));
       // console.log('Inside originator Init'+cmp.get("v.originator"));
       // console.log("===FamilyMembersList====>>"+component.get("v.FamilyMembersList"));
       
      setTimeout(function(){ 
           var fastrrackflow = cmp.get("v.fastrrackflow");
           debugger;
           if(fastrrackflow=='yes')
           {
           var originatorId = cmp.get("v.orgid");
           cmp.find('selOrginator').set("v.value",originatorId);
           }
 }, 1000);
    },
    
    handleint: function(cmp,event,helper){
        console.log('memberdetailoriginator '+JSON.stringify(cmp.get("v.int")));
        if(cmp.get("v.int") && $A.util.isEmpty(cmp.find('selOrginator').get("v.value"))){
          cmp.find('selOrginator').set("v.value",cmp.get("v.int").Originator__c);
        }
    },
    handleOptionSelected: function(cmp,event,helper){
        var originatorId = cmp.get("v.originatorId");
      //  alert(originatorId);
        var originatorVal = cmp.get("v.originator");
        var originalVal = event.getParam("oldValue") ;
        cmp.set("v.originalOriginator", originatorId);
      //  alert('----originator Id----origval  ----- old val-- '+ originatorId +'---'+originatorVal+'---'+originalVal);
        if(originatorId == 'Third Party'){
            cmp.set("v.showTPpopUp", true);
        }
        else{
			if(!cmp.get('v.isMemberNotFound')){
				for(var index in cmp.get('v.FamilyMembersList')){
					var family = cmp.get('v.FamilyMembersList')[index];
					if(family.value == originatorId){
						cmp.set('v.originator',family.label);
					}
				}
			}
        }
        //Fire App Event to Select the button
        var appEvent = $A.get("e.c:ACETLGT_FocusTopicTextEvent");        
        appEvent.setParams({"valueSelected" : "true" });
        appEvent.fire();


        var cmpEvent = cmp.getEvent("getOriginatorEvent");
        cmpEvent.fire();

    },
    
    handleShowOriginatorError: function(component,event,helper){
        //alert("---ORI---");       
        document.getElementById("originatorlocationscroll").scrollIntoView(true);
        // show the error message of originator combobox
        var selOrginator = component.find("selOrginator");
        selOrginator.set('v.validity', {valid:false, badInput :true});
        selOrginator.showHelpMessageIfInvalid();
    }
   
    
})