({
    waitingTimeId: null,
    setStartTimeOnUI : function(component) {
        component.set("v.ltngstart",true);
        component.set("v.ltngstop",false);
        var currTime =component.get("v.ltngTimmer");
        var ss = '';
        if(currTime != null && currTime != undefined){
        	ss = currTime.split(":");
        }
        var dt = new Date();
        dt.setHours(ss[0]);
        dt.setMinutes(ss[1]);
        dt.setSeconds(ss[2]);
        
        var dt2 = new Date(dt.valueOf() - 1000);
        var temp = dt2.toTimeString().split(" ");
        var ts = '';
        if(ts != null && ts != undefined){
        	ts = temp[0].split(":");
        }
            component.set("v.ltngHourd",ts[0]);
            component.set("v.ltngMinuted",ts[1]);
            component.set("v.ltngSecondd",ts[2]);

        component.set("v.ltngTimmer",ts[0] + ":" + ts[1] + ":" + ts[2]);
        this.waitingTimeId =setTimeout($A.getCallback(() => this.setStartTimeOnUI(component)), 1000);
        if(ts[0]==0 && ts[1]==0 && ts[2]==0 ){
            component.set("v.ltngstart",true);
            component.set("v.ltngstop",true);
            component.set("v.ltngend",true);
            component.set("v.ltngmessage","Time EXPIRED");
           // $A.util.removeClass(component.find("txtmsg"), "slds-hide");
            window.clearTimeout(this.waitingTimeId);
        }
    },
    setStopTimeOnUI : function(component) {
        component.set("v.ltngstart",false);
        component.set("v.ltngstop",true);
        window.clearTimeout(this.waitingTimeId);
        var calcstoptime = component.get("v.ltngHourd")+"."+component.get("v.ltngMinuted")+"."+component.get("v.ltngSecondd");
        var action = component.get("c.updatecaserec");
        action.setParams({ caseid : component.get("v.recordId"), stoptime: calcstoptime,isprojend: false});        
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('case record updated successfully.');
            }
          });  
        $A.enqueueAction(action);

    },
    setResetTimeOnUI : function(component) {
        component.set("v.ltngstart",true);
        component.set("v.ltngstop",true);
        component.set("v.ltngend",true);
        window.clearTimeout(this.waitingTimeId);
        var calcstoptime = component.get("v.ltngHourd")+"."+component.get("v.ltngMinuted")+"."+component.get("v.ltngSecondd");
        var action = component.get("c.updatecaserec");
        action.setParams({ caseid : component.get("v.recordId"), stoptime: calcstoptime,isprojend: true});        
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('case record updated successfully.');
            }
          });  
        $A.enqueueAction(action);

    },
    getcaserecinfo : function(component) {
        var action = component.get("c.getcaserec");
        action.setParams({ caseid : component.get("v.recordId")});        
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('case record info got successfully.');
                component.set("v.casedetail",response.getReturnValue());
                if(!$A.util.isUndefinedOrNull(component.get("v.casedetail")) && !$A.util.isEmpty(component.get("v.casedetail"))){
                  var caseprjctime = component.get("v.casedetail").Project_Time__c;
                  var caseprjend = component.get("v.casedetail").Is_Project_Time_End__c;  
                  if(!$A.util.isUndefinedOrNull(caseprjctime) && !$A.util.isEmpty(caseprjctime)){  
                    var res = caseprjctime.split(".");
                    var res1 = res[0];
                    var res2 = res[1];
                    var res3 = res[2];
                    component.set("v.ltngHourd",res1);
                    component.set("v.ltngMinuted",res2);  
                    component.set("v.ltngSecondd",res3);  
                  }
                  if(!$A.util.isUndefinedOrNull(caseprjend) && !$A.util.isEmpty(caseprjend)){  
                      if(caseprjend == true){
                        component.set("v.ltngstart",true);
			            component.set("v.ltngstop",true);
			            component.set("v.ltngend",true);
                      }
                  }	
        	  }
            }
          });  
        $A.enqueueAction(action);
    }
})