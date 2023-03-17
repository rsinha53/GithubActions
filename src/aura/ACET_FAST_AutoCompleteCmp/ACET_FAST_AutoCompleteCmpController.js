({
    searchField: function(component, event, helper) {
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        console.log('currentText--> '+currentText);
        console.log('resultBox--> '+resultBox);
        component.set("v.LoadingText", true);
        if(currentText.length > 0) {
            var sList = component.get("v.searchList");
            console.log("sList==>"+JSON.stringify(sList));
            var finalList = [];
            for (const element of sList) {
                var sChar = new RegExp(currentText, 'i');
                var result = element.sValue.match(sChar);
                if(result){
                    finalList.push(element);
                }  
            }
            component.set("v.displayList",finalList);
            $A.util.addClass(resultBox, 'slds-is-open');
            console.log('inside if-->');
        }
        else {
            $A.util.removeClass(resultBox, 'slds-is-open');
            console.log('inside else-->');
        }
        component.set("v.LoadingText", false);
    },
    setSelectedValue: function(component, event, helper){
        console.log("inside setselectedvalye");
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
       	console.log("currentText==>"+currentText);
        component.set("v.selectedTextValue", currentText);
        component.find("userinput").set("v.readonly", true);
    },
    resetData: function(component, event, helper){
        component.set("v.selectedTextValue", "");
        component.find("userinput").set("v.readonly", false);
    },
    handleChangeSelVal: function(component, event, helper){
      var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');  
    },
})