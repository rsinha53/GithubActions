({
	SaveCase : function(component, event, helper) {
		// US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
		component.set("v.providerSearchResultsADMultiplePages", false);

		component.set("v.isModalOpen",true);
	},

	init : function(component, event, helper){		
		var caseWrapper = new Object();		
		component.set("v.caseWrapper",caseWrapper);
	},
	closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
        
    },
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
	providerDataChange: function(component, event, helper){
		//US1970508 - Ravindra
		let providerDetails = component.get("v.ProviderCardDetails");
		var interactionRec = component.get("v.interactionRec");
		console.log(JSON.parse(JSON.stringify(providerDetails)));
		var taxId = "";
		var providerId = "";
		var originator = "";
		if (component.get("v.providerNotFound")) {
			taxId = providerDetails.taxIdOrNPI;
		} else if (component.get("v.isProviderSearchDisabled")) {
			taxId = "";
		} else {
			originator = interactionRec.Originator__c;
			taxId = providerDetails.TaxId;
			providerId = providerDetails.ProviderId;
		}
		//

		var subjectDetails = component.get("v.subjectDetails");
		// alert(JSON.stringify(subjectDetails) );
		//let providerDetails = component.get("v.ProviderCardDetails");
		var caseWrapper = component.get("v.caseWrapper");

		caseWrapper.providerId = providerId;

		//Originator Details
		caseWrapper.providerContactId = originator;
		caseWrapper.TaxId = taxId;
		caseWrapper.noProviderToSearch = component.get("v.isProviderSearchDisabled");
		caseWrapper.providerNotFound = component.get("v.providerNotFound");
		caseWrapper.noMemberToSearch = component.get("v.noMemberToSearch");
        caseWrapper.phoneNumber = providerDetails.EffectivePhoneNumber;////US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
        caseWrapper.providerInfoCity =  providerDetails.AddressCity;
		caseWrapper.mnf = component.get("v.mnf");
		caseWrapper.OriginatorName = providerDetails.ProviderName;
		caseWrapper.OriginatorType = 'Provider';
		caseWrapper.Interaction = component.get("v.interactionId");
		caseWrapper.OriginatorContactName = subjectDetails.contactName;
		//US2740876 - Sravan - Start

		caseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
        caseWrapper.OriginatorLastName =  component.get("v.flowDetailsForRoutingScreen").contactLastName;
		//US2740876 - Sravan - End
		// US2435572
		caseWrapper.providerNPI = providerDetails.NPI;
		caseWrapper.degree = component.get("v.credentialList");

		// Subject Card
		caseWrapper.SubjectName = subjectDetails.fullName;
		caseWrapper.SubjectType = subjectDetails.subjectType;
		caseWrapper.SubjectDOB = subjectDetails.DOB;
		caseWrapper.SubjectId = subjectDetails.subjectId;
		caseWrapper.SubjectGroupId = subjectDetails.subjectGroupId;

		//US2699902 - Avish
        caseWrapper.contactNumber = subjectDetails.contactNumber;
        caseWrapper.contactExt = subjectDetails.contactExt;

		component.set("v.caseWrapper",caseWrapper);
		setTimeout(function () {
            var tabKey = component.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
        }, 1);
        helper.hideproviderphysicianSpinner(component);
	},

	openPreview : function(component, event, helper){
		// US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
		component.set("v.providerSearchResultsADMultiplePages", false);

		component.set("v.isPreviewModalOpen", true);
		//US2076634 - HIPAA Guidelines Button - Sravan
        if(component.get("v.isHippaInvokedInProviderSnapShot")){
			var autoDocKey = component.get("v.AutodocKey");
            document.getElementById(autoDocKey+'HIPPA').setAttribute("data-auto-doc-feature",component.get("v.autodocPageFeature"));
        }
        component.set("v.isPreviewOpen", true);
	},

	openTTSPopup: function (component, event, helper) {
		// US2543182 - Thanish - 13th May 2020
		if(component.get("v.AutodocKey") == event.getParam("autodocKey")) {
			component.set("v.routingSOPLinkClicked", event.getParam("linkClicked"));
			component.set("v.isModalOpen", event.getParam("openPopup"));
		}
	}
})