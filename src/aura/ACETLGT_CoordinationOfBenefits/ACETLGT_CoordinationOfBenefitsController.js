({
    onInit : function(component, event, helper) {
		//Page Reference
        var pageReference = component.get("v.pageReference");


        //TTS Data
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId; 
        var memid = pageReference.state.c__memberid;

        //alert(cseTopic+' '+srk+' '+int+' '+intId+' '+memid);
        
        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memid);
        
        var hpi = pageReference.state.c__hgltPanelData;
        

        var hghString = pageReference.state.c__hgltPanelDataString;
        
        hpi = JSON.parse(hghString);
        component.set("v.highlightPanel", hpi);
        console.log('highlightPanelData :: '+JSON.stringify(hpi));
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        
        let cobData = {};
        cobData.firstName = pageReference.state.c__fname;
        cobData.gender = pageReference.state.c__memGender;
        cobData.lastName = pageReference.state.c__lname;
        cobData.mName = pageReference.state.c__mName;
        cobData.suffixName = pageReference.state.c__suffixName;
        cobData.SSN = pageReference.state.c__SSN;
        cobData.dob = pageReference.state.c__va_dob;
        cobData.relationship = hpi.originatorRel;
        cobData.groupNumber = hpi.GroupNumber;
        cobData.relationshipCode = hpi.subjectRelationCode;
        cobData.memberId = hpi.MemberId;
        cobData.scrId = hpi.SubscriberId;
        component.set('v.cobData',cobData);
        console.log('cobData :: '+JSON.stringify(cobData));
        //var memid=hpi.MemberId;
		var grpnumber = hpi.GroupNumber;
		component.set("v.grpNum", grpnumber);

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



        ////////////////////////

        var srk = component.get("v.srk");
		var memId = component.get("v.memId"); 
		var grpNum = component.get("v.grpNum");
		var coveffdate = pageReference.state.c__coveffdate;
		
		var action = component.get("c.getFamilyMembershipResults");
		
		console.log('------srk----'+srk);
        console.log('------grpnumber----'+grpNum);
		console.log('------coveffdate----'+coveffdate);
		console.log('------MemId----'+memId);
		
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

                    //alert(JSON.stringify(result));
                    console.log("result service ::: " +JSON.stringify(result));
                    
                    console.log("result from service ---> " + result);
                    console.log('~~~~~------result--------'+result);

                    //alert('Test 1 ');

                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper) && !$A.util.isEmpty(result.resultWrapper.lstCOB) && !$A.util.isUndefined(result.resultWrapper.lstCOB)){
                            //alert('Values ::: -> ::: '+JSON.stringify(result.resultWrapper.lstCOB));
                            console.log('Values ::: -> ::: '+JSON.stringify(result.resultWrapper.lstCOB));
                            component.set("v.cobList",result.resultWrapper.lstCOB);
                           
                        }
                        else{
                        	console.log('retValue.ErrorMessage : ', result.ErrorMessage);
                        	helper.displayToast('Error!', result.ErrorMessage); 
                        }
					}
                } else if(state == "ERROR"){
					console.log('Error Logged !');
                }
                component.set('v.Spinner',false);
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);

        ///////////////////////
        
        var appEvent = $A.get("e.c:ACETLGT_COBValidationEvent");
        appEvent.setParams({
            validation : component.get('v.validationErrorOther') ||component.get('v.validationErrorGov')
        });
        appEvent.fire();


    },
    validationFire : function(component,event,helper){
        var appEvent = $A.get("e.c:ACETLGT_COBValidationEvent");
        appEvent.setParams({
            validation : component.get('v.validationErrorOther') ||component.get('v.validationErrorGov')
        });
        appEvent.fire();
    }
})