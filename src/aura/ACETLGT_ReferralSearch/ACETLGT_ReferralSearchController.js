({
    doInit: function(component, event, helper) {

        if (component.get("v.pageReference") != null) {

            var pagerefarance = component.get("v.pageReference");
            var memid = component.get("v.pageReference").state.c__Id;
            var srk = component.get("v.pageReference").state.c__srk;
            var eid = component.get("v.pageReference").state.c__eid;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            var fname = component.get("v.pageReference").state.c__fname;
            var lname = component.get("v.pageReference").state.c__lname;
            var DOB = component.get("v.pageReference").state.c__dateOfBirth;
            var bookOfBusinessTypeCode = '';
            if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
                bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            }
            console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);

            var len = 10;
            var buf = [],
                chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
                charlen = chars.length,
                length = len || 32;

            for (var i = 0; i < length; i++) {
                buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
            }
            var GUIkey = buf.join('');
            component.set('v.AutodocKey', GUIkey + 'viewPCPReferrals');
            //            component.set('v.AutodocKey', intId + 'viewPCPReferrals');
            //		   alert("======>>"+component.get('v.AutodocKey'));
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberid', memid);
            component.set('v.srk', srk);
            component.set('v.firstName', fname);
            component.set('v.lastName', lname);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            component.set("v.usInfo", uInfo);

            var hghString = pagerefarance.state.c__hgltPanelDataString;
            console.log('hData 3:: ' + hghString);
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            //		   
            //		   		   alert('1: ' + DOB);
            //		   
            //		   alert('2: ' + hData.MemberDOB.split(' (')[0]);
            var trimDOB = hData.MemberDOB.split(' (')[0];
            //		           var strList,mm,dd;
            //		   
            //		   if(trimDOB !=null){
            //	            strList=trimDOB.split('/',3);
            //	        }
            //	        console.log(strList);
            //	        if(strList.length==3){     
            //	            mm =   (parseInt(strList[0]) < 10 ? '0' : '') + strList[0];
            //	            dd =   (parseInt(strList[1]) < 10 ? '0' : '') + strList[1];
            //	            trimDOB =  strList[2]+'-'+mm+'-'+dd;
            //	            
            //	        }
            //	        else{
            //	            trimDOB ='';
            //	        }
            //	        alert(trimDOB);
            component.set('v.birthDate', trimDOB);
            //US2114105 
            var fromClaims = component.get("v.pageReference").state.c__fromClaimDetail;
            if (fromClaims) {
                component.set("v.Referral_Number", component.get("v.pageReference").state.c__refnum);
            }
            if (intId != undefined) {
                var childCmp = component.find("cComp");
                var memID = component.get("v.memberid");
                var GrpNum = component.get("v.grpNum");
                var bundleId = hData.benefitBundleOptionId;
                childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
            }
            helper.runReferralSearch(component, event, helper);

        }
    },

    onclick_Clear: function(component, event, helper) {
        console
        component.set("v.Referral_Number", "");
        component.set("v.Referral_Type", "None");
        component.set("v.Referral_Status", "None");
        if (component.get('v.Start_Date') == null) {
            component.set('v.Start_Date', "");
            //        	component.find("Start_Date_Auraid").value('{!v.Start_Date}');
            component.find("Start_Date_Auraid").set("v.value", "1/1/2019");
        }
        if (component.get('v.End_Date') == null) {
            component.set('v.End_Date', "");
            //        	component.find("End_Date_Auraid").value('{!v.End_Date}');
            component.find("End_Date_Auraid").set("v.value", "1/1/2019");
        }
        component.set('v.Start_Date', "");
        component.set('v.End_Date', "");
        var lgt_dt_table_ID = component.get('v.lgt_dt_table_ID');
        $(lgt_dt_table_ID + ' tbody tr').each(function() {
            $(this).removeClass('slds-hide');
        });
        component.find("End_Date_Auraid").reportValidity();
        component.find("Start_Date_Auraid").reportValidity();

    },
    onclick_Apply: function(component, event, helper) {
        var refNum = component.get('v.Referral_Number');
        var refType = component.get('v.Referral_Type');
        var refStatus = component.get('v.Referral_Status');
        var startDate = component.get('v.Start_Date');
        var endDate = component.get('v.End_Date');
        var lgt_dt_table_ID = component.get('v.lgt_dt_table_ID');
        var startDateWithSlash = '';
        var endDateWithSlash = '';
        var isError = false;
        if (startDate != null && startDate != '' && endDate != null && endDate != '') {
            if (endDate < startDate) {
                component.find("End_Date_Auraid").reportValidity();
                isError = true;
            }
        } else if (startDate == null || endDate == null) {
            isError = true;
        }
        if (!isError) {
            component.find("End_Date_Auraid").setCustomValidity("");
            if (endDate != null && endDate != '') {
                var endDateArray = endDate.split('-');
                endDateWithSlash = endDateArray[1] + '/' + endDateArray[2] + '/' + endDateArray[0];
            }
            if (startDate != null && startDate != '') {
                var startDateArray = startDate.split('-');
                startDateWithSlash = startDateArray[1] + '/' + startDateArray[2] + '/' + startDateArray[0];
            }
            $(lgt_dt_table_ID + ' tbody tr').each(function() {
                $(this).removeClass('slds-hide');
                if (refNum != null && refNum != '') {
                    if ($(this).attr('data-refNum') != refNum) {
                        $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
                            $(this).prop("checked", false);
                        });$(this).addClass('slds-hide');

                        return;
                    }
                }
                if (refType != null && refType != '' && refType != 'None') {
                    if ($(this).attr('data-refType') != refType) {
                        $(this).addClass('slds-hide');
                        $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
                            $(this).prop("checked", false);
                        });
                        return;
                    }
                }
                if (refStatus != null && refStatus != '' && refStatus != 'None') {
                    if ($(this).attr('data-refStatus') != refStatus) {
                        $(this).addClass('slds-hide');
                        $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
                            $(this).prop("checked", false);
                        });
                        return;
                    }
                }
                if (startDate != null && startDate != '') {
                    if ($(this).attr('data-refStartDate') != startDateWithSlash) {
                        $(this).addClass('slds-hide');
                        $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
                            $(this).prop("checked", false);
                        });
                        return;
                    }
                }
                if (endDate != null && endDate != '') {
                    if ($(this).attr('data-refendDate') != endDateWithSlash) {
                        $(this).addClass('slds-hide');
                        return;
                        $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
                            $(this).prop("checked", false);
                        });
                    }
                }
            });
        }
    },
    onclick_Create: function(component, event, helper) {
        console.log('Create PCP Referral clicked');
    },
    validateDates: function(component, event, helper) {
        component.find("End_Date_Auraid").reportValidity();
    },
    handle_dt_createdRow_Event: function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataStr = JSON.stringify(data);
        $(row).attr('data-refNum', data.resultreferralExternalID);
        $(row).attr('data-refType', data.resultReferaltype);
        $(row).attr('data-refStatus', data.resultReferralstatus);
        $(row).attr('data-refStartDate', data.resultStartdate);
        $(row).attr('data-refEndDate', data.resultEnddate);

        $(row).children().first().html("<a id='lnkRefNum' href='javascript:void(0);'>" + data.resultreferralExternalID + "</a>");
        $(row).children().first().on('click', function(e) {
            var pagerefaranceobj = component.get("v.pageReference");
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_ReferralDetail"
                        },
                        "state": {
                            "c__dataStr": dataStr,
                            "c__memberid": component.get("v.memberid"),
                            "c__gId": component.get("v.grpNum"),
                            "c__eid": component.get("v.eid"),
                            "c__srk": pagerefaranceobj.state.c__srk,
                            "c__userInfo": component.get("v.userInfo"),
                            "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
                            "c__int": component.get("v.int"),
                            "c__intId": component.get("v.intId"),
                            "c__gId": component.get("v.grpNum"),
                            "c__fname": pagerefaranceobj.state.c__fname,
                            "c__lname": pagerefaranceobj.state.c__lname,
                            "c__va_dob": pagerefaranceobj.state.c__va_dob,
                            "c__originatorval": pagerefaranceobj.state.c__originatorval,
                            "c__userInfo": pagerefaranceobj.state.c__userInfo,
                            "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
                            "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
                            "c__refId": data.resultreferralExternalID,
                            "c__birthDate": component.get('v.birthDate'),
                            "c__AutodocKey": component.get("v.AutodocKey")

                        }
                    }
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: "Referral - " + data.resultreferralExternalID
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


    },
    handle_dt_callback_Event: function(component, event, helper) {
          var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
       if (lgt_dt_table_ID.includes('ReferralSearchResultsDatatable_lgt_dt_table_ID')) {
          
            var Responce = event.getParam("Responce");
            console.log('response-----------------')
            console.log(Responce);
            var respObj = JSON.parse(Responce);
           if(respObj.statusCode !=null && respObj.statusCode != 200){
               //alert(respObj.statusCode);
                helper.getErrorMsg('GN', respObj.statusCode,  component,event,helper);  
           }
       }    
    },
    handle_dt_initComplete_Event: function(component, event, helper) {
        var settings = event.getParam("settings");
        console.log('#' + settings.sTableId);
        var tableId = '#' + settings.sTableId;
        component.set("v.lgt_dt_table_ID", tableId);
        setTimeout(function() {
            $("input.autodoc[type='checkbox']").click(function() {
                var lgt_dt_table_ID = component.get('v.lgt_dt_table_ID');
                $(lgt_dt_table_ID + ' tbody tr').each(function(index) {
                    if ($(this).hasClass("slds-hide")) {
                        setTimeout(function() {
                            $(this).find("input.autodoc[type='checkbox']:checked").each(function() {
	                            $(this).prop("checked", false);
	                        });
                        }.bind(this), 300);
                    }

                });
            });

        }, 30);
    }
})