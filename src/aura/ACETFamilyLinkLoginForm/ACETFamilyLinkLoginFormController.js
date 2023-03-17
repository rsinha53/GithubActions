({
	doInit : function(component, event, helper) {
        if($A.get('$Browser').isIE11 || $A.get('$Browser').isIE10 || $A.get('$Browser').isIE9 || $A.get('$Browser').isIE8 || $A.get('$Browser').isIE7 || $A.get('$Browser').isIE6){
            component.set('v.isUnsupportedBrowser', true);
        } else {
            component.set('v.isUnsupportedBrowser', false);
        }
	},
    handleClick : function(component, event, helper){
       window.open('/myportal/','_self');
    
}
    
})