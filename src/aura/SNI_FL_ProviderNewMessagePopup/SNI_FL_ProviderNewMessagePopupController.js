({
    
    closeModel : function(component, event, helper) {
        component.set("v.IsOpenNewMsg",false); 
    },
    
    handleUploadFinished : function(component, event, helper) { 
        
        component.set("v.fileName", '');
        component.set("v.attachId", null);
        var uploadFiles = event.getParam("files");
        var documentId = uploadFiles[0].documentId;
        var fileName = uploadFiles[0].name;
        
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

    fileUploadClick: function(component, event, helper) {
        component.set("v.fileName", '');
    },
    
    handleMulticmpEvent : function(component, event, helper) {
        
        var message = event.getParam("listOfSearchRecordsEvt");
        component.set("v.listOfSearchRecords", message);
        if(message == undefined){
            var childCmp1 = component.find("programs");
            var childCmp2 = component.find("to");
            childCmp1.clearFunction();
            childCmp2.clearFunction();
        }
    },

    //Nanthu - ACDC  US3128774
    sendMessage : function(component, event, helper) {   
        
        let providerAffliation = component.get('v.providerAffliationID')
        let relatedToUsers = component.get('v.selectRelatedToUser');
        let recipients = component.get('v.selectRecipients');
        let desktopViewMessage = component.find("desktopBody").get("v.value");
        let mobileViewMessage = component.find("number").get("v.value");
        let toastEvent = $A.get("e.force:showToast");
        let subject = component.get("v.subjectValue");
        let fileId = component.get("v.attachId");
        let spinner = component.find("mySpinner");
        let isFLPovider = true;
        let messageBody;
        
        if($A.util.isUndefinedOrNull(desktopViewMessage)){
            messageBody = mobileViewMessage; 
        }else{
            messageBody = desktopViewMessage; 
        }
            
        if(recipients.length>0){
            if(messageBody){
                if(messageBody.length < 131072){
                    let dataObject = {
                        providerAffliation,
                        relatedToUsers,
                        recipients,
                        messageBody,
                        subject,
                        fileId,
                        isFLPovider
                    }

                    $A.util.removeClass(spinner, "slds-hide");
                    helper.createMessage(component,event,dataObject);

                } else{
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Limit Exceeded...!!"
                    });
                    toastEvent.fire();
                }
            } else if(fileId){
                messageBody='Posted a file';
                let dataObject = {
                    providerAffliation,
                    relatedToUsers,
                    recipients,
                    messageBody,
                    subject,
                    fileId,
                    isFLPovider
                }
                $A.util.removeClass(spinner, "slds-hide");
                helper.createMessage(component,event,dataObject);
            } else{
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please write some text to send message"
                });
                toastEvent.fire();
            }
        } else{
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select a recipient"
            });
            toastEvent.fire();
        }
    }
})