({
 doInit : function(component, event, helper) {
       var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
       component.set('v.todaysdate',today);
       component.set("v.Spinner", true);
       component.set("v.accumsOlddatesearch", component.get("v.accumsdatesearch"));
     	
  },  
 populatedate  : function(component, event, helper) {
     var todaysdate = component.get("v.todaysdate");
     component.find("dateinptid").set("v.value", todaysdate );
 },
 validateSearch : function(component, event, helper) {
      var tabAutodocKey = component.get("v.accumAutodocKey");
       //alert(tabAutodocKey);
       setTimeout(function(){
         //alert('---1--'+ 'Coverage line change');
            window.lgtAutodoc.saveBenefitsAutodocSelections(tabAutodocKey,'accumulators');
            window.lgtAutodoc.saveBenefitsAutodocSelections(tabAutodocKey,'coverageoverview');
            component.set("v.accumsOlddatesearch", component.get("v.accumsdatesearch"));
            //window.lgtAutodoc.clearAutodocSelections(tabAutodocKey); 
       }, 1);
       var covInfoBenefits = component.get("v.attrcoverageBenefits");
       var returnError = false;  
       if(covInfoBenefits != undefined){
           var dtcmp = component.find("dateinptid").get("v.value");
           var dtfld= component.find("dateinptid");
           var dateReg = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
           var dateReg1 = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
            var benstartDate = component.get("v.selectedBenefitStrtDt");
            var benendDate = component.get("v.selectedBenefitEndDt");
            var accumsdateSearch = component.get("v.accumsdatesearch");
            var accumsrch = $A.localizationService.formatDate(dtcmp, "MM/DD/YYYY");
     	 
           if(dtcmp== null || dtcmp== undefined ||dtcmp ==''){
               component.set("v.accumsdatesearch",dtcmp);
               component.set("v.errormsg",'Error: Invalid Date.' );
               returnError = true; 
           }
		   else if(!dtcmp.match(dateReg) && !dtcmp.match(dateReg1)){
               component.set("v.accumsdatesearch",dtcmp);
			   component.set("v.errormsg",'Error: Invalid Date.' );
               returnError = true; 
		   }
           else if(new Date(accumsrch) < new Date(benstartDate) || new Date(accumsrch) > new Date(benendDate)){
             component.set("v.errormsg",'Error: Date selected outside of coverage period.' );
             returnError = true; 
           }
           else if(accumsdateSearch.match(dateReg) || dtcmp.match(dateReg1)){
               component.set("v.Spinner", true);                
               var sechdDT = $A.localizationService.formatDate(accumsrch, "YYYY-MM-DD");
               component.set("v.errormsg",'' );  
             // helper.validateDate(component,event,helper,covInfoBenefits);
               helper.getAccumSearchResultsUPdtd(component,event,helper,covInfoBenefits,sechdDT);
               returnError = true; 
		   }
       }
         if(returnError) {            
            return;  
        }
        
   },
    showResults : function(component,event,helper) {
       /** var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.accumGUIkey",GUIkey);*/ 
        var covInfoBenefits = component.get("v.attrcoverageBenefits");
        helper.validateDate(component,event,helper,covInfoBenefits);
        helper.getAccumSearchResults(component,event,helper,covInfoBenefits); 
        component.set("v.accumsOlddatesearch", component.get("v.accumsdatesearch"));
        
    },
    toggleHelpTextHover: function(component, event, helper) {
        var innHover = component.get("v.isInnHoverVisible");
        var oonHover = component.get("v.isOnnHoverVisible");
        if('inn' == event.target.dataset.section) {
            component.set("v.isInnHoverVisible", !innHover);
        }else if('onn' == event.target.dataset.section) {
            component.set("v.isOnnHoverVisible", !oonHover);
        }
    }
  
})