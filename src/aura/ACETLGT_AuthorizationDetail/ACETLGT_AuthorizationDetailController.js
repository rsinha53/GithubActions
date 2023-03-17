({
	doInit : function(component, event, helper) {
		
        var pageReference = component.get("v.pageReference");
        
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
        
        
        var memId = pageReference.state.c__mId;
        var groupNumber = pageReference.state.c__gId;
        var srk = pageReference.state.c__srk;
        //var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var allowedUser = pageReference.state.c__allowedUser;
        var authno = pageReference.state.c__authno;
        var authid = pageReference.state.c__authid;
        //var memId = pageReference.state.c__Id;
        var authcasetypedesc = pageReference.state.c__authcasetypedesc;
        var authType = pageReference.state.c__authtype;
        var authpredet = pageReference.state.c__authpredet;
        var authjsonstring = pageReference.state.c__jsonstring;
		
        component.set("v.AutodocKey",pageReference.state.c__AutodocKey);
        
        var hghString = pageReference.state.c__hgltPanelDataString;

        //var hpi = pageReference.state.c__hgltPanelData;
        var hpi = JSON.parse(hghString);
        console.log('highlightPanelData :: '+hpi);
        //alert('highlightPanelData json :: '+JSON.stringify(hpi));

        component.set("v.highlightPanel", hpi); 

        
        component.set("v.memberId",memId);
        component.set("v.groupId",groupNumber);
        component.set("v.srk",srk);
        component.set("v.intId",intId);
        
        //alert(memId)
        
        //string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.Create_Date+'_'+Authorization.Expected_Admit_Date+'_'+Authorization.Actual_Admit_Date+'_'+Authorization.Expected_Dscharg_Date+'_'+Authorization.Actual_Dscharg_Date+'_'+Authorization.Facility_Status+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail+'_'+Authorization.LOS;
        //out string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.Create_Date+'_'+Authorization.Start_Date+'_'+Authorization.End_Date+'_'+Authorization.ServiceProviderStatus+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.Procedure_Code+'_'+Authorization.Count+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail;
 		//fac string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.ServiceProvider+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.Procedure_Code+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail;
        component.set("v.authno",authno);
        component.set("v.authjsonstring",authjsonstring);
        
        component.set("v.authType",authType);
        component.set("v.allowedUser",allowedUser);
        
        console.log('????'+memId+srk+allowedUser+authno+authType+authid);
        helper.getAuthDetail(component,event,helper,srk,authid,authno,authpredet);
		
        //setTimeout(function(){
                //alert('----1----');
        //        window.lgtAutodoc.initAutodoc();
        //   },1);
    },
    updateAuth : function(component, event, helper) {
		console.log('Clicked update Auth');
        
        		var authno = component.get("v.authno");		// Auth Number
                
                var actionicue = component.get("c.GenerateICUEURL");
                actionicue.setParams({
                        "AuthorizationNumber": authno
                });
                actionicue.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                                var storeResponse = response.getReturnValue();                
                            console.log('storeResponse'+storeResponse);    
                            component.set("v.ICUEURL", storeResponse); 
                                helper.getICUEURL(component, event, helper);               
                        }
                });
                $A.enqueueAction(actionicue);
    }
})