({
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

                //setTimeout(function() {
                    //                                alert("====");
                   // window.lgtAutodoc.initAutodoc(tabKey);
                    //                                alert("==done?==");
                //}, 1);
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
        var docType = "u_optum_physical_health_ltr";  // Updated DOC360 class for Physical Health letter
        var tableName = "PhysicalHealthLetterTable";
        var wrapper = "v.PhysicalHealthLetterDTWrapper";
        var columns = '[{"title":"Document ID","defaultContent":"","data":"DocumentId","type":"string"},{"title":"Document Name","defaultContent":"","data":"u_tmplt_nm","type":"string"},{"title":"Created Date/Time","defaultContent":"","data":"cmis:creationDate"}]';
        helper.initDocTable(cmp, event, helper, tableAura, docType, tableName, wrapper, columns);
    }
})