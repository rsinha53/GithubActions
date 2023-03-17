({  
    doInit:function(component,event,helper){  
       
      component.set("v.tempfile",component.get("v.file"));
    },      
    
    previewFile :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
        helper.fetchuploadedFiles(component);         
        component.find('notifLib').showNotice({
            "variant": "info",
            "header": "Success",
            "message": "File Uploaded successfully!!",
            closeCallback: function() {}
        });
    }, 
    
    delFiles:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    },
     inlineEditDescrption : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.DescrptionMode", false); 
       
    },
    openModel:function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.DescrptionMode", true); 
       
        
        var action = component.get("c.fetchSingleFile");  
        action.setParams({  
            "fileId":component.get("v.file.fileId"),  
            "attchId":component.get("v.file.attchId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                console.log(result);
                 component.set("v.file.Description",JSON.parse(result).Description);
            }  
        });  
        $A.enqueueAction(action);  
    
    },
     onDescriptionChange : function(component,event,helper){ 
        // if edit field value changed and field not equal to blank,
        // then show save and cancel button by set attribute to true
        if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    },
     closeNameBox : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.onDescriptionChange", false); 
      // check if change/update Name field is blank, then add error class to column -
      // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    },
    save:function(component,event,helper){
        var currentRecord;
       // currentRecord = event.
    var action = component.get("c.updateFiles");  
        action.setParams({  
            "file":JSON.stringify(component.get("v.file")) 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                component.set("v.DescrptionMode", true);
            }  
        });  
        $A.enqueueAction(action);  
	}
 })