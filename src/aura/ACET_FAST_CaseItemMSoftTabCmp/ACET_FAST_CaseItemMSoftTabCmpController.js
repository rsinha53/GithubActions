({
    skipTabChanged: function(component, event, helper){
        var currentTab = component.get("v.singleTab");
        var msg = 'Tab Can be Edited Now';
        if(currentTab["skipTab"] == true){
            currentTab["isOpen"] = false;
            msg= 'Tab Skipped successfully';
        }
        helper.showToast(component, event, 'Success','success', msg);
        var tabs = component.get("v.tabList");
        var ind = component.get("v.currentRow");
        tabs[ind] = currentTab;
        component.set("v.tabList",tabs);
        component.set("v.singleTab",currentTab);
    },
    getSingleTab: function(component, event, helper){
        var tabs = component.get("v.tabList");
        var ind = component.get("v.currentRow");
        var currentTab = tabs[ind];
        var claimHeaderList = currentTab["claimHeader"];
        var fieldSets = helper.assignFieldsList(component.get("v.metaData"));
        var hList = [];
        for(var i=0; i<claimHeaderList.length; i++){
            hList.push(claimHeaderList[i]["excelField"]);
        }
        for(var p=0; p<fieldSets.length; p++){
            fieldSets[p]["displayList"] = hList;
        }
        component.set('v.fieldSets', fieldSets);
        component.set("v.singleTab",currentTab);
    },
    toggleTab : function(component, event, helper) {
		var tabs = component.get("v.tabList");
        var ind = component.get("v.currentRow");
        for(var i=0; i<tabs.length; i++){
            if(i==ind){
                tabs[i]["isOpen"]=true;
            }else{
                tabs[i]["isOpen"]=false;
            }
        }
        component.set("v.tabList",tabs);
	},
    completeTab : function(component, event, helper) {
        if(helper.validateFields(component) == true){
            helper.completeCurrTab(component, event, helper);
            helper.showToast(component, event, 'Success','success', 'Tab Completed');
        }else{
            var message = 'Please select atleast one field other than "Provider Comments" complete the tab';
            helper.showToast(component, event, 'Error','error', message);
        }
	},
    handleFieldChange: function(component, event, helper){
        const inputValue = event.getSource().get('v.value');
        helper.hFChange(component, event, helper, inputValue);
        if(inputValue==''){
            component.set("v.allfieldsFields", false);
        }
    },
})