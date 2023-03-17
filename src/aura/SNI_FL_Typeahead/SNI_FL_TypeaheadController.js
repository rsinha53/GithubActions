({
    doInit : function(component, event, helper) {
        // fill lookup value
        if(!$A.util.isEmpty(component.get("v.selectedLabel")))
        {            
            var selectedOption = component.find('selectedOption');
            $A.util.removeClass(selectedOption, 'slds-hide');
            
            var allOptions = component.find('availableOptions');
            $A.util.addClass(allOptions, 'slds-hide');
            
            var search = component.find('InputSearch');
            $A.util.addClass(search, 'slds-hide');
            
        }
    },
    
    // perform search on change of text in search box
    onChangeSearchText : function(component, event, helper){
        var searchInput = component.get('v.selectedLabel');

        if(searchInput.length > 2){
            helper.onChangeSearchTextHelper(component, event);
        } else {
            component.set('v.displyDropdown', false);
            component.set('v.searchResult',null);
        }
    },
    
    handleMemberNameChange : function(component, event, helper){

        component.set('v.selectedLabel', component.get('v.searchedMemberName'));
        helper.fullMemberNameSearch(component, event);
    },
    
    onCloseSelectedRecord : function(component, event, helper){
        
        component.set('v.selectedId', 'empty');
        component.set('v.selectedLabel', '');
        component.set('v.searchedMemberName','');
        var selectedOption = component.find('selectedOption');
        $A.util.addClass(selectedOption, 'slds-hide');
        
        var search = component.find('InputSearch');
        $A.util.removeClass(search, 'slds-hide');
        
        component.set('v.displyDropdown', false);
        component.set('v.searchResult', null);
    },
    
    onSelectRecord : function(component, event, helper){
        component.set('v.isFocus',false);

        var selectedOption = component.find('selectedOption');
        $A.util.removeClass(selectedOption, 'slds-hide');
        
        var search = component.find('InputSearch');
        $A.util.addClass(search, 'slds-hide');
        
        var selectedIndx = event.currentTarget.dataset.index;
        var listAll = component.get('v.searchResult');
        
        component.set('v.selectedId', listAll[selectedIndx].value);
        component.set('v.selectedLabel', listAll[selectedIndx].label);

        component.set('v.displyDropdown', false);
        component.set('v.searchResult', null);
    },

    handleSearchText : function(component, event, helper){
        
        // var searchInput = component.get('v.selectedLabel');
        
        // if(searchInput.length > 2){
        //     helper.onChangeSearchTextHelper(component, event);
        // } else {
        //     component.set('v.displyDropdown', false);
        //     component.set('v.searchResult',null);
        // }

        component.set('v.searchResult',null);
        var searchInput = component.get('v.selectedLabel');
        if(searchInput.length < 3 ){
            component.set('v.displyDropdown', false);
            component.set('v.searchResult',null);
        }
    },

    onFocus : function(component, event, helper){
        var searchInput = component.get('v.selectedLabel');
        var isFocus = component.get('v.isFocus');
        if(isFocus != true){
            component.set('v.isFocus',true);
            if(searchInput.length > 2){
                helper.onChangeSearchTextHelper(component, event);
            } else {
                component.set('v.displyDropdown', false);
                component.set('v.searchResult',null);
                
            }
        }
        
    },
   
    hideDropdown : function(component, event, helper){
        component.set('v.isFocus',false);
        setTimeout(function () {
            component.set('v.displyDropdown', false);
        }, 200);
    }
})