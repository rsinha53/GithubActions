({
    searchHelper : function(component,event,helper,searchKeyWord) {
        debugger;
       $A.util.removeClass(component.find("mySpinner"), "slds-show");
       var excludeitemsList= component.get("v.lstSelectedRecords");
        var excludeitemsListValues = [];
        if(excludeitemsList != null && excludeitemsList.length > 0) {
            for(var i =0; i<excludeitemsList.length; i++){
                excludeitemsListValues.push(excludeitemsList[i].label);
             }   
        }
        searchKeyWord = searchKeyWord.toLowerCase();
        console.log(searchKeyWord);
        var listOfOptions = component.get("v.listOfAllRecords");
        console.log(JSON.stringify(listOfOptions));
        var searchList = [];
        var searchList1 = [];
        //alert(listOfOptions.length);
         for(var i =0; i<listOfOptions.length; i++){
            var option = listOfOptions[i].label.toLowerCase();
             //keywork found match and selected items should exclude in search records
            if(option.indexOf(searchKeyWord) !== -1 && excludeitemsListValues.indexOf(listOfOptions[i].label) < 0){
                searchList.push(listOfOptions[i]);
            }
            //keyword match not found selected items should exclude in search records
            if(!searchKeyWord && excludeitemsListValues.indexOf(listOfOptions[i].label) < 0){
                searchList1.push(listOfOptions[i]);
            }
         }
        
        $A.util.removeClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", searchList);
        if(!searchKeyWord){
            component.set("v.listOfSearchRecords", searchList1);
        }
        debugger;
        
        helper.sortListRecords(component,event,helper);
    },
    sortListRecords : function(component,event,helper) {
        debugger;
        var lstRecords = component.get("v.listOfSearchRecords");
        lstRecords.sort(function(a, b){
        var nameA=a.label.toLowerCase();
        var nameB=b.label.toLowerCase();
        if (nameA < nameB) //sort string ascending
            return -1;
        if (nameA > nameB)
            return 1;
          return 0; //default return value (no sorting)
    })
   }
    
})