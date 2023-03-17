({  
    fetchrecordtypes : function(component){
        var action = component.get("c.disableAttachment"); 
        
        action.setParams({  
            "caseId":component.get("v.recordId")  
        });   
        
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue(); 
               
                    component.set("v.disableupload",result);
                
            }  
        });  
        $A.enqueueAction(action); 
    },
    fetchacceptedformats:function(component){
        var action = component.get("c.fetchAcceptedFormats"); 
        
        action.setParams({  
            "Caseid":component.get("v.recordId")  
        });   
        
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue(); 
                if(result.length==0){
                    component.set("v.disableupload",true);
                }else{
                console.log('result --> ' + JSON.stringify(result));
                component.set("v.accept",result);
                    component.set("v.disableupload",false);
                }
            }  
        });  
        $A.enqueueAction(action);  
    },
  
    fetchuploadedFiles:function(component){
        var action = component.get("c.fetchFiles");  
        action.setParams({  
            "recordId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                console.log('result --> ' + JSON.stringify(result));
                component.set("v.files",result);  
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
                component.set("v.Spinner", false); 
            }  
        });  
        $A.enqueueAction(action);  
    },  
 })