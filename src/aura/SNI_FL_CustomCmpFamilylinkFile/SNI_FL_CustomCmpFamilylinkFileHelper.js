({  
    getuploadedFiles:function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
		console.log(userId);
        component.set("v.currentUser",userId);
        var action = component.get("c.getallFiles");  
        action.setParams({  
            "recordId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();
                if(result.length > 5){
                	var recordList = [];
                	for(var i = 0; i < 5;i++){
                		recordList.push(result[i]);
                	}
                    component.set("v.File_count",result.length);
                	component.set('v.files', recordList);
                	component.set('v.shortlistfiles', recordList);
                	component.set('v.showAllFC', false);
                } else {
                	component.set('v.files', result);
                    component.set("v.File_count",result.length);
                }
               // component.set("v.fullLstFC", records);
                component.set("v.fulllistfiles",result);
            }  
        });  
        $A.enqueueAction(action);  
    },
   
    updatesDocList :  function(component,event,helper){
         var uploadedFiles = event.getParam("files");  
        var ids=new Array();
        for (var i= 0 ; i < uploadedFiles.length ; i++){
            ids.push(uploadedFiles[i].documentId);
        }
        var idListJSON=JSON.stringify(ids);
        var familyId = component.get("v.familyId");
        var action = component.get("c.getUpdatedDocs");
        action.setParams({  
            "uploadedFilesIds": idListJSON,
            "familyId": familyId,
            "RecordID":component.get('v.recordId'),
            "selectedName" : component.get('v.recordName')
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();
            if(state=='SUCCESS'){  
                var result = response.getReturnValue(); 
                component.set("v.familydocwrap", result);
            }else {
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }
        });  
        $A.enqueueAction(action);
    },
    
    delUploadedfiles : function(component,documentId) {  
        var action = component.get("c.deleteFiles");           
        action.setParams({
            "sdocumentId":documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                this.getuploadedFiles(component);
                component.set("v.isRemoveCnfrmModalOpen",false);
            }  
        });  
        $A.enqueueAction(action);  
    },
        UpdateDocument : function(component,event,Id) {  	     
        var action = component.get("c.UpdateFiles");  	     
        var fName = component.find("fileName").get("v.value");  	     
        //alert('File Name'+fName);  	     
        action.setParams({"documentId":Id,  	              
                          "title": fName,  	              
                          "recordId": component.get("v.recordId")  	              
                         });  	     
        action.setCallback(this,function(response){  	      
        var state = response.getState();  	       
         if(state=='SUCCESS'){  	         
         var result = response.getReturnValue();  	         
         console.log('Result Returned: ' +result);  	         
         component.find("fileName").set("v.value", " ");  	        
         component.set("v.files",result);  	      
              }  	     
        });  	     
            $A.enqueueAction(action);  	   
        },  
 })