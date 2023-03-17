({
    // function to get read population details - Sunil Vennam: US2727248 - Read Population API 
    getReadPopulationDetails :function(component, event, helper,isOnload) {
        component.set("v.showSpinner", true);
        //get big 5 to pass to the service
        var XrefPartitionId = component.get("v.xrefPartitionID");
        var firstName = component.get("v.memFirstName");
        var lastName = component.get("v.memLastName");
        var XrefId = component.get("v.memberXrefId")
        var action = component.get("c.getMemberProgramsAPIDetails");
        action.setParams({ XrefPartitionId : XrefPartitionId,
                          firstName: firstName,
                          lastName: lastName,
                          XrefId: XrefId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var readPopulationDetails = response.getReturnValue();
                if(!$A.util.isEmpty(readPopulationDetails) && !$A.util.isUndefined(readPopulationDetails)){
                    // If the statusMessage from the response is not empty and does not equal 'success'
                    if(!$A.util.isEmpty(readPopulationDetails.systemErrorMessage) && (readPopulationDetails.systemErrorMessage.toLowerCase() != 'success')){
                        component.set('v.systemErrMsg',readPopulationDetails.systemErrorMessage);
                    } else {
                        // Get details of the member's multiple programs
                        if(!$A.util.isEmpty(readPopulationDetails.availableProgramsResponse) && !$A.util.isUndefined(readPopulationDetails.availableProgramsResponse)){
                            if(!$A.util.isEmpty(readPopulationDetails.availableProgramsResponse.availableProgramsResponseTypeList) && !$A.util.isUndefined(readPopulationDetails.availableProgramsResponse.availableProgramsResponseTypeList)){
                                component.set("v.PopulationDetails", readPopulationDetails.availableProgramsResponse.availableProgramsResponseTypeList);
                                if(isOnload)
                                    component.set("v.sortAsc", true);
                                else
                                    component.set("v.sortAsc", false);

                                helper.sortBy(component, "programName");
                            }
                        }
                        // Get details of the member's single program but store the details as an array object with details in index 0
                        if (!$A.util.isEmpty(readPopulationDetails.singleAvailableProgramsResponse) && !$A.util.isUndefined(readPopulationDetails.singleAvailableProgramsResponse)){
                            if(!$A.util.isEmpty(readPopulationDetails.singleAvailableProgramsResponse.singleAvailableProgramsResponseList) && !$A.util.isUndefined(readPopulationDetails.singleAvailableProgramsResponse.singleAvailableProgramsResponseList)){
                                if(!Array.isArray(readPopulationDetails.singleAvailableProgramsResponse.singleAvailableProgramsResponseList)) {
                                    let programs = new Array(readPopulationDetails.singleAvailableProgramsResponse.singleAvailableProgramsResponseList);
                                    component.set("v.PopulationDetails", programs);
                                } else {
                                    component.set("v.PopulationDetails", readPopulationDetails.singleAvailableProgramsResponse.singleAvailableProgramsResponseList);
                                }
                            }
                        }
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.PopulationDetails");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.PopulationDetails", records); 
    },
    
    //	toggle comment Ok button
    toggleOkButton : function(component, inputText) {
        if(!$A.util.isEmpty(inputText)){
            component.set('v.isOkButtonDisabled',false);
        }   
        else{
            component.set('v.isOkButtonDisabled',true);
        }
    },
    
    // handle save button visibility
    checkboxClickEvent : function(component, event, helper) {
        var values = document.getElementsByClassName("itemCheckboxes");
        for (var i = 0; i < values.length; i++){
            if(values[i].checked){
                component.set('v.isSaveButtonDisabled',false);
                break;
            }
            else{
                component.set('v.isSaveButtonDisabled',true);
            }
        }
    },
    
    // open comment box 
    commentBoxHandler: function(component, event, helper){
        //	track the index of the selected row
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_item");
        
        component.set('v.listIndex', listIndex);	// set current index to be used in 'Ok' button handler
        var disposision = document.getElementById('allProgramDropdown' + listIndex);
        
        //	set the current item's comment into the comment box
        var dataList = component.get("v.PopulationDetails");
        var item = dataList[listIndex];
        
        component.set("v.isCommentBoxVisible", true);                        
        component.set("v.removeOpportunityComment", item.removeOpportunityComment);
        
        helper.toggleOkButton(component, component.get('v.removeOpportunityComment'));
        
    },
    
    dispositionChange: function(component, event, helper){
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_item");
        component.set('v.listIndex', listIndex);
        
        // get old value of selected disposition 
        var oldDisposition = component.get("v.selectedValue");
        var lstDisposition = component.get("v.listOfDisposition");
        var strDisposition = lstDisposition.join("");
        
        // convert list to string
        var lengthValue = strDisposition.length;
        
        // when all dropdowns are deselected, disable Save button
        if(lengthValue == 0){
            component.set('v.isSaveButtonDisabled',true);
        }
        // at lease one dropdown is selected, enable Save button
        else{
            component.set('v.isSaveButtonDisabled',false);
        }
        component.set("v.listOfDisposition", strDisposition);
    },
    //added by Sai Kolluru
    submitDispositionHandler :function(component, event, helper){
        var listindex = component.get('v.listIndex');
        
        var action = component.get("c.submitAllProgramsDisposition");
        
        var selectedProgram = component.get('v.PopulationDetails')[listindex];
        var programICUESSOURL = selectedProgram['programICUESSOURL'];
        
        var currentDropdown = document.getElementById('allProgramDropdown' + listindex);
        var disposition = currentDropdown.value;
        var userId = component.get('v.userId');
        console.log('in submitDisposition method::userId'+userId+'::nbastatus'+disposition+'::programICUESSOURL'+programICUESSOURL);
        if(disposition == 'Not_Appropriate'){
           	var blankList = [];
            component.set('v.PopulationDetails',blankList);
            helper.getReadPopulationDetails(component, event, helper,false);
        }else{
            action.setParams({ 
                          programICUESSOURL : programICUESSOURL,
            nbastatus : disposition,
            userId : userId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //var redirectionUrl = result.redirectionUrl;
                        console.log('result'+result);
                        if(result != null && result != ''){
                        	window.open(result);
                            var blankList = [];
                            component.set('v.PopulationDetails',blankList);
                            helper.getReadPopulationDetails(component, event, helper,false);
                        }
            }
            
        });    
        $A.enqueueAction(action);
        }
        
        
    },
    submiteRedirectUrl:function(component, event, helper){
        var listindex = component.get('v.listIndex');
        var action = component.get("c.submitAllProgramsDisposition");
        
        var selectedItem = event.currentTarget;
        var programICUESSOURL= selectedItem.dataset.id;
         var userId = component.get('v.userId');
        console.log('in submitDisposition method::userId'+userId+'::programICUESSOURL'+programICUESSOURL);
       
        action.setParams({ 
                          programICUESSOURL : programICUESSOURL,
            			  nbastatus : '',
            			  userId : userId
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //var redirectionUrl = result.redirectionUrl;
                        console.log('result'+result);
                        if(result != null && result != ''){
                        	window.open(result);
                        }
            }	
            
        });    
        $A.enqueueAction(action);
    },
})