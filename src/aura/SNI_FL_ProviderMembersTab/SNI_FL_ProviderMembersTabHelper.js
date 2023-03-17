({
	getMemberList : function(component, event, helper) {
        var action = component.get('c.getMemberDetails');
        action.setParams({
            "providerProgram" : component.get('v.providerProgram')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                //console.log("docds:"+ JSON.stringify(res.memberDetails));
                if(!res.ErrorOccured){
                    component.set('v.memberWrapperList', res.memberDetails);
                    component.set('v.AllMemberRecords', res.memberDetails);
                    component.set('v.progPopulation',res.progPopulation);
                    var nameList = [];
                    for(var i = 0; i < res.memberDetails.length; i++){
                        if(res.memberDetails[i].memberName != null && res.memberDetails[i].memberName.trim() != ""){
                            nameList.push(res.memberDetails[i].memberName.trim());
                        }
                    }
                    component.set('v.memberNamesFullList', nameList);
                    component.set('v.memberNamesShortList', nameList);
                    component.set('v.selectedMemberName', '');
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire();     
                }  
            }
        });
        
        $A.enqueueAction(action);
	},
    
    getFilteredList : function(component, event, selectedValue) {
        var memrecs = component.get("v.AllMemberRecords");
        var selectedName = component.get('v.selectedMemberName');
        var activemem = [];
        var inactivemem = [];
        component.set("v.memberWrapperList",activemem);
        if((selectedValue == 'activeMembers')||(selectedValue == 'statusSort')){
            
            for(let index in memrecs){
                if(selectedName != null && selectedName != ''){
                	if(memrecs[index].memberName == selectedName && memrecs[index].isActive == true){
                    	activemem.push(memrecs[index]);
                    }
                } else if(memrecs[index].isActive == true){
                    activemem.push(memrecs[index]);           
                }
            }
            activemem.sort(function( a, b ) {
                if (a.memberName != true){
                    return 1;
                }
                if (b.memberName != true){
                    return -1;
                }
                if ( a.memberName.toLowerCase() < b.memberName.toLowerCase() ){
                    return -1;
                }
                if ( a.memberName.toLowerCase() > b.memberName.toLowerCase() ){
                    return 1;
                }
                return 0;
            });
            
            component.set("v.memberWrapperList",activemem); 
        }
        if((selectedValue == 'inactiveMembers')||(selectedValue == 'statusSort')){
            
            for(let index in memrecs){
                if(selectedName != null && selectedName != ''){
                    if(memrecs[index].memberName == selectedName && memrecs[index].isActive != true){
                    	inactivemem.push(memrecs[index]);
                    }
                } else if(memrecs[index].isActive != true){
                    inactivemem.push(memrecs[index]); 
                }
            }
            inactivemem.sort(function( a, b ) {
                
                if (a.memberName != true){
                    return 1;
                }
                if (b.memberName != true){
                    return -1;
                }
                if ( a.memberName.toLowerCase() < b.memberName.toLowerCase() ){
                    return -1;
                }
                if ( a.memberName.toLowerCase() > b.memberName.toLowerCase() ){
                    return 1;
                }
                return 0;
            });
            
            component.set("v.memberWrapperList",inactivemem);
        }
        
        if (selectedValue == 'statusSort'){
            
            var carray = [].concat(activemem, inactivemem);
            component.set("v.memberWrapperList",carray);
        }
        var nameList = [];
        var memList = component.get('v.memberWrapperList');
        for(var i = 0; i < memList.length; i++){
            if(memList[i].memberName != null && memList[i].memberName.trim() != ""){
                nameList.push(memList[i].memberName.trim());
            }
        }
        component.set('v.memberNamesFullList', nameList);
        component.set('v.memberNamesShortList', nameList);
    },
    
    getNameSortedList : function(component, event, helper){
         var memrecs = component.get("v.AllMemberRecords");
        memrecs.sort(function( a, b ) {
                
                if (a.memberName != true){
                    return 1;
                }
                if (b.memberName != true){
                    return -1;
                }
                if ( a.memberName.toLowerCase() < b.memberName.toLowerCase() ){
                    return -1;
                }
                if ( a.memberName.toLowerCase() > b.memberName.toLowerCase() ){
                    return 1;
                }
                return 0;
            });
            var nameList = [];
        	for(var i = 0; i < memrecs.length; i++){
                if(memrecs[i].memberName != null && memrecs[i].memberName.trim() != ""){
                    nameList.push(memrecs[i].memberName.trim());
                }
            }
            component.set('v.memberNamesFullList', nameList);
            component.set('v.memberNamesShortList', nameList);
        	component.set('v.filterMembers','');
        	component.set('v.selectedMemberName', '');
            component.set("v.memberWrapperList",memrecs);
        
    },
    searchForFilteredMembers : function(component, event) {
        var selectedMember = component.get('v.selectedMemberName');
		var memrecs = component.get("v.AllMemberRecords");
        var filterStatus = component.get('v.sortByDropdown');
        var filtermem = [];
        var nameList = [];
        for(let index in memrecs){
            if(memrecs[index].memberName == selectedMember){
                if(filterStatus == 'inactiveMembers' && memrecs[index].isActive != true){
                    filtermem.push(memrecs[index]);   
                	nameList.push(memrecs[index].memberName);
                } else if(filterStatus == 'activeMembers' && memrecs[index].isActive == true){
                    filtermem.push(memrecs[index]);   
                    nameList.push(memrecs[index].memberName);
                } else if(filterStatus == 'allMembers'){
                    filtermem.push(memrecs[index]);   
                    nameList.push(memrecs[index].memberName);
                }
            }
        }
        filtermem.sort(function( a, b ) {
            if (a.memberName != true){
                return 1;
            }
            if (b.memberName != true){
                return -1;
            }
            if ( a.memberName.toLowerCase() < b.memberName.toLowerCase() ){
                return -1;
            }
            if ( a.memberName.toLowerCase() > b.memberName.toLowerCase() ){
                return 1;
            }
            return 0;
        });
        component.set('v.memberNamesShortList', nameList);
        component.set('v.memberNamesFullList', nameList);
        component.set("v.memberWrapperList",filtermem);
		component.set('v.displayNameList', false);
	},
})