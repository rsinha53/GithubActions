({
	processtablehelper : function(component, event, helper,enddate,startdate,memberid) {
		debugger;
             var lgt_dt_DT_Object = new Object();
            lgt_dt_DT_Object.startdate = startdate;
           lgt_dt_DT_Object.enddate = enddate;
            lgt_dt_DT_Object.idQualifier = memberid;
    lgt_dt_DT_Object.lgt_dt_PageSize = '1';
    lgt_dt_DT_Object.lgt_dt_SortBy = -1;
    lgt_dt_DT_Object.lgt_dt_SortDir = '';
    lgt_dt_DT_Object.lgt_dt_serviceObj = '';
    lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
    lgt_dt_DT_Object.lgt_dt_StartRecord ='1';
    lgt_dt_DT_Object.lgt_dt_PageNumber='1';
    lgt_dt_DT_Object.lgt_dt_searching = false;  
debugger;
  //  lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCPWebservice';
    lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Provider ID","defaultContent":"","data":"providerId","type": "string"},{"title":"Name","defaultContent":"","data":"fullName","type": "string"},{"title":"Provider Type","defaultContent":"","data":"providerType","type": "string"},{"title":"Tax ID","defaultContent":"","data":"taxId","type": "number"},{"title":"Address","defaultContent":"","data":"address","type": "string"},{"title":"Phone Number","defaultContent":"","data":"phoneNumber","type": "string"},{"title":"Specialty","defaultContent":"","data":"speciality","type": "string"},{"title":"PCP Role","defaultContent":"","data":"PCPRole","type": "string"},{"title":"PCP/OBGYN ID","defaultContent":"","data":"pcpObgnID","type": "string"},{"title":"Gender","defaultContent":"","data":"gender","type": "string"},{"title":"UHPD","defaultContent":"","data":"uphd","type": "string"},{"title":"Platinum","defaultContent":"","data":"Platinum","type": "string"},{"title":"Radius","defaultContent":"","data":"radious","type": "string"},{"title":"Address Status","defaultContent":"","data":"providerLocationAffiliationsStatusCode","type": "string"}]');
    component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        debugger;

        
   // var lgt_dt_Cmp = component.find("orderhistorycmp");  
         //   lgt_dt_Cmp.tableinitload();
	}
    
})