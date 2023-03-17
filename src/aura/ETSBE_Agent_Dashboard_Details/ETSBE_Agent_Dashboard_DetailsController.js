({
    refreshDashboard: function(component, event, helper){
        $A.get('e.force:refreshView').fire();
	},
    onsectiontoggleUser: function(component, event, helper){
         var interaction = component.find("sections");
         interaction.toggleuserChange();
        
    },
    clickBusinessUnit: function(component, event, helper){
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.businessUnitFilter", component.get("v.businessUnitOptions"));
    	
    	if(component.get("v.businessUnitText") == "None"){
    		component.set("v.businessUnitText", "");
    	}
    	component.set("v.displayBU", true);
    },
    clickBU: function(component, event, helper){
        component.set("v.displayBU", false);
    },
  searchBUonEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
        	var filterList = component.get("v.businessUnitFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.businessUnitSelected",filterList[0].label);
	        	component.set("v.businessUnitText",filterList[0].label);
	        	
	        	helper.resetFields(component,event);
	        	
        	}
        }
    },
  getBusinessUnitInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.businessUnitSelected",selLabel);
    	component.set("v.businessUnitText", selLabel);
    	helper.resetFields(component,event);
    },
   
  businessUnitTextChange: function(component, event, helper){
    	
    	
    	
    	helper.filterBusinessUnits(component, event, helper);
    },
    
    pickUser: function(component, event, helper) {
        component.set("v.initialLoad",true);
        var currentaction = component.get("c.fetchUser");
        var currentUser;
        currentaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('fetchUser response: ' + storeResponse);
                // set current user information on userInfo attribute
                component.set("v.currentuserMap", storeResponse);
                var selectedrecord = {};
                var businessunits =[];
                for (var key in storeResponse) {
                    if (storeResponse.hasOwnProperty(key)) {
                        //selectedrecord.push({value: key, label: storeResponse[key]});
                        //alert(JSON.parse(key));
                        businessunits = storeResponse[key];
                        console.log('JSON: ' + JSON.parse(key));
                        console.log( JSON.parse(key));
                        selectedrecord = JSON.parse(key);
                        console.log(selectedrecord);
                        //selectedrecord = key;
                        //alert(selectedrecord[key].Name);
                    }
                };
                 component.set("v.buList",businessunits);
                component.set("v.selectedLookUpRecord", selectedrecord);
                helper.onsectiontoggle(component,event,helper);
            }
        });
        
        
        $A.enqueueAction(currentaction);
    },
    // common reusable function for toggle sections
    toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    
    
})