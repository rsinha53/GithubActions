({
	
   doInit : function(component, event, helper) {
       helper.getMemberDetails(component, event, helper);
       helper.checkIfMobileDevice(component,event);
     },
  
   closeModel: function(component, event, helper) {
      var cmpEvent = component.getEvent("SNI_FL_MemberModelCloseEvt");
      cmpEvent.setParams({
            isModalOpen : false  });
      cmpEvent.fire();
   },
    
    uploadFile: function(component, event, helper) {
     //todo
   },
    
    handleSectionToggle :  function(component, event, helper) {
       var sectionName= event.getParam('openSections');
       if(sectionName=='A'){
           helper.getFiles(component, event, helper);
        }
    },
    
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");  
        var ids=new Array();
        for (var i= 0 ; i < uploadedFiles.length ; i++){
            ids.push(uploadedFiles[i].documentId);
        }
        var uploadedFileIds = JSON.stringify(ids);
        //Added by ankit
        var memname = component.get('v.memberRecord').memberName;
        console.log('membername'+memname);
        //End -----
        
        var memberId = component.get("v.recordId");
        console.log('memberId'+memberId);
        console.log('uploadedFileIds'+uploadedFileIds);
        var action = component.get("c.getUpdatedDocs");
        action.setParams({  
            "uploadedFilesIds": uploadedFileIds,
            "memberId": memberId,
            "membername":memname
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();
            if(state=='SUCCESS'){  
                var memberDocList = response.getReturnValue();
                for(var i = 0; i < memberDocList.length; i++){
						var options = { year: 'numeric', month: 'long', day: 'numeric' };
                        var tempDate = new Date(memberDocList[i].LastModifiedDate);
						memberDocList[i].LastModifiedDate = tempDate.toLocaleDateString("en-US", options);
					}
                component.set('v.memberDocuments', memberDocList);
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
    
    clickDownload: function(component, event, helper){
        var curTarget = event.currentTarget;
        var dataEle = curTarget.getAttribute('data-index');
        var memberDocList = component.get("v.memberDocuments");
        var documentId = memberDocList[dataEle].Id; 
        
        var actionDownload = component.get('c.downloadFile');
        actionDownload.setParams({
            "downloadAttachmentId": documentId
        });
        
        actionDownload.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": result
                });
                
                urlEvent.fire();
            }
        });
        $A.enqueueAction(actionDownload);
    },
    
    editDoc: function(component, event, helper) {
        var curTarget = event.currentTarget;
        var dataEle = curTarget.getAttribute('data-index');
        var memberDocList = component.get('v.memberDocuments');
        var documentId = memberDocList[dataEle].Id; 
        var documentName = memberDocList[dataEle].Title;
        
        component.set('v.selectedDocId', documentId);
        component.set('v.selectedDocName', documentName);
        component.set('v.isDocCnfrmModalOpen', true);
    },
    
    saveDoc: function(component, event, helper) {
        var action = component.get('c.editFile');
        var documentId = component.get('v.selectedDocId');
        var documentName = component.get('v.selectedDocName');
        action.setParams({
            "documentId":documentId,
            "documentName":documentName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                component.set('v.isDocCnfrmModalOpen', false);
                helper.getMemberDetails(component, event, helper);
            } else{
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    closeDoc : function(component, event, helper){
        component.set("v.isDocCnfrmModalOpen",false);
    },
    
    clickRemove : function(component, event, helper){
        var curTarget = event.currentTarget;
        var dataEle = curTarget.getAttribute('data-index');
        var memberDocList = component.get('v.memberDocuments');
        var documentId = memberDocList[dataEle].Id; 
        var documentName = memberDocList[dataEle].Title;
        component.set("v.selectedDocId",documentId);
        component.set("v.selectedDocName",documentName);
        component.set("v.isRemoveCnfrmModalOpen",true);
    },
    
    closeWarning : function(component, event, helper){
	    component.set("v.isRemoveCnfrmModalOpen",false);
    },
    
    deleteFile : function(component, event, helper){
        var action = component.get("c.deleteSelectedFile");
        var documentId =component.get("v.selectedDocId");
        action.setParams({
            "sdocumentId":documentId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                component.set("v.isRemoveCnfrmModalOpen",false);
                helper.getMemberDetails(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    }
   
})