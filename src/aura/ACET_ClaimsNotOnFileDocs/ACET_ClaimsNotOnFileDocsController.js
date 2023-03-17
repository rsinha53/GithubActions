({
    onInit : function(component, event, helper) {
        var indexNameList=[];
        //indexNameList.push('U_Prov_attch');
        //indexNameList.push('u_cos_clmltr_mem_doc');
        //indexNameList.push('u_cos_clmltr_prov_doc');
        //helper.getClaimLetters(component, event, helper,indexNameList);
    },
    relatedDocDataChange : function(component, event, helper) {
        var indexNameList=[];
        //indexNameList.push('U_Prov_attch');
        indexNameList.push('u_cos_clmltr_mem_doc');
        indexNameList.push('u_cos_clmltr_prov_doc');
       // helper.getClaimLetters(component, event, helper,indexNameList);
    },
    navigateTodoc360GlobalURL: function (cmp, event, helper) {
        helper.navigateTodoc360GlobalURL(cmp, event, helper);          
    },
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
            if(!component.get("v.isDoc360Called")){
                
                var indexNameList=[];
                indexNameList.push('u_cos_clmltr_mem_doc');
                indexNameList.push('u_cos_clmltr_prov_doc');
                component.set("v.isDoc360Called",true);
                helper.showSpinner(component, event, helper);
                helper.getClaimLetters(component, event, helper,indexNameList);
            }
            
        } else {
            helper.hideSpinner(component, event, helper);
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    
    getSelectedRecords: function (component, event, helper) {
        helper.navigateTodoc360GlobalURL(component, event, helper);          
       /* var data = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        console.log("Row data "+ JSON.stringify(data) )

        let claimSvcLineDtl = {};//sravani start
        claimSvcLineDtl.line = data.rowColumnData[0].fieldValue;
        claimSvcLineDtl.v = data.rowColumnData[1].fieldValue;
        claimSvcLineDtl.code = data.rowColumnData[3].fieldValue;
        claimSvcLineDtl.rcode = data.rowColumnData[6].fieldValue;
        claimSvcLineDtl.processDt = data.rowColumnData[2].fieldValue;*/
       
    }
})