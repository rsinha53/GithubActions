({
    doInit: function(component, event, helper) {
       
        if (component.get("v.pageReference") != null) {
            var pagerefarance = component.get("v.pageReference");
            var memid = component.get("v.pageReference").state.c__memberid;
            var srk = component.get("v.pageReference").state.c__srk;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.memberid', memid);
            component.set('v.srk', srk);
            component.set("v.usInfo", uInfo);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            component.set('v.AutodocKey', intId + 'materialsRequest');
            var bookOfBusinessTypeCode = '';
            if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
                bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            }
           
            console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            if(bookOfBusinessTypeCode =='LF'||bookOfBusinessTypeCode=='OL'){
                $A.util.addClass(component.find("formstagid"), "slds-hide");
            }else{
              $A.util.addClass(component.find("lfmessagetagid"), "slds-hide");
            }            
            var hghString = pagerefarance.state.c__hgltPanelDataString;
            console.log('hghString====>'+hghString);
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            component.set("v.pagerefaranceobj", pagerefarance);
                    
            localStorage.removeItem(memid+'_orderSubmitted');
        }
        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberid");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
        }
        
    },
   /* onchange_Start_Date: function(component, event, helper) {
      
       var Start_Date = component.find('Start_Date_Auraid').get("v.value");
        debugger;
        var covertedstartDate = $A.localizationService.formatDate(Start_Date, "MM/DD/YYYY");
        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        debugger;
        var Start_Date_cmp = component.find('Start_Date_Auraid');
       if (Start_Date != null && today < covertedstartDate) {
            debugger;
            Start_Date_cmp.setCustomValidity("Error: Start Date must be less than or equal to today's date.");
	   }
      
         Start_Date_cmp.reportValidity();
    },*/
    onchangeordertype: function(component, event, helper) {
        var ordertypevalue = component.get("v.ordertypevalue");
        if (ordertypevalue != 'New_Order') {
         /*   var startdate = new Date(new Date().setDate(new Date().getDate() - 30));
            var today = $A.localizationService.formatDate(startdate, "MM/DD/YYYY");
            var enddate = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
            component.find('Start_Date_Auraid').set("v.value", today);
            component.find('end_date_auraid').set("v.value", enddate);*/
        } else{
     setTimeout(function(){
            var tabKey = component.get("v.AutodocKey");
//            alert("tabKey"+tabKey);
         if(window.lgtAutodoc != undefined){
             window.lgtAutodoc.initAutodoc(tabKey);
         }
            //alert("Done");
            //var MemberdetailFromGroup = component.get("v.MemberdetailFromGroup").enrollmentMethod;
            //alert("Done-1");
            //var orgType = component.get("v.originatorType");
            //console.log("SSS Coverage Benefit" + MemberdetailFromGroup);
//        	component.set("v.Spinner", false);
//            alert('done');
            
        },1);
//        alert('here2');
        }
    },
    onclick_Search: function(component, event, helper) {
        var validtion;
         var dateReg = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
         var dateReg1 =/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/;
        var Start_Date = component.find('Start_Date_Auraid').get("v.value");
        var covertedstartDate = $A.localizationService.formatDate(Start_Date, "MM/DD/YYYY");
        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        var Start_Date_cmp = component.find('Start_Date_Auraid');

        if(Start_Date=='' && covertedstartDate =='Invalid Date'){
             component.set('v.strtErrorMessage',"Error: You must enter a value");
             validtion='false';
        }else if (today < covertedstartDate && Start_Date.match(dateReg1) ) {
             component.set('v.strtErrorMessage',"Error: Start Date must be less than or equal to today's date.");
     	       validtion='false';
        }else if(covertedstartDate =='Invalid Date' || ((covertedstartDate != Start_Date) && (! covertedstartDate.match(dateReg) || !Start_Date.match(dateReg1)))){
              component.set('v.strtErrorMessage',"Error: Your entry does not match the allowed format M/D/YYYY.");
             validtion='false';
        } else{
            component.set('v.strtErrorMessage',"");
     	       validtion='true';
        }
        if(validtion == 'true'){
            //component.set('v.dataTblId', new Date().getTime());
         //   setTimeout(function(){ 
            var enddate = component.find('end_date_auraid').get("v.value");
            var startdate = component.find('Start_Date_Auraid').get("v.value");
            var pagerefarance = component.get("v.pagerefaranceobj");
            var action = component.get("c.searchOrderHistory");
            var memberid = component.get("v.memberid");
       //     helper.processtablehelper(component, event, helper,startdate,enddate,memberid);
       }
    },
    onclick_Clear: function(component, event, helper) {
        var startdate = new Date(new Date().setDate(new Date().getDate() - 30));

        var today = $A.localizationService.formatDate(startdate, "MM/DD/YYYY");
        component.find('Start_Date_Auraid').set("v.value", today);
        component.set("v.formshistoryresultlist", '');
        var Start_Date_cmp = component.find('Start_Date_Auraid');
            $("input:checked").each.prop("checked", false);
            alert('here2');
        // Start_Date_cmp.setCustomValidity("");
        //Start_Date_cmp.reportValidity();
        component.set("v.totalPages", '');
        //    var startdate = new Date(new Date().setDate(new Date().getMonth() - 1));

        //component.find('Start_Date_Auraid').set("v.value",startdate.getFullYear()+'/'+startdate.getMonth()+'/'+startdate.getDate());


    },
  
    
    onPrev: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('previous').draw('page');
    },
    onNext: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('next').draw('page');
    },
    onFirst: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('first').draw('page');
    },
    onLast: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('last').draw('page');
    },
    processMe: function(component, event, helper) {
        var selectdpage = parseInt(event.target.name) - 1;
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page(selectdpage).draw('page');
    },
    startAutodoc:function(component,event,helper){
//  alert('here');
     setTimeout(function(){
            var tabKey = component.get("v.AutodocKey");
//            alert("tabKey"+tabKey);
            if(window.lgtAutodoc != undefined)
            	window.lgtAutodoc.initAutodoc(tabKey);
            //alert("Done");
            //var MemberdetailFromGroup = component.get("v.MemberdetailFromGroup").enrollmentMethod;
            //alert("Done-1");
            //var orgType = component.get("v.originatorType");
            //console.log("SSS Coverage Benefit" + MemberdetailFromGroup);
//        	component.set("v.Spinner", false);
//            alert('done');
            
        },1);
//        alert('here2');
  }
})