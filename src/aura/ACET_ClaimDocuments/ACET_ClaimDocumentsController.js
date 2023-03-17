({
	onInit : function(cmp, event, helper) {

        var pageReference = cmp.get("v.pageReference");
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        cmp.set("v.claimNo", pageReference.state.c__claimNo);
        cmp.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
        var activeSections=pageReference.state.c__docSectionId;
        cmp.set("v.activeSections",activeSections);
        cmp.set("v.contactUniqueId",pageReference.state.c__contactUniqueId);
        cmp.set("v.autodocUniqueId",pageReference.state.c__autodocUniqueId);
        console.log('###12'+pageReference.state.c__autodocUniqueId);
        console.log('###13'+JSON.stringify(pageReference.state.c__relatedDocData));
        cmp.set("v.relatedDocData",pageReference.state.c__relatedDocData);
        cmp.set("v.isClaimNotOnFile",pageReference.state.c__isClaimNotOnFile);
        cmp.set("v.indexNameList",pageReference.state.c__indexNameList);

    },
    //View Claim Documents Page - Add hippa guidelines Button
	 handleHippaGuideLines : function(component, event, helper) {
         var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
         if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
              window.open(hipaaEndPointUrl, '_blank');
         }
         component.set("v.isHipaa",true);
	},
    openMisdirectComp: function (component, event, helper) {
        console.log("component retrieved "+ component);
        helper.openMisDirect(component, event, helper);
    },
     handleHippaGuideLines : function(component, event, helper) {
         var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
         if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
              window.open(hipaaEndPointUrl, '_blank');
         }
         component.set("v.isHipaa",true);

         //Added by Mani -- Start 12/02/2020
         var cardDetails = new Object();
         cardDetails.componentName = "HIPAA Guidelines";
         cardDetails.componentOrder = 0;
         cardDetails.noOfColumns = "slds-size_1-of-1";
         cardDetails.type = "card";
         cardDetails.allChecked = false;
         cardDetails.cardData = [
             {
                 "checked": true,
                 "disableCheckbox": true,
                 "fieldName": "HIPAA Guidelines",
                 "fieldType": "outputText",
                 "fieldValue": "HIPAA Guidelines button was selected."
             }
         ];
         _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
         //Added by Mani -- End
	},
    handleSectionToggle: function (cmp, event, helper) {
        var openSections = event.getParam('openSections');
        var activeSections = cmp.find("accordion").get('v.activeSectionName');
        console.log("activeSections"+ activeSections);
        if(activeSections == 'Attachments')
        {
            var emptyList=[];
            cmp.set("v.AttachmentsList",emptyList);
            var indexNameList=[];
            indexNameList.push('u_prov_attch');
            cmp.set("v.attachmentEmptyCheck",false);
            helper.showAttachmentSpinner(cmp,'attchmentspinner');
            helper.getAttachments(cmp, event, helper, indexNameList);
        }
        else if(activeSections == 'ClaimImages'){
            var emptyList=[];
            cmp.set("v.claimImagesList",emptyList);
            cmp.set("v.claimImagesEmptyCheck",false);
            var relatedDocData = cmp.get("v.relatedDocData");
            var platform = relatedDocData.platform;
            console.log("platform"+ platform);
            helper.showAttachmentSpinner(cmp,'claimImages');
            var indexNameList=[];
            if(!cmp.get("v.isClaimNotOnFile")){
            if(platform == 'UNET'){
           		//helper.getClaimImagesUNETGroup1(cmp, event, helper);
           		helper.getClaimImagesUNETGroup2(cmp, event, helper);
            }
            else if(platform != 'UNET'){
               	helper.getClaimImagesOtherGroup1(cmp, event, helper);
            }
            }else{
                if(cmp.get("v.indexNameList") == "u_edi_claim"){
                    indexNameList.push('u_edi_claim');
                }else{
                    indexNameList.push('u_keyed_claim');
                }
                helper.getClaimImagesCNF(cmp, event, helper, indexNameList);
            }

            helper.hidettachmentSpinner(cmp,'claimImages');
        }
        else if(activeSections == 'ProviderRemittance'){
            var emptyList=[];
            cmp.set("v.ProviderRemittanceAdviceList",emptyList);
            cmp.set("v.praEmptyCheck",false);
            var relatedDocData = cmp.get("v.relatedDocData");
            var platform = relatedDocData.platform;
            console.log("platform"+ platform);
            if(platform == 'UNET'){
                var indexNameList=[];
                indexNameList.push('u_eps_prov_eob');
                indexNameList.push('u_unet_gflx_eob');
                helper.showAttachmentSpinner(cmp,'praspinner');
                helper.getProviderRemittanceAdviceGroup1(cmp, event, helper,indexNameList);
            }
            if(platform == 'COSMOS'){
                var indexNameList=[];
                indexNameList.push('u_cosmos_pra');
                indexNameList.push('u_cosmos_pra_ub');
                helper.showAttachmentSpinner(cmp,'praspinner');
                helper.getProviderRemittanceAdviceGroup1(cmp, event, helper,indexNameList);
            }
        }
        else if(activeSections == 'ClaimLetters'){
            var emptyList=[];
            cmp.set("v.ClaimLettersList",emptyList);
            cmp.set("v.ClaimLettersCheck",false);
            var relatedDocData = cmp.get("v.relatedDocData");
            var platform = relatedDocData.platform;  
            if(platform == 'UNET'){
                var indexNameList=[];
                indexNameList.push('u_mli_elgs');
                indexNameList.push('u_nasc_salsa_ltr');
                helper.showAttachmentSpinner(cmp,'clspinner');
                helper.getClaimLetters(cmp, event, helper,indexNameList);
            }
            else if(platform == 'COSMOS'){
                var indexNameList=[];
                indexNameList.push('u_cos_clmltr_mem_doc');
                indexNameList.push('u_cos_clmltr_prov_doc');
                indexNameList.push('u_ovat_mapd_ltr');
                helper.showAttachmentSpinner(cmp,'clspinner');
                helper.getClaimLetters(cmp, event, helper,indexNameList);
            }
        }
        else if(activeSections == 'MemberEOB'){
          var emptyList=[];
            cmp.set("v.memberEOBList",emptyList);
            cmp.set("v.memberEOBCheck",false);
            var relatedDocData = cmp.get("v.relatedDocData");
            var platform = relatedDocData.platform;  
            if(platform == 'UNET'){
                 var indexNameList=[];
                indexNameList.push('u_mber_eob');
                helper.showAttachmentSpinner(cmp,'memspinner');
                helper.getMemberEOB(cmp, event, helper,indexNameList);
            }else  if(platform == 'COSMOS'){
                var indexNameList=[];
                indexNameList.push('u_cosmos_eob');
                indexNameList.push('u_cosmos_eob_ub');
                indexNameList.push('u_mr_partc_eob');
                helper.showAttachmentSpinner(cmp,'memspinner');
                helper.getMemberEOB(cmp, event, helper,indexNameList);
            }
        }
    },
         navigateToClaimsDoc: function (cmp, event, helper) {
             var elementID = event.currentTarget.getAttribute("data-docId") + 'link';
        if (!$A.util.isUndefinedOrNull(document.getElementById(elementID))) {
            document.getElementById(elementID).style.pointerEvents="none";
            document.getElementById(elementID).style.cursor="default";
            document.getElementById(elementID).style.color="black";
        }
        var titleDocID = event.currentTarget.getAttribute("data-docId");
		var callDoc360 = event.currentTarget.getAttribute("data-callDoc360");
        var docLst = cmp.get("v.docIdLst");
        if(docLst.length == 0){
            docLst.push(titleDocID);
        }else{
            for(var i =0; i<docLst.length;i++){
                if(docLst[i] != titleDocID){
                    docLst.push(titleDocID);
                }
            }
        }

        cmp.set("v.docIdLst",docLst);
        var docId = 'documentId=' + event.currentTarget.getAttribute("data-docId"); //'0902a771800d5f63'

        var encodedString = btoa(docId);
        //var encodedString = Base64.encode(docId);
        console.log(encodedString);
        //encodedString = 'ZG9jdW1lbnRJZD0wOTAyYjVlYzhiYzIwOGYy';
        //var URLToSend = 'https://edms-cdms.uhc.com/ecaa/resources/?viewDocument='+encodedString; //ZG9jdW1lbnRJZD0wOTAyYTc3MTgwMGQ1ZjYz
        var URLToSend = encodedString;
        var memberTabId = cmp.get("v.memberTabId");
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_EDMSIframe" // c__<comp Name>
                                },
                                "state": {
                                    "iframeUrl":URLToSend,
                                    "memberTabId" : memberTabId,
                                    "docID": titleDocID
                                }
                            },
                focus: true
            }).then(function (subtabId) {
                let mapSubTabID = new Map();
                mapSubTabID.set(titleDocID,subtabId);
                cmp.set("v.subTabMap",mapSubTabID);
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: titleDocID
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: "Service Request Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });

    },
	navigateTodoc360GlobalURL: function (cmp, event, helper) {
         helper.navigateTodoc360GlobalURL(cmp, event, helper);          
     }



})