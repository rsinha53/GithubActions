({
    getBusinessUnitValues: function(component,event,helper) {
    component.get("v.pagerefaranceobj");
},
	getMaterialForms : function(component,event,helper) {
        var  BusinessUnit = component.find('bussinessunitselect').get('v.value');
          var action = component.get("c.getMaterialForms");
        action.setParams({ BusinessUnit : BusinessUnit });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responcedata = response.getReturnValue();
              console.log(responcedata.vListMaterialsForms);
                component.set("v.vListMaterialsForms",responcedata.vListMaterialsForms);
                setTimeout(function(){
		            var tabKey = component.get("v.AutodocKey");
		            if(window.lgtAutodoc != undefined)
		            	window.lgtAutodoc.initAutodoc(tabKey);
		        },100);
                      }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
	},
    getselectedformshelper: function(component,event,helper) { 
        var matformsmap = new Object(); // or var map = {};   
        var businessunitval = component.find('bussinessunitselect').get("v.value");
        debugger;
var elements = document.getElementsByClassName('inputfieldcls');
          for (var i=0; i<elements.length; i++) {
              if(elements[i].value != ''){
                  debugger;
                  matformsmap[elements[i].getAttribute("data-recordid")] = elements[i].value;
              }
        }
        matformsmap.businessunitval = businessunitval;
       // component.get("v.matformsmap",matformsmap)
            console.log(JSON.stringify(matformsmap));

           var appEvent = $A.get("e.c:ACETLGT_MaterialRequestformSupportevent");
        appEvent.setParams({
            "matformsmap" : matformsmap
        });
        appEvent.fire();
        }
    
})