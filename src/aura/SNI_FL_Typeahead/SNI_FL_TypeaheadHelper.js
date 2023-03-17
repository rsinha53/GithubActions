({
    onChangeSearchTextHelper : function(component, event){
        var searchInput = component.get('v.selectedLabel');

        if(searchInput.length > 2){
            var searchResult = [];
            var action = component.get("c.getAllRelatedToMembers");

            action.setParams({searchKeyWord: searchInput});
            action.setCallback(this,function(response){                          
                var state = response.getState();
                if (state == 'SUCCESS') {
                    searchResult = response.getReturnValue();
                    if(searchResult.length > 0){
                        component.set('v.searchResult',searchResult);
                        component.set('v.displyDropdown', true);
                    } else {
                        component.set('v.searchResult',null);
                        component.set('v.displyDropdown', false);
                    }
                } 
            });
            $A.enqueueAction(action);
        } else {
            component.set('v.searchResult',null);
            component.set('v.displyDropdown', false);
        }
    },
    fullMemberNameSearch : function(component, event){
        var searchInput = component.get('v.selectedLabel');
        if(searchInput.length > 2){
            /******Hiding input***/
            var search = component.find('InputSearch');
            $A.util.addClass(search, 'slds-hide');
            var selectedOption = component.find('selectedOption');
            $A.util.removeClass(selectedOption, 'slds-hide');
            var allOptions = component.find('availableOptions');
            $A.util.addClass(allOptions, 'slds-hide');
            /*************************/
            var searchResult = [];
            var action = component.get("c.getAllRelatedToMembers");
            action.setParams({searchKeyWord: searchInput});
            action.setCallback(this,function(response){                          
                var state = response.getState();
                if (state == 'SUCCESS') {
                    searchResult = response.getReturnValue();
                    component.set('v.searchResult',searchResult);
                    var listAll = component.get('v.searchResult');
                    for(var i = 0;i < listAll.length; i++){
                        if(listAll[i].label == component.get('v.selectedLabel')){
                            component.set('v.selectedId', listAll[i].value);
                            break;
                        }
                    }
                } 
            });
            $A.enqueueAction(action);
        }
        else{
            var search = component.find('InputSearch');
        	$A.util.removeClass(search, 'slds-hide');
            var selectedOption = component.find('selectedOption');
        	$A.util.addClass(selectedOption, 'slds-hide');
            component.set('v.selectedLabel', '');
        }
    }
})