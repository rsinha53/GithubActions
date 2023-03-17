({ 
    doInit:function(component,event,helper) {
 },
 onLoad: function(component,event,helper) { 
         
         var d = new Date();
         var m = d.getMilliseconds();
         var tableID = component.get("v.lgt_dt_table_name")+'_lgt_dt_table_ID'+m; 
         component.set("v.lgt_dt_table_ID",tableID); 
       var ordertypevalue = component.get("v.ordertypevalue");
        if (ordertypevalue != 'New_Order') {
            var startdate = new Date(new Date().setDate(new Date().getDate() - 30));
            var today = $A.localizationService.formatDate(startdate, "MM/DD/YYYY");
            var enddate = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
            component.find('Start_Date_Auraid').set("v.value", today);
            component.find('end_date_auraid').set("v.value", enddate);
        } 
    },
    onclick_Search : function(component,event,helper) {
var lgt_dt_DT_Object = new Object();
    lgt_dt_DT_Object.lgt_dt_PageSize = '1';
    lgt_dt_DT_Object.lgt_dt_SortBy = -1;
    lgt_dt_DT_Object.lgt_dt_SortDir = '';
    lgt_dt_DT_Object.lgt_dt_serviceObj = '';
    lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
    lgt_dt_DT_Object.lgt_dt_StartRecord ='1';
    lgt_dt_DT_Object.lgt_dt_PageNumber='1';
    lgt_dt_DT_Object.lgt_dt_searching = false;  
    lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Request Date/Time","defaultContent":"","data":"requestdate","type": "string"},{"title":"Document Name","defaultContent":"","data":"documentname","type": "string"},{"title":"Status","defaultContent":"","data":"status","type": "string"},{"title":"Mailed Date/Time","defaultContent":"","data":"maileddate","type": "number"},{"title":"Recipient","defaultContent":"","data":"recipient","type": "string"},{"title":"Address","defaultContent":"","data":"Address","type": "string"},{"title":"Source","className":"sourcecls","data":"source","type": "string"}]');

             var processtable = helper.processDataTable(component,event,helper,lgt_dt_DT_Object); 

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
       var tabkey = component.get("v.AutodocKey");
       if(pagenum != undefined)
      	window.lgtAutodoc.storePaginationData(pagenum,tabkey);
       var table = $('#'+component.get("v.lgt_dt_table_ID")).DataTable();
             table.page('next').draw( 'page' );
        
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
    onclick_Clear:function(component,event,helper) {
          var startdate = new Date(new Date().setDate(new Date().getDate() - 30));

        var today = $A.localizationService.formatDate(startdate, "MM/DD/YYYY");
        component.find('Start_Date_Auraid').set("v.value", today);
        component.set("v.formshistoryresultlist", '');
        var Start_Date_cmp = component.find('Start_Date_Auraid');
    var tableid = '#'+component.get("v.lgt_dt_table_ID");
    var table = $(tableid).DataTable();
    component.set("v.DTWrapper",'');
       $(tableid).find("tbody").remove();
       $(tableid).find("thead").remove();
    }
})