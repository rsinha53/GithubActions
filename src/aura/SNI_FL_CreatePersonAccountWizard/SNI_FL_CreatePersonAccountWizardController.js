({
    doInit : function(component, event, helper) {
        var action = component.get('c.getPicklist');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS") {
                var result = response.getReturnValue();
                var pickVal=[];
                for(var key in result){
                    pickVal.push({key:key, value:result[key]});
                }
                console.log('pickVal--'+pickVal);
                component.set("v.options", pickVal); 
                console.log('options',component.get("v.options"));
            } else {
                console.error();
            }
        });
        $A.enqueueAction(action);
    },
    save : function(component, event, helper)
    {	
        console.log(JSON.stringify(component.get("v.relatedFamilyInformation")));
        var fstName= component.get("v.firstName");
        var lstName= component.get("v.lastName");
        var dob= component.get("v.dateOfBirth");
        var eml= component.get("v.email");
        var mId= component.get("v.memberId");
        var pId= component.get("v.policyId");
        var relation = component.get("v.Relationship");
        console.log(relation);
        //var reltedFam = JSON.parse(JSON.stringify(component.get("v.relatedFamilyInformation")));
        var reltedFam =component.get("v.relatedFamilyInformation");
        console.log('reltedFam--'+reltedFam);
        
        let flag = false;
        for(let i=0;i<reltedFam.length;i++){
            if(reltedFam[i].firstname=='' || reltedFam[i].firstname==undefined || 
               reltedFam[i].lastname=='' || reltedFam[i].lastname==undefined || 
               reltedFam[i].DOB=='' || reltedFam[i].DOB==undefined ||
               reltedFam[i].relationship=='' || reltedFam[i].relationship=='--None--'){
                flag=true;
            }
            if((reltedFam[i].firstname=='' || reltedFam[i].firstname==undefined) &&
               (reltedFam[i].lastname=='' || reltedFam[i].lastname==undefined) && 
               (reltedFam[i].DOB=='' || reltedFam[i].DOB==undefined) &&
               (reltedFam[i].relationship=='' || reltedFam[i].relationship=='--None--')){
                flag=false;
                break;
            }
        }
        if(fstName=='' || fstName==undefined || lstName=='' || lstName==undefined || dob=='' || dob==undefined || relation =='' || relation =='--None--' || mId == '' || mId==undefined || pId == '' || pId==undefined){
           		flag = true;
           }
	
           
        if(fstName !== undefined || fstName!=''){
            component.set("v.showSpinner", true);
			console.log(flag);
            if(!flag){
                reltedFam.push({
            'firstname':fstName,
            'lastname':lstName,
            'DOB':dob,
            'relationship':relation
        	});
                var action= component.get("c.personAccountSave");
                console.log('action is '+ action);
                action.setParams({"accData": JSON.stringify(component.get("v.relatedFamilyInformation")),
                                  "fname" : fstName, "lname":lstName, "dbirth":dob, "em":eml, "mid":mId , "pid":pId});
                action.setCallback(this,function(response)
                                   {
                                       var state =response.getState();
                                       console.log('state is '+ state);
                                       if(state=='SUCCESS')
                                       {	component.set("v.showSpinner", false);
                                        console.log('state is '+ state);
                                        helper.showToast('Success !', 'Record Inserted Successfully', 'success');
                                        //$A.get("e.force:closeQuickAction").fire();
                                        
                                        var accountId = response.getReturnValue();
                                        if(document.location.pathname.indexOf("/lightning/") != 0){
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": accountId,
                                    //"slideDevName": "related"
                                });
                                navEvt.fire();
                            }else{
                                var workspaceAPI = component.find("workspace");
                                console.log('workspaceAPI'+workspaceAPI);
                                workspaceAPI.openTab({
                                    url: '/lightning/r/Account/'+accountId+'/view',
                                    focus: true
                                    
                                }).then(function(response) {
                                    var setEvent = component.getEvent("setShowSpinner");
                                    setEvent.fire();
                                    if(IdsPersonFamilyAccount[0]=='ITE'){
                                        workspaceAPI.openSubtab({
                                            parentTabId: response,
                                            url: '/lightning/r/Account/'+accountId+'/view',
                                            focus: true
                                        });
                                        //}
                                    }
                                    var focusedTabId = response;
                                    //alert('response--> '+response);
                                    workspaceAPI.refreshTab({
                                        tabId: focusedTabId,
                                        includeAllSubtabs: true
                                    });
                                }).catch(function(error) {
                                    
                                });
                            }
                                        
                                       }
                                       else {
                                           component.set("v.showSpinner", false);
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               title : 'Error',
                                               message: 'Error while inserting the record.',
                                               duration:' 5000',
                                               key: 'info_alt',
                                               type: 'error',
                                               
                                           });
                                           toastEvent.fire();
                                       }
                                   });
                $A.enqueueAction(action);

                component.set("v.firstName", ""); 
                component.set("v.lastName", ""); 
                component.set("v.dateOfBirth", ""); 
                component.set("v.email", ""); 
                component.set("v.memberId", ""); 
                component.set("v.policyId", ""); 
                component.set("v.Relationship","");
                component.set("v.relatedFamilyInformation", ""); 
            }
            else{
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'Please insert value in all the fields.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    
                });
                toastEvent.fire();
            }
            //var toastEvent = $A.get("e.force:showToast");
            //  toastEvent.setParams({
            //      title : 'Warning',
            //    message: 'Please fill all the details',
            //  duration:' 5000',
            //key: 'info_alt',
            // type: 'warning',
            // mode: 'sticky'
            //  });
            // toastEvent.fire();
            
        }     
    },
    
    handleChange:  function(component, event, helper)
    {
        var name = event.getSource().get("v.name"); 
        console.log('--',event.getSource().get("v.name"));
        var value = event.getSource().get("v.value");  
        console.log('--',event.getSource().get("v.value"));
        var relatedFamilyInformation = component.get("v.relatedFamilyInformation") ; 
        console.log('relatedFamilyInformation',relatedFamilyInformation);
        if(name=="firstName"){
            component.set("v.firstName", value);
        }
        if (name == "lastName") {
            component.set("v.lastName", value);
        }
        if (name == "dateOfBirth") {
            component.set("v.dateOfBirth", value);
        }
        if (name == "email") {
            component.set("v.email", value);
        }
        if (name == "memberId") {
            component.set("v.memberId", value);
        }
        if (name == "policyId") {
            component.set("v.policyId", value);
        }
        if (name == "relationship") {
            component.set("v.Relationship", value);
        }
    },
    cancel : function(component, event, helper)
    {	$A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();  
        component.set("v.firstName", ""); 
        component.set("v.lastName", ""); 
        component.set("v.dateOfBirth", ""); 
        component.set("v.email", ""); 
        component.set("v.memberId", ""); 
        component.set("v.policyId", ""); 
        component.set("v.Relationship","");
        component.set("v.relatedFamilyInformation", ""); 
    },
    handleAdd : function(component, event, helper)
    {
        // alert( event.getSource().get("v.name"));
        let nextRow =  Number(event.getSource().get("v.name"))+1;
        let newRow = {'firstname':'','lastname':'','DOB':'','relationship':''};
        let relatedFamilyInformation = component.get("v.relatedFamilyInformation") ;
        relatedFamilyInformation.push(newRow);
        component.set("v.relatedFamilyInformation",relatedFamilyInformation);
        
    },
    handleDelete:function(component, event, helper)
    {
        
        let relatedFamilyInformation = component.get("v.relatedFamilyInformation") ;
        if(relatedFamilyInformation.length!==1){
            relatedFamilyInformation.pop();
        }
        component.set("v.relatedFamilyInformation",relatedFamilyInformation);
    }
})