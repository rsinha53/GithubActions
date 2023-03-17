({  
    
    doInit:function(component,event,helper){  
        helper.getuploadedFiles(component,event,helper);
    },      
    
    previewFile :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    }, 
    
    
     showfiles: function(component, event, helper){
    	component.set("v.showAllFC", true);
    	component.set("v.files", component.get("v.fulllistfiles"));
    },
    
    hidefiles: function(component, event, helper){
    	component.set("v.showAllFC", false);
    	component.set("v.files", component.get("v.shortlistfiles"));
    },
    
    handleMenuSelect: function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        var documentId = event.getSource().get("v.class");  
        var title= event.getSource().get("v.title");
        console.log('title'+title);
        component.set("v.selectedDocId",documentId);
        if(selectedMenuItemValue== "delete"){
            //component.set("v.Spinner", true); 
               
             component.set("v.isRemoveCnfrmModalOpen",true);
            component.set("v.selectedDocId",documentId);
           
        }
        if(selectedMenuItemValue== "edit"){
            component.set("v.selectedDocument",title);
            component.set("v.Ttle",title);
            component.set("v.showEditModal",true);
            component.set("v.buttondisable", true);
        }
        if(selectedMenuItemValue== "download"){
            var actiondownload = component.get("c.DownloadAttachment");
            actiondownload.setParams({
                "DownloadAttachmentID": documentId
            });
            actiondownload.setCallback(this,function(response){  
                var state = response.getState();  
                console.log(state);
                if(state=='SUCCESS'){  
                    var result = response.getReturnValue(); 
                    console.log(result);
                    // component.set("v.Baseurl", b.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": result
                    });
                    urlEvent.fire();
                    // component.set("v.files",result);  
                }  
            });  
            $A.enqueueAction(actiondownload);  
        }
        
        
    },
    handlecheck : function(component, event) { 
        var title = event.getSource().get('v.value').trim();
        if(title != ''){
        console.log('Title'+ title);
        console.log('old title'+ component.get("v.selectedDocument") );
        if(title != component.get("v.Ttle")){
            //alert('File Name'+fName);  	     
            component.set("v.buttondisable", false);
        }else{
            component.set("v.buttondisable", true);
        }
        }else{
            component.set("v.buttondisable", true);
        }
        
    },
    
    UploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");  
        helper.getuploadedFiles(component,event, helper);         
    },
    
    redirectToRelatedList : function (component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "AttachedContentDocuments",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
    },
    closeEditModal : function(component,event,helper) {
        component.set("v.showEditModal",false);
        helper.getuploadedFiles(component,event, helper);
    },
    EditDocumentInfo : function(component,event,helper) {
        var documentId = component.get("v.selectedDocId");
        var editName = component.get("v.selectedDocument");
        component.set("v.Spinner", true);
        if (editName!= undefined && editName != null && editName != ''){
            var action = component.get("c.editDocumentName");
            action.setParams({
                "sdocumentId": documentId,
                "Editedname": editName   
            });
            action.setCallback(this, function (response) {
                if(response.getState() === 'SUCCESS') {
                    component.set("v.Spinner", false);
                    var storedResponse = response.getReturnValue();
                    console.log("Response: "+ storedResponse);
                    if(storedResponse!=null) {
                        helper.getuploadedFiles(component,event, helper);
                        component.set("v.showEditModal",false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    UpdateColor : function(component, event, helper){
        var title = component.find('filesOver');
        $A.util.addClass(title, 'blueColor');
    },
    removeClass : function(component, event, helper){
        var Files = component.find('filesOver');
        $A.util.removeClass(Files, 'blueColor');
    },
    closeWarning : function(component, event, helper){
        component.set("v.isRemoveCnfrmModalOpen",false);
    },
    deleteFile:function(component,event,helper){
    var documentId = component.get("v.selectedDocId");
    helper.delUploadedfiles(component,documentId); 
        
    }
})