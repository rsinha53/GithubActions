var acet = acet || {};
var globalMap = new Map();
(function (w) {

    var saveAutodocSelectionsCount = 0;
    acet.autodoc = {};
    acet.autodoc.additionalInfo = '';
    acet.autodoc.selectedItems = [];
    var identifierList = [];
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
    var rowAuthorizationList = {} ;// added new for authorization
    var $paginationTableMap = new Map();
    var $paginationDataMap = new Map();
    var $paginationMultipleTableMap = new Map();
    w.lgtAutodoc = {

        "initAutodoc": function (sf_id) {
            console.time("-------Timer------->");
            var $docsection;
            var $contextvar = "#"+sf_id;
            //only autodoc the specified section if sf_id is provided, otherwise autodoc all sections under the page
            if (sf_id) {
                $docsection = $("[data-auto-doc='true']", $($contextvar));
                if($docsection != undefined && $docsection.find(".autodocPagination") == undefined)
                    $("[data-auto-doc='true']", $($contextvar)).attr('data-auto-doc', 'auto');
            }
            if($docsection != undefined){
            $docsection.each(function () {
                //remove any autodoc tags added before
                $(this).find(".autodoc").remove();
                //add a checkbox right of the label for any field under page block section
                if (!($(this).attr("data-auto-doc-header-only") == 'true')) {
                    $(this).find("p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');

                    //Preselect checkboxes for SAE business flow - Sanka US2138277
                    $(this).find(".preselect").each(function(){
                        $(this).find("input[type='checkbox'].autodoc").prop('checked', true).prop("disabled", true);
                    });
                    $(this).find(".valueCls").css("margin-left", "16px");
                    //align label and checkbox added .
                }

                //add a checkbox in column header in first column
                //.slds-table is for standard page block table, .auto-doc-list is for acetdatatable component
                if (!($(this).attr("auto-doc-header-only") == 'true')) {
                    var rowCount = $(this).find(".slds-table, .auto-doc-list").find('tbody').children().length;
                    if (rowCount < 26 && rowCount != 0) {
                        console.log('-----autodoc----4------');
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');

                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                    } else if (rowCount > 26) {
                        $(this).find(".slds-table").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                    }

                }
                //add checkboxes for all rows in first column
                if($(this).hasClass('titleCheckBox'))
                {
                    //For SAE Change the position of the checkbox from right to left - Sanka US2138277
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").prepend('<input type="checkbox" class="autodoc" style="margin-right: 5px;"/>');
                }
                else
                {
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").append('<input type="checkbox" class="autodoc" style="margin-left: 5px;"/>');
                }

                $(this).find(".slds-text-heading_small").find("input[type='checkbox']").change(function () {
                    //console.log('------autodoc---7------');
                    $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));

                    $(this).parent().parent().find(".preselect").find("input[type='checkbox'].autodoc").prop("checked", true);

                    $(this).parent().parent().find(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });


                //enable check-all/uncheck all function in table
                $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                    //console.log('-----autodoc----8------');
                    $(this).parents(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                var authAutodoc = $(this).find('span.enableAuthorizationAutodoc').attr("data-auto-doc-section-state");
                if (authAutodoc == "yes") {
                    var $source = $(this);
                    var $authSection = $(this).clone();
                    $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').find('tr').remove();
                   // console.log('----autodoc---autodoc----9------');
                    var tableHead = $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list");
                    //var tableHead = $authSection.find(".slds-box");
                   // console.log('-----autodoc---10------' + tableHead);
                    if ($authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").length > 0) {
                      //  console.log('-----autodoc----11------' + $authSection);
                        tableHeaderMap[$(this).attr("data-auto-doc-section-key")] = tableHead.parent().html();
                    }
                  //  console.log('------autodoc----12-----' + tableHeaderMap);

                    //$authorization.push($authSection);
                }

            });
            }
            //resolved checkboxes for case items
            var $caseItemSection;
            if (sf_id) {
                $caseItemSection = $("[data-auto-doc-case-items='true']", $($contextvar));
            }
            if($caseItemSection != undefined){
            $caseItemSection.each(function () {
                //remove any case item resolved tags added before
                $(this).find(".autodoc-case-item-resolved").remove();

                //Hide Resolve check-boxes for SAE tables - Sanka US2138277
                if(!$(this).hasClass('noResolveCheckBox')){
                    //add a resolved header in column header in last column
                    $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').append('<th class="autodoc-case-item-resolved">Resolved</th>');
                    //add resolved checkboxes for all rows in last column
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').append('<td class="autodoc-case-item-resolved"><input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px"/></td>');
                }
                //if autodoc is on by default, check on resolved checkbox by default (usually on sub tab page B)
                if ($(this).attr("data-auto-doc") == 'auto') {
                    //  $(this).find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", true);
                }
                //sync checked status(case item resolved) with status of autodoc checkbox
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                    $(this).parent().parent().find("input[type='checkbox'].autodoc-case-item-resolved").prop("checked", $(this).prop("checked"));
                });
                //check on autodoc checkbox if item is marked as resolved
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').find("input[type='checkbox'].autodoc-case-item-resolved").change(function () {
                    if ($(this).prop("checked")) {
                        $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                    }
                });

            });
            }
            if($docsection != undefined){
              //update autodoc selected items whenever autodoc or case item resolved checkbox is changed
              $docsection.find(".slds-table, .auto-doc-list").find("input[type='checkbox'].autodoc, input[type='checkbox'].autodoc-case-item-resolved").change(function () {
              });
              //update autodoc selected items whenever autodoc or case item resolved checkbox is changed in Non Table view
              $docsection.find("p.slds-form-element__label").find("input[type='checkbox'].autodoc").change(function () {
              });
            }
            console.timeEnd("-------Timer------->");
        },

        "saveStateAutodocOnSearch": function () {
            globalSectionalVar = [];
           // console.log(globalSectionalVar);
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

            localStorage.removeItem("localAccumsData");

        },

        "saveAutodoc": function (pagefeature) {

           // console.log(authorizationFinal);
            var $autodoc = $("<div></div>");

            var autodocPrepended = false;

            var $autodocMap = new Map();
            multipleTableRowFinal = [];
            identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
            if (identifierList.length > 0) {
              //  console.log('----autodoc---100.05------');
                for (var i = 0; i < identifierList.length; i++) {

                    $autodoc.append(identifierList[i]);
                  //  console.log('----autodoc---100.05.1------' + $autodoc);

                }
            }
            $("[data-auto-doc='auto'],[data-auto-doc='true']").each(function () {
                if($(this).attr('data-auto-doc-feature') == pagefeature){
                    var $source = $(this);
                    var $section = $(this).clone();
                    //autodoc on header and section details
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                        var $table = $(this).clone();
                        $section.find(".autodocNotTableView").each(function () {
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                                var $tr = $("<tr></tr>");
                                $table.find(".slds-grid").each(function () {
                                    $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
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
                                    var $chks = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");

                                    $chks.closest(".slds-p-around_xx-small").remove();
                                } else {
                                    $section = $("<div></div>");
                                }
                            }
                        });

                        $section.find(".slds-table").each(function () {
                            //reorder fields in page block section
                            if ($table.find(".autodocNotTableView").length == 0 && $table.find(".autodocPagination").length == 0) {
                                var $tr = $("<tr></tr>");
                                if ($(this).find("input:checkbox:checked").length > 0) {

                                    $(this).find(".autodoc").find("input:checkbox:not(:checked)").each(function () {
                                        $tr = $(this);
                                        $tr.closest(".slds-hint-parent").remove();
                                    });
                                } else {
                                    $section = $("<div></div>");
                                }
                            }else if($table.find(".autodocPagination").length > 0){
                              //console.log("-----currTableId=======>"+$table.html());
                                var $currTableId = $table.find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                                //console.log("============$currTableId=======>"+$currTableId);
                                $table.find(".autodocPagination").find("tbody").empty();
                                var autoDocData = $("<tr></tr>");

                                if($paginationMultipleTableMap.has($currTableId)){
                                  for (var value of $paginationMultipleTableMap.get($currTableId).values()) {
                                      console.log("============value=======>"+value);
                                      var clonedItem = value;
                                      autoDocData.append(clonedItem);
                                  }
                                  $table.find(".autodocPagination").find("tbody").append(autoDocData.html());
                                  $section = $table;
                                }

                            }
                    });
                } else {
                    //autodoc on header only, clear whole section if header is not checked on
                    $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                        $(this).parent().parent().html('');
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

                    //test fix
                    //var $clonedSection = $section.clone();
                   // $section = $clonedSection;

                    //remove auto generagted element for autodoc
                    $section.find(".autodoc").remove();

                    //exclude element with autodoc equals false
                    $section.find("[data-auto-doc-item='false']").remove();

                    //remove all script tags
                    $section.find("script").remove();

                   // console.log('----autodoc---91.92.2------' + $section.html());
                    //convert input field into text node
                    $section.find("input,select,textarea").each(function () {
                     //   console.log('----autodoc---91.93------');
                        if ($(this).css("display") !== "none") {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                               // console.log('----autodoc---91.94------');
                                if ($(this).is(":checked")) {
                                 //   console.log('----autodoc---91.95------');
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
                          //  console.log('----autodoc---100------');
                            for (var j = 0; j < multipleTableRowArray[i].length;) {
                                identifierList.push(multipleTableRowArray[i][j]);
                                var temp = multipleTableRowArray[i][++j];
                                multipleTableRowFinal.push(temp);
                                j++;
                            }

                        }

                        var tempList = GetUnique(multipleTableRowFinal);
                        for (var y = 0; y < tempList.length; y++) {
                          //  console.log('----autodoc---100.1------');
                           // console.log(tempList[y]);
                            if (tempList[y] != undefined) {
                                var splitString = tempList[y].split("%");
                                aMap[splitString[0]] = aMap[splitString[0]] || [];
                                aMap[splitString[0]].push(splitString[1]);
                            }
                        }
                        for (var key in aMap) {
                           // console.log('----autodoc---100.2------');
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

                    if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.slds-form-element__label").length > 0 || $section.find(".slds-table, .auto-doc-list").children("tbody").find("tr").length > 0 ) {

                        localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0

                        var mapKey = $source.attr("data-auto-doc-feature");
                        var mapval;
                        if ($autodocMap.has(mapKey)) {
                            $autodoc = $autodocMap.get(mapKey);

                        } else if (localStorage.getItem("rowCheckHold") == undefined || !(localStorage.getItem("rowCheckHold") != undefined && localStorage.getItem("rowCheckHold").length > 0)) {
                            $autodoc = $("<div></div>");
                        }
                        var sectionHeader = $source.attr("data-auto-doc-section-key");
                        if (sectionHeader != undefined) {
                            var $autodocHeader = $("<div class='slds-page-header' style='margin-top:-1rem;margin-left:-1rem;margin-right:-1rem;border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                            $section.prepend($autodocHeader);
                        }

                        //Prepend section on top - Sanka US2038277
                        var selected = $source.find(".autodocPagination").find('input:checkbox:checked').length;

                        var hasPagination = $source.attr("data-auto-doc-pagination");
                       // console.log(hasPagination);

                        var sectionId = '';

                        if(selected <= 0 && hasPagination)
                        {
                            $section.addClass('noitemsSelected');
                        }

                        if($source.hasClass('prependSection'))
                        {
                            mapval = $autodoc.prepend($section);
                            //autodocPrepended = true;
                        }else{
                            mapval = $autodoc.append($section);
                        }

                        if(selected <= 0 && hasPagination){
                            //mapval.find(".selectedSection").remove();
                            mapval.find(".noitemsSelected").remove();
                        }

                        $autodocMap.set(mapKey, mapval);



                    }

                }

            });


            //Fixing table padding issue - Sanka US2138277
            $autodoc.find(".autodocTableView").addClass("slds-box slds-card");

            //append additonal autodoc
            if (acet.autodoc.additionalInfo) {
                $autodoc.append(acet.autodoc.additionalInfo);
              //  console.log('----autodoc---100.5------');
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

            //Auto-Doc for Benefit codes :start
            $autodoc.append("<br/><br/>");


            $paginationTableMap = new Map();
            $paginationDataMap = new Map();
            //Auto-Doc for Benefit codes :End
            //assign autodoc content
            if ($autodocMap.get(pagefeature) != undefined) {
                $("[id$='autodocHidden']").val($autodocMap.get(pagefeature).html());
                //assign autodoc comment
                $("[id$='autodocCommentHidden']").val($("#autodocComments").val());
                //assign autodoc case item key ids

                var autodocMapData = acet.autodoc.getCaseItemInfo($autodocMap.get(pagefeature));
                if(autodocMapData.length > 0){
                  //  console.log('====2====>>'+autodocMapData);
                    $("[id$='autodocCaseItemsHidden']").val(autodocMapData);
                }
                return $autodocMap.get(pagefeature).html();
            }
            else
                return null;
        },

        "saveAuthorizationSection": function () {
           // console.log('----autodoc---55------');
            identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
            var $autodoc = $("<div></div>");
            $("[data-auto-doc-section-key]").each(function () {

                var sectionName = $(this).attr("data-auto-doc-section-key");
                $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                    var arrColIndexes = [];
                    $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                        arrColIndexes.push(parseInt(e));
                    });
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {

                        var rowCloneVar = sectionName;
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            var $rowClone = $(this).clone();
                            $rowClone.find("input,select,textarea").each(function () {
                                if ($(this).css("display") !== "none") {
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
                           // console.log(rowAuthorizationList);
                            identifierList.push(identifier);
                          //  console.log("identifierList..." + identifierList);
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
                                if ($(this).css("display") !== "none") {
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
                           // console.log(rowAuthorizationList);
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

        "storePaginationData": function(pagenum) {

            var $originalSection = $("[data-auto-doc-pagination='true']");
            //var $paginationsection = $("[data-auto-doc-pagination='true']");
            var $paginationsection = $originalSection.clone();

           // console.log('----autodoc---Pagination.1------'+ $paginationsection);
            $paginationsection.each(function() { //

                var $tableId = $(this).find('.dataTables_wrapper').find('#dt_lgt_table_wrap').find('table').attr('id');
                if($paginationMultipleTableMap.has($tableId))
                  $paginationTableMap = $paginationTableMap.get($tableId);
                else
                  $paginationTableMap = new Map();
                console.log('----autodoc---Pagination.0.0------'+ $tableId);
                console.log('----autodoc---Pagination.1.1------'+ $(this).html());

                if($paginationTableMap == null || $paginationTableMap == undefined)
                {
                    $paginationTableMap = new Map();
                }

                var $sectionName = $(this);
                $(this).find('.autodocPagination').children('tbody').children('tr').each(function() {
                    console.log('----autodoc---Pagination.2------'+$(this).html() );
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        var $resolvedChk = $(this).find("input[type='checkbox'].autodoc-case-item-resolved");
                        console.log("=====$resolvedChk===="+$resolvedChk.is(":checked"));
                        if ($resolvedChk.is(":checked")) {
                            console.log('----autodoc---91.95------');
                            $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" checked="true">');
                        } else {
                            console.log('----autodoc---91.96------');
                            $resolvedChk.replaceWith('<input type="checkbox" class="autodoc-case-item-resolved" style="margin-left:15px" >');
                            $resolvedChk.checked = false;
                        }
                        var autodockey = $(this).find("#lnkClaimId").html();

                        if($paginationTableMap.has(pagenum)){
                           console.log('----autodoc---Pagination.3.1.1------'+pagenum+'===='+$paginationTableMap.get(pagenum));
                            if ($paginationTableMap.get(pagenum) != null && $paginationTableMap.get(pagenum) != undefined) {
                               console.log('----autodoc---Pagination.3.1.2------'+$paginationTableMap.get(pagenum));
                                var tempHTML = $paginationTableMap.get(pagenum);
                                console.log('----autodoc---Pagination.3.1.2------'+tempHTML);
                                var $doctr ="</tr>";
                                var $dochtml = "<tr class='slds-hint-parent' role='row'>";
                                var tempJQConvert = $("<div></div>");
                                tempJQConvert.append(tempHTML);
                                tempJQConvert.append($dochtml);

                                //console.log('----autodoc---Pagination.3.1.2------'+key == pagenum);
                                //if (key == pagenum) {

                             //   console.log('----autodoc---Pagination.3.1.3------'+tempJQConvert.html());
                             //   console.log('----autodoc---Pagination.3.1.3------'+$(this).html());
                                //tempJQConvert.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').append(tempMapAuthorization.get(key));
                                tempJQConvert.append($(this).html());
                                tempJQConvert.append($doctr);
                                $paginationTableMap.set(pagenum, tempJQConvert.html()) ;
                                console.log('----autodoc---Pagination.3.1.4------'+$paginationTableMap.get(pagenum));
                                //}

                            }
                        }else{
                            console.log('----autodoc---Pagination.3.1.0------'+ pagenum);
                            console.log('----autodoc---Pagination.3.1.0------'+ $(this).html());
                            var $doctr ="</tr>";
                            var $dochtml = $("<tr></tr>");
                            $dochtml.append("<tr class='slds-hint-parent' role='row'>");
                            $dochtml.append($(this).html());
                            $dochtml.append($doctr);
                            $paginationTableMap.set(pagenum, $dochtml.html()) ;
                        }
                       // console.log('----autodoc---Pagination.3.2------'+ $paginationTableMap.get(1));
                       // console.log('----autodoc---Pagination.3.2------'+ $paginationTableMap.get(pagenum));
                        console.log('----autodoc---Pagination.3.2.0------'+ $paginationDataMap.has(autodockey));
                        if($paginationDataMap.has(autodockey)){
                            //for (var key in $paginationDataMap) {
                            console.log('----autodoc---Pagination.3.2.1------');
                            if ($paginationDataMap.get(autodockey) != null || $paginationDataMap.get(autodockey) != undefined) {
                                console.log('----autodoc---Pagination.3.2.1.0------'+$paginationDataMap.get(autodockey));
                                var tempHTML = $paginationDataMap.get(autodockey);
                                var $doctr =$("</tr>");
                                var $dochtml = $("<tr class='slds-hint-parent' role='row'>");
                                var tempJQConvert = $("<tr></tr>");
                                tempJQConvert.append(tempHTML);
                                //tempJQConvert.append(dochtml.html());
                                //if (key == autodockey) {
                             //   console.log('----autodoc---Pagination.3.2.1.2------');
                                //tempJQConvert.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').append(tempMapAuthorization.get(key));
                                tempJQConvert.append($(this).html());
                                tempJQConvert.append($doctr.html());
                                $paginationDataMap.set(autodockey, tempJQConvert.html());
                                //}

                            }
                            //}
                        }else{
                            console.log('----autodoc---Pagination.3.2.2------'+ $(this).html());
                            var $doctr =$("</tr>");
                            var dochtml = $("<tr class='slds-hint-parent' role='row'>");
                            dochtml.append($(this).html());
                            dochtml.append($doctr.html());
                            $paginationDataMap.set(autodockey,dochtml.html());
                        }
                       console.log('----autodoc---Pagination.3.3------'+ $paginationDataMap.get(autodockey));
                    }
                });

                $paginationMultipleTableMap.set($tableId,$paginationTableMap);
            });


        },

        "getPaginationData": function ($checkedRow, tableId) {
           // console.log('----autodoc---P.5------');
            multipleTableRowList = JSON.parse(localStorage.getItem("table")) || [];
           // console.log(multipleTableRowList);
            for (var i = 0; i < multipleTableRowList.length; i++) {
                for (var j = 0; j < multipleTableRowList[i].length;) {
                    $removeDuplicatesOnCaseObject[multipleTableRowList[i][j]] = multipleTableRowList[i][++j];
                    j++;
                }
            }
           // console.log($removeDuplicatesOnCaseObject);
            $("[data-auto-doc-section-key]").each(function () {
              //  console.log('-----autodoc----P.6------');
                var setAttributeTabId = $(this).find(".enablePagination");
                setAttributeTabId.attr("auto-doc-section-tabid", globalVar);
                var sectionName = $(this).attr("data-auto-doc-section-key");
                $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                //    console.log('-----autodoc----P.7------');
                    var arrColIndexes = [];
                    $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                 //       console.log('-----autodoc----P.8------');
                        arrColIndexes.push(parseInt(e));
                    });
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {
                    //    console.log('-----autodoc----P.9------');
                        var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                        if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                            var identifier = sectionName;
                            for (var i = 0; i < arrColIndexes.length; i++) {
                             //   console.log('-----autodoc----P.10------');
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
                          //  console.log("identifier......" + identifier);
                            var $rowClone = $(this).clone();
                            $rowClone.find("input,select,textarea").each(function () {
                             //   console.log('-----autodoc----P.11------');
                                if ($(this).css("display") !== "none") {
                                    if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                        if ($(this).is(":checked")) {
                                      //      console.log('-----autodoc----P.12------');
                                            $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                        } else {
                                          //  console.log('-----autodoc----P.13------');
                                            $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                        }
                                    } else {
                                      //  console.log('-----autodoc----P.14------');
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
                              //  console.log('-----autodoc----P.15------');
                                $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                            } else {
                                delete $removeDuplicatesOnCaseObject[identifier];
                                $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                            }
                            var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                            acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                            localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                          //  console.log(localStorage.getItem("table"));
                        } else if ($chkAutodoc.is(":not(:checked)")) {
                          //  console.log('-----autodoc----P.16------');
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
                       // console.log('-----autodoc----P.17------');
                    });

                });
            });

        },

        "saveAutodocSaveAccums": function () {
           // console.log('----autodoc---77------');
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
                            if ($table.find(".slds-table, .auto-doc-list").length == 0) {
                                var $tr = $("<tr></tr>");
                                $table.find("tr").each(function () {
                                    $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
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
                                var $chks = $section.find(".slds-table, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
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
               // console.log($section.html());
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
                $section.find(".autodoc").remove();
                //convert input field into text node
                $section.find("input,select,textarea").each(function () {
                    if ($(this).css("display") !== "none") {
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
               // console.log($sectionFinal);

            });
            $sectionFinalList.push($sectionFinal);
            localStorage.setItem("localAccumsData", $sectionFinalList);

        },

        "clearAutodocSelections": function (pagefeature, pageid) {
			console.time("-------Timer2------->");
            var sel = "[data-auto-doc-feature='" + pagefeature + "']";
            // console.log('----autodoc---111------' + $("[data-auto-doc='auto']").html());
            if(pageid != undefined && pageid != null){
            pageid = '#'+pageid
            var $toBeClearedSection = $("[data-auto-doc='auto'],[data-auto-doc='true']",$(pageid)).find(sel);
            console.log('----autodoc---111------'+pageid );
            $toBeClearedSection.each(function () {
                //remove any autodoc tags added before
                $(this).find(".autodoc").remove();
               // console.log('----autodoc---111.1------');
                //add a checkbox right of the label for any field under page block section
                if (!($(this).attr("data-auto-doc-header-only") == 'true')) {
                  //  console.log('----autodoc---111.2------');
                    $(this).find("p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');
                    //$(this).find("div.slds-form-element__static").css( "margin-left", "16px" );

                    //Preselect checkboxes for SAE business flow - Sanka US2138475
                    $(this).find(".preselect").each(function(){
                        $(this).find("input[type='checkbox'].autodoc").prop('checked', true).prop("disabled", true);
                    });

                    $(this).find(".valueCls").css("margin-left", "16px");
                    //align label and checkbox added .
                    //$(this).find(".slds-box").find("p.valueCls").css("vertical-align", "middle");
                }

                //add a checkbox in column header in first column
                //.slds-table is for standard page block table, .auto-doc-list is for acetdatatable component
                if (!($(this).attr("auto-doc-header-only") == 'true')) {
                    //var rowCount = $(this).find(".slds-box").find(".slds-table, .auto-doc-list").find('tbody').children().length;
                    var rowCount = $(this).find(".slds-table, .auto-doc-list").find('tbody').children().length;
                  //  console.log('----autodoc---111.3------');
                    if (rowCount < 26) {
                    //    console.log('----autodoc---111.4------');
                        $(this).find(".slds-table").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        $(this).find(".auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" /></th>');
                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                    } else {
                      //  console.log('----autodoc---111.5------');
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                    //Table not clearing for SAE
                    if (rowCount < 26) {
                        // $("[data-auto-doc='auto']").find(".slds-table").find(".autodoc").remove();
                       // console.log('----autodoc---111.4------');
                        // $("[data-auto-doc='auto']").find(".slds-table").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        // $(this).find(".auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" /></th>');
                        //$("[data-auto-doc='auto']").find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                        $("[data-auto-doc='auto'],[data-auto-doc='true']",$(pageid)).find(".slds-table").find("input[type='checkbox'].autodoc").prop("checked", false);
                    } else {
                        //console.log('----autodoc---111.5------');
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                }
                //add checkboxes for all rows in first column
                if (!($(this).attr("auto-doc-header-only") == 'true')) {
                   // console.log('----autodoc---111.6------');
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                }

                //Move checkboxes to the left - Sanka US2138475
                if($("[data-auto-doc='auto']",$(pageid)).hasClass('titleCheckBox'))
                {
                   // console.log('----autodoc---titleCheckBoxPrepend------');
                    //For SAE Change the position of the checkbox from right to left - Sanka US2138277
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").prepend('<input type="checkbox" class="autodoc" style="margin-right: 5px;"/>');
                }
                else
                {
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").append('<input type="checkbox" class="autodoc" style="margin-left: 5px;"/>');
                }

                $(this).find(".slds-text-heading_small").find("input[type='checkbox']").change(function () {
                    //console.log('----autodoc---111.7------');
                    $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                    $(this).parent().parent().find(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                //enable check-all/uncheck all function in table
                $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                  //  console.log('----autodoc---111.8------');
                    $(this).parents(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                var authAutodoc = $(this).find('span.enableAuthorizationAutodoc').attr("data-auto-doc-section-state");
                if (authAutodoc == "yes") {
                    var $source = $(this);
                    var $authSection = $(this).clone();
                    $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').find('tr').remove();
                   // console.log('----autodoc---autodoc----9------');
                    var tableHead = $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list");
                    //var tableHead = $authSection.find(".slds-box");
                   // console.log('-----autodoc---10------' + tableHead);
                    if ($authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").length > 0) {
                     //   console.log('-----autodoc----11------' + $authSection);
                        tableHeaderMap[$(this).attr("data-auto-doc-section-key")] = tableHead.parent().html();
                    }
                   // console.log('----autodoc---111.9------');

                    //$authorization.push($authSection);
                }

            });
            }else{
            var $toBeClearedSection = $("[data-auto-doc='auto'],[data-auto-doc='true']").find(sel);
             console.log('----autodoc---110------');
            $toBeClearedSection.each(function () {
                //remove any autodoc tags added before
                $(this).find(".autodoc").remove();
               // console.log('----autodoc---111.1------');
                //add a checkbox right of the label for any field under page block section
                if (!($(this).attr("data-auto-doc-header-only") == 'true')) {
                  //  console.log('----autodoc---111.2------');
                    $(this).find("p.slds-form-element__label").prepend('<input type="checkbox" class="autodoc" style="margin-right: 3px;"/>');
                    //$(this).find("div.slds-form-element__static").css( "margin-left", "16px" );

                    //Preselect checkboxes for SAE business flow - Sanka US2138475
                    $(this).find(".preselect").each(function(){
                        $(this).find("input[type='checkbox'].autodoc").prop('checked', true).prop("disabled", true);
                    });

                    $(this).find(".valueCls").css("margin-left", "16px");
                    //align label and checkbox added .
                    //$(this).find(".slds-box").find("p.valueCls").css("vertical-align", "middle");
                }

                //add a checkbox in column header in first column
                //.slds-table is for standard page block table, .auto-doc-list is for acetdatatable component
                if (!($(this).attr("auto-doc-header-only") == 'true')) {
                    //var rowCount = $(this).find(".slds-box").find(".slds-table, .auto-doc-list").find('tbody').children().length;
                    var rowCount = $(this).find(".slds-table, .auto-doc-list").find('tbody').children().length;
                  //  console.log('----autodoc---111.3------');
                    if (rowCount < 26) {
                    //    console.log('----autodoc---111.4------');
                        $(this).find(".slds-table").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        $(this).find(".auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" /></th>');
                        $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                    } else {
                      //  console.log('----autodoc---111.5------');
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                    //Table not clearing for SAE
                    if (rowCount < 26) {
                        // $("[data-auto-doc='auto']").find(".slds-table").find(".autodoc").remove();
                       // console.log('----autodoc---111.4------');
                        // $("[data-auto-doc='auto']").find(".slds-table").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" style="margin-left: 0px;"/></th>');
                        // $(this).find(".auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"><input type="checkbox" class="autodoc" /></th>');
                        //$("[data-auto-doc='auto']").find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                        $("[data-auto-doc='auto'],[data-auto-doc='true']").find(".slds-table").find("input[type='checkbox'].autodoc").prop("checked", false);
                    } else {
                        //console.log('----autodoc---111.5------');
                        $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').prepend('<th class="autodoc"></th>');
                    }

                }
                //add checkboxes for all rows in first column
                if (!($(this).attr("auto-doc-header-only") == 'true')) {
                   // console.log('----autodoc---111.6------');
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').prepend('<td class="autodoc"><input type="checkbox" class="autodoc"/></td>');
                }

                //Move checkboxes to the left - Sanka US2138475
                if($("[data-auto-doc='auto']").hasClass('titleCheckBox'))
                {
                   // console.log('----autodoc---titleCheckBoxPrepend------');
                    //For SAE Change the position of the checkbox from right to left - Sanka US2138277
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").prepend('<input type="checkbox" class="autodoc" style="margin-right: 5px;"/>');
                }
                else
                {
                    //add a checkbox on section header and enable check-all/uncheck all for all tables under the section
                    $(this).find(".slds-text-heading_small").append('<input type="checkbox" class="autodoc" style="margin-left: 5px;"/>');
                }

                $(this).find(".slds-text-heading_small").find("input[type='checkbox']").change(function () {
                    //console.log('----autodoc---111.7------');
                    $(this).parent().parent().find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked"));
                    $(this).parent().parent().find(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                //enable check-all/uncheck all function in table
                $(this).find(".slds-table, .auto-doc-list").children('thead').children('tr').children(":first-child").find("input[type='checkbox']").change(function () {
                  //  console.log('----autodoc---111.8------');
                    $(this).parents(".slds-table, .auto-doc-list").children('tbody').find("input[type='checkbox'].autodoc").prop("checked", $(this).prop("checked")).trigger("change");
                });

                var authAutodoc = $(this).find('span.enableAuthorizationAutodoc').attr("data-auto-doc-section-state");
                if (authAutodoc == "yes") {
                    var $source = $(this);
                    var $authSection = $(this).clone();
                    $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").find('tbody').find('tr').remove();
                   // console.log('----autodoc---autodoc----9------');
                    var tableHead = $authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list");
                    //var tableHead = $authSection.find(".slds-box");
                   // console.log('-----autodoc---10------' + tableHead);
                    if ($authSection.find(".slds-box").find(".slds-card__body").find('span.enableAuthorizationAutodoc').find(".slds-table, .auto-doc-list").length > 0) {
                     //   console.log('-----autodoc----11------' + $authSection);
                        tableHeaderMap[$(this).attr("data-auto-doc-section-key")] = tableHead.parent().html();
                    }
                   // console.log('----autodoc---111.9------');

                    //$authorization.push($authSection);
                }

            });
            }
            console.timeEnd("-------Timer2------->");
        },

        "saveAutodocSelections": function (pagefeature, pageid) {
            console.time("-------Timer------->");
            var tempMapAuthorization = new Map();
            
            var $autodoc = $("<div></div>");

            var $autodocMap = new Map();
            multipleTableRowFinal = [];
            var selSec = "[data-auto-doc-feature='" + pagefeature + "']";
          //  console.log('----autodoc---77.00------' + selSec);

            var $autodoc = $("<div></div>");
            //var accumAsOfSave = $("[id$='accumsdateSearch']").val();
            //var grpEligPopulation = '';
            //if ($("[id$='grpEligPopulationId']").val() != undefined && $("[id$='grpEligDateId']").val() != undefined) {
            //    var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + '|' + $("[id$='grpEligDateId']").val();
            //}

            //var grpEligPopulation = $("[id$='grpEligPopulationId']").val() + $("[id$='grpEligDateId']").val();
            if(pageid != undefined && pageid != null){
                pageid = '#'+pageid
                $("[data-auto-doc='auto'],[data-auto-doc='true']",$(pageid)).each(function () {
                if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                    //console.log('----autodoc---91.1------'+window.location.href);
                 //   console.log('----autodoc---91.1------' + window.location.pathname.substring(window.location.pathname.indexOf('/cmp/') + 8, window.location.pathname.length));
                    //console.log('----autodoc---91.1------'+window.location.href);
                    //console.log('----autodoc---91.1.1------'+window.location.hostname);
                    //console.log('----autodoc---91.1.3------'+$source.attr( "data-auto-doc-feature" ));
                    var $source = $(this);
                    var $section = $(this).clone();
                   // console.log('----autodoc---91.2------' + $section.html());
                    //fix jquery issue, selected value is not cloned
                    $section.find("input,select,textarea").each(function () {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                       // console.log('----autodoc---91.3------');
                    });
                    //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                    //remove unchecked fields or rows
                    //if ($section.attr("data-auto-doc") == 'true') {
                   // console.log('----autodoc---91.31.1------');
                    //autodoc on header and section details
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                      //  console.log('----autodoc---91.31.2------');
                        var $table = $(this);
                        //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                        $section.find(".autodocNotTableView").each(function () {
                           // console.log('----autodoc---91.31.3------');

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                             //   console.log('----autodoc---91.7------');
                                var $tr = $("<tr></tr>");
                                $table.find(".slds-grid").each(function () {
                                //    console.log('----autodoc---91.8------');
                                    $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                        if ($tr.children().length == 4) {
                                            $table.append($tr);
                                            $tr = $("<tr></tr>");
                                           // console.log('----autodoc---91.9------');
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
                                  //  console.log('----autodoc---91.72------' + $chks.html());

                                    $chks.closest(".slds-p-around_xx-small").remove();
                                 //   console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                    //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                } else {
                                    $section = $("<div></div>");
                                }
                            }
                        });

                        //US2138475 - Policy Click Autodoc Change - Sanka
                        $section.find(".slds-table").each(function () {
                           // console.log('----autodoc-selected---91.31.31------');

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                              //  console.log('----autodoc-selected---91.71------' + $section.html());
                             //   console.log('----autodoc-selected---91.72------' + $section.find(".autodoc").html());
                                var $tr = $("<tr></tr>");
                                //$section.find(".autodoc").each(function() {
                             //   console.log('----autodoc-selected---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
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
                                  //  console.log('----autodoc-selected---91.91.1------');
                                });
                                    } else {
                                        $section = $("<div></div>");
                                    }
                                //$(this).remove();
                                //});
                                //$table.append($tr);
                            }
                        });
                    } else {
                      //  console.log('----autodoc---91.92------');
                        //autodoc on header only, clear whole section if header is not checked on
                        $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                            $(this).parent().parent().html('');
                       //     console.log('----autodoc---91.92.1------');
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
                     //   console.log('----autodoc---91.93------');
                        if ($(this).css("display") !== "none") {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                             //   console.log('----autodoc---91.94------');
                                if ($(this).is(":checked")) {
                                //    console.log('----autodoc---91.95------');
                                    $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                } else {
                                 //   console.log('----autodoc---91.96------');
                                    $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                }
                            } else {
                                if ($(this).is("select")) {
                                 //   console.log('----autodoc---91.97------');

                                    var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                    strData = strData.replace('::after', '');
                                    //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                    $(this).replaceWith(strData);
                                } else {
                                 //   console.log('----autodoc---91.98------');
                                    $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                }
                            }
                        }
                    });

                    
                    $section.find(".autodoc").remove();

                   // console.log('----autodoc---100.4.0------>' + $section.html);
                    //append section content

                    if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.slds-form-element__label").length > 0 || $section.find(".slds-table, .auto-doc-list").children("tbody").find("tr").length > 0) {

                        //var $chks1 = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                        //console.log('----autodoc---91.72------'+ $table.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                        //$autodoc = $("<div></div>");
                        var sectionHeader = $source.attr("data-auto-doc-section-key");
                        var $autodocHeader = $("<div class='slds-page-header' style='margin-top:-1rem;margin-left:-1rem;margin-right:-1rem;border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                        //console.log('----autodoc---100.4.5.0------>'+$tempautodoc.html());
                        $section.prepend($autodocHeader);
                        //$autodoc.append($section);

                        if(!$section.hasClass("detailSection"))
                        {
                         //   console.log('------sectionHeader--------' + sectionHeader);
                            $autodoc.append($section);
                        }

                        if($source.hasClass('prependSection'))
                        {
                            //$autodoc.prepend($section);
                            //autodocPrepended = true;
                        }else{
                            //$autodoc.append($section);
                        }

                        //$autodoc.append($section);

                        //identifierList = [];

                       // console.log('----autodoc---100.4.5------>' + localStorage.getItem("rowCheckHold"));
                        //identifierList.push(localStorage.getItem("rowCheckHold"));



                    }


                }

            });
            }else{
                $("[data-auto-doc='auto'],[data-auto-doc='true']").each(function () {
                if ($(this).attr('data-auto-doc-feature') == pagefeature) {
                    //console.log('----autodoc---91.1------'+window.location.href);
                 //   console.log('----autodoc---91.1------' + window.location.pathname.substring(window.location.pathname.indexOf('/cmp/') + 8, window.location.pathname.length));
                    //console.log('----autodoc---91.1------'+window.location.href);
                    //console.log('----autodoc---91.1.1------'+window.location.hostname);
                    //console.log('----autodoc---91.1.3------'+$source.attr( "data-auto-doc-feature" ));
                    var $source = $(this);
                    var $section = $(this).clone();
                   // console.log('----autodoc---91.2------' + $section.html());
                    //fix jquery issue, selected value is not cloned
                    $section.find("input,select,textarea").each(function () {
                        $(this).val($source.find("[id='" + $(this).attr("id") + "']").val());
                       // console.log('----autodoc---91.3------');
                    });
                    //console.log('----autodoc---91.31------'+ component.find("autodocSec").getElement());
                    //remove unchecked fields or rows
                    //if ($section.attr("data-auto-doc") == 'true') {
                   // console.log('----autodoc---91.31.1------');
                    //autodoc on header and section details
                    if (!($section.attr("auto-doc-header-only") == 'true')) {
                      //  console.log('----autodoc---91.31.2------');
                        var $table = $(this);
                        //console.log('----autodoc---91.5------'+$table.find(".autodocNotTableView").length);
                        $section.find(".autodocNotTableView").each(function () {
                           // console.log('----autodoc---91.31.3------');

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                             //   console.log('----autodoc---91.7------');
                                var $tr = $("<tr></tr>");
                                $table.find(".slds-grid").each(function () {
                                //    console.log('----autodoc---91.8------');
                                    $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
                                        if ($tr.children().length == 4) {
                                            $table.append($tr);
                                            $tr = $("<tr></tr>");
                                           // console.log('----autodoc---91.9------');
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
                                  //  console.log('----autodoc---91.72------' + $chks.html());

                                    $chks.closest(".slds-p-around_xx-small").remove();
                                 //   console.log('----autodoc---91.72.1------' + $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                                    //console.log('----autodoc---91.72.1------'+ $chks.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);$tr = $("<tr></tr>");
                                } else {
                                    $section = $("<div></div>");
                                }
                            }
                        });

                        //US2138475 - Policy Click Autodoc Change - Sanka
                        $section.find(".slds-table").each(function () {
                           // console.log('----autodoc-selected---91.31.31------');

                            //console.log('----autodoc---91.6------'+ $table.find(".autodocNotTableView").html());
                            //reorder fields in page block section

                            if ($table.find(".autodocNotTableView").length == 0) {
                              //  console.log('----autodoc-selected---91.71------' + $section.html());
                             //   console.log('----autodoc-selected---91.72------' + $section.find(".autodoc").html());
                                var $tr = $("<tr></tr>");
                                //$section.find(".autodoc").each(function() {
                             //   console.log('----autodoc-selected---91.81------' + $(this).find(".autodoc").find("input:checkbox:checked").length);
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
                                  //  console.log('----autodoc-selected---91.91.1------');
                                });
                                    } else {
                                        $section = $("<div></div>");
                                    }
                                //$(this).remove();
                                //});
                                //$table.append($tr);
                            }
                        });
                    } else {
                      //  console.log('----autodoc---91.92------');
                        //autodoc on header only, clear whole section if header is not checked on
                        $section.find(".slds-text-heading_small").find("input:checkbox:not(:checked)").each(function () {
                            $(this).parent().parent().html('');
                       //     console.log('----autodoc---91.92.1------');
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
                     //   console.log('----autodoc---91.93------');
                        if ($(this).css("display") !== "none") {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                             //   console.log('----autodoc---91.94------');
                                if ($(this).is(":checked")) {
                                //    console.log('----autodoc---91.95------');
                                    $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                } else {
                                 //   console.log('----autodoc---91.96------');
                                    $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');
                                }
                            } else {
                                if ($(this).is("select")) {
                                 //   console.log('----autodoc---91.97------');

                                    var strData = $source.find("[id='" + $(this).attr("id") + "']").val().replace('::before', '');
                                    strData = strData.replace('::after', '');
                                    //jquery issue, sometimes, changed value in select element is not updated in cloned element.
                                    $(this).replaceWith(strData);
                                } else {
                                 //   console.log('----autodoc---91.98------');
                                    $(this).replaceWith($(this).val().replace(/\r?\n/g, '<br />'));
                                }
                            }
                        }
                    });

                    $section.find(".autodoc").remove();

                   // console.log('----autodoc---100.4.0------>' + $section.html);
                    //append section content

                    if ($section.attr("data-auto-doc") == 'auto' || $section.attr("data-auto-doc") == 'true' || $section.find(".autodocNotTableView").find("p.slds-form-element__label").length > 0 || $section.find(".slds-table, .auto-doc-list").children("tbody").find("tr").length > 0) {

                        //var $chks1 = $section.find(".autodocNotTableView").find("input:checkbox:not(:checked)");
                        //console.log('----autodoc---91.72------'+ $table.find(".autodocNotTableView").find("input:checkbox:not(:checked)").length);
                        //$autodoc = $("<div></div>");
                        var sectionHeader = $source.attr("data-auto-doc-section-key");
                        var $autodocHeader = $("<div class='slds-page-header' style='margin-top:-1rem;margin-left:-1rem;margin-right:-1rem;border-bottom-left-radius: 0rem !important;border-bottom-right-radius: 0rem !important;padding: .7rem .7rem'><div class='slds-grid'><div class='slds-col slds-has-flexi-truncate'><h1 class='slds-page-header__title slds-m-right_small slds-align-middle slds-truncate' style='font-size:.800rem !important;line-height:1.3 !important;'>" + sectionHeader + "</h1></div></div></div>");
                        //console.log('----autodoc---100.4.5.0------>'+$tempautodoc.html());
                        $section.prepend($autodocHeader);
                        //$autodoc.append($section);

                        if(!$section.hasClass("detailSection"))
                        {
                         //   console.log('------sectionHeader--------' + sectionHeader);
                            $autodoc.append($section);
                        }

                        if($source.hasClass('prependSection'))
                        {
                            //$autodoc.prepend($section);
                            //autodocPrepended = true;
                        }else{
                            //$autodoc.append($section);
                        }

                        //$autodoc.append($section);

                        //identifierList = [];

                       // console.log('----autodoc---100.4.5------>' + localStorage.getItem("rowCheckHold"));
                        //identifierList.push(localStorage.getItem("rowCheckHold"));



                    }


                }

            });
            }
            identifierList = [];
            var $tempautodoc = $("<div></div>");
            var saveddata = [];
            saveddata = JSON.parse(localStorage.getItem("rowCheckHold"));

            if (localStorage.getItem("rowCheckHold") != null && localStorage.getItem("rowCheckHold") != undefined) {
               // console.log('----autodoc---100.4.5.00------>' + saveddata[0]);
                $tempautodoc = $(saveddata[0]);
            }


            //Fixing table padding issue - Sanka US2138277
            $autodoc.find(".autodocTableView").addClass("slds-box slds-card");

            $autodoc.prepend($tempautodoc);
          //  console.log('----autodoc---100.4.5.1------>' + identifierList);
            identifierList.push($autodoc.html());
           // console.log('----autodoc---77.04------' + identifierList);
            localStorage.setItem("rowCheckHold", JSON.stringify(identifierList));
            console.timeEnd("-------Timer------->");
        },

        "initAutodocSelections": function () {
          //  console.log('----autodoc---88------');
          //  console.log('----autodoc---2.1------');
            var subTabId = localStorage.getItem("subTabIdInfo");
          //  console.log(localStorage.getItem("rowCheckHold"));
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
                    $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {
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
                      //  console.log("identifier......" + identifier);
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
        }
    };

    function getSubTabIdMethodOnCheckboxSelection() {
        //First find the ID of the current tab to close it
        //sforce.console.getEnclosingTabId(getIdSubTab);
    }

    var getIdSubTab = function getIdSubTab(result) {
      //  console.log('----autodoc---getIdSubTab------');
        //Now that we have the tab ID, we can close it
        var sbTbIdInfo = result.id;
        globalVar = sbTbIdInfo;
        localStorage.setItem("subTabIdInfo", sbTbIdInfo);

    };

    acet.autodoc.saveAuthorizationSection = function () {
      //  console.log('----autodoc---55------');
        identifierList = JSON.parse(localStorage.getItem("rowCheckHold")) || [];
        var $autodoc = $("<div></div>");
        $("[data-auto-doc-section-key]").each(function () {

            var sectionName = $(this).attr("data-auto-doc-section-key");
            $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
                var arrColIndexes = [];
                $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    arrColIndexes.push(parseInt(e));
                });
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {

                    var rowCloneVar = sectionName;
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        var $rowClone = $(this).clone();
                        $rowClone.find("input,select,textarea").each(function () {
                            if ($(this).css("display") !== "none") {
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
                      //  console.log(rowAuthorizationList);
                        identifierList.push(identifier);
                      //  console.log("identifierList..." + identifierList);
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
                            if ($(this).css("display") !== "none") {
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
                      //  console.log(rowAuthorizationList);
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
       // console.log('----autodoc---P.5------');
        multipleTableRowList = JSON.parse(localStorage.getItem("table")) || [];
       // console.log(multipleTableRowList);
        for (var i = 0; i < multipleTableRowList.length; i++) {
            for (var j = 0; j < multipleTableRowList[i].length;) {
                $removeDuplicatesOnCaseObject[multipleTableRowList[i][j]] = multipleTableRowList[i][++j];
                j++;
            }
        }
      //  console.log($removeDuplicatesOnCaseObject);
        $("[data-auto-doc-section-key]").each(function () {
        //    console.log('-----autodoc----P.6------');
            var setAttributeTabId = $(this).find(".enablePagination");
            setAttributeTabId.attr("auto-doc-section-tabid", globalVar);
            var sectionName = $(this).attr("data-auto-doc-section-key");
            $(this).find("[auto-doc-section-column-indexes]").addBack().each(function () {
            //    console.log('-----autodoc----P.7------');
                var arrColIndexes = [];
                $(this).attr("auto-doc-section-column-indexes").split(",").forEach(function (e) {
               //     console.log('-----autodoc----P.8------');
                    arrColIndexes.push(parseInt(e));
                });
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {
                //    console.log('-----autodoc----P.9------');
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                        //    console.log('-----autodoc----P.10------');
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
                     //   console.log("identifier......" + identifier);
                        var $rowClone = $(this).clone();
                        $rowClone.find("input,select,textarea").each(function () {
                        //    console.log('-----autodoc----P.11------');
                            if ($(this).css("display") !== "none") {
                                if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                    if ($(this).is(":checked")) {
                                  //      console.log('-----autodoc----P.12------');
                                        $(this).replaceWith('<img src="/img/checkbox_checked.gif" alt="Checked" width="21" height="16" class="checkImg" title="Checked" />');
                                    } else {
                                     //   console.log('-----autodoc----P.13------');
                                        $(this).replaceWith('<img src="/img/checkbox_unchecked.gif" alt="Not Checked" width="21" height="16" class="checkImg" title="Not Checked" />');

                                    }
                                } else {
                                  //  console.log('-----autodoc----P.14------');
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
                           // console.log('-----autodoc----P.15------');
                            $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                        } else {
                            delete $removeDuplicatesOnCaseObject[identifier];
                            $removeDuplicatesOnCaseObject[identifier] = sectionName + globalVar + '%' + $rowClone.closest('tr')[0].outerHTML;
                        }
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.table = JSON.stringify(Object.entries($removeDuplicatesOnCaseObject));
                     //   console.log(localStorage.getItem("table"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                     //   console.log('-----autodoc----P.16------');
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
                  //  console.log('-----autodoc----P.17------');
                });

            });
        });

    };
    acet.autodoc.saveAutodocSaveAccums = function () {
       // console.log('----autodoc---77------');
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
                        if ($table.find(".slds-table, .auto-doc-list").length == 0) {
                            var $tr = $("<tr></tr>");
                            $table.find("tr").each(function () {
                                $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
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
                            var $chks = $section.find(".slds-table, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
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
          //  console.log($section.html());
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
            $section.find(".autodoc").remove();
            //convert input field into text node
            $section.find("input,select,textarea").each(function () {
                if ($(this).css("display") !== "none") {
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
          //  console.log($sectionFinal);

        });
        $sectionFinalList.push($sectionFinal);
        localStorage.setItem("localAccumsData", $sectionFinalList);

    };
    acet.autodoc.saveAutodocSelections = function () {
      //  console.log('----autodoc---77------');
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
        //    console.log('----autodoc---77.1------');
            $(this).find("[data-auto-doc-section-column-indexes]").addBack().each(function () {
                var arrColIndexes = [];
          //      console.log('----autodoc---77.2------');
                $(this).attr("data-auto-doc-section-column-indexes").split(",").forEach(function (e) {
                    arrColIndexes.push(parseInt(e));
               //     console.log('----autodoc---77.3------>');
                });
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                   // console.log('----autodoc---77.4------');
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                     //   console.log('----autodoc---77.5------');
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
                      //  console.log("identifier......2" + identifier);
                        identifierList.push(identifier);
                      //  console.log(identifierList);
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                      //  console.log(localStorage.getItem("rowCheckHold"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                      //  console.log('----autodoc---77.6------');
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
              //  console.log('----autodoc---77.31------' + JSON.stringify($(this).html()));
                $(this).find(".autodocNotTableView").each(function () {
                    var $chkAutodoc = $(this).find("input[type='checkbox'].autodoc");
                //    console.log('----autodoc---77.41------');
                    if ($chkAutodoc && $chkAutodoc.is(":checked")) {
                  //      console.log('----autodoc---77.51------');
                        var identifier = sectionName;
                        for (var i = 0; i < arrColIndexes.length; i++) {
                     //       console.log('----autodoc---77.511------');
                            if (arrColIndexes[i] > 0 && arrColIndexes[i] < $(this).find("div").length) {
                       //         console.log('----autodoc---77.52------');
                                var $td = $(this).find("div").eq(arrColIndexes[i]);
                                if ($td) {
                                    identifier = identifier + '|' + ($td.find("lightning-formatted-text").val() || $td.text());
                            //        console.log('----autodoc---77.53------' + JSON.stringify(identifier));
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
                       // console.log("identifier......2" + identifier);
                        identifierList.push(identifier);
                     //   console.log(identifierList);
                        var $chkCaseItemResolved = $(this).find("input[type='checkbox'].autodoc-case-item-resolved").is(":checked");
                        acet.autodoc.selectedItems[identifier] = $chkCaseItemResolved;
                        localStorage.setItem("rowCheckHold", JSON.stringify(GetUnique(identifierList)));
                      //  console.log(localStorage.getItem("rowCheckHold"));
                    } else if ($chkAutodoc.is(":not(:checked)")) {
                      //  console.log('----autodoc---77.6------');
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
       // console.log(localStorage.getItem("rowCheckHold"));
      //  console.log('----autodoc---880------');
    };

    acet.autodoc.initAutodocSelections = function () {
        //console.log('----autodoc---88------');
       // console.log('----autodoc---2.1------');
        var subTabId = localStorage.getItem("subTabIdInfo");
       // console.log(localStorage.getItem("rowCheckHold"));
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
                $(this).find(".slds-table, .auto-doc-list").children('tbody').children('tr').each(function () {
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
                  //  console.log("identifier......" + identifier);
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
       // console.log('----autodoc---00------');
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
           // console.log('----autodoc---01------');
            var ownProps = Object.keys(obj),
                i = ownProps.length,
                resArray = new Array(i); // preallocate the Array
            while (i--)
                resArray[i] = [ownProps[i], obj[ownProps[i]]];

            return resArray;
        };
    acet.autodoc.saveStateAutodocOnSearch = function () {
       // console.log('----autodoc---99------');
        globalSectionalVar = [];
      //  console.log(globalSectionalVar);
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
       // console.log(globalSectionalVar);
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
      //  console.log('----autodoc---91------');
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
      //  console.log(tableHeaderMap);
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
       // console.log(authorizationFinal);
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
                        if ($table.find(".slds-table, .auto-doc-list").length == 0) {
                            var $tr = $("<tr></tr>");
                            $table.find("tr").each(function () {
                                $(this).find("p.slds-form-element__label").find("input:checkbox:checked").each(function () {
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
                            var $chks = $table.find(".slds-table, .auto-doc-list").children("tbody").find(".autodoc").find("input:checkbox:not(:checked)");
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
            $section.find(".autodoc").remove();

            //exclude element with autodoc equals false
            $section.find("[data-auto-doc-item='false']").remove();

            //remove all script tags
            $section.find("script").remove();


            //convert input field into text node
            $section.find("input,select,textarea").each(function () {
                if ($(this).css("display") !== "none") {
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
                 //   console.log(tempList[y]);
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
                         //   console.log($section);
                            $section.append(iterateMap[i][++j]);
                        }
                        j++;
                    }
                   // console.log($section);

                }

            }

            $section.find(".autodoc").remove();

            //append section content

            if ($section.attr("auto-doc") == 'auto' || $section.find(".slds-box").find("p.slds-form-element__label").length > 0 || $section.find(".slds-table, .auto-doc-list").children("tbody").find("tr").length > 0) {

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
           // console.log(globalSectionalVar);
            $autodoc.find(".enableSectionAutodoc").remove();
            //var $additionalAccumsSection = localStorage.getItem("globalAccumsData");
            $autodoc.append(GetUnique(globalSectionalVar));
            localStorage.removeItem("globalAccumsData");

        }

        var $additionalAccumsSection = '';
        $autodoc.append("<br/><br/>");
        //Auto-Doc for Benefit codes :start
        $autodoc.append("<br/><br/>");

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
      //  console.log('----autodoc---92------');
        var keyIds = [];

        //dummy case item from call topic section

        $autodoc.find("[data-auto-doc-case-item='true']").each(function () {
            var isResolved = $(this).find(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
            keyIds.push("::" + isResolved);
         //   console.log('----autodoc---92.1333------');
        });

        $autodoc.find("[data-auto-doc-case-item='true']").each(function () {
            debugger;
            var isResolved = $(this).find(".header-column").first(".valueCls").find(".valueCls").find(".data-auto-first-element").html();
            if(isResolved != undefined){
                keyIds = [];
                keyIds.push(isResolved +"::" + false);
              //  console.log('----autodoc---92.1------');
            }

        });


        //case items from call topic search results
        $autodoc.find("[data-auto-doc-case-items='true']").each(function () {
            var idx = 0;
            var idxprovName = 0;
          //  console.log('----autodoc---92.2------');
            $(this).find(".slds-table, .auto-doc-list").children("thead").find("tr").find("th").each(function (index) {
             //   console.log('----autodoc---92.3------');
                if ($(this).text() == 'Tax ID') {
             //       console.log('matched');
                    idx = index;
               //     console.log('Inside::' + idx);
                } else if ($(this).text() == 'Provider') {
                //    console.log('matched provider');
                    idxprovName = index;
                 //   console.log('Inside::' + idxprovName);
                } else if ($(this).text() == 'Provider ID') {
                  //  console.log('matched provider: ' + $(this).html());
                    idxprovName = index + 1;
                    //provName + 1 because we want provider name, not provider id, but the header "name" is too generic
                  //  console.log('Inside::' + idxprovName);

                }
            });
            if (idx != 0 || idxprovName != 0) {
               // console.log('----autodoc---92.4------');
                if (idx != 0) {
                    $(this).find(".slds-table, .auto-doc-list").children("tbody").find("tr").each(function () {
                     //   console.log('----autodoc---92.5------');
                        var adding = '';
                        var taxId = $(this).children().eq(idx).text();
                      //  console.log('TAX ID ::: ' + taxId);
                        adding = adding + ";;" + taxId;
                        if (idxprovName != 0) {
                            var prov = $(this).children().eq(idxprovName).text();
                          //  console.log('Provider Name ::: ' + prov);
                            adding = adding + ";;" + prov;
                        }
                        var isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                        keyIds.push($.trim($(this).children().first().text()) + adding + "::" + isResolved);
                    });
                }

            } else {
              //  console.log('----autodoc---92.6------');
              //  console.log('outside::' + idx);
                $(this).find(".slds-table, .auto-doc-list").children("tbody").find("tr").each(function () {
                    var isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                    keyIds.push($.trim($(this).children().first().text()) + "::" + isResolved);
                   // console.log("2nd" + isResolved);

                });
                /**$(this).find(".slds-table, .auto-doc-list").children("tbody").find("tr").each(function() {
                    var isResolved = $(this).children().last(".autodoc-case-item-resolved").find("img").attr("title") == "Checked";
                    keyIds.push($.trim($(this).children().first().text()) + "::" + isResolved);
                    console.log("3rd" + isResolved);
                });**/
            }
        });

        var $benefitAutoDoc = $("[data-auto-doc-accordian='true']");


        $benefitAutoDoc.each(function () {
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

        return keyIds.join("||");
    };


    acet.autodoc.saveAutodocComments = function () {
       // console.log('----autodoc---93------');
        //assign autodoc comment
        $("[id$='autodocCommentHidden']").val($("#autodocComments").val());
        return $("#autodocComments").val();
    };

    acet.autodoc.createCommentsbox = function () {
        //console.log('----autodoc---94------');
        var html = '<div id="autodocCommentsContainer" style="position:fixed;bottom:0;right:0;width:400px;height:100px;background-color:#E1E0DA;padding-left:10px;padding-right:10px;border:3px solid #D18361;">' +
            '<div id="autodocCommentsHeader" style="width:100%;height:24px;background-color:#E1E0DA;padding-top:4px;">' +
            '<div style="float:left;">' +
            '<img src="/resource/1479166730000/ACETResources/img/comments.png" style="vertical-align:middle;margin-right:2px;"/>' +
            '<span>Comments</span>' +
            '</div>' +
            '<div style="float:right;">' +
            '<img id="btnMinimize" src="/resource/1479166730000/ACETResources/img/minimize.png" />' +
            '</div>' +
            '</div>' +
            '<textarea id="autodocComments" style="width:100%;height:50px;overflow:auto;border:none;"/>' +
            '<div id="autodocCommentsFooter" style="width:100%;height:20px;background-color:#E1E0DA;bottom:0" />' +
            '</div>';

        $("form").append(html);
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
        $("#autodocCommentsContainer").on("resize", function (event, ui) {
            $("#autodocComments").height(ui.size.height - 51);
            ui.size.height = Math.max(51, ui.size.height);
            ui.size.width = Math.max(150, ui.size.width);
        });

        $("#autodocCommentsContainer").on("drag", function (event, ui) {
            if (ui.position.top + $(this).height() > $(window).height()) {
                ui.position.top = $(window).height() - $(this).height();
            }

            if (ui.position.left + $(this).width() > $(window).width()) {
                ui.position.left = $(window).width() - $(this).width();
            }
        });

        $("#btnMinimize").on('click', function () {
            //$("#autodocCommentsContainer").resizable("disable").draggable("disable");
            //$("#autodocCommentsContainer").attr("bottom",0);
            $("#autodocCommentsContainer").height(28);
            $("#autodocComments").height(0);
            $("#autodocCommentsFooter").height(0);
            $("#autodocCommentsContainer").css('left', 'auto');
            $("#autodocCommentsContainer").css('top', 'auto');
            $("#autodocCommentsContainer").css("bottom", '0px');
            $("#autodocCommentsContainer").css('right', '0px');

        });

        $("#autodocCommentsHeader").on('dblclick', function () {
            if ($("#autodocComments").height() == 0) {
                //$("#autodocCommentsContainer").resizable("enable").draggable("enable");
                $("#autodocCommentsContainer").height(100);
                $("#autodocComments").height(50);
                $("#autodocCommentsFooter").height(20);
                $("#autodocCommentsContainer").css('left', $(window).innerWidth() - $("#autodocCommentsContainer").width() - 25 + 'px');
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
                $("#autodocCommentsContainer").css("bottom", '0px');
                $("#autodocCommentsContainer").css('right', '0px');

            }
        });

        //do not invoke page action when the focus is in comment box and enter key is pressed
        $('#autodocComments').keypress(function (e) {
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
   // console.log('----autodoc---95------');
    //Now that we have the tab ID, we can close it
    var sbTbIdInfo = result.id;
    globalVar = sbTbIdInfo;
    localStorage.setItem("subTabIdInfo", sbTbIdInfo);
};
