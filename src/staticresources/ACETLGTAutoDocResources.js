var acet = acet || {};
var globalMap = new Map();
(function (w) {

    var saveAutodocSelectionsCount = 0;
    acet.autodoc = {};
    acet.autodoc.additionalInfo = '';
    acet.autodoc.selectedItems = [];
    var identifierList = [];
    var uniqueIdentifierList = [];
    var adIdentifierList = [];
    var adResolvedList = [];
    var $coverageDateList = [];
    var $sectionFinal = '';
    var $globalAccumsList = [];
    var removeDuplicatesOnCaseList = [];
    var multipleTableRowList = [];
    var multipleTableRowFinal = [];
    var $removeDuplicatesOnCaseMap = new Map();
    var $removeDuplicatesOnCaseObject = {}; //Using it to enable entries() in IE
    var autodocedRows = [];
    var globalVar = '';
    var globalSectionalVar = [];
    var tableHeaderMap = {}; // added new for authorisation
    var rowAuthorizationList = {}; // added new for authorization
    var $paginationTableMap = new Map();
    var $paginationMultipleTableMap = new Map();
    var $paginationDataMap = new Map();
    var $paginationMultipleTableKeyMap = new Map();

    w.lgtAutodoc = {
        "initAutodoc": function (sf_id) {
            var $docsection;
            var $contextvar = "#" + sf_id;
            console.log('-----autodoc----1------' + $contextvar);
            //only autodoc the specified section if sf_id is provided, otherwise autodoc all sections under the page
            if (sf_id) {
                $docsection = $("[data-auto-doc='true']", $($contextvar));

                $docsection.each(function () {
                    console.log('-----autodoc----2------' + $(this).find(".accordionTables").html());
                    var refreshBoxes = $(this).attr("data-auto-doc-refresh");
                    if ($(this).find(".autodocPagination").html() == undefined && $(this).find(".accordionTables").html() == undefined && $(this).find(".providerFeeScheduleTables").html() == undefined) {
                        console.log('-----autodoc----0.2------' + $(this).attr('data-auto-doc'));
                        $(this).attr('data-auto-doc', 'auto');
                    }
                    if(refreshBoxes == "true"){
                        $(this).attr('data-auto-doc', 'true');
                    }

                });

            }
            if ($docsection != undefined) {
                console.log('-----autodoc----3------' + $docsection.html());
                $docsection.each(function () {
                    //remove any autodoc tags added before
                    if($(this).find("table").html() != undefined && !$(this).hasClass("SAESection") ){ // US1918695
                        $(this).find(".autodoc:checkbox").each(function() {
                            console.log('-----autodoc----0.3------'+$(this).html());
                            //if($(this).find("input[type='checkbox']").html() != undefined)
                                $(this).parent().remove();
                        });
                    }else{
                        $(this).find(".autodoc:checkbox").each(function() {
                            console.log('-----autodoc----0.3------'+$(this).html());
                            //if($(this).find("input[type='checkbox']").html() != undefined)
                                $(this).remove();
                        });
                    }

                    //add a checkbox right of the label for any field under page block section
                    if (!($(this).attr("data-auto-doc-header-only") == 'true')) {
                        if ($(this).find("p.autodocFieldName").html() != undefined || $(this).find("p.slds-form-element__label").html() != undefined) { // SAE changed - mar 25
                            // SAE changed - mar 25
                            $(this).find("p.autodocFieldName,p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');

                            //$(this).find("div.slds-form-element__static").css( "margin-left", "16px" );
                            $(this).find(".autodocValue,.valueCls").css("margin-left", "16px"); // SAE changed - mar 25
                            //align label and checkbox added .
                            //$(this).find(".slds-box").find("p.autodocValue").css("vertical-align", "middle");

                            //Preselect checkboxes for SAE business flow - Sanka US2138277
                            $(this).find(".preselect").each(function () {
                                $(this).find("input[type='checkbox'].autodoc").prop('checked', true).prop("disabled", true);
                            });
                            
                            // Preselect checkboxes for SAE business flow - Not Disabled - Kavinda US2382581
                            $(this).find(".preselect-enable").each(function () {
                                $(this).find("input[type='checkbox'].autodoc").prop('checked', true);
                            });
                            
                            //defaultSelect checkboxes without disabling for SAE business flow - Thanish US2421967
                            $(this).find(".defaultSelected").each(function () {
                                $(this).find("input[type='checkbox'].autodoc").prop('checked', true);
                            });

                        } else {
                            if($(this).find("table").html() != undefined){
                                $(this).find(".autodoc:checkbox").each(function() {
                                    console.log('-----autodoc----0.3------'+$(this).html());
                                    //if($(this).find("input[type='checkbox']").html() != undefined)
                                        $(this).parent().remove();
                                });
                            }else{
                                $(this).find(".autodoc:checkbox").each(function() {
                                    console.log('-----autodoc----0.3------'+$(this).html());
                                    //if($(this).find("input[type='checkbox']").html() != undefined)
                                        $(this).remove();
                                });
                            }
                            //Added SAE - Else because of p.autodocFieldName
                            $(this).find("p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');



                            $(this).find(".valueCls").css("margin-left", "16px");
                        }
                    }

                    //add a checkbox in column header in first column
                    //.slds-table is for standard page block table, .auto-doc-list is for acetdatatable component
                    if (!($(this).attr("auto-doc-header-only") == 'true')) {

                        $(this).find(".autodocPagination, .auto-doc-list").children('thead').children('tr').find('th').each(function() {

                            if($(this).hasClass('sorting') == false && $(this).hasClass('sorting_desc') == false && $(this).hasClass('sorting_asc') == false){
                                //Commenting out based on the combined discussion with SAE and Metalica
                                //$(this).remove();
                            }
                        });

                        var refreshTableHTML = $(this).find(".slds-table, .autodocPagination, .auto-doc-list").find('tbody').html();
                        //console.log('-----autodoc----004------'+$refreshTableHTML.children('tr').html());
                        var $refreshTableDOM = $("<div></div>").prepend(refreshTableHTML);
                        console.log('-----autodoc----004------'+$refreshTableDOM.children('tr').html());
                        var $tempTableDOM = $("<div></div>").append($refreshTableDOM.find('tr'));
                        console.log('-----autodoc----004------'+$tempTableDOM.html());
                        console.log('-----autodoc----004------'+$tempTableDOM.find('tr').length);
                        var rowCount = $(this).find(".slds-table, .autodocPagination, .auto-doc-list").find('tbody').children().length;
                        console.log('-----autodoc----04------' + rowCount);
                        if (rowCount <= 26 && rowCount != 0) {
                            console.log('-----autodoc----4------' + $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('thead').children('tr').html());
                            console.log('-----autodoc----4------' + $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').html());
                            $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc" style="width:30px"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');

                            $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc" style="width:30px"><input type="checkbox" class="autodoc"/></td>');
                        } else if (rowCount > 26) {
                            console.log('-----autodoc----5------' + $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('thead').children('tr').html());
                            console.log('-----autodoc----5------'+$(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').html());
                            $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc" style="width:30px"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                            $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc" style="width:30px"><input type="checkbox" class="autodoc"/></td>');
                        } else if(rowCount == 0 && $tempTableDOM.find('td').length > 0){
                            console.log('-----autodoc----6------'+$tempTableDOM.children('tr').html());
                            $(this).find(".slds-table, .autodocPagination").children('thead').children('tr').prepend('<th class="autodoc" style="width:30px"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                            $tempTableDOM.children('tr').prepend('<td class="autodoc" style="width:30px"><input type="checkbox" class="autodoc"/></td>');
                            $(this).find(".slds-table, .autodocPagination").find('tbody').empty();
                            console.log('-----autodoc----6------'+$(this).find(".slds-table, .autodocPagination").find('tbody').html());
                            $(this).find(".slds-table, .autodocPagination").find('tbody').append($tempTableDOM.html());
                        }

                        //Added for SAE - Default row ticking NEEDS TO BE REVIEWED
                        $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').find(".slds-hint-parent").find("input[type='checkbox'].autodoc").prop("checked", false);
                        $(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').find(".highlight").find("input[type='checkbox'].autodoc").prop("checked", true);
						//Added for SAE - To hide the checkbox in a table - Sravan - US2658951
						$(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').find(".hideCheckBox").find("input[type='checkbox'].autodoc").prop("checked",false).css("display", "none");

                    }
                    if ($(this).find(".autodocPreselect").html() != undefined) {
                          //$(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc slds-hide"><input type="checkbox" class="autodoc "/></td>');
                          $(this).find("input[type='checkbox'].autodoc").css("display", "none");
                          $(this).find("input[type='checkbox'].autodoc").prop("style", "display:none");
                          $(this).find("input[type='checkbox'].autodoc").prop("checked", true);


                    }

                    var hasTitle = false;
                    if ($(this).hasClass('titleCheckBox')) {
                        //For SAE Change the position of the checkbox from right to left - Sanka US2138277
                        //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                        $(this).find(".slds-text-heading_small").prepend('<input type="checkbox" class="autodoc" style="margin-right: 5px;"/>');
                        hasTitle = true;
                    } else {
                        //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                        $(this).find(".slds-text-heading_small").append('<input type="checkbox" class="autodoc" style="margin-left: 5px;"/>');
                    }

                    $(this).find(".slds-text-heading_small").find("input[type='checkbox']").change(function () {
                        console.log('------autodoc---7------');
                        $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));

                        //Added SAE - Sanka
                        $(this).parent().parent().find(".preselect").find("input[type='checkbox'].autodoc").prop("checked", true);

                        //Additional Details Collapse - SAE - US2619021
                        if($(this).parent().hasClass('adetail')){
                            $(this).parent().parent().parent().parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                        }


                        //DE309309
                        if (hasTitle == false) {
                        $(this).parent().parent().find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
						$(this).parent().parent().parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                        $(this).parent().parent().parent().parent().find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                        }
                    });

                    //enable check-all/uncheck all function in table
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('thead').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                        console.log('-----autodoc----8------');
                        $(this).parents(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                    });
                });

            }
            //resolved checkboxes for case items
            var $caseItemSection;
            if (sf_id) {
                $caseItemSection = $("[data-auto-doc-case-items='true']", $($contextvar));

            }
            if ($caseItemSection != undefined) {
                $caseItemSection.each(function () {
                    //remove any case item resolved tags added before
                    if($(this).attr('data-auto-doc-autosave') != "auto"){
                    $(this).find(".autodoc-case-item-resolved").remove();

                    console.log('-----autodoc----13------');

                    //Hide Resolve check-boxes for SAE tables - Sanka US2138277
                    if (!$(this).hasClass('noResolveCheckBox')) {
                        //add a resolved header in column header in last column
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').append('<th class="autodoc-case-item-resolved">Resolved</th>');
                        //add resolved checkboxes for all rows in last column
                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').append('<td class="autodoc-case-item-resolved"><input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px"/></td>');
                    }

                    //add a resolved header in column header in last column
                    //$(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('thead').children('tr').append('<th class="autodoc-case-item-resolved">Resolved</th>');
                    //add resolved checkboxes for all rows in last column
                    //$(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').append('<td class="autodoc-case-item-resolved"><input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px"/></td>');
                    console.log("===CASE-ITEM===>>" + $(this).html());
                    //if autodoc is on by default, check on resolved checkbox by default (usually on sub tab page B)
                        if ($(this).find(".autodocPreselect").html() != undefined) {
                        //$(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc slds-hide"><input type="checkbox" class="autodoc "/></td>');
                        console.log("===INPUT CHECKBOX====>>" + $(this).find("input[type='checkbox'].autodoc").html());
                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", true);
                        $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                        $(this).find("input[type='checkbox'].autodoc").prop("style", "display:none");

                    }
                    console.log('-----autodoc----14------');
                    //sync checked status(case item resolved) with status of autodoc checkbox
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                        $(this).parent().parent().find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", $(this).prop("checked"));
                    });
                    console.log('-----autodoc----15------');
                    //check on autodoc checkbox if item is marked as resolved
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').find("input[type='checkbox'].autodoc-case-item-resolved").change(function () {
                        if ($(this).prop("checked")) {
                            $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                        }
                    });

                    if ($(this).find(".autodocHideResolved").html() != undefined) {
                          //$(this).find(".slds-table,.autodocPagination, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc slds-hide"><input type="checkbox" class="autodoc "/></td>');
                          $(this).find("input[type='checkbox'].autodoc-case-item-resolved").css("display", "none");
                          $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("style", "display:none");
                          $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", true);


                    }
                    }
                });
            }
        },

        "saveStateAutodocOnSearch": function () {
            console.log('----autodoc---99------');
            globalSectionalVar = [];
            console.log(globalSectionalVar);
            if (localStorage.getItem("localAccumsData") != null) {
                var tempVar = (localStorage.getItem("localAccumsData")).split("|");
                if (!globalMap.has(tempVar[0])) {
                    globalMap[tempVar[0]] = tempVar[1];
                } else {
                    delete globalMap[tempVar[0]];
                    globalMap[tempVar[0]] = tempVar[1];
                }
            }
            $globalAccumsList = Object.keys(globalMap).map(function (e) {
                return globalMap[e]
            });
            localStorage.setItem("globalAccumsData", GetUnique($globalAccumsList));
            globalSectionalVar.push(localStorage.getItem("globalAccumsData"));
            //localStorage.setItem("globalAccumsDataFinal",GetUnique(globalSectionalVar));
            console.log(globalSectionalVar);
            localStorage.removeItem("localAccumsData");

        },

        "saveAutodoc": function (pagefeature, pageid) {
            console.log('----autodoc---91------' + localStorage.getItem("rowCheckHold"));
            var pageidClone = pageid;
            var $autodoc = $("<div></div>");

            var $autodocMap = new Map();
            multipleTableRowFinal = [];
            if (localStorage.getItem("rowCheckHold") != undefined)
                identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
            if (identifierList.length > 0) {
                console.log('----autodoc---100.05------');
                for (var i = 0; i < identifierList.length; i++) {

                    // US2271237: Kavinda (Aerosmith)
                    var identifier = $.parseHTML(identifierList[i]);
                    for (var j = 0; j < identifier.length; j++) {
                       var pfeature = $(identifier[j]).attr('data-auto-doc-feature');
                        if (pfeature != undefined && pagefeature == pfeature) {
                            var htmlparsor = $(identifier[j]).html();
                            $autodoc.append('<div class="slds-box" >'+htmlparsor+'</div>');
                        }
                    }

                    // US2271237: Kavinda (Aerosmith)
                    // $autodoc.append(identifierList[i]);

                    //console.log('----autodoc---100.05.1------'+$autodoc);

                }
            }

            var multiplePagesCheck = $("[data-auto-doc-multiple-pages='true']", $('#' + pageid));
            //alert('-----MP-1----'+multiplePagesCheck.html());
            if (multiplePagesCheck.html() != undefined) {
                if (pageid != undefined && pageid != null) {
                    pageid = "." + pageid;
                    var pageidTemp = pageid;
                    console.log('--1--autodoc---100.05--LEN----');
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        console.log('----autodoc---100.05.1----' + pagefeature);
                        var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                        var $clonedSec = $(this);
                        console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature'));
                        console.log('----autodoc---91.0------>' + pagefeature);
                        console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                              $source.find(".planbenifitstable").find("tbody").find("tr.slds-hide").remove();
                             $source.find(".planbenifitstable").find("tbody").find("tr").find("td.hidetdcls").remove();

                            var $section = $(this).clone();
                            console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                        $section.find("input,select,textarea").each(function() {
                            $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                            console.log('----autodoc---91.3------');
                        });
                      }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                console.log('----autodoc---91.31.2------');
                                var $table = $(this).clone();
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                    console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                                console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {

                                var $currTableId ;
                                if( $table.find('.dataTables_wrapper').html() != undefined)
                                $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');

                                var $paginationTableData = JSON.stringify($paginationMultipleTableMap.get($currTableId));
                                if($(this).find("input:checkbox:checked").length > 0 || ($paginationTableData != undefined && $paginationTableData.length > 0) ){
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                  }else if($table.find(".autodocPagination").length > 0 || ($paginationTableData != undefined && $paginationTableData.length > 0)){
                                            console.log("-----currTableId=======>" + $table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');


                                            $table.find(".autodocPagination").find("thead").find("th").each(function () {
                                                $(this).css("transform", "");
                                            });
                                            $table.find(".autodocPagination").find("tbody").empty();

                                            var IdList;
                                            if (uniqueIds != undefined && uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");
                                      else
                                          IdList.push(uniqueIds);

                                            console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tableValueList = $paginationMultipleTableMap.get($currTableId).values();
                                                console.log("============tableValueList=======>"+tableValueList.length);
                                                for (var i=0;i < tableValueList.length; i++) {
                                                    console.log("============value=======>"+tableValueList[i]);
                                                    var clonedItem = tableValueList[i];
                                                    autoDocData.append(clonedItem);
                                                }
                                                **/
                                                /**for (var value of $paginationMultipleTableMap.get($currTableId).values()) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                    console.log("============value=======>" + value);
                                                    console.log("============value=======>" + $paginationMultipleTableMap.get($currTableId).values()[value]);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);


                                                var autoDocRows = $("<tr></tr>");
                                                uniqueIdentifierList = [];
                                                autoDocData.children("tr").each(function () {
                                                    var uniqueKey;
                                                    console.log("============OUT=======>" + $(this).length);
                                                    if ($(this).html() != '') {
                                                        if (IdList.length > 0) {
                                                            for (var i = 0; i < IdList.length; i++) {
                                                                var keyStr = "td:eq(" + IdList[i] + ")";
                                                                if (uniqueKey != undefined) {
                                                                    uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                                } else {
                                                                    uniqueKey = $(this).find(keyStr).text();
                                                                }
                                                            }
                                                        }
                                                        console.log("============UNIQUE Value=======>" + uniqueKey);
                                                        if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                            console.log("============In 1=======>");
                                                            autoDocRows.append($(this));
                                                            console.log("============In 2=======>");
                                                            uniqueIdentifierList.push(uniqueKey);
                                                            console.log("============In 3=======>");
                                                        }
                                                        console.log("============UNIQUE uniqueIdentifierList=======>" + uniqueIdentifierList);
                                                    }
                                                });
                                                console.log("========>>>>>" + autoDocRows.html());
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                if (autoDocRows.html() == undefined || autoDocRows.html().length == 0 || autoDocRows.html() == '') {
                                                    console.log("====IN====>>>>>");
                                                    $table.empty();
                                                }

                                                $section = $table;
                                            } else {
                                                console.log("====Make it blank====>>>>>");
                                                $table.empty();
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                            $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                        console.log('----autodoc---91.92.2------'+ $section.html());

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                        console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                            console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                            console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    console.log('----autodoc---100.1------');
                                    console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }
                            /**
                      if (authorizationFinal != null) {
                          console.log('----autodoc---100.3------');
                          var sectionName = $section.attr("data-auto-doc-section-key");
                          var iterateMap = Object.entries(authorizationFinal);
                          for (var i = 0; i < iterateMap.length; i++) {
                              for (var j = 0; j < iterateMap[i].length;) {
                                  if (iterateMap[i][j] == sectionName) {
                                      $section.find(".slds-box").remove();
                                      console.log($section);
                                      $section.append(iterateMap[i][++j]);
                                  }
                                  j++;
                              }
                              console.log($section);

                          }

                      }
                      **/


                        //$section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {


                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    console.log('----autodoc---100.4.0001------>');
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (localStorage.getItem("rowCheckHold") == undefined || !(localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0)) {
                                    console.log('----autodoc---100.4.001------>');
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }

                                //SAE Fix - incorrect div position - 4th Mar 2020
                                var $bodyDiv = $section.find(".additionalDetail");
                                if ($bodyDiv != undefined) {
                                    $section.find(".additionalDetail").remove();
                                    $section.append($bodyDiv);
                                }

                                $section.append("<br/>");
                                mapval = $autodoc.append($section);

                                console.log('----autodoc---100.4.1------>' + mapKey);
                                console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });

                } else {
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        console.log('----autodoc---100.05.1----' + pagefeature);

                        console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                            console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                        $section.find("input,select,textarea").each(function() {
                            $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                            console.log('----autodoc---91.3------');
                        });
                      }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                console.log('----autodoc---91.31.2------');
                                var $table = $(this);
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                    console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                    console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                                console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                    console.log('----autodoc---91.31.31------');
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            //console.log("-----currTableId=======>"+$table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                            //console.log("============$currTableId=======>"+$currTableId);
                                            $table.find(".autodocPagination").find("tbody").empty();
                                            var uniqueIds = $table.find(".autodocPagination").attr("data-auto-doc-uniqueids");
                                            var IdList;
                                            if (uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                            console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tabledata = $paginationMultipleTableMap.get($currTableId).values();
                                                for (var i=0 ; i<tabledata.length; i++) {
                                                  console.log("============value=======>"+tabledata[i]);
                                                  var clonedItem = tabledata[i];
                                                  autoDocData.append(clonedItem);
                                                }
                                                **/
                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                                var uniqueKey;
                                                var autoDocRows = $("<tr></tr>");
                                                $table.find(".autodocPagination").children('tbody').children('tr').each(function () {
                                                    if (IdList.length > 0) {
                                                        for (var i = 0; i < IdList.length; i++) {
                                                            var keyStr = "td:eq(" + IdList[i] + ")";
                                                            if (uniqueKey != undefined) {
                                                                uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                            } else {
                                                                uniqueKey = $(this).find(keyStr).text();
                                                            }
                                                        }
                                                    }
                                                });

                                                autoDocData.find("tr").each(function () {
                                                    console.log("============UNIQUE Value=======>" + uniqueKey);
                                                    if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                        autoDocRows.append(clonedItem);
                                                        uniqueIdentifierList.push(uniqueKey);
                                                    }
                                                });
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                $section = $table;
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                        $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });
                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                        console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                            console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                            console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    console.log('----autodoc---100.1------');
                                    console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }
                            /**
                      if (authorizationFinal != null) {
                          console.log('----autodoc---100.3------');
                          var sectionName = $section.attr("data-auto-doc-section-key");
                          var iterateMap = Object.entries(authorizationFinal);
                          for (var i = 0; i < iterateMap.length; i++) {
                              for (var j = 0; j < iterateMap[i].length;) {
                                  if (iterateMap[i][j] == sectionName) {
                                      $section.find(".slds-box").remove();
                                      console.log($section);
                                      $section.append(iterateMap[i][++j]);
                                  }
                                  j++;
                              }
                              console.log($section);

                          }

                      }
                      **/


                        //$section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                                //var $chks1 = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                //console.log('----autodoc---91.72------'+ $table.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);

                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (localStorage.getItem("rowCheckHold") == undefined || !(localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0)) {
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }
                                mapval = $autodoc.append($section);

                                console.log('----autodoc---100.4.1------>' + mapKey);
                                console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });
                }
            } else {
                if (pageid != undefined && pageid != null) {
                    pageid = "#" + pageid;
                    var pageidTemp = pageid;
                    console.log('--1--autodoc---100.05--LEN----');
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        console.log('----autodoc---100.05.1----' + pagefeature);
                        var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                        var $clonedSec = $(this);
                        console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                            console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                    $section.find("input,select,textarea").each(function() {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                        console.log('----autodoc---91.3------');
                    });
                  }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                console.log('----autodoc---91.31.2------');
                                //Sanka - Added SAE
                                var $table = $(this).clone();
                                //var $table = $(this);

                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                    console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName, p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                    console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                                console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                    console.log('----autodoc---91.31.31------' + $(this).find("input:checkbox:checked").length);
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            console.log("-----currTableId=======>" + $table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');

                                            $table.find(".autodocPagination").find("thead").find("th").each(function () {
                                                $(this).css("transform", "");
                                            });
                                            $table.find(".autodocPagination").find("tbody").empty();

                                            var IdList;
                                            if (uniqueIds != undefined && uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                            console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tableValueList = $paginationMultipleTableMap.get($currTableId).values();
                                                console.log("============tableValueList=======>"+tableValueList.length);
                                                for (var i=0;i < tableValueList.length; i++) {
                                                    console.log("============value=======>"+tableValueList[i]);
                                                    var clonedItem = tableValueList[i];
                                                    autoDocData.append(clonedItem);
                                                }
                                                **/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

												/**for (var value of $paginationMultipleTableMap.get($currTableId).values()) {
                                                      console.log("============value=======>"+value);
                                                      var clonedItem = value;
                                                      autoDocData.append(clonedItem);
                                                  }**/

                                                var autoDocRows = $("<tr></tr>");
                                                uniqueIdentifierList = [];
                                                autoDocData.children("tr").each(function () {
                                                    var uniqueKey;
                                                    console.log("============OUT=======>" + $(this).length);
                                                    if ($(this).html() != '') {
                                                        if (IdList.length > 0) {
                                                            for (var i = 0; i < IdList.length; i++) {
                                                                var keyStr = "td:eq(" + IdList[i] + ")";
                                                                if (uniqueKey != undefined) {
                                                                    uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                                } else {
                                                                    uniqueKey = $(this).find(keyStr).text();
                                                                }
                                                            }
                                                        }
                                                        console.log("============UNIQUE Value=======>" + uniqueKey);
                                                        if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                            console.log("============In 1=======>");
                                                            autoDocRows.append($(this));
                                                            console.log("============In 2=======>");
                                                            uniqueIdentifierList.push(uniqueKey);
                                                            console.log("============In 3=======>");
                                                        }
                                                        console.log("============UNIQUE uniqueIdentifierList=======>" + uniqueIdentifierList);
                                                    }
                                                });
                                                console.log("========>>>>>" + autoDocRows.html());
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                if (autoDocRows.html() == undefined || autoDocRows.html().length == 0 || autoDocRows.html() == '') {
                                                    console.log("====IN====>>>>>");
                                                    $table.empty();
                                                }

                                                $section = $table;
                                            } else {
                                                console.log("====Make it blank====>>>>>");
                                                $table.empty();
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //Hide duplicate headers when creating document - Sanka US2038277 NEEDS TO BE REVIEWED
                            $section.find(".slds-text-heading_small").hide();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                    $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                        console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                            console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                            console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    console.log('----autodoc---100.1------');
                                    console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }
                            /**
                  if (authorizationFinal != null) {
                      console.log('----autodoc---100.3------');
                      var sectionName = $section.attr("data-auto-doc-section-key");
                      var iterateMap = Object.entries(authorizationFinal);
                      for (var i = 0; i < iterateMap.length; i++) {
                          for (var j = 0; j < iterateMap[i].length;) {
                              if (iterateMap[i][j] == sectionName) {
                                  $section.find(".slds-box").remove();
                                  console.log($section);
                                  $section.append(iterateMap[i][++j]);
                              }
                              j++;
                          }
                          console.log($section);

                      }

                  }
                  **/


                    //$section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName, p.slds-form-element__label").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {


                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    console.log('----autodoc---100.4.0001------>');
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (localStorage.getItem("rowCheckHold") == undefined || !(localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0)) {
                                    console.log('----autodoc---100.4.001------>');
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }

                                //SAE Fix - incorrect div position
                                var $bodyDiv = $section.find(".additionalDetail");
                                if ($bodyDiv != undefined) {
                                    $section.find(".additionalDetail").remove();
                                    $section.append($bodyDiv);
                                }

                                //console.log($section.html());


                                //Prepend section on top - Sanka US2038277
                                var selected = $source.find(".autodocPagination").find('input:checkbox:checked').length;

                                var hasPagination = $source.attr("data-auto-doc-pagination");
                                // console.log(hasPagination);

                                if (selected <= 0 && hasPagination) {
                                    $section.addClass('noitemsSelected');
                                }

                                if ($source.hasClass('prependSection')) {
                                    mapval = $autodoc.prepend($section);
                                    //autodocPrepended = true;
                                } else {
                                    mapval = $autodoc.append($section);
                                }

                                //mapval = $autodoc.prepend($section);

                                if (selected <= 0 && hasPagination) {
                                    //mapval.find(".selectedSection").remove();
                                    mapval.find(".noitemsSelected").remove();
                                }

                                //mapval = $autodoc.append($section);

                                console.log('----autodoc---100.4.1------>' + mapKey);
                                console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });

                } else {
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        console.log('----autodoc---100.05.1----' + pagefeature);

                        console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                            console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                        $section.find("input,select,textarea").each(function() {
                            $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                            console.log('----autodoc---91.3------');
                        });
                      }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                console.log('----autodoc---91.31.2------');
                                var $table = $(this);
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                    console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName, p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                    console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                                console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                    console.log('----autodoc---91.31.31------');
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            //console.log("-----currTableId=======>"+$table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                            //console.log("============$currTableId=======>"+$currTableId);
                                            $table.find(".autodocPagination").find("tbody").empty();
                                            var uniqueIds = $table.find(".autodocPagination").attr("data-auto-doc-uniqueids");
                                            var IdList;
                                            if (uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                            console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tabledata = $paginationMultipleTableMap.get($currTableId).values();
                                                for (var i=0 ; i<tabledata.length; i++) {
                                                  console.log("============value=======>"+tabledata[i]);
                                                  var clonedItem = tabledata[i];
                                                  autoDocData.append(clonedItem);
                                                }
                                                **/
                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                                var uniqueKey;
                                                var autoDocRows = $("<tr></tr>");
                                                $table.find(".autodocPagination").children('tbody').children('tr').each(function () {
                                                    if (IdList.length > 0) {
                                                        for (var i = 0; i < IdList.length; i++) {
                                                            var keyStr = "td:eq(" + IdList[i] + ")";
                                                            if (uniqueKey != undefined) {
                                                                uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                            } else {
                                                                uniqueKey = $(this).find(keyStr).text();
                                                            }
                                                        }
                                                    }
                                                });

                                                autoDocData.find("tr").each(function () {
                                                    console.log("============UNIQUE Value=======>" + uniqueKey);
                                                    if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                        autoDocRows.append(clonedItem);
                                                        uniqueIdentifierList.push(uniqueKey);
                                                    }
                                                });
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                $section = $table;
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                        $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                        console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                            console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                            console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    console.log('----autodoc---100.1------');
                                    console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }
                            /**
                      if (authorizationFinal != null) {
                          console.log('----autodoc---100.3------');
                          var sectionName = $section.attr("data-auto-doc-section-key");
                          var iterateMap = Object.entries(authorizationFinal);
                          for (var i = 0; i < iterateMap.length; i++) {
                              for (var j = 0; j < iterateMap[i].length;) {
                                  if (iterateMap[i][j] == sectionName) {
                                      $section.find(".slds-box").remove();
                                      console.log($section);
                                      $section.append(iterateMap[i][++j]);
                                  }
                                  j++;
                              }
                              console.log($section);

                          }

                      }
                      **/


                        //$section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName, p.slds-form-element__label").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                                //var $chks1 = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                //console.log('----autodoc---91.72------'+ $table.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);

                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (localStorage.getItem("rowCheckHold") == undefined || !(localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0)) {
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }
                                mapval = $autodoc.append($section);

                                console.log('----autodoc---100.4.1------>' + mapKey);
                                console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });
                }
            }
            console.log('----autodoc---100.005------' + $autodoc.html());
            //append additonal autodoc
            if (acet.autodoc.additionalInfo) {
                $autodoc.append(acet.autodoc.additionalInfo);
                console.log('----autodoc---100.5------');
            }

            var $additionalAccumsSection = '';
            $autodoc.append("<br/><br/>");

            $paginationTableMap = new Map();
            $paginationDataMap = new Map();
            $paginationMultipleTableMap = new Map();
            $paginationMultipleTableKeyMap = new Map();
            adIdentifierList = [];
            adResolvedList = [];

            console.log('====0====>>' + pagefeature);
            if ($autodocMap != undefined && $autodocMap.get(pagefeature) != undefined) {
                var $finalHTML = $autodocMap.get(pagefeature);
                if (($finalHTML.find(".autodocTableView").html() != undefined || $finalHTML.find(".autodocPagination").html() != undefined) && $finalHTML.find(".autodocHighlightsPanel") != undefined) {
                    console.log("----IN----" + $finalHTML.find(".autodocHighlightsPanel").html());
                    var $hpDOM = $finalHTML.find(".autodocHighlightsPanel");
                    console.log("----IN----" + $hpDOM.html());
                    $finalHTML.find(".autodocHighlightsPanel").remove();
                    if($finalHTML.find(".benefitAccordionTable").html() != undefined){
                        var $benefitDOM = $finalHTML.find(".benefitAccordionTable").parent();
                        $finalHTML.find(".benefitAccordionTable").parent().remove();
                    	$finalHTML.prepend($benefitDOM);
                    }
                    console.log("----IN----" + $finalHTML.html());
                    $finalHTML.prepend($hpDOM);
                    console.log("----IN----" + $finalHTML.html());

                    //Added for SAE - Fixing padding issue
					$finalHTML.find(".autodocTableView").addClass("slds-box slds-card");
					$finalHTML.find(".benefitAccordionTable").wrap('<div class="slds-scrollable_x slds-box slds-card"></div>');
                }
				$finalHTML.find('.autodocTableView').each(function(){
                    //console.log("=======autoDocTableView TABLE======"+$(this).find('table').length);
                    if($(this).find('table').length == 0 ){
                        $(this).remove();
                    }else if($(this).find('table').length > 0 && $(this).find('table').find('tbody').length == 0){
                        $(this).remove();
                    }
                });
                var autoSavedList= $("<div></div>");
                if($(this).find("table").html() != undefined){
                    $(this).find(".autodoc:checkbox").each(function() {
                        console.log('-----autodoc----0.3------'+$(this).html());
                        //if($(this).find("input[type='checkbox']").html() != undefined)
                        $(this).parent().remove();
                    });
                }else{
                    $(this).find(".autodoc:checkbox").each(function() {
                        console.log('-----autodoc----0.3------'+$(this).html());
                        //if($(this).find("input[type='checkbox']").html() != undefined)
                        $(this).remove();
                    });
                }
                var firstDiv = false;
                if($finalHTML.find('.coverageDetails').length < 2  && $finalHTML.find('.eligibilityDetails').length < 2 && $finalHTML.find('.deductibles').length < 2){
                    $finalHTML.find('.autodocHighlightsPanel').each(function(){
                        console.log("=======autoDocTableView TABLE===1===");

                        if(firstDiv){
                            $(this).remove();
                        }
                        firstDiv = true;
                    });
                }else if($finalHTML.find('.coverageDetails').length > 1 || $finalHTML.find('.eligibilityDetails').length > 1 || $finalHTML.find('.deductibles').length > 1){
                    var count =0;
                    $finalHTML.find('.autodocHighlightsPanel').each(function(){
                        console.log("=======autoDocTableView TABLE===2===");
                        count = count +1;
                        if(count > 2){
                            $(this).remove();
                        }

                    });
                }
                $finalHTML.find(".autodoc:checkbox").each(function() {
                    console.log('-----autodoc----IN CLEANING------'+$(this).html());
                    //if($(this).find("input[type='checkbox']").html() != undefined)
                    $(this).remove();
                });
                if(autoSavedList.length > 0)
                    $finalHTML.append(autoSavedList);

                $("[id$='autodocHidden']",$("#autodocParams")).val($finalHTML.html());

                //Uncommented by SAE - We will make the change next sprint as we have demos pending
                //$("[id$='autodocHidden']").val($finalHTML.html());  // Commented by Metallica - Add a div with id= autodocParams in TTS
                var commentSec = "#"+pageidClone+"autodocComments";
                //assign autodoc comment
                $("[id$='autodocCommentHidden']",$("#autodocParams")).val($(commentSec).val());
                //assign autodoc case item key ids

                var autodocMapData = acet.autodoc.getCaseItemInfo($finalHTML);

                if (autodocMapData.length > 0) {
                    console.log('====2====>>' + autodocMapData);
                    $("[id$='autodocCaseItemsHidden']", $("#autodocParams")).val(autodocMapData);
                } else {
                    $("[id$='autodocCaseItemsHidden']", $("#autodocParams")).val("");
                }
				localStorage.removeItem("rowCheckHold");
                return $finalHTML.html();
            } else
                return null;
        },

        "previewAutoDoc": function (pagefeature, pageid) {

            var $autodoc = $("<div></div>");

            var $autodocMap = new Map();
            multipleTableRowFinal = [];

            var rowCheckHoldPreview = localStorage.getItem(pagefeature);

            if (rowCheckHoldPreview != undefined && rowCheckHoldPreview != null)
                identifierList = JSON.parse(rowCheckHoldPreview) || [];
            if (identifierList.length > 0) {
                for (var i = 0; i < identifierList.length; i++) {
                    $autodoc.append(identifierList[i]);
                }
            }

            var multiplePagesCheck = $("[data-auto-doc-multiple-pages='true']", $('#' + pageid));
            if (multiplePagesCheck.html() != undefined) {
                if (pageid != undefined && pageid != null) {
                    pageid = "." + pageid;
                    var pageidTemp = pageid;
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                        var $clonedSec = $(this);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            var $source = $(this);
                            var $section = $(this).clone();
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                console.log('----autodoc---91.31.2------');
                                var $table = $(this).clone();
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                $section.find(".autodocNotTableView").each(function () {

                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            //console.log('----autodoc---1745------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            //console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            //console.log('----autodoc---1759------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                    //console.log('----autodoc---1767------' + $(this).find("input:checkbox:checked").length);
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            //console.log('----autodoc---1771------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            //console.log('----autodoc---1744------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {
                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    //console.log('----autodoc---1780------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            //console.log("-----currTableId=======>" + $table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');

                                            $table.find(".autodocPagination").find("thead").find("th").each(function () {
                                                $(this).css("transform", "");
                                            });
                                            $table.find(".autodocPagination").find("tbody").empty();

                                            var IdList;
                                            if (uniqueIds != undefined && uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                            //console.log("============UNIQUE IDs 1798=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                    //console.log("============value 1803=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
												function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);


                                                var autoDocRows = $("<tr></tr>");
                                                uniqueIdentifierList = [];
                                                autoDocData.children("tr").each(function () {
                                                    var uniqueKey;
                                                    //console.log("============OUT=======>" + $(this).length);
                                                    if ($(this).html() != '') {
                                                        if (IdList.length > 0) {
                                                            for (var i = 0; i < IdList.length; i++) {
                                                                var keyStr = "td:eq(" + IdList[i] + ")";
                                                                if (uniqueKey != undefined) {
                                                                    uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                                } else {
                                                                    uniqueKey = $(this).find(keyStr).text();
                                                                }
                                                            }
                                                        }
                                                        //console.log("============UNIQUE Value=======>" + uniqueKey);
                                                        if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                            //console.log("============In 1=======>");
                                                            autoDocRows.append($(this));
                                                            //console.log("============In 2=======>");
                                                            uniqueIdentifierList.push(uniqueKey);
                                                            //console.log("============In 3=======>");
                                                        }
                                                        //console.log("============UNIQUE uniqueIdentifierList=======>" + uniqueIdentifierList);
                                                    }
                                                });
                                                //console.log("========>>>>>" + autoDocRows.html());
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                if (autoDocRows.html() == undefined || autoDocRows.html().length == 0 || autoDocRows.html() == '') {
                                                    //console.log("====IN====>>>>>");
                                                    $table.empty();
                                                }

                                                $section = $table;
                                            } else {
                                                //console.log("====Make it blank====>>>>>");
                                                $table.empty();
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                //console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    //console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                            $section.find(".autodoc").remove();

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            //console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                //console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                       // console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                           // console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                           // console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                           // console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                           // console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                //console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    //console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    //console.log('----autodoc---100.1------');
                                    //console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    //console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }

                            $section.find(".autodoc").remove();

                            //append section content
                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    //console.log('----autodoc---1968------>');
                                    $autodoc = $autodocMap.get(mapKey);

                                    //console.log( Date.now() +'----autodoc---1968------>' + $autodoc.html());

                                } else if (rowCheckHoldPreview == undefined || !(rowCheckHoldPreview != undefined && rowCheckHoldPreview.length > 0)) {
                                    //console.log('----autodoc---1972------>');
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }

                                //SAE Fix - incorrect div position - 4th Mar 2020
                                var $bodyDiv = $section.find(".additionalDetail");
                                if ($bodyDiv != undefined) {
                                    $section.find(".additionalDetail").remove();
                                    $section.append($bodyDiv);
                                }

                                $section.append("<br/>");
                                mapval = $autodoc.append($section);

                                //console.log('----autodoc---100.4.1------>' + mapKey);
                                //console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());

                            }

                        }

                    });

                } else {
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                       // console.log('----autodoc---100.05.1----' + pagefeature);
                       // console.log('----autodoc---100.05.1.2----' + $(this).attr('data-auto-doc-feature'));

                        //console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                            //console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                        $section.find("input,select,textarea").each(function() {
                            $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                            console.log('----autodoc---91.3------');
                        });
                      }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            //console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                //console.log('----autodoc---91.31.2------');
                                var $table = $(this);
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                   // console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                      //  console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                          //  console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                 //   console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                              //  console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                          //  console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                         //   console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                          //  console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                   // console.log('----autodoc---91.31.31------');
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                         //   console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                          //  console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                  //  console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            //console.log("-----currTableId=======>"+$table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                            //console.log("============$currTableId=======>"+$currTableId);
                                            $table.find(".autodocPagination").find("tbody").empty();
                                            var uniqueIds = $table.find(".autodocPagination").attr("data-auto-doc-uniqueids");
                                            var IdList;
                                            if (uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                          //  console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tabledata = $paginationMultipleTableMap.get($currTableId).values();
                                                for (var i=0 ; i<tabledata.length; i++) {
                                                  console.log("============value=======>"+tabledata[i]);
                                                  var clonedItem = tabledata[i];
                                                  autoDocData.append(clonedItem);
                                                }
                                                **/
                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                   // console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                                var uniqueKey;
                                                var autoDocRows = $("<tr></tr>");
                                                $table.find(".autodocPagination").children('tbody').children('tr').each(function () {
                                                    if (IdList.length > 0) {
                                                        for (var i = 0; i < IdList.length; i++) {
                                                            var keyStr = "td:eq(" + IdList[i] + ")";
                                                            if (uniqueKey != undefined) {
                                                                uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                            } else {
                                                                uniqueKey = $(this).find(keyStr).text();
                                                            }
                                                        }
                                                    }
                                                });

                                                autoDocData.find("tr").each(function () {
                                                  //  console.log("============UNIQUE Value=======>" + uniqueKey);
                                                    if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                        autoDocRows.append(clonedItem);
                                                        uniqueIdentifierList.push(uniqueKey);
                                                    }
                                                });
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                $section = $table;
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                               // console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                   // console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                            $section.find(".autodoc").remove();

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            //console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                               // console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                       // console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                           // console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                          //  console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                           // console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                           // console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                               // console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                   // console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                   // console.log('----autodoc---100.1------');
                                   // console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                  //  console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }

                            $section.find(".autodoc").remove();

                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (rowCheckHoldPreview == undefined || !(rowCheckHoldPreview != undefined && rowCheckHoldPreview.length > 0)) {
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }
                                mapval = $autodoc.append($section);

                                //console.log('----autodoc---100.4.1------>' + mapKey);
                                //console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                               // console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });
                }
            } else {
                if (pageid != undefined && pageid != null) {
                    pageid = "#" + pageid;
                    var pageidTemp = pageid;
                    //console.log('--1--autodoc---100.05--LEN----');
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                       // console.log('----autodoc---100.05.1----' + pagefeature);
                       // console.log('----autodoc---100.05.1.3----' + $(this).attr('data-auto-doc-feature'));
                        var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                        var $clonedSec = $(this);
                      //  console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                           // console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                    $section.find("input,select,textarea").each(function() {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                        console.log('----autodoc---91.3------');
                    });
                  }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                         //   console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                              //  console.log('----autodoc---91.31.2------');
                                //Sanka - Added SAE
                                var $table = $(this).clone();
                                //var $table = $(this);

                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                 //   console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                    //    console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                         //   console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName, p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                  //  console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                              //  console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                         //   console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                         //   console.log('----autodoc---91.72------' + $chks.html());

                                            // SAE - US2262761 - Thanish - 16th April 2020 - removed bottom_margin to fix bigs
                                            // $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            $chks.closest(".slds-p-around_xx-small, .autodocField").remove();

                                         //   console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                  //  console.log('----autodoc---91.31.31------' + $(this).find("input:checkbox:checked").length);
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                         //   console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                          //  console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                 //   console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                          //  console.log("-----currTableId=======>" + $table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');

                                            $table.find(".autodocPagination").find("thead").find("th").each(function () {
                                                $(this).css("transform", "");
                                            });
                                            $table.find(".autodocPagination").find("tbody").empty();

                                            var IdList;
                                            if (uniqueIds != undefined && uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                           // console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                          //  console.log('$paginationMultipleTableMap -- >' + $paginationMultipleTableMap);
                                         //   console.log('$Has -- >' + $paginationMultipleTableMap.has($currTableId));

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {

                                                /**for (var value in $paginationMultipleTableMap.get($currTableId).values()) {
                                                    //console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
												function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);


                                                var autoDocRows = $("<tr></tr>");
                                                uniqueIdentifierList = [];
                                                autoDocData.children("tr").each(function () {
                                                    var uniqueKey;
                                                    //console.log("============OUT=======>" + $(this).length);
                                                    if ($(this).html() != '') {
                                                        if (IdList.length > 0) {
                                                            for (var i = 0; i < IdList.length; i++) {
                                                                var keyStr = "td:eq(" + IdList[i] + ")";
                                                                if (uniqueKey != undefined) {
                                                                    uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                                } else {
                                                                    uniqueKey = $(this).find(keyStr).text();
                                                                }
                                                            }
                                                        }
                                                       // console.log("============UNIQUE Value=======>" + uniqueKey);
                                                        if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                           // console.log("============In 1=======>");
                                                            autoDocRows.append($(this));
                                                          //  console.log("============In 2=======>");
                                                            uniqueIdentifierList.push(uniqueKey);
                                                          //  console.log("============In 3=======>");
                                                        }
                                                       // console.log("============UNIQUE uniqueIdentifierList=======>" + uniqueIdentifierList);
                                                    }
                                                });
                                               // console.log("========>>>>>" + autoDocRows.html());
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                if (autoDocRows.html() == undefined || autoDocRows.html().length == 0 || autoDocRows.html() == '') {
                                                   // console.log("====IN====>>>>>");
                                                    $table.empty();
                                                }

                                                $section = $table;
                                            } else {
                                               // console.log("====Make it blank====>>>>>");
                                                $table.empty();
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                //console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                   // console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //Hide duplicate headers when creating document - Sanka US2038277
                            $section.find(".slds-text-heading_small").hide();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                            $section.find(".autodoc").remove();

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                           // console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                               // console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                       // console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                           // console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                          //  console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                           // console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                           // console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                               // console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                   // console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                   // console.log('----autodoc---100.1------');
                                   // console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                  //  console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }
                            /**
                  if (authorizationFinal != null) {
                      console.log('----autodoc---100.3------');
                      var sectionName = $section.attr("data-auto-doc-section-key");
                      var iterateMap = Object.entries(authorizationFinal);
                      for (var i = 0; i < iterateMap.length; i++) {
                          for (var j = 0; j < iterateMap[i].length;) {
                              if (iterateMap[i][j] == sectionName) {
                                  $section.find(".slds-box").remove();
                                  console.log($section);
                                  $section.append(iterateMap[i][++j]);
                              }
                              j++;
                          }
                          console.log($section);

                      }

                  }
                  **/


                            $section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName, p.slds-form-element__label").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {


                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    // console.log('----autodoc---100.4.0001------>');
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (rowCheckHoldPreview == undefined || !(rowCheckHoldPreview != undefined && rowCheckHoldPreview.length > 0)) {
                                    // console.log('----autodoc---100.4.001------>');
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }

                                //SAE Fix - incorrect div position
                                var $bodyDiv = $section.find(".additionalDetail");
                                if ($bodyDiv != undefined) {
                                    $section.find(".additionalDetail").remove();
                                    $section.append($bodyDiv);
                                }

                                //console.log($section.html());


                                //Prepend section on top - Sanka US2038277
                                var selected = $source.find(".autodocPagination").find('input:checkbox:checked').length;

                                var hasPagination = $source.attr("data-auto-doc-pagination");
                                // console.log(hasPagination);

                                if (selected <= 0 && hasPagination) {
                                    $section.addClass('noitemsSelected');
                                }

                                if ($source.hasClass('prependSection')) {
                                    mapval = $autodoc.prepend($section);
                                    //autodocPrepended = true;
                                } else {
                                    mapval = $autodoc.append($section);
                                }

                                //mapval = $autodoc.prepend($section);

                                if (selected <= 0 && hasPagination) {
                                    //mapval.find(".selectedSection").remove();
                                    mapval.find(".noitemsSelected").remove();
                                }

                                //mapval = $autodoc.append($section);

                                // console.log('----autodoc---100.4.1------>' + mapKey);
                                // console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                // console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });

                } else {
                    $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                        // console.log('----autodoc---100.05.1----' + pagefeature);

                        // console.log('----autodoc---91.0------>' + $(this).attr('data-auto-doc-feature') == pagefeature);
                        if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                            //console.log('----autodoc---91.1------'+window.location.pathname.substring(window.location.pathname.indexOf('/cmp/')+8, window.location.pathname.length));

                            var $source = $(this);
                            var $section = $(this).clone();
                            //   console.log('----autodoc---91.2------' + $section.html());
                            //fix jquery issue, selected value is not cloned
                            /**if($section.find("input,select,textarea").length > 0){
                        $section.find("input,select,textarea").each(function() {
                            $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                            console.log('----autodoc---91.3------');
                        });
                      }**/
                            //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                            //remove unchecked fields or rows
                            //if ($section.attr("data-auto-doc") == 'true') {
                            //   console.log('----autodoc---91.31.1------');
                            //autodoc on header and section details
                            if (!($section.attr("auto-doc-header-only") == 'true')) {
                                //      console.log('----autodoc---91.31.2------');
                                var $table = $(this);
                                $section.find(".autodocHighlightsPanel").addClass("slds-box");
                                $section.find(".expandable").removeClass("slds-hide");
                                //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                                $section.find(".autodocNotTableView").each(function () {
                                    //  console.log('----autodoc---91.31.3------');

                                    //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                                    //reorder fields in page block section

                                    if ($table.find(".autodocNotTableView").length == 0) {
                                        //   console.log('----autodoc---91.7------');
                                        var $tr = $("<tr></tr>");
                                        $table.find(".slds-grid").each(function () {
                                            //    console.log('----autodoc---91.8------');
                                            $(this).find("p.autodocFieldName, p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                                if ($tr.children().length == 4) {
                                                    $table.append($tr);
                                                    $tr = $("<tr></tr>");
                                                    //      console.log('----autodoc---91.9------');
                                                }
                                                $tr.append($(this).parent().clone());
                                                $tr.append($(this).parent().next().clone());
                                                //   console.log('----autodoc---91.91------');
                                            });
                                            $(this).remove();
                                        });
                                        $table.append($tr);
                                    } else {
                                        if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                            $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                            //   console.log('----autodoc---91.72.1------' + $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                            //   console.log('----autodoc---91.72------' + $chks.html());

                                            $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                            //  console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                            //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                        } else {
                                            $section = $("<div></div>");
                                        }
                                    }
                                });

                                $section.find(".slds-table, .autodocPagination").each(function () {
                                    //  console.log('----autodoc---91.31.31------');
                                    if ($(this).find("input:checkbox:checked").length > 0) {
                                        //reorder fields in page block section
                                        if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                            //  console.log('----autodoc---91.71------' + $section.html());
                                            var $tr = $("<tr></tr>");
                                            //$section.find(".autodoc").each(function() {
                                            //  console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                            if ($(this).find("input:checkbox:checked").length > 0) {

                                                $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                                    /**if ($tr.children().length == 4) {
                                                        $table.append($tr);
                                                        $tr = $("<tr></tr>");
                                                        console.log('----autodoc---91.9------');
                                                    }**/
                                                    //$tr.append($(this).parent().clone());
                                                    //$tr.append($(this).parent().next().clone());
                                                    $tr = $(this);
                                                    $tr.closest(".slds-hint-parent").remove();
                                                    //  console.log('----autodoc---91.91.1------');
                                                });
                                            } else {
                                                $section = $("<div></div>");
                                            }
                                            //$(this).remove();
                                            //});
                                            //$table.append($tr);
                                        } else if ($table.find(".autodocPagination").length > 0) {
                                            //console.log("-----currTableId=======>"+$table.html());
                                            var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                            //console.log("============$currTableId=======>"+$currTableId);
                                            $table.find(".autodocPagination").find("tbody").empty();
                                            var uniqueIds = $table.find(".autodocPagination").attr("data-auto-doc-uniqueids");
                                            var IdList;
                                            if (uniqueIds.indexOf(",") != -1)
                                                IdList = uniqueIds.split(",");

                                            // console.log("============UNIQUE IDs=======>" + uniqueIds);
                                            var autoDocData = $("<tr></tr>");

                                            if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                                /**var tabledata = $paginationMultipleTableMap.get($currTableId).values();
                                                for (var i=0 ; i<tabledata.length; i++) {
                                                  console.log("============value=======>"+tabledata[i]);
                                                  var clonedItem = tabledata[i];
                                                  autoDocData.append(clonedItem);
                                                }
                                                **/
                                                /**for (var value of $paginationMultipleTableMap.get($currTableId).values()) {
                                                    //   console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }**/
                                                function logMapElements(value, key, map) {
                                                    console.log("============value=======>" + value);
                                                    var clonedItem = value;
                                                    autoDocData.append(clonedItem);
                                                }

                                                $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                                var uniqueKey;
                                                var autoDocRows = $("<tr></tr>");
                                                $table.find(".autodocPagination").children('tbody').children('tr').each(function () {
                                                    if (IdList.length > 0) {
                                                        for (var i = 0; i < IdList.length; i++) {
                                                            var keyStr = "td:eq(" + IdList[i] + ")";
                                                            if (uniqueKey != undefined) {
                                                                uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                                            } else {
                                                                uniqueKey = $(this).find(keyStr).text();
                                                            }
                                                        }
                                                    }
                                                });

                                                autoDocData.find("tr").each(function () {
                                                    //  console.log("============UNIQUE Value=======>" + uniqueKey);
                                                    if (!uniqueIdentifierList.includes(uniqueKey)) {
                                                        autoDocRows.append(clonedItem);
                                                        uniqueIdentifierList.push(uniqueKey);
                                                    }
                                                });
                                                $table.find(".autodocPagination").find("tbody").append(autoDocRows.html());
                                                $section = $table;
                                            }

                                        }
                                    } else {
                                        $(this).empty();
                                        $section = $("<div></div>");
                                    }
                                });
                            } else {
                                // console.log('----autodoc---91.92------');
                                //autodoc on header only, clear whole section if header is not checked on
                                $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                                    $(this).parent().parent().html('');
                                    //console.log('----autodoc---91.92.1------');
                                });
                            }
                            //}

                            //hide sheveron icon and expand section if section is collapsed
                            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                            $section.find(".slds-box").show();

                            //remove input required class
                            $section.find(".requiredBlock").remove();
                            $section.find(".requiredInput").removeClass("requiredInput");

                            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                            $section.find(".slds-card__body").find(".checkImg").remove();

                            //remove auto generagted element for autodoc
                            $section.find(".autodoc").remove();

                            //exclude element with autodoc equals false
                            $section.find("[data-auto-doc-item='false']").remove();

                            //remove all script tags
                            $section.find("script").remove();

                            //  console.log('----autodoc---91.92.2------' + $section.html());
                            //convert input field into text node
                            $section.find("input,select,textarea").each(function () {
                                //   console.log('----autodoc---91.93------>' + $(this).text());
                                if ($(this).css("display") !== "none") {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {

                                        // console.log('----autodoc---91.94------' + $(this).is(":checked"));

                                        if ($(this).is(":checked")) {
                                            // console.log('----autodoc---91.95------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            //  console.log('----autodoc---91.96------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            // console.log('----autodoc---91.97------');

                                            var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                            strData = strData.replace('::after', '');
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith(strData);
                                        } else {
                                            // console.log('----autodoc---91.98------');
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });

                            if (localStorage.getItem("table") != null) {
                                // console.log('----autodoc---91.99------');
                                var arrColIndexes = [];
                                var identifierList = [];
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var aMap = {};
                                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                                for (var i = 0; i < multipleTableRowArray.length; i++) {
                                    // console.log('----autodoc---100------');
                                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                                        identifierList.push(multipleTableRowArray[i][j]);
                                        var temp = multipleTableRowArray[i][++j];
                                        multipleTableRowFinal.push(temp);
                                        j++;
                                    }

                                }

                                var tempList = GetUnique(multipleTableRowFinal);
                                for (var y = 0; y < tempList.length; y++) {
                                    // console.log('----autodoc---100.1------');
                                    // console.log(tempList[y]);
                                    if (tempList[y] != undefined) {
                                        var splitString = tempList[y].split("%");
                                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                                        aMap[splitString[0]].push(splitString[1]);
                                    }
                                }
                                for (var key in aMap) {
                                    //  console.log('----autodoc---100.2------');
                                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                                    if (keyTabId == key) {
                                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                        var arrayJoin = aMap[key].toString();
                                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                                    }

                                }



                            }

                            $section.find(".autodoc").remove();


                            //append section content

                            if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName, p.slds-form-element__label").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                                //var $chks1 = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                //console.log('----autodoc---91.72------'+ $table.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                //
                                // console.log('this is the section');

                                var mapKey = $source.attr("data-auto-doc-feature");
                                var mapval;
                                if ($autodocMap.has(mapKey)) {
                                    $autodoc = $autodocMap.get(mapKey);

                                } else if (rowCheckHoldPreview == undefined || !(rowCheckHoldPreview != undefined && rowCheckHoldPreview.length > 0)) {
                                    $autodoc = $("<div></div>");
                                }
                                var sectionHeader = $source.attr("data-auto-doc-section-key");
                                // console.log(sectionHeader);
                                if (sectionHeader != undefined) {
                                    var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                                    $section.prepend($autodocHeader);
                                }
                                mapval = $autodoc.append($section);

                                // console.log('----autodoc---100.4.1------>' + mapKey);
                                // console.log('----autodoc---100.4.2------>' + mapval.html());
                                $autodocMap.set(mapKey, mapval);
                                // console.log('----autodoc---100.4.3------>' + $autodocMap.get(mapKey).html());
                                //$chks1.closest(".slds-p-around_xx-small").remove();
                                //$autodoc.append($section);


                            }

                        }

                    });
                }
            }
            //  console.log('----autodoc---3036------' + $autodoc.html());
            //append additonal autodoc
            if (acet.autodoc.additionalInfo) {
                $autodoc.append(acet.autodoc.additionalInfo);
                //  console.log('----autodoc---100.5------');
            }

            var $additionalAccumsSection = '';
            $autodoc.append("<br/><br/>");

            $paginationTableMap = new Map();
            $paginationDataMap = new Map();
            $paginationMultipleTableMap = new Map();
            $paginationMultipleTableKeyMap = new Map();
            adIdentifierList = [];
            adResolvedList = [];

            //console.log("3053 ::: " + $autodocMap);

            //console.log('====0====>>' + pagefeature);
            if ($autodocMap != undefined && $autodocMap.get(pagefeature) != undefined) {
                //console.log('====3====>>');
                var $finalHTML = $autodocMap.get(pagefeature);
                if (($finalHTML.find(".autodocTableView") != undefined || $finalHTML.find(".autodocPagination") != undefined) && $finalHTML.find(".autodocHighlightsPanel") != undefined) {
                    //   console.log("----IN----" + $finalHTML.find(".autodocHighlightsPanel").html());
                    var $hpDOM = $finalHTML.find(".autodocHighlightsPanel");
                    //   console.log("----IN----" + $hpDOM.html());
                    $finalHTML.find(".autodocHighlightsPanel").remove();
                    //    console.log("----IN----" + $finalHTML.html());
                    $finalHTML.prepend($hpDOM);
                    //    console.log("----IN----" + $finalHTML.html());

                    //Added for SAE - Fixing padding issue
                    $finalHTML.find(".autodocTableView").addClass("slds-box slds-card");
                }
                //$("[id$='autodocHidden']",$("#autodocParams")).val($finalHTML.html());
                $("[id$='autodocHiddenPreview']").val($finalHTML.html());






                return $finalHTML.html();
                            }else
                				return null;
		},

        "saveAuthorizationSection": function () {
            console.log('----autodoc---55------');
            identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
            var $autodoc = $("<div></div>");
            $("[data-auto-doc-section-key]").each(function () {

                var sectionName = $(this).attr("data-auto-doc-section-key");
                $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                    var arrColIndexes = [];
                    $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                        arrColIndexes.push(parseInt(e));
                    });
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {

                        var rowCloneVar = sectionName;
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            var $rowClone = $(this).clone();
                            $rowClone.find("input,select,textarea").each(function () {
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                        if ($(this).is(":checked")) {
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                        } else {
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });
                            var identifier = sectionName;
                            for (var i = 0; i < arrColIndexes.length; i++) {
                                if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                    var $td = $(this).find("td").eq(arrColIndexes[i]);
                                    if ($td) {
                                        identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                    }
                                }
                            }

                            identifier = globalVar + '|' + identifier;
                            rowAuthorizationList[identifier] = sectionName + '|' + $rowClone.closest('tr')[0].outerHTML;
                            console.log(rowAuthorizationList);
                            identifierList.push(identifier);
                            console.log("identifierList..." + identifierList);
                            var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                            acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                            localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        } else if ($chkAutodoc.is(":not(:checked)")) {
                            var identifier = sectionName;
                            for (var i = 0; i < arrColIndexes.length; i++) {
                                if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                    var $td = $(this).find("td").eq(arrColIndexes[i]);
                                    if ($td) {
                                        identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                    }
                                }
                            }
                            var $rowClone = $(this).clone();
                            $rowClone.find("input,select,textarea").each(function () {
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                        if ($(this).is(":checked")) {
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                        }
                                    } else {
                                        if ($(this).is("select")) {
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                        } else {
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });
                            identifier = globalVar + '|' + identifier;
                            if (rowAuthorizationList.hasOwnProperty(identifier)) {
                                delete rowAuthorizationList[identifier];
                            }
                            console.log(rowAuthorizationList);
                            identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
                            if (identifierList.indexOf(identifier) > -1) {
                                identifierList.splice(identifierList.indexOf(identifier), 1);
                                acet.autodoc.selectedItems.splice(acet.autodoc.selectedItems.indexOf[identifier], 1);
                                localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                            }
                        }

                    });
                });


            });

        },

        "storePaginationData": function (pagenum, pageid) {
            var multiplePagesCheck = $("[data-auto-doc-multiple-pages='true']", $('#' + pageid));
            //alert('-----MP-2----'+multiplePagesCheck.html());
            if (multiplePagesCheck.html() != undefined) {

                if (pageid != undefined)
                    pageid = '.' + pageid;
                var $originalSection = $("[data-auto-doc-pagination='true']", $(pageid));

                //var $paginationsection = $("[data-auto-doc-pagination='true']");
                var $paginationsection = $originalSection.clone();
                //console.log('----autodoc---Pagination.1------' + $paginationsection.length + '===' + pageid + '====' + JSON.stringify($paginationMultipleTableMap));
                $paginationsection.each(function () { //
                    var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                    var $tableId = $(this).find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                    if ($paginationMultipleTableMap.has($tableId)) {
                        console.log('----autodoc---Pagination.00------');
                        $paginationTableMap = $paginationMultipleTableMap.get($tableId);
                    } else {
                        console.log('----autodoc---Pagination.001------');
                        $paginationTableMap = new Map();
                    }
                    var $sectionName = $(this);
                    $(this).find('.autodocPagination').children('tbody').children('tr').each(function () {
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        //acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            console.log('----autodoc---Pagination.2------');
                            var $resolvedChk = $(this).find("input[type='checkbox'].autodoc-case-item-resolved");
                            console.log('----autodoc---Pagination.2.01------');
                            if ($resolvedChk.is(":checked")) {
                                $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" checked="true">');
                            } else {
                                $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" >');
                                $resolvedChk.checked = false;
                            }
                            var autodockey = $(this).find("#lnkClaimId").html();
                            console.log('----autodoc---Pagination.2.001------' + $paginationTableMap.has(pagenum));
                            if ($paginationTableMap.has(pagenum)) {
                                console.log('----autodoc---Pagination.2.0001------');
                                if ($paginationTableMap.get(pagenum) != null && $paginationTableMap.get(pagenum) != undefined) {
                                    console.log('----autodoc---Pagination.2.1------');
                                    var tempHTML = $paginationTableMap.get(pagenum);

                                    var $doctr = "</tr>";
                                    var $dochtml = "<tr class='slds-hint-parent' role='row'>";
                                    var tempJQConvert = $("<div></div>");
                                    tempJQConvert.append(tempHTML);
                                    tempJQConvert.append($dochtml);

                                    tempJQConvert.append($(this).html());
                                    tempJQConvert.append($doctr);
                                    $paginationTableMap.set(pagenum, tempJQConvert.html());
                                    //console.log('----autodoc---Pagination.3------' + JSON.stringify($paginationTableMap.get(pagenum)));

                                }
                            } else {
                                console.log('----autodoc---Pagination.2.2------');
                                var $doctr = "</tr>";
                                var $dochtml = $("<tr></tr>");
                                $dochtml.append("<tr class='slds-hint-parent' role='row'>");
                                $dochtml.append($(this).html());
                                $dochtml.append($doctr);
                                $paginationTableMap.set(pagenum, $dochtml.html());
                                //console.log('----autodoc---Pagination.4------' + JSON.stringify($paginationTableMap.get(pagenum)));
                            }
                            console.log('----autodoc---Pagi-Identifier----->' + uniqueIds + '<-------' + $(this).html());
                            if (uniqueIds != undefined) {

                                var IdList;
                                if (uniqueIds.indexOf(",") != -1)
                                    IdList = uniqueIds.split(",");
                                else
                                    IdList = IdList.push(uniqueIds);
                                if (IdList.length > 0) {
                                    var uniqueKey;

                                    for (var i = 0; i < IdList.length; i++) {
                                        var keyStr = "td:eq(" + IdList[i] + ")";
                                        if (uniqueKey != undefined) {
                                            uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                        } else {
                                            uniqueKey = $(this).find(keyStr).text();
                                        }

                                    }
                                    adIdentifierList.push(uniqueKey);
                                    if ($chkCaseItemResolved) {
                                        var resolvedUniqueKey = $tableId + "-" + uniqueKey;
                                        adResolvedList.push(resolvedUniqueKey);
                                    }
                                }
                            }
                            console.log('----autodoc---Pagi-IdentifierLIST-----' + adIdentifierList);

                        }
                    });
                    console.log('----autodoc---Pagination.7------' + $tableId);
                    //console.log('----autodoc---Pagination.8------' + JSON.stringify($paginationTableMap.get(pagenum)));
                    $paginationMultipleTableMap.set($tableId, $paginationTableMap);
                    $paginationMultipleTableKeyMap.set($tableId, adIdentifierList);
                });


            } else {
                if (pageid != undefined)
                    pageid = '#' + pageid;
                var $originalSection = $("[data-auto-doc-pagination='true']", $(pageid));

                //var $paginationsection = $("[data-auto-doc-pagination='true']");
                var $paginationsection = $originalSection.clone();
                //console.log('----autodoc---Pagination.1------' + $paginationsection.length + '===' + pageid + '====' + JSON.stringify($paginationMultipleTableMap));
                $paginationsection.each(function () { //
                    var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                    var $tableId = $(this).find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                    if ($paginationMultipleTableMap.has($tableId)) {
                        console.log('----autodoc---Pagination.00------');
                        $paginationTableMap = $paginationMultipleTableMap.get($tableId);
                    } else {
                        console.log('----autodoc---Pagination.001------');
                        $paginationTableMap = new Map();
                    }
                    var $sectionName = $(this);
                    $(this).find('.autodocPagination').children('tbody').children('tr').each(function () {
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        //acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            console.log('----autodoc---Pagination.2------');
                            var $resolvedChk = $(this).find("input[type='checkbox'].autodoc-case-item-resolved");
                            console.log('----autodoc---Pagination.2.01------');
                            if ($resolvedChk.is(":checked")) {
                                $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" checked="true">');
                            } else {
                                $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" >');
                                $resolvedChk.checked = false;
                            }
                            var autodockey = $(this).find("#lnkClaimId").html();
                            console.log('----autodoc---Pagination.2.001------' + $paginationTableMap.has(pagenum));
                            if ($paginationTableMap.has(pagenum)) {
                                console.log('----autodoc---Pagination.2.0001------');
                                if ($paginationTableMap.get(pagenum) != null && $paginationTableMap.get(pagenum) != undefined) {
                                    console.log('----autodoc---Pagination.2.1------');
                                    var tempHTML = $paginationTableMap.get(pagenum);

                                    var $doctr = "</tr>";
                                    var $dochtml = "<tr class='slds-hint-parent' role='row'>";
                                    var tempJQConvert = $("<div></div>");
                                    tempJQConvert.append(tempHTML);
                                    tempJQConvert.append($dochtml);

                                    tempJQConvert.append($(this).html());
                                    tempJQConvert.append($doctr);
                                    $paginationTableMap.set(pagenum, tempJQConvert.html());
                                    //console.log('----autodoc---Pagination.3------' + JSON.stringify($paginationTableMap.get(pagenum)));

                                }
                            } else {
                                console.log('----autodoc---Pagination.2.2------');
                                var $doctr = "</tr>";
                                var $dochtml = $("<tr></tr>");
                                $dochtml.append("<tr class='slds-hint-parent' role='row'>");
                                $dochtml.append($(this).html());
                                $dochtml.append($doctr);
                                $paginationTableMap.set(pagenum, $dochtml.html());
                                //console.log('----autodoc---Pagination.4------' + JSON.stringify($paginationTableMap.get(pagenum)));
                            }
                            console.log('----autodoc---Pagi-Identifier----->' + uniqueIds + '<-------' + $(this).html());
                            if (uniqueIds != undefined) {

                                var IdList;
                                if (uniqueIds.indexOf(",") != -1)
                                    IdList = uniqueIds.split(",");
                                else
                                    IdList = IdList.push(uniqueIds);
                                if (IdList.length > 0) {
                                    var uniqueKey;

                                    for (var i = 0; i < IdList.length; i++) {
                                        var keyStr = "td:eq(" + IdList[i] + ")";
                                        if (uniqueKey != undefined) {
                                            uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                        } else {
                                            uniqueKey = $(this).find(keyStr).text();
                                        }

                                    }
                                    adIdentifierList.push(uniqueKey);
                                    if ($chkCaseItemResolved) {
                                        var resolvedUniqueKey = $tableId + "-" + uniqueKey;
                                        adResolvedList.push(resolvedUniqueKey);
                                    }
                                }
                            }
                            console.log('----autodoc---Pagi-IdentifierLIST-----' + adIdentifierList);

                        }
                    });
                    console.log('----autodoc---Pagination.7------' + $tableId);
                    //console.log('----autodoc---Pagination.8------' + JSON.stringify($paginationTableMap.get(pagenum)));
                    $paginationMultipleTableMap.set($tableId, $paginationTableMap);
                    $paginationMultipleTableKeyMap.set($tableId, adIdentifierList);
                });


                    }
        },

        "getPaginationData": function ($checkedRow, tableId) {
            console.log('----autodoc---P.5------');
            multipleTableRowList = JSON.parse(localStorage.getItem("table")) || [];
            console.log(multipleTableRowList);
            for (var i = 0; i < multipleTableRowList.length; i++) {
                for (var j = 0; j < multipleTableRowList[i].length;) {
                    $removeDuplicatesOnCaseObject[multipleTableRowList[i][j]] = multipleTableRowList[i][++j];
                    j++;
                }
            }
            console.log($removeDuplicatesOnCaseObject);
            $("[data-auto-doc-section-key]").each(function () {
                console.log('-----autodoc----P.6------');
                var setAttributeTabId = $(this).find(".enablePagination");
                setAttributeTabId.attr("auto-doc-section-tabid", globalVar);
                var sectionName = $(this).attr("data-auto-doc-section-key");
                $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                    console.log('-----autodoc----P.7------');
                    var arrColIndexes = [];
                    $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                        console.log('-----autodoc----P.8------');
                        arrColIndexes.push(parseInt(e));
                    });
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                        console.log('-----autodoc----P.9------');
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            var identifier = sectionName;
                            for (var i = 0; i < arrColIndexes.length; i++) {
                                console.log('-----autodoc----P.10------');
                                if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                    var $td = $(this).find("td").eq(arrColIndexes[i]);
                                    if ($td) {
                                        identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                    }
                                }
                            }
                            if (globalVar != '' || globalVar != undefined) {
                                identifier = globalVar + '|' + identifier;
                            }
                            console.log("identifier......" + identifier);
                            var $rowClone = $(this).clone();
                            $rowClone.find("input,select,textarea").each(function () {
                                console.log('-----autodoc----P.11------');
                                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                        if ($(this).is(":checked")) {
                                            console.log('-----autodoc----P.12------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                            console.log('-----autodoc----P.13------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                        }
                                    } else {
                                        console.log('-----autodoc----P.14------');
                                        if ($(this).is("select")) {
                                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                            $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                        } else {
                                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                        }
                                    }
                                }
                            });
                            if (!$removeDuplicatesOnCaseObject.hasOwnProperty(identifier)) {
                                console.log('-----autodoc----P.15------');
                                $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                            } else {
                                delete $removeDuplicatesOnCaseObject[identifier];
                                $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                            }
                            var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                            acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                            localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                            console.log(localStorage.getItem("table"));
                        } else if ($chkAutodoc.is(":not(:checked)")) {
                            console.log('-----autodoc----P.16------');
                            var identifier = sectionName;
                            for (var i = 0; i < arrColIndexes.length; i++) {
                                if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                    var $td = $(this).find("td").eq(arrColIndexes[i]);
                                    if ($td) {
                                        identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                    }
                                }
                            }
                            if (globalVar != '' || globalVar != undefined) {
                                identifier = globalVar + '|' + identifier;
                            }
                            if ($removeDuplicatesOnCaseObject.hasOwnProperty(identifier)) {
                                delete $removeDuplicatesOnCaseObject[identifier];
                                localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                            }
                        }
                        console.log('-----autodoc----P.17------');
                    });

                });
            });

        },

        "saveAutodocSaveAccums": function () {
            console.log('----autodoc---77------');
            var $sectionFinalList = [];
            var accumAsOfSave = $("[id$='accumsdateSearch']").val();
            var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + $("[id$='grpEligDateId']").val();

            $("[data-auto-doc='true']").each(function () {
                if ($(this).attr('data-auto-doc-autosave') != "false" && $(this).attr('data-auto-doc-autosave') != "auto" ) {
                var $source = $(this);
                var $section = $(this).clone();

                $section.find("input,select,textarea").each(function () {
                    $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                });
                $sectionFinal = '';
                if ($section.attr("auto-doc") == 'true') {
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                        $section.find(".slds-box").find(".slds-card__body").each(function () {
                            var $table = $(this);
                            //reorder fields in page block section
                            if ($table.find(".slds-table, .autodocPagination, .auto-doc-list").length == 0) {
                                var $tr = $("<tr></tr>");
                                $table.find("tr").each(function () {
                                    $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                        if ($tr.children().length == 4) {
                                            $table.append($tr);
                                            $tr = $("<tr></tr>");
                                        }
                                        $tr.append($(this).parent().clone());
                                        $tr.append($(this).parent().next().clone());
                                    });
                                    $(this).remove();
                                });
                                $table.append($tr);
                            } else {
                                //page block table, remove unchecked rows
                                var $chks = $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
                                $chks.closest("tr").remove();

                            }
                        });
                    } else {
                        //autodoc on header only, clear whole section if header is not checked on
                        $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                            $(this).parent().parent().html('');
                        });
                    }
                }
                console.log($section.html());
                //hide sheveron icon and expand section if section is collapsed
                $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                $section.find(".slds-box").show();

                //remove input required class
                $section.find(".requiredBlock").remove();
                $section.find(".requiredInput").removeClass("requiredInput");

                //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                $section.find(".slds-box").find(".slds-card__body").find(".checkImg").remove();
                //$section.find(".slds-box").find(".slds-card__body").find("tbody tr:first").remove();
                //exclude element with autodoc equals false
                $section.find("[auto-doc-item='false']").remove();
                //remove all script tags
                $section.find("script").remove();
                //remove auto generagted element for autodoc
                $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).parent().remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });
                //convert input field into text node
                $section.find("input,select,textarea").each(function () {
                    if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                        if ($(this).is(":checkbox") || $(this).is(":radio")) {
                            if ($(this).is(":checked")) {
                                $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                            } else {
                                $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                            }
                        } else {
                            if ($(this).is("select")) {
                                //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                            } else {
                                $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                            }
                        }
                    }
                });
                $section.find(".tertiaryPalette").remove();
                if (accumAsOfSave != '' && accumAsOfSave != undefined) {
                    $sectionFinal = accumAsOfSave + '|' + $section.html();
                } else {
                    $sectionFinal = grpEligPopulation + '|' + $section.html();
                }
                console.log($sectionFinal);
            }
                console.log('----autodoc---111.000------'+$(this).parent().attr('data-auto-doc-autosave'));
                $(this).parent().attr('data-auto-doc-autosave', 'auto');

            });
            $sectionFinalList.push($sectionFinal);
            localStorage.setItem("localAccumsData", $sectionFinalList);

        },

        "clearAutodocSelections": function (pagefeature) {
            console.log('----autodoc---111------'+ pagefeature);
            var sel = "[data-auto-doc-feature='" + pagefeature + "']";

            var $toBeClearedSection = $("[data-auto-doc='auto']").find(sel);
            console.log('----autodoc---111------'+ $toBeClearedSection.length);
            console.log('----autodoc---111------'+ $toBeClearedSection.html());
            $toBeClearedSection.each(function () {
            	console.log('----autodoc---111.001------'+$(this).attr('data-auto-doc-autosave'));
                if ($(this).attr('data-auto-doc-autosave') != "false" && $(this).attr('data-auto-doc-autosave') != "auto" && !$(this).hasClass('autodocHighlightsPanel') ) {
                //remove any autodoc tags added before
                if($(this).find("table").html() != undefined && !$(this).hasClass("SAESection") ){ // US1918695
                    $(this).find(".autodoc:checkbox").each(function() {
                        console.log('-----autodoc----0.3------'+$(this).html());
                        //if($(this).find("input[type='checkbox']").html() != undefined)
                            if (!$(this).parent().hasClass("slds-text-heading_small")) {
                        $(this).parent().remove();
                            } else {
                                $(this).remove();
                            }

                    });
                }else{
                    $(this).find(".autodoc:checkbox").each(function() {
                        console.log('-----autodoc----0.3------'+$(this).html());
                        //if($(this).find("input[type='checkbox']").html() != undefined)
                        $(this).remove();
                    });
                }
                console.log('----autodoc---111.1------'+$(this).html());
                //add a checkbox right of the label for any field under page block section
                if (!($(this).attr("data-auto-doc-header-only") == 'true')) {
                    console.log('----autodoc---111.2------');
                    //Added for SAE - Sanka
                    $(this).find("p.autodocFieldName, p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');

                    //Preselect checkboxes for SAE business flow - Sanka US2138475
                    $(this).find(".preselect").each(function () {
                        $(this).find("input[type='checkbox'].autodoc").prop('checked', true).prop("disabled", true);
                    });

                    // Preselect checkboxes for SAE business flow - Not Disabled - Kavinda US2382581
                    $(this).find(".preselect-enable").each(function () {
                        $(this).find("input[type='checkbox'].autodoc").prop('checked', true);
                    });

                    //$(this).find("div.slds-form-element__static").css( "margin-left", "16px" );
                    $(this).find(".autodocValue, .valueCls").css("margin-left", "16px");
                    //align label and checkbox added
                    //$(this).find(".slds-box").find("p.autodocValue").css("vertical-align", "middle");
                }

                //add a checkbox in column header in first column
                //.slds-table is for standard page block table, .auto-doc-list is for acetdatatable component
                if (!($(this).attr("auto-doc-header-only") == 'true') && $(this).find(".slds-box").find(".slds-table, .autodocPagination, .auto-doc-list").html() != undefined) {

                    var rowCount = $(this).find(".slds-box").find(".slds-table, .autodocPagination, .auto-doc-list").find('tbody').children().length;
                    console.log('----autodoc---111.3------'+ rowCount);
                    if (rowCount < 26) {
                        console.log('----autodoc---111.4------');
                        $(this).find(".slds-table, .autodocPagination").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        $(this).find(".auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" /></th>');

                        //Added for SAE
                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                    } else if (rowCount > 26){
                        console.log('----autodoc---111.5------');
                        $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                    //Table not clearing for SAE
                    if (rowCount < 26) {
                        $("[data-auto-doc='auto']").find(".slds-table").find("input[type='checkbox'].autodoc").prop("checked", false);
                    } else if (rowCount > 26){
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                }
                //add checkboxes for all rows in first column
                if (!($(this).attr("auto-doc-header-only") == 'true') && $(this).find(".slds-table, .autodocPagination,.auto-doc-list").html() != undefined) {
                    console.log('----autodoc---111.6------');
                    $(this).find(".slds-table, .autodocPagination,.auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                }

                //Move checkboxes to the left - Sanka US2138475
                if ($("[data-auto-doc='auto']").hasClass('titleCheckBox')) {
                    // console.log('----autodoc---titleCheckBoxPrepend------');
                    //For SAE Change the position of the checkbox from right to left - Sanka US2138277
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").prepend('<input type="checkbox" class="autodoc" style="margin-right: 5px;"/>');
                } else {
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").append('<input type="checkbox" class="autodoc" style="margin-left: 5px;"/>');
                }

                $(this).find(".slds-text-heading_small").find("input[type='checkbox']").change(function () {
                    console.log('----autodoc---111.7------');
                    $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                    $(this).parent().parent().find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                //enable check-all/uncheck all function in table
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('thead').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                    console.log('----autodoc---111.8------');
                    $(this).parents(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                var authAutodoc = $(this).find('span.enableAuthorizationAutodoc').attr("data-auto-doc-section-state");
                if (authAutodoc == "yes") {
                    var $source = $(this);
                    var $authSection = $(this).clone();
                    $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .autodocPagination, .auto-doc-list").find('tbody').find('tr').remove();
                    console.log('----autodoc---autodoc----9------');
                    var tableHead = $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .autodocPagination, .auto-doc-list");
                    //var tableHead = $authSection.find(".slds-box");
                    console.log('-----autodoc---10------' + tableHead);
                    if ($authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .autodocPagination, .auto-doc-list").length > 0) {
                        console.log('-----autodoc----11------' + $authSection);
                        tableHeaderMap[$(this).attr("data-auto-doc-section-key")] = tableHead.parent().html();
                    }
                    console.log('----autodoc---111.9------');

                    //$authorization.push($authSection);
                }

                }
                console.log('----autodoc---111.001------'+$(this).parent().attr('data-auto-doc-autosave'));
                $(this).parent().attr('data-auto-doc-autosave', 'auto');
            });
        },

        "saveAutodocSelections": function (pagefeature) {
            var tempMapAuthorization = new Map();
            for (var key in rowAuthorizationList) {
                var localVal = '';
                var splitString = rowAuthorizationList[key].split("|");
                if (!tempMapAuthorization.has(splitString[0])) {
                    tempMapAuthorization.set(splitString[0], splitString[1]);
                } else {
                    localVal = tempMapAuthorization.get(splitString[0]) + '' + splitString[1];
                    tempMapAuthorization.set(splitString[0], localVal);
                }
            }
            var tempHTML;
            var tempJQConvert;
            var authorizationFinal = {};
            console.log(tableHeaderMap);
            for (var key in tableHeaderMap) {
                if (tableHeaderMap[key] != null || tableHeaderMap[key] != undefined) {
                    tempHTML = tableHeaderMap[key];
                    tempJQConvert = $(tempHTML);
                    if (tempMapAuthorization.get(key) != null) {
                        //tempJQConvert.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').append(tempMapAuthorization.get(key));
                        tempJQConvert.find('tbody').append(tempMapAuthorization.get(key))
                    }
                    authorizationFinal[key] = tempJQConvert[0].outerHTML;
                }

            }
            console.log(authorizationFinal);
            var $autodoc = $("<div></div>");

            var $autodocMap = new Map();
            multipleTableRowFinal = [];
            var selSec = "[data-auto-doc-feature='" + pagefeature + "']";
            console.log('----autodoc---77.00------' + selSec);

            var $autodoc = $("<div></div>");

            $("[data-auto-doc='auto'],[data-auto-doc='true']").each(function () {
                if ($(this).attr('data-auto-doc-feature') == pagefeature) {
					if ($(this).attr('data-auto-doc-autosave') != "false" && $(this).attr('data-auto-doc-autosave') != "auto") {
                    var $source = $(this);
                    var $section = $(this).clone();
                    console.log('----autodoc---91.2------' + $section.html());
                    //fix jquery issue, selected value is not cloned
                    $section.find("input,select,textarea").each(function () {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                        console.log('----autodoc---91.3------');
                    });
                    //remove unchecked fields or rows
                    //if ($section.attr("data-auto-doc") == 'true') {
                    console.log('----autodoc---91.31.1------');
                    //autodoc on header and section details
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                        console.log('----autodoc---91.31.2------');
                        var $table = $(this);
                        $section.find(".autodocHighlightsPanel").addClass("slds-box");
                        $section.find(".expandable").removeClass("slds-hide");
                        //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                        $section.find(".autodocNotTableView").each(function () {
                            console.log('----autodoc---91.31.3------' + $(this).html());

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                                console.log('----autodoc---91.7------');
                                var $tr = $("<tr></tr>");
                                $table.find(".slds-grid").each(function () {
                                    console.log('----autodoc---91.8------');
                                    $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function() {
                                        if ($tr.children().length == 4) {
                                            $table.append($tr);
                                            $tr = $("<tr></tr>");
                                            console.log('----autodoc---91.9------');
                                        }
                                        $tr.append($(this).parent().clone());
                                        $tr.append($(this).parent().next().clone());
                                        console.log('----autodoc---91.91------');
                                    });
                                    $(this).remove();
                                });
                                $table.append($tr);
                            } else {

                                console.log('----autodoc---91.31.3.0------' + $section.find(".autodocNotTableView").find("input:checkbox:checked").length);

                                if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                    console.log('----autodoc---91.31.3.1------' + $(this).find(".autodocNotTableView").find(".slds-col_bump-right"));
                                    if ($section.find(".autodocNotTableView").find(".slds-col_bump-right").html() != undefined) {
                                        $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                    }
                                    if ($section.find(".autodocNotTableView").find(".slds-col_bump-left").html() != undefined) {
                                        $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                    }
                                    var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                    console.log('----autodoc---91.72------' + $chks.html());

                                    $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                    console.log('----autodoc---91.72.0001------' + $chks.find(".autodocNotTableView").find("input:checkbox:checked").length);
                                    console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                    //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                } else {
                                    $section = $("<div></div>");
                                }
                            }
                        });

                        $section.find(".slds-table, .autodocPagination").each(function () {

                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                console.log('----autodoc---91.71------' + $(this).html());
                                var $tr = $("<tr></tr>");
                                //$section.find(".autodoc").each(function() {
                                console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                if ($(this).find("input:checkbox:checked").length > 0) {

                                    $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                        /**if ($tr.children().length == 4) {
                                                $table.append($tr);
                                                $tr = $("<tr></tr>");
                                                console.log('----autodoc---91.9------');
                                            }**/
                                        //$tr.append($(this).parent().clone());
                                        //$tr.append($(this).parent().next().clone());
                                        $tr = $(this);
                                        console.log('----autodoc---91.91.1------' + $tr.html());
                                        $tr.closest(".slds-hint-parent").remove();

                                    });
                                } else {
                                    $section = $("<div></div>");
                                }
                                //$(this).remove();
                                //});
                                console.log('----autodoc---91.711------' + $section.html());
                                //$table.append($tr);

                            } else if ($table.find(".autodocPagination").length > 0) {
                                console.log("-----currTableId=======>" + $table.html());
                                var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                console.log("============$currTableId=======>" + $currTableId);
                                $table.find(".autodocPagination").find("tbody").empty();
                                var autoDocData = $("<tr></tr>");

                                if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                    /**var pagiTableData = $paginationMultipleTableMap.get($currTableId).values();
                                    for (var i = 0; i < pagiTableData.length; i++) {
                                        console.log("============value=======>" + pagiTableData[i]);
                                        var clonedItem = pagiTableData[i];
                                        autoDocData.append(clonedItem);
                                    }**/
                                    function logMapElements(value, key, map) {
                                        console.log("============value=======>" + value);
                                        var clonedItem = value;
                                        autoDocData.append(clonedItem);
                                    }

                                    $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                    $table.find(".autodocPagination").find("tbody").append(autoDocData.html());
                                    $section = $table;
                                }



                            }
                        });

                    } else {
                        console.log('----autodoc---91.92------');
                        //autodoc on header only, clear whole section if header is not checked on
                        $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                            $(this).parent().parent().html('');
                            console.log('----autodoc---91.92.1------');
                        });
                    }
                    //}

                    //hide sheveron icon and expand section if section is collapsed
                    $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                    $section.find(".slds-box").show();

                    //Hide duplicate headers when creating document - Sanka US2038277
                    $section.find(".slds-text-heading_small").hide();

                    //remove input required class
                    $section.find(".requiredBlock").remove();
                    $section.find(".requiredInput").removeClass("requiredInput");

                    //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                    $section.find(".slds-card__body").find(".checkImg").remove();

                    //remove auto generagted element for autodoc
                  $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                    //exclude element with autodoc equals false
                    $section.find("[data-auto-doc-item='false']").remove();

                    //remove all script tags
                    $section.find("script").remove();

                    console.log('----autodoc---91.92.2------' + $section.html());
                    //convert input field into text node
                    $section.find("input,select,textarea").each(function () {
                        console.log('----autodoc---91.93------');
                        if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                console.log('----autodoc---91.94------');
                                if ($(this).is(":checked")) {
                                    console.log('----autodoc---91.95------');
                                    $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                } else {
                                    console.log('----autodoc---91.96------');
                                    $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                }
                            } else {
                                if ($(this).is("select")) {
                                    console.log('----autodoc---91.97------');

                                    var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                    strData = strData.replace('::after', '');
                                    //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                    $(this).replaceWith(strData);
                                } else {
                                    console.log('----autodoc---91.98------');
                                    $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                }
                            }
                        }
                    });

                    if (localStorage.getItem("table") != null) {
                        console.log('----autodoc---91.99------');
                        var arrColIndexes = [];
                        var identifierList = [];
                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                        var aMap = {};
                        var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                        for (var i = 0; i < multipleTableRowArray.length; i++) {
                            console.log('----autodoc---100------');
                            for (var j = 0; j < multipleTableRowArray[i].length;) {
                                identifierList.push(multipleTableRowArray[i][j]);
                                var temp = multipleTableRowArray[i][++j];
                                multipleTableRowFinal.push(temp);
                                j++;
                            }

                        }

                        var tempList = GetUnique(multipleTableRowFinal);
                        for (var y = 0; y < tempList.length; y++) {
                            console.log('----autodoc---100.1------');
                            console.log(tempList[y]);
                            if (tempList[y] != undefined) {
                                var splitString = tempList[y].split("%");
                                aMap[splitString[0]] = aMap[splitString[0]] || [];
                                aMap[splitString[0]].push(splitString[1]);
                            }
                        }
                        for (var key in aMap) {
                            console.log('----autodoc---100.2------');
                            var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                            if (keyTabId == key) {
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var arrayJoin = aMap[key].toString();
                                $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                            }

                        }



                    }

                    if (authorizationFinal != null) {
                        console.log('----autodoc---100.3------');
                        var sectionName = $section.attr("data-auto-doc-section-key");
                        var iterateMap = Object.entries(authorizationFinal);
                        for (var i = 0; i < iterateMap.length; i++) {
                            for (var j = 0; j < iterateMap[i].length;) {
                                if (iterateMap[i][j] == sectionName) {
                                    $section.find(".slds-box").remove();
                                    console.log($section);
                                    $section.append(iterateMap[i][++j]);
                                }
                                j++;
                            }
                            console.log($section);

                        }

                    }

                  $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                    console.log('----autodoc---100.4.0------>' + $section.html);
                    //append section content
					var $secTempClone = $section.clone();
                    if ($section.attr("data-auto-doc") == 'auto' || $secTempClone.attr("data-auto-doc") == 'true' || $secTempClone.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $secTempClone.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                        var sectionHeader = $source.attr("data-auto-doc-section-key");
                        if (sectionHeader != undefined) {
                            var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                            //console.log('----autodoc---100.4.5.0------>'+$tempautodoc.html());
                            $secTempClone.prepend($autodocHeader);
                        }
						
						//var $secTempClone = $section.clone();

                        $autodoc.append($secTempClone);


                        //$autodoc.append($section);
                        //if (($autodoc.find(".autodocTableView") != undefined || $autodoc.find(".autodocPagination") != undefined) && $autodoc.find(".autodocHighlightsPanel") != undefined)
                            //$autodoc.find(".autodocHighlightsPanel").remove();
                        //identifierList = [];

                        console.log('----autodoc---100.4.5------>' + localStorage.getItem("rowCheckHold"));
                        //identifierList.push(localStorage.getItem("rowCheckHold"));



                    }


                }
            }
            });

            //Preview Autoodc
            var autoPrev = $autodoc.clone();
            var identifierListPrev = [];
            var $tempautodocPrev = $("<div></div>");
            var saveddataPrev = [];
            saveddataPrev = JSON.parse(localStorage.getItem(pagefeature));
            if (localStorage.getItem(pagefeature) != null && localStorage.getItem(pagefeature) != undefined) {
                $tempautodocPrev = $(saveddataPrev[0]);
            }
            autoPrev.prepend($tempautodocPrev);
            identifierListPrev.push(autoPrev.html());
            localStorage.setItem(pagefeature, JSON.stringify(identifierListPrev));



            identifierList = [];
            var $tempautodoc = $("<div></div>");
            var saveddata = [];
            saveddata = JSON.parse(localStorage.getItem("rowCheckHold"));

            if (localStorage.getItem("rowCheckHold") != null && localStorage.getItem("rowCheckHold") != undefined) {
                console.log('----autodoc---100.4.5.00------>' + saveddata[0]);
                $tempautodoc = $(saveddata[0]);
            }

            //$autodoc.append($tempautodoc); ---> DE339519 
			$autodoc.prepend($tempautodoc);
            console.log('----autodoc---100.4.5.1------>' + identifierList);
            identifierList.push($autodoc.html());
            console.log('----autodoc---77.04------' + identifierList);
            localStorage.setItem("rowCheckHold", JSON.stringify(identifierList));

            console.log(localStorage.getItem("rowCheckHold"));
            console.log('----autodoc---880------');
        },

        "saveBenefitsAutodocSelections": function (pagefeature, pageid) {
            console.log('save entering');
            console.log(pagefeature);
            if (pageid != undefined)
               pageid = '#' + pageid;
            var tempMapAuthorization = new Map();
            for (var key in rowAuthorizationList) {
                var localVal = '';
                var splitString = rowAuthorizationList[key].split("|");
                if (!tempMapAuthorization.has(splitString[0])) {
                    tempMapAuthorization.set(splitString[0], splitString[1]);
                } else {
                    localVal = tempMapAuthorization.get(splitString[0]) + '' + splitString[1];
                    tempMapAuthorization.set(splitString[0], localVal);
                }
            }
            var tempHTML;
            var tempJQConvert;
            var authorizationFinal = {};
            console.log(tableHeaderMap);
            for (var key in tableHeaderMap) {
                if (tableHeaderMap[key] != null || tableHeaderMap[key] != undefined) {
                    tempHTML = tableHeaderMap[key];
                    tempJQConvert = $(tempHTML);
                    if (tempMapAuthorization.get(key) != null) {
                        //tempJQConvert.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').append(tempMapAuthorization.get(key));
                        tempJQConvert.find('tbody').append(tempMapAuthorization.get(key))
                    }
                    authorizationFinal[key] = tempJQConvert[0].outerHTML;
                }

            }
            console.log(authorizationFinal);
            var $autodoc = $("<div></div>");

            var $autodocMap = new Map();
            multipleTableRowFinal = [];
            var selSec = "[data-auto-doc-feature='" + pagefeature + "']";
            console.log('----autodoc---77.00------' + selSec);

            var $autodoc = $("<div></div>");

            $("[data-auto-doc='auto'],[data-auto-doc='true']", $(pageid)).each(function () {
                if ($(this).attr('data-auto-doc-feature') == pagefeature) {
					if ($(this).attr('data-auto-doc-autosave') != "false" && $(this).attr('data-auto-doc-autosave') != "auto") {
                    var $source = $(this);
                    var $section = $(this).clone();
                    console.log('----autodoc---91.2------' + $section.html());
                    //fix jquery issue, selected value is not cloned
                    $section.find("input,select,textarea").each(function () {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                        console.log('----autodoc---91.3------');
                    });
                    //remove unchecked fields or rows
                    //if ($section.attr("data-auto-doc") == 'true') {
                    console.log('----autodoc---91.31.1------');
                    //autodoc on header and section details
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                        console.log('----autodoc---91.31.2------');
                        var $table = $(this);
                        $section.find(".autodocHighlightsPanel").addClass("slds-box");
                        $section.find(".expandable").removeClass("slds-hide");
                        //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                        $section.find(".autodocNotTableView").each(function () {
                            console.log('----autodoc---91.31.3------' + $(this).html());

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                                console.log('----autodoc---91.7------');
                                var $tr = $("<tr></tr>");
                                $table.find(".slds-grid").each(function () {
                                    console.log('----autodoc---91.8------');
                                    $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function() {
                                        if ($tr.children().length == 4) {
                                            $table.append($tr);
                                            $tr = $("<tr></tr>");
                                            console.log('----autodoc---91.9------');
                                        }
                                        $tr.append($(this).parent().clone());
                                        $tr.append($(this).parent().next().clone());
                                        console.log('----autodoc---91.91------');
                                    });
                                    $(this).remove();
                                });
                                $table.append($tr);
                            } else {

                                console.log('----autodoc---91.31.3.0------' + $section.find(".autodocNotTableView").find("input:checkbox:checked").length);

                                if ($section.find(".autodocNotTableView").find("input:checkbox:checked").length > 0) {
                                    console.log('----autodoc---91.31.3.1------' + $(this).find(".autodocNotTableView").find(".slds-col_bump-right"));
                                    if ($section.find(".autodocNotTableView").find(".slds-col_bump-right").html() != undefined) {
                                        $section.find(".autodocNotTableView").find(".slds-col_bump-right").removeClass("slds-col_bump-right");
                                    }
                                    if ($section.find(".autodocNotTableView").find(".slds-col_bump-left").html() != undefined) {
                                        $section.find(".autodocNotTableView").find(".slds-col_bump-left").removeClass("slds-col_bump-left");
                                    }
                                    var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                                    console.log('----autodoc---91.72------' + $chks.html());

                                    $chks.closest(".slds-p-around_xx-small, .card_element_bottom_margin, .autodocField").remove();
                                    console.log('----autodoc---91.72.0001------' + $chks.find(".autodocNotTableView").find("input:checkbox:checked").length);
                                    console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                    //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                } else {
                                    $section = $("<div></div>");
                                }
                            }
                        });

                        $section.find(".slds-table, .autodocPagination").each(function () {

                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                console.log('----autodoc---91.71------' + $(this).html());
                                var $tr = $("<tr></tr>");
                                //$section.find(".autodoc").each(function() {
                                console.log('----autodoc---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
                                if ($(this).find("input:checkbox:checked").length > 0) {

                                    $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                        /**if ($tr.children().length == 4) {
                                                $table.append($tr);
                                                $tr = $("<tr></tr>");
                                                console.log('----autodoc---91.9------');
                                            }**/
                                        //$tr.append($(this).parent().clone());
                                        //$tr.append($(this).parent().next().clone());
                                        $tr = $(this);
                                        console.log('----autodoc---91.91.1------' + $tr.html());
                                        $tr.closest(".slds-hint-parent").remove();

                                    });
                                } else {
                                    $section = $("<div></div>");
                                }
                                //$(this).remove();
                                //});
                                console.log('----autodoc---91.711------' + $section.html());
                                //$table.append($tr);

                            } else if ($table.find(".autodocPagination").length > 0) {
                                console.log("-----currTableId=======>" + $table.html());
                                var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                console.log("============$currTableId=======>" + $currTableId);
                                $table.find(".autodocPagination").find("tbody").empty();
                                var autoDocData = $("<tr></tr>");

                                if ($paginationMultipleTableMap != undefined && $currTableId != undefined && $paginationMultipleTableMap.has($currTableId)) {
                                    /**var pagiTableData = $paginationMultipleTableMap.get($currTableId).values();
                                    for (var i = 0; i < pagiTableData.length; i++) {
                                        console.log("============value=======>" + pagiTableData[i]);
                                        var clonedItem = pagiTableData[i];
                                        autoDocData.append(clonedItem);
                                    }**/
                                    function logMapElements(value, key, map) {
                                        console.log("============value=======>" + value);
                                        var clonedItem = value;
                                        autoDocData.append(clonedItem);
                                    }

                                    $paginationMultipleTableMap.get($currTableId).forEach(logMapElements);

                                    $table.find(".autodocPagination").find("tbody").append(autoDocData.html());
                                    $section = $table;
                                }



                            }
                        });

                    } else {
                        console.log('----autodoc---91.92------');
                        //autodoc on header only, clear whole section if header is not checked on
                        $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                            $(this).parent().parent().html('');
                            console.log('----autodoc---91.92.1------');
                        });
                    }
                    //}

                    //hide sheveron icon and expand section if section is collapsed
                    $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
                    $section.find(".slds-box").show();

                    //Hide duplicate headers when creating document - Sanka US2038277
                    $section.find(".slds-text-heading_small").hide();

                    //remove input required class
                    $section.find(".requiredBlock").remove();
                    $section.find(".requiredInput").removeClass("requiredInput");

                    //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
                    $section.find(".slds-card__body").find(".checkImg").remove();

                    //remove auto generagted element for autodoc
                  $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                    //exclude element with autodoc equals false
                    $section.find("[data-auto-doc-item='false']").remove();

                    //remove all script tags
                    $section.find("script").remove();

                    console.log('----autodoc---91.92.2------' + $section.html());
                    //convert input field into text node
                    $section.find("input,select,textarea").each(function () {
                        console.log('----autodoc---91.93------');
                        if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                console.log('----autodoc---91.94------');
                                if ($(this).is(":checked")) {
                                    console.log('----autodoc---91.95------');
                                    $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                } else {
                                    console.log('----autodoc---91.96------');
                                    $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                }
                            } else {
                                if ($(this).is("select")) {
                                    console.log('----autodoc---91.97------');

                                    var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                    strData = strData.replace('::after', '');
                                    //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                    $(this).replaceWith(strData);
                                } else {
                                    console.log('----autodoc---91.98------');
                                    $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                }
                            }
                        }
                    });

                    if (localStorage.getItem("table") != null) {
                        console.log('----autodoc---91.99------');
                        var arrColIndexes = [];
                        var identifierList = [];
                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                        var aMap = {};
                        var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                        for (var i = 0; i < multipleTableRowArray.length; i++) {
                            console.log('----autodoc---100------');
                            for (var j = 0; j < multipleTableRowArray[i].length;) {
                                identifierList.push(multipleTableRowArray[i][j]);
                                var temp = multipleTableRowArray[i][++j];
                                multipleTableRowFinal.push(temp);
                                j++;
                            }

                        }

                        var tempList = GetUnique(multipleTableRowFinal);
                        for (var y = 0; y < tempList.length; y++) {
                            console.log('----autodoc---100.1------');
                            console.log(tempList[y]);
                            if (tempList[y] != undefined) {
                                var splitString = tempList[y].split("%");
                                aMap[splitString[0]] = aMap[splitString[0]] || [];
                                aMap[splitString[0]].push(splitString[1]);
                            }
                        }
                        for (var key in aMap) {
                            console.log('----autodoc---100.2------');
                            var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                            if (keyTabId == key) {
                                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                                var arrayJoin = aMap[key].toString();
                                $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                            }

                        }



                    }

                    if (authorizationFinal != null) {
                        console.log('----autodoc---100.3------');
                        var sectionName = $section.attr("data-auto-doc-section-key");
                        var iterateMap = Object.entries(authorizationFinal);
                        for (var i = 0; i < iterateMap.length; i++) {
                            for (var j = 0; j < iterateMap[i].length;) {
                                if (iterateMap[i][j] == sectionName) {
                                    $section.find(".slds-box").remove();
                                    console.log($section);
                                    $section.append(iterateMap[i][++j]);
                                }
                                j++;
                            }
                            console.log($section);

                        }

                    }

                  $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

                    console.log('----autodoc---100.4.0------>' + $section.html);
                    //append section content

                    if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                        var sectionHeader = $source.attr("data-auto-doc-section-key");
                        if (sectionHeader != undefined) {
                            var $autodocHeader = $("<div class='slds-page-header' style='border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                            //console.log('----autodoc---100.4.5.0------>'+$tempautodoc.html());
                            $section.prepend($autodocHeader);
                        }

                        $autodoc.append($section);
                        //if (($autodoc.find(".autodocTableView") != undefined || $autodoc.find(".autodocPagination") != undefined) && $autodoc.find(".autodocHighlightsPanel") != undefined)
                            //$autodoc.find(".autodocHighlightsPanel").remove();
                        //identifierList = [];

                        console.log('----autodoc---100.4.5------>' + localStorage.getItem("rowCheckHold"));
                        //identifierList.push(localStorage.getItem("rowCheckHold"));



                    }


                }
            }
            });

            //Preview Autoodc
            var autoPrev = $autodoc.clone();
            var identifierListPrev = [];
            var $tempautodocPrev = $("<div></div>");
            var saveddataPrev = [];
            saveddataPrev = JSON.parse(localStorage.getItem(pagefeature));
            if (localStorage.getItem(pagefeature) != null && localStorage.getItem(pagefeature) != undefined) {
                $tempautodocPrev = $(saveddataPrev[0]);
            }
            autoPrev.prepend($tempautodocPrev);
            identifierListPrev.push(autoPrev.html());
            localStorage.setItem(pagefeature, JSON.stringify(identifierListPrev));



            identifierList = [];
            var $tempautodoc = $("<div></div>");
            var saveddata = [];
            saveddata = JSON.parse(localStorage.getItem("rowCheckHold"));

            if (localStorage.getItem("rowCheckHold") != null && localStorage.getItem("rowCheckHold") != undefined) {
                console.log('----autodoc---100.4.5.00------>' + saveddata[0]);
                $tempautodoc = $(saveddata[0]);
            }

            $autodoc.append($tempautodoc);
            console.log('----autodoc---100.4.5.1------>' + identifierList);
            identifierList.push($autodoc.html());
            console.log('----autodoc---77.04------' + identifierList);
            localStorage.setItem("rowCheckHold", JSON.stringify(identifierList));

            console.log(localStorage.getItem("rowCheckHold"));
            console.log('----autodoc---880------');
        },

        "initAutodocSelections": function (pageid) {
            console.log('----autodoc---88------');
            var multiplePagesCheck = $("[data-auto-doc-multiple-pages='true']", $('#' + pageid));
            //alert('-----MP-3----'+multiplePagesCheck.html());
            if (multiplePagesCheck.html() != undefined) {
                if (pageid != undefined)
                    pageid = '.' + pageid;
                var $paginationsection = $("[data-auto-doc-pagination='true']", $(pageid));


                $paginationsection.each(function () {
                    var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                    var $tableId = $(this).find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                    if ($paginationMultipleTableKeyMap.has($tableId)) {

                        $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                            if (uniqueIds != undefined) {
                                var uniqueKey;
                                var IdList;
                                if (uniqueIds.indexOf(",") != -1)
                                    IdList = uniqueIds.split(",");
                                if (IdList.length > 0) {
                                    for (var i = 0; i < IdList.length; i++) {
                                        var keyStr = "td:eq(" + IdList[i] + ")";
                                        if (uniqueKey != undefined) {
                                            uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                        } else {
                                            uniqueKey = $(this).find(keyStr).text();
                                        }
                                    }
                                }
                                if ($paginationMultipleTableKeyMap.get($tableId).includes(uniqueKey)) {
                                    $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                                    var resKey = $tableId + "-" + uniqueKey;
                                    if (adResolvedList.includes(resKey)) {
                                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", true);
                                    } else {
                                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", false);
                                    }

                                }
                            }
                            /**
                            if (retrieveDat.indexOf(identifier) > -1) {
                                $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                                $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                            }
                            **/
                            /*	if(typeof acet.autodoc.selectedItems[identifier] != undefined){
                                $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                              } */
                        });
                    }
                });
            } else {
                if (pageid != undefined)
                    pageid = '#' + pageid;
                var $paginationsection = $("[data-auto-doc-pagination='true']", $(pageid));


                $paginationsection.each(function () {
                    var uniqueIds = $(this).attr("data-auto-doc-uniqueids");
                    var $tableId = $(this).find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                    if ($paginationMultipleTableKeyMap.has($tableId)) {

                        $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                            if (uniqueIds != undefined) {
                                var uniqueKey;
                                var IdList;
                                if (uniqueIds.indexOf(",") != -1)
                                    IdList = uniqueIds.split(",");
                                if (IdList.length > 0) {
                                    for (var i = 0; i < IdList.length; i++) {
                                        var keyStr = "td:eq(" + IdList[i] + ")";
                                        if (uniqueKey != undefined) {
                                            uniqueKey = uniqueKey + "-" + $(this).find(keyStr).text();
                                        } else {
                                            uniqueKey = $(this).find(keyStr).text();
                                        }
                                    }
                                }
                                if ($paginationMultipleTableKeyMap.get($tableId).includes(uniqueKey)) {
                                    $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                                    var resKey = $tableId + "-" + uniqueKey;
                                    if (adResolvedList.includes(resKey)) {
                                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", true);
                                    } else {
                                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", false);
                                    }

                                }
                            }
                            /**
                            if (retrieveDat.indexOf(identifier) > -1) {
                                $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                                $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                            }
                            **/
                            /*	if(typeof acet.autodoc.selectedItems[identifier] != undefined){
                                $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                              } */
                        });
                    }
                });
            }
        },

        "createCommentsbox": function(sf_id, commentclass) {
            var divId = sf_id;
            var commSec = divId + "autodocComments";
            var commContainer = commSec + "Container";
            var autodocCommentsFooter = commContainer + "Footer";
            var commbtnMinimize = divId + "btnMinimize";
            var autodocCommentsHeader = commContainer + "Header";
            var html = '<div id="'+commContainer+'" data-autodoc-comments="true" style="position:fixed;border-radius: 5px;bottom:40px;right:0;width:400px;height:135px;background-color:#F2F3F5;padding-left:2px;padding-right:2px;border:2px solid #99AAD3;z-index:1000;">' +
                '<div id="'+autodocCommentsHeader+'" style="cursor:move;width:100%;height:30px;background-color:#F2F3F5;padding-top:4px;">' +
                '<div style="float:left;">' +
                '<img src="/resource/1582515837000/ACETLGT_CommentIcon" style="vertical-align:middle;margin-right:2px;"/>' +
                '<span style="font-family: Salesforce Sans, Arial, sans-serif;">Comments</span>' +
                '</div>' +
                '<div style="float:right;">' +
                '<img id="'+commbtnMinimize+'" src="/resource/1582515674000/ACETLGT_minimizeButton" />' +
                '</div>' +
                '</div>' +
                '<textarea id="'+commSec+'" class="'+commentclass+'" style="width:100%;height:95px;overflow:auto;border:none;z-index: 1;"></textarea>' +
                '<div id="'+autodocCommentsFooter+'" style="cursor:move;width:100%;height:5px;background-color:#F2F3F5;bottom:0" />' +
                '</div>';

            $("#"+divId).append(html);
            /**
            $("#autodocCommentsContainer").draggable({
                create: function(event, ui){
                    //fix for IE, does not work when left and top is auto
                    $("#autodocCommentsContainer").css('left', $(window).width() - $(this).width() - 25 + 'px');
                    $("#autodocCommentsContainer").css('top', $(window).height() - $(this).height() - 4 + 'px');
                }
            }).resizable({
                handles: "n, e, s, w, ne, se, sw, nw"
            });
            **/
            var timer;
            $("#"+commSec).keyup(function(e) {
                //alert("---1---");
                clearTimeout(timer);
                //alert("---2---");
                var commVal = $(this).val();
            	timer = setTimeout(function() {
                //alert("---3---");


                    //alert("------");
                    $("."+commentclass, $("[data-autodoc-comments='true']")).each(function() {
                        //alert("+++"+ $(this).val());
                        //alert("++----+"+ e.val());
                        //$(this).value = e.value;
                        $(this).val(commVal);
                    });
                }, 1000);
            });
            var commValue;
            $("."+commentclass, $("[data-autodoc-comments='true']")).each(function() {
                        //alert("+++"+ $(this).val());
                        //alert("++----+"+ e.val());
                        //$(this).value = e.value;
                        if($(this).val() != undefined && $(this).val() != '')
                        	commValue = $(this).val();
                		if(commValue != undefined && commValue != '' )
                        	$(this).val(commValue);
                    });

            $("#"+commSec).on('resize', function(event, ui) {
                $("#"+commContainer).height(ui.size.height + 35);
                $("#"+commContainer).width(ui.size.width);
                //ui.size.height = Math.max(51, ui.size.height);
                //ui.size.width = Math.max(150, ui.size.width);
            });

            dragElement(document.getElementById(commContainer));

            function dragElement(elmnt) {
                var pos1 = 0,
                    pos2 = 0,
                    pos3 = 0,
                    pos4 = 0,
                    initialTop;
              if (elmnt != null && elmnt != undefined && document.getElementById(elmnt.id + "Header")) {
                /* if present, the header is where you move the DIV from:*/
                document.getElementById(elmnt.id + "Header").onmousedown = dragMouseDown;
                document.getElementById(elmnt.id + "Footer").onmousedown = dragMouseDown;
              } else if(elmnt != null && elmnt != undefined)  {
                /* otherwise, move the DIV from anywhere inside the DIV:*/
                elmnt.onmousedown = dragMouseDown;
              }

              function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                // get the mouse cursor position at startup:
                pos3 = e.clientX;
                pos4 = e.clientY;
                  if(initialTop == undefined || initialTop == null) {
                      initialTop = e.clientY;
                  }
                document.onmouseup = closeDragElement;
                // call a function whenever the cursor moves:
                document.onmousemove = elementDrag;
              }

              function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                // calculate the new cursor position:
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;

                  //	DE335967 : Madhura 6/30/2020
                  //	Checking for browsers
                  var ua = window.navigator.userAgent;
				  var trident = ua.indexOf('Trident/');
                  var msie = ua.indexOf('MSIE ');

                  var topPx = elmnt.offsetTop - pos2;
                  var leftPx = elmnt.offsetLeft - pos1;
                  var maxLeftPx = screen.width/window.devicePixelRatio - 400;
                  var maxTopPx = initialTop/window.devicePixelRatio;

                  if(msie > 0 || trident > 0) { //	IE browsers
                      maxLeftPx = screen.width - 400;
                  	  maxTopPx = initialTop;
                  }

                  //	DE335967 : Madhura : 6/30/3030 : avoid the comment box getting dragged beyond the screen
                  var minTopPx = 0;
                  var minLeftPx = 0;
                  if(topPx > minTopPx && leftPx > minLeftPx && leftPx < maxLeftPx && topPx < initialTop ) {
                      // set the element's new position:
                      elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
                      elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
                  }
              }

              function closeDragElement() {
                /* stop moving when mouse button is released:*/
                document.onmouseup = null;
                document.onmousemove = null;
              }
            }
            /**
            $("#"+commContainer).draggable({
                start: function(event, ui) {
                  alert("-1->"+ ui.position.top);
                  console.log("Drag started of item with id: " + ui.helper[0].id);
                },
                stop: function(event, ui) {
                  console.log("Drag ended of item with id: " + ui.helper[0].id);
                }
            });
            **/
            //$("#"+commContainer).draggable();
            /**
            $("#"+commContainer).on("drag", function(event, ui) {
                alert("-->");
                if (ui.position.top + $(this).height() > $(window).height()) {
                    ui.position.top = $(window).height() - $(this).height();
                }

                if (ui.position.left + $(this).width() > $(window).width()) {
                    ui.position.left = $(window).width() - $(this).width();
                }
            });
    		**/
            $("#"+commbtnMinimize).on('click', function() {
                //$("#autodocCommentsContainer").resizable("disable").draggable("disable");
                //$("#autodocCommentsContainer").attr("bottom",0);
                //alert(">>>");
                $("#"+commContainer).height(28);
                $("#"+commSec).height(0);
                $("#"+autodocCommentsFooter).height(0);
                $("#"+commContainer).css('left', 'auto');
                $("#"+commContainer).css('top', 'auto');
                $("#"+commContainer).css("bottom", '40px');
                $("#"+commContainer).css('right', '0px');

            });

            $("#"+autodocCommentsHeader).on('dblclick', function() {
                //alert("==>>"+ $("#"+commSec).height());
                if ($("#"+commSec).height() == 0) {
                    //$("#autodocCommentsContainer").resizable("enable").draggable("enable");
                    $("#"+commContainer).height(175);
                    $("#"+commSec).height(130);
                    $("#"+autodocCommentsFooter).height(5);
                    //$("#autodocCommentsContainer").css("bottom",'40px');
                    $("#"+commContainer).css('left', $(window).innerWidth() - $("#"+commContainer).width() - 9 + 'px');
                    $("#"+commContainer).css('top', $(window).innerHeight() - $("#"+commContainer).height() - 4 + 'px');

                    //$("#autodocCommentsContainer").css('right', '0px');
                } else {
                    //$("#autodocCommentsContainer").resizable("disable").draggable("disable");
                    $("#"+commContainer).height(28);
                    $("#"+commSec).height(0);
                    $("#"+autodocCommentsFooter).height(0);
                    //$("#autodocCommentsContainer").css('left', $(window).width() - $(this).width() + 'px');
                    //$("#autodocCommentsContainer").css('top', $(window).height() - $(this).height() + 'px');
                    $("#"+commContainer).css('left', 'auto');
                    $("#"+commContainer).css('top', 'auto');
                    $("#"+commContainer).css("bottom", '40px');
                    $("#"+commContainer).css('right', '0px');

                }
            });

            //do not invoke page action when the focus is in comment box and enter key is pressed
            $("#"+commSec).keypress(function(e) {
                if (e.which == 13) {
                    e.stopPropagation();
                }
        	});

		}
    };

    function startDragging(){
        //alert("-1->"+ ui.position.top);
                if (ui.position.top + $(this).height() > $(window).height()) {
                    ui.position.top = $(window).height() - $(this).height();
                }

                if (ui.position.left + $(this).width() > $(window).width()) {
                    ui.position.left = $(window).width() - $(this).width();
                }
    }

    function getSubTabIdMethodOnCheckboxSelection() {
        //First find the ID of the current tab to close it
        //sforce.console.getEnclosingTabId(getIdSubTab);
    }

    var getIdSubTab = function getIdSubTab(result) {
        console.log('----autodoc---getIdSubTab------');
        //Now that we have the tab ID, we can close it
        var sbTbIdInfo = result.id;
        globalVar = sbTbIdInfo;
        localStorage.setItem("subTabIdInfo", sbTbIdInfo);

    };

    acet.autodoc.saveAuthorizationSection = function () {
        console.log('----autodoc---55------');
        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
        var $autodoc = $("<div></div>");
        $("[data-auto-doc-section-key]").each(function () {

            var sectionName = $(this).attr("data-auto-doc-section-key");
            $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                var arrColIndexes = [];
                $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    arrColIndexes.push(parseInt(e));
                });
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {

                    var rowCloneVar = sectionName;
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        var $rowClone = $(this).clone();
                        $rowClone.find("input,select,textarea").each(function () {
                            if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                    if ($(this).is(":checked")) {
                                        $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                    } else {
                                        $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                    }
                                } else {
                                    if ($(this).is("select")) {
                                        //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                        $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                    } else {
                                        $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                    }
                                }
                            }
                        });
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }

                        identifier = globalVar + '|' + identifier;
                        rowAuthorizationList[identifier] = sectionName + '|' + $rowClone.closest('tr')[0].outerHTML;
                        console.log(rowAuthorizationList);
                        identifierList.push(identifier);
                        console.log("identifierList..." + identifierList);
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        var $rowClone = $(this).clone();
                        $rowClone.find("input,select,textarea").each(function () {
                            if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                    if ($(this).is(":checked")) {
                                        $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                    } else {
                                        $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                    }
                                } else {
                                    if ($(this).is("select")) {
                                        //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                        $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                    } else {
                                        $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                    }
                                }
                            }
                        });
                        identifier = globalVar + '|' + identifier;
                        if (rowAuthorizationList.hasOwnProperty(identifier)) {
                            delete rowAuthorizationList[identifier];
                        }
                        console.log(rowAuthorizationList);
                        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
                        if (identifierList.indexOf(identifier) > -1) {
                            identifierList.splice(identifierList.indexOf(identifier), 1);
                            acet.autodoc.selectedItems.splice(acet.autodoc.selectedItems.indexOf[identifier], 1);
                            localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        }
                    }

                });
            });


        });

    };

    acet.autodoc.getPaginationData = function ($checkedRow, tableId) {
        console.log('----autodoc---P.5------');
        multipleTableRowList = JSON.parse(localStorage.getItem("table")) || [];
        console.log(multipleTableRowList);
        for (var i = 0; i < multipleTableRowList.length; i++) {
            for (var j = 0; j < multipleTableRowList[i].length;) {
                $removeDuplicatesOnCaseObject[multipleTableRowList[i][j]] = multipleTableRowList[i][++j];
                j++;
            }
        }
        console.log($removeDuplicatesOnCaseObject);
        $("[data-auto-doc-section-key]").each(function () {
            console.log('-----autodoc----P.6------');
            var setAttributeTabId = $(this).find(".enablePagination");
            setAttributeTabId.attr("auto-doc-section-tabid", globalVar);
            var sectionName = $(this).attr("data-auto-doc-section-key");
            $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                console.log('-----autodoc----P.7------');
                var arrColIndexes = [];
                $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    console.log('-----autodoc----P.8------');
                    arrColIndexes.push(parseInt(e));
                });
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                    console.log('-----autodoc----P.9------');
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            console.log('-----autodoc----P.10------');
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        if (globalVar != '' || globalVar != undefined) {
                            identifier = globalVar + '|' + identifier;
                        }
                        console.log("identifier......" + identifier);
                        var $rowClone = $(this).clone();
                        $rowClone.find("input,select,textarea").each(function () {
                            console.log('-----autodoc----P.11------');
                            if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                                if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                    if ($(this).is(":checked")) {
                                        console.log('-----autodoc----P.12------');
                                        $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                    } else {
                                        console.log('-----autodoc----P.13------');
                                        $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                    }
                                } else {
                                    console.log('-----autodoc----P.14------');
                                    if ($(this).is("select")) {
                                        //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                        $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                                    } else {
                                        $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                    }
                                }
                            }
                        });
                        if (!$removeDuplicatesOnCaseObject.hasOwnProperty(identifier)) {
                            console.log('-----autodoc----P.15------');
                            $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                        } else {
                            delete $removeDuplicatesOnCaseObject[identifier];
                            $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                        }
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                        console.log(localStorage.getItem("table"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                        console.log('-----autodoc----P.16------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        if (globalVar != '' || globalVar != undefined) {
                            identifier = globalVar + '|' + identifier;
                        }
                        if ($removeDuplicatesOnCaseObject.hasOwnProperty(identifier)) {
                            delete $removeDuplicatesOnCaseObject[identifier];
                            localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                        }
                    }
                    console.log('-----autodoc----P.17------');
                });

            });
        });

    };
    acet.autodoc.saveAutodocSaveAccums = function () {
        console.log('----autodoc---77------');
        var $sectionFinalList = [];
        var accumAsOfSave = $("[id$='accumsdateSearch']").val();
        var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + $("[id$='grpEligDateId']").val();

        $("[data-auto-doc='true']").each(function () {
            var $source = $(this);
            var $section = $(this).clone();

            $section.find("input,select,textarea").each(function () {
                $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
            });
            $sectionFinal = '';
            if ($section.attr("auto-doc") == 'true') {
                if (!($section.attr("auto-doc-header-only") == 'true')) {
                    $section.find(".slds-box").find(".slds-card__body").each(function () {
                        var $table = $(this);
                        //reorder fields in page block section
                        if ($table.find(".slds-table, .autodocPagination, .auto-doc-list").length == 0) {
                            var $tr = $("<tr></tr>");
                            $table.find("tr").each(function () {
                                $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                    if ($tr.children().length == 4) {
                                        $table.append($tr);
                                        $tr = $("<tr></tr>");
                                    }
                                    $tr.append($(this).parent().clone());
                                    $tr.append($(this).parent().next().clone());
                                });
                                $(this).remove();
                            });
                            $table.append($tr);
                        } else {
                            //page block table, remove unchecked rows
                            var $chks = $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
                            $chks.closest("tr").remove();

                        }
                    });
                } else {
                    //autodoc on header only, clear whole section if header is not checked on
                    $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                        $(this).parent().parent().html('');
                    });
                }
            }
            console.log($section.html());
            //hide sheveron icon and expand section if section is collapsed
            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
            $section.find(".slds-box").show();

            //remove input required class
            $section.find(".requiredBlock").remove();
            $section.find(".requiredInput").removeClass("requiredInput");

            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
            $section.find(".slds-box").find(".slds-card__body").find(".checkImg").remove();
            //$section.find(".slds-box").find(".slds-card__body").find("tbody tr:first").remove();
            //exclude element with autodoc equals false
            $section.find("[auto-doc-item='false']").remove();
            //remove all script tags
            $section.find("script").remove();
            //remove auto generagted element for autodoc
            $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });
            //convert input field into text node
            $section.find("input,select,textarea").each(function () {
                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                        if ($(this).is(":checked")) {
                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                        } else {
                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                        }
                    } else {
                        if ($(this).is("select")) {
                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                            $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                        } else {
                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                        }
                    }
                }
            });
            $section.find(".tertiaryPalette").remove();
            if (accumAsOfSave != '' && accumAsOfSave != undefined) {
                $sectionFinal = accumAsOfSave + '|' + $section.html();
            } else {
                $sectionFinal = grpEligPopulation + '|' + $section.html();
            }
            console.log($sectionFinal);

        });
        $sectionFinalList.push($sectionFinal);
        localStorage.setItem("localAccumsData", $sectionFinalList);

    };
    acet.autodoc.saveAutodocSelections = function () {
        console.log('----autodoc---77------');
        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
        var $autodoc = $("<div></div>");
        var accumAsOfSave = $("[id$='accumsdateSearch']").val();
        var grpEligPopulation = '';
        if ($("[id$='grpEligPopulationId']").val() != undefined && $("[id$='grpEligDateId']").val() != undefined) {
            var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + '|' + $("[id$='grpEligDateId']").val();
        }
        //var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + $("[id$='grpEligDateId']").val();
        $("[data-auto-doc-section-key]").each(function () {
            var sectionName = $(this).attr("data-auto-doc-section-key");
            console.log('----autodoc---77.1------');
            $(this).find("[data-auto-doc-section-column-indexes]").addBack().each(function () {
                var arrColIndexes = [];
                console.log('----autodoc---77.2------');
                $(this).attr("data-auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    arrColIndexes.push(parseInt(e));
                    console.log('----autodoc---77.3------>');
                });
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    console.log('----autodoc---77.4------');
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        console.log('----autodoc---77.5------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        if (accumAsOfSave != '' && accumAsOfSave != undefined && sectionName != "pbsec1") {
                            identifier = accumAsOfSave + '|' + identifier;
                        } else if (grpEligPopulation != '' && grpEligPopulation != undefined && sectionName != "pbsec1") {
                            identifier = grpEligPopulation + '|' + identifier;
                        } else {
                            identifier = globalVar + '|' + identifier;
                        }
                        console.log("identifier......2" + identifier);
                        identifierList.push(identifier);
                        console.log(identifierList);
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        console.log(localStorage.getItem("rowCheckHold"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                        console.log('----autodoc---77.6------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        if (accumAsOfSave != '' && accumAsOfSave != undefined && sectionName != "pbsec1") {
                            identifier = accumAsOfSave + '|' + identifier;
                        } else if (grpEligPopulation != '' && grpEligPopulation != undefined && sectionName != "pbsec1") {
                            identifier = grpEligPopulation + '|' + identifier;
                        } else {
                            identifier = globalVar + '|' + identifier;
                        }
                        //console.log("identifier......"+identifier);
                        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
                        if (identifierList.indexOf(identifier) > -1) {
                            identifierList.splice(identifierList.indexOf(identifier), 1);
                            localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        }

                    }

                });
                console.log('----autodoc---77.31------' + JSON.stringify($(this).html()));
                $(this).find(".autodocNotTableView").each(function () {
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    console.log('----autodoc---77.41------');
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        console.log('----autodoc---77.51------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            console.log('----autodoc---77.511------');
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("div").length) {
                                console.log('----autodoc---77.52------');
                                var $td = $(this).find("div").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("lightning-formatted-text").val() || $td.text());
                                    console.log('----autodoc---77.53------' + JSON.stringify(identifier));
                                }
                            }
                        }
                        if (accumAsOfSave != '' && accumAsOfSave != undefined && sectionName != "pbsec1") {
                            identifier = accumAsOfSave + '|' + identifier;
                        } else if (grpEligPopulation != '' && grpEligPopulation != undefined && sectionName != "pbsec1") {
                            identifier = grpEligPopulation + '|' + identifier;
                        } else {
                            identifier = globalVar + '|' + identifier;
                        }
                        console.log("identifier......2" + identifier);
                        identifierList.push(identifier);
                        console.log(identifierList);
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        console.log(localStorage.getItem("rowCheckHold"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                        console.log('----autodoc---77.6------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                                var $td = $(this).find("td").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                                }
                            }
                        }
                        if (accumAsOfSave != '' && accumAsOfSave != undefined && sectionName != "pbsec1") {
                            identifier = accumAsOfSave + '|' + identifier;
                        } else if (grpEligPopulation != '' && grpEligPopulation != undefined && sectionName != "pbsec1") {
                            identifier = grpEligPopulation + '|' + identifier;
                        } else {
                            identifier = globalVar + '|' + identifier;
                        }
                        //console.log("identifier......"+identifier);
                        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
                        if (identifierList.indexOf(identifier) > -1) {
                            identifierList.splice(identifierList.indexOf(identifier), 1);
                            localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                        }

                    }

                });
            });
        });
        console.log(localStorage.getItem("rowCheckHold"));
        console.log('----autodoc---880------');
    };

    acet.autodoc.initAutodocSelections = function () {
        console.log('----autodoc---88------');
        console.log('----autodoc---2.1------');
        var subTabId = localStorage.getItem("subTabIdInfo");
        console.log(localStorage.getItem("rowCheckHold"));
        var accumAsOfInit = $("[id$='accumsdateSearch']").val();
        var grpEligPopulation = '';
        if ($("[id$='grpEligPopulationId']").val() != undefined && $("[id$='grpEligDateId']").val() != undefined) {
            var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + '|' + $("[id$='grpEligDateId']").val();
        }
        //var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + $("[id$='grpEligDateId']").val();
        $("[data-auto-doc-section-key]").each(function () {
            var sectionName = $(this).attr("data-auto-doc-section-key");
            $(this).find("[data-auto-doc-section-column-indexes]").addBack().each(function () {
                var arrColIndexes = [];
                $(this).attr("data-auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    arrColIndexes.push(parseInt(e));
                });
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children('tbody').children('tr').each(function () {
                    var identifier = sectionName;
                    for (var i = 0; i < arrColIndexes.length; i++) {
                        if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("td").length) {
                            var $td = $(this).find("td").eq(arrColIndexes[i]);
                            if ($td) {
                                identifier = identifier + '|' + ($td.find("input").val() || $td.text());
                            }
                        }
                    }
                    if (accumAsOfInit != '' && accumAsOfInit != undefined && sectionName != "pbsec1") {
                        identifier = accumAsOfInit + '|' + identifier;
                    } else if (grpEligPopulation != '' && grpEligPopulation != undefined && sectionName != "pbsec1") {
                        identifier = grpEligPopulation + '|' + identifier;
                    } else {
                        identifier = globalVar + '|' + identifier;
                    }
                    console.log("identifier......" + identifier);
                    var retrieveDat = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
                    if (retrieveDat.indexOf(identifier) > -1) {
                        $(this).find("input[type='checkbox'].autodoc").prop("checked", true);
                        $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                    }
                    /*	if(typeof acet.autodoc.selectedItems[identifier] != undefined){
                    		$(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", acet.autodoc.selectedItems[identifier]);
                    	} */
                });
            });
        });
    };
    if (!Object.keys) {
        console.log('----autodoc---00------');
        Object.keys = (function () {
            'use strict';
            var hasOwnProperty = Object.prototype.hasOwnProperty,
                hasDontEnumBug = !({
                    toString: null
                }).propertyIsEnumerable('toString'),
                dontEnums = [
                    'toString',
                    'toLocaleString',
                    'valueOf',
                    'hasOwnProperty',
                    'isPrototypeOf',
                    'propertyIsEnumerable',
                    'constructor'
                ],
                dontEnumsLength = dontEnums.length;

            return function (obj) {
                if (typeof obj !== 'function' && (typeof obj !== 'object' || obj === null)) {
                    throw new TypeError('Object.keys called on non-object');
                }

                var result = [],
                    prop, i;

                for (prop in obj) {
                    if (hasOwnProperty.call(obj, prop)) {
                        result.push(prop);
                    }
                }

                if (hasDontEnumBug) {
                    for (i = 0; i < dontEnumsLength; i++) {
                        if (hasOwnProperty.call(obj, dontEnums[i])) {
                            result.push(dontEnums[i]);
                        }
                    }
                }
                return result;
            };
        }());
    }
    if (!Object.entries)
        Object.entries = function (obj) {
            console.log('----autodoc---01------');
            var ownProps = Object.keys(obj),
                i = ownProps.length,
                resArray = new Array(i); // preallocate the Array
            while (i--)
                resArray[i] = [ownProps[i], obj[ownProps[i]]];

            return resArray;
        };
    acet.autodoc.saveStateAutodocOnSearch = function () {
        console.log('----autodoc---99------');
        globalSectionalVar = [];
        console.log(globalSectionalVar);
        if (localStorage.getItem("localAccumsData") != null) {
            var tempVar = (localStorage.getItem("localAccumsData")).split("|");
            if (!globalMap.has(tempVar[0])) {
                globalMap[tempVar[0]] = tempVar[1];
            } else {
                delete globalMap[tempVar[0]];
                globalMap[tempVar[0]] = tempVar[1];
            }
        }
        $globalAccumsList = Object.keys(globalMap).map(function (e) {
            return globalMap[e]
        });
        localStorage.setItem("globalAccumsData", GetUnique($globalAccumsList));
        globalSectionalVar.push(localStorage.getItem("globalAccumsData"));
        //localStorage.setItem("globalAccumsDataFinal",GetUnique(globalSectionalVar));
        console.log(globalSectionalVar);
        localStorage.removeItem("localAccumsData");

    };

    function GetUnique(inputArray) {
        var outputArray = [];
        for (var i = 0; i < inputArray.length; i++) {
            if ((jQuery.inArray(inputArray[i], outputArray)) == -1) {
                outputArray.push(inputArray[i]);
            }
        }
        return outputArray;
    }
    acet.autodoc.saveAutodoc = function () {
        console.log('----autodoc---91------');
        var tempMapAuthorization = new Map();
        for (var key in rowAuthorizationList) {
            var localVal = '';
            var splitString = rowAuthorizationList[key].split("|");
            if (!tempMapAuthorization.has(splitString[0])) {
                tempMapAuthorization.set(splitString[0], splitString[1]);
            } else {
                localVal = tempMapAuthorization.get(splitString[0]) + '' + splitString[1];
                tempMapAuthorization.set(splitString[0], localVal);
            }
        }
        var tempHTML;
        var tempJQConvert;
        var authorizationFinal = {};
        console.log(tableHeaderMap);
        for (var key in tableHeaderMap) {
            if (tableHeaderMap[key] != null || tableHeaderMap[key] != undefined) {
                tempHTML = tableHeaderMap[key];
                tempJQConvert = $(tempHTML);
                if (tempMapAuthorization.get(key) != null) {
                    //tempJQConvert.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').append(tempMapAuthorization.get(key));
                    tempJQConvert.find('tbody').append(tempMapAuthorization.get(key))
                }
                authorizationFinal[key] = tempJQConvert[0].outerHTML;
            }

        }
        console.log(authorizationFinal);
        var $autodoc = $("<div></div>");
        multipleTableRowFinal = [];
        $("[data-auto-doc='auto'],[data-auto-doc='true']").each(function () {
            var $source = $(this);
            var $section = $(this).clone();

            //fix jquery issue, selected value is not cloned
            $section.find("input,select,textarea").each(function () {
                $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
            });

            //remove unchecked fields or rows
            if ($section.attr("auto-doc") == 'true') {
                //autodoc on header and section details
                if (!($section.attr("auto-doc-header-only") == 'true')) {
                    $section.find(".slds-box").find(".slds-card__body").each(function () {
                        var $table = $(this);
                        //reorder fields in page block section
                        if ($table.find(".slds-table, .autodocPagination, .auto-doc-list").length == 0) {
                            var $tr = $("<tr></tr>");
                            $table.find("tr").each(function () {
                                $(this).find("p.autodocFieldName").find("input:checkbox:checked").each(function () {
                                    if ($tr.children().length == 4) {
                                        $table.append($tr);
                                        $tr = $("<tr></tr>");
                                    }
                                    $tr.append($(this).parent().clone());
                                    $tr.append($(this).parent().next().clone());
                                });
                                $(this).remove();
                            });
                            $table.append($tr);
                        } else {
                            var $chks = $table.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
                            $chks.closest("tr").remove();
                        }
                    });
                } else {
                    //autodoc on header only, clear whole section if header is not checked on
                    $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                        $(this).parent().parent().html('');
                    });
                }
            }

            //hide sheveron icon and expand section if section is collapsed
            $section.find(".slds-text-heading_small").find(".showListButton, .hideListButton").hide();
            $section.find(".slds-box").show();

            //remove input required class
            $section.find(".requiredBlock").remove();
            $section.find(".requiredInput").removeClass("requiredInput");

            //console.log('found>>>'+$section.find(".slds-box").find(".slds-card__body").find(".checkImg"));
            $section.find(".slds-card__body").find(".checkImg").remove();

            //remove auto generagted element for autodoc
            $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

            //exclude element with autodoc equals false
            $section.find("[data-auto-doc-item='false']").remove();

            //remove all script tags
            $section.find("script").remove();


            //convert input field into text node
            $section.find("input,select,textarea").each(function () {
                if ($(this).css("display") !== "none" && !$(this).hasClass("autodoc")) {
                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                        if ($(this).is(":checked")) {
                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                        } else {
                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                        }
                    } else {
                        if ($(this).is("select")) {
                            //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                            $(this).replaceWith($source.find("[id='" + $(this).attr("id") + "']").val());
                        } else {
                            $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                        }
                    }
                }
            });

            if (localStorage.getItem("table") != null) {
                var arrColIndexes = [];
                var identifierList = [];
                $section.find(".enablePagination").children().find("table").find("tbody").empty();
                var aMap = {};
                var multipleTableRowArray = JSON.parse(localStorage.getItem("table")) || [];
                for (var i = 0; i < multipleTableRowArray.length; i++) {
                    for (var j = 0; j < multipleTableRowArray[i].length;) {
                        identifierList.push(multipleTableRowArray[i][j]);
                        var temp = multipleTableRowArray[i][++j];
                        multipleTableRowFinal.push(temp);
                        j++;
                    }

                }

                var tempList = GetUnique(multipleTableRowFinal);
                for (var y = 0; y < tempList.length; y++) {
                    console.log(tempList[y]);
                    if (tempList[y] != undefined) {
                        var splitString = tempList[y].split("%");
                        aMap[splitString[0]] = aMap[splitString[0]] || [];
                        aMap[splitString[0]].push(splitString[1]);
                    }
                }
                for (var key in aMap) {
                    var keyTabId = $section.find(".enablePagination").attr("auto-doc-section-combinedkey") + $section.find(".enablePagination").attr("auto-doc-section-tabid");
                    if (keyTabId == key) {
                        $section.find(".enablePagination").children().find("table").find("tbody").empty();
                        var arrayJoin = aMap[key].toString();
                        $section.find(".enablePagination").children().find("table").find("tbody").append(arrayJoin);
                    }

                }



            }

            if (authorizationFinal != null) {
                var sectionName = $section.attr("data-auto-doc-section-key");
                var iterateMap = Object.entries(authorizationFinal);
                for (var i = 0; i < iterateMap.length; i++) {
                    for (var j = 0; j < iterateMap[i].length;) {
                        if (iterateMap[i][j] == sectionName) {
                            $section.find(".slds-box").remove();
                            console.log($section);
                            $section.append(iterateMap[i][++j]);
                        }
                        j++;
                    }
                    console.log($section);

                }

            }

            $section.find(".autodoc").each(function(){
                                console.log('----autodoc---IN-1------'+ $(this).html());
                                console.log('----autodoc---IN-1------'+ $(this).find("input[type='checkbox']").html());
                                if($(this).find("input[type='checkbox']").html() != undefined){
                                    console.log('----autodoc---IN-2------');
                                    $(this).remove();
                                }
                                console.log('----autodoc---IN-3------'+ $section.html());
                            });

            //append section content

            if ($section.attr("auto-doc") == 'auto' || $section.find(".slds-box").find("p.autodocFieldName").length > 0 || $section.find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length > 0) {

                $autodoc.append($section);
            }



        });

        //append additonal autodoc
        if (acet.autodoc.additionalInfo) {
            $autodoc.append(acet.autodoc.additionalInfo);
        }
        //display highlight panel when it is collapsed
        var $span = $autodoc.find(".highlights-panel-collapsible");
        // Replace all the span's with a div
        $span.replaceWith(function () {
            return $('<div/>', {
                class: 'highlights-panel-collapsible',
                html: this.innerHTML
            });
        });
        if (localStorage.getItem("globalAccumsData") != null) {
            globalSectionalVar.push(localStorage.getItem("globalAccumsData"));
            console.log(globalSectionalVar);
            $autodoc.find(".enableSectionAutodoc").remove();
            //var $additionalAccumsSection = localStorage.getItem("globalAccumsData");
            $autodoc.append(GetUnique(globalSectionalVar));
            localStorage.removeItem("globalAccumsData");

        }

        var $additionalAccumsSection = '';
        $autodoc.append("<br/>");
        //Auto-Doc for Benefit codes :start
        //$autodoc.append("<br/><br/>");

        var $acccordianAutoDoc = $("[data-auto-doc-accordian='true']");
        $acccordianAutoDoc.each(function () {
            if ($(this).is(":checkbox")) {
                if ($(this).is(":checked")) {
                    $autodoc.append("<div class='pbSubheader brandTertiaryBgr first tertiaryPalette'><h3>Benefit Details</h3></div>");
                    $autodoc.append("<table cellspacing='10px' width='100%'><tbody><tr><td class='colStyle'><label class='outputLabelPanel'>Benefit As Of</label>" + $("#benefitDateSearch").val() + "</td></tr><tbody></table>");

                    return false;
                }
            }
        });

        $acccordianAutoDoc.each(function () {
            if ($(this).is(":checkbox")) {
                if ($(this).is(":checked")) {
                    $autodoc.append("<li style='margin-left:20px'>" + $(this).val() + "</li>");
                }
            }
        });

        //Auto-Doc for Benefit codes :End
        //assign autodoc content
        $("[id$='autodocHidden']").val($autodoc.html());
        //assign autodoc comment
        $("[id$='autodocCommentHidden']").val($("#autodocComments").val());
        //assign autodoc case item key ids
        $("[id$='autodocCaseItemsHidden']").val(acet.autodoc.getCaseItemInfo($autodoc));
        //$autodoc.find(".enablePagination").find("#datatable").find("tbody").empty();
        return $autodoc.html();
    };

    acet.autodoc.getCaseItemInfo = function ($autodoc) {
        console.log('----autodoc---92------');
        var keyIds = [];
        //dummy case item from call topic section
        $autodoc.find("[data-auto-doc-case-item='true']").each(function () {
            console.log('----autodoc---92------' + $(this).find(".autodocPagination").length);
            if ($(this).find(".autodocPagination").length == 0) {
                var isResolved = $(this).find(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                keyIds.push("::" + isResolved);
                console.log('----autodoc---92.1------');
            }
        });
        $autodoc.find("[data-auto-doc-case-item='true']").each(function () {
            var isResolved = $(this).find(".header-column").first(".valueCls").find(".valueCls").find(".data-auto-first-element").html();
            if (isResolved != undefined) {
                keyIds = [];
                // DE347591 - Thanish - 17th Jul 2020
                //keyIds.push(isResolved + "::" + false);
                //Make default case item true
                keyIds.push(isResolved + "::" + true);
                console.log('----autodoc---92.1.1.2------');
            }

        });


        //case items from call topic search results
        $autodoc.find("[data-auto-doc-case-items='true']").each(function () {
            var idx = 0;
            var idxprovName = 0;
            console.log('----autodoc---92.2------');
            $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("thead").find("tr").find("th").each(function (index) {
                console.log('----autodoc---92.3------');
                if ($(this).text() == 'Tax ID') {
                    console.log('matched');
                    idx = index;
                    console.log('Inside::' + idx);
                } else if ($(this).text() == 'Provider') {
                    console.log('matched provider');
                    idxprovName = index;
                    console.log('Inside::' + idxprovName);
                } else if ($(this).text() == 'Provider ID') {
                    console.log('matched provider: ' + $(this).html());
                    idxprovName = index + 1;
                    //provName + 1 because we want provider name, not provider id, but the header "name" is too generic
                    console.log('Inside::' + idxprovName);

                }
            });
            if (idx != 0 || idxprovName != 0) {
                console.log('----autodoc---92.4------' + idx);
                if (idx != 0) {
                    $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").each(function () {
                        console.log('----autodoc---92.5------' + $(this).html());
                        var adding = '';
                        var taxId = $(this).children().eq(idx).text();
                        console.log('TAX ID ::: ' + taxId);
                        adding = adding + ";;" + taxId;
                        var prov;
                        if (idxprovName != 0) {
                            prov = $(this).children().eq(idxprovName).text();
                            console.log('Provider Name ::: ' + prov);
                            adding = adding + ";;" + prov;
                        }
                        var isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                        if ($.trim($(this).children().first().text()) != undefined && $.trim($(this).children().first().text()) != '')
                            keyIds.push($.trim($(this).children().first().text())+(taxId?';'+taxId:'; ')+(prov?';'+prov:'; ')+ "::" + isResolved); //+ adding +
                    });
                }

            } else {
                console.log('----autodoc---92.6------' + $(this).html());
                console.log('outside::' + idx);
                console.log('outside::' + $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").find("tr").length);
                console.log('outside::' + $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").children("tr").length);
                console.log('outside::' + $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").html());
                $(this).find(".slds-table, .autodocPagination, .auto-doc-list").children("tbody").children("tr").each(function () {
                    // US2644744 - Thanish - 8th Jun 2020
                    var isResolved = true;
                    if($(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") != undefined){
                      	isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                    }
                    keyIds.push($.trim($(this).children().first().text()) + "::" + isResolved);
                    console.log("2nd" + isResolved);

                });
                /**$(this).find(".slds-table, .auto-doc-list").children("tbody").find("tr").each(function() {
                    var isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                    keyIds.push($.trim($(this).children().first().text()) + "::" + isResolved);
                    console.log("3rd" + isResolved);
                });**/
            }
        });
        /**
        var $benefitAutoDoc = $("[data-auto-doc-accordian='true']");


        $benefitAutoDoc.each(function() {
            if ($(this).is(":checkbox")) {
                if ($(this).is(":checked")) {
                    //alert('2 :: '+$(this).val());
                    keyIds.push($(this).val() + "::" + true);
                    localStorage.setItem("benefitCaseItem", JSON.stringify(GetUnique(keyIds)));

                }
            }
        });
        if (localStorage.getItem("benefitCaseItem") != null) {
            var benefitCaseItem_array = [];
            benefitCaseItem_array = JSON.parse(localStorage.getItem("benefitCaseItem"));
            keyIds.push(benefitCaseItem_array.join("||") || []);
        }
        **/
        return keyIds.join("||");
    };


    acet.autodoc.saveAutodocComments = function () {
        console.log('----autodoc---93------');
        //assign autodoc comment
        $("[id$='autodocCommentHidden']").val($("#autodocComments").val());
        return $("#autodocComments").val();
    };

    acet.autodoc.createCommentsbox = function(sf_id) {
        var html = '<div id="autodocCommentsContainer" style="position:fixed;bottom:0;right:0;width:400px;height:130px;background-color:#F2F3F5;padding-left:2px;padding-right:2px;border:3px solid #1460FA;">' +
                '<div id="autodocCommentsHeader" style="width:100%;height:24px;background-color:#F2F3F5;padding-top:4px;">' +
                '<div style="float:left;">' +
                '<img src="/resource/1479166730000/ACETResources/img/comments.png" style="vertical-align:middle;margin-right:2px;"/>' +
                '<span>Comments</span>' +
                '</div>' +
                '<div style="float:right;">' +
                '<img id="btnMinimize" src="/resource/1479166730000/ACETResources/img/minimize.png" />' +
                '</div>' +
                '</div>' +
                '<textarea id="'+sf_id+'autodocComments" style="width:100%;height:82px;overflow:auto;border:none;"/>' +
                '<div id="autodocCommentsFooter" style="width:100%;height:5px;background-color:#F2F3F5;bottom:0" />' +
                '</div>';
    		var divId = "#"+sf_id;
            $(divId).append(html);

            /**
            $("#autodocCommentsContainer").draggable({
                create: function(event, ui){
                    //fix for IE, does not work when left and top is auto
                    $("#autodocCommentsContainer").css('left', $(window).width() - $(this).width() - 25 + 'px');
                    $("#autodocCommentsContainer").css('top', $(window).height() - $(this).height() - 4 + 'px');
                }
            }).resizable({
                handles: "n, e, s, w, ne, se, sw, nw"
            });
            **/
            $("#autodocCommentsContainer").on("resize", function(event, ui) {
                $("#autodocComments").height(ui.size.height - 51);
                ui.size.height = Math.max(51, ui.size.height);
                ui.size.width = Math.max(150, ui.size.width);
            });

            $("#autodocCommentsContainer").on("drag", function(event, ui) {
                if (ui.position.top + $(this).height() > $(window).height()) {
                    ui.position.top = $(window).height() - $(this).height();
                }

                if (ui.position.left + $(this).width() > $(window).width()) {
                    ui.position.left = $(window).width() - $(this).width();
                }
            });

            $("#btnMinimize").on('click', function() {
                //$("#autodocCommentsContainer").resizable("disable").draggable("disable");
                //$("#autodocCommentsContainer").attr("bottom",0);
                $("#autodocCommentsContainer").height(28);
                $("#autodocComments").height(0);
                $("#autodocCommentsFooter").height(0);
                $("#autodocCommentsContainer").css('left', 'auto');
                $("#autodocCommentsContainer").css('top', 'auto');
                $("#autodocCommentsContainer").css("bottom", '35px');
                $("#autodocCommentsContainer").css('right', '0px');

            });

            $("#autodocCommentsHeader").on('dblclick', function() {
                if ($("#autodocComments").height() == 0) {
                    //$("#autodocCommentsContainer").resizable("enable").draggable("enable");
                    $("#autodocCommentsContainer").height(130);
                    $("#autodocComments").height(82);
                    $("#autodocCommentsFooter").height(20);
                    $("#autodocCommentsContainer").css('left', $(window).innerWidth() - $("#autodocCommentsContainer").width() - 10 + 'px');
                    $("#autodocCommentsContainer").css('top', $(window).innerHeight() - $("#autodocCommentsContainer").height() - 4 + 'px');
                    //$("#autodocCommentsContainer").css("bottom",'0px');
                    //$("#autodocCommentsContainer").css('right', '0px');
                } else {
                    //$("#autodocCommentsContainer").resizable("disable").draggable("disable");
                    $("#autodocCommentsContainer").height(28);
                    $("#autodocComments").height(0);
                    $("#autodocCommentsFooter").height(0);
                    //$("#autodocCommentsContainer").css('left', $(window).width() - $(this).width() + 'px');
                    //$("#autodocCommentsContainer").css('top', $(window).height() - $(this).height() + 'px');
                    $("#autodocCommentsContainer").css('left', 'auto');
                    $("#autodocCommentsContainer").css('top', 'auto');
                    $("#autodocCommentsContainer").css("bottom", '35px');
                    $("#autodocCommentsContainer").css('right', '0px');

                }
            });

            //do not invoke page action when the focus is in comment box and enter key is pressed
            $('#autodocComments').keypress(function(e) {
                if (e.which == 13) {
                    e.stopPropagation();
                }
        });

    };
    //}
}(window));

function closeSubtabOnReady() {
    //First find the ID of the current tab to close it
    //sforce.console.getEnclosingTabId(getIdSubTab);
}
var getIdSubTab = function getIdSubTab(result) {
    console.log('----autodoc---95------');
    //Now that we have the tab ID, we can close it
    var sbTbIdInfo = result.id;
    globalVar = sbTbIdInfo;
    localStorage.setItem("subTabIdInfo", sbTbIdInfo);
};
