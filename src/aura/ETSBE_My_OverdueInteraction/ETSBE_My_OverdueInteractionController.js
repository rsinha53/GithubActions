({
     scriptsLoaded : function(component, event, helper) {
      
    },
    
   
handleClick: function(component,event,helper){
       helper.getrecursiveTableRows(component, event, helper);
    },
    
	doInit : function(component,event,helper){
        
          console.log('Script loaded..'); 
          var params = event.getParam('arguments');
        var selectedUser='';
        var selectedBUnit='';
        if (params) {
            selectedUser = params.selectedUSer;
            selectedBUnit = params.selectedBU;
            component.set("v.username",selectedUser);
            component.set("v.businessunit",selectedBUnit);
            component.set("v.lastId",'');
        }
        var action = component.get("c.getFieldSet1");
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldSetName: component.get("v.fieldSetName")
        });
        
        action.setCallback(this, function(response) {
            var fieldSetObj = response.getReturnValue();
            var fieldSetValues = JSON.parse(fieldSetObj.Value);
            var columns=fieldSetObj.Label;
            console.log(fieldSetValues);
            
             var setfieldNames = new Set();
            
        for(var c=0, clang=fieldSetValues.length; c<clang; c++){    
            //alert(fieldSetValues[c].name);
            if(!setfieldNames.has(fieldSetValues[c].name)) {               
                              
                if(fieldSetValues[c].type == 'REFERENCE') {                    
                    if(fieldSetValues[c].name.indexOf('__c') == -1) {          
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('Id')) + '.Name');  
                    }                     
                    else {                     
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('__c')) + '__r.Name');                           
                    }                 
                } 
                else{
                    setfieldNames.add(fieldSetValues[c].name); 
                }
            }         
        }         
            console.log(setfieldNames);
            var arrfieldNames = [];       
            setfieldNames.forEach(v => arrfieldNames.push(v));
            //alert(setfieldNames);
   console.log(arrfieldNames);
            component.set("v.fieldsAPINameList", arrfieldNames);
            component.set("v.columnsLabelList", columns);
            console.log(arrfieldNames);
          helper.fetchdetails(component, event, helper,arrfieldNames,columns);
        })
        $A.enqueueAction(action);
       
    },
     showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
})