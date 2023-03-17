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
               var dataTblId = ('#'+component.get('v.dataTblId'));
               
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
                        /*
                        "drawCallback": function(settings) {
                             var table = $(dataTblId).DataTable();
              var info = table.page.info();
                            console.log('info---------------'+info);
      var currentpage = info.page + 1;
      var pagelist = [];
          var i = currentpage+1;
      while (i <= info.pages) {
       if (pagelist.length <= 9) {
           if(info.page != i && info.pages != i){
        pagelist.push(i)
           }
       }
       i++;

      }
        if(pagelist.length < 10){
      for (var j = currentpage; j >= 1; --j) {
       if(pagelist.length <= 9 && currentpage != j ){
        pagelist.push(j)
          }

         }
         }
         pagelist.sort(function(a, b){return a-b});
     
              component.set("v.pageList",pagelist);
              component.set("v.totalPages",info.pages);
              component.set("v.currentPageNumber",currentpage);
                           
                var pagenationdiv_id = dataTblId+'_paginate';
                  $(pagenationdiv_id).css("display","none");
                        }
                        */
                    });
                
                /*
                * 
                var table;
                if ( $.fn.dataTable.isDataTable( '#tableId' ) ) {
                    table = $('#tableId').DataTable();
                }else{
                    table = $('#tableId').DataTable({
                        stateSave: true,                    
                        sPaginationType: "full_numbers",
                        aLengthMenu: [
                            [10,25, 50, 100, 200, -1],
                            [10,25, 50, 100, 200, "All"]
                        ],
                        iDisplayLength: 50,
                        order: [[4, 'desc']],
                        //"bDestroy": true
                             });
                    
                }
                */
                
                //$('#tableId').dataTable().fnClearTable();
                                                         //$('#tableId').dataTable().fnDestroy();
                                                         
                /*$('#tableId').DataTable({                  
                    sPaginationType: "full_numbers",
                    aLengthMenu: [
                        [10,25, 50, 100, 200, -1],
                       [10,25, 50, 100, 200, "All"]
                    ],
                    iDisplayLength: 50,
                    order: [[4, 'desc']],
                    stateSave: true
                });*/
                
                //paging: false
                
                
                
                // add lightning class to search filter field with some bottom margin..  
                //$('div.dataTables_filter input').addClass('slds-input');
                //$('div.dataTables_filter input').css("marginBottom", "10px");
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