({
    createAddInfoData : function(component, event, helper) {
        
        let claimSvcLineDtl = component.get("v.serviceLineDtls");
        var  selectedSvcLineDtlCard = component.get("v.selectedSvcLineDtlCard");
        console.log("Testing@@"+ JSON.stringify(selectedSvcLineDtlCard));
        console.log("Testing@@"+ JSON.stringify(claimSvcLineDtl));
        var interaction = component.get("v.interactionId")
        var originalCompName = selectedSvcLineDtlCard.componentName;
        var derivedCompName = originalCompName.substring(0, originalCompName.lastIndexOf(':'));
        var claimNumber = originalCompName.substring(originalCompName.lastIndexOf(':') + 1, originalCompName.length);
        component.set("v.derivedCompName", derivedCompName);

        // Added by Jay

        var remarkCodes = [];
        remarkCodes = claimSvcLineDtl.rcode.split(",");

        for( var i = 0; i< remarkCodes.length; i++)
            remarkCodes[i] = remarkCodes[i].replace(/\s/g,'');

          // remarkCodes = remarkCodes.filter(e => e !== '--');
           var action = component.get("c.getToolTips");
           action.setParams({rcodes: remarkCodes });
           action.setCallback(this,function(data){
            var tooltips = data.getReturnValue();
            component.set("v.toolTips",data.getReturnValue())

            let claimSvcLineDtl = component.get("v.serviceLineDtls");

            var card = new Object();
            var isRemark = true;
            card.componentName = selectedSvcLineDtlCard.componentName;
            card.componentOrder = selectedSvcLineDtlCard.componentOrder;
            card.type = selectedSvcLineDtlCard.type;
            card.noOfColumns = selectedSvcLineDtlCard.noOfColumns;

            // US3653565
            card.reportingHeader = 'Service Line Detail';
            card.caseItemsExtId = claimNumber.trim();

            var cardData = [];


            for( var i = 0; i< tooltips.length;i++)
            {

            var cardDataDtl1 = {};
            var cardDataDtl2 = {};
            var cardDataDtl3 = {};
            var cardDataDtl4 = {};
            var cardDataSpace = {};

            cardDataSpace.fieldType = 'emptySpace';


           for( var j = 0;j<selectedSvcLineDtlCard.cardData.length;j++)
           {
               var codes = selectedSvcLineDtlCard.cardData[j].fieldValue.split(' - ')[0];
               var parentName = '';
               if(! card.componentName.includes('Interest:')){
                  parentName = selectedSvcLineDtlCard.cardData[j].parentName;
                  }
               console.log("codes@@"+ codes);
               //if(selectedSvcLineDtlCard.cardData[j].fieldValue.includes(tooltips[i].Value__c))

               if(! card.componentName.includes('Interest:') && parentName === 'Remark' && isRemark){
                   var cardDataDtl = {};
                   cardDataDtl.checked = false;
                   cardDataDtl.defaultChecked = false;
                   cardDataDtl.fieldType = "noFieldName";
                   cardDataDtl.fieldValue = "Processing/Denial Codes(s)";
                   cardDataDtl.isReportable = true;
                   cardDataDtl.showCheckbox = true;
                   cardDataDtl.parentName = "Remark";
                   cardDataDtl.isParent = true;
                   cardDataDtl.isChild = false;
                   cardDataDtl.fieldValueStyle = "font-weight: bold;";
                        cardDataDtl.reportingFieldName = "Remark Code/Desc";
                   cardData.push(cardDataDtl);
                   isRemark = false;
               }

               if(parentName === 'ovrcd'){
                   var cardDataDtl = {};
                   cardDataDtl.checked = false;
                   cardDataDtl.defaultChecked = false;
                   cardDataDtl.fieldType = "noFieldName";
                   cardDataDtl.fieldValue = "Override Codes(s)";
                   cardDataDtl.isReportable = true;
                   cardDataDtl.showCheckbox = true;
                   cardDataDtl.parentName = "ovrcd";
                   cardDataDtl.isParent = true;
                   cardDataDtl.isChild = false;
                        cardDataDtl.reportingFieldName = "Remark Code/Desc";
                   cardDataDtl.fieldValueStyle = "font-weight: bold;";
                   cardData.push(cardDataDtl);
               }

                    if (codes == tooltips[i].Value__c) {
                        selectedSvcLineDtlCard.cardData[j].isReportable = true;
                        selectedSvcLineDtlCard.cardData[j].reportingFieldName = "Remark Code/Desc";
                  cardData.push(selectedSvcLineDtlCard.cardData[j]);
                  break;

               }
           }


            var url = "mailto:ACETSAEBUSINESS@ds.uhc.com?subject=SPIRE Tool Tip Research Needed&body=Interaction Number ["+interaction+"]%0D%0ARemark Code - "+tooltips[i].Value__c+"%0D%0ATool Tip Type%0D%0AValue";
            var href = 'No tool tip exists for this remark code. <a href="'+url+'">Click here</a> to create a tool tip request.';

            cardDataDtl2.checked = false;
            cardDataDtl2.defaultChecked = false;
            cardDataDtl2.fieldType = "unescapedHtml";
            cardDataDtl2.fieldValue = "TIP: "+ ($A.util.isEmpty(tooltips[i].Tip__c) ? href : tooltips[i].Tip__c );
                cardDataDtl2.reportingFieldName = 'TIP';
            cardDataDtl2.isReportable = true;
            cardDataDtl2.showCheckbox = true;
            cardDataDtl2.parentName = parentName;
            cardDataDtl2.isParent = false;
            cardDataDtl2.isChild = true;
            cardData.push(cardDataDtl2);


            cardDataDtl3.checked = false;
            cardDataDtl3.defaultChecked = false;
            cardDataDtl3.fieldName = "SOP: "
                cardDataDtl3.reportingFieldName = 'SOP';
            cardDataDtl3.fieldValueStyle = "display: inline-flex !important;font-size:14px";
            cardDataDtl3.fieldType = ($A.util.isEmpty(tooltips[i].SOP_or_Document_Link__c) ? "unescapedHtml" : "SingleLineUrl");
            cardDataDtl3.fieldValue =  ($A.util.isEmpty(tooltips[i].SOP_or_Document_Name__c) ? "SOP: --" : tooltips[i].SOP_or_Document_Name__c );
            cardDataDtl3.urlLabel = tooltips[i].SOP_or_Document_Name__c;
            cardDataDtl3.isReportable = true;
            cardDataDtl3.showCheckbox = true;
            cardDataDtl3.parentName = parentName;
            cardDataDtl3.isParent = false;
            cardDataDtl3.isChild = true;
            if(cardDataDtl3.fieldType == "unescapedHtml" )
            cardDataDtl3.fieldName = "";
            cardData.push(cardDataDtl3);
            component.set("v.SOPName",tooltips[i].SOP_or_Document_Name__c);
            card.cardData =cardData;

            }
            helper.hideSpinner(component, event, helper);
            component.set("v.cardAutoDocData",card);
        });
        $A.enqueueAction(action);

        // End of Addition
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (component, event, helper) {
        //alert('test');
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})