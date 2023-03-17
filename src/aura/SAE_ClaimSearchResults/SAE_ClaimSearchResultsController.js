({
    onInit: function(component, event, helper) {
       /* var claimsList = [{
            'ClaimNumber': 123456789,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'In Progress',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 343325467,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Jones',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Denied',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 234890876,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Paid',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 980765433,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Paid',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 456545678,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Paid',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 980765433,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Paid',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 456545678,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Paid',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 123456789,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Smith',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'In Progress',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 343325467,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Jones',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Denied',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 343325467,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Jones',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Denied',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 343325467,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Jones',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Denied',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }, {
            'ClaimNumber': 343325467,
            'TaxId': 76876543,
            'ProviderId': 67890987,
            'ProviderName': 'Dr. Jones',
            'DOSStart': '11/12/2018',
            'DOSEnd': '11/12/2018',
            'Charged': '$100.00',
            'Status': 'Denied',
            'RecievedDate': '11/12/2018',
            'IntialDueDate': '11/12/2018',
            'ProcessDate': '11/12/2018'
        }];
        component.set('v.claimsList', claimsList);
        helper.updateRecords(component, event, true);
        console.log('&&&&&&&&&&');
        console.log(component.get("v.claimsList")); */

        var claimsList = component.get("v.claimsList");
        console.log('init claimsList===>'+claimsList);
        component.set('v.claimsFullList', claimsList);
    },

    //<!-- Sravani START-->
    handleSAEClaimSearchResultEvent : function(component, event, helper) {
        var claimsList = event.getParam("claimSearchResult");
        console.log('&&&&&&&&&& claimsList'+JSON.stringify(claimsList) );
        component.set('v.claimsList', claimsList);
        component.set('v.claimsFullList', claimsList);

    },
//<!-- Sravani END-->
    sortBy: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var sortFieldName = selectedItem.dataset.sorfld;
        component.set("v.sortBy", sortFieldName);
        helper.sortHelper(component, event, sortFieldName);
    },

    handleSort : function(component,event,helper){
        debugger;
        //Returns the field which has to be sorted
        var fieldName = event.currentTarget.getAttribute("data-fieldName");
        //returns the direction of sorting like asc or desc
        //var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        //component.set("v.sortBy",sortBy);
        var sortDirection = component.get("v.arrowDirection");
        component.set("v.selectedTabsoft",fieldName);
        //component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,fieldName,sortDirection);
    },
    calculateWidth: function(component, event, helper) {

        var childObj = event.target
        var mouseStart=event.clientX;
        component.set("v.currentEle", childObj);
        component.set("v.mouseStart",mouseStart);
        // Stop text selection event so mouse move event works perfectlly.
        if(event.stopPropagation) event.stopPropagation();
        if(event.preventDefault) event.preventDefault();
        event.cancelBubble=true;
        event.returnValue=false;
    },

    setNewWidth: function(component, event, helper) {
        var currentEle = component.get("v.currentEle");
        if( currentEle != null && currentEle.tagName ) {
            var parObj = currentEle;
            while(parObj.parentNode.tagName != 'TH') {
                if( parObj.className == 'slds-resizable__handle')
                    currentEle = parObj;
                parObj = parObj.parentNode;
                count++;
            }
            var count = 1;
            var mouseStart = component.get("v.mouseStart");
            var oldWidth = parObj.offsetWidth;  // Get the width of DIV
            var newWidth = oldWidth + (event.clientX - parseFloat(mouseStart));
            component.set("v.newWidth", newWidth);
            currentEle.style.right = ( oldWidth - newWidth ) +'px';
            component.set("v.currentEle", currentEle);
        }
    },
	// We are setting the width which is just changed by the mouse move event
    resetColumn: function(component, event, helper) {
        // Get the component which was used for the mouse move
        if( component.get("v.currentEle") !== null ) {
            var newWidth = component.get("v.newWidth");
            var currentEle = component.get("v.currentEle").parentNode.parentNode; // Get the DIV
            var parObj = currentEle.parentNode; // Get the TH Element
            parObj.style.width = newWidth+'px';
            currentEle.style.width = newWidth+'px';
            console.log(newWidth);
            component.get("v.currentEle").style.right = 0; // Reset the column devided
            component.set("v.currentEle", null); // Reset null so mouse move doesn't react again
        }
	},
    //US1918617 :Venkat added 241 to 362
    handleClaimSearchViewResultEvent : function(cmp, event,helper) {

        var searchResult=cmp.get('v.claimsList');
        //US1974673 Bharat added start
        if(cmp.get('v.firstRun') == 'true'){
          cmp.set('v.claimsFullList', searchResult);
            cmp.set('v.firstRun', 'false');
        }
        //console.log('searchResult ==>'+JSON.stringify(searchResult));
        //US1974673 End
        if(searchResult != undefined && searchResult != null){
         console.log('searchresults'+searchResult);
         cmp.set("v.currentPageNumber",1);
		 cmp.set("v.totalPages", Math.ceil(searchResult.length/cmp.get("v.pageSize")));


        var pageNumber = cmp.get("v.currentPageNumber");
        var pageSize = cmp.get("v.pageSize");
        var claimsLst = cmp.get("v.claimsList");
        console.log('all total pages'+ cmp.get("v.totalPages"));
        var data = [];

        console.log('page Number'+ pageNumber);
        console.log('all claimlist data in build'+ claimsLst.length);

        var x = (pageNumber-1)*pageSize;

        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(claimsLst[x]){
            	data.push(claimsLst[x]);
            }
        }

  var tempObj = {
            "claimNumber":'',
            "taxId": '',
            "providerId": '',
            "providerName": '',
            "DOSStart": '',
            "DOSEnd":'',
            "charged": '',
            "receivedDate":'',
            "status": '',
            "processDate":''
        };
        var newClaimLstTemp = [];
        for(var i = 0; i < data.length;i++){
            tempObj = new Object();
            tempObj.claimNumber = data[i].claimNumber;
            tempObj.taxID = data[i].taxID;
            tempObj.ProviderId = data[i].providerID;
            tempObj.providerName = data[i].providerName;
            tempObj.DOSStart = data[i].DOSStart;
            tempObj.DOSEnd=data[i].DOSEnd;
            tempObj.charged = data[i].charged;
            tempObj.status = data[i].status;
            tempObj.receivedDate = data[i].receivedDate;
            tempObj.processDate = data[i].processDate;
            console.log('temporary records '+tempObj);

            newClaimLstTemp.push(tempObj);
        }
        cmp.set("v.data", newClaimLstTemp);

                               cmp.set("v.claimSearchFlag",false);

     helper.generatePageList(cmp, pageNumber);
        }

        else {
             cmp.set("v.claimSearchFlag",true);
            cmp.set("v.currentPageNumber",1);
		 cmp.set("v.totalPages",1);


        }
    },



    onNext : function(component, event, helper) {
        debugger;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },

    onPrev : function(component, event, helper) {
        debugger;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        component.set("v.currentStartNumber", (component.get("v.currentStartNumber") - component.get("v.pageSize")));
        component.set("v.currentEndNumber", (component.get("v.currentStartNumber") + component.get("v.pageSize")) - 1);
        helper.buildData(component, helper);
    },

    processMe : function(component, event, helper) {
        debugger;
        component.set("v.currentPageNumber", parseInt(event.target.name));
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var x = (pageNumber-1)*pageSize;
        component.set("v.currentStartNumber", parseInt(x) + 1);
        component.set("v.currentEndNumber", parseInt(x) + parseInt(pageSize));
        console.log(component.get("v.currentStartNumber"));
        helper.buildData(component, helper);
        //var selectedTabsoft = component.get("v.selectedTabsoft");
        var arrowDirection = component.get("v.arrowDirection");
        helper.sortData(component,selectedTabsoft,arrowDirection);
    },

    onFirst : function(component, event, helper) {
        component.set("v.currentPageNumber", 1);
        component.set("v.currentStartNumber", component.get("v.currentPageNumber"));
        component.set("v.currentEndNumber", component.get("v.pageSize"));
        helper.buildData(component, helper);
    },

    onLast : function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var newClaimLst = component.get("v.claimsList");
        var x = (pageNumber-1)*pageSize;
        component.set("v.currentStartNumber", x + 1);
        component.set("v.currentEndNumber", newClaimLst.length);
        helper.buildData(component, helper);
    },

    searchValueFunc: function(cmp,event,helper){
        helper.ClaimsearchResults(cmp, event, helper);
    },


    //venkat added ended

    selectItem: function(component, event, helper) {
        //alert('selected');
        //helper.selectRow(component,event);
        //var claimrow = event.currentTarget.getAttribute("data-row-index");

        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.index;

        // CTRL Click
        var row = document.getElementById("tr" + index);
        var isCtrlClick = false;
        //US2908113 - Tilak changes
		var claimrow = selectedItem.getAttribute("data-row-index");
        $('#tr'+claimrow).find('input:checkbox').each(function() {
            if(!this.checked){
            this.checked = (!this.checked);
            console.log("value of checkbox is :"+this.checked);
            }
        });
        console.log("tilak--claimrow # is:"+claimrow);
        //US2908113 - Tilak changes end
        if (event.ctrlKey) {
            isCtrlClick = true;
            if(row.classList.contains('highlight')){
                row.classList.remove("highlight");
            } else {
                row.classList.add("highlight");
            }
        } else {
            var els = document.querySelectorAll('.highlight');
            for (var i = 0; i < els.length; i++) {
                els[i].classList.remove('highlight')
            }
            component.set('v.selectedItem', index);
        }

        //US1956058 : Malinda
		let selectedClaimNo = selectedItem.getAttribute("data-clm");
        let selectedProcessDate = selectedItem.getAttribute("data-date");

        let selectedRows = component.get("v.selectedRows");
        selectedRows.push(selectedClaimNo);
        component.set("v.selectedRows",selectedRows);


        let compEvent = $A.get("e.c:SAE_ClaimDetailsEvent");

        compEvent.setParams({"selectedClaimNo" : selectedClaimNo
                             ,"selectedProcessDate" : selectedProcessDate
                             ,"selectedClaimNumbers" : component.get("v.selectedRows")});
        compEvent.fire();

        //US2876410 ketki 9/11:  Launch Claim Detail Page
        let workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {

            let mapOpenedTabs = component.get('v.TabMap');
            let claimNoTabUniqueId = component.get('v.memberTabId') + selectedClaimNo;
            if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
                mapOpenedTabs = new Map();
            }

            //Duplicate Found
            if (mapOpenedTabs.has(claimNoTabUniqueId)) {
                //let tabResponse = mapOpenedTabs.get(claimNoTabUniqueId);
                let tabResponse;
                if (!$A.util.isUndefinedOrNull(response)) {
                    for (let i = 0; i < response.length; i++) {
                        if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                            for (let j = 0; j < response[i].subtabs.length; j++) {

                               if(claimNoTabUniqueId === response[i].subtabs[j].pageReference.state.c__claimNoTabUnique)
                               {

                                tabResponse = response[i].subtabs[j];
                                break;
                               }
                           }
                        }
                    }
                 }

                workspaceAPI.openTab({
                    url: tabResponse.url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                });
            } else {
                console.log("Opening sub tab for claimNoTabUniqueId "+ claimNoTabUniqueId);
                workspaceAPI.openSubtab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACET_ClaimDetails"
                        },
                        "state": {
                            "c__claimNo": selectedClaimNo,
                            "c__claimNoTabUnique": claimNoTabUniqueId,
                            "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                            "c__contactUniqueId": component.get("v.contactUniqueId"),
                            "c__interactionRec": JSON.stringify(component.get('v.interactionRec')),
                             "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId")
                        }
                    },
                    focus: true
                }).then(function (response) {
                    console.log("After opening sub tab for claimNoTabUniqueId "+ claimNoTabUniqueId);
                    console.log(JSON.stringify(response));
                    mapOpenedTabs.set(claimNoTabUniqueId, response);
                    console.log("mapOpenedTabs value "+ JSON.stringify(mapOpenedTabs));
                    component.set('v.TabMap', mapOpenedTabs);
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: selectedClaimNo
                    });
                    workspaceAPI.setTabIcon({
                         tabId: response,
                        icon: "custom:custom17",
                        iconAlt: "Claim Detail"
                    });
                }).catch(function (error) {
                });
            }
        }).catch(function (error) {
        });
       //US2876410 ketki 9/11:  Launch Claim Detail Page
    },
    commentsShow:function(component, event, helper) {
        component.set("v.showComments",true);
        let button = event.getSource();
        button.set('v.disabled',true);
    },

    openModal: function(component, event, helper){
        component.set("v.isModalOpen",true);
        let caseWrapper=component.get("v.caseWrapperMNF");
        if( !$A.util.isUndefinedOrNull(caseWrapper)){
         	caseWrapper.Comments=component.get("v.commentsValue");
            component.set("v.caseWrapperMNF",caseWrapper);
        }
    },
     closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);

    },
    onTabClosed: function (cmp, event) {

        let tabFromEvent = event.getParam("tabId");

        if( !$A.util.isUndefinedOrNull(tabFromEvent)){
            let mapOpenedTabs = cmp.get('v.TabMap');
            let mapEntryToRemove =null ;
            if(!$A.util.isUndefinedOrNull(mapOpenedTabs)){
            	for (let elem of mapOpenedTabs.entries()) {

                	if(tabFromEvent === elem[1] ){
                    	mapEntryToRemove = elem[0];
                    	break;
                		}
            	}
            	if( !$A.util.isUndefinedOrNull(mapEntryToRemove)){
                	mapOpenedTabs.delete(mapEntryToRemove);
                	cmp.set('v.TabMap', mapOpenedTabs);
            	}
           	 }
         }

    },
    wrapperChange: function(component, event, helper){
         //let val = component.get('v.caseWrapper');
        //console.log('###MNF-PARAMS:',JSON.stringify(val));
    },

    /*selectRow: function (component, event, helper) {
       var row = event.currentTarget.getAttribute("data-row-index");
        console.log('row#', row);
        $('#tr'+row).find('input:checkbox').each(function() {
       	this.checked = (!this.checked);
        });
    },*/

    WhichButton: function (component, event, helper) {
        if(event.button == 0){
            component.set("v.showAutodocWarning",true);
        }

    },
    handleAutodocWarningYes: function (component, event, helper) {
        window.localStorage.clear();
        component.set("v.showAutodocWarning", false);
    },

    handleAutodocWarningNo: function (component, event, helper) {
        component.set("v.showAutodocWarning", false);
    },
    //US1974673: Bharat Start
    //// Bharath Added:10/5/2020 start
    deductibleSelect: function (component, event, helper) {

        if(component.find('DeductibleId').get('v.checked') == true){
            var claimLsttemp = [];
            var claimsList = component.get("v.claimsFullList");
            for (var i = 0; i < claimsList.length; i++) {
                console.log('totalDeductibleAmt ==>'+claimsList[i].totalDeductibleAmt);
                if(claimsList[i].totalDeductibleAmt != null && claimsList[i].totalDeductibleAmt != null &&
                  claimsList[i].totalDeductibleAmt != '$0.00'){
                  claimLsttemp.push(claimsList[i]);
                }

            }
            component.set('v.claimsList', claimLsttemp);
        }else {
            if(component.find('AppliedId').get('v.checked') == false){
                var varClaimsFullList = component.get("v.claimsFullList");
                component.set("v.claimsList",varClaimsFullList);
            }
        }
         helper.resetPages(component,helper);
         helper.buildData(component, helper);
    },

    appliedSelect: function (component, event, helper) {
       if(component.find('AppliedId').get('v.checked') == true){
            var claimLsttemp = [];
            var claimsList = component.get("v.claimsFullList");
            for (var i = 0; i < claimsList.length; i++) {
                console.log('totalDeductibleAmt ==>'+claimsList[i].totalDeductibleAmt);
                console.log('totalCoinsuranceAmt ==>'+claimsList[i].totalCoinsuranceAmt);
                if((claimsList[i].totalDeductibleAmt != null && claimsList[i].totalDeductibleAmt != null &&
                  claimsList[i].totalDeductibleAmt != '$0.00') || (claimsList[i].totalCoinsuranceAmt != null && claimsList[i].totalCoinsuranceAmt != null &&
                  claimsList[i].totalCoinsuranceAmt != '$0.00')){
                  claimLsttemp.push(claimsList[i]);
                }

            }
            component.set('v.claimsList', claimLsttemp);
        }else {
           if(component.find('DeductibleId').get('v.checked') == false){
                var varClaimsFullList = component.get("v.claimsFullList");
                component.set("v.claimsList",varClaimsFullList);
            }
        }
         helper.resetPages(component,helper);
         helper.buildData(component, helper);
    },
    //Bharath Added:10/5/2020 End
    handleChange:function (cmp, event, helper){
        //console.log("inside handle change");
        //console.log("in handle change "+ JSON.stringify(event));
        /*
        var selectedItem = event.currentTarget;
        var claimrow = selectedItem.getAttribute("data-row-index");
        console.log("ketki/claimrow is:"+claimrow);
        $('#tr'+claimrow).find('input:checkbox').each(function() {
            console.log("value of checkbox is :"+this.checked);
        })
		*/
        /*if(component.find('CheckedClaimId').get('v.checked') == true){
            console.log("claim checked event is fired!");
            var selectedClaimLst = component.get("v.selectedClaimLst");
            var selectedClaimAttributes = {};
        	selectedClaimAttributes.ClaimNumber = event.currentTarget.getAttribute("data-clm");
        	selectedClaimAttributes.Charged = event.currentTarget.getAttribute("data-Charged");
            console.log("claim number is :"+ event.currentTarget.getAttribute("data-clm"));
            console.log("charged amount is :"+ event.currentTarget.getAttribute("data-Charged"));

            selectedClaimLst.push(selectedClaimAttributes);
            component.set("v.selectedClaimLst",selectedClaimLst);
            console.log("selected claim list is:"+selectedClaimLst);
        }


       /*
        if(component.find('CheckedClaimId').get('v.checked') == true){
            console.log("claim is checked");
        }
        else{
            console.log("claim is unchecked");
        }*/

    },
    //US1974673: Bharat End

      //ketki US2910290 TECH - View Claims - Case Creation in ACET Feed To ORS start
     getSelectedClaims: function (component, event, helper) {
        var appEvent = $A.get("e.c:ACET_SetClaimsList");
        var claimsSelectedForORS = [];
        var allClaims =  component.get("v.data");
        if( !$A.util.isUndefinedOrNull(allClaims)) {
            for (let i =0; i < allClaims.length; i ++ ){

                  $('#tr'+i).find('input:checkbox').each(function() {
            			console.log("value of checkbox "+ i + " " + (this.checked));
                        if( this.checked === true){
                            var selectedClaim = {};

                            selectedClaim.claimNumber = allClaims[i].claimNumber;
                            //Remove $ sign. Appears ORS doesn't appears to accept $ in claim.totalamount field
                            if( !$A.util.isUndefinedOrNull(allClaims[i].charged) && allClaims[i].charged.length > 0 ) {
                            	selectedClaim.charged = allClaims[i].charged.substring(1);
                            }
                            else{
                                selectedClaim.charged = "";
                            }
                            console.log("Adding Claimnumber "+allClaims[i].claimNumber + " charged "+ allClaims[i].charged + " to Claims List");
                            claimsSelectedForORS.push(selectedClaim);
                      }
           		 });
            }
        }

        appEvent.setParams({
            "selectedClaimsList" : claimsSelectedForORS
        });
        appEvent.fire();
    },
    //ketki US2910290 TECH - View Claims - Case Creation in ACET Feed To ORS end
})