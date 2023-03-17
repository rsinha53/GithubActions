({
    helperMethod: function() {

    },

    queryClaimServices: function(component, event, helper) {
        var claimType = component.get("v.claimType");
        var claimID = component.get("v.claimID");
        console.log('insideQueryClaimServices');
        var action;
        if (claimType == "02" || claimType == "2") {
            action = component.get("c.getInstClaimDetail");
            console.log('firing getInstClaimDetail event');

        } else if (claimType == "03" || claimType == "3") {
            action = component.get("c.getProfClaimDetail");
            console.log('firing getProfClaimDetail event');
        }
        action.setParams({
            claim_Type: claimType,
            claim_ID: claimID
        });
        action.setCallback(this, function(response) {
            console.log('inside claim detail callback' + claimID);
            console.log('TESTTESTTEST:' + claimType);
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultString = response.getReturnValue();
                component.set("v.baseurl", resultString.baseurl);
                console.log(JSON.parse(resultString.responce));
                var result = JSON.parse(resultString.responce);
                component.set("v.result", result);
                if (result.Success == true) {
                    if (result.Response != null) {

                        var sectionVsCodes = new Object();

                        if (result.Response.TotalUHCs != null && result.Response.TotalUHCs.length > 0) {
                            component.set("v.claimTotalsUHC", result.Response.TotalUHCs[0]);
                            console.log('claim totals uhc set');
                        }
                        if (result.Response.TotalCOB != null && result.Response.TotalCOB.length > 0) {
                            component.set("v.claimTotalsCOB", result.Response.TotalCOB[0]);
                            console.log('claim totals cob set');
                        }
                        if (result.Response.MemberResponsibility != null && result.Response.MemberResponsibility.length > 0) {
                            component.set("v.memResp", result.Response.MemberResponsibility[0]);
                            console.log('member resp set');
                        }
                        if (result.Response.ProviderResponsibility != null && result.Response.ProviderResponsibility.length > 0) {
                            component.set("v.provResp", result.Response.ProviderResponsibility[0]);
                            console.log('prov resp set');
                        }
                        if (result.Response.ServiceLines != null && result.Response.ServiceLines.length > 0) {
                            component.set("v.serviceLines", result.Response.ServiceLines);
                            component.set("v.serviceLinesActiveSections", ['ServiceLines']);
                            var codes = [];
                            for (var i = 0; i < result.Response.ServiceLines.length; i++) {
                                if (result.Response.ServiceLines[i].Revenue != null) {
                                    codes.push(result.Response.ServiceLines[i].Revenue);
                                }
                                if (result.Response.ServiceLines[i].Procedure != null) {
                                    codes.push(result.Response.ServiceLines[i].Procedure);
                                }
                                if (result.Response.ServiceLines[i].Modifier != null) {
                                    codes.push(result.Response.ServiceLines[i].Modifier);
                                }
                            }
                            sectionVsCodes["serviceLines"] = codes;
                            console.log("encoderPro - serviceLines:" + JSON.stringify(codes));
                        }
                        if (result.Response.ClaimCode != null && result.Response.ClaimCode.length > 0) {
                            component.set("v.claimCodes", result.Response.ClaimCode);
                            console.log('claim codes set');
                            component.set("v.claimCodesActiveSections", ['ClaimCodes']);
                        }
                        if (result.Response.ClaimDiagnosis != null && result.Response.ClaimDiagnosis.length > 0) {
                            component.set("v.claimDiagnosis", result.Response.ClaimDiagnosis);
                            console.log('claim diagnosis set');
                            component.set("v.claimDiagActiveSections", ['ClaimDiag']);
                            var codes = [];
                            for (var i = 0; i < result.Response.ClaimDiagnosis.length; i++) {
                                if (result.Response.ClaimDiagnosis[i].DiagnosisCode != null) {
                                    codes.push(result.Response.ClaimDiagnosis[i].DiagnosisCode);
                                }
                            }
                            sectionVsCodes["claimDiagnosis"] = codes;
                            console.log("encoderPro - claimDiagnosis:" + JSON.stringify(codes));
                        }
                        if (result.Response.ClaimEdits != null && result.Response.ClaimEdits.length > 0) {
                            component.set("v.clinicalEdits", result.Response.ClaimEdits);
                            console.log('claim edits set');
                            component.set("v.clinicalEditsActiveSections", ['ClinicalEdits']);
                        }
                        if (result.Response.ClaimEvents != null && result.Response.ClaimEvents.length > 0) {
                            component.set("v.claimEventHistory", result.Response.ClaimEvents);
                            console.log('claim events set');
                            component.set("v.claimEventHistoryActiveSections", ['ClaimEventHist']);
                        }
                        if (result.Response.SurgicalProcedureCodes != null && result.Response.SurgicalProcedureCodes.length > 0) {
                            component.set("v.surgicalProcedureCodes", result.Response.SurgicalProcedureCodes);
                            console.log('surgical procedure codes set');
                            component.set("v.surgicalProcedureCodesActiveSections", ['SurgicalProcedureCodes']);
                        }
                        if (result.Response.OccurrenceCodes != null && result.Response.OccurrenceCodes.length > 0) {
                            component.set("v.occurrenceCodes", result.Response.OccurrenceCodes);
                            console.log('occurrence codes set');
                            component.set("v.occurrenceCodesActiveSections", ['OccurrenceCodes']);
                        }
                        if (result.Response.OccurrenceSpanCodes != null && result.Response.OccurrenceSpanCodes.length > 0) {
                            component.set("v.occurrenceSpanCodes", result.Response.OccurrenceSpanCodes);
                            console.log('occurrence span codes set');
                            component.set("v.occurrenceCodesActiveSections", ['OccurrenceCodes']);
                        }
                        if (result.Response.claimNotesUser != null && result.Response.claimNotesUser.length > 0) {
                            component.set("v.claimNotesUser", result.Response.claimNotesUser);
                            console.log('user notes set');
                            component.set("v.claimNotesUserActiveSections", ['UserNotes']);
                        }
                        if (result.Response.claimNotesSystem != null && result.Response.claimNotesSystem.length > 0) {
                            component.set("v.claimNotesSystem", result.Response.claimNotesSystem);
                            console.log('system notes set');
                            component.set("v.claimNotesSystemActiveSections", ['SystemNotes']);
                        }
                        if (result.Response.PatientInformation != null && result.Response.PatientInformation) {
                            component.set("v.inOutPatientInfo", result.Response.PatientInformation);
                            console.log('patient info set');
                        }
                        var generalInfoObj = {};
                        generalInfoObj.GroupNumber = result.Response.GroupNumber;
                        generalInfoObj.ClaimSplitIndicator = result.Response.ClaimSplitIndicator;
                        generalInfoObj.ReceivedDate = result.Response.ReceivedDate;
                        generalInfoObj.BillType = result.Response.BillType;
                        generalInfoObj.SplitClaimNumber = result.Response.ReferenceClaimID;
                        generalInfoObj.TimelyFilingLimit = result.Response.TimelyFilingLimit;
                        generalInfoObj.AdmitDate = result.Response.AdmitDate;
                        generalInfoObj.ClaimEventType = result.Response.ClaimEventType;
                        generalInfoObj.PatientAccountNumber = result.Response.PatientAccountNumber;
                        generalInfoObj.PatientName = result.Response.PatientName;
                        generalInfoObj.PatientDOB = result.Response.PatientDOB;
                        generalInfoObj.AdmitTime = result.Response.AdmitTime;
                        generalInfoObj.ClaimEventSequenceNumber = result.Response.ClaimEventSequenceNumber;
                        generalInfoObj.SubmissionType = result.Response.SubmissionType;
                        generalInfoObj.DCN = result.Response.DCN;
                        generalInfoObj.relatedIcns = result.Response.relatedIcns;
                        generalInfoObj.ClaimProcessed = result.Response.ClaimProcessed;
                        component.set("v.generalInfo", generalInfoObj);
                        console.log('general info set');
                        var tabKey = component.get("v.AutodocKey") + component.get("v.GUIkey");

                        //                        var inputCodes;

//                        var sectionIds = ["claimCode", "claimDiagnosis", "serviceLines", "claimItem"];
                        //                        var tableVsColMap = new Object;
                        //				        tableVsColMap["claimCode"]      = ["Revenue Code","Procedure Code"];
                        //				        tableVsColMap["claimDiagnosis"] = ["Diagnosis Code"];
                        //				        tableVsColMap["serviceLines"]   = ["Revenue","Procedure","Modifier"];
                        //				        tableVsColMap["claimItem"] = ["Primary Dx"];

                        //				        var codes = [];



                        //TODO: fetch from results instead of through jquery
                        if (component.get("v.primaryDX") != null) {
                            var codes = [];
                            if (component.get("v.primaryDX") != null) {
                                codes[0] = component.get("v.primaryDX");
                                sectionVsCodes["claimItem"] = codes;
                            }
                            console.log("encoderPro - claimItem:" + JSON.stringify(codes));
                        }

                        console.log("sectionVsCodes >>> " + JSON.stringify(sectionVsCodes));
                        var EPAction = component.get("c.getEncoderProDescription");
                        EPAction.setParams({
                            data: JSON.stringify(sectionVsCodes)
                        });
                        EPAction.setCallback(this, function(response) {
                            //map encoder pro codes
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var resultString = response.getReturnValue();
                                console.log('encoder pro results:' + resultString);
                                var results = JSON.parse(resultString);
                                var hoverTimeout;
                                $("td.encoder-pro-code").mouseenter(function(event) {
                                    var codeArray = Object.keys(results.Response);
                                    console.log(codeArray);
                                    for (var i = 0; i < codeArray.length; i++) {
                                        var currentCode = codeArray[i];
                                        if ($(this).text() == currentCode) {
                                            var toolTip = document.createElement("div");
                                            $(toolTip).addClass("eptooltip-modal");
                                            var descArray = results.Response[currentCode];
                                            var descHtml = "<ul style = 'padding:1%'>"
                                            for (var j = 0; j < descArray.length; j++) {
                                                if (JSON.stringify(descArray[j]).indexOf(":") > 0)
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(JSON.stringify(descArray[j]).indexOf(":") + 2, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";
                                                else
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(1, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";

                                            }
                                            descHtml = descHtml + "</ul>";
                                            $(toolTip).html(descHtml);
                                            $(this).append(toolTip);
                                            var posX = event.clientX + 10 + 'px';
                                            var posY = event.clientY + 20 + 'px';
                                            console.log(posX + " :: " + posY);
                                            $(toolTip).show();
                                            if (event.relatedTarget != null && event.relatedTarget.tagName == 'DIV') {
                                                $(toolTip).hide();
                                            }
                                            $(toolTip).css("top", posY);
                                            $(toolTip).css("left", posX);
                                        }
                                    }



                                });
                                $("td.encoder-pro-code").mouseleave(function() {
                                    $(this).find(".eptooltip-modal").remove();
                                });
                            }


                        });

                        setTimeout(function() {
                            window.lgtAutodoc.initAutodoc(tabKey);
                            $A.enqueueAction(EPAction);
			     var dataTblId = ('#'+component.get('v.dataTblId'));
               
                    $(dataTblId).DataTable({   
                        pagingType: "full_numbers",
                        sPaginationType: "full_numbers",
                        order: [[1, 'asc']],
                            "bPaginate": false,
                            "paging": false,
                             "bInfo": false,
                             "bFilter": false,
                              "bPaginate": false,
                               "columnDefs": [{ targets: 'no-sort', orderable: false }]
                    });
                    $(dataTblId).removeClass("dataTable");
                        }, 1);
                    }


                } else {
                    helper.getErrorMsg('GN', result.statusCode, "v.detailServiceErrorMsg", component);
                }
            }


        });
        $A.enqueueAction(action);



    },

    queryClaimPaymentServices: function(component, event, helper) {
        var claimID = component.get("v.claimID");
        var action;
        action = component.get("c.queryClaimPayment");
        action.setParams({
            claim_ID: claimID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.paymentQueryDone", true);
                // DE466798 Start
                var childCmp = component.find("paymentsTabComp");
                childCmp.initAutodocAfterPaymentLoad();
                // DE466798 End
                var resultString = response.getReturnValue();
                console.log('claimpaymentresult-------->' + resultString);
                var result = JSON.parse(resultString);
                if (result.Success == true) {
                    if (result.Response != null) {
                        if (result.Response.Payments != null && result.Response.Payments.length > 0) {
                            component.set("v.medicalPaymentDetails", result.Response.Payments);
                            component.set("v.medicalPaymentDetailsActiveSections", ['MedicalPaymentDetails']);
                            component.set("v.payeeInformationActiveSections", ['PayeeInformation']);

                            for (var i = 0; i < result.Response.Payments.length; i++) {
                                console.log(result.Response.Payments);

                                if (result.Response.Payments[i].PaymentType == "CHK") {
                                    var checkStatusAction;
                                    checkStatusAction = component.get("c.queryCheckStatus");
                                    checkStatusAction.setParams({
                                        checkSeriesDesignator: result.Response.Payments[i].SeriesDesignator,
                                        checkEFTNumber: result.Response.Payments[i].CheckEFTNumber
                                    });
                                    checkStatusAction.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            var resultString = response.getReturnValue();
                                            var result = JSON.parse(resultString);
                                            console.log('checkstatus result');
                                            console.log(result);
                                            if (result.Response != null && result.Response.Payments != null && result.Response.Payments.length > 0) {
                                                var payments = component.get("v.medicalPaymentDetails");
                                                for (var j = 0; j < payments.length; j++) {
                                                if (payments[j].PaymentType == 'CHK' && payments[j].SeriesDesignator == result.Response.Payments[0].SeriesDesignator &&  payments[j].CheckEFTNumber == result.Response.Payments[0].CheckEFTNumber) {
     
                                                        payments[j].CheckStatus = result.Response.Payments[0].CheckStatus;
                                                        payments[j].Cashed = result.Response.Payments[0].Cashed;
                                                        payments[j].VoidStop = result.Response.Payments[0].VoidStop;
                                                        payments[j].Returned = result.Response.Payments[0].Returned;
                                                        payments[j].Reemailed = result.Response.Payments[0].Reemailed;
                                                        component.set("v.medicalPaymentDetails", payments);
                                                    }
                                                }
                                            }
                                        }


                                    });
                                    $A.enqueueAction(checkStatusAction);


                                }

                            }
                        }
                    }
                } else {
                    helper.getErrorMsg('GN', result.statusCode, "v.detailServiceErrorMsg", component);
                }
            }
        });
        $A.enqueueAction(action);

    },

    getErrorMsg: function(prefix, statusCode, errorLoc, component) {
        //build action to query global error handling component
        var errorMsg;
        var action = component.get("c.getStdErrMsg");
        action.setParams({
            prefix: prefix,
            resultStatusCode: statusCode
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                errorMsg = response.getReturnValue();
                component.set(errorLoc, errorMsg);
            }
        });
        $A.enqueueAction(action);
    },

    openCheckImgWindow: function(component, event, helper, seriesDesginator, checkNumber) {
        //build action to open check image window - look at open cirrus link
        var action = component.get("c.getCheckImageUrl");
        var checkImageUrl;
        action.setParams({
            SeriesDesignator: seriesDesginator,
            CheckEFTNumber: checkNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                checkImageUrl = response.getReturnValue();
                window.open(checkImageUrl, '_blank', 'toolbars=0, width=1333, height=706 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');
            }
        });
        $A.enqueueAction(action);
    },

    initDocTable: function(component, event, helper, tableAura, docType, tableName, wrapper, columns) {
        //build action to open check image window - look at open cirrus link
        var action = component.get("c.initClaimDocDatatable");
        var claimID = component.get("v.claimID");

        var memberID = component.get("v.memberID");
        if (docType == 'u_oxf_med_eob' || docType == 'u_clm_ltr') {
            memberID = '';
        }
        action.setParams({
            docType: docType,
            memberId: memberID,
            claimId: claimID
        });
        action.setCallback(this, function(response) {
            //       component.set("v.Loadingspinner",false);
            // var elmnt = document.getElementById("scrollLocation");
            // elmnt.scrollIntoView(true);
            var state = response.getState();
            if (state === "SUCCESS") {
                var responce = JSON.parse(response.getReturnValue().responce);
                console.log('DOCQUERYHERE');
                console.log(responce);
                var DTWrapper = new Object();
                DTWrapper.lgt_dt_PageSize = 50;
                DTWrapper.lgt_dt_SortBy = '1';
                DTWrapper.lgt_dt_SortDir = 'desc';
                DTWrapper.lgt_dt_serviceName = 'ACETLGT_FindDocWebservice'; //Modified by Team-Styx Raviteja on June 11 2021 
                DTWrapper.lgt_dt_PagenationReq = true;
                DTWrapper.lgt_dt_PageNumber = '1';
                DTWrapper.lgt_dt_columns = JSON.parse(columns);
                DTWrapper.lgt_dt_Tablename = tableName;
                DTWrapper.lgt_dt_serviceObj = responce;
                component.set(wrapper, JSON.stringify(DTWrapper));
                console.log(DTWrapper);
                var childCmp = component.find(tableAura);
                childCmp.tableinit();
                var tabKey = component.get("v.AutodocKey") + component.get("v.GUIkey");

                
            }

        });
        $A.enqueueAction(action);
    },

    initMemberEOBTable: function(cmp, event, helper) {
        var tableAura = "MemberEOBDocTable_auraid";
        var docType = "u_oxf_med_eob";
        var tableName = "MemberEOBTable";
        var wrapper = "v.MemberEOBDTWrapper";
        var columns = '[{"title":"Document ID","defaultContent":"","data":"DocumentId","type":"string"},{"title":"Payment Cycle Date","defaultContent":"","data":"u_pay_cyc_dt","type":"date"}]';
        helper.initDocTable(cmp, event, helper, tableAura, docType, tableName, wrapper, columns);
    },

    initProviderRATable: function(cmp, event, helper) {
        var tableAura = "ProviderRADocTable_auraid";
        var docType = "u_oxf_pra";
        var tableName = "ProviderRATable";
        var wrapper = "v.ProviderRADTWrapper";
        var columns = '[{"title":"Document ID","defaultContent":"","data":"DocumentId","type":"string"},{"title":"Payment Cycle Date","defaultContent":"","data":"u_pay_cyc_dt","type":"date"}]';
        helper.initDocTable(cmp, event, helper, tableAura, docType, tableName, wrapper, columns);
    },

    initClaimLetterTable: function(cmp, event, helper) {
        var tableAura = "ClaimLetterDocTable_auraid";
        var docType = "u_clm_ltr";
        var tableName = "ClaimLetterTable";
        var wrapper = "v.ClaimLetterDTWrapper";
        var columns = '[{"title":"Document ID","defaultContent":"","data":"DocumentId","type":"string"},{"title":"Document Name","defaultContent":"","data":"u_tmplt_nm","type":"string"},{"title":"Created Date/Time","defaultContent":"","data":"cmis:creationDate","type":"date"}]';
        helper.initDocTable(cmp, event, helper, tableAura, docType, tableName, wrapper, columns);
    },

    initPhysicalHealthLetterTable: function(cmp, event, helper) {
        var tableAura = "PhysicalHealthLetterDocTable_auraid";
        var docType = "u_optum_physical_health_ltr"; // Updated DOC360 class for Physical Health letter
        var tableName = "PhysicalHealthLetterTable";
        var wrapper = "v.PhysicalHealthLetterDTWrapper";
        var columns = '[{"title":"Document ID","defaultContent":"","data":"DocumentId","type":"string"},{"title":"Document Name","defaultContent":"","data":"u_tmplt_nm","type":"string"},{"title":"Created Date/Time","defaultContent":"","data":"cmis:creationDate"}]';
        helper.initDocTable(cmp, event, helper, tableAura, docType, tableName, wrapper, columns);
    }

})