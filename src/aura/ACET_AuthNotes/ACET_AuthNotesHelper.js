({
    // US2308090: Enhancements, Authorizations: KAVINDA
    initAuthTable: function (cmp, helper) {

        if (!cmp.get("v.IsInitializedTable")) {
            cmp.set('v.dataTblId', 'AuthNotesTbl' + new Date().getTime());
        }

        var authDetailsObj = cmp.get('v.authDetailsObj');
        if ($A.util.isUndefinedOrNull(authDetailsObj)){
            return;

        } else if ($A.util.isUndefinedOrNull(authDetailsObj.notes) || authDetailsObj.notes.length == 0){
            return;
        }

        var dataTblId = ('#' + cmp.get('v.dataTblId'));
        if ($.fn.DataTable.isDataTable(dataTblId)) {
            $(dataTblId).DataTable().destroy();
        }

        setTimeout(function () {
            $(dataTblId).DataTable({
                "oLanguage": {
                    "sEmptyTable": "No records found."
                },
                "sPaginationType": "full_numbers",
                "bRetrieve": true,
                "aLengthMenu": [
                    [10, 25, 50, 100, 200, -1],
                    [10, 25, 50, 100, 200, "All"]
                ],
                "iDisplayLength": 7,
                "destroy": true,
                "order": [
                    [1, "desc"]
                ],
                "dom": '<"toolbar">frtip',
                initComplete: function () {
                    $(dataTblId + '_filter').css("margin-bottom", ".5rem"); //US2061071
                },
                "bPaging": false,
                "bInfo": false,
                "bPaginate": false,
                "pageLength": 7,
                "columnDefs": [{
                    "orderable": false,
                    "targets": 0
                }],

            });
        }, 1000);
        cmp.set("v.IsInitializedTable", true);

    },
    //US2061071 - Format Date
    convertMilitaryDate: function (dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                returnDate = $A.localizationService.formatDate(dateParam, format);
            } catch (error) { }
        }
        return returnDate;
    }


})