({
	doinit : function(component, event, helper) {
        debugger;
       helper.helperInitMethod(component, event, helper);
    }, 
    userInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.currentUser",userId);
    },
    clickRemove : function(component, event, helper){
	    debugger;
        var dataEle = event.target.getAttribute("data-selected-Index");
        var FamilySlected = component.get("v.isFamilySec");
        var familydocwrap = component.get("v.familydocwrap");
        var documentId ='';
        var documentName = '';
        if(FamilySlected){
           documentId = familydocwrap.familyDocuments[dataEle].contdoc.Id;
           documentName = familydocwrap.familyDocuments[dataEle].contdoc.Title;
        }
        else{
           if(dataEle != ''){
           var searchString = dataEle.split("-");
           if(searchString != ''){
           var memDoc = Number(searchString[0]);
           var documentSel = Number(searchString[1]);
           }
           documentId = familydocwrap.membDocwrapper[memDoc].membDocuments[documentSel].contdoc.Id;
           documentName = familydocwrap.membDocwrapper[memDoc].membDocuments[documentSel].contdoc.Title;
           }
        }
        component.set("v.selectedDocId",documentId);
        component.set("v.selectedDocName",documentName);
        component.set("v.isRemoveCnfrmModalOpen",true);
    },
    closeWarning : function(component, event, helper){
	    component.set("v.isRemoveCnfrmModalOpen",false);
    },
    deleteFile : function(component, event, helper){
        debugger;
        var action = component.get("c.deleteFiles");
        var documentId =component.get("v.selectedDocId");
        console.log('documentId'+documentId);
        action.setParams({
            "sdocumentId":documentId            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                component.set("v.isRemoveCnfrmModalOpen",false);
                helper.helperInitMethod(component, event, helper);
            }
        });
        $A.enqueueAction(action); 
    },
	Downloadfile: function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var FamilySlected = component.get("v.isFamilySec");
        var familydocwrap = component.get("v.familydocwrap");
        var documentId ='';
        if(FamilySlected){
           documentId = familydocwrap.familyDocuments[dataEle].contdoc.Id;
        }
        else{
           if(dataEle != ''){
           var searchString = dataEle.split("-");
           if(searchString != ''){
           var memDoc = Number(searchString[0]);
           var documentSel = Number(searchString[1]);
           }
           documentId = familydocwrap.membDocwrapper[memDoc].membDocuments[documentSel].contdoc.Id;       
           }
        }
        console.log('documentId'+documentId);
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
        
        
    },
    Editdoc : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var FamilySlected = component.get("v.isFamilySec");
        var familydocwrap = component.get("v.familydocwrap");
        var documentId ='';
        var documentName = '';
        if(FamilySlected){
           documentId = familydocwrap.familyDocuments[dataEle].contdoc.Id;
           documentName = familydocwrap.familyDocuments[dataEle].contdoc.Title;
        }
        else{
           if(dataEle != ''){
           var searchString = dataEle.split("-");
           if(searchString != ''){
           var memDoc = Number(searchString[0]);
           var documentSel = Number(searchString[1]);
           }
           documentId = familydocwrap.membDocwrapper[memDoc].membDocuments[documentSel].contdoc.Id;
           documentName = familydocwrap.membDocwrapper[memDoc].membDocuments[documentSel].contdoc.Title;
           }
        }
        component.set("v.selectedDocId",documentId);
        component.set("v.selectedDocName",documentName);
        component.set("v.isDocCnfrmModalOpen",true);
    },
    closeDoc : function(component, event, helper){
        component.set("v.isDocCnfrmModalOpen",false);
    },
    saveDoc : function(component, event, helper){
        var action = component.get("c.editFile");
        var documentId =component.get("v.selectedDocId");
        var documentName =component.get("v.selectedDocName");
        console.log('selectedDocName'+documentName);
        action.setParams({
            "documentId":documentId,
			"documentName":documentName            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){
                component.set("v.isDocCnfrmModalOpen",false);
                helper.helperInitMethod(component, event, helper);
            }else{
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }  
        });  
        $A.enqueueAction(action); 
    }
})