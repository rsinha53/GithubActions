({
    showCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    showResults: function(component, helper) {   
        var res = component.get('v.caseHistoryList');
        component.set("v.caseHistory", res);
        
        if(!component.get("v.IsInitializedTable")){
            component.set('v.dataTblId', new Date().getTime());
        }
        
        // DE302184 - Thanish - 13th Feb 2020
        setTimeout(function() {
            var dataTblId = ('#' + component.get('v.dataTblId'));
            if($.fn.DataTable != undefined) {
                if ($.fn.DataTable.isDataTable(dataTblId)){
                    $(dataTblId).DataTable().destroy();
                }
            }
            
            var table = $(dataTblId).DataTable({
                "oLanguage": {"sEmptyTable": ""},
                "sPaginationType": "full_numbers",
                "bRetrieve": true,
                "columnDefs": [
                    { "orderable": false, "targets": 0 }
                ],
                "aLengthMenu": [
                    [10, 25, 50, 100, 200, -1],
                    [10, 25, 50, 100, 200, "All"]
                ],
                "iDisplayLength": 10,
                "destroy": true,
                "order": [[ 5, "desc" ]],
                "drawCallback": function(settings) {
                    var table = $(dataTblId).DataTable();
                    var info = table.page.info();
                    var currentpage = info.page + 1;
                    var pagelist = [];
                    var i = currentpage + 1;
                    while (i <= info.pages) {
                        if (pagelist.length <= 9) {
                            if (info.page != i && info.pages != i) {
                                pagelist.push(i)
                            }
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
                    pagelist.sort(function(a, b) {
                        return a - b
                    });
                    component.set("v.pageList", pagelist);
                    component.set("v.totalPages", info.pages);
                    component.set("v.currentPageNumber", currentpage);
                    var pagenationdiv_id = dataTblId + '_paginate';
                    $(pagenationdiv_id).css("display", "none");
                }                                
            });            
        }, 1000);
        component.set("v.IsInitializedTable", true);
    },
})