({
    doInit: function(component, event, helper) {
        //        setTimeout(function() {
        //            //  helper.Call_Server_Side_Action(component, event);  
        //        }, 500);
        if (component.get("v.pageReference") != null) {
            var pagerefarance = component.get("v.pageReference");
            var memid = component.get("v.pageReference").state.c__memberid;
            var srk = component.get("v.pageReference").state.c__srk;
            var eid = component.get("v.pageReference").state.c__eid;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            var bookOfBusinessTypeCode = '';
            if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
                bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            }
            console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.AutodocKey', intId + 'viewPayments');
            //alert("======>>"+component.get('AutodocKey'));
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberid', memid);
            component.set('v.srk', srk);
            component.set('v.memberIDSearch', memid);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            component.set("v.usInfo", uInfo);
            var hghString = pagerefarance.state.c__hgltPanelDataString;
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);

        }
        if (component.get("v.pageReference") != null) {
            var pagereferanceobj = component.get("v.pageReference").state;
            var isClaimDetailcall = pagereferanceobj.c__fromClaimDetail;
            if (isClaimDetailcall) {
                component.set("v.paymentNumberSearch", pagereferanceobj.c__paymentNum);
                component.set("v.seriesDesignatorSearch", pagereferanceobj.c__seriesDesignator);
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
        component.set("v.AutodocKey",component.get("v.pageReference").state.c__AutodocKey);
                
                setTimeout(function() {
                    helper.validateSearch(component, event, helper);
                }, 1);
                
            }
            var memid = component.get("v.pageReference").state.c__Id;
            if (memid != null) {
                component.set('v.memberIDSearch', memid);
            }

        }
        document.onkeypress = function(event) {
            if (event.key === "Enter") {
                //    var isvalid = helper.SearchFunctionValidationhelper(component, event);
                //    var isValidSearch = component.get("v.isValidSearch");
                //    if (isvalid && isValidSearch) {
                //     helper.Call_Server_Side_Action(component, event);
                //    }
                helper.validateSearch(component, event, helper);
            }
        };

        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberid");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
        }

    },
    onkeyup_PaymentNumber: function(component, event, helper) {     
      
        component.set("v.paymentNumberSearch", component.get("v.paymentNumberSearch").trim());
        var PaymentNumber = component.get("v.paymentNumberSearch");
        var PaymentNumber_cmp = component.find('paymentNumber');  
      
        //PaymentNumber_cmp.setCustomValidity("");
        //PaymentNumber_cmp.reportValidity();
        if(PaymentNumber == null || PaymentNumber == '' || PaymentNumber == 'undefined'){
          $A.util.removeClass(PaymentNumber_cmp, "hide-error-message"); 
            $A.util.addClass(PaymentNumber_cmp, "slds-has-error");
            PaymentNumber_cmp.setCustomValidity("Error: You must enter a value.");
            PaymentNumber_cmp.reportValidity();
            component.set("v.isValidSearch", false);
        }
        else if (isNaN(PaymentNumber)) {
            var myString = PaymentNumber.replace(/\D/g, '');
            component.set("v.paymentNumberSearch", myString);
            PaymentNumber_cmp.setCustomValidity("Error: Please Enter Numbers Only.");
            PaymentNumber_cmp.reportValidity();
            component.set("v.isValidSearch", false);
        }else {
            PaymentNumber_cmp.setCustomValidity("");
            PaymentNumber_cmp.reportValidity();             
            component.set("v.isValidSearch", true);
        }
        
    },
    onclick_Clear: function(component, event, helper) {
         
       //  $A.util.removeClass(PaymentNumber_cmp, "slds-has-error");        
        component.set("v.paymentNumberSearch", "");
        component.set("v.seriesDesignatorSearch", "");
        component.set("v.memberIDSearch", "");
        component.set('v.showResults', false);
        if (component.get('v.tableComplete')) {
            var lgt_dt_Cmp = component.find("PaymentSearchTable_auraid");
            lgt_dt_Cmp.clearTable_event();
            component.set('v.tableComplete', false);
        }
         var PaymentNumber_cmp = component.find('paymentNumber');
         var PaymentNumber = component.get("v.paymentNumberSearch");
        if(PaymentNumber =='' || PaymentNumber=='undefined' || PaymentNumber==''){
         $A.util.addClass(PaymentNumber_cmp, "hide-error-message");        
         $A.util.removeClass(PaymentNumber_cmp, "slds-has-error");
        }
    },
    onclick_Search: function(component, event, helper) {
        //  var isvalid = helper.SearchFunctionValidationhelper(component, event);
        //  var isValidSearch = component.get("v.isValidSearch");
        //  if (isvalid && isValidSearch) {
        //   helper.Call_Server_Side_Action(component, event);
        //  }
        
        helper.validateSearch(component, event, helper);
    },
    handle_dt_createdRow_Event: function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var table_id = event.getParam("lgt_dt_table_ID");
        var memberid = component.get("v.memberIDSearch");
        var srk = component.get("v.srk");
        if (dataIndex == 0) {
            component.set('v.rowZeroID', row);
        }
        if (table_id.includes('PaymentSearchTable_lgt_dt_table_ID')) {
            $(row).children().on('click', function(e) {
                component.set('v.showDetails', true);
                var selectedRow = component.get('v.selectedRow');
                if (selectedRow == null || (selectedRow != null && dataIndex != selectedRow)) {
                    //			  alert('row ' + dataIndex + ' clicked');
                    component.set('v.selectedRow', dataIndex);
                    console.log(JSON.stringify(data));
                    component.set('v.paymentDetails', data);
                    //                    alert('here');
                    //                    setTimeout(function() {
                    ////                        alert('initiating autodoc');
                    //                        var tabKey = component.get("v.AutodocKey");
                    ////                        window.lgtAutodoc.initAutodoc();
                    ////                        window.lgtAutodoc.initAutodocSelections(tabKey);
                    //                    }, 100);
                    var payeeInfo = [data];
                    payeeInfo = [{
                        PayeeType: data.PayeeType,
                        PayeeName: data.PayeeName,
                        PayeeAddressLine1: data.PayeeAddressLine1,
                        PayeeAddressLine2: data.PayeeAddressLine2,
                        City: data.City,
                        State: data.State,
                        Zip: data.Zip
                    }];
                    component.set('v.PayeeInfo', payeeInfo);
                    if (data.PaymentType == 'CHK') {
                        //fire check status service
                        var checkStatusAction;
                        checkStatusAction = component.get("c.queryCheckStatus");
                        checkStatusAction.setParams({
                            checkSeriesDesignator: data.SeriesDesignator,
                            checkEFTNumber: data.CheckEFTNumber
                        });
                        checkStatusAction.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var resultString = response.getReturnValue();
                                var result = JSON.parse(resultString);
                                console.log('checkstatus result');
                                console.log(result);
                                if (result.Response != null && result.Response.Payments != null && result.Response.Payments.length > 0) {
                                    for (var j = 0; j < result.Response.Payments.length; j++) {
                                        if (data.PaymentType == 'CHK' && data.SeriesDesignator == result.Response.Payments[0].SeriesDesignator && data.CheckEFTNumber == result.Response.Payments[0].CheckEFTNumber) {
                                            data.CheckStatus = result.Response.Payments[0].CheckStatus;
                                            data.Cashed = result.Response.Payments[0].Cashed;
                                            data.VoidStopDate = result.Response.Payments[0].VoidStop;
                                            data.Returned = result.Response.Payments[0].Returned;
                                            data.Reemailed = result.Response.Payments[0].Reemailed;
                                            component.set("v.paymentDetails", data);

                                        }
                                    }
                                }else if(result.Response != null && result.statusCode != 200){
                                 helper.getErrorMsg('GN', result.statusCode, component,event,helper);
                                }
                            }

                        });
                        $A.enqueueAction(checkStatusAction);

                        component.set('v.displayCheckButton', true);
                    } else {
                        component.set('v.displayCheckButton', false);
                    }

                    var paidClaimsAction = component.get("c.initPaidClaimsDatatable");
                    paidClaimsAction.setParams({
                        SeriesDesignator: data.SeriesDesignator,
                        CheckNumber: data.CheckEFTNumber,
                        FirstName: "",
                        LastName: "",
                        MemberId: memberid
                    });
                    paidClaimsAction.setCallback(this, function(response) {
                        component.set("v.Loadingspinner", false);
                        // var elmnt = document.getElementById("scrollLocation");
                        // elmnt.scrollIntoView(true);
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var responce = JSON.parse(response.getReturnValue().responce);
                            var lgt_dt_DT_Object = new Object();
                            lgt_dt_DT_Object.lgt_dt_PageSize = 50;
                            lgt_dt_DT_Object.lgt_dt_StartRecord = 1;
                            lgt_dt_DT_Object.lgt_dt_PageNumber = 1;
                            lgt_dt_DT_Object.lgt_dt_SortBy = '0';
                            lgt_dt_DT_Object.lgt_dt_SortDir = 'asc';
                            lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindClaimPaymentDetailWebService';
                            lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Claim Number","defaultContent":"","data":"ClaimNumber","className":"ClaimNumber_clm_cls","type": "string" },{"title":"Member ID","defaultContent":"","data":"MemberID","className":"MemberID_clm_cls","type": "string"},{"title":"Policy Number","defaultContent":"","data":"PolicyNumber","type": "string"},{"title":"Patient Account Number","defaultContent":"","data":"PatientAccountNumber","type": "string"},{"title":"First Name","defaultContent":"","data":"FirstName","type": "string"},{"title":"Last Name","defaultContent":"","data":"LastName","type": "string"},{"title":"Relationship","defaultContent":"","data":"Relationship","type": "string"},{"title":"Paid Amount","defaultContent":"","data":"PaidAmount","type": "string"},{"title":"Start Date","defaultContent":"","data":"StartDate","type": "date"},{"title":"End Date","defaultContent":"","data":"EndDate","type": "date"}]');
                            lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
                            lgt_dt_DT_Object.lgt_dt_lock_headers = "300"
                            component.set("v.lgt_dt_DT_Object_PaidClaims", JSON.stringify(lgt_dt_DT_Object));
                            var lgt_dt_Cmp = component.find("PaidClaimsTable_auraid");
                            lgt_dt_Cmp.tableinit();
                            //	    component.set('v.showDetails', true);
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " +
                                        errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                    });
                    $A.enqueueAction(paidClaimsAction);
                }
            });
        } else if (table_id.includes('PaidClaimsTable_lgt_dt_table_ID')) {
            $(row).children().first().html("<a id='lnkClaimId' href='javascript:void(0);'>" + data.ClaimNumber + "</a>");
            $(row).children().first().on('click', function(e) {
                var pagerefaranceobj = component.get("v.pageReference");
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACETLGT_ClaimsSearch"
                            },
                            "state": {
                                "c__searchByClaimNumber": true,
                                "c__claimNumber": data.ClaimNumber,
                                "c__callTopic": "View Claims",
                                "c__interaction": component.get('v.int'),
                                "c__intId": component.get('v.intId'),
                                "c__srk": component.get('v.srk'),
                                "c__memberid": component.get('v.memberid'),
                                "c__gId": component.get('v.grpNum'),
                                "c__eid": component.get('v.eid'),
                                "c__fname": component.get('v.fname'),
                                "c__lname": component.get('v.lname'),
                                "c__va_dob": component.get('v.va_dob'),
                                "c__originatorval": component.get('v.originatorval'),
                                "c__userInfo": component.get("v.userInfo"),
                                "c__hgltPanelData": component.get('v.highlightPanel'),
                                "c__AutodocKey": component.get("v.AutodocKey"),
                                "c__hgltPanelDataString": JSON.stringify(component.get('v.highlightPanel'))
                            }
                        }
                    }).then(function(response) {
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function(tabInfo) {
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label: "Claims Search"
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
            });
        }



    },
    handle_dt_callback_Event: function(component, event, helper) {

        //save response

        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
        if (lgt_dt_table_ID.includes('PaymentSearchTable_lgt_dt_table_ID')) {
            component.set('v.isPaymentResultsTable', true);
            var Responce = event.getParam("Responce");
            console.log('response-----------------')
            console.log(Responce);
            var respObj = JSON.parse(Responce);
            component.set('v.PaymentsResp', respObj);
            if(respObj.statusCode === 200){
                if (respObj.Response != null) {
                    component.set('v.PaymentsSize', respObj.Response.length);
                } else {
                    component.set('v.PaymentsSize', 0);
                }
            }else{
                  helper.getErrorMsg('GN', respObj.statusCode, component,event,helper);
            }
        }
    },
    handle_dt_initComplete_Event: function(component, event, helper) {
        var isPaymentResultsTable = component.get('v.isPaymentResultsTable');
        if (isPaymentResultsTable) {
            var paymentsSize = component.get('v.PaymentsSize');
            if (paymentsSize == 1) {
                var rowZeroID = component.get('v.rowZeroID');
                //                alert(rowZeroID);
                //                alert(rowZeroID + ':nth-child(2)');
                $(rowZeroID).children().eq(2).click();

                //                alert(rowZeroID + ':nth-child(2)');
                //                $(rowZeroID + ':nth-child(2)').children().first().click();
                //	Document.getElementById(rowZeroID).click();
            }
            var settings = event.getParam("settings");
            component.set('v.isPaymentResultsTable', false);
        }
    },

    openCheckImg: function(component, event, helper) {
        var paymentInfo = component.get('v.paymentDetails');
        //    	var dataset = event.target.dataset;
        //    	var seriesDesignator = dataset.seriesDesignator;
        //    	var checkNumber = dataset.checkNumber;
        helper.openCheckImgWindow(component, event, helper, paymentInfo.SeriesDesignator, paymentInfo.CheckEFTNumber);

    },
    handle_dt_pageNum_Event: function(component, event, helper) {
        var pgnum = event.getParam("pageNumber");
        //alert("====>>"+pgnum);
        component.set("v.page_Number", pgnum);
    }


})