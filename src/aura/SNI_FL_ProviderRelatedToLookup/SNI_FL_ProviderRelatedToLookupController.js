({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper ) {   
        
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        var famId = component.get('v.familyId');
        console.log('famId = ' + famId);
        
        if( !$A.util.isEmpty(component.get('v.familyId')) ) {
            helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        }
        
        var dropDown = component.find("dropDown");
        $A.util.removeClass(dropDown,'slds-is-open');
        $A.util.addClass(dropDown,'slds-is-close');
        $A.util.removeClass(dropDown,'slds-show');
        $A.util.addClass(dropDown,'slds-hide');

        if( !$A.util.isEmpty(component.get('v.familyId')) ) {
            helper.getMemberIdByFamilyId(component, event, helper);
        }
        component.set("v.selectedRecord", '');
        
        
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
        var familyID = component.get("v.familyId");	                      
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        if(!isBackupAgentViewcondition){
            
            if(!$A.util.isEmpty(event.currentTarget.id)) {
                var recordsList = component.get('v.recordsList');
                var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
                if(index != -1) {
                    var selectedRecord = recordsList[index];
                }
                component.set('v.selectedRecord',selectedRecord);
                component.set('v.memberId',selectedRecord.memberId); 
                var memberId = component.get('v.memberId');
                if(familyID != null && familyID != 'undefined' ){
                    if( memberId != null && memberId != 'undefined'){
                        component.set('v.displayName',selectedRecord.label + ' - ' + selectedRecord.memberId );
                    }else{
                        component.set('v.displayName',selectedRecord.label);
                    } 
                }else{
                    if( memberId != null && memberId != 'undefined'){
                        component.set('v.displayName',selectedRecord.label + ' - ' + selectedRecord.memberId );
                    }else{
                        component.set('v.displayName',selectedRecord.label);
                    } 
                }

                             
                
                component.set('v.value',selectedRecord.value);
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');                

                //<!-- vamsi -->
                var selItemObj = component.get("v.selectedRecord");
            }else{
                var selectedRecord = recordsList;
            } 
            var cmpEvent = component.getEvent("cmpEventx"); 
            cmpEvent.setParams({
                "listOfSearchRecordsEvt" : component.get("v.selectedRecord") });
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
                component.set('v.selectedRecord',selectedRecord);
                component.set('v.memberId',selectedRecord.memberId); 
                var memberId = component.get('v.memberId');               
                if(familyID != null && familyID != 'undefined' ){
                    if( memberId != null && memberId != 'undefined'){
                        component.set('v.displayName',selectedRecord.label + ' - ' + selectedRecord.memberId );
                    }else{
                        component.set('v.displayName',selectedRecord.label);
                    } 
                }else{
                    if( memberId != null && memberId != 'undefined'){
                        component.set('v.displayName',selectedRecord.label + ' - ' + selectedRecord.memberId );
                    }else{
                        component.set('v.displayName',selectedRecord.label);
                    } 
                }
                component.set('v.value',selectedRecord.value);
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
                //<!-- vamsi -->
                var selItemObj = component.get("v.selectedRecord");
            }else{
                var selectedRecord = recordsList;
            } 
            var cmpEvent = component.getEvent("cmpEventx"); 
            cmpEvent.setParams({
                "listOfSearchRecordsEvt" : component.get("v.selectedRecord") });
            cmpEvent.fire();
            	
            component.set('v.isRecordSelected',true);
        } 
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
        
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        if( $A.util.isEmpty(component.get('v.selectedRecord')) )
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

        if($A.util.isUndefined(component.get("v.familyId"))){
            component.set('v.selectedRecord','');
            component.set('v.value','');
            component.set('v.searchString','');
            component.set('v.isRecordSelected',false);
            component.set('v.message','');
        }
        
    },
})