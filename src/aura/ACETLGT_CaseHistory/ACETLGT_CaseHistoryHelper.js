({
    showResults : function(component, helper) {
         var dataTblId = ('#'+component.get('v.dataTblId'));
        var settimeout = '1';
        if($A.util.isUndefinedOrNull(dataTblId)){
            settimeout ='3000';
        }
                    setTimeout(function(){
        var action = component.get("c.getCaseHistoryResults");
        helper.showSpinner2(component,event,helper);
        action.setParams({"memSRK":component.get("v.srk")
                         })
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if(res != undefined && res != null){
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.intlink = '/'+record.Interaction__c;
                    if(record.Parent != null)
                        record.prntCaselink = '/'+record.Parent.Id;
                }); 
            }
            setTimeout(function(){   
                $.extend($.fn.dataTableExt.oSort, {
                    "ddMmYyyy-pre": function (a) {
                        a = a.split('/');
                        if (a.length < 2) return 0;
                        return Date.parse(a[0] + '/' + a[1] + '/' + a[2]);
                    },
                    "ddMmYyyy-asc": function (a, b) {
                        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
                    },
                    "ddMmYyyy-desc": function (a, b) {
                        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
                    }
                });            
                    $(dataTblId).DataTable({   
                        pagingType: "full_numbers",
                        sPaginationType: "full_numbers",
                        aLengthMenu: [
                            [10,25, 50, 100, 200, -1],
                            [10,25, 50, 100, 200, "All"]
                        ],
                        iDisplayLength: 50,
                        order: [[4, 'desc']],
                        "columnDefs" : [{"targets":4, "type":"ddMmYyyy"}],
                        "drawCallback": function(settings) {
                             var table = $(dataTblId).DataTable();
              var info = table.page.info();
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
                       //debugger;     
                var pagenationdiv_id = dataTblId+'_paginate';
                  $(pagenationdiv_id).css("display","none");
                        }
                    });
               
            }, 100); 
            var newlst =[];
            
            if (state === "SUCCESS") {
                for(var i = 0; i < res.length; i++){
                    
                    res[i].CreatedDate = $A.localizationService.formatDateTime(res[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    if (res[i].Interaction__c) {
                        if(res[i] != null && res[i].Interaction__c != null)
                            res[i].InteractionName = res[i].Interaction__r.Name;
                        
                        if(res[i] != null && res[i].Parent != null)
                            res[i].ParentCaseNumber = res[i].Parent.CaseNumber;
                        
                        if(res[i] != null && res[i].Rollup_Fulfillment__c > 0)
                        res[i].fullfilment = "Y";
                        
                        if(res[i] != null && res[i].Rollup_Fulfillment__c < 1)
                        res[i].fullfilment = "";
                        console.log(res[i].Rollup_Fulfillment__c + ' || ' + res[i].fullfilment);
                    }
                    
                    
                    newlst.push(res[i]);
                }
                component.set("v.caseHistory", newlst);
            }
            else {
                helper.counselLogErrors(response.getError());
            }
            helper.hideSpinner2(component,event,helper);
        }));
        $A.enqueueAction(action);
                                  }, settimeout); 

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