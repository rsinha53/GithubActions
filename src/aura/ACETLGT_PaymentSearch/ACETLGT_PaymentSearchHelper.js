({
    SearchFunctionValidationhelper: function(component, event) {
        var Search_By = component.find("Search_By_ID").get("v.value");
        var Claim_Number_cmp = component.find('clmAuraid');
        if (Search_By == "Claim_Number") {
            var Claim_Number = component.get("v.Claim_Number");
            if ($A.util.isEmpty(Claim_Number) || $A.util.isUndefined(Claim_Number)) {
                Claim_Number_cmp.setCustomValidity("Error: You must enter a value.");
                Claim_Number_cmp.reportValidity();
                return false;
            } else {
                Claim_Number_cmp.setCustomValidity("");
                Claim_Number_cmp.reportValidity();
                return true;
            }
        } else if (Search_By == "Subject") {
            var TaxId_cmp = component.find('TaxIdAuraid');
            var TaxId = component.get("v.TaxID");
            var today = new Date();
            var Start_Date_cmp = component.find('Start_Date_Auraid');
            var End_Date_cmp = component.find('End_Date_Auraid');
            var Start_Date = component.get("v.Start_Date");
            var End_Date = component.get("v.End_Date");
            var inputStart_Date = new Date($A.localizationService.formatDate(Start_Date));
            var DateofService = component.get("v.Date_Of_Service");
            if ((DateofService == "Date Range") && ($A.util.isEmpty(Start_Date) || $A.util.isUndefined(Start_Date))) {
                Start_Date_cmp.setCustomValidity("Error: You must enter a value.");
                Start_Date_cmp.reportValidity();
                return false;
            }
            if (DateofService == "Day" && DateofService != "This Calender Year") {
                if (today < inputStart_Date) {
                    Start_Date_cmp.setCustomValidity("Error: Start Date must be less than or equal to today's date.");
                    Start_Date_cmp.reportValidity();
                    return false;
                }
                if (Start_Date == '' || Start_Date == null || Start_Date == undefined) {
                    Start_Date_cmp.setCustomValidity("Error: You must enter a value.");
                    Start_Date_cmp.reportValidity();
                    return false;
                }
            }
            if ((component.get("v.Date_Of_Service") == "Date Range") && (End_Date == '' || End_Date == null || End_Date == undefined)) {
                End_Date_cmp.set("v.required", "true");
                End_Date_cmp.setCustomValidity("Error: You must enter a value.");
                End_Date_cmp.reportValidity();
                return false;
            }
            if (TaxId != null && TaxId != '' && TaxId != undefined && TaxId.length < '9') {
                TaxId_cmp.setCustomValidity("Error: Tax ID Should be min 10 digits");
                TaxId_cmp.reportValidity();
                component.set("v.isValidSearch", false);
            } else {
                TaxId_cmp.setCustomValidity("");
                TaxId_cmp.reportValidity();
                component.set("v.isValidSearch", true);
                return true;
            }
        }
    },
    Call_Server_Side_Action: function(component, event) {
        component.set("v.responce", "");
        component.set("v.Loadingspinner", true);
        var action = component.get("c.initPaidClaimsDatatable");
        var Search_By = component.find('Search_By_ID').get("v.value");
        var claimnumber = component.get("v.Claim_Number");
        var DateofService = component.get("v.Date_Of_Service");
        var Network_Status = component.get("v.Network_Status");
        var Start_Date = component.get("v.Start_Date");
        var End_Date = component.get("v.End_Date");
        var Provider_Type = component.get("v.Provider_Type");
        var Deductible = '';
        var memid = component.get("v.memberid");
        var Authorization_Number = component.get("v.Authorization_Number");
        var Referral_Number = component.get("v.Referral_Number");
        if (Search_By == "Subject") {
            if (DateofService == "All") {
                Start_Date = "1939-10-11";
                End_Date = "9999-10-11";
            } else if (DateofService == "Day") {
                End_Date = Start_Date;
            }
            if (Network_Status == "All") {
                Network_Status = '';
            }
            if (Provider_Type == "All") {
                Provider_Type = '';
            }
            if (component.find('Deductible_Only_AuraId').get("v.checked")) {
                Deductible = "Y";
            } else {
                Deductible = '';
            }
            if (!$A.util.isEmpty(Authorization_Number) || $A.util.isUndefined(Authorization_Number)) {
                Authorization_Number = '';
            }
            if (!$A.util.isEmpty(Referral_Number) || $A.util.isUndefined(Referral_Number)) {
                Referral_Number = '';
            }
        }
        if (Search_By != "Subject") {
            action.setParams({
                claimnumber: component.get("v.Claim_Number"),
                MemberId: memid,
                EID: "478799929"
            });
        } else {
            action.setParams({
                taxid: component.get("v.TaxID"),
                inNetwork: Network_Status,
                startdate: Start_Date,
                enddate: End_Date,
                strdeductible: Deductible,
                AuthorizationNumber: Authorization_Number,
                ReferralNumber: Referral_Number,
                providers: Provider_Type,
                MemberId: memid,
                EID: "478799929"
            });
        }
        action.setCallback(this, function(response) {
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
                lgt_dt_DT_Object.lgt_dt_SortBy = '6';
                lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
                lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETFindClaimWebservice';
                lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Claim Number","defaultContent":"","data":"ClaimID","className":"ClaimID_clm_cls","type": "string" },{"title":"Cirrus Claim ID","defaultContent":"","data":"SourceClaimId","className":"SourceClaimId_clm_cls","type": "string"},{"title":"PHI","defaultContent":"","data":"PHIRestriction","type": "string"},{"title":"Tax ID","defaultContent":"","data":"TaxID","type": "string"},{"title":"Provider","defaultContent":"","data":"Provider","type": "string"},{"title":"Network","defaultContent":"","data":"Network","type": "string"},{"title":"DOS Start","defaultContent":"","data":"ServiceStart","type": "date"},{"title":"DOS End","defaultContent":"","data":"ServiceEnd","date": "string"},{"title":"Charged","defaultContent":"","data":"TotalCharged","type": "number"},{"title":"Paid","defaultContent":"","data":"TotalPaid","type": "number"},{"title":"Deductible","defaultContent":"","data":"Deductible","type": "number"},{"title":"Patient Resp","defaultContent":"","data":"patientResponsibility","type": "number"},{"title":"Status Date","defaultContent":"","data":"claimEventStatusDate","type": "string"},{"title":"Status","defaultContent":"","data":"Status","type": "string"},{"title":"Event Type","defaultContent":"","data":"claimEvtType","type": "string"},{"title":"Primary Dx ","defaultContent":"","data":"PrimaryDiagnosisCode","type": "string"}]');
                lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
                lgt_dt_DT_Object.lgt_dt_lock_headers = "300"
                component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
                var lgt_dt_Cmp = component.find("ClaimsSearchTable_auraid");
                lgt_dt_Cmp.tableinit();
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

    validateSearch: function(component, event, helper) {
        var paymentNum = component.get("v.paymentNumberSearch");
        var seriesDes = component.get("v.seriesDesignatorSearch");
        var memberID = component.get("v.memberIDSearch");
        
        if (paymentNum == null || paymentNum == 'undefined') {
            paymentNum = '';
        }
        if (seriesDes == null || seriesDes == 'undefined') {
            seriesDes = '';
        }
        if (memberID == null || memberID == 'undefined') {
            memberID = '';
        }
        var firstName = "";
        var lastName = "";
        if (paymentNum == "") {
            var PaymentNumber_cmp = component.find('paymentNumber');
            if (PaymentNumber_cmp != undefined) {
                PaymentNumber_cmp.focus();
                PaymentNumber_cmp.blur();
            }
        } else {
            component.set('v.showResults', true);
            var action = component.get("c.initPaymentResultsDatatable");
            action.setParams({
                SeriesDesignator: seriesDes,
                CheckNumber: paymentNum,
                FirstName: firstName,
                LastName: lastName,
                MemberId: memberID
            });
            action.setCallback(this, function(response) {
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
                    lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
                    lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindClaimPaymentWebService';
                    lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Payment Number","defaultContent":"","data":"CheckEFTNumber","className":"PaymentNumber_clm_cls","type": "string" },{"title":"Series Designator","defaultContent":"","data":"SeriesDesignator","className":"SeriesDesginator_clm_cls","type": "string"},{"title":"Payment Total","defaultContent":"","data":"PaymentTotal","type": "string"},{"title":"Payment Date","defaultContent":"","data":"checkDate","type": "date"},{"title":"Payee Name","defaultContent":"","data":"PayeeName","type": "string"},{"title":"Payee Address","defaultContent":"","data":"PayeeAddress","type": "string"},{"title":"City","defaultContent":"","data":"City","type": "date"},{"title":"State","defaultContent":"","data":"State","type": "string"},{"title":"Zip","defaultContent":"","data":"Zip","type": "number"}]');
                    lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
                    lgt_dt_DT_Object.lgt_dt_lock_headers = "300"
                    component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
                    var lgt_dt_Cmp = component.find("PaymentSearchTable_auraid");
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
            component.set('v.selectedRow', null);
            component.set('v.rowZeroID', null);
            component.set('v.displayCheckButton', false);
            component.set('v.showDetails', false);
            var paymentDetails = [];
            component.set('v.paymentDetails', paymentDetails);
            $A.enqueueAction(action);




        }
    },
     getErrorMsg: function(prefix, statusCode,  component,event,helper) {
        //build action to query global error handling component
        var errorMsg;
        var action = component.get("c.getStdErrMsg");       
        var errcode;
        if(statusCode==400) {
			 errcode= '400B';
		}else {
			 errcode= statusCode;
		}     
		action.setParams({
            prefix: prefix,
            resultStatusCode: errcode
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                errorMsg = response.getReturnValue();               
               if(errorMsg != 'undefined' && errorMsg != null){
                  helper.fireToast("Error:", errorMsg,component,event,helper);
               }
            }
        });
        $A.enqueueAction(action);
    },
    fireToast: function(title, messages,component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
    }

})