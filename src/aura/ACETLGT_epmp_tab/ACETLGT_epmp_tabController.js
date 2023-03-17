({
	doInit : function(component, event, helper) {
	   var subid = component.get("v.pageReference").state.c__memberid;
      console.log('EPMP_URL_'+localStorage.getItem("EPMP_URL_"+subid));
        component.set("v.epmpurl", localStorage.getItem("EPMP_URL_"+subid));
        localStorage.removeItem("EPMP_URL_"+subid);
          
	}
})