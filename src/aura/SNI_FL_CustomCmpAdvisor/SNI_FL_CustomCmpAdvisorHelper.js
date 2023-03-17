({  
    
    getuploadedFiles:function(component,event, helper){
        component.set("v.Spinner", true);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
		console.log(userId);
        component.set("v.currentUser",userId);
        var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                component.set("v.Spinner", false);
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
            } else{
                component.set("v.Spinner", false);
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
 })