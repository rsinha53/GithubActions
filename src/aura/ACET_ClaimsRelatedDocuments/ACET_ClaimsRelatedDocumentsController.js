({
    onInit : function(cmp, event, helper) {
        var relatedDocMemberEOB = {};
        relatedDocMemberEOB.docName = 'Member EOB';
        relatedDocMemberEOB.docHelpText = 'Displays Member Explanation of Benefits available once a claim has been processed.';
        relatedDocMemberEOB.docSectionId = 'MemberEOB';

        var relatedDocClaimLetters = {};
        relatedDocClaimLetters.docName = 'Claim Letters';
        relatedDocClaimLetters.docHelpText = 'Displays Claim Letters for pended claims, reconsiderations, etc.';
        relatedDocClaimLetters.docSectionId = 'ClaimLetters';

        var relatedDocClaimImages = {};
        relatedDocClaimImages.docName = 'Claim Images';
        relatedDocClaimImages.docHelpText = '';
        relatedDocClaimImages.docSectionId = 'ClaimImages';

        var relatedDocAttachments = {};
        relatedDocAttachments.docName = 'Attachments';
        relatedDocAttachments.docHelpText = '';
        relatedDocAttachments.docSectionId = 'Attachments';

        var relatedDocProviderRemAdvice = {};
        relatedDocProviderRemAdvice.docName = 'Provider Remittance Advice';
        relatedDocProviderRemAdvice.docHelpText = 'Displays Provider Remittance Advice available once a claim has been processed.';
        relatedDocProviderRemAdvice.docSectionId = 'ProviderRemittance';


        var relatedDocumentList = cmp.get("v.relatedDocumentList");
         relatedDocumentList.push(relatedDocAttachments);
         relatedDocumentList.push(relatedDocClaimImages);
         relatedDocumentList.push(relatedDocClaimLetters);
         relatedDocumentList.push(relatedDocMemberEOB);
         relatedDocumentList.push(relatedDocProviderRemAdvice);





        cmp.set("v.relatedDocumentList",relatedDocumentList);
        console.log('###PaymentNumber'+cmp.get("v.PaymentNumber"));


    },
	onAttmntSelect : function(component,event, helper){
        /*var attachmentList = [];
        attachmentList.push({
            value : event.getParam('attchName')
        });*/
        var attchtypeext=event.getParam('attchtypeext');
        /*component.set("v.attachmentList", attachmentList);
        var lst = component.get("v.attachmentList");
        for(var i=0; i<lst.length; i++){
        }*/
        var claimNo=component.get("v.claimNo");
        var cmpName = "Claim Related Documents: "+claimNo;
        console.log('AutodoccmpName'+JSON.stringify(cmpName));
        var getcardDetails = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"),cmpName);
        console.log('getcardDetails'+JSON.stringify(getcardDetails));
        if(!$A.util.isEmpty(getcardDetails)){
            component.set("v.cardDetails",getcardDetails);
        }
        if($A.util.isEmpty(component.get("v.cardDetails"))){
            helper.autoDocLink(component, event, helper,'',event.getParam('attchName')+attchtypeext);
        }else{
            helper.autoDocLink1(component, event, helper,'',event.getParam('attchName')+attchtypeext);
        }
        
    },
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }

    },
    navigateToClaimsDoc: function (component, event, helper) {
        var idx = event.target.getAttribute('data-index');
        var relatedDoc = component.get("v.relatedDocumentList")[idx];
        console.log('###s'+JSON.stringify(relatedDoc));
        console.log('###selectedDoc'+relatedDoc.docName);
        console.log('###63'+JSON.stringify(component.get("v.relatedDocData")));
        //Added by Mani--Start
        var getcardDetails = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"),'Claim Related Documents');
        console.log("getcardDetails@@"+getcardDetails);
        console.log("getcardDetails@@"+JSON.stringify(getcardDetails));
        if(!$A.util.isEmpty(getcardDetails)){
            component.set("v.cardDetails",getcardDetails);
        }
        if($A.util.isEmpty(component.get("v.cardDetails"))){
            helper.autoDocLink(component, event, helper,relatedDoc.docName,relatedDoc.docName+' was selected.');

        }else{
            helper.autoDocLink1(component, event, helper,relatedDoc.docName,relatedDoc.docName+' was selected.');

        }
        //Added by Mani-End

        var workspaceAPI = component.find("workspace");
        var matchingTabs = [];
        //var relatedDoc = 'relatedDoc';
        var relUniqueId = component.get('v.claimNo') + relatedDoc;

        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabRelDocUniqueId = response[i].subtabs[j].pageReference.state.c__relatedDocTabUnique;
                            if (relUniqueId === tabRelDocUniqueId) {
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            }
                        }
                    }
                }
            }

            if (true) {
                if(!(matchingTabs.length === 0)){
                    workspaceAPI.closeTab({
                        tabId:matchingTabs[0].tabId
                    });
                }

                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACET_ClaimDocuments"
                            },
                            "state": {
                                //"c__selectedDocument": relatedDoc.docName,
                                "c__claimNo": component.get("v.claimNo"),
                                "c__relatedDocTabUnique": relUniqueId,
                                "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                                 "c__docSectionId": relatedDoc.docSectionId,
                                 "c__interactionID": component.get('v.contactUniqueId'),
                            "c__contactUniqueId": component.get('v.contactUniqueId'),
                                "c__autodocUniqueId": component.get("v.autodocUniqueId"),
                                "c__relatedDocData": component.get("v.relatedDocData"),
                                /*,"c__interactionRec": JSON.stringify(component.get('v.interactionRec')),
                                "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId"),*/

                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {


                        workspaceAPI.setTabLabel({
                            tabId: subtabId,
                            label: 'Documents'
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subtabId,
                            icon: "standard:file",
                            //icon:"custom:custom17",
                            iconAlt:" Claim Documents"
                        });
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                tabURL= tabURL.replace(/(c__docSectionId=)[^\&]+/, '$1' + relatedDoc.docSectionId);
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.refreshTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });

                $A.util.removeClass(event.currentTarget, "disableLink");
            }
})

    },
    getPaymentNumber: function (component, event, helper) {
        console.log('###child PaymentNumber'+component.get("v.PaymentNumber"));
        var paymentNumber = component.get("v.PaymentNumber");
        if(!$A.util.isUndefinedOrNull(paymentNumber) && !$A.util.isEmpty(paymentNumber) && paymentNumber != '--'){
            var relatedDocData = component.get("v.relatedDocData");
            relatedDocData.paymentNumber = paymentNumber;
            console.log("###child PaymentNumber" + relatedDocData);
            component.set("v.relatedDocData",relatedDocData);
        }
    }
})