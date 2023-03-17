({
    onInit : function(component, event, helper) {

        var pageReference = component.get("v.pageReference");
        
        //TTS Data
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId; 
        var memid = pageReference.state.c__Id;
        var grpnumber = pageReference.state.c__gId;

        //Get user Info
        var userProfile = pageReference.state.c__userProfile;
        component.set("v.uInfo", userProfile);     

        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memid);  
        component.set("v.grpNum", grpnumber);
        
		var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        
        var hpi = pageReference.state.c__hgltPanelData;
        console.log('highlightPanelData :: '+ hpi.benefitBundleOptionId);
        //alert('highlightPanelData json :: '+JSON.stringify(hpi));

        var hghString = pageReference.state.c__hgltPanelDataString;
        hpi = JSON.parse(hghString);
        component.set("v.highlightPanel", hpi);
        

        //Alerts Data
        var intId = component.get("v.intId");

        if(intId != undefined ){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
        }


        //All to do with Autodoc
        var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.AutodocKey", GUIkey);


        var action = component.get("c.getFamilyMembershipResults");
        var errormsg = '';
        helper.showSpinner2(component,event,helper);
        
        var coveffdate = pageReference.state.c__coveffdate;
        console.log('------srk----'+srk);
        console.log('------grpnumber----'+grpnumber);
        console.log('------coveffdate----'+coveffdate);
        var result = true;
        
        //alert('srk : '+srk+' grpNum : '+grpnumber+' coveffdate'+coveffdate);

        //action.setStorable();
        if(result && grpnumber != undefined && srk != undefined){
                        
            // Setting the apex parameters
            action.setParams({
                srk: srk,
                groupNumber: grpnumber,
                effectiveDate: coveffdate,
                memberId:memid
            });
            
            //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('~~~~----state---'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    errormsg = result.ErrorMessage;  
                    //alert(JSON.stringify(result));
                    console.log("result service ::: " +JSON.stringify(result));

                    console.log("result from service ---> " + result);
                    console.log('~~~~~------result--------'+result);
                    if( $A.util.isEmpty(result.ErrorMessage) &&!$A.util.isEmpty(result) && !$A.util.isUndefined(result)&&!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                            component.set("v.Memberdetail",result.resultWrapper);
                            console.log('result.resultWrapper.FamilyMembers : ', JSON.stringify(result.resultWrapper.FamilyMembers));
                            component.set("v.FamilyMemberList",result.resultWrapper.FamilyMembers);
                            console.log(JSON.stringify(result.resultWrapper.FamilyMembers));
                    }
                    else{
                    	helper.displayToast('Error!', errormsg, component, helper, event);
                    }  
                } else if(state == "ERROR"){
                    component.set("v.Memberdetail");
                }
                helper.hideSpinner2(component, event, helper);

                var tabKey = component.get("v.AutodocKey")+ 'SM';

                setTimeout(function(){
                    //alert("Hello");
                    window.lgtAutodoc.initAutodoc(tabKey);
                    
                },1);
                
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);

        }
 
        var startDate = new Date();
		startDate.setDate(startDate.getDate() - 365);
        var sDay = $A.localizationService.formatDate(startDate, "YYYY-MM-DD");
    	component.set('v.startDate', sDay);  
        
       	var endDate = new Date();
		endDate.setDate(endDate.getDate());
        var eDate = $A.localizationService.formatDate(endDate, "YYYY-MM-DD");
    	component.set('v.endDate', eDate);
 
        
    },
  
    dateUpdate : function(cmp, event, helper) {
        
        //var sDate = component.get("v.startDate");
        var sDate = cmp.find("startDate").get("v.value");
        var inputStart_Date = new Date($A.localizationService.formatDate(sDate));
        inputStart_Date.setDate(inputStart_Date.getDate()+365);
        //inputStart_Date.setMonth(inputStart_Date.getMonth());
        console.log(inputStart_Date);
        
        var eDate = $A.localizationService.formatDate(inputStart_Date, "YYYY-MM-DD");
    	cmp.set('v.endDate', eDate);
    },
    
    submitOrderCtrl : function(component, event, helper) {        
        helper.submitOrderHandler(component, event, helper);        
        helper.hideSpinner(component);
    }

})