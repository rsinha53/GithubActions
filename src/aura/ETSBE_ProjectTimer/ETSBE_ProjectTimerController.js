({
    doInit : function(component, event, helper) {
        console.log("diinit get called!!");
        //var tt=component.get("v.ltngHour")+":"+component.get("v.ltngMinute")+":"+component.get("v.ltngSecond");
        component.set("v.ltngTimmer","00:00");
        component.set("v.ltngHourd","00");
        component.set("v.ltngMinuted","00");
        component.set("v.ltngSecondd","00");
		helper.getcaserecinfo(component);
        
    },
    handleStartClick : function(component, event, helper) {
        console.log("start button clicked!!");
        var timezone = $A.get("$Locale.timezone");
        console.log('Time Zone Preference in Salesforce ORG :'+timezone);
        var now = new Date().toLocaleString("en-US", {timeZone: timezone});
               
        console.log('Time Zone Preference in Salesforce now :'+now);
        
        var newnow = new Date(now);
        console.log('--------------newnow------'+newnow);
               
        console.log('Time Zone Preference type:'+typeof now);
        now =newnow.setDate(newnow.getDate()+1); 
        console.log('Time Zone Preference :'+now);
                        
        //var now = new Date();
       // now.setHours( now.getHours() + 24 );
        var date = new Date(now);
        var d = new Date();
        console.log('==date==>'+date)
        console.log('==d==>'+d)
        var hours=component.get("v.ltngHourd");
        var minutes=component.get("v.ltngMinuted");
        var seconds=component.get("v.ltngSecondd");
        var tt=component.get("v.ltngHour")+":"+component.get("v.ltngMinute")+":"+component.get("v.ltngSecond");
        
        if(tt=="0:0:0" || tt=="00:00:00"){
        }
        else{
            component.set("v.ltngTimmer",hours+":"+minutes+":"+seconds);
            component.set("v.ltngHourd",hours);
            component.set("v.ltngMinuted",minutes);
            component.set("v.ltngSecondd",seconds);
            
            helper.setStartTimeOnUI(component);
        }
    },
    handleStopClick : function(component, event, helper) {
        console.log("stop button clicked!!");
        var currtt=component.get("v.ltngTimmer");
        var ss = '';
        if(currtt != null && currtt != undefined){
        	ss = currtt.split(":");
        }
        component.set("v.ltngHour",ss[0]);
        component.set("v.ltngMinute",ss[1]);
        component.set("v.ltngSecond",ss[2]);
        helper.setStopTimeOnUI(component);
    },
    handleResetClick : function(component, event, helper) {
        console.log("Reset button clicked!!");
        helper.setResetTimeOnUI(component);
    } 
})