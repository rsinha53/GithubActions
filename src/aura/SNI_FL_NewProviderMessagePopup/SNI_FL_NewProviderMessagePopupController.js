({
    closeModel : function(component, event, helper) {
        component.set("v.IsOpenNewProviderMsg",false); 
        
        
    },
    
    handleUploadFinished : function(component, event, helper) { 
        
        component.set("v.fileName", '');
        component.set("v.attachId", null);
        let uploadFiles = event.getParam("files");
        let documentId = uploadFiles[0].documentId;
        let fileName = uploadFiles[0].name;
        
        let fileId = component.get("v.attachId"); 
        component.set("v.fileName", fileName);
        component.set("v.attachId", documentId);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File(s)" + fileName + "Uploaded Successfully",
            "type": "success"
        });
        toastEvent.fire();
    },
    handleMulticmpEvent : function(component, event, helper) {
        
        let message = event.getParam("listOfSearchRecordsEvt");
        component.set("v.listOfSearchRecords", message);
        if(message == undefined){
            
            let childCmp = component.find("programs");
            let childCmp1 = component.find("related");
            let childCmp2 = component.find("To");
            childCmp.clearFunction();
            childCmp1.clearFunction();
            childCmp2.clearFunction();
        }
    },

    //Sameera - ACDC  US3128709
    sendMessage : function(component, event, helper) {   
       
        let providerGroup = component.get('v.selectedFamilyRecord');
        let providerAffliation = component.get('v.selectProviderAfliation')
        let recipients = component.get('v.selectRecipients');
        let isBackupAgentView = component.get("v.isBackupAgentView");
        let familyId = component.get("v.familyId");
        let relatedTOUsers = component.get('v.selectRelatedToUser'); 
        let relatedToUsers;

        if(familyId){
            relatedToUsers = {
                "label":relatedTOUsers.Name,
                "value":relatedTOUsers.Id
            }
        }else{
            relatedToUsers = relatedTOUsers; 
        }

        let selectedTabId = component.get("v.selectedTabId");
        let messageBody = component.find("number").get("v.value");
        let toastEvent = $A.get("e.force:showToast");
        let subject = component.get("v.subjectValue");
        let fileId = component.get("v.attachId");
        let spinner = component.find("mySpinner");
        
    debugger;
        if(providerGroup){
            if(providerAffliation){
                
                //backup advisor
                if(!isBackupAgentView){
                    if(recipients.length>1){
                        if(messageBody){
                            if(messageBody.length < 131072){
                                    
                                 
                                let dataObject = {
                                    providerGroup,
                                    providerAffliation,
                                    relatedToUsers,
                                    recipients,
                                    isBackupAgentView,
                                    familyId,
                                    selectedTabId,
                                    messageBody,
                                    subject,
                                    fileId
                                }
    
                                $A.util.removeClass(spinner, "slds-hide");
                                helper.createMessage(component,event,dataObject);
    
                            }else{
                                toastEvent.setParams({
                                    "title": "Warning!",
                                    "message": "Limit Exceeded...!!"
                                });
                                toastEvent.fire();
                            }
                        }else if(fileId){
                            
                            messageBody='Posted a file';
                            let dataObject = {
                                providerGroup,
                                providerAffliation,
                                relatedToUsers,
                                recipients,
                                isBackupAgentView,
                                familyId,
                                selectedTabId,
                                messageBody,
                                subject,
                                fileId
                            }
                            $A.util.removeClass(spinner, "slds-hide");
                            helper.createMessage(component,event,dataObject);
    
                        }else{
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Please write some text to send message"
                            });
                            toastEvent.fire();
                        }
                    }else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please select a recipient"
                        });
                        toastEvent.fire();
                    }
                }
                //person account level
                else if(familyId){
                    
                    if(recipients.length>0){
                        if(messageBody){
                            if(messageBody.length < 131072){
                                    
                                let dataObject = {
                                    providerGroup,
                                    providerAffliation,
                                    relatedToUsers,
                                    recipients,
                                    isBackupAgentView,
                                    familyId,
                                    selectedTabId,
                                    messageBody,
                                    subject,
                                    fileId
                                }
    
                                $A.util.removeClass(spinner, "slds-hide");
                                helper.createMessage(component,event,dataObject);
    
                            }else{
                                toastEvent.setParams({
                                    "title": "Warning!",
                                    "message": "Limit Exceeded...!!"
                                });
                                toastEvent.fire();
                            }
                        }else if(fileId){
                            
                            messageBody='Posted a file';
                            let dataObject = {
                                providerGroup,
                                providerAffliation,
                                relatedToUsers,
                                recipients,
                                isBackupAgentView,
                                familyId,
                                selectedTabId,
                                messageBody,
                                subject,
                                fileId
                            }
                            $A.util.removeClass(spinner, "slds-hide");
                            helper.createMessage(component,event,dataObject);
    
                        }else{
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Please write some text to send message"
                            });
                            toastEvent.fire();
                        }
                    }else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please select a recipient"
                        });
                        toastEvent.fire();
                    }
                }
                //advisor level
                else{
                    if(recipients.length>0){
                        if(messageBody){
                            if(messageBody.length < 131072){
                                    
                                
                                let dataObject = {
                                    providerGroup,
                                    providerAffliation,
                                    relatedToUsers,
                                    recipients,
                                    isBackupAgentView,
                                    familyId,
                                    selectedTabId,
                                    messageBody,
                                    subject,
                                    fileId
                                }
    
                                $A.util.removeClass(spinner, "slds-hide");
                                helper.createMessage(component,event,dataObject);
    
                            }else{
                                toastEvent.setParams({
                                    "title": "Warning!",
                                    "message": "Limit Exceeded...!!"
                                });
                                toastEvent.fire();
                            }
                        }else if(fileId){
                            
                            messageBody='Posted a file';
                            let dataObject = {
                                providerGroup,
                                providerAffliation,
                                relatedToUsers,
                                recipients,
                                isBackupAgentView,
                                familyId,
                                selectedTabId,
                                messageBody,
                                subject,
                                fileId
                            }
                            $A.util.removeClass(spinner, "slds-hide");
                            helper.createMessage(component,event,dataObject);
    
                        }else{
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Please write some text to send message"
                            });
                            toastEvent.fire();
                        }
                    }else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please select a recipient"
                        });
                        toastEvent.fire();
                    }
                }
                
            }else{
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please select a program"
                });
                toastEvent.fire();
            }
        }else{
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select a provider group"
            });
            toastEvent.fire();
        }
        
        
    },
    handleShowCurtain: function(component, event, helper){
        component.set('v.showOnclickCurtain',event.getParam("showOnclickCurtain"));
    },
    hideDropdowns: function(component, event, helper){
        component.set('v.showOnclickCurtain',false);
    },
})