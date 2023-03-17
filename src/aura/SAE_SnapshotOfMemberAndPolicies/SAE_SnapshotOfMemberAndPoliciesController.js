({
    //DE364195 - Avish
    onTabClosed: function (cmp, event, helper) {
        helper.closedSnapShotHandler(cmp, event);
    },

    onTabFocused: function (cmp, event, helper) {
        helper.updateProviderDetails(cmp, event);
    },
    //DE364195 - Ends

    getAlertFromPolices: function (component, event, helper) {

        var policyGroupId = event.getParam("data_group");
        var providerTabId = event.getParam("v.providerUniqueId");
        var memberTabId = event.getParam("v.memberTabId");
        component.set("v.policyGroupId", policyGroupId);
        component.find("alertsAI").getAlertsOnclickPolicies();
    },

    handlehiglightGrpNumber: function (component, event, helper) {
        var groupNumber = component.get("v.higlightGrpNumber");
        if (!$A.util.isEmpty(groupNumber) && groupNumber.length == 7 && groupNumber.charAt(0) == '0') {
            var temp = groupNumber.substring(1, groupNumber.length);
            component.set("v.alertGroupId", temp);
        } else {
            component.set("v.alertGroupId", groupNumber);
        }
        component.find("alertsAI").alertsMethodShapshots();
    },


    doInit: function (component, event, helper) {
        var today = new Date();
        var uniqueTimeStamp = today.getTime();
        helper.showEligibilityErrorMessage = true; // US3299151 - Thanish - 16th Mar 2021

        var pageReference = component.get("v.pageReference");
        //DE364195 - Avish
        helper.getEnclosingTabIdHelper(component, event);
        //US1761826 - UHC/Optum Exclusion UI
        //helper.fetchExlusionMdtData(component);
        helper.fetchMockStatus(component);
        //US2478836 - Member Not Found Plan Type Card Link to OneSource - Sravan - Start
        helper.getOneSourceLink(component, event, helper);
        //US2478836 - Member Not Found Plan Type Card Link to OneSource - Sravan - End
        var providerDetails = pageReference.state.c__providerDetails;
        component.set("v.providerDetails", providerDetails);
        component.set("v.insuranceTypeCode", pageReference.state.c__insuranceTypeCode);
        var isRoutingAllowed = (providerDetails.isNoProviderToSearch || providerDetails.isOther) ? false : true;
        component.set("v.isRoutingAllowed", isRoutingAllowed);
        var providerUniqueId = pageReference.state.c__providerUniqueId;
        component.set("v.providerUniqueId", providerUniqueId);
        var mnfVal = pageReference.state.c__mnf;
        //var mnfVal = '';
        var interactionCard = pageReference.state.c__interactionCard;
        var contactName = pageReference.state.c__contactName;
        var searchOptionVal = pageReference.state.c__searchOption;
        var subjectCard = pageReference.state.c__subjectCard;
        var houseHoldMemberId = pageReference.state.c__memberId;
        var houseHoldGroupId = pageReference.state.c__groupId;
        var IntRec = pageReference.state.c__interactionRecord;
        var houseHoldFirstName = pageReference.state.c__memberFN;
        var houseHoldRelationShip = pageReference.state.c__relatioship;
        // DE452841 - removed faulty code
        // component.set("v.FISourceCode", subjectCard.FISourceCode);

        //DE364195 - Avish
        if (!$A.util.isEmpty(pageReference.state.c__interactionOverviewTabId)) {
            component.set("v.interactionOverviewTabId", pageReference.state.c__interactionOverviewTabId);
        }
        //DE364195 - Ends

        //US2705857 - Sravan - Start
        var addressId = $A.util.isEmpty(pageReference.state.c__addressId) ? 'physiciandetails' : pageReference.state.c__addressId;
        console.log('Address Id' + pageReference.state.c__addressId);
        component.set("v.addressId", addressId);
        //US2705857 - Sravan - End


        //US3612768 - Sravan - Start
        if(!$A.util.isUndefinedOrNull(subjectCard) && !$A.util.isUndefinedOrNull(subjectCard.FISourceCode)){
            component.set("v.explorePageSourceCode",subjectCard.FISourceCode);
        }
        //US3612768 - Sravan - End

        //US3259671 - Sravan - Start
        var interactionOverviewTabId = component.get("v.interactionOverviewTabId");
        if(!$A.util.isUndefinedOrNull(interactionOverviewTabId) && !$A.util.isEmpty(interactionOverviewTabId)){
            var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
            var flowDetails = interactionOverviewData.flowDetails;
            component.set("v.flowDetails",flowDetails);
            console.log('Flow Details'+ JSON.stringify(flowDetails));
        }
        //US3259671 - Sravan - End
        
        //DE347387 - Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);


        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl", hipaaEndPointUrl);
        //US2076634 - HIPAA Guidelines Button - Sravan - End
        //DE347387 Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);

        component.set("v.contactCard", pageReference.state.c__contactCard);
        
        var relationship = '';
        if (!$A.util.isEmpty(houseHoldRelationShip)) {
            relationship = houseHoldRelationShip;
        }
        //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
        var payerMap = pageReference.state.c__payerMap;
        if (!$A.util.isEmpty(payerMap)) {
            component.set("v.policywithPayerIdMap", payerMap);
        }
        var searchQueryPayerId = pageReference.state.c__searchPayerID;
        if (!$A.util.isEmpty(searchQueryPayerId)) {
            component.set("v.searchQueryPayerId", searchQueryPayerId);
        }
        var isDependent = pageReference.state.c__isDependent;
        if (!$A.util.isEmpty(isDependent)) {
            component.set("v.isDependent", true);
        }

        //US2061732 - Added by Avish
        var interactionType = pageReference.state.c__interactionType;
        component.set("v.interactionType", interactionType);
        //US2061732 Ends

        if (!$A.util.isEmpty(houseHoldMemberId)) {
            component.set("v.houseHoldMemberId", houseHoldMemberId);
        }
        if (!$A.util.isEmpty(houseHoldGroupId)) {
            component.set("v.houseHoldGroupId", houseHoldGroupId);
        }
        //Ketki open member snapshot for claim
        var policyDateRange = pageReference.state.c__policyDateRange;

        if(!$A.util.isEmpty(policyDateRange)){
            component.set("v.policyDateRange",policyDateRange );
        }
        var memberGrpN = pageReference.state.c__memberGrpN;

        if(!$A.util.isEmpty(memberGrpN)){
            component.set("v.memberGrpN",memberGrpN );
        }
        
        var isClaim = pageReference.state.c__isClaim;

        var claimInput=pageReference.state.c__claimInput;
        if(!$A.util.isEmpty(claimInput)){
           component.set("v.claimInput",claimInput);
        }



        //Ketki open member snapshot for claim end

        // US3536342 - Thanish - 3rd Jun 2021 - removed old scroll function

        if (!$A.util.isEmpty(subjectCard)) {
            /*component.set("v.alertMemberId",subjectCard.memberId);
            component.set("v.houseHoldMemberId",subjectCard.memberId); Commented as part of US2925631 - Sravan*/

            //component.set("v.alertGroupId",subjectCard.groupNumber);
            //US2100807: Added by Ravindra
            if ($A.util.isEmpty(component.get("v.payerID"))) {
                component.set("v.payerID", subjectCard.payerID);
            }
            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
            component.set("v.policywithPayerIdMap", subjectCard.policyandPayerMap);
            component.set("v.searchQueryPayerId", subjectCard.searchQueryPayerId);
            //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            if (!$A.util.isEmpty(subjectCard.middleName)) {
                component.set("v.memberMiddleInitial", subjectCard.middleName);
            }
        }
        if (!$A.util.isEmpty(interactionCard)) {
            component.set("v.alertProviderId", interactionCard.providerId);
            component.set("v.alertTaxId", interactionCard.taxId);
        }
        var providerNotFoundValue = false;
        var isProviderSearchDisabledValue = false;
        providerNotFoundValue = pageReference.state.c__providerNotFound;
        isProviderSearchDisabledValue = pageReference.state.c__isProviderSearchDisabled;
        if (!providerNotFoundValue && !isProviderSearchDisabledValue) {
            component.set("v.callCSContractsAPI", true);
            helper.getCSPProviderID(component, event, helper);
        }

        component.set("v.isfindIndividualFlag", pageReference.state.c__isfindIndividualFlag); //US2070352  added by Avish on 09/25/2019

        component.set("v.isAdditionalMemberSearchfindIndividual", pageReference.state.c__isAdditionalMemberIndividualSearch); //US2020384

        if (mnfVal == "mnf") {
            var caseNotSavedTopics = component.get("v.caseNotSavedTopics");
            if(!caseNotSavedTopics.includes("Member Not Found")){
                caseNotSavedTopics.push("Member Not Found");
            }
            component.set("v.caseNotSavedTopics", caseNotSavedTopics);
            
            var memState = subjectCard.mnfState;
            var memPhone = subjectCard.mnfPhoneNumber;
            var memMnfFname = subjectCard.mnfMemberFN;
            var memDOB = subjectCard.mnfDOB;
            component.set("v.memState", memState);
            component.set("v.memPhone", memPhone);
            component.set("v.mnfMemberFN", memMnfFname);
            component.set("v.memberLN", subjectCard.mnfMemberLN);
            component.set("v.mnfDOB", memDOB);

            // MNF Details
            var mnfData = new Object();
            mnfData.memState = subjectCard.mnfState;
            mnfData.memPhone = subjectCard.mnfPhoneNumber;
            mnfData.memMnfFname = subjectCard.mnfMemberFN;
            mnfData.memMnfLname = subjectCard.mnfMemberLN;
            mnfData.memDOB = subjectCard.mnfDOB;
            component.set("v.mnfMemberDetails", mnfData);

            //US2137922 - AutodocPageFeature - Sanka
            var autoDocPF = subjectCard.mnfMemberFN + subjectCard.mnfDOB;
            component.set("v.AutodocPageFeature", autoDocPF);

            // US2808743 - Thanish - 4th Sep 2020 - New Autodoc Framework
            let today = new Date();
            var autodocUniqueId = uniqueTimeStamp + subjectCard.mnfMemberFN + subjectCard.mnfMemberLN + subjectCard.mnfDOB + today.getTime();
            component.set("v.autodocUniqueId", autodocUniqueId);

            // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda

            //AutoDoc Key Setting for MNF - Sanka
            var strDateVal = memDOB.replace("/", "");
            strDateVal = strDateVal.replace("/", "");
            var autoDocMNF = memberFNVal + strDateVal;
            var autodockey = IntRec.Id + autoDocMNF;

            component.set("v.AutodocKey", autodockey);
            // US2543737 - Thanish - 22nd Apr 2020

            //US1970508 - Ravindra - start
            component.set("v.isOtherSearch", pageReference.state.c__isOtherSearch);
            component.set("v.interactionRec", pageReference.state.c__interactionRecord);
            component.set("v.isProviderSearchDisabled", pageReference.state.c__isProviderSearchDisabled);
            helper.createOrUpdatePersonAccount(component, mnfVal, memMnfFname, subjectCard.mnfMemberLN, memDOB, subjectCard.memberId, subjectCard.groupNumber, memPhone);
            //US1970508 - Ravindra - end
        } else {
            var caseNotSavedTopics = component.get("v.caseNotSavedTopics");
            if(!caseNotSavedTopics.includes("View Member Eligibility")){
                caseNotSavedTopics.push("View Member Eligibility");
            }
            component.set("v.caseNotSavedTopics", caseNotSavedTopics);

            var payerID = '';
            // US1944108 - Accommodate Multiple Payer ID's - Kavinda
            if (!$A.util.isEmpty(subjectCard)) {
                var payerID = subjectCard.payerID;
            }


            /* US2070352  added by Avish on 09/25/2019 */
            if (!component.get("v.isfindIndividualFlag")) {
                var memberIdVal = !$A.util.isEmpty(subjectCard) ? subjectCard.memberId : pageReference.state.c__memberId;
                var memberDOBVal = !$A.util.isEmpty(subjectCard) ? subjectCard.memberDOB : pageReference.state.c__memberDOB;
                var memberFNVal = !$A.util.isEmpty(subjectCard) ? subjectCard.firstName : pageReference.state.c__memberFN;
                var memberLNVal = !$A.util.isEmpty(subjectCard) ? subjectCard.lastName : pageReference.state.c__memberLN;
                var memberGrpNVal = !$A.util.isEmpty(subjectCard) ? subjectCard.groupNumber : pageReference.state.c__memberGrpN;

                // US1944108 - Accommodate Multiple Payer ID's - Kavinda
                payerID = !$A.util.isEmpty(subjectCard) ? subjectCard.payerID : pageReference.state.c__payerID;

                component.set("v.memberId", memberIdVal);
                component.set("v.memberDOB", memberDOBVal);
                component.set("v.memberFN", memberFNVal);
                component.set("v.memberLN", memberLNVal);
                component.set("v.memberGrpN", memberGrpNVal);
                component.set("v.searchOption", "NameDateOfBirth");

                //US2137922 - AutodocPageFeature - Sanka
                var strDateVal = memberDOBVal.replace("/", "");
                strDateVal = strDateVal.replace("/", "");
                var autoDocPF;
                if (!$A.util.isEmpty(memberFNVal)) {
                    autoDocPF = memberFNVal.replaceAll(' ', '') + strDateVal;
                }

                component.set("v.AutodocPageFeature", autoDocPF);

                // US2808743 - Thanish - 4th Sep 2020 - New Autodoc Framework
                let today = new Date();
                var autodocUniqueId = uniqueTimeStamp + memberIdVal + memberFNVal + memberLNVal + strDateVal + today.getTime();
                component.set("v.autodocUniqueId", autodocUniqueId);


                // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda

                var autodockey = IntRec.Id + autoDocPF;

                //alert("-----AUtoKey---"+ autodockey);
                component.set("v.AutodocKey", autodockey);
                // US2543737 - Thanish - 22nd Apr 2020

                // DE301090
                component.set("v.AuthAutodocPageFeature", autodockey + 'Auth');

            } else {

                component.set("v.memberId", subjectCard.memberId);
                component.set("v.memberDOB", subjectCard.memberDOB);
                component.set("v.memberFN", subjectCard.firstName);
                component.set("v.memberLN", subjectCard.lastName);
                component.set("v.memberGrpN", subjectCard.groupNumber);
                component.set("v.searchOption", "NameDateOfBirth");
                component.set("v.memberContactName", pageReference.state.c__memberContactName);

                //US2137922 - AutodocPageFeature - Sanka
                var strDateVal = subjectCard.memberDOB.replace("/", "");
                strDateVal = strDateVal.replace("/", ""); //DE285334 - Sarma - Removing dot notation
                var autoDocPF = subjectCard.firstName + strDateVal;
                component.set("v.AutodocPageFeature", autoDocPF);

                // US2808743 - Thanish - 4th Sep 2020 - New Autodoc Framework
                let today = new Date();
                var autodocUniqueId = uniqueTimeStamp + subjectCard.memberId + subjectCard.firstName + subjectCard.lastName + strDateVal + today.getTime();
                component.set("v.autodocUniqueId", autodocUniqueId);

                helper.createGUID(component, event, helper); //DE285334 - Sarma - Adding missing parameters

                // US2271237
                var autodockey = IntRec.Id + autoDocPF; //component.get("v.guid");

                //alert("-----AUtoKey---"+ autodockey);
                component.set("v.AutodocKey", autodockey);
                // US2543737 - Thanish - 22nd Apr 2020

                // DE301090
                // US2271237
                component.set("v.AuthAutodocPageFeature", autodockey + 'Auth');

                // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda


            }
            /* US2070352 Ends */

            //US2020384 - START
            if (component.get("v.isAdditionalMemberSearchfindIndividual")) {

                component.set("v.memberId", subjectCard.memberId);
                component.set("v.memberDOB", subjectCard.memberDOB);
                component.set("v.memberFN", subjectCard.firstName);
                component.set("v.memberLN", subjectCard.lastName);
                component.set("v.memberGrpN", subjectCard.groupNumber);
                component.set("v.searchOption", "NameDateOfBirth");
            }
            //US2020384 - END

            // US1944108 - Accommodate Multiple Payer ID's - Kavinda
            component.set("v.payerID", payerID);

        }
        var memTabId = pageReference.state.c__memberUniqueId;
        var interactionRecVal = pageReference.state.c__interactionRecord;
        component.set("v.contactUniqueId", interactionRecVal.Id);
        /** US1895939  added by Avish on 08/01/2019 **/
        var providerNotFound = pageReference.state.c__providerNotFound;
        var noMemberToSearch = pageReference.state.c__noMemberToSearch;
        var isProviderSearchDisabled = pageReference.state.c__isProviderSearchDisabled;
        var memberCardFlag = pageReference.state.c__memberCardFlag;
        component.set("v.memberCardFlag", memberCardFlag);
        component.set("v.noMemberToSearch", noMemberToSearch);
        component.set("v.providerNotFound", providerNotFound);
        component.set("v.isProviderSearchDisabled", isProviderSearchDisabled);
        /** US1895939 Ends **/

        component.set("v.contactName", contactName);
        component.set("v.interactionCard", interactionCard);
        component.set("v.memberTabId", memTabId);

        //US1835149
        component.set("v.mnf", mnfVal);
        //component.set("v.searchOption", searchOptionVal);
        component.set("v.interactionRec", interactionRecVal);
        //DE282930	House Hold Card issue , Duplicate and Provider card blank - 25/11/2019 - Sarma

        //Adding null check for contact name
        if (component.get("v.memberCardFlag") && component.get("v.isProviderSearchDisabled") && !$A.util.isEmpty(component.get("v.contactName"))) {
            component.set("v.contactName", component.get("v.contactName").toUpperCase());
            component.set("v.authContactName", component.get("v.contactName").toUpperCase()); //US2061732 - Added by Avish
        }

        //US1909380 - START
        let isOtherSearch = pageReference.state.c__isOtherSearch;

        let otherDetails = pageReference.state.c__otherDetails;

        component.set("v.isOtherSearch", isOtherSearch);
        component.set("v.otherCardDataObj", otherDetails);
        //US1909380 - END

        if (!$A.util.isEmpty(interactionCard)) {
            component.set("v.authContactName", interactionCard.contactName.toUpperCase()); //US2061732 - Added by Avish
        } else if (component.get("v.isProviderSearchDisabled") && !$A.util.isEmpty(component.get("v.contactName"))) { //US2061732 - Added by Avish
            component.set("v.authContactName", component.get("v.contactName").toUpperCase()); //US2061732 - Added by Avish
        } else if (component.get("v.isOtherSearch")) { //US2061732 - Added by Avish
            var otherCardDataObj = component.get("v.otherCardDataObj");
            var otherName = otherCardDataObj.firstName + ' ' + otherCardDataObj.lastName;
            component.set("v.authContactName", otherName.toUpperCase());
        }
        //US2061732 - Ends
        //US1970508 - Ravindra - start
        var interactionRec = component.get("v.interactionRec");
        var interactionCard = component.get("v.interactionCard");

        let MNFCaseWrapper = {};
        var taxId = "";
        var providerId = "";

        // US2815284
        MNFCaseWrapper.refreshUnique = memTabId;
        //US3248222 - Praveen
		MNFCaseWrapper.EEID = "";

        //US2587781 - Avish
        if (component.get("v.isOtherSearch")) {
            var otherConNumber = (component.get("v.otherCardDataObj") != undefined && component.get("v.otherCardDataObj") != null) ? component.get("v.otherCardDataObj").conNumber : "";
            if (!$A.util.isEmpty(otherConNumber)) {
                //var conNumber = otherConNumber.split('-');
                MNFCaseWrapper.contactNumber = otherConNumber; //conNumber[0]+conNumber[1]+conNumber[2];
            }
            //MNFCaseWrapper.contactNumber = (component.get("v.otherCardDataObj") != undefined && component.get("v.otherCardDataObj") != null)? component.get("v.otherCardDataObj").conNumber:"";
            MNFCaseWrapper.contactExt = (component.get("v.otherCardDataObj") != undefined && component.get("v.otherCardDataObj") != null) ? component.get("v.otherCardDataObj").otherConExt : "";
            //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            var otherCardDetails = component.get("v.otherCardDataObj");
            if (!$A.util.isUndefinedOrNull(otherCardDetails) && !$A.util.isUndefinedOrNull(otherCardDetails.contactType)) {
                MNFCaseWrapper.OtherOrginatorType = otherCardDetails.contactType;
            }
        } else {
            if (!$A.util.isEmpty(interactionCard)) {
                MNFCaseWrapper.contactNumber = interactionCard.contactNumber;
                MNFCaseWrapper.contactExt = interactionCard.contactExt;
            } else {
                MNFCaseWrapper.contactNumber = (component.get("v.contactCard") != undefined && component.get("v.contactCard") != null) ? component.get("v.contactCard").contactNumber : "";
                MNFCaseWrapper.contactExt = (component.get("v.contactCard") != undefined && component.get("v.contactCard") != null) ? component.get("v.contactCard").contactExt : "";

            }
        }



        //US2587781 - Avish - Ends

        //US2784325
        var providerValues = component.get("v.providerDetailsForRoutingScreen");
        if (!$A.util.isUndefinedOrNull(providerValues)) {
            MNFCaseWrapper.phoneNumber = providerValues.EffectivePhoneNumber;
            MNFCaseWrapper.providerInfoCity = providerValues.AddressCity;
        }
        if (component.get("v.providerNotFound")) {
            taxId = interactionCard.taxIdOrNPI;
        } else if (component.get("v.isProviderSearchDisabled") || component.get("v.isOtherSearch")) {
            taxId = "";
        } else {
            taxId = interactionCard.taxId;
            providerId = interactionCard.providerId;
        }
        //provider flow info
        MNFCaseWrapper.providerNotFound = component.get("v.providerNotFound");
        MNFCaseWrapper.noProviderToSearch = component.get("v.isProviderSearchDisabled");
        MNFCaseWrapper.isOtherSearch = component.get("v.isOtherSearch");
        MNFCaseWrapper.mnf = component.get("v.mnf");
        //MNFCaseWrapper.memberContactId = component.get("v.memberPersonAccount.PersonContactId");
        //DE285334 - adding null check - Sarma
        if (!$A.util.isEmpty(interactionRec)) {
            MNFCaseWrapper.providerContactId = interactionRec.Originator__c;
        }

        MNFCaseWrapper.providerId = providerId; //
        MNFCaseWrapper.TaxId = taxId; //
        MNFCaseWrapper.noMemberToSearch = component.get("v.noMemberToSearch");
        //US1970508 - Ravindra - end

        ////US1835149
        if (component.get("v.mnf") != 'mnf') {
            helper.getMemberData(component, event, helper);
            helper.processSubjectCardData(component, event, helper);
            //
            //US1970508 - Ravindra
            //let MNFCaseWrapper = {};
            if (component.get('v.interactionRec') != null && component.get('v.interactionRec') != '') {
                if (!$A.util.isEmpty(component.get('v.interactionRec').Id)) {
                    MNFCaseWrapper.Interaction = component.get('v.interactionRec').Id;
                }
            }

            //US1909380 : START - HANDLE NULL interactionCard VLUES
            if (interactionCard != null && interactionCard != undefined) {
                MNFCaseWrapper.OriginatorName = interactionCard.firstName + ' ' + interactionCard.lastName;
                MNFCaseWrapper.OriginatorType = 'Provider';
                MNFCaseWrapper.OriginatorRelationship = '';
                MNFCaseWrapper.OriginatorContactName = interactionCard.contactName;
                //US2740876 - Sravan - Start
                MNFCaseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
                MNFCaseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
                //US2740876 - Sravan - End

                //US3145625 - Sravan - Start
                MNFCaseWrapper.strAddressID = component.get("v.addressId");
                //US3145625 - Sravan - End

                MNFCaseWrapper.OriginatorPhone = interactionCard.phone;
                MNFCaseWrapper.OriginatorEmail = '--';
                //Household hot fix - Sanka
                // if(subjectCard != null){
                //     MNFCaseWrapper.SubjectName = subjectCard.firstName + ' ' + subjectCard.lastName;
                // }
                //US1921739 - Case creation during member standalone search bug fix - 21/10/2019 - Sarma (commenting above lines as well)
                MNFCaseWrapper.SubjectName = component.get("v.memberFN") + ' ' + component.get("v.memberLN");
                MNFCaseWrapper.SubjectDOB = component.get("v.memberDOB");
                MNFCaseWrapper.middleInitial = component.get("v.memberMiddleInitial"); //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                MNFCaseWrapper.SubjectType = 'Member';
                // Case creation bug fix - Sarma : 16/09//2019
                MNFCaseWrapper.SubjectId = component.get("v.memberId");
                MNFCaseWrapper.SubjectGroupId = component.get("v.memberGrpN");
                MNFCaseWrapper.Relationship = relationship;
            } else {
                MNFCaseWrapper.OriginatorName = '';
                MNFCaseWrapper.OriginatorType = 'Provider';
                MNFCaseWrapper.OriginatorRelationship = '';
                MNFCaseWrapper.OriginatorContactName = '';
                //US2740876 - Sravan - Start
                MNFCaseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
                MNFCaseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
                //US2740876 - Sravan - End

                //US3145625 - Sravan - Start
                MNFCaseWrapper.strAddressID = component.get("v.addressId");
                //US3145625 - Sravan - End

                MNFCaseWrapper.OriginatorPhone = '';
                MNFCaseWrapper.OriginatorEmail = '--';
                //Household hot fix - Sanka
                if (subjectCard != null) {
                    MNFCaseWrapper.SubjectName = subjectCard.firstName + ' ' + subjectCard.lastName;
                }
                //Sarma : 22/10/2019
                MNFCaseWrapper.SubjectDOB = component.get("v.memberDOB");
                MNFCaseWrapper.SubjectType = 'Member';
                // Case creation bug fix - Sarma : 16/09//2019
                MNFCaseWrapper.SubjectId = component.get("v.memberId");
                MNFCaseWrapper.SubjectGroupId = component.get("v.memberGrpN");
            }

            //US1909380 : END

            component.set("v.caseWrapperMNF", MNFCaseWrapper);
            //
        } else if (providerNotFound && noMemberToSearch) {
            //US1970508 - Ravindra
            //let MNFCaseWrapper = {};
            if (component.get('v.interactionRec') != null && component.get('v.interactionRec') != '') {
                if (!$A.util.isEmpty(component.get('v.interactionRec').Id)) {
                    MNFCaseWrapper.Interaction = component.get('v.interactionRec').Id;
                }
            }

            //US1909380 : START - HANDLE NULL interactionCard VLUES
            if (interactionCard != null && interactionCard != undefined) {
                MNFCaseWrapper.OriginatorName = interactionCard.firstName + ' ' + interactionCard.lastName;
                MNFCaseWrapper.OriginatorType = 'Provider';
                MNFCaseWrapper.OriginatorRelationship = '';
                MNFCaseWrapper.OriginatorContactName = interactionCard.contactName;
                //US2740876 - Sravan - Start
                MNFCaseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
                MNFCaseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
                //US2740876 - Sravan - End
                MNFCaseWrapper.OriginatorPhone = interactionCard.phone;
                MNFCaseWrapper.OriginatorEmail = '--';
            }

            //MNFCaseWrapper.SubjectName = interactionCard.firstName + ' ' + interactionCard.lastName;
            //MNFCaseWrapper.SubjectDOB = memberDOBVal;
            //MNFCaseWrapper.SubjectDOB = pageReference.state.c__memberDOB;
            //MNFCaseWrapper.SubjectType = 'Provider';
            //MNFCaseWrapper.SubjectId = '';
            //MNFCaseWrapper.SubjectGroupId = '';

            component.set("v.caseWrapperMNF", MNFCaseWrapper);
        } else if (component.get("v.mnf") == 'mnf' && providerNotFound) {
            //US1970508 - Ravindra
            //let MNFCaseWrapper = {};
            if (component.get('v.interactionRec') != null && component.get('v.interactionRec') != '') {
                if (!$A.util.isEmpty(component.get('v.interactionRec').Id)) {
                    MNFCaseWrapper.Interaction = component.get('v.interactionRec').Id;
                }
            }
            //US1909380 : START - HANDLE NULL interactionCard VLUES
            if (interactionCard != null && interactionCard != undefined) {
                MNFCaseWrapper.OriginatorName = interactionCard.firstName + ' ' + interactionCard.lastName;
                MNFCaseWrapper.OriginatorType = 'Provider';
                MNFCaseWrapper.OriginatorRelationship = '';
                MNFCaseWrapper.OriginatorContactName = interactionCard.contactName;
                //US2740876 - Sravan - Start
                MNFCaseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
                MNFCaseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
                //US2740876 - Sravan - End
                MNFCaseWrapper.OriginatorPhone = interactionCard.phone;
                MNFCaseWrapper.OriginatorEmail = '--';
            }

            //Household hot fix - Sanka
            if (subjectCard != null) {
                MNFCaseWrapper.SubjectName = subjectCard.mnfMemberFN + ' ' + subjectCard.mnfMemberLN;
                MNFCaseWrapper.SubjectDOB = subjectCard.mnfDOB;
                MNFCaseWrapper.SubjectType = 'Member';
                //US3172545 - No Provider to Search to MNF - Sravan - Start
                MNFCaseWrapper.SubjectId = subjectCard.memberId;
                //US3172545 - No Provider to Search to MNF - Sravan - End
                MNFCaseWrapper.SubjectGroupId = '--';
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan- Start
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfMemberFN)) {
                    MNFCaseWrapper.subjectFirstName = subjectCard.mnfMemberFN;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfMemberLN)) {
                    MNFCaseWrapper.subjectLastName = subjectCard.mnfMemberLN;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfState)) {
                    MNFCaseWrapper.stateCode = subjectCard.mnfState;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfPhoneNumber)) {
                    MNFCaseWrapper.subjectPhoneNumber = subjectCard.mnfPhoneNumber;
                }
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan- End
            }

            component.set("v.caseWrapperMNF", MNFCaseWrapper);
            //
        } else {
            //US1875495 - Malinda : Case Creation MNF
            //US1970508 - Ravindra
            //let MNFCaseWrapper = {};
            if (component.get('v.interactionRec') != null && component.get('v.interactionRec') != '') {
                if (!$A.util.isEmpty(component.get('v.interactionRec').Id)) {
                    MNFCaseWrapper.Interaction = component.get('v.interactionRec').Id;
                } else {

                }
            }
            //US1909380 : START - HANDLE NULL interactionCard VLUES
            if (interactionCard != null && interactionCard != undefined) {
                //US1974034 - Thanish - 26th Aug 2019.
                MNFCaseWrapper.OriginatorName = interactionCard.providerFN + ' ' + interactionCard.providerLN;
            }


            //MNFCaseWrapper.OriginatorType = 'Member';
            MNFCaseWrapper.OriginatorType = 'Provider';

            MNFCaseWrapper.OriginatorRelationship = '';
            //MNFCaseWrapper.OriginatorContactName = contactName;
            MNFCaseWrapper.OriginatorContactName = component.get("v.contactName");
            //US2740876 - Sravan - Start
            MNFCaseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
            MNFCaseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
            //US2740876 - Sravan - End

            //US3145625 - Sravan - Start
            MNFCaseWrapper.strAddressID = component.get("v.addressId");
            //US3145625 - Sravan - End

            MNFCaseWrapper.OriginatorPhone = component.get('v.memPhone');
            MNFCaseWrapper.OriginatorEmail = '';

            //Household hot fix - Sanka
            if (subjectCard != null) {
                //MNFCaseWrapper.SubjectName = memMnfFname+' '+memberLNVal;
                //MNFCaseWrapper.SubjectDOB = memberDOBVal;
                MNFCaseWrapper.SubjectName = memMnfFname + ' ' + component.get("v.memberLN");
                // US1974034 - Thanish - 22nd Aug 2019 - To display subject DOB in Case record page.
                MNFCaseWrapper.SubjectDOB = subjectCard.mnfDOB;
                MNFCaseWrapper.SubjectType = 'Member';
                //US3172545 - No Provider to Search to MNF - Sravan - Start
                MNFCaseWrapper.SubjectId = subjectCard.memberId;
                //US3172545 - No Provider to Search to MNF - Sravan - End
                MNFCaseWrapper.SubjectGroupId = '--';
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan- Start
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfMemberFN)) {
                    MNFCaseWrapper.subjectFirstName = subjectCard.mnfMemberFN;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfMemberLN)) {
                    MNFCaseWrapper.subjectLastName = subjectCard.mnfMemberLN;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfState)) {
                    MNFCaseWrapper.stateCode = subjectCard.mnfState;
                }
                if (!$A.util.isUndefinedOrNull(subjectCard.mnfPhoneNumber)) {
                    MNFCaseWrapper.subjectPhoneNumber = subjectCard.mnfPhoneNumber;
                }
                //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan- End
            }

            component.set("v.caseWrapperMNF", MNFCaseWrapper);
        }

        //US1912183	Case Creation - Other (Third Party) With Member - 17/09/2019 : Sarma : Start
        var caseWrapper = component.get("v.caseWrapperMNF");
        if (isOtherSearch) {
            var otherCardDataObj = component.get("v.otherCardDataObj");
            caseWrapper.OriginatorName = otherCardDataObj.conName; //US2587781 - Avish //otherCardDataObj.firstName + ' ' + otherCardDataObj.lastName;
            caseWrapper.OriginatorType = 'Other';
            caseWrapper.OriginatorRelationship = otherCardDataObj.contactType;
            caseWrapper.OriginatorContactName = otherCardDataObj.conName; //US2587781 - Avish //otherCardDataObj.firstName + ' ' + otherCardDataObj.lastName;
            //US2740876 - Sravan - Start
            caseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
            caseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
            //US2740876 - Sravan - End
            caseWrapper.OriginatorPhone = otherCardDataObj.phoneNumber;
            if (component.get("v.mnf") != 'mnf') {
                caseWrapper.SubjectDOB = component.get("v.memberDOB");
            }
            component.set("v.caseWrapperMNF", caseWrapper);

        } // US1921739 - adding else if to set originator details during member only flow, take var outside of if - 21/10/2019 - Sarma
        else if ($A.util.isEmpty(interactionCard)) {
            caseWrapper.OriginatorType = 'Member';
            caseWrapper.OriginatorName = component.get("v.memberFN") + ' ' + component.get("v.memberLN");
            caseWrapper.OriginatorContactName = component.get("v.contactName");
            //US2740876 - Sravan - Start
            caseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
            caseWrapper.OriginatorLastName = component.get("v.flowDetailsForRoutingScreen").contactLastName;
            //US2740876 - Sravan - End
            component.set("v.caseWrapperMNF", caseWrapper);
        }
        //US1912183 : End

        //US1983293 - Added by Avish
        if (component.get("v.isProviderSearchDisabled") && !component.get("v.isOtherSearch")) {
            component.set("v.originatorType", "Member");
            component.set("v.detailPage", "Member Snapshot");
        } else if ((!component.get("v.isProviderSearchDisabled") && !component.get("v.isOtherSearch") && component.get("v.noMemberToSearch"))) {
            component.set("v.originatorType", "Provider");
            component.set("v.detailPage", "Provider Snapshot");
        } else if (!component.get("v.isProviderSearchDisabled") && !component.get("v.isOtherSearch") && !component.get("v.noMemberToSearch")) {
            component.set("v.originatorType", "Provider");
            component.set("v.detailPage", "Member Snapshot");
        } else if (component.get("v.isOtherSearch") && !component.get("v.noMemberToSearch")) {
            component.set("v.originatorType", "Other");
            component.set("v.detailPage", "Member Snapshot");
        }
        //US1983293 - Ends
        //Moved the code snippet after the detail page name is set in order to support US2873801 && US2880283 - Sravan
        //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - Start
        console.log('Preparing the vccd data');
        var isVCCD = pageReference.state.c__isVCCD;
        var VCCDQuestionType = pageReference.state.c__VCCDQuestionType;
        var strEmails = pageReference.state.c__memberEmails;
        component.set("v.isVCCD",isVCCD);
        component.set("v.VCCDQuestionType",VCCDQuestionType);
        component.set("v.strEmails",strEmails);
        component.set("v.isVCCD", isVCCD);
        component.set("v.VCCDQuestionType", VCCDQuestionType);
        if(isVCCD)
            component.set("v.iVRDetails", pageReference.state.c__iVRDetails);
        console.log("iVRDetails>>"+component.get("v.iVRDetails"));
        var postVCCDEvent = $A.get("e.c:ACET_PostVCCD");
        postVCCDEvent.setParams({
            "isVCCD": isVCCD,
            "VCCDQuestionType": VCCDQuestionType,
            "pageName": component.get("v.detailPage")
        });
        postVCCDEvent.fire();
        //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - Stop

        component.find("alertsAI").alertsMethodShapshots();
        if (component.get("v.mnf") != 'mnf') {
            //component.find("caseHistoryCard").callCasesFromORS();
        }


 	     //ketki open member snapshot from claim
         if(!$A.util.isEmpty(isClaim)){
         	var calltopiccmp = component.find("calltopiccmp");
            let detailPage = component.get("v.detailPage");
            let originatorName =  component.get("v.originatorType");
            let topicName = 'View Claims';
            calltopiccmp.selectTopic(detailPage,originatorName,topicName);
            component.set("v.showHighlightsPanel",true)
          }
		 //ketki open member snapshot from claim end


        // US2099074 - Sanka

        if (interactionCard != null) {
            caseWrapper = component.get("v.caseWrapperMNF");
            caseWrapper.plFirstName = interactionCard.firstName;
            caseWrapper.plLastName = interactionCard.lastName;
            caseWrapper.plMpin = interactionCard.corpMpin;
            caseWrapper.plProviderID = interactionCard.providerId;
            caseWrapper.plState = interactionCard.state;
            caseWrapper.plStreet1 = interactionCard.addressLine1;
            caseWrapper.plStreet2 = interactionCard.addressLine2;
            caseWrapper.plZip = interactionCard.zip;
            caseWrapper.plTaxId = interactionCard.taxId;

            caseWrapper.providerNPI = interactionCard.npi;
            caseWrapper.degree = interactionCard.degreeCode;
            caseWrapper.providerMpin = interactionCard.corpMpin;
            caseWrapper.providerTpsm = interactionCard.tpsmIndicator;
            if(!$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isUndefinedOrNull(providerDetails.filterType) ){
                caseWrapper.providerFilterType = providerDetails.filterType;
            }


            component.set("v.caseWrapperMNF", caseWrapper);
        }

        // DE380979 - Thanish - Snapshot duplicate fix
        var snapshotLink = document.getElementById(pageReference.state.c__ioMemberSnapshotLinkId);
        if (!$A.util.isEmpty(snapshotLink)) {
            $A.util.removeClass(snapshotLink, "disableLink");
        }
    },

    handleNetworkEvent: function (component, event, helper) {
        var selectedPolicy = event.getParam("selectedPolicy");
        var networkStatus = event.getParam("networkStatus");
        var eligibleDate = event.getParam("eligibleDates");

        component.set("v.selectedPolicy", selectedPolicy);
        component.set("v.selectedTabType", networkStatus);
        component.set("v.eligibleDate", eligibleDate);
    },

    handlePHSEvent: function (component, event, helper) {
        var isPhs = event.getParam("isPHS");
        component.set("v.isSelectedPHS", isPhs);
    },
    // DE333920
    viewPCPHistory: function (component, event, helper) {
        var originPage = event.getParam("originPage");
        if (originPage == component.get("v.memberTabId")) {
            if (component.get("v.isShowCobHistory")) {
                helper.fireToastMessage("", "Please close any expanded components.", "Error", "dismissible", "10");
            } else {
                var historyViewed = event.getParam("historyViewed");
                var transactionId = event.getParam("transactionId");
                component.set("v.transactionId", transactionId);
                component.set("v.showPCPHistory", historyViewed);
            }
        }
    },
    // DE333920
    viewCOBHistory: function (component, event, helper) {
        var originPage = event.getParam("originPage");
        if (originPage == component.get("v.memberTabId")) {
            if (component.get("v.showPCPHistory")) {
                helper.fireToastMessage("", "Please close any expanded components.", "Error", "dismissible", "10");
            } else {
                var cobhistoryViewed = event.getParam("cobhistoryViewed");
                component.set("v.isShowCobHistory", cobhistoryViewed);

            }
        }
    },

    handleTopicClick: function (component, event, helper) {
        // US2192945 - Sanka
        // US1955585
        if (event.getParam("clickedTopic") == 'Provider Lookup') {
            component.set("v.showProviderLookup", true);
            // setTimeout(function () {
            //     component.find("providerLookup").getElement().scrollIntoView({
            //         behavior: "smooth",
            //         block: "start"
            //     });
            // }, 100);
            // US1959855 - Thanish - 23rd January 2020
            helper.createCaseWrapper(component);
        }
        // US3802608 - Thanish - 25th Aug 2021
        else if (event.getParam("clickedTopic") == 'View Appeals') {
            component.set("v.showViewAppeals", true);
        }
        else if (event.getParam("clickedTopic") == 'View PCP Referrals') {
            component.set("v.showViewReferralsPCP", true);
        } else {
            component.set("v.showFinanceComponent", true);
            // US1730906: Benefit Details Component UI: Kavinda - START
            component.set('v.showBenefitDetails', true);
            // US1730906: Benefit Details Component UI: Kavinda - END
            // setTimeout(function () {
            //     component.find("financials-comp").getElement().scrollIntoView({behavior: "smooth",block: "start"});
            // }, 100);
        }

    },

    // 16th Aug 2019 - US1866429 - Search Claim  Number UI : SARMA
    // US1955585
    handleOpenTopicBtnClick: function (component, event, helper) {
        component.set("v.isShowClaimInfo", true);
        // setTimeout(function () {
        //     component.find("claimsInfo-comp").getElement().scrollIntoView({behavior: "smooth",block: "start"});
        // }, 100);
    },
    //US1958804
    handleOpenTopicBtn: function (component, event, helper) {
        component.set("v.isShowPaymentInfo", true);
        // setTimeout(function () {
        //     component.find("claimsInfo-comp").getElement().scrollIntoView({behavior: "smooth",block: "start"});
        // }, 100);
    },

    // US2061713 Open Topic View Authorization - 9/12/2019 - Sarma
    // US1955585
    handleOpenAuthorizationResultsClick: function (component, event, helper) {
        component.set("v.isShowAuthorizationResults", true);
        // setTimeout(function () {
        //     component.find("AuthorizationResults-comp").getElement().scrollIntoView({ behavior: 'smooth', block: 'center' });
        // }, 100);
    },

    navigateToDetail: function (component, event, helper) {

        var intId = event.currentTarget.getAttribute("data-intId");


        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId: intId
                },
            },
            focus: true
        }).then(function (response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function (tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
            });
        }).catch(function (error) {

        });
    },
    //US1761826 - UHC/Optum Exclusion UI
    handleShowHideComponents: function (component, event, helper) {
        if (component.get('v.AutodocPageFeature') == event.getParam("originPage")) { // UHG Access Uniquness fix
            let isShow = event.getParam("hide_component");
            let errorMessage = event.getParam("errorMessage");  // US3475823
            component.set("v.isShowComponentBasedOnExclusions", isShow);
            if (!isShow) {
                helper.fireToastMessage("", errorMessage, "warning", "dismissible", "10000");
            }
        }
    },

    saveCase: function (cmp, event, helper) {
        var oldValue = event.getParam("oldValue");
        var value = event.getParam("value");
        if (!oldValue && value) {
            helper.saveCase(cmp, event, helper);
        }
    },
    // US1909477 - Thanish (30th July 2019)
    // Purpose - Add misdirect button to page header.
    // Copied from SAE_MisdirectController.js
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    // Thanish - End of Code.

    //US2061732 - Added by Avish
    showSRNCreateMsg: function (cmp, event, helper) {

        if (cmp.get("v.memberTabId") == event.getParam("memberTabId")) {
            var endDate = event.getParam("termedFlag");
            cmp.set("v.SRNFlag", event.getParam("policyStatus"));
            cmp.set("v.policyNumber", event.getParam("policyNumber"));
        }

    },
    //US2061732 - Ends
    // US2579637
    deployHouseHoldValues: function (component, evt, helper) {
        helper.postActionHousehold(component);
    },

    // US2618180
    handleCallTopicAutodoc: function (cmp, event, helper) {
        var memberTabId = event.getParam("memberTabId");
        var AutodocKey = event.getParam("AutodocKey");
        var AutodocPageFeature = event.getParam("AutodocPageFeature");
        if ((cmp.get('v.memberTabId') == memberTabId) || memberTabId == '-') {
            cmp.set('v.ADKeyMemberDtlCallTopic', AutodocKey);
            cmp.set('v.ADPageFeatureMemberDtlCallTopic', AutodocPageFeature);
        }
    },

    //US2076634 - HIPAA Guidelines Button - Sravan
    handleHippaGuideLines: function (component, event, helper) {
        var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if (!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)) {
            window.open(hipaaEndPointUrl, '_blank');
        }
        component.set("v.isHippaInvokedInProviderSnapShot", true);

        // DE373867 - Thanish - 8th Oct 2020
        var cardDetails = new Object();
        cardDetails.componentName = "HIPAA Guidelines";
        cardDetails.componentOrder = 0;
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [{
            "checked": true,
            "disableCheckbox": true,
            "fieldName": "HIPAA Guidelines",
            "fieldType": "outputText",
            "fieldValue": "Accessed"
        }];
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
    },

    //Policy switching
    handleXrefChange: function (component, event, helper) {
        var xRefId = event.getParam("xRefId");
        var xRefIdOrs = event.getParam("xRefIdOrs");
        var selectedMemberId = event.getParam("memberId");
        //if (xRefId != component.get("v.xRefId")) { //DE356375 - Avish
        component.set("v.xRefIdORS", xRefIdOrs);
        component.set("v.xRefId", xRefId);
        var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
        appEvent.setParams({
            "xRefId": xRefId,
            "xRefIdOrs": xRefIdOrs,
            "memberID": selectedMemberId,
            "memberTabId": component.get('v.memberTabId'),
            "flowType": 'Member'
        });
        appEvent.fire();
        //}
    },

    // US2931847 - TECH
    handleheaderClick: function (cmp, event, helper) {
        try {
            var data = event.getParam("data");
            cmp.set("v.searchObject", data);
            cmp.set("v.populatedFromHeader", true);
            var calltopiccmp = cmp.find("calltopiccmp");
            calltopiccmp.lookuproute();
        } catch (error) {
            console.log(error.message);
        }
    },

    handleAuthProviderClick: function (cmp, event, helper) {
        var searchObject = event.getParam("searchObject");
        var tabId = event.getParam("tabId");
        if (cmp.get("v.currentTabId") == tabId) {
            cmp.set("v.searchObject", searchObject);
            cmp.set("v.populatedFromHeader", true);
            var calltopiccmp = cmp.find("calltopiccmp");
            calltopiccmp.lookuproute();
            // alert('handleAuthProviderClick');
        }
    },
    //US2925631 - Tech: Member Alerts Convert Member ID to EEID and Include the Business Segment - Sravan
    handleEEIDChange: function (component, event, helper) {
        console.log('handleEEIDChange');
        var memberSubscriberId = component.get("v.memberSubscriberId");
        if (!$A.util.isUndefinedOrNull(memberSubscriberId) && !$A.util.isEmpty(memberSubscriberId)) {
            component.set("v.alertMemberId", memberSubscriberId);
            var caseWrapper = component.get("v.caseWrapper");
            if (!$A.util.isUndefinedOrNull(caseWrapper.EEID) && !$A.util.isEmpty(caseWrapper.EEID)) {
                caseWrapper.EEID = memberSubscriberId;
                component.set("v.caseWrapper",caseWrapper);
            }
            var caseWrapperMNF = component.get("v.caseWrapperMNF");
            if (!$A.util.isUndefinedOrNull(caseWrapperMNF.EEID)) {
                caseWrapperMNF.EEID = memberSubscriberId;
                component.set("v.caseWrapperMNF",caseWrapperMNF);
            }
            component.find("alertsAI").alertsMethodShapshots();
        }
    },
    // US3536342 - Thanish - 3rd Jun 2021
    toggleHighlightPanel: function (cmp, event, helper) {
        cmp.set("v.showHighlightsPanel", !cmp.get("v.showHighlightsPanel"));
        $A.util.toggleClass(event.currentTarget, "isOpened");
    },

    navigateToCallTopic: function (component, event, helper) {
        var selectedPillId = event.getSource().get("v.label");
        //callcontainer
        component.set("v.callTopicName", selectedPillId);
        var callcontainer = component.find("callcontainer");
        callcontainer.scrollIntoViewMember(selectedPillId);
    },

    navigateToCallTopicEventHandler: function (component, event, helper) {
        var selectedPillId = event.getParam("callTopicName");
        var callTopicTabId = event.getParam("tabId");
        if (component.get("v.callTopicTabId") === callTopicTabId) {
            component.set("v.callTopicName", selectedPillId);
            var callcontainer = component.find("callcontainer");
            callcontainer.scrollIntoViewMember(selectedPillId);
        }

    },

    // Save Case Consolidation - US3424763
    getAllAutoDoc: function (cmp, event, helper) {
        var autodocUniqueId = cmp.get("v.autodocUniqueId");
        console.log(cmp.get("v.autodocUniqueId"));
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        if (caseNotSavedTopics.includes('Plan Benefits')) {
            var caseEvent = $A.get("e.c:ACET_HandleCaseWrapperEvent");
            caseEvent.setParams({
                "autodocUniqueId": autodocUniqueId + 'Financials'
            });
            caseEvent.fire();
        }
        var autoItems = _autodoc.getAllAutoDoc(cmp.get("v.autodocUniqueId"), true);
        cmp.set("v.tableDetails_prev", autoItems.selectedList);
        cmp.set("v.showpreview", true);
        console.log(JSON.stringify(autoItems));
    },

    openSaveCase: function (cmp, event, helper) {
        helper.openSaveCaseHelper(cmp, event, helper);
    },

    closeWarning: function (cmp, event, helper) {
        cmp.set("v.showWarning", false);
    },

    // US3536342 - Thanish - 3rd Jun 2021
    toggleComments: function(cmp, event, helper){
        cmp.set("v.showComments", !cmp.get("v.showComments"));
        $A.util.toggleClass(event.currentTarget, "isOpened");
    },

    toggleCommentsPopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    getClaimEngineCode:function (cmp, event, helper) {
        var claimEngineCode = event.getParam("claimEngineCode");
        var groupNumber = event.getParam("groupNumber");
        var claimEngineCodeObj=cmp.get("v.claimEngineCodeObj");
        var claimDetails = new Object();
        claimDetails.claimEngineCode = claimEngineCode;
        claimDetails.groupNumber = groupNumber;
        claimEngineCodeObj.push(claimDetails);
        cmp.set("v.claimEngineCodeObj", claimEngineCodeObj);
        console.log('claimEngineCodeObj@@@@@'+JSON.stringify(cmp.get("v.claimEngineCodeObj")));

    },

    // DE491765
    handlePolicySnipperChange: function(cmp){
        var policySpinner = cmp.get('v.policySpinner');
        if(!policySpinner){
            cmp.set('v.isSaveCaseDisabled', false);
        }else{
            cmp.set('v.isSaveCaseDisabled', true);
        }
    }
})