({
    onInit : function(component, event, helper) {
        var firstName = "Jospeh"
        var lastName = "Doe";
        var gender = "Male";
        var preferredName = "Joe";
        var memberId = "xxx-xx-1234";
        var policy = "123456";
        var planYear = "03/15/2019 to 04/25/2019";
        
        //component.set("v.firstName", firstName);
        //component.set("v.lastName", lastName);
        //component.set("v.gender", gender);
        //component.set("v.preferredName", preferredName);
        //component.set("v.memberId", memberId);
        //component.set("v.policy", policy);
        //component.set("v.planYear", planYear);
        
    },
    
    handleMouseOver : function(component, event, helper){
        component.set("v.togglehover",true);
    },
    
    handleMouseOut : function(component, event, helper){
       component.set("v.togglehover",false);
    }
    
})