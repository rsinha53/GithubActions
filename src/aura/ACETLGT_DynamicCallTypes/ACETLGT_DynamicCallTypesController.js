({
    
    doInit : function(component, event, helper) {
        var topicName = component.get("v.attrCallTopic");
    },
    
    callChildMethod: function (component, event, helper) {
        
        var topicName = component.get("v.attrCallTopic");
        helper.loadSwivelData(component, event,topicName);
    },
    onChange: function (cmp, evt, helper) {
        //Get and Set Dropdown Value
        var selKey = cmp.get("v.AutodocKey")+"select";
        var dropDownSelectedVal = document.getElementById(selKey).value;
        var dropDownCmp =  document.getElementById(selKey).value;
        
        cmp.set("v.isDropDownHasValue",dropDownSelectedVal);
        if(! $A.util.isEmpty(dropDownSelectedVal)){
        var cmpEvent = cmp.getEvent("DynamicCallTypesSupportEvt");
        cmpEvent.setParams({
            "dropDownSelectedVal" : dropDownSelectedVal});
        cmpEvent.fire();
        }
        //Get and Set Comments
        var commentsVal = cmp.get('v.isCommentsHasValue');
    },
    
    onDropDownBlur : function(component, event, helper) {

        var id = component.get('v.AutodocKey')+'select';
        
        if(document.getElementById(id) != null && document.getElementById(id).value == 'None' && (document.getElementById(id).value == undefined)){
            component.set("v.isSetDropDownError",true);
        }else{
            component.set("v.isSetDropDownError",false);
        }
        
    },

    
    handleDropDownChange : function(component, event, helper) {
        
        var id = component.get('v.AutodocKey')+'select';
        
        var dropDownVal = component.get("v.isSetDropDownError");
        if(dropDownVal){
            
            document.getElementById(id).classList.add("slds-has-error")
        }else{
            document.getElementById(id).classList.remove("slds-has-error");
        }
    },



    selectAllCallTypeCheckBox : function(component, event, helper) {

        var capturedCheckboxName = event.currentTarget.getAttribute("data-rolval");
        var capturedCheckboxClassValue = event.target.getAttribute("class");
        if(capturedCheckboxClassValue === 'autodoc'){
		var callTypes = component.get("v.callTypes");
        var val = event.currentTarget.getAttribute("aria-checked"); 
        
        switch(val) {
            case "true":
                var tempArr = [];
                component.set("v.valList",tempArr);
                component.set('v.isCallChecked', "false");
                break;
                
            case "false":
                var tempArr = [];
                callTypes.forEach(function (ct) {
                    tempArr.push(ct.Call_Type__c);
                });

                component.set("v.valList",tempArr);
                component.set('v.isCallChecked', "true");
                break;
        }
        }
        
    },

    selectCallTypeCheckBox : function(component, event, helper) {

        var capturedCheckboxName = event.currentTarget.getAttribute("data-rolval");
        var capturedCheckboxClassValue = event.target.getAttribute("class");
        if(capturedCheckboxClassValue === 'autodoc'){
        var tempArr = component.get("v.valList");
        
        if(tempArr.includes(capturedCheckboxName)==true){
            var index = tempArr.indexOf(capturedCheckboxName);
            tempArr.splice(index, 1)
        }else{
            tempArr.push(capturedCheckboxName);
        }
        
        component.set("v.valList",tempArr);
        }                
    },
    
    
    selectAllAccTypeCheckBox: function(component, event, helper) {

        var capturedCheckboxName = event.currentTarget.getAttribute("data-rolval");
        var capturedCheckboxClassValue = event.target.getAttribute("class");
        if(capturedCheckboxClassValue === 'autodoc'){
		var accTypes = component.get("v.accList");
        var val = event.currentTarget.getAttribute("aria-checked");
        
        switch(val) {
            case "true":
                var tempArr = [];
                component.set("v.accTypeList",tempArr);
                component.set('v.isAccChecked', "false");
                break;
                
            case "false":
                var tempArr = [];
                accTypes.forEach(function (ct) {
                    tempArr.push(ct);
                });

                component.set("v.accTypeList",tempArr);
                component.set('v.isAccChecked', "true");
                break;
        }

        }
        
    },
    
    
    
    ChangeAccCheckBox: function(component, event, helper) {
        var capturedCheckboxName = event.currentTarget.getAttribute("data-rolval");
        var capturedCheckboxClassValue = event.target.getAttribute("class");
        
        if(capturedCheckboxClassValue === 'autodoc'){
        var tempArr = component.get("v.accTypeList");
        
        if(tempArr.includes(capturedCheckboxName)==true){
            var index = tempArr.indexOf(capturedCheckboxName);
            tempArr.splice(index, 1)
        }else{
            tempArr.push(capturedCheckboxName);
        }
        
        component.set("v.accTypeList",tempArr);
        } 
    },
    
})