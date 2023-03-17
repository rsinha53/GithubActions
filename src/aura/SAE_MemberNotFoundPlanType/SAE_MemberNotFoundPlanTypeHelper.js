({
    openSaveCaseHelper: function(component, event, helper, isRoute) {
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
        var IsValidareSuccess = helper.fireSaveCaseValidations(component, event, helper);
        if (!IsValidareSuccess) {
            return false;
        }
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - END
        
        // US2119580 - Thanish - 26th Nov 2019 - passing external id of case item as Tax ID
        var cWrapper = component.get("v.caseWrapper");
        
        //Set autodoc
        // Special case - should not be followed in other places
        helper.createPreview(component);
        var autoDoc = component.get("v.tableDetails_prev");
        cWrapper.savedAutodoc = JSON.stringify(autoDoc);
        
        //US3376219 - Sravan - Start
        var planType = component.get("v.planType");
        if(planType == 'Medicaid'){
            helper.getMemberNotFoundDetails(component, event, helper);
        }
        //US3376219 - Sravan - End
        
        //DefaultCase item
        var caseItem = new Object();
        caseItem.uniqueKey = component.get("v.planType");
        caseItem.isResolved = component.get("v.isResolved");;
        caseItem.topic = 'Member Not Found';//US3071655 - Sravan
        var caseItemList = [];
        caseItemList.push(caseItem);
        cWrapper.caseItems = caseItemList;
        
        //cWrapper.TaxId = component.find("provStateId").get("v.value");
        //DE3151146 - MNF External id should be plantype
        cWrapper.mnfExternalId = component.get("v.planType");
        component.set("v.caseWrapper", cWrapper);
        if(isRoute) {
            component.set("v.isModalOpen", true);   
        }
    },
    
    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    fireSaveCaseValidations: function(cmp, event, helper) {
        var planType = cmp.get('v.planType');
        var memberFound = cmp.find('memberFound');
        var GroupId = cmp.find('GroupId');
        var commercialAltID = cmp.find('commercialAltID');
        var MedicareId = cmp.find('MedicareId');
        var MedicaidId = cmp.find('MedicaidId');
        var MedicaidAddress = cmp.find('MedicaidAddress');
        var MedicaidZipCode = cmp.find('MedicaidZipCode');
        var BabyCIN = cmp.find('BabyCIN');
        var MotherCIN = cmp.find('MotherCIN');
        var FamilyID = cmp.find('FamilyID');
        var Gender = cmp.find('Gender');
        var IsValidareSuccess = false;

        if (planType == undefined || planType == '' || planType == 'None') {
            $A.util.addClass(cmp.find('provStateId'), 'slds-has-error');
            cmp.set('v.showPlanTypeError', true);
        } else {
            cmp.set('v.showPlanTypeError', false);
            $A.util.removeClass(cmp.find('provStateId'), 'slds-has-error');
            if (planType == 'Commercial') {
                var IsFaild = false;
                if (memberFound != undefined && !memberFound.checkValidity()) {
                    memberFound.reportValidity();
                    IsFaild = true;
                }
                if (GroupId != undefined && !GroupId.checkValidity()) {
                    GroupId.reportValidity();
                    IsFaild = true;
                }
                if (commercialAltID != undefined && !commercialAltID.checkValidity()) {
                    commercialAltID.reportValidity();
                    IsFaild = true;
                }
                if (!IsFaild) {
                    IsValidareSuccess = true;
                }
            } else if (planType == 'Medicare') {
                if (MedicareId.checkValidity()) {
                    IsValidareSuccess = true;
                } else {
                    MedicareId.reportValidity();
                }
            } else if (planType == 'Medicaid') {
                var IsFaild = false;
                if (!MedicaidId.checkValidity()) {
                    MedicaidId.reportValidity();
                    IsFaild = true;
                }
                if (!MedicaidAddress.checkValidity()) {
                    MedicaidAddress.reportValidity();
                    IsFaild = true;
                }
                if (!MedicaidZipCode.checkValidity()) {
                    MedicaidZipCode.reportValidity();
                    IsFaild = true;
                }
                var NewbornChkValue = cmp.get('v.NewbornChkValue');
                if (NewbornChkValue) {
                    if (!BabyCIN.checkValidity()) {
                        BabyCIN.reportValidity();
                        IsFaild = true;
                    }
                    if (!MotherCIN.checkValidity()) {
                        MotherCIN.reportValidity();
                        IsFaild = true;
                    }
                    if (!FamilyID.checkValidity()) {
                        FamilyID.reportValidity();
                        IsFaild = true;
                    }
                    if (!Gender.checkValidity()) {
                        Gender.reportValidity();
                        IsFaild = true;
                    }
                }
                if (!IsFaild) {
                    IsValidareSuccess = true;
                }
            } else {
                IsValidareSuccess = true;
            }
        }
        return IsValidareSuccess;
    },

    addDefaultAutodoc: function (cmp) {
        var contactDetails = cmp.get("v.contactDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var otherDetails = cmp.get("v.otherDetails");
        var memberDetails = cmp.get("v.memberDetails");

        cmp.set("v.isDefaultGenerated",true);

        // Contact Details
        if (contactDetails != null && cmp.get("v.isProviderSearchDisabled")) {
            var contactCard = new Object();
            contactCard.type = 'card';
            contactCard.componentName = 'Contact Name: ' + contactDetails.contactName;
            contactCard.noOfColumns = 'slds-size_4-of-12';
            contactCard.componentOrder = 1;
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'Contact Number', contactDetails.contactNumber, 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Ext', contactDetails.contactExt, 'outputText', true)); //US2820034 - adding isReportable - true
            contactCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), contactCard);
        } else {
            if (cmp.get("v.isOther")) {
                var otherCard = new Object();
                otherCard.type = 'card';
                otherCard.componentName = 'Other: ' + providerDetails.conName;
                otherCard.noOfColumns = 'slds-size_4-of-12';
                otherCard.componentOrder = 1;
                var cardData = [];
                cardData.push(new fieldDetails(true, false, true, 'Contact Type', providerDetails.contactType, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Contact Number', providerDetails.contactNumber, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Ext', providerDetails.contactExt, 'outputText', true)); //US2820034 - adding isReportable - true
                otherCard.cardData = cardData;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), otherCard);
            } else if (providerDetails != null) {
                var providerCard = new Object();
                providerCard.type = 'card';
                providerCard.componentName = 'Provider: ' + providerDetails.firstName + ' ' + providerDetails.lastName;
                providerCard.noOfColumns = 'slds-size_4-of-12';
                providerCard.componentOrder = 2;
                var cardData = [];
                cardData.push(new fieldDetails(true, false, true, 'Tax ID', providerDetails.taxId, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'CSP Provider ID', cmp.get("v.CSPProviderId"), 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Phone #', providerDetails.phone, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Contact Name', providerDetails.contactName, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Contact Number', providerDetails.contactNumber, 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Ext', providerDetails.contactExt, 'outputText', true)); //US2820034 - adding isReportable - true
                providerCard.cardData = cardData;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), providerCard);
            }
        }

        //member details
        if (memberDetails != null) {
            var memberCard = new Object();
            memberCard.type = 'card';
            memberCard.componentName = 'Subject: ' + memberDetails.memMnfFname + ' ' + memberDetails.memMnfLname;
            memberCard.noOfColumns = 'slds-size_6-of-12';
            memberCard.componentOrder = 3;
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'DOB', memberDetails.memDOB, 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'State', memberDetails.memState, 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Phone #', memberDetails.memPhone, 'outputText', true)); //US2820034 - adding isReportable - true
            memberCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), memberCard);
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
        if(!cmp.get("v.isDefaultGenerated")){
            this.addDefaultAutodoc(cmp);
        }
        var selectedType = cmp.get("v.selectedPlanType");
        if (selectedType == 'Commercial') {
            var memberCard = new Object();
            memberCard.type = 'card';
            memberCard.componentName = 'Plan Type: Commercial';
            memberCard.noOfColumns = 'slds-size_6-of-12';
            memberCard.componentOrder = 4;
            memberCard.uniqueId = selectedType;
            memberCard.hasUnresolved = !cmp.get("v.isResolved");
            memberCard.callTopic = 'Member Not Found';
            // US3653469: Add missing fields/components to autodoc reporting - adding caseItemsExtId - Krish - 4th Aug 2021
            memberCard.caseItemsExtId = 'Commercial';
            var cardData = [];
            if (cmp.get("v.selectedRadioOption") == 'No') {
                cardData.push(new fieldDetails(true, false, true, 'Was the member found in CDB, but not returning in the search results?', 'No', 'outputText', true)); //US2820034 - adding isReportable - true
            } 
            if (cmp.get("v.selectedRadioOption") == 'Yes') {
                cardData.push(new fieldDetails(true, false, true, 'Group#', cmp.get("v.GroupId"), 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Alt ID/SSN', cmp.get("v.commercialAltID"), 'outputText', true)); //US2820034 - adding isReportable - true
            }
            cardData.push(new fieldDetails(true, false, true, 'Resolved', cmp.get("v.isResolved"), 'checkbox')); //US3653469: Updating Resolved to not reportable as not in sheet - Krish - 4th Aug 2021
            memberCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), memberCard);
        } else if (selectedType == 'Medicare') {
            var memberCard = new Object();
            memberCard.type = 'card';
            memberCard.componentName = 'Plan Type: Medicare';
            memberCard.noOfColumns = 'slds-size_6-of-12';
            memberCard.componentOrder = 4;
            memberCard.uniqueId = selectedType;
            memberCard.hasUnresolved = !cmp.get("v.isResolved");
            memberCard.callTopic = 'Member Not Found';
            // US3653469: Add missing fields/components to autodoc reporting - adding caseItemsExtId - Krish - 4th Aug 2021
            memberCard.caseItemsExtId = 'Medicare';
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'MBI/HICN', cmp.get("v.MedicareId"), 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Resolved', cmp.get("v.isResolved"), 'checkbox')); //US3653469: Updating Resolved to not reportable as not in sheet - Krish - 4th Aug 2021
            memberCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), memberCard);
        } else if (selectedType == 'Medicaid') {
            var memberCard = new Object();
            memberCard.type = 'card';
            memberCard.componentName = 'Plan Type: Medicaid';
            memberCard.noOfColumns = 'slds-size_6-of-12';
            memberCard.componentOrder = 4;
            memberCard.uniqueId = selectedType;
            memberCard.hasUnresolved = !cmp.get("v.isResolved");
            memberCard.callTopic = 'Member Not Found';
            // US3653469: Add missing fields/components to autodoc reporting - adding caseItemsExtId - Krish - 4th Aug 2021
            memberCard.caseItemsExtId = 'Medicaid';
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, 'Medicaid ID', cmp.get("v.MedicaidId"), 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Resolved', cmp.get("v.isResolved"), 'checkbox')); //US3653469: Updating Resolved - not reportable as not in sheet - Krish - 4th Aug 2021
            cardData.push(new fieldDetails(true, false, true, 'Street Address', cmp.get("v.MedicaidAddress"), 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Zip Code', cmp.get("v.MedicaidZipCode"), 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, '', '', 'outputText'));
            if(cmp.get("v.NewbornChkValue")){
                // Title
                cardData.push(new fieldDetails(true, false, true, '', '<b>Newborn Details</b>', 'outputText')); //US3653469 - removing isReportable - true - 5 Aug 2021
                cardData.push(new fieldDetails(true, false, true, '', '', 'outputText')); //US3653469 - removing isReportable - true - krish - 5 Aug 2021
                // end
                cardData.push(new fieldDetails(true, false, true, 'Baby\'s CIN (Medicaid ID)', cmp.get("v.BabyCIN"), 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Mother\'s CIN (Medicaid ID)', cmp.get("v.MotherCIN"), 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Family Link ID', cmp.get("v.FamilyID"), 'outputText', true)); //US2820034 - adding isReportable - true
                cardData.push(new fieldDetails(true, false, true, 'Gender', cmp.get("v.genderValue"), 'outputText', true)); //US2820034 - adding isReportable - true//US2356260 - Member Not Found Update to Medicaid Gender Options - Sravan
            }
            memberCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), memberCard);
        } else if (selectedType == 'Other/Unknown') {
            var memberCard = new Object();
            memberCard.type = 'card';
            memberCard.componentName = 'Plan Type: Other/Unknown';
            memberCard.noOfColumns = 'slds-size_6-of-12';
            memberCard.componentOrder = 4;
            memberCard.uniqueId = selectedType;
            memberCard.hasUnresolved = !cmp.get("v.isResolved");
            memberCard.callTopic = 'Member Not Found';
            // US3653469: Add missing fields/components to autodoc reporting - adding caseItemsExtId - Krish - 4th Aug 2021
            memberCard.caseItemsExtId = 'Other/Unknown';
            var cardData = [];
            cardData.push(new fieldDetails(true, false, true, '', 'Please refer provider to the provider services number on the back of the member\'s ID Card', 'outputText', true)); //US2820034 - adding isReportable - true
            cardData.push(new fieldDetails(true, false, true, 'Resolved', cmp.get("v.isResolved"), 'checkbox')); //US3653469: Updating Resolved to not reportable as not in sheet - Krish - 4th Aug 2021
            memberCard.cardData = cardData;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), memberCard);
    }

        // Filter proper one
        var selectedAutoDoc = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var filtered = [];
        if (selectedAutoDoc != undefined && selectedAutoDoc != null) {
            selectedAutoDoc.forEach(element => {
                if (element.componentOrder == 4 && element.uniqueId == selectedType) {
                    filtered.push(element);
                } else if (element.componentOrder != 4) {
                    filtered.push(element);
                }
            });
        }
        cmp.set("v.tableDetails_prev", filtered);

        return filtered;

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
    //US3376219 - Sravan - Start
    getMemberNotFoundDetails: function(component, event, helper){
        var memberNotFoundDetails = '';
        var caseWrapper = component.get("v.caseWrapper");
        var subjectDetails = 'Subject:'+caseWrapper.SubjectName+'\n'+'DOB:'+caseWrapper.SubjectDOB+'\n'+'Phone #:'+caseWrapper.subjectPhoneNumber;
        var address = component.get("v.MedicaidAddress")+' '+caseWrapper.stateCode+' '+component.get("v.MedicaidZipCode");
        var planTypeDetails = 'Medicaid ID:'+component.get("v.MedicaidId")+'\n'+'Address:'+address;
        if(!$A.util.isUndefinedOrNull(component.get("v.BabyCIN")) && !$A.util.isEmpty(component.get("v.BabyCIN"))){
            var babyDetails = 'Baby\'s CIN (Medicaid ID):'+component.get("v.BabyCIN")+'\n'+'Mother\'s CIN (Medicaid ID):'+component.get("v.MotherCIN")+'\n'+'Family Link ID:'+component.get("v.FamilyID")+'\n'+'Gender:'+component.get("v.genderValue");
        }
        if(!$A.util.isUndefinedOrNull(babyDetails) && !$A.util.isEmpty(babyDetails)){
            memberNotFoundDetails = subjectDetails+'\n'+planTypeDetails+'\n'+babyDetails;
        }
        else{
            memberNotFoundDetails = subjectDetails+'\n'+planTypeDetails;   
        }
        console.log('MemberNotFoundDetails'+memberNotFoundDetails);
        component.set("v.memberNotFoundDetails",memberNotFoundDetails);
    },
    //US3376219 - Sravan - End

    /* US3692809: Krish - 29th July 2021
       validateForAutodocButton() Function to validate if all fields of the selected plan type are populated and enable/diable autodoc button
    */
    validateForAutodocButton: function(cmp) {

        this.createPreview(cmp);
        var planType = cmp.get('v.planType');
        // Commercial
        var memberFound = cmp.find('memberFound');
        var GroupId = cmp.find('GroupId');
        var commercialAltID = cmp.find('commercialAltID');
        // Medicare
        var MedicareId = cmp.find('MedicareId');
        // Medicaid
        var MedicaidId = cmp.find('MedicaidId');
        var MedicaidAddress = cmp.find('MedicaidAddress');
        var MedicaidZipCode = cmp.find('MedicaidZipCode');
        // Medicaid - Newborn
        var NewbornChkValue = cmp.get('v.NewbornChkValue');
        var BabyCIN = cmp.find('BabyCIN');
        var MotherCIN = cmp.find('MotherCIN');
        var FamilyID = cmp.find('FamilyID');
        var Gender = cmp.find('Gender');
        var isAllFieldsComplete = false;

        if (!$A.util.isUndefinedOrNull(planType) && !$A.util.isEmpty(planType) && planType != 'None') {
            switch (planType) {

                case 'Commercial':
                    if(!$A.util.isUndefinedOrNull(memberFound) && memberFound.get('v.value') == 'No'){
                        isAllFieldsComplete = true;
                    }else{
                        isAllFieldsComplete = !$A.util.isUndefinedOrNull(memberFound) && memberFound.get('v.value') == 'Yes' && !$A.util.isUndefinedOrNull(GroupId)
                        && !$A.util.isUndefinedOrNull(commercialAltID) && GroupId.checkValidity() && commercialAltID.checkValidity();
                    }
                    break;

                case 'Medicare':
                    isAllFieldsComplete = !$A.util.isUndefinedOrNull(MedicareId) && MedicareId.checkValidity();                   
                    break;

                case 'Medicaid':
                    isAllFieldsComplete = !$A.util.isUndefinedOrNull(MedicaidId) && MedicaidId.checkValidity() && !$A.util.isUndefinedOrNull(MedicaidAddress) && MedicaidAddress.checkValidity()
                    && !$A.util.isUndefinedOrNull(MedicaidZipCode) && MedicaidZipCode.checkValidity();

                    if(NewbornChkValue){
                        if(!$A.util.isUndefinedOrNull(BabyCIN) &&  !$A.util.isUndefinedOrNull(MotherCIN) && !$A.util.isUndefinedOrNull(FamilyID) && !$A.util.isUndefinedOrNull(Gender)){
                            isAllFieldsComplete = isAllFieldsComplete && BabyCIN.checkValidity() && MotherCIN.checkValidity() && FamilyID.checkValidity() && Gender.checkValidity();
                        }else{
                            isAllFieldsComplete = false;
                        } 
                    }
                    break;

                case 'Other/Unknown':
                    isAllFieldsComplete = true; // Since no fields are there for this option to validate.
                    break;

                default:
                    
            }
            // If all the fields are populated then enable the Autodoc Button
            if(isAllFieldsComplete){
                cmp.set("v.isAutodocDisabled", false);
            }else{
                cmp.set("v.isAutodocDisabled", true);
            }
        }
    },
})