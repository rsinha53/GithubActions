({
	searchDirectionRecords : function(component, event) {
		console.log('in helper call');
		var directionSearchType = component.get("v.directionSearchType");
		var businessUnit = component.get("v.businessUnitSelected");
        
		var topic = component.get("v.topicSelected");
        
		var type = component.get("v.typeSelected");
        
		var action = component.get("c.populateBusinessDropdown");
        
		var userRole = component.get("v.userInfo").Role_Name__c;
		console.log('USER ROLE! ' + userRole);
		action.setParams({
			searchType: directionSearchType,
			searchBusinessUnit: businessUnit,
			searchTopic: topic,
			searchTypeSel: type,
			searchUser: userRole
		});
		console.log('before callback');
		action.setCallback(this,function(response){
			var state = response.getState();
			console.log('STATE: ' + state);
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			console.log('RESULTS: ' + storeResponse);
    			var dropdownOptions = [];
    			dropdownOptions.push({
	                label: "None",
	                value: "None"
	            });
    			for (var i = 0; i < storeResponse.length; i++) {
		        	dropdownOptions.push({
		                label: storeResponse[i],
		                value: storeResponse[i]
		            });
		        }
    			if(directionSearchType == "Business Unit"){
    		        component.set('v.businessUnitOptions', dropdownOptions);
    			} else if(directionSearchType == "Topic"){
    				component.set('v.topicOptions', dropdownOptions);
    			} else if(directionSearchType == "Type"){
    				component.set('v.typeOptions', dropdownOptions);
    			} else if(directionSearchType == "Subtype"){
    				component.set('v.subtypeOptions', dropdownOptions);
    			} 
    		}
		});
		$A.enqueueAction(action);
	}
})