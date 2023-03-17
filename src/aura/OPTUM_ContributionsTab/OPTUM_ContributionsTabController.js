({
    getData : function(cmp, event, helper) {
    cmp.set("v.accountList",event.getParam("accountList"));
    cmp.set("v.rowIndex",event.getParam("index"));
    cmp.set("v.accountType", event.getParam("accountType"));
    var cy = new Date().getFullYear();
    cmp.set("v.currentYear", cy);
    cmp.set("v.previousYear", cy-1);
    cmp.set("v.data",cmp.get("v.accountList"));
    var totalCon= (cmp.get("v.accountList[0].nonNotionalAccountDetails[0].cyEmployeeContribution"))+(cmp.get("v.accountList[0].nonNotionalAccountDetails[0].cyEmployerContribution"));
    cmp.set("v.totalContribution",totalCon);
    var totalPy= (cmp.get("v.accountList[0].nonNotionalAccountDetails[0].pyEmployeeContribution"))+(cmp.get("v.accountList[0].nonNotionalAccountDetails[0].pyEmployerContribution"));
    cmp.set("v.totalPrevious",totalPy);
	var cyFilingStatus= (cmp.get("v.accountList[0].nonNotionalAccountDetails[0].cyFilingStatus"));
        if(cyFilingStatus == "1"){
             cmp.set("v.cyFilingStatus","Individual");
        }else{
            cmp.set("v.cyFilingStatus","Family");
        }
      var pyFilingStatus= (cmp.get("v.accountList[0].nonNotionalAccountDetails[0].pyFilingStatus"));
        if(pyFilingStatus == "1"){
             cmp.set("v.pyFilingStatus","Individual");
        }else{
            cmp.set("v.pyFilingStatus","Family");
        }
	var accType = cmp.get("v.accountType");
    if(accType == 'HSA'){
	   helper.autoDocCont(cmp, event, helper);
       helper.autoDocContForPy(cmp, event, helper);
	}
    }
})