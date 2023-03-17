({
    doInit: function(component, event, helper) {

        if (component.get("v.pageReference") != null) {
            
            var pagerefarance = component.get("v.pageReference");
            var PCP_OBGYNID = component.get("v.pageReference").state.c_PCP_OBGYNID;
	    var pcpProviderId = component.get("v.pageReference").state.c__pcpProviderId;
            var pcpProviderType = component.get("v.pageReference").state.c__pcpProviderType;
            
            var memId = component.get("v.pageReference").state.c__memberid;
            var srk = component.get("v.pageReference").state.c__srk;
            var subSrk = component.get("v.pageReference").state.c__subSrk;
            var eid = component.get("v.pageReference").state.c__eid;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            var groupNameValue = component.get("v.pageReference").state.c__groupName;
            var Ismnf = component.get("v.pageReference").state.c__Ismnf;
            var bookOfBusinessTypeCode = '';
            var customerPurchaseId = component.get("v.pageReference").state.c__CPID;
            let COStartDate = component.get("v.pageReference").state.c__COStartDate;
            let COEndDate = component.get("v.pageReference").state.c__COEndDate;
            if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
                bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            }
            console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
           
            var fName = component.get("v.pageReference").state.c__fname;
            var lName = component.get("v.pageReference").state.c__lname;
            var memGender = component.get("v.pageReference").state.c__memGender;
            var mName = component.get("v.pageReference").state.c__mName;
            var suffixName = component.get("v.pageReference").state.c__suffixName;
            var ssn;
            var networkId =component.get("v.pageReference").state.networkId;
            if (component.get("v.pageReference").state.c__SSN != undefined) {
                ssn = component.get("v.pageReference").state.c__SSN;    
            }
            if (component.get("v.pageReference").state.c__benefitPlanId != undefined) {
                component.set('v.BenefitPlanId',component.get("v.pageReference").state.c__benefitPlanId);    
            }
            component.set('v.fName',fName);
            component.set('v.lName', lName);
            component.set('v.memGender', memGender);
            component.set('v.mName', mName);
            component.set('v.suffixName', suffixName);
            component.set('v.ssn', ssn);
            component.set("v.Ismnf", Ismnf);
            console.log('groupname');
            console.log(groupNameValue);
            component.set("v.networkId",networkId);
            var providerState = component.get("v.pageReference").state.c__providerState;
            console.log('providerstate');
            console.log(providerState);
            //alert("======>>"+component.get('AutodocKey'));
            component.set('v.pcpobjnidstr',PCP_OBGYNID);
            component.set('v.pcpProviderId', pcpProviderId);
            component.set('v.pcpProviderType', pcpProviderType);
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberId', memId);
            component.set('v.srk', srk);
            component.set("v.subSrk",subSrk);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            component.set("v.usInfo", uInfo);
            var hghString = pagerefarance.state.c__hgltPanelDataString;     
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);           
            var coverageInfoBenefits = component.get("v.pageReference").state.c__coverageInfoBenefits;
            console.log(JSON.stringify(coverageInfoBenefits));
            component.set('v.coverageData',coverageInfoBenefits);
            console.log(component.get('v.coverageData'));
            component.set('v.groupName',groupNameValue);
            component.set('v.providerState',providerState);
          if(!$A.util.isUndefinedOrNull(customerPurchaseId)){
            component.set('v.customerPurchaseId',customerPurchaseId);
            }
            if(!$A.util.isUndefinedOrNull(COStartDate)){
            component.set('v.COStartDate',COStartDate);
            }
            if(!$A.util.isUndefinedOrNull(COEndDate)){
            component.set('v.COEndDate',COEndDate);
            }
            
            var len = 10;
            var buf = [],
                chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
                charlen = chars.length,
                length = len || 32;
                
            for (var i = 0; i < length; i++) {
                buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
            }
            var GUIkey = buf.join('');
            component.set('v.AutodocKey', GUIkey + 'providerLookup');
            var city = component.get("v.pageReference").state.c__city;
            component.set("v.cityVal",city);
            var zip = component.get("v.pageReference").state.c__zip;      
            component.set("v.zipVal",zip);
            var FromPCP = component.get("v.pageReference").state.c__FromPCP;
            component.set("v.FromPCP",FromPCP);
            var FromClaims = component.get("v.pageReference").state.c__FromClaims;
        }

       var providerType = component.get("v.providerType");
        var classification = component.get("v.classification");

                     component.set("v.SpinnerOnLoad",true);
        var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");   
        helper.getUIOptionsafterChange(component,event,helper);
        var FromPCP = component.get("v.pageReference").state.c__FromPCP;
        component.set("v.FromPCP",FromPCP);
        var FromClaims = component.get("v.pageReference").state.c__FromClaims;
        // helper.onSearchRadioChange(component,event,helper,searchType,selectNetworkStatusRadioValue);  
        //helper.onProviderTypeChange(component,event,helper,providerType,classification);
        //helper.onClassificationChange(component,event,helper,providerType,classification);   
        helper.generateUniqueName(component,memId);
		helper.defNetworkValue(component,event,helper);											   
        if(FromPCP){
          /*     setTimeout(function(){ 
            component.set("v.searchType",'ID');
            component.set("v.searchPcpOBGYNId",PCP_OBGYNID);
            component.set("v.providerType",'Physician');
            helper.showResults(component,event,helper);
            },5000);*/

        }
        else if(Ismnf){
            component.set("v.searchRadioValue","Advanced");
            component.set("v.isDisabledBenefitTierValues",true);
            component.set("v.isDisabledNetworkValues",false);
            var lst=['INN and OON'];
            component.set('v.networkStatusRadio',lst);
            component.set("v.selectNetworkStatusRadioValue","INN and OON");
            var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");
            var searchType = component.get("v.searchRadioValue");
           helper.onNetworkTypeChange(component,event,helper,searchType,selectNetworkStatusRadioValue);
        }
        
        else if(FromClaims){
            component.set("v.searchType", 'ID');
            component.set("v.taxId", component.get("v.pageReference").state.c__taxID);
            component.set("v.searchRadioValue","Advanced");
            component.set("v.isDisabledBenefitTierValues",true);
            component.set("v.isDisabledNetworkValues",false);
            var lst=['INN and OON'];
            component.set('v.networkStatusRadio',lst);
            component.set("v.selectNetworkStatusRadioValue","INN and OON");
            var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");
            var searchType = component.get("v.searchRadioValue");
           helper.onNetworkTypeChange(component,event,helper,searchType,selectNetworkStatusRadioValue);
        }

        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberId");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '',bundleId);
        }
         if(!$A.util.isEmpty(memId) && !$A.util.isUndefined(memId)) {
            helper.getCoverageInfoBenefits(component,event,helper);
        }

       var action = component.get("c.getLanguagescmdt");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    //var lst = ['--None--'];
                    var lst = []; 
                    for(var i=0; i < result.length; i++) {
                        if (result[i] != "--None--")
                            //lst.push(result[i].Label);
                            
                            lst.push({label:result[i].Label,value:result[i].DeveloperName}); 
                    }
                    if(result[i] != '--None--') {
                        lst.unshift({label:'--None--',value:''});
                    }
                    component.set('v.languageOptions',lst);
                    
                }
            }
            component.set("v.Spinner", false);    
        });
        $A.enqueueAction(action);
    },
    onSearchRadioChange : function(component, event, helper) {
        var searchType = component.get("v.searchRadioValue");
        var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");  
        component.set('v.isTieredProvider',false);
        helper.onSearchRadioChange(component,event,helper,searchType,selectNetworkStatusRadioValue);
    },
    onProviderTypeChange : function(component, event, helper) {
        debugger;
        var providerType = component.get("v.providerType");
        var classification = component.get("v.classification");
        helper.onProviderTypeChange(component,event,helper,providerType,classification);
        helper.providerTypeHelper(component,event,helper,providerType);
    },
    searchResults : function(component, event, helper) { 
      var pagenum = component.get("v.page_Number");
      var tabkey = component.get("v.AutodocKey");
      if (pagenum != undefined)
        window.lgtAutodoc.storePaginationData(pagenum,tabkey);
      
      helper.searchhelper(component, event, helper);
    },
    onClassificationChange : function(component, event, helper) {
        
        var providerType = component.get("v.providerType");
        console.log('providerType' +providerType);
        var classification = component.get("v.classification");
        console.log('classification' +classification);
        helper.onClassificationChange(component,event,helper,providerType,classification);
    },
    onSearchTypeChange : function(component,event,helper) {
        helper.clearFunctionHelper(component,event, helper);   
        
    },
    onGenderNameChange : function(component,event,helper) {
        component.set("v.isDisabledFreeStandingFacility",false); 
        var gender = component.get("v.gender");
        if(gender != '--None--') {
            component.set("v.providerType",'Physician');
            var classification = component.get("v.classification");
            helper.onProviderTypeChange(component,event,helper,providerType,classification);
            helper.providerTypeHelper(component,event,helper,providerType);
        }
        var providerType = component.get("v.providerType"); 
        if(gender != '--None--' || (gender == '--None--' && providerType == 'Physician')) {
            component.set("v.isCheckedFreeStandingFacility",false);
            component.set("v.isDisabledFreeStandingFacility",true); 
        }
    },
    onChangeFreeStandingFacility : function(component,event,helper) {
        var freeStandingFacility = component.get("v.isCheckedFreeStandingFacility");
        if(freeStandingFacility == true) {
            if(component.get("v.providerType") != 'Facility') {
                component.set("v.providerType",'Facility');
                var classification = component.get("v.classification");
                var providerType = component.get("v.providerType");
                helper.onProviderTypeChange(component,event,helper,providerType,classification);
                helper.providerTypeHelper(component,event,helper,providerType);
            }
        }
    },
    onLanguageChange : function(component,event,helper) {
        component.set("v.isDisabledFreeStandingFacility",false); 
        if(component.get("v.language") != '--None--') {
            component.set("v.isCheckedFreeStandingFacility",false);
            component.set("v.isDisabledFreeStandingFacility",true); 
        }
    },
    onSearchPcpOBGYNIdChange : function(component,event,helper) {
        component.set("v.isDisabledFreeStandingFacility",false); 
        if(component.get("v.searchPcpOBGYNId") != '') {
            component.set("v.isCheckedFreeStandingFacility",false);
            component.set("v.isDisabledFreeStandingFacility",true); 
        }
    },
    onNewpatientsChange : function(component,event,helper) {
        component.set("v.isDisabledFreeStandingFacility",false); 
        var newPatient = component.get("v.isCheckedAcceptingNewPatient");
        if(newPatient == true) {
            component.set("v.isCheckedFreeStandingFacility",false);
            component.set("v.isDisabledFreeStandingFacility",true); 
        }
    },
    onFirstNameChange : function(component,event,helper) {
        component.set("v.isDisabledFreeStandingFacility",false); 
        if(component.get("v.firstName") != '') {
            if(component.get("v.providerType") != 'Physician') {
                component.set("v.providerType",'Physician');
                var classification = component.get("v.classification");
                var providerType = component.get("v.providerType");
                helper.onProviderTypeChange(component,event,helper,providerType,classification);
                helper.providerTypeHelper(component,event,helper,providerType);
            }
        }
        if(component.get("v.firstName") != '' || (component.get("v.firstName") == '' && component.get("v.providerType") == 'Physician')) {
            component.set("v.isCheckedFreeStandingFacility",false);
            component.set("v.isDisabledFreeStandingFacility",true); 
        }
    },
    onNetworkTypeChange : function(component,event,helper){
        var searchType = component.get("v.searchRadioValue");
        var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");    
        helper.onNetworkTypeChange(component,event,helper,searchType,selectNetworkStatusRadioValue);
    },
    allowDigitsOnly: function (component, event, helper) {
        var regex = new RegExp("^[0-9]+$");  
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
    },
    clearResults : function(component,event, helper) {
        helper.clearFunctionHelper(component,event, helper);
        component.set("v.searchType", "Specialty");
        component.set("v.selectNetworkStatusRadioValue","INN Only");
        component.set("v.selectStatusValue","Active");
        component.set("v.showAndHideResults",false);
        component.set("v.isTieredProvider",false);
        var searchType = component.get("v.searchRadioValue");
        if(searchType == 'Advanced'){
            var lst=['INN Only','INN and OON'];
            component.set('v.networkStatusRadio',lst);
            component.set('v.isDisabledBenefitTierValues',false);
            component.set('v.benefitTier','');
            component.set('v.serviceType','');
            var benefitOptions = [];
            benefitOptions.unshift({key:'',value: '--None--'});
            var benefitTierMap = component.get("v.benefitTierMap");
            for (var i in benefitTierMap) {
                   benefitOptions.push({
                               key: benefitTierMap[i].key,
                               value: benefitTierMap[i].value
                             });
            }
            console.log(benefitOptions);
            component.set("v.benefitTierOptions",benefitOptions);
        }
        var lgt_dt_Cmp = component.find("ProviderLookupTable_auraid");
        lgt_dt_Cmp.clearTable_event();
    },
    initComplete_Event: function(component,event, helper) {
        
    },
    handlecreatedRow_Event:function(component,event, helper) {

        var fName = component.get("v.fName");
        var lName = component.get("v.lName");
        var mName = component.get("v.mName");
        var memGender = component.get("v.memGender");
        var suffixName = component.get("v.suffixName");
        var ssn = component.get("v.ssn");
        var subSrk = component.get("v.subSrk");
        var Ismnf = component.get("v.Ismnf");;     
        
        var row = event.getParam("row");   
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var table_id = event.getParam("table_id");
        var memberId = component.get("v.memberId");
        var addressStatus = data.providerLocationAffiliationsStatusCode ? data.providerLocationAffiliationsStatusCode : '';
        var providerTypeCode = data.providerType;
        var workspaceAPI = component.find("workspace");
        if(addressStatus == 'A') {
            $(row).children(":nth-child(15)").html('<div class="slds-icon_container_circle slds-icon-action-approval slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png" style="max-width:12px;"></img></div>');
        }else if(addressStatus == 'I') {
            $(row).children(":nth-child(15)").html('<div class="slds-icon_container_circle slds-icon-action-close slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png" style="max-width:12px;"></img></div>');
        }    
		
		     
        var lbTypes = data.labTypes;
        if(lbTypes != null && lbTypes !=undefined){
            var finalLbTStr = '';
        	lbTypes.forEach(function(e){ 
                if(finalLbTStr == ''){
                    finalLbTStr = finalLbTStr + '<span title="'+e.description+'">'+e.code+'</span>';
                }else{
                	finalLbTStr = finalLbTStr + '- <span title="'+e.description+'">'+e.code+'</span>';    
                }
            	
            });
            var searchedPrvdrType = component.get("v.providerType");
            if(searchedPrvdrType == ''){
            $(row).children(":nth-child(13)").html(finalLbTStr);
            }   else if(searchedPrvdrType == 'Facility'){
                    $(row).children(":nth-child(12)").html(finalLbTStr);
                }
        }
        $(row).children().first().html("<a id='lnkProviderId' href='javascript:void(0);'>" + data.providerId + "</a>");
        $(row).children().first().on('click', function(e) {
            //alert('>>'+component.get("v.networkOptions"));
            var networks = component.get("v.networkOptions");
            var network='';
            if(component.get("v.networkOptions") != null && component.get("v.networkOptions")!= undefined){
                for(var i =0; i< networks.length; i++) {
                    if(networks[i].label == component.get("v.network")) {
                        network = networks[i].value;
                    }
                }
            }
            var pagerefaranceobj = component.get("v.pageReference");
            if(providerTypeCode == 'Physician') {
                workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACETLGT_ProviderLookupDetail"
                            },
                            "state": {
                                "c__providerId": data.providerId,
                                "c__fullName" : data.fullName,
                                "c__providerType": data.providerType,
                                "c__taxId": data.taxId,
                                "c__address": data.address,
                                "c__taxID": data.TaxID,
                                "c__phoneNumber": data.phoneNumber,
                                "c__speciality": data.speciality,
                                "c__PCPRole": data.PCPRole,
                                "c__pcpObgnID": data.pcpObgnID,
                                "c__gender": data.gender,
                                "c__uphd": data.uphd,
                                "c__qualityBenefitTier": data.qualityBenefitTier,
                                "c__Platinum": data.Platinum,
                                "c__radious": data.radious,
                                "c__network": network,
                                "c__providerLocationAffiliationsStatusCode": data.providerLocationAffiliationsStatusCode,
                                "c__addressId": data.addressId,
                                "c__addressTypeCode": data.addressTypeCode,
                                "c__providerTINTypeCode": data.providerTINTypeCode,
                                "c__memberId":component.get("v.memberId"),
                                "c__gId":component.get("v.grpNum"),
                                "c__srk":component.get("v.srk"),
                                "c__subSrk":subSrk,
                                "c__intId": component.get("v.intId"),
                                 "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
                                 "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
                                "c__AutodocKey":component.get("v.AutodocKey"),
                                "c__Ismnf":Ismnf,
                                "c__fName": fName,
                                "c__lName": lName,
                                "c__mName": mName,
                                "c__memGender": memGender,
                                "c__suffixName": suffixName,
                                "c__SSN":ssn,
                                "c__NetworkId":component.get('v.networkId'),
                                "c__qualityProviderRuleId":component.get('v.qualityProviderRuleId'),
                                "c__isTieredProvider" : component.get('v.isTieredProvider')
                                
                            }
                        }
                    }).then(function(response) {
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function(tabInfo) {
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label: "Prov - " + data.fullName
                            });
                            workspaceAPI.setTabIcon({
                                tabId: tabInfo.tabId,
                                icon: "standard:people",
                                iconAlt: "Member"
                            });
                        });
                    }).catch(function(error) {
                        console.log(error);
                    });
                });
            }
            if(providerTypeCode == 'Facility') {
                workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACETLGT_ProviderLookupFacilityDetails"
                            },
                            "state": {
                                "c__providerId": data.providerId,
                                "c__fullName" : data.fullName,
                                "c__providerType": data.providerType,
                                "c__taxId": data.taxId,
                                "c__address": data.address,
                                "c__taxID": data.TaxID,
                                "c__phoneNumber": data.phoneNumber,
                                "c__speciality": data.speciality,
                                "c__PCPRole": data.PCPRole,
                                "c__gender": data.gender,
                                "c__uphd": data.uphd,
                                "c__Platinum": data.Platinum,
                                "c__radious": data.radious,
                                "c__addressId": data.addressId,
                                "c__addressTypeCode": data.addressTypeCode,
                                "c__providerTINTypeCode": data.providerTINTypeCode,
                                "c__memberId":component.get("v.memberId"),
                                "c__gId":component.get("v.grpNum"),
                                "c__srk":component.get("v.srk"),
                                "c__subSrk":subSrk,
                                "c__intId": component.get("v.intId"),
                                "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
                                "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
                                "c__AutodocKey":component.get("v.AutodocKey"),
                                "c__Ismnf":Ismnf,
                                "c__ddpType":data.labTypeCode
                            }
                        }
                    }).then(function(response) {
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function(tabInfo) {
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label: "Prov - " + data.fullName
                            });
                            workspaceAPI.setTabIcon({
                                tabId: tabInfo.tabId,
                                icon: "standard:people",
                                iconAlt: "Member"
                            });
                        });
                    }).catch(function(error) {
                        console.log(error);
                    });
                });
            }
        });
    },
    handledtcallbackevent:function(component,event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
        var provtype = component.find('providerTypeId').get("v.value");
        var comp =  event.getParam("comp");
        var table = $(lgt_dt_table_ID).DataTable();
        var info = table.page.info();
        var currentpage = info.page + 1;
        var totalpages = info.pages;
        var entrypageinfo ='';
        if(provtype != 'Facility'){
            setTimeout(function() {
                if(totalpages >0){
                    entrypageinfo = 'Showing page '+comp.get("v.lgt_dt_currentPageNumber") +' of '+totalpages;
                }
                else{
                    entrypageinfo = 'Showing page 1 of 1.';
                }
                comp.set("v.lgt_dt_entries_info",entrypageinfo);
            }, 1);
        }
        
    },
    onFillValCity : function(component,event,helper) {    
        component.set("v.city", component.get("v.cityVal"));
    },
    onFillValZip : function(component,event,helper) {
        component.set("v.zipCode", component.get("v.zipVal"));
    },
    onValidatetaxId : function(component,even,helper) {
        var taxCmp = component.find('taxId');
        var taxId =  taxCmp.get("v.value");
        if(taxId.length < 9) {
            taxCmp.setCustomValidity("Error: To search by Tax ID number, enter nine digits.");
            taxCmp.reportValidity();
            return false;
        }else {
            taxCmp.setCustomValidity("");
            taxCmp.reportValidity();
            return true;
        }
    },
    onValidatenpiId: function(component,even,helper) {
        var npiCmp =  component.find('npiId');
        var npiId =  npiCmp.get("v.value");
        if(npiId.length < 10) {
            npiCmp.setCustomValidity("Error:  To search by NPI number, enter ten digits.");
            npiCmp.reportValidity();
            return false;
        }else {
            npiCmp.setCustomValidity("");
            npiCmp.reportValidity();
            return true;
        }
    },
    onValidatePhoneNumber : function(component,even,helper) {
        var phoneCmp = component.find('phoneId');
        var phoneId =  phoneCmp.get("v.value");
        if(phoneId.length < 10) {
            phoneCmp.setCustomValidity("Error: Error: Enter a valid 10 digit number.");
            phoneCmp.reportValidity();
            return false;
        }else {
            phoneCmp.setCustomValidity("");
            phoneCmp.reportValidity();
            return true;
        }
    },
    handle_dt_pageNum_Event: function(component, event, helper) {
        var pgnum = event.getParam("pageNumber");
        //alert("====>>"+pgnum);
        component.set("v.page_Number", pgnum);
    },
    onBenefitTierChange : function(component,event,helper) {
          var benefitTier = component.get("v.benefitTier");
          component.set("v.isDisabledNetworkValues",false);
          if(benefitTier == '') {
            component.set("v.isDisabledNetworkValues",true);
         }
          var serviceAreaTypeMap = component.get("v.serviceAreaTypeMap");
          var networkList = [];
          for(var i =0; i< serviceAreaTypeMap.length; i++) {
            if(serviceAreaTypeMap[i].key == benefitTier) {
              component.set('v.serviceType',serviceAreaTypeMap[i].value);
            }
        }
        var networkMap = component.get("v.networkMap"); 
        console.log(networkMap);
        networkList.push({label : '',
                          value : '--None--'
                        }); 
        for(var i =0; i< networkMap.length; i++) {
           var ntwArray = networkMap[i].value;
           for(var j =0; j<ntwArray.length; j++) {
             if(networkMap[i].key == benefitTier) {
                     networkList.push({label : ntwArray[j].split('_')[0],
                                       value : ntwArray[j].split('_')[1]
                                    }); 
             }
           }
        }
              component.set("v.networkOptions",networkList);
              component.set("v.network",networkList[0].label);
    },
    onClickOfEnter : function(component,event,helper) {
        if (event.which == 13){
            helper.searchhelper(component, event, helper);
        }
    }
})