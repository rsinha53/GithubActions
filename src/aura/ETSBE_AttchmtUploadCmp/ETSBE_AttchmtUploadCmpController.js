({  
    doInit:function(component,event,helper){  
       helper.fetchuploadedFiles(component);
       helper.fetchacceptedformats(component);  
        helper.fetchrecordtypes(component);
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
        
         var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type":"success",
        "message": "File Uploaded successfully!!"
    });
    toastEvent.fire();
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
       
    },
     onDescriptionChange : function(component,event,helper){ 
        // if edit field value changed and field not equal to blank,
        // then show save and cancel button by set attribute to true
        if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    }
 })