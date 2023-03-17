({
    table:{
        
        
    },
    
    fetchdetails:function(component, event, helper,arrfieldNames,columns){
        //Call helper method to fetch the records
      
       component.set("v.lastId",'');
        component.set("v.spinner", true);
        var distable= '#'+component.get('v.tableid');
         
        var faction = component.get("c.generateDataSet");
        //// var fieldSetValues = component.get("v.fieldSetValues");
        // var setfieldNames = new Set();
        // if(component.get('v.reportResponse.tabResp.fieldDataList').length>0) {
                                var distable= '#'+component.get('v.tableid');

        if ( $.fn.dataTable.isDataTable( distable ) ) {
        	helper.table = $(distable).DataTable();
            helper.table.destroy();
            //helper.table.rows().remove().draw();
            //helper.table.rows().delete();
            helper.table.clear().draw();
        }
        console.log(arrfieldNames); 
        
        faction.setParams({
            objAPIname: component.get('v.objAPIname'),
            fieldsAPIname: JSON.stringify(arrfieldNames),
            columnsLabel: columns, 
            hyperlinkColumn: component.get('v.columnForHyperLink'),
            "UserName":component.get('v.username')
            ,"SelectedBU":component.get('v.businessunit')
            ,"lastId":component.get("v.lastId")
            ,"isoverdue":component.get("v.isOverdue")
            ,"pageLength":25
        });
        faction.setCallback(this, function(response) {
            
            var tableData = response.getReturnValue();
            console.log(tableData);
            //tableData =tableData.replace(/(&quot\;)/g,"\"")
            //tableData  = tableData.replace(/(&lt\;)/g,'<').replace(/(&gt\;)/g,'>').replace(/(&#39\;)/g,'\'').replace(/(&amp\;)/g,'&');
            if(!$A.util.isUndefinedOrNull(tableData)){
                var jsonData = JSON.parse(tableData);
                var dataSize = jsonData.data.length;
                component.set("v.tableRecords",jsonData.data);
                component.set("v.recordCount",jsonData.recordcount);
                console.log(jsonData);
                var casedetails = jsonData.data;
                if(jsonData.data.length>0){
                    var casestring = casedetails[dataSize-1][1];
                    var lastId = casestring.substring(
                        casestring.lastIndexOf("'>")+2, 
                        casestring.lastIndexOf("</")
                    );
                   
                    component.set("v.lastId",lastId);
                    console.log(lastId);
                    component.set("v.displaytable",true);
                    component.set("v.spinner", false);
                    if(jsonData.recordcount >25){
                        component.set("v.displayloadmore",true);
                    }else{
                        component.set("v.displayloadmore",false);
                    } 
                    
                    //rendering jquery datatable
                    setTimeout(function(){ 
                        var tableHeaders="";
                        var columnar=[];
                        $.each(jsonData.columns, function(i, val){
                            console.log("vaql : "+val);
                            tableHeaders += "<th>" + val + "</th>";
                            columnar.push(val[0]);
                        });
                        console.log(columnar);
                        component.set("v.columns", columnar);
                        //$("#tableDiv").empty();   
                        //$("#tableDiv").append('<table class="slds-table slds-table_bordered slds-table_cell-buffer" cellspacing="0" width="100%" id="displayTable"><thead><tr>' + tableHeaders + '</tr></thead></table>');
                        console.log(this.table);
                       // table.clear().draw();
   //table.rows.add(jsonData.data); // Add new data
   //table.columns.adjust().draw();
                        
                                            
					
                        $(distable).on( 'length.dt', function ( e, settings, len ) {
                            
                            
                            
                                helper.fetchdetailsentries(component, event, helper,arrfieldNames,columns,len);
                            
                        });
                        
                        helper.table = $(distable).DataTable(jsonData);
                       //table = $(distable).DataTable({ "aLengthMenu": [[25, 50, -1], [25, 50, "All"]]});
                        helper.table.order( [ 0, 'desc' ] ).draw();
                        $(distable+' tbody').on( 'click', 'tr', function () {
                           var data = helper.table.rows().data();
                           if(data.length != 0){
                           console.log(data);
                              
                           var d = helper.table.row( this ).data();
                            var lastId = d[1].substring(8,26);
                            helper.navigateToSObject(component,event,helper,lastId);
                            
                            }
                        } );
                         
                        //var table = $("#displayTable").dataTable(jsonData);
                        console.log("After >>> "+this.table);
                        //var counter =0;
                        //counter =Math.ceil((jsonData.recordcount)/25);
                        // alert(counter);
                        //for(var i=1;i<counter;i++)
                        //helper.getrecursiveTableRows(component, event, helper);
                    }, 5); 
                    
                    //
                } else{
                    component.set("v.displaytable",false);
                    
                    component.set("v.spinner", false);
                }  
            }else{
                 component.set("v.spinner", false);
            }
        })
        
        $A.enqueueAction(faction);
        
    },
    fetchdetailsentries:function(component, event, helper,arrfieldNames,columns,len){
        //Call helper method to fetch the records
        component.set("v.spinner", true);
        component.set("v.lastId",'');
        var distable= '#'+component.get('v.tableid');
        
        var faction = component.get("c.generateDataSet");
        //// var fieldSetValues = component.get("v.fieldSetValues");
        // var setfieldNames = new Set();
        // if(component.get('v.reportResponse.tabResp.fieldDataList').length>0) {
        if ( $.fn.dataTable.isDataTable( distable ) ) {
         //helper.table= $(distable).DataTable();
       helper.table.destroy();
            //helper.table.rows().remove().draw();
           helper.table.clear().draw();
        }
        console.log(arrfieldNames); 
        
        faction.setParams({
            objAPIname: component.get('v.objAPIname'),
            fieldsAPIname: JSON.stringify(arrfieldNames),
            columnsLabel: columns, 
            hyperlinkColumn: component.get('v.columnForHyperLink'),
            "UserName":component.get('v.username')
            ,"SelectedBU":component.get('v.businessunit')
            ,"lastId":''
            ,"isoverdue":component.get("v.isOverdue")
            ,"pageLength":len
        });
        faction.setCallback(this, function(response) {
            
            var tableData = response.getReturnValue();
            console.log(tableData);
            //tableData =tableData.replace(/(&quot\;)/g,"\"")
            //tableData  = tableData.replace(/(&lt\;)/g,'<').replace(/(&gt\;)/g,'>').replace(/(&#39\;)/g,'\'').replace(/(&amp\;)/g,'&');
            if(!$A.util.isUndefinedOrNull(tableData)){
                var jsonData = JSON.parse(tableData);
                var dataSize = jsonData.data.length;
                component.set("v.tableRecords",jsonData.data);
                component.set("v.recordCount",jsonData.recordcount);
                console.log(jsonData);
                var casedetails = jsonData.data;
                if(jsonData.data.length>0){
                    var casestring = casedetails[dataSize-1][1];
                    var lastId = casestring.substring(
                        casestring.lastIndexOf("'>")+2, 
                        casestring.lastIndexOf("</")
                    );
                    // alert(lastId);
                    component.set("v.lastId",lastId);
                    console.log(lastId);
                    component.set("v.displaytable",true);
                  component.set("v.spinner", false);
                    if(jsonData.recordcount >len){
                        component.set("v.displayloadmore",true);
                    }else{
                        component.set("v.displayloadmore",false);
                    } 
                    
                    //rendering jquery datatable
                    setTimeout(function(){ 
                        var tableHeaders="";
                        var columnar=[];
                        $.each(jsonData.columns, function(i, val){
                            console.log("vaql : "+val);
                            tableHeaders += "<th>" + val + "</th>";
                            columnar.push(val[0]);
                        });
                        console.log(columnar);
                        component.set("v.columns", columnar);
                        //$("#tableDiv").empty();   
                        //$("#tableDiv").append('<table class="slds-table slds-table_bordered slds-table_cell-buffer" cellspacing="0" width="100%" id="displayTable"><thead><tr>' + tableHeaders + '</tr></thead></table>');
                        console.log(this.table);
                        var distable= '#'+component.get('v.tableid');
                        helper.table = $(distable).DataTable(jsonData);
                          // table.clear().draw();
                           //table.rows.add(jsonData.data); // Add new data
                           //table.columns.adjust().draw();
                           
                       // this.table = $(distable).DataTable({ "aLengthMenu": [[25, 50, -1], [25, 50, "All"]]});
                        helper.table.order( [ 0, 'desc' ] ).draw();
                                            
						
                        var length = 0;
					
                       $(distable).on( 'length.dt', function ( e, settings, len ) {
                            
                            console.log( 'New page length:fetch '+len );
                            
                                helper.fetchdetailsentries(component, event, helper,arrfieldNames,columns,len);
                            
                        });
                        
                        
                        
                        
                         $(distable+' tbody').on( 'click', 'tr', function () {
                           var data = helper.table.rows().data();
                           if(data.length != 0){
                           console.log(data);
                              
                           var d = helper.table.row( this ).data();
                            var lastId = d[1].substring(8,26);
                            helper.navigateToSObject(component,event,helper,lastId);
                            
                            }
                        } );
                         
                        //var table = $("#displayTable").dataTable(jsonData);
                        //var counter =0;
                        //counter =Math.ceil((jsonData.recordcount)/25);
                        // alert(counter);
                        //for(var i=1;i<counter;i++)
                        //helper.getrecursiveTableRows(component, event, helper);
                    }, 5); 
                    
                    //
                } else{
                    component.set("v.displaytable",false);
                    
                    component.set("v.spinner", false);
                }  
            }else{
                component.set("v.spinner", false);
            }
        })
        
        $A.enqueueAction(faction);
    },
    navigateToSObject : function(component, event, helper,lastid) {
        
        var sObjId = lastid;          
        console.log('sObjId: ' + lastid);
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        console.log('navToSObjEvt: ' + navToSObjEvt);
        navToSObjEvt.setParams({
            "recordId": lastid,
            "slideDevName": "detail"
        });	
        navToSObjEvt.fire(); 
        var daction = component.get("c.updateCase");
        daction.setParams({caseId:lastid});
        daction.setCallback(this, function(response) {
            
        });
        $A.enqueueAction(daction);
    },
    getrecursiveTableRows : function(component, event, helper){
        //component.set("v.displaytable",false);
        component.set("v.displayloadmore",false);
        var distable= '#'+component.get('v.tableid');
                
                
                var table = $(distable).DataTable();
        var info = table.page.info();

        var faction = component.get("c.generateDataSet");
        
        var arrfieldNames = []; 
        arrfieldNames = component.get("v.fieldsAPINameList");
        faction.setParams({
            objAPIname: component.get('v.objAPIname'),
            fieldsAPIname: JSON.stringify(arrfieldNames),
            columnsLabel: component.get("v.columnsLabelList"), 
            hyperlinkColumn: component.get('v.columnForHyperLink'),
            "UserName":component.get('v.username')
            ,"SelectedBU":component.get('v.businessunit')
            ,"lastId":component.get('v.lastId')
            ,"isoverdue":component.get("v.isOverdue")
            ,"pageLength":info.length
        });
        faction.setCallback(this, function(response) {
            
            var tableData = response.getReturnValue();
            console.log(tableData);
            var tempjsonData = JSON.parse(tableData);
            
            var dataSize = tempjsonData.data.length;
            component.set("v.tableRecords",tempjsonData.data);
            //component.set("v.recordCount",tempjsonData.recordcount);
            if(tempjsonData.recordcount>0){
                var casedetails = tempjsonData.data;
                //alert(component.get("v.lastId"));
                var casestring = casedetails[dataSize-1][1];
                var lastId = casestring.substring(
                    casestring.lastIndexOf("'>")+2, 
                    casestring.lastIndexOf("</")
                );
                //alert(lastId);
                component.set("v.lastId",lastId);
                component.set("v.displaytable",true);
                
                
                
                //rendering jquery datatable
                //var table = $('#displayTable').DataTable(tempjsonData);
                //https://acet-uhg--etsbedev.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage
                
                var t= table.rows().data();
                
                //setTimeout(function(){ 
                //$("#tableDiv").append('<table class="slds-table slds-table_bordered slds-table_cell-buffer" cellspacing="0" width="100%" id="displayTable"><thead><tr>' + tableHeaders + '</tr></thead></table>');
                
                
                console.log("recasdasd >>> "+this.table);
                $.each(tempjsonData.data, function(i, val){
                    console.log("Val : "+val);
                    
                    t.row.add(val).draw( false );
                });
                
                t.order( [ 0, 'desc' ] )
                .draw();
              //  t.page.len( info.length ).draw();
                var counter =table.rows().count();
                
                if(component.get("v.recordCount") == counter){
                    component.set("v.displayloadmore",false);
                }else{
                    component.set("v.displayloadmore",true);
                } 
                // }, 5);  
                
            }
        })
        
        $A.enqueueAction(faction);
    }
})