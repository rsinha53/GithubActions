({
    // US3305963 - Thanish - 18th Mar 2021
    viewAuthErrorMessage: "Unexpected Error Occurred with View Authorization Results. Please try again. If problem persists please contact the help desk",
    authStatusErrorMessage: "Unexpected Error Occurred in the Authorization Status Card. Please try again. If problem persists please contact the help desk",

    showAuthResultSpinner: function (cmp) {
        var spinner = cmp.find("auth-result-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideAuthResultSpinner: function (cmp) {
        var spinner = cmp.find("auth-result-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    getICUEURL: function (component, event, helper) {
        var ICUEURL = component.get("v.ICUEURL");
        
         this.hideAuthResultSpinner(component);
        window.open(ICUEURL, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },

    // US2536127 - Avish
    handleSaveModal: function (component, event, helper) {

        var autoDocKey = component.get("v.AutodocPageFeature");
        var tabKey = component.get("v.AutodocKey");
        var cmpid = component.get('v.componentId');

        // US2618180
        // document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", tabKey + "Auth");
        // document.getElementById(tabKey + tabKey + 'memberdetailsclone').setAttribute("data-auto-doc-feature", tabKey + "Auth");
        // document.getElementById(tabKey + tabKey + 'memberdetailsclone2').setAttribute("data-auto-doc-feature", tabKey + "Auth");

        //US2396655 - Make Autodoc available for multiple pages
        // component.set("v.isAutodocForMultiplePages", true);
        // // DE301090
        // component.set('v.AutodocPageFeatureMemberDtl', component.get('v.AutodocPageFeature'));
        // // US2442658
        // component.set("v.AutodocKeyMemberDtl", component.get("v.AutodocKey"));

        // US2099074 - Sanka
        var caseWrapper = component.get('v.caseWrapper');
        var selectedPolicy = component.get('v.policy');
        var sourceCode = '';
        if(!$A.util.isEmpty(selectedPolicy) &&  !$A.util.isEmpty(selectedPolicy.resultWrapper) &&
        !$A.util.isEmpty(selectedPolicy.resultWrapper.policyRes) && !$A.util.isEmpty(selectedPolicy.resultWrapper.policyRes)){
            sourceCode = selectedPolicy.resultWrapper.policyRes.sourceCode;
            caseWrapper.policyNumber = selectedPolicy.resultWrapper.policyRes.policyNumber;
            caseWrapper.benefitPackage = selectedPolicy.resultWrapper.policyRes.benefitPackageLogNumber;
            caseWrapper.alternateId = selectedPolicy.resultWrapper.policyRes.alternateId;
        }

        if(!$A.util.isEmpty(sourceCode)) {
            if(sourceCode == 'AP') {
                // if C&S member, no ORS case will be created
                caseWrapper.createORSCase = false;
            } else {
                // if other than C&S member, ORS case will be created
                caseWrapper.createORSCase = true;
            }
        }

        caseWrapper.isFromAuth = true;
        // New AutoDoc
        // commented - Save Case Consolidation - US3424763
        // var defaultAutoDoc = this.getAutoDocObject(component);
        // var jsString = JSON.stringify(defaultAutoDoc);
        // caseWrapper.savedAutodoc = jsString;

        component.set("v.caseWrapper", caseWrapper);
        // End

        // Set isModalOpen attribute to true
        //component.set("v.isModalOpen", true);

        // US2618180
        helper.fireCallTopicAutodoc(component, event, helper);

    },

    // US2536127 - Avish
    //Adding 3rd param - New Public group for Create Auth Pilot - Sarma - 28/10/2020
    handleShowModal: function (component,name,isOpenIcue) {
       
        var ICUEURL = component.get("v.ICUEURL");
        var policyStatus = component.get("v.policyStatus");
        this.hideAuthResultSpinner(component);
        $A.createComponent("c:SAE_OverLayModal",
            {
                "ICUEURL": ICUEURL,
                "eventName": name,
                "contactName": component.get("v.contactName"),
                "memberTabId" : component.get("v.memberTabId"),
                "policyNumber" : component.get("v.policyNumber"),
                "MemberId":  component.get("v.memberId"),
                "FirstName": component.get("v.FirstName"),
                "LastName": component.get("v.LastName"),
                "isOpenIcue" : isOpenIcue,
                "policyStatus" : policyStatus
            },
            function (content, status) {
                if (status === "SUCCESS") {
                    var modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: false,
                        cssClass: "cSAE_OverLayModal modalWidth",
                        closeCallback: function (ovl) {
                            
                        }
                    }).then(function (overlay) {
                        
                    });
                }
            });
    },
    addStatusComponent: function (cmp, event, helper, authid, xref, authType, srn, lofstay, authCompId) {
        //US2718111: View Authorizations - Switching Policies and Auto Doc - Praveen
        var authIdsStatusOpened = cmp.get('v.authIds');
        //Swapna
        if(cmp.get("v.isClaimDetail")){
        let currentIndexOfAuthOpenedTabs=cmp.get('v.currentIndexOfAuthOpenedTabs');
        currentIndexOfAuthOpenedTabs++;
        cmp.set('v.currentIndexOfAuthOpenedTabs',currentIndexOfAuthOpenedTabs);
        }
        //Swapna
        authIdsStatusOpened.push(authid);
        cmp.set('v.authIds', authIdsStatusOpened);

         if(cmp.get("v.isClaimDetail")){
        		//US2308090
                var workspaceAPI = cmp.find("workspace");

                workspaceAPI.getAllTabInfo().then(function (response) {

                    let mapOpenedTabs = cmp.get('v.TabMap');
                    let claimNo = cmp.get('v.claimNo');
                    let authstatusId = "authstatus"+ srn+authid;
                    let claimNoTabUniqueId = cmp.get('v.memberTabId') + '_' + authstatusId + '_' + claimNo ;
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

                    //Check if MedicAid is not undefined
                    var medicaid = cmp.get("v.isMedicaidPlan");
                    if($A.util.isUndefinedOrNull(medicaid))
                            medicaid  = '';

                        workspaceAPI.openSubtab({

                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_AuthorizationDetail"
                                },
                                "state": {
                                    "c__authDetails": JSON.stringify(cmp.get('v.authStatusDetails')),
                                    "c__authType": authType,
                                    "c__LengthOfStay": lofstay,
                                    "c__SRN": srn,
                                    "c__srnTabUnique": claimNoTabUniqueId,
                                    "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')), //US2325822
                                    "c__isMedicaidPlan":  medicaid,
                                    "c__AutodocPageFeature": cmp.get('v.AutodocPageFeature'), //US2301790
                                    "c__AutodocKey": cmp.get("v.AutodocKey"), // Autodoc multiple pages - Lahiru - 3rd Mar 2020
                                    "c__assignmentFlag": false, //US2382470
                                    "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                                    "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                    "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                                    "c__autodocUniqueIdCmp": cmp.get("v.autodocUniqueIdCmp"),
                                    "c__interactionOverviewTabId" : cmp.get("v.interactionOverviewTabId"), //US2330408  - Avish
                                    "c__memberId" : cmp.get("v.memberId"),
                                    "c__claimNo" : cmp.get("v.claimNo"),
                                    "c__currentIndexOfOpenedTabs" : cmp.get("v.currentIndexOfOpenedTabs"),
                                    "c__isClaimDetail" : cmp.get("v.isClaimDetail"),
                                    "c__currentIndexOfAuthOpenedTabs" : cmp.get("v.currentIndexOfAuthOpenedTabs"),
                                    "c__maxAutoDocAuthComponents" : cmp.get("v.maxAutoDocAuthComponents"),
                                    "c__isClaim": true,
                                    "c__policy": cmp.get('v.policy'), //US3653687
                                    "c__memberCardData": cmp.get('v.memberCard'),
                                    "c__policySelectedIndex": cmp.get('v.policySelectedIndex')
                                }
                            },

                            focus: true

                        }).then(function (response) {

                            console.log("After opening sub tab for claimNoTabUniqueId "+ claimNoTabUniqueId);
                            console.log(JSON.stringify(response));
                            mapOpenedTabs.set(claimNoTabUniqueId, response);
                            console.log("mapOpenedTabs value "+ JSON.stringify(mapOpenedTabs));
                            cmp.set('v.TabMap', mapOpenedTabs);

                            //mapOpenedTabs.set(claimNoTabUniqueId, response);
                            //cmp.set('v.TabMap', mapOpenedTabs);

                            workspaceAPI.setTabLabel({
                                tabId: response,
                                label: srn
                            });
                            workspaceAPI.setTabIcon({
                                 tabId: response,
                                icon: "utility:play",
                                iconAlt: "Auth Details"
                            });


                        }).catch(function (error) {

                        });
                    }


                }).catch(function (error) {

                });
        }
        else
        {
        $A.createComponent('c:ACET_AuthorizationStatus', {
            "compName": authCompId,
            "memberTabId": cmp.get('v.memberTabId'),
            "authID": authid,
            "xrefID": xref,
            "authType": authType,
            "authStatusDetails": cmp.get('v.authStatusDetails'),
            "SRN": srn,
            "LengthOfStay": lofstay,
            "interactionRec": cmp.get('v.interactionRec'), // US2325822 - View Authorizations - ECAA Letter Button Landing Page UI
            "isMedicaidPlan": cmp.get('v.isMedicaidPlan'), // US2325822 - View Authorizations - ECAA Letter Button Landing Page UI
            "AutodocPageFeature": cmp.get('v.AutodocPageFeature'), //US2061071
            "spinnerFlag" : true,
            "AutodocKey": cmp.get('v.AutodocKey'), //US2061071
            "assignmentFlag": true, //US2382470
            "contactUniqueId": cmp.get('v.contactUniqueId'),
            "hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
            "originatorType": cmp.get("v.originatorType"),
            "autodocUniqueId": cmp.get("v.autodocUniqueId"),
            "interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //US2330408  - Avish
            "memberId": cmp.get("v.memberId"), //US2330408  - Avish
            "autodocUniqueIdCmp": cmp.get("v.autodocUniqueId") + authCompId,
            "callTopicLstSelected": cmp.get("v.callTopicLstSelected"),
            "callTopicTabId": cmp.get("v.callTopicTabId"),
            "policy": cmp.get('v.policy'), //US3653687
            "memberCardData": cmp.get('v.memberCard'),
            "policySelectedIndex": cmp.get('v.policySelectedIndex'),

        },
            function (components, status, errorMessage) {
                if (status === "SUCCESS") {
                    var authStatusList = cmp.get("v.authStatusList");

                    // US2619431
                    authStatusList.unshift(components);
                    cmp.set("v.authStatusList", authStatusList);

                    // US2382581
                    helper.rearrangeStatusCards(cmp);

                    // var elenm = authCompId + 'link';

                    // document.getElementById(elenm).style.pointerEvents = "none";
                    // document.getElementById(elenm).style.cursor = "default";
                    // document.getElementById(elenm).style.color = "black";

                    // // DE32622
                    // $(event.target).closest("tr").addClass('highlight');


                }
            }
        );
	  }
    },

    removeStatusComponent: function (cmp, event, helper, authCompId) {
        var authStatusList = cmp.get("v.authStatusList");
        for (var i = 0; i < authStatusList.length; i++) {
            if (authStatusList[i].get('v.compName') == authCompId) {
                authStatusList.splice(i, 1);
            }
        }
        cmp.set("v.authStatusList", authStatusList);
        // US2382581
        helper.rearrangeStatusCards(cmp);
    },

    initAuthTable: function (cmp, helper) {

        cmp.set('v.isInitialCall',false);

        if (!cmp.get("v.IsInitializedTable")) {
            cmp.set('v.dataTblId', 'AuthResultsTbl' + new Date().getTime());
        }

        var dataTblId = ('#' + cmp.get('v.dataTblId'));
        if(!$A.util.isUndefinedOrNull($.fn.DataTable)){
            if ($.fn.DataTable.isDataTable(dataTblId)){
                $(dataTblId).DataTable().destroy();
                //$(dataTblId).DataTable().clear().draw();
                $(dataTblId).find(".autodoc").remove();
            }
        }

        setTimeout(function () {

            var authResults = cmp.get('v.authResults');
            var scrollY = "";
            if (authResults.length >= 7) {
                scrollY = "250px";
            }
            var isSortable = true;
            if(cmp.get("v.isNoRecordsFound")){
                isSortable = false;
            }

            $(dataTblId).DataTable({
                "oLanguage": { "sEmptyTable": "No records found." },
                "bSort" : isSortable,
                "sPaginationType": "full_numbers",
                "bRetrieve": true,
                "aLengthMenu": [
                    [10, 25, 50, 100, 200, -1],
                    [10, 25, 50, 100, 200, "All"]
                ],
                "iDisplayLength": 7,

                "order": [
                    [1, "desc"]
                ],
                "dom": '<"toolbar">frtip',
                "initComplete": function () {

                    cmp.set("v.IsInitializedTable", true);

                    // US2683494 Performance Improvement - View Authorizations Results - Switching Policies
                    // US2748386 - Find auth Perf improvement - Sarma - 20/07/2020
                    if(cmp.get("v.isNoRecordsFound")){

                        if(cmp.get("v.isAllActive")){
                        $(dataTblId+ ' > tbody:last-child').append('<tr> <td colspan="9"><center>No Records Found</center></td></tr>');
                        } else{
                            $(dataTblId+ ' > tbody:last-child').append('<tr> <td colspan="9"><center>No Recent Results Found. Select Toggle for more results.</center></td></tr>');
                        }
                    }

                    let tabKey = cmp.get("v.AutodocKey");
                    // window.lgtAutodoc.initAutodoc(tabKey);

                     $(dataTblId + ' tbody tr .autodoc').on('change', function(evt) {
                    // DE32622
                    if(this.checked != undefined){
                        if(this.checked){
                            $(evt.target).closest("tr").addClass('highlight');
                        } else {
                            $(evt.target).closest("tr").removeClass('highlight');
                        }
                    }
                    cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
                    // US2442658
                    cmp.set("v.AutodocKeyMemberDtl", cmp.get("v.AutodocKey"));

                });

                },
                "drawCallback": function (settings){

                },
                "bPaging": false,
                "bInfo": false,
                "bPaginate": false,
                // "sScrollY": scrollY,
                "pageLength": 7
            });


        }, 1000);

        this.hideAuthResultSpinner(cmp);
    },

    //US2154799
    findAuthorizationResults: function (cmp, helper) {

        let action = cmp.get("c.findAuthorizations");
        let selectedPolicy = cmp.get('v.policy');
        let xrefId = '';
        let memberDob = '';
        let startDate = ''; // US2619791
        let isAllActive = ''; // US2619791
		//Adds this for mocking data purposes
        var policySelectedIndex = cmp.get('v.policySelectedIndex');
        if (!$A.util.isUndefinedOrNull(selectedPolicy) && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper) &&
            !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes)) {
            if (!$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.xrefId)) {
                xrefId = selectedPolicy.resultWrapper.policyRes.xrefId;
                cmp.set('v.xrefId', xrefId);
            }

            memberDob = cmp.get("v.Dob");

            let dt = new Date(memberDob),
                month = '' + (dt.getMonth() + 1),
                day = '' + dt.getDate(),
                year = dt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            memberDob = year + '-' + month + '-' + day;
            startDate = memberDob; // US2619791

        }
        // US2619791 Performance Improvement - View Authorizations - Sarma - 10/06/2020
        // for get auth of last 6 month start date will be Today - 6 months
        if(!cmp.get('v.isAllActive')){

            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0
            var yyyy = today.getFullYear();
            today = mm + '/' + dd + '/' + yyyy;

            const getDaysInMonth = (year, month) => new Date(year, month, 0).getDate()

			const addMonths = (input, months) => {
                const date = new Date(input)
                date.setDate(1)
                date.setMonth(date.getMonth() + months)
                date.setDate(Math.min(input.getDate(), getDaysInMonth(date.getFullYear(), date.getMonth()+1)))
                return date
            }

            startDate = addMonths(new Date(today), -6);

            let dt = new Date(startDate),
            month = '' + (dt.getMonth() + 1),
            day = '' + dt.getDate(),
            year = dt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            startDate = year + '-' + month + '-' + day;

            isAllActive = 0;

        } else{
            isAllActive = 1;

        }

        var SRNNumber = cmp.get('v.SRNNumber');

        // Add logic to update dates -- Jay

        var requestParamObj = {};

         if (!$A.util.isUndefinedOrNull(cmp.get("v.serviceFromDate")) &&
             !$A.util.isUndefinedOrNull(cmp.get("v.serviceToDate")))
         {
             var serviceFromDate = cmp.get("v.serviceFromDate"); //"2020-06-04"
             var serviceToDate = cmp.get("v.serviceToDate");  // "2020-12-04"


             requestParamObj = {
                SourceMemberId: xrefId,
                SourceMemberFirstName: cmp.get("v.FirstName"),
                SourceMemberLasttName: cmp.get("v.LastName"),
                SourceMemberDOB: memberDob,
                StartDate: serviceFromDate,
                StopDate: serviceToDate,
                PolicyIndex: policySelectedIndex,
                GetAllAuth: isAllActive,
                SRNNumber: SRNNumber
            }
        }

        else  {

            // US2819909
            requestParamObj = {
                SourceMemberId: xrefId,
                SourceMemberFirstName: cmp.get("v.FirstName"),
                SourceMemberLasttName: cmp.get("v.LastName"),
                SourceMemberDOB: memberDob,
                StartDate: startDate,
                PolicyIndex: policySelectedIndex,
                GetAllAuth: isAllActive,
                SRNNumber: SRNNumber
            }
        }
       // End of Change
        action.setParams({ "requestObject": requestParamObj });

        action.setCallback(this, function (response) {

            let authResults = new Array();
            let state = response.getState();
            this.hideAuthResultSpinner(cmp);
            if (state == "SUCCESS") {

                let result = response.getReturnValue();

                if (!$A.util.isEmpty(result)) {

                    if (result.statusCode == 200) {

                        //InPatient
                        if (!$A.util.isUndefinedOrNull(result.resultWrapper.InPatientSummaries)) {

                            for (let i = 0; i < result.resultWrapper.InPatientSummaries.length; i++) {

                                let authResultObj = new Object();

                                authResultObj.SRN = result.resultWrapper.InPatientSummaries[i].ServiceReferenceNumber;
                                authResultObj.SRN = !$A.util.isEmpty(authResultObj.SRN) ? authResultObj.SRN : '--';

                                authResultObj.startDate = result.resultWrapper.InPatientSummaries[i].ActualAdmitDateTime;
                                // US3077956    Service Dates for Onshore/ Offshore Sarma - 26/11/2020
                                let startDate = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].ActualAdmitDateTime) ? this.processDateString(result.resultWrapper.InPatientSummaries[i].ActualAdmitDateTime) : '--';
                                let endDate = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].ActualDischargeDateTime) ? this.processDateString(result.resultWrapper.InPatientSummaries[i].ActualDischargeDateTime) : '--';

                                authResultObj.ServiceDates = startDate + ' - ' + endDate;

                                authResultObj.PrimaryCode = '--';

                                authResultObj.PrimaryDX = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].PrimaryDiagnosisCode) ? result.resultWrapper.InPatientSummaries[i].PrimaryDiagnosisCode : '--';
                                authResultObj.PrimaryDXdesc = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].PrimaryDiagnosisCodeDescription) ? result.resultWrapper.InPatientSummaries[i].PrimaryDiagnosisCodeDescription : '--';

                                let statusValue = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].ProviderNetworkStatusTypeDescription) ? result.resultWrapper.InPatientSummaries[i].ProviderNetworkStatusTypeDescription : '--';
                                let serviceProviderStatusValue = result.resultWrapper.InPatientSummaries[i].ProviderFirstName + ' ' + result.resultWrapper.InPatientSummaries[i].ProviderLastName;
                                if ($A.util.isEmpty(serviceProviderStatusValue.trim())) {
                                    serviceProviderStatusValue = result.resultWrapper.InPatientSummaries[i].ProviderOrganizationName;
                                }
                                authResultObj.ServiceProviderStatus = !$A.util.isEmpty(serviceProviderStatusValue.trim()) ? serviceProviderStatusValue : '--';
                                authResultObj.ServiceProviderStatus = authResultObj.ServiceProviderStatus + ' / ' + statusValue

                                authResultObj.FacilityStatus = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].ProviderOrganizationName) ? result.resultWrapper.InPatientSummaries[i].ProviderOrganizationName : '--';
                                authResultObj.FacilityStatus = authResultObj.FacilityStatus + ' / ' + statusValue;

                                authResultObj.ServiceSetting = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].ServiceSettingTypeDescription) ? result.resultWrapper.InPatientSummaries[i].ServiceSettingTypeDescription : '--';

                                authResultObj.Type = 'InPatient';

                                authResultObj.AuthId = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].AuthId) ? result.resultWrapper.InPatientSummaries[i].AuthId : '';

                                authResultObj.LengthOfStay = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].LengthOfStay) ? result.resultWrapper.InPatientSummaries[i].LengthOfStay : '';

                                // US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2020
                                authResultObj.StatusTypeCode = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].StatusTypeCode) ? result.resultWrapper.InPatientSummaries[i].StatusTypeCode : '--';

                                authResultObj.StatusTypeDescription = !$A.util.isEmpty(result.resultWrapper.InPatientSummaries[i].StatusTypeDescription) ? result.resultWrapper.InPatientSummaries[i].StatusTypeDescription : '--';

                                authResults.push(authResultObj);
                            }

                        }

                        //OutPatient
                        if (!$A.util.isUndefinedOrNull(result.resultWrapper.OutPatientSummaries)) {

                            for (let i = 0; i < result.resultWrapper.OutPatientSummaries.length; i++) {

                                let authResultObj = new Object();
                                authResultObj.SRN = result.resultWrapper.OutPatientSummaries[i].ServiceReferenceNumber;
                                authResultObj.SRN = !$A.util.isEmpty(authResultObj.SRN) ? authResultObj.SRN : '--';

                                authResultObj.startDate = result.resultWrapper.OutPatientSummaries[i].ServiceStartDate;
                                // US3077956    Service Dates for Onshore/ Offshore Sarma - 26/11/2020
                                let startDate = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ServiceStartDate) ? this.processDateString(result.resultWrapper.OutPatientSummaries[i].ServiceStartDate) : '--';
                                let endDate = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ServiceEndDate) ? this.processDateString(result.resultWrapper.OutPatientSummaries[i].ServiceEndDate) : '--';
                                authResultObj.ServiceDates = startDate + ' - ' + endDate;

                                authResultObj.PrimaryCode = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ProcedureCode) ? result.resultWrapper.OutPatientSummaries[i].ProcedureCode : '--';
                                authResultObj.PrimaryCodeDesc = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ProcedureCodeDescription) ? result.resultWrapper.OutPatientSummaries[i].ProcedureCodeDescription : '--';

                                authResultObj.PrimaryDX = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].PrimaryDiagnosisCode) ? result.resultWrapper.OutPatientSummaries[i].PrimaryDiagnosisCode : '--';
                                authResultObj.PrimaryDXdesc = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].PrimaryDiagnosisCodeDescription) ? result.resultWrapper.OutPatientSummaries[i].PrimaryDiagnosisCodeDescription : '--';

                                let statusValue = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ProviderStatus) ? result.resultWrapper.OutPatientSummaries[i].ProviderStatus : '--';
                                let serviceProviderStatusValue = result.resultWrapper.OutPatientSummaries[i].ProviderFirstName + ' ' + result.resultWrapper.OutPatientSummaries[i].ProviderLastName;
                                authResultObj.ServiceProviderStatus = !$A.util.isEmpty(serviceProviderStatusValue.trim()) ? serviceProviderStatusValue : '--';
                                authResultObj.ServiceProviderStatus = authResultObj.ServiceProviderStatus + ' / ' + statusValue;

                                authResultObj.FacilityStatus = '-- / --';

                                authResultObj.ServiceSetting = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].ServiceSettingTypeDescription) ? result.resultWrapper.OutPatientSummaries[i].ServiceSettingTypeDescription : '--';

                                authResultObj.Type = 'OutPatient';

                                authResultObj.AuthId = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].AuthId) ? result.resultWrapper.OutPatientSummaries[i].AuthId : '';

                                // US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2020
                                authResultObj.StatusTypeCode = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].StatusTypeCode) ? result.resultWrapper.OutPatientSummaries[i].StatusTypeCode : '--';

                                authResultObj.StatusTypeDescription = !$A.util.isEmpty(result.resultWrapper.OutPatientSummaries[i].StatusTypeDescription) ? result.resultWrapper.OutPatientSummaries[i].StatusTypeDescription : '--';

                                authResults.push(authResultObj);
                            }

                        }

                        //OutPatientFacility
                        if (!$A.util.isUndefinedOrNull(result.resultWrapper.OutPatientFacilitySummaries)) {

                            for (let i = 0; i < result.resultWrapper.OutPatientFacilitySummaries.length; i++) {

                                let authResultObj = new Object();
                                authResultObj.SRN = result.resultWrapper.OutPatientFacilitySummaries[i].ServiceReferenceNumber;
                                authResultObj.SRN = !$A.util.isEmpty(authResultObj.SRN) ? authResultObj.SRN : '--';

                                authResultObj.startDate = result.resultWrapper.OutPatientFacilitySummaries[i].ActualAdmitDate;
                                // US3077956    Service Dates for Onshore/ Offshore Sarma - 26/11/2020
                                let startDate = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ActualAdmitDate) ? this.processDateString(result.resultWrapper.OutPatientFacilitySummaries[i].ActualAdmitDate) : '--';
                                let endDate = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ActualDischargeDateTime) ? this.processDateString(result.resultWrapper.OutPatientFacilitySummaries[i].ActualDischargeDateTime) : '--'; //US2308090
                                authResultObj.ServiceDates = startDate + ' - ' + endDate;

                                authResultObj.PrimaryCode = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ProcedureCode) ? result.resultWrapper.OutPatientFacilitySummaries[i].ProcedureCode : '--';
                                authResultObj.PrimaryCodeDesc = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ProcedureCodeDescription) ? result.resultWrapper.OutPatientFacilitySummaries[i].ProcedureCodeDescription : '--';

                                authResultObj.PrimaryDX = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].PrimaryDiagnosisCode) ? result.resultWrapper.OutPatientFacilitySummaries[i].PrimaryDiagnosisCode : '--';
                                authResultObj.PrimaryDXdesc = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].PrimaryDiagnosisCodeDescription) ? result.resultWrapper.OutPatientFacilitySummaries[i].PrimaryDiagnosisCodeDescription : '--';

                                let statusValue = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ProviderNetworkStatusTypeDescription) ? result.resultWrapper.OutPatientFacilitySummaries[i].ProviderNetworkStatusTypeDescription : '--';
                                let serviceProviderStatusValue = result.resultWrapper.OutPatientFacilitySummaries[i].ProviderFirstName + ' ' + result.resultWrapper.OutPatientFacilitySummaries[i].ProviderLastName;
                                if ($A.util.isEmpty(serviceProviderStatusValue.trim())) {
                                    serviceProviderStatusValue = result.resultWrapper.OutPatientFacilitySummaries[i].ProviderOrganizationName;
                                }
                                authResultObj.ServiceProviderStatus = !$A.util.isEmpty(serviceProviderStatusValue.trim()) ? serviceProviderStatusValue : '--';
                                authResultObj.ServiceProviderStatus = authResultObj.ServiceProviderStatus + ' / ' + statusValue;

                                authResultObj.FacilityStatus = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ProviderOrganizationName) ? result.resultWrapper.OutPatientFacilitySummaries[i].ProviderOrganizationName : '--';
                                authResultObj.FacilityStatus = authResultObj.FacilityStatus + ' / ' + statusValue;

                                authResultObj.ServiceSetting = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].ServiceSettingTypeDescription) ? result.resultWrapper.OutPatientFacilitySummaries[i].ServiceSettingTypeDescription : '--';

                                authResultObj.Type = 'OutPatientFacility';

                                authResultObj.AuthId = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].AuthId) ? result.resultWrapper.OutPatientFacilitySummaries[i].AuthId : '';

                                // US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2020
                                authResultObj.StatusTypeCode = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].StatusTypeCode) ? result.resultWrapper.OutPatientFacilitySummaries[i].StatusTypeCode : '--';

                                authResultObj.StatusTypeDescription = !$A.util.isEmpty(result.resultWrapper.OutPatientFacilitySummaries[i].StatusTypeDescription) ? result.resultWrapper.OutPatientFacilitySummaries[i].StatusTypeDescription : '--';

                                authResults.push(authResultObj);
                            }

                        }

                        // US2619791 Performance Improvement - View Authorizations - Sarma - 10/06/2020
                        // US2683494 Performance Improvement - View Authorizations Results - Switching Policies
                        if(!cmp.get('v.isInitialCall')){
                            var temp = new Array();
                            temp = cmp.get('v.authResults');
                            cmp.set('v.authResultsTemp',temp);
                            cmp.set('v.isNoRecordsFoundTemp',cmp.get('v.isNoRecordsFound'));
                            cmp.set('v.isNoRecordsFound', false);
                        }

                        cmp.set("v.authResults", authResults);
                        // DE322385
                        cmp.set("v.isAutodoc", true);
                        //helper.initAuthTable(cmp, helper);

                    } else {
                        // US2683494 Performance Improvement - View Authorizations Results - Switching Policies
                        if(!cmp.get('v.isInitialCall')){
                            var temp = new Array();
                            temp = cmp.get('v.authResults');
                            cmp.set('v.authResultsTemp',temp);

                            cmp.set('v.isNoRecordsFoundTemp',cmp.get('v.isNoRecordsFound'));
                            cmp.set('v.isNoRecordsFound', false);
                        }
                        //US2616399 changes by vishnu 05/20/2020
                        let errorMsg = (result.statusCode == 404)?'No Authorization Results Found':' ';
                        cmp.set("v.ErrorMessage", errorMsg);

                        authResults = [{
                            'SRN':'--',
                            'ServiceDates':'--',
                            'PrimaryCode':'--',
                            'PrimaryDX':'--',
                            'StatusTypeDescription':'--',
                            'ServiceProviderStatus':'--',
                            'FacilityStatus':'--',
                            'ServiceSetting':'--'
                            }];
                        cmp.set("v.authResults", authResults);

                        if(result.statusCode == 404){
                            cmp.set("v.isNoRecordsFound", true);
                        }
                        // DE322385
                        cmp.set("v.isAutodoc", true);
                        //helper.initAuthTable(cmp, helper);
                        //US2748386 - Find auth Perf improvement - Sarma - 20/07/2020
                        if(cmp.get('v.isAllActive')){
                         //DE483224   helper.fireToastMessage("Error!", result.message, "error", "dismissible", "10000");
                        } else{
                            if(result.statusCode != 404){
                                helper.fireToastMessage("We hit a snag.", this.viewAuthErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
                            }
                        }
                    }

                } else {
                    // US2683494 Performance Improvement - View Authorizations Results - Switching Policies

                    if(!cmp.get('v.isInitialCall')){
                        var temp = new Array();
                        temp = cmp.get('v.authResults');
                        cmp.set('v.authResultsTemp',temp);
                        cmp.set('v.isNoRecordsFoundTemp',cmp.get('v.isNoRecordsFound'));
                        cmp.set('v.isNoRecordsFound', false);
                    }

                    authResults = [{
                        'SRN':'--',
                        'ServiceDates':'--',
                        'PrimaryCode':'--',
                        'PrimaryDX':'--',
                        'StatusTypeDescription':'--',
                        'ServiceProviderStatus':'--',
                        'FacilityStatus':'--',
                        'ServiceSetting':'--'
                        }];
                    cmp.set("v.authResults", authResults);

                    //US2616399 changes by vishnu 05/20/2020
                    let errorMsg = ' ';
                    cmp.set("v.ErrorMessage", errorMsg);
                    cmp.set("v.authResults", authResults);
                    // DE322385
                    cmp.set("v.isAutodoc", true);
                    //helper.initAuthTable(cmp, helper);
                    //US2616399 changes by vishnu 05/20/2020
                    helper.fireToastMessage("Error!", result.message, "error", "dismissible", "10000");
                }

            }

            helper.createTableData(cmp);

        });

        $A.enqueueAction(action);

    },

    formatDateMMDDYYYY: function (dobToFormat) {
        let date = new Date(dobToFormat);
        let returnDate;
        try {
            returnDate = ((date.getMonth() > 8) ? (date.getMonth() + 1) : ('0' + (date.getMonth() + 1))) + '/' + ((date.getDate() > 9) ? date.getDate() : ('0' + date.getDate())) + '/' + date.getFullYear();
            //returnDate = date.toLocaleString();
        } catch (error) {
            console.log('###FIND-AUTH-DATE-PARSE-ERROR:', error);
        }
        return returnDate;
    },

    formatStringDate: function (dateParam) {

        var returnDate = '';
        var splitDate = dateParam.split('-');

        if(splitDate.count != 0){
            var year = splitDate[0];
            var month = splitDate[1];
            var day = splitDate[2];

            var returnDate =  month + '\/' + day + '\/' + year;
        }

        return returnDate;
    },

    removeTimeStamp: function (dateParam) {
        let returnDate = '';
        try {
            if (!$A.util.isEmpty(dateParam)) {
                if (dateParam.includes('T')) {
                    returnDate = dateParam.split('T')[0];
                } else if (dateParam.includes(' ')) {
                    returnDate = dateParam.split(' ')[0];
                } else {
                    returnDate = dateParam;
                }
            }
        } catch (error) {

        }

        return returnDate;
    },

    getAuthStatusDetails: function (cmp, event, helper, authstatusId, authData, showOnlyAssignmentErrors) {
        var authid = authData.authId;
        if(cmp.get("v.isClaimDetail")){
         	var selectedPolicy=cmp.get("v.claimspolicyDetails");
         	var xref=selectedPolicy.resultWrapper.policyRes.xrefId;
        }
        else{
            var xref = cmp.get('v.xrefId');
        }
        var authType = authData.authType;
        var action = cmp.get("c.getAuthorizationStatus");
        var srn = authData.srn;
        var lofstay = authData.lofstay;
        if (authid == '' || authid == null || authid == undefined || xref == '' || xref == null || xref == undefined) {
            return;
        }
        var requestParams = {
            AUTH_ID: authid, // '156627064',
            XREF_ID: xref // '625871210'
        };
        action.setParams({ requestObject: requestParams });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if (data.statusCode == 200) {
                    //Handle null check for .length
                    if (data.resultWrapper == undefined || data.resultWrapper.length == 0 || data.resultWrapper == null) {
                        helper.fireToastMessage("Error!", 'No records found! Please try again.', "error", "dismissible", "10000");
                        return;
                    }

                    // US3476822
                    if(showOnlyAssignmentErrors){

                        if (!$A.util.isUndefinedOrNull(data.resultWrapper) && !$A.util.isUndefinedOrNull(data.resultWrapper.AuthDetailsResponse)) {
                            if ($A.util.isUndefinedOrNull(data.resultWrapper.AuthDetailsResponse.assignments) ||
                                (!$A.util.isUndefinedOrNull(data.resultWrapper.AuthDetailsResponse.assignments) && data.resultWrapper.AuthDetailsResponse.assignments.length == 0)) {
                                helper.fireToastMessage("Error", 'Auto assignment failed!, please recreate the authorization in ICUE', "warning", "dismissible", "10000");
                            }
                        }

                    } else {

                    var resultWrapper = data.resultWrapper;

                    //US2061071 - Format Date
                    if (!$A.util.isUndefinedOrNull(data.resultWrapper) && !$A.util.isUndefinedOrNull(data.resultWrapper.AuthDetailsResponse.facility)) {
                        let renderedDateTime = data.resultWrapper.AuthDetailsResponse.facility.facilityDecision.renderedDateTime;
                        data.resultWrapper.AuthDetailsResponse.facility.facilityDecision.renderedDateTimeFormated = this.convertMilitaryDate(renderedDateTime, 'dttm');
                    }

                    // DE303000
                    var actualAdmissionDateTimeRendered = '--';
                    var actualDischargeDateTimeRendered = '';
                    var admissionNotifyDateTimeRendered = '--';
                    var advanceNotificationTimeStampRendered = '--';
                    var dischargeNotifyDateTimeRendered = '--';
                    var expectedAdmissionDateRendered = '--';
                    var expectedDischargeDateRendered = '--';
                    // US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
                    var expirationDateRendered = '--';
                    if (!$A.util.isUndefinedOrNull(data.resultWrapper) && !$A.util.isUndefinedOrNull(data.resultWrapper.AuthDetailsResponse.facility)) {

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.actualAdmissionDateTime)) {
                            actualAdmissionDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.actualAdmissionDateTime, 'dttm');
                        }
                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.actualDischargeDateTime)) {
                            actualDischargeDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.actualDischargeDateTime, 'dttm');
                        }

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.admissionNotifyDateTime)) {
                            admissionNotifyDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.admissionNotifyDateTime, 'dttm')
                        }

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.advanceNotificationTimeStamp)) {
                            advanceNotificationTimeStampRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.advanceNotificationTimeStamp, 'dttm');
                        }

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.dischargeNotifyDateTime)) {
                            dischargeNotifyDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.dischargeNotifyDateTime, 'dttm')
                        }

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.expectedAdmissionDate)) {
                            expectedAdmissionDateRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.expectedAdmissionDate, 'dt')
                        }

                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.expectedDischargeDate)) {
                            expectedDischargeDateRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.expectedDischargeDate, 'dt')
                        }
                        // US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.expirationDate)) {
                            expirationDateRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.expirationDate, 'dt')
                        }
                        var advanceNotifyDateTimeRendered;
                        // US3222404
                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.advanceNotifyDateTime)) {
                            advanceNotifyDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.facility.advanceNotifyDateTime, 'dt')
                        }

                        resultWrapper.AuthDetailsResponse.facility.actualAdmitDischargeRendered = actualAdmissionDateTimeRendered + ' - ' + actualDischargeDateTimeRendered;
                        resultWrapper.AuthDetailsResponse.facility.admissionNotifyDateTimeRendered = admissionNotifyDateTimeRendered;
                        resultWrapper.AuthDetailsResponse.facility.advanceNotificationTimeStampRendered = advanceNotificationTimeStampRendered;
                        resultWrapper.AuthDetailsResponse.facility.dischargeNotifyDateTimeRendered = dischargeNotifyDateTimeRendered;
                        resultWrapper.AuthDetailsResponse.facility.expectedAdmissionDischargeRendered = expectedAdmissionDateRendered + ' - ' + expectedDischargeDateRendered;
                        // US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
                        resultWrapper.AuthDetailsResponse.facility.expirationDateRendered = expirationDateRendered;

                        // US3222404
                        resultWrapper.AuthDetailsResponse.facility.advanceNotifyDateTimeRendered = advanceNotifyDateTimeRendered;

                        // IPMNR ALLOWD field (BDD) Translation Logic
                        var ipmnrAllowed = '--';
                        if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.ipcmTypeId) && !$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.ipcmTypeId.description)) {
                            var ipcmTypeId = resultWrapper.AuthDetailsResponse.facility.ipcmTypeId.description;

                            if(ipcmTypeId == 'Y'){
                                ipmnrAllowed = 'Yes'
                            } else  if(ipcmTypeId == 'N'){
                                ipmnrAllowed = 'No'
                            } else  if(ipcmTypeId == 'U'){
                                ipmnrAllowed = 'Unknown'
                            }
                            resultWrapper.AuthDetailsResponse.facility.ipmnrAllowed = ipmnrAllowed;
                        }

                    }

                    // US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
                    var createDateTimeRendered = '--';
                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.createDateTime)) {
                        createDateTimeRendered = this.convertMilitaryDate(resultWrapper.AuthDetailsResponse.createDateTime, 'dttm');
                    }
                    resultWrapper.AuthDetailsResponse.createDateTimeRendered = createDateTimeRendered;


                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.AssignDate)) {
                        let assignDate = resultWrapper.AuthDetailsResponse.AssignDate;
                        resultWrapper.AuthDetailsResponse.AssignDateFormated = this.convertMilitaryDate(assignDate, 'dt');
                    }

                    // PROVIDER DETAILS DATA MANIPULATION
                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.providers)) {
                        var providers = resultWrapper.AuthDetailsResponse.providers;
                        for (var i = 0; i < providers.length; i++) {

                            // ROLE
                            if (!$A.util.isUndefinedOrNull(providers[i].role)) {
                                var roleRendered = '';
                                for (var x = 0; x < providers[i].role.length; x++) {
                                    if (providers[i].role[x].id == 'AD') {
                                        roleRendered += 'Admitting Services, '
                                    }
                                    if (providers[i].role[x].id == 'AT') {
                                        roleRendered += 'Attending Physician, '
                                    }
                                    if (providers[i].role[x].id == 'FA') {
                                        roleRendered += 'Facility, '
                                    }
                                    if (providers[i].role[x].id == 'PC') {
                                        roleRendered += 'Primary Care Provider, '
                                    }
                                    if (providers[i].role[x].id == 'RF') {
                                        roleRendered += 'Requesting Provider, '
                                    }
                                    if (providers[i].role[x].id == 'SJ') {
                                        roleRendered += 'Servicing, '
                                    }
                                    if (providers[i].role[x].id == 'SO') {
                                        roleRendered += 'Surgical Opinion, '
                                    }
                                }
                            }
                            roleRendered = roleRendered.replace(/,\s*$/, "");
                            providers[i].roleRendered = roleRendered;

                            // NAME / STATUS / DESCRIPTION
                            var nameStatusRendered = '';
                            if (!$A.util.isUndefinedOrNull(providers[i].firstName)) {
                                nameStatusRendered += providers[i].firstName;
                                if (!$A.util.isUndefinedOrNull(providers[i].middleName)) {
                                    nameStatusRendered += (' ' + providers[i].middleName);
                                }
                                if (!$A.util.isUndefinedOrNull(providers[i].lastName)) {
                                    nameStatusRendered += (' ' + providers[i].lastName);
                                }
                            } else {
                                if (!$A.util.isUndefinedOrNull(providers[i].organizationName)) {
                                    nameStatusRendered += providers[i].organizationName;
                                }
                            }

                            // DE302268
                            nameStatusRendered += '/';
                            if (!$A.util.isUndefinedOrNull(providers[i].networkStatusType)) {
                                if (!$A.util.isUndefinedOrNull(providers[i].networkStatusType.description)) {
                                    nameStatusRendered += providers[i].networkStatusType.description;
                                } else {
                                    nameStatusRendered += '--';
                                }
                            } else {
                                nameStatusRendered += '--';
                            }

                            providers[i].nameStatusRendered = nameStatusRendered;

                            // ADDRESS
                            var addressRendered = '';
                            if (!$A.util.isUndefinedOrNull(providers[i].address.addressLine1)) {
                                addressRendered += providers[i].address.addressLine1 + ', ';
                            }
                            if (!$A.util.isUndefinedOrNull(providers[i].address.city)) {
                                addressRendered += providers[i].address.city + ', ';
                            }
                            if (!$A.util.isUndefinedOrNull(providers[i].address.state.code)) {
                                addressRendered += providers[i].address.state.code + ', ';
                            }
                            if (!$A.util.isUndefinedOrNull(providers[i].address.postalCode1)) {
                                addressRendered += providers[i].address.postalCode1 + ', ';
                            }
                            addressRendered = addressRendered.replace(/,\s*$/, "");
                            providers[i].addressRendered = addressRendered;

                            resultWrapper.AuthDetailsResponse.providers = providers;

                        }
                    }

                    // SERVICE DETAILS DATA MANIPULATION
                    // US2955613
                    let isNoServiceLine = true;
                    let isAllApproved = true;
                    let isAllDenied = true;
                    let isAllCancelled = true;

                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.services)) {
                        var services = resultWrapper.AuthDetailsResponse.services;
                        for (var i = 0; i < services.length; i++) {

                            if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility)){

                                if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.advanceNotificationTimestamp) ) {
                                    services[i].serviceNonFacility.advanceNotificationTimestampRendered = this.convertMilitaryDate(services[i].serviceNonFacility.advanceNotificationTimestamp, 'dttm');
                                }

                                var serDatesRendered = '';
                                if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.serviceEffDates)) {
                                    if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.serviceEffDates.startDate)) {
                                        serDatesRendered += this.convertMilitaryDate(services[i].serviceNonFacility.serviceEffDates.startDate, 'dt');
                                    } else {
                                        serDatesRendered += '--';
                                    }
                                    serDatesRendered += ' - ';
                                    if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.serviceEffDates.stopDate)) {
                                        serDatesRendered += this.convertMilitaryDate(services[i].serviceNonFacility.serviceEffDates.stopDate, 'dt');
                                    } else {
                                        serDatesRendered += '--';
                                    }
                                } else {
                                    serDatesRendered += '--';
                                }
                                services[i].serDatesRendered = serDatesRendered;

                                var countFreqRendered = '';
                                if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.procedureUnitCount)){
                                    countFreqRendered += services[i].serviceNonFacility.procedureUnitCount;
                                } else{
                                    countFreqRendered += '--';
                                }
                                countFreqRendered += ' ';
                                if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.procedureUnitOfMeasureCode)){
                                    if (!$A.util.isUndefinedOrNull(services[i].serviceNonFacility.procedureUnitOfMeasureCode.description)){
                                        countFreqRendered += services[i].serviceNonFacility.procedureUnitOfMeasureCode.description;
                                    } else{
                                        countFreqRendered += '--';
                                    }
                                } else {
                                    countFreqRendered += '--';
                                }
                                services[i].countFreqRendered = countFreqRendered;
                            }

                                // US2955613 Authorization Decision on the Authorization Status Card and Details Card - Sarma - 27/01/2021
                                if(!$A.util.isEmpty(services[i].serviceDecision) && !$A.util.isEmpty(services[i].serviceDecision.decisionOutcomeCode) && !$A.util.isEmpty(services[i].serviceDecision.decisionOutcomeCode.code)){
                                    isNoServiceLine = false;
                                    switch(services[i].serviceDecision.decisionOutcomeCode.code) {
                                        case '1':
                                            isAllDenied = false;isAllCancelled=false;
                                            break;
                                        case '2':
                                            isAllApproved = false;isAllCancelled=false;
                                            break;
                                        case '4':
                                            isAllDenied = false;isAllApproved=false;
                                            break;
                                    }
                                }
                                //US3222385 - View Auth- Auth Details Decision Date and Time - Sarma - 11/02/2021
                                if(!$A.util.isEmpty(services[i].serviceDecision) && !$A.util.isEmpty(services[i].serviceDecision.decisionRenderedDatetime)){
                                    services[i].serviceDecision.decisionRenderedDatetimeFormatted = this.convertMilitaryDate(services[i].serviceDecision.decisionRenderedDatetime, 'dttm');
                                }
                        }
                        resultWrapper.AuthDetailsResponse.services = services;
                    }
                     // US2955613
                     if(isNoServiceLine){
                        resultWrapper.AuthDetailsResponse.serviceDecisionOutcome = '--';
                     }else if(isAllCancelled){
                        resultWrapper.AuthDetailsResponse.serviceDecisionOutcome = 'Cancelled';
                     } else if(isAllApproved){
                        resultWrapper.AuthDetailsResponse.serviceDecisionOutcome = 'Covered/Approved';
                     }else if(isAllDenied){
                        resultWrapper.AuthDetailsResponse.serviceDecisionOutcome = 'Denied';
                    }else {
                        resultWrapper.AuthDetailsResponse.serviceDecisionOutcome = 'Partial Approval';
                    }

                    // BEDDAY DECISION DATA MANIPULATION
                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility) &&
                        !$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.facilityDecision) &&
                        !$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.facility.facilityDecision.bedDayDecision)) {
                        var beddaydecision = resultWrapper.AuthDetailsResponse.facility.facilityDecision.bedDayDecision;
                        for (var i = 0; i < beddaydecision.length; i++) {

                            // if (!$A.util.isUndefinedOrNull(beddaydecision[i].serviceNonFacility)) {

                                // US3222404
                                var BeginEndDays = '';
                                if (!$A.util.isUndefinedOrNull(beddaydecision[i].bedDates)) {
                                    if (!$A.util.isUndefinedOrNull(beddaydecision[i].bedDates.startDate)) {
                                        BeginEndDays += this.convertMilitaryDate(beddaydecision[i].bedDates.startDate, 'dt');
                                    } else {
                                        BeginEndDays += '--';
                                    }
                                    BeginEndDays += ' - ';
                                    if (!$A.util.isUndefinedOrNull(beddaydecision[i].bedDates.stopDate)) {
                                        BeginEndDays += this.convertMilitaryDate(beddaydecision[i].bedDates.stopDate, 'dt');
                                    } else {
                                        BeginEndDays += '--';
                                    }
                                } else {
                                    BeginEndDays += '--';
                                }
                                beddaydecision[i].BeginEndDays = BeginEndDays;
                            // }

                            if (!$A.util.isUndefinedOrNull(beddaydecision[i].decisionUpdateDateTime)){
                                beddaydecision[i].decisionUpdateDateTimeRendered = this.convertMilitaryDate(beddaydecision[i].decisionUpdateDateTime, 'dttm');
                            }

                        }
                        resultWrapper.AuthDetailsResponse.facility.facilityDecision.bedDayDecision = beddaydecision;
                    }

                    // NOTE DETAILS DATA MANIPULATION
                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.notes)) {
                        for (let i = 0; i < resultWrapper.AuthDetailsResponse.notes.length; i++) {
                            let note = resultWrapper.AuthDetailsResponse.notes[i];
                            note.createDateTimeFormated = this.convertMilitaryDate(note.createDateTime, 'dt');
                        }
                    }

                    // US2382474 Auth Details -  Work Assignment Integration - 19/08/2020 - Sarma
                    // ASSIGNMENT DETAILS DATA MANIPULATION
                    if (!$A.util.isUndefinedOrNull(resultWrapper.AuthDetailsResponse.assignments)) {
                        for (let i = 0; i < resultWrapper.AuthDetailsResponse.assignments.length; i++) {
                            let assignments = resultWrapper.AuthDetailsResponse.assignments[i];
                            assignments.assignmentDateAndTimeFormated = this.convertMilitaryDate(assignments.assignmentDateAndTime, 'dttm');
                            assignments.assignmentDueDateFormated = this.convertMilitaryDate(assignments.assignmentDueDate, 'dt');
                        }
                    }
                    // US2382474 - Ends
                    cmp.set('v.authStatusDetails', resultWrapper);
                    helper.addStatusComponent(cmp, event, helper, authid, xref, authType, srn, lofstay, authstatusId);
                	helper.hideAuthResultSpinner(cmp);

                    }


                } else {
                    helper.hideAuthResultSpinner(cmp);
                    helper.fireToastMessage("We hit a snag.", this.authStatusErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
                }
            } else if (state === "INCOMPLETE") {
                helper.hideAuthResultSpinner(cmp);
                helper.fireToastMessage("Error!", 'INCOMPLETE Response!', "error", "dismissible", "10000");
            } else if (state === "ERROR") {
                helper.hideAuthResultSpinner(cmp);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.fireToastMessage("Error!", errors[0] + ': ' + errors[0].message, "error", "dismissible", "10000");
                    }
                } else {
                    helper.fireToastMessage("Error!", 'Server side error!', "error", "dismissible", "10000");
                }
            }
        });
        $A.enqueueAction(action);
    },

    fireToastMessage: function (title, message, type, mode, duration) {
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

    //US2061071 - Format Date // DE302614 / DE303000
    convertMilitaryDate: function (dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                if (type == 'dt') {
                    var dttm = dateParam;
                    if (!$A.util.isUndefinedOrNull(dateParam.split('-')[3])) {
                        var arr = dateParam.split('-');
                        dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    }
                    returnDate = $A.localizationService.formatDateUTC(dttm, format);
                } else if (type == 'dttm') {
                    var arr = dateParam.split('-');
                    var dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    returnDate = $A.localizationService.formatDateTimeUTC(dttm, format);
                }
            } catch (error) { }
        }
        return returnDate;
    },

    // US2382581
    rearrangeStatusCards: function (cmp, event, helper) {
        var authStatusList = cmp.get("v.authStatusList");
        var order = 1;
        for (var i = authStatusList.length; i > 0; i--) {
            authStatusList[(i - 1)].set('v.cardOrder', order);
            ++order;
        }
        cmp.set("v.authStatusList", authStatusList);
    },

    // US2618180
    fireCallTopicAutodoc: function(cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_CallTopicAutodoc");
        appEvent.setParams({
            memberTabId: cmp.get('v.memberTabId'),
            AutodocKey: cmp.get('v.AutodocKey'),
            AutodocPageFeature: cmp.get('v.AutodocPageFeature')
        });
        appEvent.fire();
    },

    // New AutoDoc
    createTableData: function (cmp) {
        var isClaimDetail=cmp.get("v.isClaimDetail");
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
        // US2969157	View Authorization Enhancements for new auto doc framework - Sarma - 12/10/2020
        cmp.set('v.isInitialCall',false);
        var authTable = new Object();
        authTable.type = 'table';
        // US3653575
        authTable.reportingHeader = 'Authorization Results';
        if(isClaimDetail){
         authTable.componentOrder = 18 +(maxAutoDocComponents*currentIndexOfOpenedTabs);
            authTable.componentName = 'Authorization Results: '+claimNo;
        authTable.autodocHeaderName = 'Authorization Results: '+claimNo;
        }
        else{
        authTable.componentOrder = 3;
        authTable.componentName = 'Authorization Results';
        authTable.autodocHeaderName = 'Authorization Results';
        }
        authTable.tableHeaders = ['SRN#',
            'SERVICE DATES', 'PRIMARY CODE', 'PRIMARY DX', 'STATUS', 'SERVICING PROVIDER/STATUS', 'FACILITY/STATUS',
            'SERVICE SETTING'
        ];
        authTable.caseItemsEnabled = true;
        authTable.hideResolveColumn = true; // DE378183 - Thanish - 21st Oct 2020
        var tableRows = [];
        var authData = cmp.get("v.authResults");
        var autodocSubId;
        //Set Selected Rows
        if(isClaimDetail){
        autodocSubId = cmp.get("v.autodocUniqueIdCmp");
        }
        else{
          autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        }
        var extAuthTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"),autodocSubId,'Authorization Results');
        if(!$A.util.isEmpty(extAuthTable)){
            var selectedR = extAuthTable.selectedRows;
            authTable.selectedRows = selectedR;
            cmp.set("v.selectedRows",selectedR);
        }else{
            cmp.set("v.selectedRows",[]);
        }
        // End

        // US2819909
        var SRNNumber = cmp.get('v.SRNNumber');
        var selectedRows = cmp.get('v.selectedRows');

        if(!cmp.get("v.isNoRecordsFound")){
        authData.forEach(auth => {
            var tableRow = new Object();

            tableRow.checked = false;
            tableRow.resolved = false;
            tableRow.uniqueKey = auth.SRN;//auth.AuthId;
            tableRow.authStatusId = 'authstatus' + auth.SRN + auth.AuthId;
                // US3653575
                tableRow.caseItemsExtId = isClaimDetail ? claimNo : auth.SRN;
            var rowColumnData = [];
            rowColumnData.push(setRowColumnData('link', auth.SRN));
            rowColumnData.push(setRowColumnData('outputText', auth.ServiceDates));
            rowColumnData.push(setRowColumnData('outputText', auth.PrimaryCode));
            rowColumnData.push(setRowColumnData('outputText', auth.PrimaryDX));
            rowColumnData.push(setRowColumnData('outputText', auth.StatusTypeDescription));
            rowColumnData.push(setRowColumnData('outputText', auth.ServiceProviderStatus));
            rowColumnData.push(setRowColumnData('outputText', auth.FacilityStatus));
            rowColumnData.push(setRowColumnData('outputText', auth.ServiceSetting));
            tableRow.rowColumnData = rowColumnData;

            // Additional Details
            var additionalDetails = new Object();
            additionalDetails.authId = auth.AuthId;
            additionalDetails.authType = auth.Type;
            additionalDetails.srn = auth.SRN;
            additionalDetails.lofstay = auth.LengthOfStay;
            additionalDetails.authStatusId = 'authstatus' + auth.SRN + auth.AuthId;
            tableRow.additionalData = additionalDetails;

                // US2819909
                if(SRNNumber == auth.SRN){

                    // US3476822
                    this.getAuthStatusDetails(cmp, null, this, null, additionalDetails, true);
                    cmp.set('v.SRNNumber', '');

                    var selectedAuthIndex = selectedRows.findIndex(function(row){
                        return SRNNumber == row.rowColumnData[0].fieldValue;
                    })

                    if(selectedAuthIndex < 0){
                        tableRow.checked = true;
                        tableRow.resolved = true;
                        selectedRows.push(tableRow);
                    }

                    // Preview Autodoc - US2819895
                    var selectedAutodoc = JSON.parse(cmp.get("v.createdAutodoc"));
                    selectedAutodoc.forEach(element => {
                        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), (cmp.get("v.autodocUniqueId") + tableRow.authStatusId), element);
                    });

                }

             // Autocheck during webservice error
            if(authData.length == 1){
                if(!$A.util.isUndefinedOrNull(auth.SRN) && !$A.util.isEmpty(auth.SRN)){
                    if(auth.SRN == '--'){
                        tableRow.checked = true;
                        tableRow.resolved= true;
                        //selectedRows = [];
                        selectedRows.push(tableRow);
                    }
                }
            }

            tableRows.push(tableRow);
        });
        } else {
            var message = '';
                if(cmp.get("v.isAllActive") || cmp.get("v.isClaimDetail")){
                    message = 'No Authorization Results Found';
                } else{
                    message = 'No Authorization Results in the Last 6 Months';
                }
            //US3307881 View Authorizations: No Authorization on File - Save Case Subtype - Swapnil
            var row = {
                "checked" : true,
                "uniqueKey" : 0,
                "resolved": true,
                "caseItemsExtId" : message,
                "rowColumnData" : [
                    {
                        "isNoRecords" : true,
                        "fieldLabel" : "No Records",
                        "fieldValue" : message,
                        "key" : 0,
                        "isReportable" : true
                    }
                ]
            }
            tableRows.push(row);
            selectedRows = [];
            selectedRows.push(row);
        }
        authTable.tableBody = tableRows;

        // US2819909
        authTable.selectedRows = selectedRows;

        // DE492464 - Thanish 23rd Sept 2021
        if(authTable.selectedRows.length > 0){
            this.setDefaultAutodoc(cmp, false);
        }

        cmp.set("v.authTableData", authTable);
        if(cmp.get("v.isClaimServiceAuth")){
            var childCmp = cmp.find("childComponent");
            childCmp.invokeSearch(cmp.get("v.authNum"));
        }
        // DE482674 - Thanish - 1st Sep 2021
        // this.setDefaultAutodoc(cmp);

        // US2819909
        var autodocSubId;
        if(cmp.get("v.isClaimDetail")){
             autodocSubId = cmp.get("v.autodocUniqueIdCmp");
        }
        else{
         autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        }
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, authTable);

        cmp.set("v.selectedRows", selectedRows);

        this.hideAuthResultSpinner(cmp);

        function setRowColumnData(ft, fv) {
            var rowColumnData = new Object();
            rowColumnData.fieldType = ft;
            // US3157932
            if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
                if (fv.length > 20) {
                    rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                    rowColumnData.titleName = fv;
                } else {
                    rowColumnData.fieldValue = fv;
                    rowColumnData.titleName = '';
                }
            } else {
                rowColumnData.fieldValue = '--';
                rowColumnData.titleName = '';
            }
            rowColumnData.isReportable = true; // US2808753 - Thanish - 12th Oct 2020
            if ('link' == ft) {
                rowColumnData.isLink = true;
            } else if ('outputText' == ft) {
                rowColumnData.isOutputText = true;
            } else if ('isStatusIcon' == ft) {
                rowColumnData.isIcon = true;
            } else {
                rowColumnData.isOutputText = true;
            }
            return rowColumnData;
        }

    },

    handleLinkEnable: function (cmp, authStatusId) {
        var authTable = cmp.get("v.authTableData");
        var tableRows = authTable.tableBody;
        tableRows.forEach(row => {
            if (row.authStatusId == authStatusId) {
                row.linkDisabled = false;
            }
        });

        authTable.tableBody = tableRows;
        cmp.set("v.authTableData",authTable);
        if(cmp.get("v.isClaimServiceAuth")){
            var childCmp = cmp.find("childComponent");
            childCmp.invokeSearch(cmp.get("v.authNum"));
        }
    },

    setDefaultAutodoc: function(cmp, hideInPreview){ // DE492464 - Thanish - 23rd Sept 2021
        var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
        if(!$A.util.isEmpty(defaultAutoDocPolicy) && !$A.util.isEmpty(defaultAutoDocMember)){
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 2;
            memberAutodoc.hideInPreview = hideInPreview; // DE492464 - Thanish - 23rd Sept 2021
            var cardData = [];
            cardData = defaultAutoDocMember.cardData.filter(function(el){
                if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                    return el;
                }
            });
            memberAutodoc.cardData = cardData;
            memberAutodoc.ignoreAutodocWarningMsg = true;
            var autodocSubId;
            if(cmp.get("v.isClaimDetail")){
               autodocSubId = cmp.get("v.autodocUniqueIdCmp");
            }else{
             autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
            }
            // DE456923 - Thanish - 30th Jun 2021
            var policyAutodoc = new Object();
            policyAutodoc.type = "table";
            policyAutodoc.autodocHeaderName = "Policies";
            policyAutodoc.componentName = "Policies";
            policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // // US2928520: Policies Card - updated with "TYPE"
            policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
            policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
            policyAutodoc.callTopic = 'View Member Eligibility';
            policyAutodoc.componentOrder = 0;
            policyAutodoc.ignoreAutodocWarningMsg = true;
            policyAutodoc.hideInPreview = hideInPreview; // DE492464 - Thanish - 23rd Sept 2021
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
            // US3804847 - Krish - 26th August 2021
            var interactionCard = cmp.get("v.interactionCard");
            var providerFullName = '';
            var providerComponentName = '';
            if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
                providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
                providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
            }
            var defaultAutoDocProvider = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
            if(!$A.util.isUndefinedOrNull(defaultAutoDocProvider) && !$A.util.isEmpty(defaultAutoDocProvider)){
                // DE492464 - Thanish - 23rd Sept 2021
                var providerAutodoc = new Object();
                providerAutodoc.componentName = defaultAutoDocProvider.componentName;
                providerAutodoc.componentOrder = 0.25;
                providerAutodoc.noOfColumns = defaultAutoDocProvider.noOfColumns;
                providerAutodoc.type = defaultAutoDocProvider.type;
                providerAutodoc.caseItemsExtId = defaultAutoDocProvider.caseItemsExtId;
                providerAutodoc.allChecked = defaultAutoDocProvider.allChecked;
                providerAutodoc.cardData = defaultAutoDocProvider.cardData;
            	providerAutodoc.hideInPreview = hideInPreview;
                providerAutodoc.ignoreClearAutodoc = false;
                providerAutodoc.ignoreAutodocWarningMsg = true;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, providerAutodoc);
            }
            //US3068299 - Sravan - Start
            this.deleteAutoDoc(cmp);
            //US3068299 - Sravan - End
        }
    },

    // DE482674 - Thanish - 1st Sep 2021
    deleteDefaultAutodoc: function(cmp){
        var autodocSubId;
        if(cmp.get("v.isClaimDetail")){
           autodocSubId = cmp.get("v.autodocUniqueIdCmp");
        }else{
         autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, "Policies");
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, "Member Details");

        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, providerComponentName);
    },

    getAutoDocObject: function(cmp){
        var defaultAutoDoc = _autodoc.getAutodoc(cmp.get("v.memberautodocUniqueId"));
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        for(var i=0; i < selectedString.length; i++) {
            defaultAutoDoc.push(selectedString[i]);
        }

        return selectedString;
    },
     //US2812381
     openCreateAuthTab: function (cmp, event, helper)
     {
         // US2891146	Create SRN - Warning Message

         console.log("AAAA ::: " + cmp.get('v.memberPolicies'));
         let workspaceAPI = cmp.find("workspace");
         //getting focused tab id
         var snapId;
         workspaceAPI.getFocusedTabInfo().then(function(response) {
             snapId = response.tabId;
         });
         workspaceAPI.openSubtab({


             pageReference: {
                 "type": "standard__component",
                 "attributes": {
                     "componentName": "c__ACET_CreateSRNContainer"
                 },
                 "state": {
                     "c__memberTabId": cmp.get('v.memberTabId'),
                     "c__interactionRec" : cmp.get('v.interactionRec'),  // US2816912	Build UI for Create SRN for Add New Provider with Provider Look-up - 2/9/2020 - Sarma
                     "c__contactUniqueId" : cmp.get('v.contactUniqueId'),
                     "c__noMemberToSearch" : cmp.get('v.noMemberToSearch'),
                     "c__memberCardSnap" : cmp.get('v.subjectCard'),
                     "c__policyDetails" : cmp.get('v.policy'),
                     "c__memberPolicies" : JSON.stringify(cmp.get('v.memberPolicies')),
                     "c__policySelectedIndex" : cmp.get('v.policySelectedIndex'),
                     "c__AutodocPageFeature" : cmp.get('v.AutodocPageFeature'),
                     "c__AutodocKey" : cmp.get('v.AutodocKey'),
                     "c__providerSearchResultsADMultiplePages" : cmp.get('v.providerSearchResultsADMultiplePages'),
                     "c__AutodocKeyMemberDtl" : cmp.get('v.AutodocKeyMemberDtl'),
                     "c__AutodocPageFeatureMemberDtl" : cmp.get('v.AutodocPageFeatureMemberDtl'),
                     "c__componentId" : cmp.get('v.componentId'),
                     "c__isHippaInvokedInProviderSnapShot" : cmp.get('v.isHippaInvokedInProviderSnapShot'),
                     "c__hipaaEndpointUrl" : cmp.get('v.hipaaEndpointUrl'),
                     "c__caseNotSavedTopics" : cmp.get('v.caseNotSavedTopics'),
                     "c__providerDetailsForRoutingScreen" : cmp.get('v.providerDetailsForRoutingScreen'),
                     "c__flowDetailsForRoutingScreen" : cmp.get('v.flowDetailsForRoutingScreen'),
                     "c__memberCardData" : cmp.get('v.memberCard'),
                     "c__interactionCard" : cmp.get('v.interactionCard'),
                     "c__contactName" : cmp.get('v.contactName'),
                     "c__selectedTabType" : cmp.get('v.selectedTabType'),
                     "c__originatorType" : cmp.get('v.originatorType'), // US2816983
                     "c__policy" : cmp.get('v.policy'), // US2891067
                     "c__interactionOverviewTabId" : cmp.get('v.interactionOverviewTabId'), // US2954656
                     "c__delegationValue" : cmp.get('v.delegationValue'),
                     "c__patientInfo" : cmp.get('v.patientInfo')


                 }
             },
             focus: true

         }).then(function (response) {
			_setAndGetSessionValues.settingValue(response,snapId);
             workspaceAPI.setTabLabel({
                 tabId: response,
                 label: 'Create Auth'
             });
             workspaceAPI.setTabIcon({
                  tabId: response,
                 icon: "utility:list",
                 iconAlt: "Create Auth"
             });

         }).catch(function (error) {

         });

     },
      // US2566675 FF - Create SRN Button Functionality with Error ICUE is Down - Enhancements - Sarma
     getDowntimFormDetails: function(cmp,helper){
       var policies = cmp.get('v.policy');
       var url='';
       if (!$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)) {
           if (policies.resultWrapper.policyRes.isComPlan) {
               cmp.set('v.isShowDowntimeForm',true);
               url = $A.get("$Label.c.ACET_EI_DowntimeFormUrl");
               cmp.set('v.downtimeFormUrl',url);
           }

           if (policies.resultWrapper.policyRes.isMedicarePlan) {
               cmp.set('v.isShowDowntimeForm',true);
               url = $A.get("$Label.c.ACET_MR_DowntimeFormUrl");
               cmp.set('v.downtimeFormUrl',url);
           }

           if (policies.resultWrapper.policyRes.isMedicaidPlan) {
               cmp.set('v.isShowDowntimeForm',true);
               url = $A.get("$Label.c.ACET_CS_DowntimeFormUrl");
               cmp.set('v.downtimeFormUrl',url);
    }
       }
    },
    // New Public group for Create Auth Pilot - Sarma - 28/10/2020
    openICUE: function(cmp,helper){
        var actionicue = cmp.get("c.GenerateICUEURL");
        actionicue.setParams({
            "MemberId": cmp.get("v.memberId"),
            "firstName": cmp.get("v.FirstName"),
            "lastName": cmp.get("v.LastName"),
            "contactName": cmp.get("v.contactName"),
            "policyNumber" : cmp.get("v.policyNumber"),
            "originatorType": 'Member'
        });

        actionicue.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.ICUEURL", storeResponse);
                helper.getICUEURL(cmp, event, helper);
            }
        });
        $A.enqueueAction(actionicue);
    },
     //US3068299 - Sravan - Start
     deleteAutoDoc : function(component){
        var autoDocToBeDeleted = component.get("v.autoDocToBeDeleted");
        console.log('autoDocToBeDeleted'+ JSON.stringify(component.get("v.autoDocToBeDeleted")));
        console.log('cmp.get("v.autodocUniqueId")'+ component.get("v.autodocUniqueId"));
        if(!$A.util.isUndefinedOrNull(autoDocToBeDeleted) && !$A.util.isEmpty(autoDocToBeDeleted)){
             if(autoDocToBeDeleted.doNotRetainAutodDoc){
                 _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueId")+autoDocToBeDeleted.selectedPolicyKey);
             }
    }
    },
    //US3068299 - Sravan - End

     // US3077956    Service Dates for Onshore/ Offshore Sarma - 26/11/2020
        processDateString: function (dateString) {
            let returnDate = '--';
            let dateParts;
            let splitStrings = dateString.split('T');
            if(splitStrings.length > 0){
                dateParts = splitStrings[0].split('-');
                if(dateParts.length>2){
                    returnDate = dateParts[1] + '/' + dateParts[2] + '/' + dateParts[0];
                }
            }
            return returnDate;
        },
    setClickData: function (cmp,cmpOrd,titleStr,showStr) {
         var srnCard = new Object();
        srnCard.type = 'card';
        srnCard.componentName =titleStr;
        srnCard.noOfColumns = 'slds-size_6-of-12';
        srnCard.componentOrder = cmpOrd;
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,showStr,'','outputText'));
        srnCard.cardData = cardData;
        var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),autodocSubId, srnCard);
        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = true;
        }
    }
})