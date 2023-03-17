({ 
    doInit:function(component,event,helper) {
 },
 onLoad: function(component,event,helper) { 
         
         var d = new Date();
         var m = d.getMilliseconds();
         var tableID = component.get("v.lgt_dt_table_name")+'_lgt_dt_table_ID'+m; 
         component.set("v.lgt_dt_table_ID",tableID); 
      var tablewrapperid = '#'+tableID+'_tablewrapper';
             setTimeout(function() { 

     $(tablewrapperid).css("display","none");
                          },1);
    },
    tableinit : function(component,event,helper) {
    //helper.showspinnerhelper(component,event,helper);
    
        
    var tableId = "#" +component.get("v.lgt_dt_table_ID");
       
        $(tableId).find("th").css("transform","");
        setTimeout(function() { 
        var DT_Object = JSON.parse(component.get("{!v.lgt_dt_DT_Object}"));
        if(!$A.util.isEmpty(DT_Object.lgt_dt_PageSize)){
            component.set("v.lgt_dt_PageSize",DT_Object.lgt_dt_PageSize);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_serviceObj)){
            component.set("v.lgt_dt_serviceObj",DT_Object.lgt_dt_serviceObj);
        }        if(!$A.util.isEmpty(DT_Object.lgt_dt_serviceName)){
            component.set("v.lgt_dt_serviceName",DT_Object.lgt_dt_serviceName);
        }        if(!$A.util.isEmpty(DT_Object.lgt_dt_isPagenationReq)){
            component.set("v.lgt_dt_isPagenationReq",DT_Object.lgt_dt_isPagenationReq);
        }        if(!$A.util.isEmpty(DT_Object.lgt_dt_columns)){
            component.set("v.lgt_dt_columns",DT_Object.lgt_dt_columns);
        }        if(!$A.util.isEmpty(DT_Object.lgt_dt_SortBy)){
            component.set("v.lgt_dt_SortBy",DT_Object.lgt_dt_SortBy);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_SortDir)){
            component.set("v.lgt_dt_SortDir",DT_Object.lgt_dt_SortDir);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_searching)){
            component.set("v.lgt_dt_searching",DT_Object.lgt_dt_searching);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_lock_headers)){
            component.set("v.lgt_dt_lock_headers",DT_Object.lgt_dt_lock_headers);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_PageNumber)){
            component.set("v.lgt_dt_PageNumber",DT_Object.lgt_dt_PageNumber);
        }if(!$A.util.isEmpty(DT_Object.lgt_dt_StartRecord)){
            component.set("v.lgt_dt_StartRecord",DT_Object.lgt_dt_StartRecord);
        }
      var processtable = helper.processDataTable(component,event,helper);

         },1);
    },
    onPrev: function(component,event,helper) {
                helper.showspinnerhelper(component,event,helper);
        var pagenum = component.get("v.lgt_dt_currentPageNumber");
        var tabkey = component.get("v.AutodocKey");
        if(pagenum != undefined)
        	window.lgtAutodoc.storePaginationData(pagenum,tabkey);
        var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
             table.page('previous').draw( 'page' );
    },
    onNext : function(component,event,helper) {
              helper.showspinnerhelper(component,event,helper);
       var pagenum = component.get("v.lgt_dt_currentPageNumber");
        var lgt_dt_totalPages = component.get("v.lgt_dt_totalPages");
        var processpage;
       var tabkey = component.get("v.AutodocKey");
       if(pagenum != undefined)
      	window.lgtAutodoc.storePaginationData(pagenum,tabkey);
        if(lgt_dt_totalPages>pagenum){
           processpage = pagenum;
        }else if(lgt_dt_totalPages == pagenum){
            processpage = pagenum;
        }
       
        if(processpage != undefined){
       var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
           table.page(processpage).draw( 'page' );    
        }
    },
    onFirst: function(component,event,helper) {
                helper.showspinnerhelper(component,event,helper);
        var pagenum = component.get("v.lgt_dt_currentPageNumber");
        var tabkey = component.get("v.AutodocKey");
        if(pagenum != undefined)
        	window.lgtAutodoc.storePaginationData(pagenum,tabkey);
          var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
             table.page('first').draw( 'page' );
    },
    onLast:function(component,event,helper) {
            helper.showspinnerhelper(component,event,helper);
        var pagenum = component.get("v.lgt_dt_currentPageNumber");
        var tabkey = component.get("v.AutodocKey");
       	if(pagenum != undefined)
       		window.lgtAutodoc.storePaginationData(pagenum,tabkey);
        var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
        table.page('last').draw( 'page' );
    },
    processMe:function(component,event,helper) {
        
            helper.showspinnerhelper(component,event,helper);
        var pagenum = component.get("v.lgt_dt_currentPageNumber");
        var tabkey = component.get("v.AutodocKey");
       	if(pagenum != undefined)
       		window.lgtAutodoc.storePaginationData(pagenum,tabkey);
   var selectdpage = parseInt(event.target.name)-1;
               var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
             table.page(selectdpage).draw( 'page' );
     },
    searchintable:function(component,event,helper) {
       
       var value = event.target.value;
       value = value.toLowerCase();
        var tablefilter = "[id$='"+component.get("v.lgt_dt_table_ID")+"'] tbody tr";
    $(tablefilter).filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
    },
    clearTable_event:function(component,event,helper) {
        try{
    var tableid = '#'+component.get("v.lgt_dt_table_ID");
       
    var table = $(tableid).DataTable();
          var tablewrapperid = tableid+'_tablewrapper';
     $(tablewrapperid).css("display","none");
    component.set("v.DTWrapper",'');
       $(tableid).find("tbody").remove();
       $(tableid).find("thead").remove();
        }
        catch(err){
            console.log('Error-->',err.message);
        }
    }
    
})