({
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    closePopUpWindow: function(component, event){
        $A.get("e.force:closeQuickAction").fire();
    },
    attachCaseItems: function(component, event, helper){
        helper.showSpinner(component, event);
        var wrap =  component.get("v.cWrap");
        var action = component.get("c.attachCaseItem");
        action.setParams({ 
            "caseId" : component.get("v.recordId"),
            "caseNum" : wrap.caseRec.CaseNumber
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var resp = response.getReturnValue();
                console.log('result==>'+JSON.stringify(resp.result));
                console.log('excelStr==>'+JSON.stringify(resp.excelStr));
                if(resp.result=='SUCCESS'){
                    
                    helper.showToast(component, event,'Success','success', 'Attachment added successfully');
                    var strFile = "data:application/excel;base64,"+resp.excelStr;
                    helper.downloadReport(strFile, wrap.caseRec.CaseNumber);
                    helper.closePopUpWindow(component, event); 
                }else{
                    helper.showToast(component, event,'Error','error',result);
                }
            }
            helper.hideSpinner(component,event);
        });
        $A.enqueueAction(action);
    },
    
    downloadReport: function(strFile, caseNumber){
        var hiddenElement = document.createElement('a');
        hiddenElement.href = strFile;
        hiddenElement.target = '_self';
        hiddenElement.download = 'Case Items - '+caseNumber+'.xls';
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    },
})