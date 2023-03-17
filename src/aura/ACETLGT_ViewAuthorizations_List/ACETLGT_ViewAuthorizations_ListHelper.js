({
    render_IPC_Datatables: function(component, event, helper){
        
        //Set Unique ID for Table 1
        //var dataTblId = (new Date().getTime());
        
        var dataTblIdIC = "IPC_Datatable";
        component.set('v.dataTblId', dataTblIdIC);
        component.find("IPAccordian").set('v.activeSectionName', '');
        
        // when response successfully return from server then apply jQuery dataTable after 500 milisecond
        //setTimeout(function(){
            
            //console.log('INP Comes ::: '+dataTblId);
            
            if(dataTblIdIC === "IPC_Datatable" ){
                console.log('INP Comes ::: '+dataTblIdIC);
                $('#'+dataTblIdIC).DataTable().destroy();
            }
        	setTimeout(function(){
            $('#'+dataTblIdIC).DataTable( {
                "bInfo" : false,
                
                "paging": false,
                "ordering": true,
                "searching": false,
                "oLanguage": {"sZeroRecords": "", "sEmptyTable": ""},
                "bRetrieve": true,
                "aoColumnDefs": [
                    { "aTargets": [ 0 ], "bSortable": false },
                    { "aTargets": [ 1 ], "bSortable": true },
                    { "aTargets": [ 2 ], "bSortable": true },
                    { "aTargets": [ 3 ], "bSortable": false },
                    { "aTargets": [ 4 ], "bSortable": true },
                    { "aTargets": [ 5 ], "bSortable": true },
                    { "aTargets": [ 6 ], "bSortable": true },
                    { "aTargets": [ 7 ], "bSortable": true },
                    { "aTargets": [ 8 ], "bSortable": true },
                    { "aTargets": [ 9 ], "bSortable": false },
                    { "aTargets": [ 10 ], "bSortable": false },
                    { "aTargets": [ 11], "bSortable": false },
                    { "aTargets": [ 12], "bSortable": false }
                    
                ]  ,
                "order": [[1, 'desc'],[4,'desc']],
                "destroy": true
            });
            	
        },1); 	
        
        component.find("IPAccordian").set('v.activeSectionName', 'Inpatient_Facility_Cases');
        // var accordian = component.find("IPAccordian");
        // console.log(accordian);
        
    },
    
    
    
    render_OFC_Datatables: function(component, event, helper){
        
        //Set Unique ID for Table 2
        //var dataTblIdOFC = (component.get('v.dataTblId')+1);
        component.find("OPFAccordian").set('v.activeSectionName', '');
        
        var dataTblIdOFC = "OFC_Datatable";
        component.set('v.dataTblIdOFC', dataTblIdOFC);

        var dataTblIdIC = "IPC_Datatable";            
        $('#'+dataTblIdIC).DataTable().destroy();
        
        
        if(dataTblIdOFC === "OFC_Datatable" ){
            $('#'+dataTblIdOFC).DataTable().destroy();
        }
        
        
        // when response successfully return from server then apply jQuery dataTable after 500 milisecond
        
        setTimeout(function(){ 
            $('#'+dataTblIdOFC).DataTable( {
                "bInfo" : false,
                "paging": false,
                
                "ordering": true,
                "searching": false,
                "bRetrieve": true,
                "oLanguage": {"sZeroRecords": "", "sEmptyTable": ""},    
                "aoColumnDefs": [
                    { "aTargets": [ 0 ], "bSortable": false },
                    { "aTargets": [ 1 ], "bSortable": true },
                    { "aTargets": [ 2 ], "bSortable": true },
                    { "aTargets": [ 3 ], "bSortable": false },
                    { "aTargets": [ 4 ], "bSortable": true },
                    { "aTargets": [ 5 ], "bSortable": true },
                    { "aTargets": [ 6 ], "bSortable": true },
                    { "aTargets": [ 7 ], "bSortable": true },
                    { "aTargets": [ 8 ], "bSortable": true },
                    { "aTargets": [ 9 ], "bSortable": false },
                    { "aTargets": [ 10 ], "bSortable": false },
                    { "aTargets": [ 11], "bSortable": false }
                ],
                "sorting": [[1, 'desc'],[4,'desc']],
                "destroy": true
            });
            },1); 
        
        component.find("OPFAccordian").set('v.activeSectionName', 'Outpatient_Facility_Cases');
        
    },
    
    
    
    render_OC_Datatables: function(component, event, helper){
        
        //Set Unique ID for Table 3
        //var dataTblIdOC = (component.get('v.dataTblId')+2);
        component.find("OPAccordian").set('v.activeSectionName', '');
        
        var dataTblIdOC = "OC_Datatable";
        component.set('v.dataTblIdOC', dataTblIdOC);
        
        var dataTblIdIC = "IPC_Datatable";            
        $('#'+dataTblIdIC).DataTable().destroy();
        
        if(dataTblIdOC === "OC_Datatable" ){
            $('#'+dataTblIdOC).DataTable().destroy();
        }
        
        // when response successfully return from server then apply jQuery dataTable after 500 milisecond
        setTimeout(function(){ 
            
            $('#'+dataTblIdOC).DataTable( {
                "bInfo" : false,
                    
                "paging": false,
                "ordering": true,
                "searching": false,
                "oLanguage": {"sZeroRecords": "", "sEmptyTable": ""},    
                "bRetrieve": true,
                "aoColumnDefs": [
                    { "aTargets": [ 0 ], "bSortable": false },
                    { "aTargets": [ 1 ], "bSortable": true },
                    { "aTargets": [ 2 ], "bSortable": true },
                    { "aTargets": [ 3 ], "bSortable": false },
                    { "aTargets": [ 4 ], "bSortable": true },
                    { "aTargets": [ 5 ], "bSortable": true },
                    { "aTargets": [ 6 ], "bSortable": true },
                    { "aTargets": [ 7 ], "bSortable": false },
                    { "aTargets": [ 8 ], "bSortable": false },
                    { "aTargets": [ 9 ], "bSortable": false },
                    { "aTargets": [ 10 ], "bSortable": false },
                    { "aTargets": [ 11], "bSortable": false }
                ],
                "sorting": [[1, 'desc'],[4,'desc']],
                "destroy": true
            });

            },1);
        component.find("OPAccordian").set('v.activeSectionName', 'Outpatient_Cases');
    },
       
    
    
})