({
    init: function(cmp, event, helper) {

    },

    runIndMemService: function(component, event, helper) {

        helper.showResults(component, event, helper);
    },
    
	openMemberStatus : function(component, event, helper){
       
      var groupNumber = component.get("v.Memberdetail.PreferredCoverageInfo.GroupNumber");
      var memberId = component.get("v.Memberdetail.MemberId");
      console.log('~~~ openMemberStatus popup open'+groupNumber+'//'+memberId);
      
        $A.createComponent("c:ACETLGT_MemberStatusPend", 
                           {
                               groupNumber:groupNumber,
                               memberId:memberId
                           },
           function(content, status) {
               if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(content);
                    component.set("v.body", body);
               }
           }); 
        
	}
})