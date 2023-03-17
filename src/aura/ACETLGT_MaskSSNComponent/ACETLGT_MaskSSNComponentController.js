({
	doInit : function(component, event, helper) {
		var maskSSN = component.get("v.SSNValue");
		component.set("v.editSSNValue",maskSSN);        
        console.log('In do init'+maskSSN+'test');
        if(maskSSN && maskSSN!=""){
			helper.getmaskedSSN(component, helper, maskSSN);
        }
	},
    showUnMaskValue : function(component, event, helper) {
		var cmpTarget = component.find('unMaskValue');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        var cmpTarget = component.find('maskValue');
        $A.util.addClass(cmpTarget, 'slds-hide');
        
        var cmpTarget = component.find('unMaskSSNLink');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpTarget = component.find('maskSSNLink');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        helper.insertEventLog(component,event,helper);
        
	},
    showMaskValue : function(component, event, helper) {
		var cmpTarget = component.find('maskValue');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        var cmpTarget = component.find('unMaskValue');
        $A.util.addClass(cmpTarget, 'slds-hide');
        
        var cmpTarget = component.find('unMaskSSNLink');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        var cmpTarget = component.find('maskSSNLink');
        $A.util.addClass(cmpTarget, 'slds-hide');
        
	},
    copyToClipboard : function(component, event, helper) {
		//var textForCopy = component.find('unMaskValue').getElement().innerHTML;
        var textForCopy= component.get("v.SSNValue"); 
        
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", textForCopy);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        
        var href = event.srcElement.href;
       	console.log(href);
        var html = event.srcElement.innerHTML;
        event.srcElement.innerHTML = 'Copied';
        event.srcElement.setAttribute("style", "font-weight:700;");
       	console.log(html);
        
        helper.insertEventLog(component,event,helper);
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            event.srcElement.innerHTML = 'Copy';
        	event.srcElement.setAttribute("style", "font-weight:normal;");
       	
        },3000)
        
	},
    
    editssn : function(component, event, helper) {
        helper.insertEventLog(component,event,helper);
        component.set("v.editmode",true);
        component.set("v.ShowEdit",false);
    },
    
    cancel : function(component, event, helper) {
        component.set("v.editmode",false);
        component.set("v.ShowEdit",true);
		component.set("v.editSSNValue",component.get("v.SSNValue")); 
    },
    
    save: function(component, event, helper) {
        component.set("v.editmode",false);
        component.set("v.ShowEdit",true);
        component.set("v.UpdatedSSNValue",component.get("v.editSSNValue"));
        var maskSSN = component.get("v.UpdatedSSNValue");
        helper.getmaskedSSN(component, helper, maskSSN);
    },
    

})