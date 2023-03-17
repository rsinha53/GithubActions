({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper ) {
        
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.value')) ) {
            helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        }
        
        var dropDown = component.find("dropDown");
        $A.util.removeClass(dropDown,'slds-is-open');
        $A.util.addClass(dropDown,'slds-is-close');
        $A.util.removeClass(dropDown,'slds-show');
        $A.util.addClass(dropDown,'slds-hide');

        component.set("v.selectProviderAfliation", '');
        
    },
    
    mouseHover: function( component, event, helper ) {
        var elements = document.getElementsByClassName("resultsDiv");
        elements[0].style.display = 'none';
    },

    // When a keyword is entered in search box
    searchRecords : function( component, event, helper ) {    
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    // When an item is selected
    selectItem : function( component, event, helper ) {
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        if(!isBackupAgentViewcondition){
            
            if(!$A.util.isEmpty(event.currentTarget.id)) {
                var recordsList = component.get('v.recordsList');
                var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
                if(index != -1) {
                    var selectedRecord = recordsList[index];
                }
                component.set('v.selectProviderAfliation',selectedRecord);
                component.set('v.value',selectedRecord.value);
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
                //<!-- vamsi -->
                var selItemObj = component.get("v.selectProviderAfliation");
            }else{
                var selectedRecord = recordsList;
            } 
            var cmpEvent = component.getEvent("cmpEventx"); 
            cmpEvent.setParams({
                "listOfSearchRecordsEvt" : component.get("v.selectProviderAfliation") });
            cmpEvent.fire();
            
           component.set('v.isRecordSelected',true);
        } 
        else{
            if(!$A.util.isEmpty(event.currentTarget.id)) {
                var recordsList = component.get('v.recordsList');
                var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
                if(index != -1) {
                    var selectedRecord = recordsList[index];
                }
                component.set('v.selectProviderAfliation',selectedRecord);
                component.set('v.value',selectedRecord.value);
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
                //<!-- vamsi -->
                var selItemObj = component.get("v.selectProviderAfliation");
            }else{
                var selectedRecord = recordsList;
            } 
            var cmpEvent = component.getEvent("cmpEventx"); 
            cmpEvent.setParams({
                "listOfSearchRecordsEvt" : component.get("v.selectProviderAfliation") });
            cmpEvent.fire();
            	
            component.set('v.isRecordSelected',true);
        } 
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : false
        });
        cmpEvent.fire();
    },
    
    showRecords : function( component, event, helper ) {
        var dropDown = component.find("dropDown");
        $A.util.addClass(dropDown,'slds-show');
        $A.util.removeClass(dropDown,'slds-hide');
       
        $A.util.addClass(dropDown,'slds-is-open');        
        $A.util.addClass(component.find('resultsDiv'),'slds-show');
        
        helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            //$A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
        component.set('v.showDropdown',true);
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : true
        });
        cmpEvent.fire();
    },
    
     hoverEvent: function( component, event, helper ) {
       var dropDown = component.find("dropDown");
        // $A.util.removeClass(dropDown,'slds-is-open');
         //$A.util.addClass(dropDown,'slds-is-close');
        // $A.util.removeClass(dropDown,'slds-show');
         //$A.util.addClass(dropDown,'slds-hide');
         
         component.set('v.message','');
         
    },
    
    onblur: function( component, event, helper ) {
        if(component.get('v.showOnclickCurtain') == false){
            var dropDown = component.find("resultsDiv");
            $A.util.removeClass(dropDown,'slds-is-open');
            $A.util.addClass(dropDown,'slds-is-close');
            component.set('v.showDropdown',false);
        }
    },
        // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        component.set('v.isRecordSelected',false);
        component.set('v.message','');
        var cmpEvent = component.getEvent("cmpEventx"); 
        //added vamsi
        cmpEvent.setParams({
        });
        cmpEvent.fire();
    },
    

    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        if( $A.util.isEmpty(component.get('v.selectProviderAfliation')) )
        {
            component.set('v.searchString',''); 
            component.set('v.message','');
            var dropDown = component.find("dropDown");
            $A.util.removeClass(dropDown,'slds-is-open');
            $A.util.addClass(dropDown,'slds-is-close');
            $A.util.removeClass(dropDown,'slds-show');
        }

    },

    preventDefault: function(component, event, helper){     	
        event.preventDefault();       
 	},
    
    //added Vamsi
    handleClear:function(component,event,heplper){
        component.set('v.selectProviderAfliation','');
        component.set('v.value','');
        component.set('v.searchString','');
        component.set('v.isRecordSelected',false);
        component.set('v.message','');
    },

})