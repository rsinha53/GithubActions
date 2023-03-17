({
    processDataTable: function (component, event, helper) {
        var acet_LGT = acet_LGT || {};
        var tabKey = component.get("v.AutodocKey");
        var sortedCol = '';
        var sortedDir = '';
        var sortChnged = true;
        var dt = {};
        dt.dataTableInited = false;
        var dtId = '#' + component.get("v.lgt_dt_table_ID");
        var columns = component.get("v.lgt_dt_columns");
        var pageSize = component.get("v.lgt_dt_PageSize");
        var startRecord = component.get("v.lgt_dt_StartRecord");
        var pageStartNumber = component.get("v.lgt_dt_PageNumber");
        var pagingType = 'full_numbers';
        var isSortEnabled = component.get("v.lgt_dt_SortingReq");
        var serviceName = component.get("v.lgt_dt_serviceName");
        var defaultSortBy = component.get("v.lgt_dt_SortBy");
        var defaultSortDir = component.get("v.lgt_dt_SortDir");
        var $table = $(dtId);
        var resp = [];
        var lgt_auto_doc_index = component.get("v.lgt_dt_auto_doc_clm_index");
        var lgt_dt_lock_headers = component.get("v.lgt_dt_lock_headers");
        var sort = [];
        var lgt_dt_Responce = component.get("v.lgt_dt_Responce");
        console.log("lgt_dt_serviceName----",component.get("v.lgt_dt_serviceName"));
        console.log("lgt_dt_serviceObj----",component.get("v.lgt_dt_serviceObj"));
        console.log("DOB----",component.get("v.birthDate"));
        console.log("SRK----",component.get("v.srk"));
        if (defaultSortBy != -1) {
            var sortBy = [];
            sortBy.push(defaultSortBy);
            sortBy.push(defaultSortDir);
            sort.push(sortBy);
        }

        if ($.fn.dataTable.isDataTable(dtId)) {
            $(dtId).DataTable().destroy();
            $(dtId).empty();
        }

        $table.empty();
        $table.DataTable({
            "destroy": true,
            "lengthChange": false,
            "pageLength": pageSize,
            "pagingType": pagingType,
            "processing": false,
            "serverSide": true,
            "searching": false,
            "order": sort,
            "columns": columns,
            "ajax": function (data, callback, settings) {
                helper.showspinnerhelper(component, event, helper);
                var datatable = $(dtId).dataTable();
                var action = component.get("c.getSearchResults");
                action.setParams({
                    serviceName: component.get("v.lgt_dt_serviceName"),
                    service: component.get("v.lgt_dt_serviceObj"),
                    pageNumber: parseInt(data.start / pageSize) + parseInt(pageStartNumber),
                    pageSize: component.get("v.lgt_dt_PageSize"),
                    startRecord: component.get("v.lgt_dt_serviceName")=='ACETLGT_FindDocWebservice'?((component.get("v.lgt_dt_PageSize")*((parseInt(data.start / pageSize) + parseInt(pageStartNumber))-1))+1):component.get("v.lgt_dt_StartRecord"), //Modified by Team styx Raviteja US3385722
                    firstName : component.get("v.firstName"),
                    lastName : component.get("v.lastName"),
                    birthDate : component.get("v.birthDate"),
                    srk : component.get("v.srk")
                    
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        resp = response.getReturnValue().responce;
                        component.set("v.lgt_dt_Responce", resp);
                        console.log('Provider Result'+ JSON.stringify(resp));
                        var respValue = JSON.parse(resp);
                        //US2670819 - Provider Lookup - Fixes - Sravan - Start
                        if(!$A.util.isUndefinedOrNull(resp)){
                            if($A.util.isUndefinedOrNull(respValue.Response)){
                                if(component.get("v.showProviderResultsInfo")){
                                    component.set("v.showProviderResultsInfo",false);
                                }
                                else{
                                    component.set("v.showProviderResultsInfo",true);
                                }
                            }
                        }
                        //US2670819 - Provider Lookup - Fixes - Sravan - End
                        callback(processData(data, resp, settings));
                       
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message from Data Table: " + errors[0].message);
                            }
                        }
                    }
                });
                $A.enqueueAction(action);
            },
            "createdRow": function (row, data, dataIndex) {
                helper.createdroweventhelper(component, event, helper, row, data, dataIndex, dtId);
            },
            "initComplete": function (settings, json) {
                helper.initCompleteeventhelper(component, event, helper, dtId, settings);
            },
            "drawCallback": function (settings) {
                helper.callbackeventhelper(component, event, helper, dtId, settings);
                helper.processpagenationdatahelper(component, event, helper, dtId);
                helper.autoscrollhelper(component, event, helper, dtId, lgt_dt_lock_headers);
                helper.scrolltotopeventhelper(component, event, helper, dtId);
                if (lgt_auto_doc_index) {
                    //setTimeout(function() {
                    console.log("=======1=======");
                    window.lgtAutodoc.initAutodoc(tabKey);
                    console.log("=======2=======");
                    window.lgtAutodoc.initAutodocSelections(tabKey);
                    console.log("=======3=======");
                    //}, 1);
                }
                helper.callbackeventhelper(component, event, helper, dtId, settings);
            }
        });

        function processData(d, ret, s) {
            helper.hidespinnerhelper(component, event, helper);
         var tablewrapperid ='#'+component.get("v.lgt_dt_table_ID")+'_tablewrapper';
             $(tablewrapperid).removeAttr("style");
            var selectedItems = component.get("v.selectedProviders");

            sortChnged = true;
            ret = JSON.parse(ret);

            if (ret.Response != null && ret.Response.length == 0) {
                component.set("v.lgt_disable_pagination", true);
            } else {
                component.set("v.lgt_disable_pagination", false);
            }

            if (isSortEnabled && typeof ret.Response != "undefined" && ret.Response != null && ret.Response.length > 0 && d.order.length > 0) {
                var sortBy = d.order[0].column;
                var sortByDir = d.order[0].dir;
                var sortByFieldName = d.columns[sortBy].data;
                var sortByFieldtype = s.aoColumns[sortBy].type;
                ret.Response.sort(function (a, b) {
                    var value1 = a[sortByFieldName] ? a[sortByFieldName] : '';
                    var value2 = b[sortByFieldName] ? b[sortByFieldName] : '';
                    var result;
                    if (sortByFieldtype == 'date') {
                        if (value1 == "" || value1 == null) result = -1;
                        else if (value2 == "" || value2 == null) result = 1;
                        else {
                            var a = new Date(value1);
                            var b = new Date(value2);
                            if (a < b)
                                result = -1;
                            else if (a == b)
                                result = 0;
                            else if (a > b)
                                result = 1;
                            else
                                result = 1;
                        }
                    } else if (sortByFieldtype == 'number') {
                        if (value1 == "" || value1 == null) result = -1;
                        else if (value2 == "" || value2 == null) result = 1;
                        else
                            result = Number(value1) - Number(value2);
                    } else {
                        result = value1.localeCompare(value2);
                    }
                    if (sortByDir != 'asc') {
                        result = result * -1;
                    }
                    return result;
                });
            }
            if (ret.Success) {
                debugger;
              
              //DE315145
				s.oLanguage.sEmptyTable = ret.Message;

                var newData = selectedItems.concat(ret.Response);

                if (newData != null && newData.length == 0) {
                    component.set("v.lgt_disable_pagination", true);
                } else {
                    component.set("v.lgt_disable_pagination", false);
                }

                return {
                    "draw": d.draw,
                    "start": d.start,
                    "recordsTotal": ret.totalCount,
                    "recordsFiltered": ret.totalCount,
                    "data": newData
                };
            } else {
                 s.oLanguage.sEmptyTable = ret.Message;
              //  s.oLanguage.sEmptyTable = 'No Records Found.';


                //Error Handling
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": ret.Message,
                    "mode": "pester",
                    "duration": "10000",
                    "type": "error"
                });
				
                //Conditional Error Messages
                if (selectedItems != null && selectedItems.length == 0 && component.get("v.lgt_enable_errorMsg")) {
                    toastEvent.fire();
                }

                if (selectedItems.length == 0) {
                    component.set("v.lgt_disable_pagination", true);
                } else {
                    component.set("v.lgt_disable_pagination", false);
                }

                return {
                    "draw": d.draw,
                    "start": d.start,
                    "recordsTotal": 0,
                    "recordsFiltered": 0,
                    "data": selectedItems
                };
            }
            
            

        }
    },
    processpagenationdatahelper: function (component, event, helper, tableid) {
        var table = $(tableid).DataTable();
        var info = table.page.info();
        var currentpage = info.page + 1;
        var pagelist = [];
        var i = currentpage + 1;
        while (i <= info.pages) {
            if (pagelist.length <= 9) {
                pagelist.push(i)
            }
            i++;
        }
        if (pagelist.length < 10) {
            for (var j = currentpage; j >= 1; --j) {
                if (pagelist.length <= 9 && currentpage != j) {
                    pagelist.push(j)
                }
            }
        }

        pagelist.sort(function (a, b) { return a - b });
        component.set("v.lgt_dt_pageList", pagelist);
        component.set("v.lgt_dt_totalPages", info.pages);
        component.set("v.lgt_dt_currentPageNumber", currentpage);
        var setPageNumEvent = component.getEvent("ACETLGT_DataTable_SetPageNumber_Event");
        setPageNumEvent.setParams({
            "pageNumber": component.get("v.lgt_dt_currentPageNumber")
        });
        //alert("fire here"+component.get("v.lgt_dt_currentPageNumber"));
        setPageNumEvent.fire();
    },
    showspinnerhelper: function (component, event, helper) {
        component.set("v.lgt_dt_Loadingspinner", true);

    },
    hidespinnerhelper: function (component, event, helper) {
        component.set("v.lgt_dt_Loadingspinner", false);
    },
    createdroweventhelper: function (component, event, helper, row, data, dataIndex, dtId) {
        var createdRowEvent = component.getEvent("ACETLGT_DataTable_createdRow_Event");
        createdRowEvent.setParams({
            "row": row,
            "data": data,
            "dataIndex": dataIndex,
            "lgt_dt_table_ID": dtId
        });
        $(row).addClass("slds-hint-parent");
        createdRowEvent.fire();
    },
    callbackeventhelper: function (component, event, helper, dtId, settings) {
        var tableId = "#" + settings.sTableId;
        $(tableId).wrap('<div id="dt_lgt_table_wrap"  ></div>');
        component.set("v.lgt_dt_entries_info", $(tableId + '_info').text());
        $(tableId + '_paginate').css("display", "none");
        $(tableId + '_info').css("display", "none");
        var drawCallbackEvent = component.getEvent("ACETLGT_DataTable_Callback_Event");
        drawCallbackEvent.setParams({
            "lgt_dt_table_ID": dtId,
            "Responce": component.get("v.lgt_dt_Responce"),
            "settings": settings,
            "comp": component
        });
        drawCallbackEvent.fire();
        var setPageNumEvent = component.getEvent("ACETLGT_DataTable_SetPageNumber_Event");
        setPageNumEvent.setParams({
            "pageNumber": component.get("v.lgt_dt_currentPageNumber")
        });
        setPageNumEvent.fire();

        var d = new Date();
        console.log('new date created callback ==>' + d);
    },
    autoscrollhelper: function (component, event, helper, dtId, lgt_dt_lock_headers) {
        var tableheight = $(dtId).height();
        var lgt_dt_lock_style = 'height:' + lgt_dt_lock_headers + 'px;overflow-y:auto;'
        if (lgt_dt_lock_headers < tableheight) {
            var divelement = $(dtId).parent();
            //     var divelement = $("#dt_lgt_table_wrap");
            divelement.attr("style", lgt_dt_lock_style);
            divelement.scroll(function () {
                let scrollTopval = this.scrollTop - 2;
                var translate = "translate(0," + scrollTopval + "px)";
                const allTh = this.querySelectorAll("th");
                for (let i = 0; i < allTh.length; i++) {
                    allTh[i].style.transform = translate;
                    allTh[i].style.zIndex = "1";
                    // allTh[i].style.setProperty("background-color", "red","important");
                }
            });
        }
    },
    scrolltotopeventhelper: function (component, event, helper, dtId) {
        var divelement = $(dtId).parent();
        //     var divelement = $("#dt_lgt_table_wrap");
        if (divelement) {
            console.log('scroll');
            divelement.animate({
                scrollTop: 0
            }, "fast");

        }
    },
    initCompleteeventhelper: function (component, event, helper, dtId, settings) {
        var initComplete_Event = component.getEvent("ACETLGT_DataTable_initComplete_Event");
        initComplete_Event.setParams({
            "settings": settings
        });
        initComplete_Event.fire();
    }
})