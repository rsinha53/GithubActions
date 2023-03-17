// US1938551 - Thanish - 19th Dec 2019
({
    onLoad : function(cmp) {
        cmp.set("v.success_icon", $A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png');
        cmp.set("v.fail_icon", $A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png');
    },

    onCNSAllChange : function(cmp, event, helper){
        // empty search box
        cmp.find("searchBox").set("v.value", "");

        let cAndSContractData = cmp.get("v.cAndSContractData");

        cAndSContractData.filtered = helper.filterActiveData(!cmp.get("v.isCNSAll"), cAndSContractData.unfiltered);
        cAndSContractData.display = cAndSContractData.filtered.slice(0, 11);

        cmp.set("v.cAndSContractData", cAndSContractData);
    },

    onENIAllChange : function(cmp, event, helper){
        // empty search box
        cmp.find("searchBox").set("v.value", "");

        let eAndIContractData = cmp.get("v.eAndIContractData");

        if(cmp.get("v.isENIAll")) {
            eAndIContractData.processed = eAndIContractData.unfiltered;
        } else {
            eAndIContractData.processed = helper.filterENIAccordingToMember(cmp, eAndIContractData.filtered);
        }
        eAndIContractData.display = eAndIContractData.processed.slice(0, 11);

        cmp.set("v.eAndIContractData", eAndIContractData);
    },

    onMNRAllChange : function(cmp, event, helper){
        // empty search box
        cmp.find("searchBox").set("v.value", "");

        let mAndRContractData = cmp.get("v.mAndRContractData");

        if(cmp.get("v.isMNRAll")) {
            mAndRContractData.processed = mAndRContractData.unfiltered;
        } else {
            mAndRContractData.processed = helper.filterMNRAccordingToMember(cmp, mAndRContractData.filtered);
        }
        mAndRContractData.display = mAndRContractData.processed.slice(0, 11);

        cmp.set("v.mAndRContractData", mAndRContractData);
    },

    cnsCellClicked : function(cmp, event){
        cmp.set("v.caseItemStatus", "true");
        let tdlist = event.currentTarget.parentNode.getElementsByTagName("td");
        let autodocCheckbox = tdlist[0].getElementsByTagName("input")[0];
        let resolveCheckbox = tdlist[tdlist.length - 1].getElementsByTagName("input")[0];
        let cAndSContractData = cmp.get("v.cAndSContractData");
        let cnsAutodoc = cmp.get("v.cnsAutodoc");

        if((!autodocCheckbox.disabled) && (event.currentTarget.className != "autodoc") && (event.currentTarget.className != "autodoc-case-item-resolved cnsResolve")) {
            if(autodocCheckbox.checked) {
                autodocCheckbox.checked = false;
                resolveCheckbox.checked = false;
            } else {
                autodocCheckbox.checked = true;
                resolveCheckbox.checked = true;
            }
        }

        let selectedData = cAndSContractData.display[event.currentTarget.getAttribute("data-index")];
        selectedData.contractSummary.autodoc = autodocCheckbox.checked;
        selectedData.contractSummary.resolved = resolveCheckbox.checked;

        let index = cnsAutodoc.findIndex(function(obj){
            return obj.cnsId == selectedData.cnsId;
        });

        let filteredIndex = cAndSContractData.filtered.findIndex(function(obj){
            return obj.cnsId == selectedData.cnsId;
        });
        cAndSContractData.filtered[filteredIndex] = selectedData;

        let unfilteredIndex = cAndSContractData.unfiltered.findIndex(function(obj){
            return obj.cnsId == selectedData.cnsId;
        });
        cAndSContractData.unfiltered[unfilteredIndex] = selectedData;

        if(index > -1) {
            if(selectedData.contractSummary.autodoc) {
                cnsAutodoc[index] = selectedData;
            } else {
                cnsAutodoc.splice(index, 1);
            }
        } else {
            if(selectedData.contractSummary.autodoc) {
                cnsAutodoc.push(selectedData);
            }
        }
        cmp.set("v.cnsAutodoc", cnsAutodoc);
        cmp.set("v.cAndSContractData", cAndSContractData);
    },

    eniCellClicked : function(cmp, event){
        cmp.set("v.caseItemStatus", "true");
        let tdlist = event.currentTarget.parentNode.getElementsByTagName("td");
        let autodocCheckbox = tdlist[0].getElementsByTagName("input")[0];
        let resolveCheckbox = tdlist[tdlist.length - 1].getElementsByTagName("input")[0];
        let eAndIContractData = cmp.get("v.eAndIContractData");
        let eniAutodoc = cmp.get("v.eniAutodoc");

        if((!autodocCheckbox.disabled) && (event.currentTarget.className != "autodoc") && (event.currentTarget.className != "autodoc-case-item-resolved eniResolve")) {
            if(autodocCheckbox.checked) {
                autodocCheckbox.checked = false;
                resolveCheckbox.checked = false;
            } else {
                autodocCheckbox.checked = true;
                resolveCheckbox.checked = true;
            }
        }

        let selectedData = eAndIContractData.display[event.currentTarget.getAttribute("data-index")];
        selectedData.contractSummary.autodoc = autodocCheckbox.checked;
        selectedData.contractSummary.resolved = resolveCheckbox.checked;

        let index = eniAutodoc.findIndex(function(obj){
            return obj.eniId == selectedData.eniId;
        });

        let processedIndex = eAndIContractData.processed.findIndex(function(obj){
            return obj.eniId == selectedData.eniId;
        });
        eAndIContractData.processed[processedIndex] = selectedData;

        let filteredIndex = eAndIContractData.filtered.findIndex(function(obj){
            return obj.eniId == selectedData.eniId;
        });
        eAndIContractData.filtered[filteredIndex] = selectedData;

        let unfilteredIndex = eAndIContractData.unfiltered.findIndex(function(obj){
            return obj.eniId == selectedData.eniId;
        });
        eAndIContractData.unfiltered[unfilteredIndex] = selectedData;

        if(index > -1) {
            if(selectedData.contractSummary.autodoc) {
                eniAutodoc[index] = selectedData;
            } else {
                eniAutodoc.splice(index, 1);
            }
        } else {
            if(selectedData.contractSummary.autodoc) {
                eniAutodoc.push(selectedData);
            }
        }
        cmp.set("v.eniAutodoc", eniAutodoc);
    },

    mnrCellClicked : function(cmp, event){
        cmp.set("v.caseItemStatus", "true");
        let tdlist = event.currentTarget.parentNode.getElementsByTagName("td");
        let autodocCheckbox = tdlist[0].getElementsByTagName("input")[0];
        let resolveCheckbox = tdlist[tdlist.length - 1].getElementsByTagName("input")[0];
        let mAndRContractData = cmp.get("v.mAndRContractData");
        let mnrAutodoc = cmp.get("v.mnrAutodoc");

        if((!autodocCheckbox.disabled) && (event.currentTarget.className != "autodoc") && (event.currentTarget.className != "autodoc-case-item-resolved mnrResolve")) {
            if(autodocCheckbox.checked) {
                autodocCheckbox.checked = false;
                resolveCheckbox.checked = false;
            } else {
                autodocCheckbox.checked = true;
                resolveCheckbox.checked = true;
            }
        }

        let selectedData = mAndRContractData.display[event.currentTarget.getAttribute("data-index")];
        selectedData.contractSummary.autodoc = autodocCheckbox.checked;
        selectedData.contractSummary.resolved = resolveCheckbox.checked;

        let index = mnrAutodoc.findIndex(function(obj){
            return obj.mnrId == selectedData.mnrId;
        });

        let processedIndex = mAndRContractData.processed.findIndex(function(obj){
            return obj.mnrId == selectedData.mnrId;
        });
        mAndRContractData.processed[processedIndex] = selectedData;

        let filteredIndex = mAndRContractData.filtered.findIndex(function(obj){
            return obj.mnrId == selectedData.mnrId;
        });
        mAndRContractData.filtered[filteredIndex] = selectedData;

        let unfilteredIndex = mAndRContractData.unfiltered.findIndex(function(obj){
            return obj.mnrId == selectedData.mnrId;
        });
        mAndRContractData.unfiltered[unfilteredIndex] = selectedData;

        if(index > -1) {
            if(selectedData.contractSummary.autodoc) {
                mnrAutodoc[index] = selectedData;
            } else {
                mnrAutodoc.splice(index, 1);
            }
        } else {
            if(selectedData.contractSummary.autodoc) {
                mnrAutodoc.push(selectedData);
            }
        }
        cmp.set("v.mnrAutodoc", mnrAutodoc);
    },

    emptyChecked : function(cmp, event, helper){
        let checkbox = document.getElementById(event.currentTarget.getAttribute("data-chkBxId"));
        checkbox.checked = event.currentTarget.checked;
    },

    autodocClicked : function(cmp, event) {
        cmp.set("v.caseItemStatus", "true");
        let tdList = event.currentTarget.parentElement.parentElement.getElementsByTagName("td");
        let autodocCheckbox = event.currentTarget;
        let resolveCheckbox = tdList[tdList.length - 1].getElementsByTagName("input")[0];

        if(autodocCheckbox.checked) {
            resolveCheckbox.checked = true;
        } else {
            resolveCheckbox.checked = false;
        }
    },

    resolveClicked : function(cmp, event) {
        cmp.set("v.caseItemStatus", "true");
        let tdList = event.currentTarget.parentElement.parentElement.getElementsByTagName("td");
        let autodocCheckbox = tdList[0].getElementsByTagName("input")[0];
        let resolveCheckbox = event.currentTarget;

        if(resolveCheckbox.checked) {
            autodocCheckbox.disabled = true;
            autodocCheckbox.checked = true;
        } else {
            autodocCheckbox.disabled = false;
        }
    },

    defaultTab : function(component,event,helper){

         var sourceCode = component.get("v.sourceCode");
     	 component.set("v.sourceCode",sourceCode);

        if(!$A.util.isEmpty(sourceCode)){
            if(sourceCode == 'CO'){
                component.set("v.selectedTab","MNR");
            }else if(sourceCode == 'CS'){
                component.set("v.selectedTab","ENI");
            }
            else if(sourceCode == 'AP'){
            	component.set("v.selectedTab","CNS");
            }
            else if(sourceCode == 'PA'){
            	component.set("v.selectedTab","PHS");
            }else{
        	    component.set("v.selectedTab","ENI");
            }
        }
    },
    refreshContractSummary: function (component, event, helper){
     	 var sourceCode = event.getParam("sourceCode");
        if(!$A.util.isEmpty(sourceCode)){
            if(sourceCode == 'CO'){
                component.set("v.selectedTab","MNR");
            }else if(sourceCode == 'CS'){
                component.set("v.selectedTab","ENI");
            }
            else if(sourceCode == 'AP'){
            	component.set("v.selectedTab","CNS");
            }
            else if(sourceCode == 'PA'){
            	component.set("v.selectedTab","PHS");
            }else{
        	    component.set("v.selectedTab","ENI");
            }
        }
    },

    sortByContractId : function(component, event, helper) {
        helper.sortBy(component,"contractId","contractSummary");
    },
    sortyByEniOrg :  function(component, event, helper){
        helper.sortBy(component,"org","contractSummary");
    },
    sortyByEniProduct : function(component, event, helper){
        helper.sortBy(component,"product","contractSummary");
    },
    sortyByEniMarketType :  function(component, event, helper){
        helper.sortBy(component,"marketType","contractSummary");
    },
    sortyByEniMarketNo :  function(component, event, helper){
        helper.sortBy(component,"marketNumber","contractSummary");
    },
    sortyByEniIPA :  function(component, event, helper){
        helper.sortBy(component,"ipa","contractSummary");
    },
    sortyByEniEffective :  function(component, event, helper){
        helper.sortBy(component,"effectiveAndCancel","contractSummary");
    },
    sortyByEniType :  function(component, event, helper){
        helper.sortBy(component,"contractType","contractSummary");
    },
    sortyByEniNewPatient :  function(component, event, helper){
        helper.sortBy(component,"newPatients","contractSummary");
    },

    sortyByCNSStatus : function(component,event,helper){
        helper.sortByCNS(component,"status","contractSummary");
    },

    sortyByCNSContractID : function(component,event,helper){
        helper.sortByCNS(component,"contractId","contractSummary");
    },
     sortyByCNSNetworkId : function(component,event,helper){
        helper.sortByCNS(component,"networkId","contractSummary");
    },
    sortyByCNSNetworkPrefix : function(component,event,helper){
        helper.sortByCNS(component,"networkPrefix","contractSummary");
    },
    sortyByCNSEffective : function(component,event,helper){
        helper.sortByCNS(component,"effectiveAndCancel","contractSummary");
    },
    sortyByCNSType : function(component,event,helper){
        helper.sortByCNS(component,"contractType","contractSummary");
    },
    sortyByCNSNewPatients : function(component,event,helper){
        helper.sortByCNS(component,"newPatients","contractSummary");
    },
    sortyByCNSMedicare : function(component,event,helper){
        helper.sortByCNS(component,"medicare","contractSummary");
    },

    sortBYMNRStatus : function(component,event,helper){
         helper.sortByMNR(component,"status","contractSummary");
    },

    sortBYMNRContractId : function(component,event,helper){
         helper.sortByMNR(component,"contractId","contractSummary");
    },
    sortBYMNROrg : function(component,event,helper){
         helper.sortByMNR(component,"org","contractSummary");
    },
    sortBYMNRDiv : function(component,event,helper){
         helper.sortByMNR(component,"div","contractSummary");
    },
    sortBYMNRPanel : function(component,event,helper){
         helper.sortByMNR(component,"panel","contractSummary");
    },
    sortBYMNRPanelDesc : function(component,event,helper){
         helper.sortByMNR(component,"panelDescription","contractSummary");
    },
    sortBYMNREffective : function(component,event,helper){
         helper.sortByMNR(component,"effectiveAndCancel","contractSummary");
    },
    sortBYMNRContractType : function(component,event,helper){
         helper.sortByMNR(component,"contractType","contractSummary");
    },
    sortBYMNRSpecialityType : function(component,event,helper){
         helper.sortByMNR(component,"specialtyType","contractSummary");
    },
    sortBYMNRNewPatients : function(component,event,helper){
         helper.sortByMNR(component,"newPatients","contractSummary");
    },


    providerDetailsChanged : function(cmp, event, helper) {
        // refresh contract data
        cmp.set("v.cAndSContractData", {'display' : '', 'processed' : '', 'filtered' : '', 'unfiltered' : ''}); cmp.set("v.cnsTableIsEmpty", true);
        cmp.set("v.eAndIContractData", {'display' : '', 'processed' : '', 'filtered' : '', 'unfiltered' : ''}); cmp.set("v.eniTableIsEmpty", true);
        cmp.set("v.mAndRContractData", {'display' : '', 'processed' : '', 'filtered' : '', 'unfiltered' : ''}); cmp.set("v.mnrTableIsEmpty", true);

        switch(cmp.get("v.selectedTab")) {
            case 'CNS':
                helper.getCNSContractData(cmp);
                break;

            case 'ENI':
                helper.getENIContractData(cmp);
                break;

            case 'MNR':
                helper.getMNRContractData(cmp);
                break;

            case 'PHS':
                break;
        }
    },

    // Purpose - get contract data when tab changed
    refreshTableData : function(cmp, event, helper) {
        cmp.set("v.selectedTab", event.currentTarget.getAttribute("data-tab"));
        // empty search box
        cmp.find("searchBox").set("v.value", "");
        // refresh focused tab
        switch(cmp.get("v.selectedTab")) {
            case 'CNS':
                // refresh C and S data
                let CNSData = cmp.get("v.cAndSContractData");
                if(!$A.util.isEmpty(CNSData.unfiltered)) {
                    CNSData.filtered = helper.filter(cmp, CNSData.unfiltered);
                    cmp.set("v.cAndSContractData", CNSData);
                } else {
                    helper.getCNSContractData(cmp);
                }
                break;
            case 'ENI':
                // refresh E and I data
                let ENIData = cmp.get("v.eAndIContractData");
                if($A.util.isEmpty(ENIData.unfiltered)) {
                    helper.getENIContractData(cmp);
                }
                break;
            case 'MNR':
                // refresh M and R data
                let MNRData = cmp.get("v.mAndRContractData");
                if($A.util.isEmpty(MNRData.unfiltered)) {
                    helper.getMNRContractData(cmp);
                }
                break;
            case 'PHS':
                // refresh PHS data
                break;
        }
    },

    onSearch : function(cmp, event, helper) {
        switch(cmp.get("v.selectedTab")) {
            case 'CNS':
                // filter C and S data
                let CNSData = cmp.get("v.cAndSContractData");
                if(!$A.util.isEmpty(CNSData.unfiltered)) {
                    CNSData.filtered = helper.filter(cmp, CNSData.unfiltered);
                    CNSData.display = CNSData.filtered.slice(0, 11);
                    cmp.set("v.cAndSContractData", CNSData);
                }
                break;
            case 'ENI':
                // filter E and I data
                let ENIData = cmp.get("v.eAndIContractData");
                let eniUnfilteredList;
                if(cmp.get("v.isENIAll")){
                    eniUnfilteredList = ENIData.unfiltered;
                } else {
                    eniUnfilteredList = ENIData.filtered;
                }

                if(!$A.util.isEmpty(eniUnfilteredList)) {
                    ENIData.processed = helper.filter(cmp, eniUnfilteredList);
                    ENIData.display = ENIData.processed.slice(0, 11);
                    cmp.set("v.eAndIContractData", ENIData);
                }
                break;
            case 'MNR':
                // filter M and R data
                let MNRData = cmp.get("v.mAndRContractData");
                let mnrUnfilteredList;
                if(cmp.get("v.isMNRAll")){
                    mnrUnfilteredList = MNRData.unfiltered;
                } else {
                    mnrUnfilteredList = MNRData.filtered;
                }

                if(!$A.util.isEmpty(mnrUnfilteredList)) {
                    MNRData.processed = helper.filter(cmp, mnrUnfilteredList);
                    MNRData.display = MNRData.processed.slice(0, 11);
                    cmp.set("v.mAndRContractData", MNRData);
                }
                break;
            case 'PHS':
                // filter PHS data
                break;
        }
    },

    // Purpose - To show or hide hover popup depending on its current state.
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    // Purpose - Add and show C and S contract details to contract details list.
    showCAndSContractDetails : function(cmp, event, helper) {
        // open c and s contract details
        let index = event.target.dataset.index;
        let cAndSContract = cmp.get("v.cAndSContractData");
        let contractDetailsList = cmp.get("v.contractDetailsList");

        let contrDetIndex = contractDetailsList.findIndex(function (value){
            return value.id == cAndSContract.filtered[index].cnsId;
        });
        if(contrDetIndex < 0) {
            let contractDetails = {
                "hide" : false,
                "type" : "CNS",
                "contractId" : cAndSContract.filtered[index].contractSummary.contractId,
                "id" : cAndSContract.filtered[index].cnsId,
                "effectiveDate" : cAndSContract.filtered[index].contractSummary.effectiveAndCancel,
                "data" : cAndSContract.filtered[index].contractDetails
            };
            contractDetailsList.unshift(contractDetails);
        } else {
            contractDetailsList[contrDetIndex].hide = false;
        }
        cmp.set("v.contractDetailsList", contractDetailsList);

        // disable link
        cAndSContract.filtered[index].isLinkDisabled = true;
        let unfilteredIndex = cAndSContract.unfiltered.findIndex(function(element) {
            return element.cnsId == cAndSContract.filtered[index].cnsId;
        });
        cAndSContract.unfiltered[unfilteredIndex].isLinkDisabled = true;
        cmp.set("v.cAndSContractData", cAndSContract);
    },

    // Purpose - Add and show E and I contract details to contract details list.
    showEAndIContractDetails : function(cmp, event, helper) {
        // open e and i contract details
        let index = event.target.dataset.index;
        let eAndIContract = cmp.get("v.eAndIContractData");
        let contractDetailsList = cmp.get("v.contractDetailsList");

        let contrDetIndex = contractDetailsList.findIndex(function (value){
            return value.id == eAndIContract.display[index].eniId;
        });
        if(contrDetIndex < 0) {
            let contractDetails = {
                "hide" : false,
                "type" : "ENI",
                "contractId" : eAndIContract.display[index].contractSummary.contractId,
                "effectiveDate" : eAndIContract.display[index].contractSummary.effectiveAndCancel,
                "id" : eAndIContract.display[index].eniId,
                "data" : eAndIContract.display[index].contractDetails
            };
            contractDetailsList.unshift(contractDetails);
        } else {
            contractDetailsList[contrDetIndex].hide = false;
        }
        cmp.set("v.contractDetailsList", contractDetailsList);

        // disable link
        eAndIContract.display[index].isLinkDisabled = true;

        let processedIndex = eAndIContract.processed.findIndex(function(element) {
            return element.eniId == eAndIContract.display[index].eniId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(processedIndex >= 0){ eAndIContract.processed[processedIndex].isLinkDisabled = true; }

        let filteredIndex = eAndIContract.filtered.findIndex(function(element) {
            return element.eniId == eAndIContract.display[index].eniId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(filteredIndex >= 0){ eAndIContract.filtered[filteredIndex].isLinkDisabled = true; }

        let unfilteredIndex = eAndIContract.unfiltered.findIndex(function(element) {
            return element.eniId == eAndIContract.display[index].eniId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(unfilteredIndex >= 0){ eAndIContract.unfiltered[unfilteredIndex].isLinkDisabled = true; }

        cmp.set("v.eAndIContractData", eAndIContract);
    },

    // Purpose - Add and show M and R contract details to contract details list.
    showMAndRContractDetails : function(cmp, event, helper) {
        // open m and r contract details
        let index = event.target.dataset.index;
        let mAndRContractData = cmp.get("v.mAndRContractData");
        let contractDetailsList = cmp.get("v.contractDetailsList");

        let contrDetIndex = contractDetailsList.findIndex(function (value){
            return value.id == mAndRContractData.display[index].mnrId;
        });
        if(contrDetIndex < 0) {
            let contractDetails = {
                "hide" : false,
                "type" : "MNR",
                "contractId" : mAndRContractData.display[index].contractSummary.contractId,
                "effectiveDate" : mAndRContractData.display[index].contractSummary.effectiveAndCancel,
                "id" : mAndRContractData.display[index].mnrId,
                "data" : mAndRContractData.display[index].contractDetails
            };
            contractDetailsList.unshift(contractDetails);
        } else {
            contractDetailsList[contrDetIndex].hide = false;
        }
        cmp.set("v.contractDetailsList", contractDetailsList);

        // disable link
        mAndRContractData.display[index].isLinkDisabled = true;

        let processedIndex = mAndRContractData.processed.findIndex(function(element) {
            return element.mnrId == mAndRContractData.display[index].mnrId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(processedIndex >= 0){ mAndRContractData.processed[processedIndex].isLinkDisabled = true; }

        let filteredIndex = mAndRContractData.filtered.findIndex(function(element) {
            return element.mnrId == mAndRContractData.display[index].mnrId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(filteredIndex >= 0){ mAndRContractData.filtered[filteredIndex].isLinkDisabled = true; }

        let unfilteredIndex = mAndRContractData.unfiltered.findIndex(function(element) {
            return element.mnrId == mAndRContractData.display[index].mnrId;
        });
        // Thanish - 24th Jun 2020 - defect fix
        if(unfilteredIndex >= 0){ mAndRContractData.unfiltered[unfilteredIndex].isLinkDisabled = true; }

        cmp.set("v.mAndRContractData", mAndRContractData);
    },

    // Purpose - Add and show PHS contract details to contract details list.
    showPHSContractDetails : function(cmp, event, helper) {
        // disable the clicked link
        let clickedSource = event.currentTarget;
        $A.util.addClass(clickedSource, 'disableLink');
        // open phs contract details
        let contractDetailsList = cmp.get("v.contractDetailsList");
        let contractDetails = {
            "hide" : false,
            "type" : "PHS",
            "contractId" : '',
            "id" : (contractDetailsList.length + 1) + cmp.get("v.uniqueId")
        };
        contractDetailsList.unshift(contractDetails);
        cmp.set("v.contractDetailsList", contractDetailsList);
    },

    // US2263567 - Thanish - 29th Jan 2020
    // Removes Contract Details object whose contractId is passed from 'contractDetailsList'
    removeContractDetail : function(cmp, event, helper) {
        let params = event.getParam('arguments');
        if(!$A.util.isEmpty(params)) {
            // remove the contract detail
            let contractDetailsList = cmp.get("v.contractDetailsList");
            let index = contractDetailsList.findIndex(function (value){
                return value.id == params.id;
            });
            contractDetailsList[index].hide = true;
            cmp.set("v.contractDetailsList", contractDetailsList);

            // enabling the link after removing the contract detail
            if(params.type == 'cns') {
                let cAndSContract = cmp.get("v.cAndSContractData");
                let filteredIndex = cAndSContract.filtered.findIndex(function(element) {
                    return element.cnsId == params.id;
                });
                cAndSContract.filtered[filteredIndex].isLinkDisabled = false;
                let unfilteredIndex = cAndSContract.unfiltered.findIndex(function(element) {
                    return element.cnsId == params.id;
                });
                cAndSContract.unfiltered[unfilteredIndex].isLinkDisabled = false;
                cmp.set("v.cAndSContractData", cAndSContract);

            } else if(params.type == 'eni') {
                let eAndIContract = cmp.get("v.eAndIContractData");

                let displayIndex = eAndIContract.display.findIndex(function(element) {
                    return element.eniId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(displayIndex >= 0){ eAndIContract.display[displayIndex].isLinkDisabled = false; }

                let processedIndex = eAndIContract.processed.findIndex(function(element) {
                    return element.eniId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(processedIndex >= 0){ eAndIContract.processed[processedIndex].isLinkDisabled = false; }

                let filteredIndex = eAndIContract.filtered.findIndex(function(element) {
                    return element.eniId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(filteredIndex >= 0){ eAndIContract.filtered[filteredIndex].isLinkDisabled = false; }

                let unfilteredIndex = eAndIContract.unfiltered.findIndex(function(element) {
                    return element.eniId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(unfilteredIndex >= 0){ eAndIContract.unfiltered[unfilteredIndex].isLinkDisabled = false; }

                cmp.set("v.eAndIContractData", eAndIContract);

            } else if(params.type == 'mnr') {
                let mAndRContract = cmp.get("v.mAndRContractData");

                let displayIndex = mAndRContract.display.findIndex(function(element) {
                    return element.mnrId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(displayIndex >= 0){ mAndRContract.display[displayIndex].isLinkDisabled = false; }

                let processedIndex = mAndRContract.processed.findIndex(function(element) {
                    return element.mnrId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(processedIndex >= 0){ mAndRContract.processed[processedIndex].isLinkDisabled = false; }

                let filteredIndex = mAndRContract.filtered.findIndex(function(element) {
                    return element.mnrId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(filteredIndex >= 0){ mAndRContract.filtered[filteredIndex].isLinkDisabled = false; }

                let unfilteredIndex = mAndRContract.unfiltered.findIndex(function(element) {
                    return element.mnrId == params.id;
                });
                // Thanish - 24th Jun 2020 -  defect fix
                if(unfilteredIndex >= 0){ mAndRContract.unfiltered[unfilteredIndex].isLinkDisabled = false; }

                cmp.set("v.mAndRContractData", mAndRContract);

            }
        }
    },

    cnsScrolled : function(cmp, event, helper) {
        if(event.currentTarget.scrollTop == 112){
            let cAndSContractData = cmp.get("v.cAndSContractData");
            let displayList = cAndSContractData.display;
            let filteredList = cAndSContractData.filtered;

            let endIndex = filteredList.findIndex(function (value) {
                return value.cnsId == displayList[displayList.length - 1].cnsId;
            });
            if(endIndex < filteredList.length - 3){
                displayList.shift(); displayList.shift(); displayList.shift();
                displayList.push(filteredList[endIndex + 1]); displayList.push(filteredList[endIndex + 2]); displayList.push(filteredList[endIndex + 3]);

                cAndSContractData.display = displayList;
                cmp.set("v.cAndSContractData", cAndSContractData);
            }
        }
        else if(event.currentTarget.scrollTop == 0){
            let cAndSContractData = cmp.get("v.cAndSContractData");
            let displayList = cAndSContractData.display;
            let filteredList = cAndSContractData.filtered;

            let startIndex = filteredList.findIndex(function (value) {
                return value.cnsId == displayList[0].cnsId;
            });
            if(startIndex > 1){
                displayList.pop(); displayList.pop();
                displayList.unshift(filteredList[startIndex - 1]); displayList.unshift(filteredList[startIndex - 2]);

                cAndSContractData.display = displayList;
                cmp.set("v.cAndSContractData", cAndSContractData);
                event.currentTarget.scrollTop = 28;
            }
        }

    },

    eniScrolled : function(cmp, event, helper) {
        if(event.currentTarget.scrollTop == 112){
            let eAndIContractData = cmp.get("v.eAndIContractData");
            let displayList = eAndIContractData.display;
            let filteredList = eAndIContractData.processed;

            let endIndex = filteredList.findIndex(function (value) {
                return value.eniId == displayList[displayList.length - 1].eniId;
            });
            if(endIndex < filteredList.length - 3){
                displayList.shift(); displayList.shift(); displayList.shift();
                displayList.push(filteredList[endIndex + 1]); displayList.push(filteredList[endIndex + 2]); displayList.push(filteredList[endIndex + 3]);

                eAndIContractData.display = displayList;
                cmp.set("v.eAndIContractData", eAndIContractData);
            }
        }
        else if(event.currentTarget.scrollTop == 0){
            let eAndIContractData = cmp.get("v.eAndIContractData");
            let displayList = eAndIContractData.display;
            let filteredList = eAndIContractData.processed;

            let startIndex = filteredList.findIndex(function (value) {
                return value.eniId == displayList[0].eniId;
            });
            if(startIndex > 1){
                displayList.pop(); displayList.pop();
                displayList.unshift(filteredList[startIndex - 1]); displayList.unshift(filteredList[startIndex - 2]);

                eAndIContractData.display = displayList;
                cmp.set("v.eAndIContractData", eAndIContractData);
                event.currentTarget.scrollTop = 28;
            }
        }
    },

    mnrScrolled : function(cmp, event, helper) {
        if(event.currentTarget.scrollTop == 112){
            let mAndRContractData = cmp.get("v.mAndRContractData");
            let displayList = mAndRContractData.display;
            let filteredList = mAndRContractData.processed;

            let endIndex = filteredList.findIndex(function (value) {
                return value.mnrId == displayList[displayList.length - 1].mnrId;
            });
            if(endIndex < filteredList.length - 3){
                displayList.shift(); displayList.shift(); displayList.shift();
                displayList.push(filteredList[endIndex + 1]); displayList.push(filteredList[endIndex + 2]); displayList.push(filteredList[endIndex + 3]);

                mAndRContractData.display = displayList;
                cmp.set("v.mAndRContractData", mAndRContractData);
            }
        }
        else if(event.currentTarget.scrollTop == 0){
            let mAndRContractData = cmp.get("v.mAndRContractData");
            let displayList = mAndRContractData.display;
            let filteredList = mAndRContractData.processed;

            let startIndex = filteredList.findIndex(function (value) {
                return value.mnrId == displayList[0].mnrId;
            });
            if(startIndex > 1){
                displayList.pop(); displayList.pop();
                displayList.unshift(filteredList[startIndex - 1]); displayList.unshift(filteredList[startIndex - 2]);

                mAndRContractData.display = displayList;
                cmp.set("v.mAndRContractData", mAndRContractData);
                event.currentTarget.scrollTop = 28;
            }
        }
    },
})