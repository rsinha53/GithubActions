({
	doInit : function(component, event, helper) {
        helper.getMemberList(component);
        if(screen.width < 600){
            component.set('v.isSmallScreen', true);
        } else if (screen.width < 992) {
            component.set('v.isTabletScreen', true);
        }
    },
    
    handleChange : function(component, event, helper) {
        component.set('v.providerProgram', event.getParam("value"));
       	helper.getMemberList(component);
    },
     ShowPopUP : function(component,event, helper) {
        var recid=event.target.id;
         component.set("v.memberRecord", recid);
        component.set("v.isModalOpen", true);
    } ,
    
    handleSNI_FL_MemberModelCloseEvt : function(component,event, helper) {
      component.set("v.isModalOpen", event.getParam("message"));  
    },
    
    statusChange : function(component, event, helper) {
        var selectedValue = event.getParam("value");
        if(selectedValue == 'allMembers'){
            var cmpTarget = component.find('changeMe');
            $A.util.removeClass(cmpTarget, 'toggle');
            helper.getNameSortedList(component, event, helper);
                        
        }
        else{
            var cmpTarget = component.find('changeMe');
            $A.util.addClass(cmpTarget, 'toggle');
            helper.getFilteredList(component, event, selectedValue);
            component.set("v.sortToggleSelection", 'nameSort');
        }
    },
    
    sortToggle : function(component, event, helper) {
        var sortType = event.getParam("value");
        if(sortType == 'statusSort'){
            helper.getFilteredList(component, event, sortType);
        }else{
            helper.getNameSortedList(component, event, helper);
        }
    },
    filterMemberList: function(component, event, helper) {
        var filterText = component.get('v.filterMembers').trim();
        if(filterText.length > 0){
            var shortList = [];
            component.set('v.memberNamesShortList', shortList);
            var fullList = component.get('v.memberNamesFullList');
            for(var i = 0; i < fullList.length; i++){
                if(filterText.length <= fullList[i].length){
                    var nameList = fullList[i].split(' ');
                    for(var j = 0; j < nameList.length; j++){
                        if(filterText.toLowerCase() == nameList[j].substring(0,filterText.length).toLowerCase()){
                            shortList.push(fullList[i]);
                            break;
                        }
                    }
                }
            }
            component.set('v.memberNamesShortList', shortList);
            component.set('v.displayNameList', true);
        } else {
            component.set('v.displayNameList', false);
        }
    },
   displayMemberFilterList: function(component, event, helper) {
        var filterText = component.get('v.filterMembers').trim();
        var shortList = component.get('v.memberNamesShortList');
        if(filterText != undefined && filterText != null && filterText != '' && shortList.length > 0){
            component.set('v.displayNameList', true);
        }
    },
    selectMemberName: function(component, event, helper) {
        var selMem = event.currentTarget.getAttribute("data-value");
        component.set('v.filterMembers', selMem);
        component.set('v.selectedMemberName', selMem);
        var cmpTarget = component.find('changeMe');
            $A.util.addClass(cmpTarget, 'toggle');
        helper.searchForFilteredMembers(component,event);
    },
    closeMemberFilterDropdown: function(component, event, helper) {
        component.set('v.displayNameList', false);
    },
    clearMemberFilter: function(component, event, helper){
        component.set('v.filterMembers', '');
        component.set('v.displayNameList', false);
        component.set('v.selectedMemberName', '');
        component.set('v.sortByDropdown', 'allMembers');
        var cmpTarget = component.find('changeMe');
        $A.util.removeClass(cmpTarget, 'toggle');
        helper.getNameSortedList(component, event, helper);
    },
    changeToMessages: function(component, event, helper){
        var memName=event.target.id;
        var memId =event.target.getAttribute('data-memberid');
        var cmpEvent = component.getEvent("SNI_FL_RedirectToViewMessagesEvt");
        cmpEvent.setParams({
            memberName : memName,
            memberId : memId });
        cmpEvent.fire();
    },
})