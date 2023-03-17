({
    /*Set the selected case into a different list*/
    doInit: function(component, event, helper){               
        var selectedCase = component.get("v.selectedCase");
        var allCaseList = component.get("v.listOfCases");
        var selectedCaseList = component.get("v.selectedListOfCases");
        for(let i = 0; i < allCaseList.length; i++){
            if(allCaseList[i].caseID == selectedCase){ 
                selectedCaseList.push(allCaseList[i]);     
                component.set("v.selectedListOfCases", selectedCaseList);
            }
        } 

       
    },
   
	 closeModel: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
		component.set("v.IsOpenCaseAttachment",false);
        
	 },
})