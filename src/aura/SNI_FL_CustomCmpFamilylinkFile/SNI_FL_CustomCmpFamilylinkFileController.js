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
     setCurrentFamily : function(component, event) {
        var selectFamId = event.getParam("familyAccId");
      
        component.set("v.familyId", selectFamId);
       
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
        component.set("v.selectedDocId",documentId);
        if(selectedMenuItemValue== "delete"){
             
          component.set("v.isRemoveCnfrmModalOpen",true);
            component.set("v.selectedDocId",documentId);      
        
        }
        if(selectedMenuItemValue== "edit"){
              component.set("v.selectedDocument",title);
              component.set("v.Ttle",title);
              component.set("v.showEditModal",true);
            component.set("v.buttondisable", true);
        //helper.UpdateDocument(component,event,documentId);  
        }
        if(selectedMenuItemValue== "download"){
            //var id = event.target.getAttribute("value");
            //alert('Document ID:' +selectedMenuItemValue);
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
       // alert(selectedMenuItemValue);
       
},
    handlecheck : function(component, event) { 
        var title = event.getSource().get('v.value').trim();
        if(title != ''){
        console.log('Title'+ title);
        console.log('old title'+ component.get("v.selectedDocument") );
        if(title != component.get("v.Ttle")){
            component.set("v.buttondisable", false);
        }else{
            component.set("v.buttondisable", true);
        }
        }else{
            component.set("v.buttondisable", true);
        }
},
    redirectToRelatedList : function (component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "AttachedContentDocuments",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
        
    },
    
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
        var documentId = uploadedFiles[0].documentId; 
        console.log('Console Document Id'+ documentId);
        console.log('Uploaded Files'+ JSON.stringify(uploadedFiles));
        var ids=new Array();
    for (var i= 0 ; i < uploadedFiles.length ; i++){
        ids.push(uploadedFiles[i].documentId);
        console.log(uploadedFiles[i].documentId);
    }

    var idListJSON=JSON.stringify(ids);
        console.log('idListJSON'+ idListJSON);
        //var fileName = uploadedFiles[0].name;
        var action = component.get("c.AllUserFiles");
        console.log('BIG CHECK ++++++++++++');
        action.setParams({  
            "uploadedFilesIds": idListJSON
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();
            console.log(state);
            if(state=='SUCCESS'){  
                var result = response.getReturnValue(); 
                console.log('Final Id'+ result);
            }  
        });  
        $A.enqueueAction(action);
        helper.updatesDocList(component, event, helper);
        helper.getuploadedFiles(component,event,helper);         
    }, 
    closeEditModal : function(component,event,helper) {
        component.set("v.showEditModal",false);
        helper.getuploadedFiles(component,event,helper);
    },
    EditDocumentInfo : function(component,event,helper) {
         var documentId = component.get("v.selectedDocId");
         var editName = component.get("v.selectedDocument");
                //component.set("v.files",result);
               // component.set("v.File_count",result.length);
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
                            helper.getuploadedFiles(component,event,helper);
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