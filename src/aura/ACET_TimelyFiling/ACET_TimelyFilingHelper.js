({
    getTimefillSummary : function(component, event, helper, claimNumber) {
        var card = new Object();
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
        card.componentName = "Timely Filing: "+claimNumber;
        card.componentOrder = 8+(maxAutoDocComponents*currentIndexOfOpenedTabs);
        // US3653575
        card.reportingHeader = 'Timely Filing';
        card.caseItemsExtId = claimNumber;
        card.type = "card";
        card.noOfColumns = "slds-size_4-of-12";

        var cardData = [];

        var cardDataDtl1 = {};
        cardDataDtl1.checked = false;
        cardDataDtl1.defaultChecked = false;
        cardDataDtl1.fieldName="Provider TFL";
        cardDataDtl1.fieldType = "outputText";
        cardDataDtl1.fieldValue = "--";

        cardDataDtl1.isReportable = true;
        cardDataDtl1.showCheckbox = true;
        cardData.push(cardDataDtl1);

         var cardDataDtl2 = {};
        cardDataDtl2.checked = false;
        cardDataDtl2.defaultChecked = false;
        cardDataDtl2.fieldName="TFL Code";
        cardDataDtl2.fieldType = "outputText";
        cardDataDtl2.fieldValue = "--";

        cardDataDtl2.isReportable = true;
        cardDataDtl2.showCheckbox = true;
        cardData.push(cardDataDtl2);

        var cardDataDtl3 = {};
        cardDataDtl3.checked = false;
        cardDataDtl3.defaultChecked = false;
        cardDataDtl3.fieldName="TFL Date";
        cardDataDtl3.fieldType = "outputText";
        cardDataDtl3.fieldValue = "--";

        cardDataDtl3.isReportable = true;
        cardDataDtl3.showCheckbox = true;
        cardData.push(cardDataDtl3);

         card.cardData =cardData;

        console.log("Test date"+JSON.stringify(card));
        component.set("v.timlyFillSummary",card);
        // US3474282 - Thanish - 19th Jul 2021
        helper.hideSpinner(component, event, helper);
    },
    //Added by Mani --- Start
    getTimelyFillingDetails: function (component, event, helper){
        //alert('test');
        var firstSrvDate = component.get("v.firstSrvDate");
        var ContractorID = component.get("v.ContractorID");
        var platform = component.get("v.platform");
        var claimInput = component.get("v.claimInput");
        //alert(ContractorID);
        console.log("ContractorID--"+ContractorID);
        console.log("firstSrvDate--"+firstSrvDate);
        var action = component.get('c.getTimelyFillingDetails');
        action.setParams({
            "controctorID":ContractorID,
            "firstSrvDate":firstSrvDate,
            "Platform":platform,
            "ClaimNumber": claimInput.claimNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data.statusCode==200){ //added by sravani for Error code Handling
                console.log("all data ", JSON.stringify(data));
                component.set("v.timlyFillSummary",data.timelyFillingSummry);
                //KJ multiple tabs autodoc component order begin
                var timlyFillSummary = component.get("v.timlyFillSummary");
                var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
                var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
                timlyFillSummary.componentOrder = timlyFillSummary.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
                component.set("v.timlyFillSummary",timlyFillSummary);
                //KJ multiple tabs autodoc component order end
                }
                 // added sravani for Error code handling
                else{
                     this.showToastMessage("Error!",data.message, "error", "dismissible", "10000");
                }
            }
            else if (state === "INCOMPLETE") {}
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            // US3474282 - Thanish - 19th Jul 2021
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    getContractorID: function (component, event, helper){
        helper.showSpinner(component, event, helper);
        var taxID= component.get("v.taxId");
        var ProviderID= component.get("v.providerId");
        var marketType= component.get("v.marketType");
        var marketSite= component.get("v.marketSite");
        var productCode= component.get("v.productCode");
        var platForm = component.get("v.platform");
        console.log("platForm@@@@@"+platForm);
        if(platForm == "UNET"){
            console.log("taxID/ProviderID/"+taxID+"/"+ProviderID+"/"+marketType+"/"+marketSite+"/"+productCode);
            var action = component.get('c.getControctorDetails');
            action.setParams({
                "taxId":taxID,
                "providerId":ProviderID,
                "marketType":marketType,
                "marketSite":marketSite,
                "productCode":productCode
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state@@@' + state);
                if (state == "SUCCESS") {
                    var data = response.getReturnValue();
                    if(data.statusCode == 200){
                        console.log("**104***"+data);
                        component.set("v.ContractorID",data.message);
                        component.set("v.webService",true);
                    }
                    // added sravani for Error code handling
                    else{
                        this.showToastMessage("Error!",data.message, "error", "dismissible", "10000");
                    }
                }
                else if (state === "INCOMPLETE") {}
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("error :"+errors[0].message);
                            }
                        }
                        component.set("v.ContractorID",'');
                        component.set("v.webService",false);
                    }
                // US3474282 - Thanish - 19th Jul 2021
                this.getCmpDetails(component, event, helper);
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.ContractorID",'');
            component.set("v.webService",false);
            // US3474282 - Thanish - 19th Jul 2021
            this.getCmpDetails(component, event, helper);
        }
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
    },

    //Added by mani -- End

     showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },

    // US3474282 - Thanish - 19th Jul 2021
    getCmpDetails: function(component, event, helper){
        var webService = component.get("v.webService");
        var ContractorID = component.get("v.ContractorID");
        var claimInput = component.get("v.claimInput");
        var claimNumber = claimInput.claimNumber;
        if(webService && (! $A.util.isUndefinedOrNull(ContractorID) || ! $A.util.isEmpty(ContractorID))){
            helper.getTimelyFillingDetails(component, event, helper);
        }else{
            helper.getTimefillSummary(component, event, helper, claimNumber);
        }
    }
})