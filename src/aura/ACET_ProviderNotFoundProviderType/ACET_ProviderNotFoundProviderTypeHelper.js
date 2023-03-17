({
    addDefaultAutodoc: function (cmp) {
        var contactDetails = cmp.get("v.contactDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var otherDetails = cmp.get("v.otherDetails");
        var memberDetails = cmp.get("v.memberDetails");
        console.log('contact details: '+JSON.stringify(contactDetails));
        console.log('provider details: '+JSON.stringify(providerDetails));

        cmp.set("v.isDefaultGenerated",true);

        // Contact Details
        if (contactDetails != null ) {
            console.log(contactDetails.componentHeaderVal);
            contactDetails.componentName = contactDetails.componentName + contactDetails.componentHeaderVal;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), contactDetails);
        }
        if (otherDetails != null) {
            console.log(otherDetails.componentHeaderVal);
            otherDetails.componentName = otherDetails.componentName + otherDetails.componentHeaderVal;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), otherDetails);
        }
        if (providerDetails != null) {
            providerDetails.componentName = providerDetails.componentName + providerDetails.componentHeaderVal;
            console.log(providerDetails.componentHeaderVal);
             _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), providerDetails);
        }

        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
        }
        
        //US2820034 - Auto doc Reporting Member Not Found - adding function with isReportable field
        function fieldDetails(c, dc, sc, fn, fv, ft, ir) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = ir; 
        }
    },
    createPreview: function (cmp) {
        var interactionCard = cmp.get("v.interactionCard"); // US3691217 - Thanish - 18th Aug 2021
        if(!cmp.get("v.isDefaultGenerated")){
            this.addDefaultAutodoc(cmp);
            console.log("Default AutoDoc Done");
        }
        var selectedRadio = cmp.get("v.selectedRadioOption");
        if(selectedRadio == 'Yes'){
            var providerTypeCard = new Object();
            providerTypeCard.type = 'card';
            providerTypeCard.componentName = 'Provider Type';
            providerTypeCard.noOfColumns = 'slds-size_6-of-12';
            providerTypeCard.componentOrder = 4;
            providerTypeCard.uniqueId = selectedRadio;
            providerTypeCard.caseItemsExtId = !$A.util.isUndefinedOrNull(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '--'; // US3691217 - Thanish - 18th Aug 2021
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'Is the provider a Medical Doctor/Facility ?', 'Yes', 'outputText', true));
            
            if (cmp.get("v.selectedRadioOption2") == 'Yes') {
                cardData.push(new fieldDetails(true, false, true, 'Is the Provider waiting to become INN or stating they should be showing as INN ?', 'Yes', 'outputText', true));
            } 
            if (cmp.get("v.selectedRadioOption2") == 'No') {
                cardData.push(new fieldDetails(true, false, true, 'Is the Provider waiting to become INN or stating they should be showing as INN ?', 'No', 'outputText', true));
            }
            providerTypeCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), providerTypeCard);
            
        }
        if(selectedRadio == 'No'){
            var providerTypeCard = new Object();
            providerTypeCard.type = 'card';
            providerTypeCard.componentName = 'Provider Type';
            providerTypeCard.noOfColumns = 'slds-size_6-of-12';
            providerTypeCard.componentOrder = 4;
            providerTypeCard.uniqueId = selectedRadio;
            providerTypeCard.caseItemsExtId = !$A.util.isUndefinedOrNull(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '--'; // US3691217 - Thanish - 18th Aug 2021
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'Is the provider a Medical Doctor/Facility ?', 'No', 'outputText', true));
            providerTypeCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), providerTypeCard);
            
        }
        // Filter proper one
        var selectedAutoDoc = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev", selectedAutoDoc);
        
        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
        }
        
        function fieldDetails(c, dc, sc, fn, fv, ft, ir) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = ir; 
        } 
    },
    fireProviderTypeValidations: function(cmp){
        console.log('Validating...');
        var isCheckedFirstRadio = cmp.find('providerTypeRadio');
        var errorMessage = 'Complete this field.';
        var isValid = false;
        var selectedRadioOption = cmp.get("v.selectedRadioOption");
        var selectedRadioOption2 = cmp.get("v.selectedRadioOption2")

        if(selectedRadioOption){
            if(selectedRadioOption == 'Yes'){
                //checking the second radio is valid or not
                var isCheckedSecondRadio = cmp.find('providerTypeRadio2');
                if(isCheckedSecondRadio != undefined){
                    if(selectedRadioOption2 == 'Yes' || selectedRadioOption2 == 'No'){
                        console.log('Validity: '+isCheckedSecondRadio.checkValidity());
                        isValid=true;
                        isCheckedFirstRadio.setCustomValidity('');
                		isCheckedFirstRadio.reportValidity();
                        isCheckedSecondRadio.setCustomValidity('');
                        isCheckedSecondRadio.reportValidity();
                    }
                    else{
                        isCheckedFirstRadio.setCustomValidity('');
                		isCheckedFirstRadio.reportValidity();
                        isCheckedSecondRadio.setCustomValidity(errorMessage);
                        isCheckedSecondRadio.reportValidity();
                    } 
                    
                }else{
                    isCheckedFirstRadio.setCustomValidity(errorMessage);
                    isCheckedFirstRadio.reportValidity();
                }    
            }
            else if(selectedRadioOption == 'No'){
                isCheckedFirstRadio.setCustomValidity('');
                isCheckedFirstRadio.reportValidity();
                isValid = true;
            }else{
                isCheckedFirstRadio.setCustomValidity(errorMessage);
                isCheckedFirstRadio.reportValidity();
            }
        }else{
            isCheckedFirstRadio.setCustomValidity(errorMessage);
            isCheckedFirstRadio.reportValidity();
        }
        return isValid;
    }
})