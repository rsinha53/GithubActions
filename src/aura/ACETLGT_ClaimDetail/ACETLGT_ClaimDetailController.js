({
    doInit : function(component, event, helper) {
		component.set('v.dataTblId', new Date().getTime());
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
        if (component.get("v.pageReference") != null) {
            var importState = component.get("v.pageReference").state;
            component.set('v.AutodocKey',importState.c__AutodocKey);
            setTimeout(function(){ component.set('v.stateobject', importState); },1);
            component.set('v.claimID', importState.c__claimID);
            var claimID = component.get("v.claimID");
            component.set('v.claimType', importState.c__claimType);
            var claimType = component.get("v.claimType");
            component.set('v.cirrClaimID', importState.c__cirrClaimID);
            var cirrClaimID = component.get("v.cirrClaimID");
            component.set('v.phi', importState.c__phi);
            var phi = component.get("v.phi");
            component.set('v.taxID', importState.c__taxID);
            var taxID = component.get("v.taxID");
            component.set('v.provider', importState.c__provider);
            var provider = component.get("v.provider");
            component.set('v.network', importState.c__network);
            var network = component.get("v.network");
            component.set('v.dosStart', importState.c__dosStart);
            var dosStart = component.get("v.dosStart");
            component.set('v.dosEnd', importState.c__dosEnd);
            var dosEnd = component.get("v.dosEnd");
            component.set('v.charged', importState.c__charged);
            var charged = component.get("v.charged");
            component.set('v.paid', importState.c__paid);
            var paid = component.get("v.paid");
            component.set('v.deductible', importState.c__deductible);
            var deductible = component.get("v.deductible");
            component.set('v.patientResp', importState.c__patientResp);
            var patientResp = component.get("v.patientResp");
            component.set('v.statusDate', importState.c__statusDate);
            var statusDate = component.get("v.statusDate");
            component.set('v.status', importState.c__status);
            var status = component.get("v.status");
            component.set('v.eventType', importState.c__eventType);
            var eventType = component.get("v.eventType");
            component.set('v.primaryDX', importState.c__primaryDX);
            var primaryDX = component.get("v.primaryDX");
            component.set('v.memberID', importState.c__memberID);
            var memberID = component.get("v.memberID");
            component.set('v.eid', importState.c__eid);
            var eid = component.get("v.eid");
            component.set('v.srk', importState.c__srk);
            
            var memid = component.get("v.pageReference").state.c__memberID;
            var srk = component.get("v.pageReference").state.c__srk;
            var eid  = component.get("v.pageReference").state.c__eid;
            var callTopic  = component.get("v.pageReference").state.c__callTopic;
            var interaction  = component.get("v.pageReference").state.c__interaction;
            var intId  = component.get("v.pageReference").state.c__intId;
            var groupId  = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;  
            var hghString = component.get("v.pageReference").state.c__hgltPanelDataString;
           var bookOfBusinessTypeCode  = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            var bobcode =  component.get("v.pageReference").state.c__bobcode;
         
            if(!$A.util.isUndefinedOrNull(bobcode)){
            component.set("v.bobcode",bobcode);
            }
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            component.set("v.highlightPanelString", hghString);
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberID', memid);           
            component.set('v.srk', srk);
            console.log('hData :: '+hData);
            console.log('hData 2:: '+JSON.stringify(hData));
            component.set("v.usInfo", uInfo);
            component.set("v.bookOfBusinessTypeCode",bookOfBusinessTypeCode);
            var ServiceStart = new Date (dosStart);
            var ServiceEnd = new Date (dosEnd);
            
            if(hData!=null && hData!='undefined'){
                var EffectiveDate = new Date(hData.EffectiveDate);
                var EndDate = new Date(hData.EndDate);
                if(EffectiveDate!='Invalid Date' && EndDate!='Invalid Date'){
                    if(+EffectiveDate <= +ServiceStart && +EndDate >= +ServiceEnd) {
                        console.log('Claim DOS is inside of the selected coverage period.');
                    }else{
                        component.set('v.DOSErrorMessage', true);
                    }
                }
            }
            helper.queryClaimServices(component, event, helper);
            
            if(intId != undefined ){
                var childCmp = component.find("cComp");
                var memID = component.get("v.memId");
                var GrpNum = component.get("v.grpNum");
                childCmp.childMethodForAlerts(intId,memID,GrpNum,'','');
            }
        }
    },
    OnclickReferral :function(component,event,helper){
        var referralNum = event.currentTarget.getAttribute("data-RefNum"); 
        var pagerefaranceobj = component.get("v.pageReference"); 
        var workspaceAPI = component.find("workspace");
        var hgltData = component.get("v.highlightPanel");
        var intId  = component.get("v.pageReference").state.c__intId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_ReferralSearch"
                    },
                    "state": {
                        "uid": "1",
                        "c__callTopic" : "View PCP Referrals",
                        "c__interaction": pagerefaranceobj.state.c_int,
                        "c__intId":component.get("v.intId"),
                        "c__srk":pagerefaranceobj.state.c__srk,
                        "c__Id":pagerefaranceobj.state.c__memberID,
                        "c__gId":pagerefaranceobj.state.c__gId,                                
                        "c__userInfo":pagerefaranceobj.state.c__userInfo,
                        "c__fname": pagerefaranceobj.state.c__fname,
                        "c__lname": pagerefaranceobj.state.c__lname,                                 
                        "c__dateOfBirth":hgltData.MemberDOB,
                        "c__hgltPanelData":hgltData,
                        "c__eid":pagerefaranceobj.state.c__eid,
                        "c__originatorval": pagerefaranceobj.state.c__originatorval,                               
                        "c__va_dob": pagerefaranceobj.state.c__va_dob,
                        "c__hgltPanelDataString":pagerefaranceobj.state.c__hgltPanelDataString,
                        "c__refnum":referralNum,
                        "c__fromClaimDetail":true
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "View PCP Referrals"
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
    },
    
    queryClaimPaymentServices: function (cmp, event, helper){
    	helper.queryClaimPaymentServices(cmp, event, helper);
    },
    
    switchTab: function (cmp, event, helper) {
        cmp.set('v.tabSelected', event.getParam('id'));
        if(event.getParam('id')== 'PaymentsTab' && !cmp.get("v.paymentQueryDone")){
            //helper.queryClaimPaymentServices(cmp, event, helper);
        }
        //var tabKey = cmp.get("v.AutodocKey") + cmp.get("v.GUIkey");
//        if (event.getParam('id') == 'PaymentsTab' && !cmp.get("v.paymentAutodocDone")) {
//            setTimeout(function() {
//                //                                alert("====");
//                window.lgtAutodoc.initAutodoc(tabKey);
//                //                                alert("==done?==");
//            }, 1);
//        }
//        if (event.getParam('id') == 'DocumentsTab' && !cmp.get("v.paymentQueryDone")) {
//            setTimeout(function() {
//                //                                alert("====");
//                window.lgtAutodoc.initAutodoc(tabKey);
//                //                                alert("==done?==");
//            }, 1);
//        }
//        if (event.getParam('id') == 'NotesTab' && !cmp.get("v.notesAutodocDone")) {
//            setTimeout(function() {
//                        var tabKey = cmp.get("v.AutodocKey") + cmp.get("v.GUIkey");
//                window.lgtAutodoc.initAutodoc(tabKey);
//                component.set('v.notesAutodocDone', true);
//                //                                alert("==done?==");
//            }, 1);
//        }
        //        if(event.getParam('id')== 'DocumentsTab' && !cmp.get("v.docQueryDone")){
        //        	cmp.set("v.docQueryDone", true);
        ////        	helper.initMemberEOBTable(cmp, event, helper);
        ////        	helper.initProviderRATable(cmp, event, helper);
        ////        	helper.initClaimLetterTable(cmp, event, helper);
        ////        	helper.initPhysicalHealthLetterTable(cmp, event, helper);
        //        }
        
    },
    
    openCheckImg: function (cmp, event, helper) {
        var paymentInfo = component.get()
        var dataset = event.target.dataset;
        var seriesDesignator = dataset.seriesDesignator;
        var checkNumber = dataset.checkNumber;
        helper.openCheckImgWindow(cmp, event, helper, seriesDesignator, checkNumber);
        
    },
    
    initMemberEOBTable: function (cmp, event, helper) {
        if(cmp.get("v.MemberEOBDTWrapper")==null){
            helper.initMemberEOBTable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("MemberEOBDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
        
    },
    
    initProviderRATable: function (cmp, event, helper) {
        if(cmp.get("v.ProviderRADTWrapper")==null){
            helper.initProviderRATable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("ProviderRADocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    
    initClaimLetterTable: function (cmp, event, helper) {
            	if(cmp.get("v.ClaimLetterDTWrapper")==null){
        helper.initClaimLetterTable(cmp, event, helper);
            	}
        else{
        	var docTable = cmp.find("ClaimLetterDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    
    initPhysicalHealthLetterTable: function (cmp, event, helper) {

        if(cmp.get("v.PhysicalHealthLetterDTWrapper")==null){
            helper.initPhysicalHealthLetterTable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("PhysicalHealthLetterDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    handlecreatedRow_Event:function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var docType = "";
        var docTypeU = "";
        var  table_id = event.getParam("lgt_dt_table_ID");
        if(table_id!=null && table_id!= "undefined"){
            if(table_id.includes("#ClaimLetterTable_lgt_dt_table_ID")){
                docType = "Claim Letter";
                docTypeU = "u_clm_ltr";
            }else if(table_id.includes("#MemberEOBTable_lgt_dt_table_ID")){
                docType = "Member EOB";
                docTypeU = "u_oxf_med_eob";
            }else if(table_id.includes("#ProviderRATable_lgt_dt_table_ID")){
                docType = "Provider RA";
                docTypeU = "u_oxf_pra";
            }else if(table_id.includes("#PhysicalHealthLetterTable_lgt_dt_table_ID")){
                docType = "Physical Health Letter";
                docTypeU = "u_optum_physical_health_ltr"; // Updated DOC360 class for Physical Health letter
            }
        }
        console.log('tableId: ' + table_id);
        var docId;
        var docContentType;
        var docName;
        var docsize;
        var isDocSizeMoreThanOneMB;
        var srk = component.get("v.srk");
        var memID = component.get("v.memberID");
        if(data!=null){
            docId = data["DocumentId"];
            docContentType = data["cmis:contentStreamMimeType"];
            docName = data["cmis:contentStreamFileName"];
            docsize = parseInt(data["cmis:contentStreamLength"]);
            if(docsize){
                isDocSizeMoreThanOneMB = (docsize/(1024*1024) >= 1 ? true : false);                    
            }       }
        console.log(data);
        $(row).children().first().html("<a id='lnkClaimId' href='#'>" + docId + "</a>");        
        $(row).children().first().on('click', function(e){ 
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_Document"
                        },
                        "state": {
                            "c__docId" : docId,
                            "c__docType" : docType,
                            "c__docContentType": docContentType,
                            "c__docName": docName,
                            "c__docSize": docsize,
                            "c__isDocSizeMoreThanOneMB": isDocSizeMoreThanOneMB,
                            "c__performAction": "0",
                            "c__srk": srk,
                            "c__memberID": memID,
                            "c__userInfo":component.get("v.userInfo"),
                            "c__hgltPanelData":component.get("v.highlightPanelData"),
                            "c__selecteddoctype":docTypeU,
                            "c__bookOfBusinessTypeCode":component.get("v.bobcode")
                        
                        }
                    }
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: "Document - " + docId
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:display_text",
                            iconAlt: "Document"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            });
        });
    },
    OnckickAuthNum :function(component,event,helper){
        var authorizationnum = event.currentTarget.getAttribute("data-AuthNum");  
        var workspaceAPI = component.find("workspace");
        
        var pagerefaranceobj = component.get("v.pageReference");
        
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_ViewAuthorizations_Main"
                    },
                    "state": {
                        "uid": "1",
                        "c__callTopic" : "View Authorizations",
                        "c__interaction": pagerefaranceobj.state.c__int,
                        "c__intId":pagerefaranceobj.state.c__intId,
                        "c__srk":pagerefaranceobj.state.c__srk,
                        "c__Id":pagerefaranceobj.state.c__memberID,
                        "c__gId":pagerefaranceobj.state.c__gId,
                        "c__fname": pagerefaranceobj.state.c__fname,
                        "c__lname": pagerefaranceobj.state.c__lname,
                        "c__va_dob": pagerefaranceobj.state.c__va_dob,
                        "c__originatorval": pagerefaranceobj.state.c__originatorval,
                        "c__userInfo":pagerefaranceobj.state.c__userInfo,
                        "c__hgltPanelData":pagerefaranceobj.state.c__hgltPanelData,
                        "c__hgltPanelDataString":pagerefaranceobj.state.c__hgltPanelDataString,
                        "c__authnum":authorizationnum,
                        "c__memberid": component.get("v.memberID"),
                        "c__eid": component.get("v.eid"),
						"c__int": component.get("v.int"),
                        "c__fromClaimDetail":true
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "View Authorizations"
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
    },
    
    Onclickpaymentnum:function(component,event,helper){
        var seriesDesignator = event.currentTarget.getAttribute("data-SeriesDesignator"); 
        var paymentnum = event.currentTarget.getAttribute("data-Paymentnum");
        var workspaceAPI = component.find("workspace");
        
        var pagerefaranceobj = component.get("v.pageReference");
        
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_PaymentSearch"
                    },
                    "state": {
                        "uid": "1",
                        "c__callTopic" : "View Payments",
                        "c__interaction": pagerefaranceobj.state.c__int,
                        "c__intId":pagerefaranceobj.state.c__intId,
                        "c__srk":pagerefaranceobj.state.c__srk,
                        "c__Id":pagerefaranceobj.state.c__memberID,
                        "c__gId":pagerefaranceobj.state.c__gId,
                        "c__fname": pagerefaranceobj.state.c__fname,
                        "c__lname": pagerefaranceobj.state.c__lname,
                        "c__va_dob": pagerefaranceobj.state.c__va_dob,
                        "c__originatorval": pagerefaranceobj.state.c__originatorval,
                        "c__userInfo":pagerefaranceobj.state.c__userInfo,
                        "c__hgltPanelData":pagerefaranceobj.state.c__hgltPanelData,
                        "c__hgltPanelDataString":pagerefaranceobj.state.c__hgltPanelDataString,
                        "c__paymentNum":paymentnum,
                        "c__seriesDesignator":seriesDesignator,
                        "c__memberid": component.get("v.memberID"),
                        "c__eid": component.get("v.eid"),
						"c__int": component.get("v.int"),
                        "c__fromClaimDetail":true
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "View Payments"
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
    },
    OnclickclaimEvent:function(component,event,helper){
        var claimsdetailresult = component.get("v.result").Response;
        delete claimsdetailresult.OccurrenceCodes;
        delete claimsdetailresult.ClaimDiagnosis;
        delete claimsdetailresult.CauseCode;
        delete claimsdetailresult.profTotaProviderPenaltyAmount;
        delete claimsdetailresult.ProfTotalProviderReimbursementReductionAmount;
        delete claimsdetailresult.ProfTotalMemberReimbursementReductionAmount;
        delete claimsdetailresult.ProfTotalMemberPenaltyAmount;
        delete claimsdetailresult.Payments;
        delete claimsdetailresult.OccurrenceCodes;
        delete claimsdetailresult.InstiTotaProviderPenaltyAmount;
        delete claimsdetailresult.InstiTotalMemberReimbursementReductionAmount;
        delete claimsdetailresult.InstiTotalProviderReimbursementReductionAmount;
        delete claimsdetailresult.InstiTotalMemberPenaltyAmount;
        delete claimsdetailresult.ClaimDiagnosis;
        delete claimsdetailresult.CauseCode;
        delete claimsdetailresult.SurgicalProcedureCodes;
        delete claimsdetailresult.ServiceLines;
        delete claimsdetailresult.claimNotesSystem;
        delete claimsdetailresult.ClaimEvents;
        delete claimsdetailresult.ClaimEdits;
        delete claimsdetailresult.ClaimCode;
        var baseurl = component.get("v.baseurl");
        var EventSequenceNumber = event.currentTarget.getAttribute("data-EventSequenceNumber"); 
        var EventType = event.currentTarget.getAttribute("data-EventType");
        var EventID = event.currentTarget.getAttribute("data-EventID");
        var pagerefaranceobjval = component.get("v.pageReference").state;
        var pagerefaranceObj = new Object();
        pagerefaranceObj.c__EventSequenceNumber = EventSequenceNumber;
        pagerefaranceObj.c__EventType = EventType;
        pagerefaranceObj.c__EventID = EventID;
        pagerefaranceObj.c__memberID = pagerefaranceobjval.c__memberID;
        pagerefaranceObj.c__eventType = pagerefaranceobjval.c__eventType;
        pagerefaranceObj.c__claimID = pagerefaranceobjval.c__claimID;
        pagerefaranceObj.c__claimType = pagerefaranceobjval.c__claimType;
        pagerefaranceObj.c__cirrClaimID = pagerefaranceobjval.c__cirrClaimID;
        pagerefaranceObj.c__phi = pagerefaranceobjval.c__phi;
        pagerefaranceObj.c__taxID = pagerefaranceobjval.c__taxID;
        pagerefaranceObj.c__provider = pagerefaranceobjval.c__provider;
        pagerefaranceObj.c__network = pagerefaranceobjval.c__network;
        pagerefaranceObj.c__dosStart = pagerefaranceobjval.c__dosStart;
        pagerefaranceObj.c__dosEnd = pagerefaranceobjval.c__dosEnd;
        pagerefaranceObj.c__charged = pagerefaranceobjval.c__charged;
        pagerefaranceObj.c__paid = pagerefaranceobjval.c__paid;
        pagerefaranceObj.c__deductible = pagerefaranceobjval.c__deductible;
        pagerefaranceObj.c__patientResp = pagerefaranceobjval.c__patientResp;
        pagerefaranceObj.c__statusDate = pagerefaranceobjval.c__patientResp;
        pagerefaranceObj.c__status = pagerefaranceobjval.c__status;
        pagerefaranceObj.c__eventType = pagerefaranceobjval.c__eventType;
        pagerefaranceObj.c__primaryDX = pagerefaranceobjval.c__primaryDX;
        pagerefaranceObj.c__claimsdetailresult = claimsdetailresult;
        var pagerefaranceObjstr = JSON.stringify(pagerefaranceObj);
        var insertlocalstorage= component.get('v.insertlocalstorage');
        component.set("v.insertlocalstorage", true);
        if(insertlocalstorage != 'true' && pagerefaranceObjstr != '' && pagerefaranceObjstr  != null){                                                 
            localStorage.setItem("ClaimEventData_"+pagerefaranceObj.c__claimID , pagerefaranceObjstr );
             insertlocalstorage = 'true';
            component.set("v.claimEventId",pagerefaranceObj.c__claimID);
        }
        var historyurl = baseurl +'/c/ACETLGT_ClaimHistoryWindow_App.app?claimId='+pagerefaranceObj.c__claimID;
        var openwindowslist  =[];
        var loadiedwindows = component.get("v.clmhistorycmpurllist");
        var openwindows =    window.open(historyurl,'_blank','toolbars=0, width=1333, height=706 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');
        openwindowslist.push(openwindows);
        component.set("v.clmhistorycmpurllist",openwindowslist);
    },
    handleDestroy : function (component, event, helper) {
         var ClaimId =component.get('v.claimEventId');
         localStorage.removeItem("ClaimEventData"+ClaimId);
        var clmhistorycmpurllist =  component.get("v.clmhistorycmpurllist");
        clmhistorycmpurllist.forEach(function(clmhistorycmpurl){
            console.log('url ===>'+clmhistorycmpurl);
            clmhistorycmpurl.close();
        });
    }
})