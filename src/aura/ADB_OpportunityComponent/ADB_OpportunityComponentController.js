({
    onInit : function(component, event, helper) {        
        if(component.get("v.memberTypeId") == 'CDB_XREF_ID'){
           helper.getRole(component, event, helper);
        }
    },
    
    //	handler for 'More' button click
    onclickmore : function(component, event, helper) {
        
        //	toggle more/less buttons
        component.set("v.isMoreButtonVisible", "false");		        
        
        //	update the cap value to list length so the table will show all the records
        component.set("v.listEndCount", component.get("v.displayOffers").length);                
    },
    
    //	handler for 'Less' button click
    onclickless : function(component, event, helper) {
        
        //	toggle more/less buttons
        component.set("v.isMoreButtonVisible", "true");
        
        //	update the cap value to 3 to show the default view
        component.set("v.listEndCount", 3);
    },
    
    checkboxClick: function(component, event, helper) {
        //handle save button visibility
        helper.checkboxClickEvent(component, event, helper);
    },
    
    //	handler for specific event click(small circles)
    onEventClick : function(component, event, helper) {
        helper.onEventClick(component, event, helper);        
    },
    
    // handle hover text  
    handleMouseOver :function(component, event, helper) {
        //  component.set("v.hoverRow", parseInt(event.target.dataset.index));
        var currIndex = event.target.dataset.index;
        //alert(currIndex);
        var currColumn = event.target.dataset.column;
        //alert(currColumn);
        var popoverId = 'popover' + currColumn + currIndex;
        var dataElement = document.getElementById(popoverId);
        
        if(dataElement != null) {
            document.getElementById(popoverId).classList.remove('slds-hide');
            document.getElementById(popoverId).classList.add('slds-show');
        }
    },
    
    // handle hover text 
    handleMouseOut : function(component,event,helper){
        //component.set("v.hoverRow",-1);  
        var currIndex = event.target.dataset.index;
        var currColumn = event.target.dataset.column;
        var popoverId = 'popover' + currColumn + currIndex;
        var dataElement = document.getElementById(popoverId);
        
        if(dataElement != null) {
            document.getElementById(popoverId).classList.remove('slds-show');
            document.getElementById(popoverId).classList.add('slds-hide');        
        }
    },
    
    //handle AllProgram button
    handleAllPrograms : function(component, event, helper) {
        component.set("v.allProgramSubCardVisible", true);
    },
    
    //Close AllProgram subcard
    closeAllProgramButton : function(component, event, helper) {
        component.set("v.allProgramSubCardVisible", false);
    },
    
    //  fires when the disposition drop down get changed
    dispositionChangeHandler :  function(component, event, helper) {
        var dataSource = event.target;
        var listIndex = dataSource.getAttribute("data-list_index");
        component.set('v.listIndex', listIndex);
        
        // get old value of selected disposition 
        var oldDisposition = component.get("v.selectedValue");
        var lstDisposition = component.get("v.listOfDisposision");
        
        var currentDropdown = document.getElementById('dropdown' + listIndex);
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
        var listIndex = dataSource.getAttribute("data-list_index");
        component.set('v.listIndex', listIndex);
        
        // get old disposition value of selected row
        var oldValue = document.getElementById('dropdown' + listIndex).value;
        component.set('v.selectedValue',oldValue);
        
    },
    
    //	close comment box for remove opportunity
    closeCommentBox: function(component, event, helper) {
        
        var listIndex = component.get('v.listIndex');
        var selectedDropdown  = document.getElementById('dropdown'+ listIndex);
        
        var lstDisposition = component.get("v.listOfDisposision");
        
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
        var dataList = component.get("v.displayOffers");
        var item = dataList[component.get("v.listIndex")];
        item.removeOpportunityComment = component.get("v.removeOpportunityComment");
        
        //	reset comment attribute and close the comment popup
        component.set("v.removeOpportunityComment", "");
        component.set("v.isCommentBoxVisible", false);
    },
    
    showHover: function(component, event, helper) {
        //console.log('hit');
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
    
    onmouseover: function(component, event, helper) {
        helper.handleonmouseover(component, event, helper);
    },
    
    onmouseout: function(component, event, helper) {
        helper.handleonmouseout(component, event, helper);
        
        //component.set('v.hoverRow',-1);
        //component.set('v.hoverCol',-1);
    },
    saveOpps: function(component, event, helper) {
        helper.saveDispositions(component, event, helper);
    },
    /*page refresh after data save*/    
    refreshCard: function(component, event, helper) {
        //location.reload();
        // $A.get('e.force:refreshView').fire();
        component.set("v.displayOffers",[]);
        
        if(component.get("v.memberTypeId")== 'SKEY'){
            console.log(">>>srk"+component.get("v.memberXrefId"));
            helper.getRole(component, event, helper); 
        } 
        
        if(component.get("v.memberTypeId") == 'CDB_XREF_ID'){
            helper.getRole(component, event, helper);
        }
        
    },
    clickDashboard : function(component, event, helper) {
        helper.getDashboardURL(component, event, helper);
	},
	 validateOpportunities : function(component, event, helper) {
        if(component.get('v.policyTerminated') ){
            console.log('validated.. its terminated policy');
               component.set("v.displayOffers", []);
               component.set("v.originalOffers", []);
            	component.set("v.isError", true);
               component.set("v.isTerminated", true);
               component.set("v.isInfoMsg", true);
               component.set("v.errorMessage", "Members' Policy is Terminated");
               component.set("v.isServicePending", false);	//	hide the spinner
        }
        
    }  
})