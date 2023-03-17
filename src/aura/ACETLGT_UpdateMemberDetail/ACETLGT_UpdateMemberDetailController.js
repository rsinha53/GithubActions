({
    //US2100280
    doInit : function(component, event, helper) {	
        helper.getStateOptions(component);
        //TTS Data
        var pageReference = component.get("v.pageReference");
        //var userData = pageReference.state.c__topicList;
        
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__Id;
        var grpNum = pageReference.state.c__gId;  
        var enrollmentMethod = pageReference.state.c__enrollmentMethod;  
        
        var hpi = pageReference.state.c__hgltPanelData;
        //alert('highlightPanelData json :: '+JSON.stringify(hpi));

        var hghString = pageReference.state.c__hgltPanelDataString;
        hpi = JSON.parse(hghString);

		var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);

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
        




        component.set("v.highlightPanel", hpi);

        //  DEF276790
        var d = new Date();
        var timeStamp = d.getTime();
        component.set("v.timeStamp", timeStamp);


        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.grpNum", grpNum);
		component.set("v.enrollmentMethod", enrollmentMethod);
        if(enrollmentMethod!='Paper Only'){
            component.set("v.disabledemographics",true);
        }
        var intId = component.get("v.intId");

        if(intId != undefined ){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
        }

        //	retrieve member information and populate in the UI
        helper.getMemberInformation(component, event, helper);
        var additionalUpdates = [];
        let update = {};
        update.updateType = 'Language Spoken';
        additionalUpdates.push(update);
        let update2 = {};
        update2.updateType = 'Language Written';
        additionalUpdates.push(update2);
        let update3 = {};
        update3.updateType = 'Foreign Address';
        additionalUpdates.push(update3);
        component.set("v.additionalUpdates",additionalUpdates);
        
    },
    
    handleRecordChanged: function(component, event, helper) {
        if(component.get("v.CurrentUser").Profile.Name=='Research User'){
            component.set("v.disabledemographics",true);
        }
    },
    clearHandler : function(component, event, helper) {
        //	retrieve member information and restore in the UI
        component.set("v.email","");
        var memberId = component.get("v.memId");
        var timeStamp = component.get("v.timeStamp");

        var resolvedCheckBox = document.getElementById('isResolvedEmail' + memberId);
        if(resolvedCheckBox != null)
        	resolvedCheckBox.checked = false;
        
        helper.getMemberInformation(component, event, helper);
        helper.removeEmailErrors(memberId, timeStamp);
        component.set("v.additionalUpdates", []);
        component.set("v.isFailedUpdate", false);
        component.set("v.isSuccessUpdate", false);
    },
    
    updatememberdetails: function(component, event, helper) {
        component.set("v.openconfirmmodal",true);
    },
    
    cancelupdate: function(component, event, helper) {
        component.set("v.openconfirmmodal",false);
    },
    
    updatedetails: function(component, event, helper) {
        component.set("v.openconfirmmodal",false);
        component.set("v.isUpdating", true);
        var errormsg = '';
        let demographdata = {};
        demographdata.memberId = component.get("v.memId");
        demographdata.scrId = component.get("v.highlightPanel").SubscriberId;
        demographdata.groupNumber = component.get("v.grpNum");
        demographdata.lastName = component.get("v.lastname");
        demographdata.firstname = component.get("v.firstname");
        demographdata.middleName = component.get("v.middlename");
        demographdata.nameSuffix = component.get("v.suffix");
        demographdata.ssn = component.get("v.ssn");
        demographdata.gender = component.get("v.gender");
        demographdata.dob = component.get("v.dob");
        demographdata.relationshipcode = component.get("v.highlightPanel").subjectRelationCode;
        var action = component.get("c.updateMemberDemographics");
        action.setParams({
            demographicData: JSON.stringify(demographdata),
            addressData: JSON.stringify(component.get("v.addresslist"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();               
            if (state == "SUCCESS") {  
                component.set("v.isUpdating", false);
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                    if(result.Success){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": 'Success',
                            "message": 'Updated Successfully',
                            "type": "success",
                            "mode": "dismissible"
                        });
                        toastEvent.fire();
                    }else{
                        errormsg = result.ErrorMessage;
                		helper.displayToast('Error!', errormsg, component, helper, event);
                    }
                }
               
            } else if (state == "ERROR") {
                component.set("v.isUpdating", false);                        
                helper.displayToast('Error!', errormsg, component, helper, event);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    updateaddress: function(component, event, helper) {
        var addlist = component.get("v.addresslist");
        var selectedAnsIdx = event.currentTarget.getAttribute('data-ansIndex');
        var selectedType = event.currentTarget.getAttribute('data-id');
        var selectedval = event.target.value;
        for(var i=0; i<addlist.length; i++){
            if(i==selectedAnsIdx){
                if(selectedType==='add1'){
                    addlist[i].addressLine1=selectedval;
                }else if(selectedType==='add2'){
                    addlist[i].addressLine2=selectedval;
                }else if(selectedType==='city'){
                    addlist[i].city=selectedval;
                }else if(selectedType==='state'){
                    addlist[i].stateCode=selectedval;
                }else if(selectedType==='zip'){
                    addlist[i].postalCode=selectedval;
                }
            }
        }
        component.set("v.addresslist",addlist);
    },
    updatefirstname: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.firstname",selectedval);
    },
    updatelastname: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.lastname",selectedval);
    },
    updatemiddlename: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.middlename",selectedval);
    },
    updatesuffix: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.suffix",selectedval);
    },
    updatedob: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.dob",selectedval);
    },   
    updategender: function(component, event, helper) {
        var selectedval = event.target.value;
        component.set("v.gender",selectedval);
    },
 
})