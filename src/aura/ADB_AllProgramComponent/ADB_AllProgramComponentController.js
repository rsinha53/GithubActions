({
    // display Program Detail into All Program Card
    onInit : function(component, event, helper) {
        helper.getReadPopulationDetails(component, event, helper,true);
    },
    
    //  fires when the disposition drop down get changed
    dispositionHandler :  function(component, event, helper) {
        var dataSource = event.target; 
        var listIndex = dataSource.getAttribute("data-list_item");
        component.set('v.listIndex', listIndex);
        
        // get old value of selected disposition 
        var oldDisposition = component.get("v.selectedValue");
        var lstDisposition = component.get("v.listOfDisposition");
        
        var currentDropdown = document.getElementById('allProgramDropdown' + listIndex);
        var disposition = currentDropdown.value;
        
        
        if (disposition == "Accept"||"Maybe_Later"||"Decline"){
            if(oldDisposition == "Accept"||"Maybe_Later"||"Decline"||"Not_Appropriate"){
                // remove old value of disposition and add new value of disposition 
                var index = lstDisposition.indexOf(oldDisposition);
                if (index > -1) {
                    lstDisposition.splice(index, 1);
                }
                lstDisposition.push(disposition);           
            }
            // when there isn't old value , only add new value of disposition
            else{
                lstDisposition.push(disposition);  
            }
        }  
        else if (disposition == "Not_Appropriate"){
            if(oldDisposition == "Accept"||"Maybe_Later"||"Decline"||"Not_Appropriate"){
                // remove old value of disposition and add new value of disposition 
                var index = lstDisposition.indexOf(oldDisposition);
                if (index > -1) {
                    lstDisposition.splice(index, 1);
                }
                lstDisposition.push(disposition);           
            }
            // when there isn't old value , only add new value of disposition
            else{
                lstDisposition.push(disposition);  
            } 
        }
        // when deselect the dropdown remove the old value of disposition
            else{
                var index = lstDisposition.indexOf(oldDisposition);
                if (index > -1) {
                    lstDisposition.splice(index, 1);
                }
            }
        // handle the Comment Box 
        if (disposition == "Not_Appropriate"){
            helper.commentBoxHandler(component, event, helper); 
        }
        helper.dispositionChange(component, event, helper);
        currentDropdown.blur();
    },
    
    // get old value of disposition
    getSelectedValue :  function(component, event, helper) {
        //	track the index of the selected row
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_item");
        component.set('v.listIndex', listIndex);
        
        // get old disposition value of selected row
        var oldValue = document.getElementById('allProgramDropdown' + listIndex).value;
        component.set('v.selectedValue',oldValue);
        
    },
    
    //	close comment box for remove opportunity
    closeCommentBox: function(component, event, helper) {
        
        var listIndex = component.get('v.listIndex');
        var selectedDropdown  = document.getElementById('allProgramDropdown'+ listIndex);
        
        var lstDisposition = component.get("v.listOfDisposition");
        
        var index = lstDisposition.indexOf("Not_Appropriate");
        if (index > -1) {
            lstDisposition.splice(index, 1);
        }
        // close comment popup     
        component.set("v.isCommentBoxVisible", false);	
        // reset empty value for the dropdown
        selectedDropdown.value = "";
        component.set("v.listOfDisposition", lstDisposition);
        helper.dispositionChange(component, event, helper);
    },
    
    //	handler for text change event on comment box
    onChangeComment : function(component, event, helper){
        var inputText = event.getSource().get("v.value");
        helper.toggleOkButton(component, inputText);
        
        var commentBox = component.find('commentBox');
        commentBox.reportValidity();
    },
    
    okButton: function(component, event, helper) {
        //	set the user entered comment into the list item comment field
        var dataList = component.get("v.PopulationDetails");
        var item = dataList[component.get("v.listIndex")];
        item.removeOpportunityComment = component.get("v.removeOpportunityComment");
        
        //	reset comment attribute and close the comment popup
        component.set("v.removeOpportunityComment", "");
        component.set("v.isCommentBoxVisible", false);
    },
    
    showHover: function(component, event, helper) {
        
        var hoverValue = component.get("v.isHoverVisible");
        if(hoverValue==false){
            component.set('v.isHoverVisible',true);
        }
        else{
            component.set('v.isHoverVisible',false); 
        }
        component.set('v.hoverRow', parseInt(event.target.dataset.index));
        component.set('v.hoverCol', parseInt(event.target.dataset.column));
    },    
    
    //added by Sai Kolluru
    submitDisposition : function(component, event, helper) {
        helper.submitDispositionHandler(component, event, helper);
    },
    
    viewRedirectUrl: function(component, event, helper) {
        helper.submiteRedirectUrl(component, event, helper);
    }
    
})