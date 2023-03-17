({
    showResults : function(component, helper) {

        var action = component.get("c.getCaseHistoryResults");
        helper.showSpinner2(component,event,helper);
        action.setParams({
              // "memSRK":component.get("v.srk")
              "accId": component.get("v.recordId")
              //"originatorType":component.get("v.originatorType")
        })

        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if(res != undefined && res != null){
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                  /*  record.intlink = '/'+record.Interaction__c;
                    if(record.Parent != null)
                        record.prntCaselink = '/'+record.Parent.Id;
                        */
                });
            }
            setTimeout(function(){
                
               
               $(document).ready(function() {
                var dataTblId = ('#'+component.get('v.dataTblId'));
                if ($.fn.dataTable == undefined || ($.fn.dataTable != undefined && $.fn.dataTable.isDataTable( dataTblId ) )) {
                    //$(dataTblId).DataTable().destroy();
                    $(dataTblId).DataTable();
                }
                else {
                    //$(dataTblId).DataTable().destroy();
                    $(dataTblId).DataTable({
                        bPaginate:true,
                        pagingType: "full_numbers",
                        sPaginationType: "full_numbers",
                        aLengthMenu: [
                            [10,25, 50, 100, 200, -1],
                            [10,25, 50, 100, 200, "All"]
                        ],
                        iDisplayLength: 10,
                        order: [[10, 'desc']]

                    });
                }
                });
            }, 500);
            var newlst =[];

            if (state === "SUCCESS") {
                for(var i = 0; i < res.length; i++){

                    res[i].CreatedDate = $A.localizationService.formatDateTime(res[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    if (res[i].Interaction__c) {
                        if(res[i] != null && res[i].Interaction__c != null)
                            res[i].InteractionName = res[i].Interaction__r.Name;

                        if(res[i] != null && res[i].Parent != null)
                            res[i].ParentCaseNumber = res[i].Parent.CaseNumber;


                    }


                    newlst.push(res[i]);
                }
                component.set("v.caseHistory", newlst);
                //$('#tableId').DataTable().destroy();
                //$('#tableId').find('tbody').append("<tr><td><value1></td><td><value1></td></tr>");
                //$('#tableId').dataTable().fnDestroy();
                //if ($.fn.DataTable.isDataTable('#dataTable')) {
                    //alert(2);
                    //$('#tableId').DataTable().clear().destroy();
                    //$('#tableId tbody').empty();
                    //alert(3);
                   /*
                var dataTblId = ('#'+component.get('v.dataTblId'));
                alert(dataTblId);
                    $(dataTblId).DataTable({
                        sPaginationType: "full_numbers",
                        aLengthMenu: [
                            [10,25, 50, 100, 200, -1],
                            [10,25, 50, 100, 200, "All"]
                        ],
                        iDisplayLength: 50,
                        order: [[4, 'desc']]
                        //stateSave: true
                    });*/
                //}
            }
            else {
                helper.counselLogErrors(response.getError());
            }
            //window.lgtAutodoc.initAutodoc();
            //setTimeout(function(){window.utilMethods.method1();},50);
            helper.hideSpinner2(component,event,helper);
        }));
        $A.enqueueAction(action);

    },
    counselLogErrors : function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
            }
        } else {
            console.log("Unknown error");
        }
    },
    hideSpinner2: function(component, event, helper) {
        component.set("v.Spinner", false);
        console.log('Hide');
    },
    // this function automatic call by aura:waiting event
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
        console.log('show');
                             }
})