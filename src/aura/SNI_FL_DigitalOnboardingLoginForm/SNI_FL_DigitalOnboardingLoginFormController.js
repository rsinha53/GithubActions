({
	doInit : function(component, event, helper) {
        
        if($A.get('$Browser').isIE11 || $A.get('$Browser').isIE10 || $A.get('$Browser').isIE9 || $A.get('$Browser').isIE8 || $A.get('$Browser').isIE7 || $A.get('$Browser').isIE6){
            component.set('v.isUnsupportedBrowser', true);
        } else {
            component.set('v.isUnsupportedBrowser', false);
            component.set('v.isLogin', true);
        }
	},
    onRegisternow : function(component, event, helper) {
        component.set('v.isLogin', false);
        component.set('v.isRegister', true);
    },
    backToLogin: function(component,event,helper){
        window.open('/myfamilylink/s/login','_self');
    },
    openPrivacyPolicy : function(component, event, helper) {
        var URL = $A.get("$Label.c.DigitalOnboarding_Privacy_Policy");
        var win = window.open(URL, "_blank");
    },
    openTerms : function(component, event, helper) {
        var URL = $A.get("$Label.c.DigitalOnboarding_Terms_Of_Use");
        var win = window.open(URL, "_blank");
    },
})