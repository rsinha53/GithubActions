({
    decodeMemberId : function(helper, encodedStr) {
        var keyStr = "subid";
        var keybyteArr;
        var dec;
        var decoded = "" ;
        
        keybyteArr = helper.string2byte(keyStr);
        dec = helper.base64ToArrayBuffer(encodedStr);
        
        var decodedArray = helper.RC4(dec, keybyteArr);
        decoded = new TextDecoder().decode(decodedArray);
        
        return decoded;
    },
    base64ToArrayBuffer : function (base64) {
        var binary_string = window.atob(base64);
        var len = binary_string.length;
        var bytes = new Uint8Array(len);
        for (var i = 0; i < len; i++) {
            bytes[i] = binary_string.charCodeAt(i);
        }
        return bytes;
    },
    string2byte : function (str) {
        let byteArray = []
        for (let j=0; j < str.length; j++) {
            byteArray.push(str.charCodeAt(j));
        }
        return byteArray
    },
    RC4 : function (bytes, key) {
        const s = new ArrayBuffer(256);
        const k = new ArrayBuffer(256);
        var temp;
        var i = 0;
        var j = 0;
        var n;
        for(i = 0; i < 256; i++) {
            s[i] = i;
            k[i] = key[i % key.length];
        }
        
        var tempCount = 0;
        for(n = 128; n < 256; n++) {
            s[n] = -128 + tempCount;
            tempCount++;
        }
        
        j = 0;
        for(i = 0; i < 256; i++) {
            j = (j + s[i] + k[i]) & 255;
            temp = s[i];
            s[i] = s[j];
            s[j] = temp;
        }
        
        i = 0;
        j = 0;
        for(var x= 0; x < bytes.length; x++) {
            i = (i + 1) & 255;
            j = (j + s[i]) & 255
            temp = s[i];
            s[i] = s[j];
            s[j] = temp;
            var t = (s[i] + s[j]) & 255;
            bytes[x] ^= s[t];
        }
        
        return bytes;
    },
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    // call the alerts method and set back response : US2382023 - Sunil Vennam 
    callAlertsApi : function(component,event,helper) {   
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.selectedMemberDOB");
        var memFirstName = component.get("v.memberFirstName");
        var memLastName = component.get("v.memberLastName");
        var memberPolicy = component.get("v.memberPolicy");
        /*var memberId = '456404844';
        var memDob = '04/20/1978';
        var memFirstName = 'Jack';
        var memLastName = 'Bauer';
        var memberPolicy = '03L0329';*/
        var action = component.get("c.callEpmpAlertsAPI"); 
        // Pass details to apex class
        action.setParams({ 
            memberId : memberId,
            memDob : memDob,
            memFirstName : memFirstName,
            memLastName : memLastName,
            memberPolicy : memberPolicy
        });
        action.setCallback(this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                var result = response.getReturnValue(); 
                if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                    if (!$A.util.isEmpty(result.alertList) && !$A.util.isUndefined(result.alertList) && !$A.util.isEmpty(result.alertList.status) && !$A.util.isUndefined(result.alertList.status) && !$A.util.isEmpty(result.alertList.status.messages) && !$A.util.isUndefined(result.alertList.status.messages) && !$A.util.isUndefined(result.alertList.status.messages) && !$A.util.isUndefined(result.alertList.status.messages.message) && !$A.util.isUndefined(result.alertList.status.messages.message) ) {   
                        console.log('Alerts result -- >>', JSON.stringify(result.alertList.status.messages.message));
                        component.set("v.alertsDetails", result.alertList.status.messages.message);
                        
                        //alert( JSON.stringify(result.alertList.status.messages.message));
                        var stuff = result.alertList.status.messages.message;
                        var nps='',gp='',nea='' ,iea='',nmp='',imp='',ngf='';
                        
                        if(!$A.util.isEmpty(stuff) && !$A.util.isUndefined(stuff)){ 
                            component.set("v.isMemberPrefFlagsExist", true);
                            
                            stuff.forEach(function(item) {
                                var type = item.type_X;
                                var lDesc = item.longDescription + ' Click flag for Advocate action.';
                                switch (type) {
                                    case 'NPS':
                                        nps = lDesc;
                                        component.set('v.prefMsg',lDesc) ;
                                        component.set('v.prefFlag',true) ;    
                                        break;
                                    case 'GP':
                                        gp = lDesc;
                                        component.set('v.prefMsg',lDesc) ;
                                        component.set('v.prefFlag',true) ;    
                                        break;
                                    case 'NEA':
                                        nea = lDesc;
                                        component.set('v.emailMsg',lDesc) ;
                                        component.set('v.emailFlag',true) ;   
                                        break;
                                    case 'IEA':
                                        iea = lDesc;    
                                        component.set('v.emailMsg',lDesc) ;
                                        component.set('v.emailFlag',true) ;    
                                        break;
                                    case 'NMP':
                                        nmp = lDesc;    
                                        component.set('v.phoneMsg',lDesc) ;
                                        component.set('v.phoneFlag',true) ;    
                                        break;
                                    case 'IMP':
                                        imp = lDesc;    
                                        component.set('v.phoneMsg',lDesc) ;
                                        component.set('v.phoneFlag',true) ;    
                                        break;
                                    case 'NGF':
                                        ngf = lDesc;    
                                        component.set('v.phoneMsg',lDesc) ;
                                        component.set('v.phoneFlag',true) ;    
                                        break;
                                    default:
                                        break;      
                                }
                            });
                            
                            if(ngf != '' && nmp != ''){
                                component.set('v.phoneFlag',true) ;
                                var label_NoGANNoMob = $A.get("$Label.c.ADBPhoneFlagNoPhoneCustomMessage");
                                component.set('v.phoneMsg',label_NoGANNoMob) ;    
                            }
                            if(ngf != '' && imp != ''){
                                component.set('v.phoneFlag',true) ;
                                var label_InvalidPhone = $A.get("$Label.c.ADBPhoneFlagInvalidPhoneCustomMessage");
                                component.set('v.phoneMsg',label_InvalidPhone) ;    
                            } 
                        }else{
                            component.set("v.isMemberPrefFlagsExist", false);
                        }     
                    }  
                }
            }
        });
        $A.enqueueAction(action);                                                
    },
    
    calculateAge : function(component,event,helper,dayofbirth) {
        var today = new Date();
                var birthDate = new Date(dayofbirth);
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
        return age;
    },
    callFIMService : function(component){
        var action = component.get("c.callFIMService");
        console.log('caller dob form dashboard: ',  component.get("v.callerDateofBirth"));
        var callerDOB = component.get("v.callerDateofBirth");
        var convertedDOB;
        var  arrDOB;
        if(!$A.util.isEmpty(callerDOB)){
            arrDOB = callerDOB.split('/');
            if(!$A.util.isEmpty(arrDOB) && arrDOB.length == 3){
                convertedDOB = arrDOB[2] + '-' + arrDOB[0] + '-' + arrDOB[1];
            }
        }
        if(!$A.util.isEmpty(convertedDOB)){
            // Pass details to apex class
            action.setParams({
                memId : component.get('v.decodedMemberId'),//'77641511400',
                dob : convertedDOB//'1986-10-27'
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();

                    // For Testing Financials component with Mock or actual data to FIm not in sync comment it and deploy in qa201
                    // uncomenting in qa 201 by devops team for testing suopport
                    // result.fimResponseCode = 200;
                    // result.callerSSN = '713797013';

                    if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                        component.set("v.FIMWrapper", result);
                        console.log('FIM : ', result);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
	 getPopupDetails : function(component, event, helper,memDob){
        var action = component.get("c.getCallerPopupDetails"); 
        
        // Get member Id & Member DOB to pass as a V2 request
        var memberId = component.get("v.decodedMemberId");
        console.log('member id -- member profile', memberId);
        var memFirstName = component.get("v.memberFirstName");
        var memLastName = component.get("v.memberLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var DOB = memDob;
        console.log('DOB value in getPopupDetails'+DOB);
        // change date format as per the request
        if(DOB != undefined){
            var memberDOB = DOB.split("/");
            var memberdob = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
            console.log('member dob member profile', memberdob);
        }
        console.log('in dashboard parent-> memberId'+memberId+'::memberDob'+memberdob+'::firstName'+memFirstName+'::lastName'+memLastName+'::groupNumber'+memberPolicy);
        // Pass details to apex class
        // String firstName,String lastName,String groupNumber
        action.setParams({ 
            memberId : memberId ,
            memberDob : memberdob,
            firstName: memFirstName,
            lastName: memLastName,
            groupNumber: memberPolicy
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                console.log('display pops pops::', records);
                var policyStatus = records.policyStatus;
                    var errorMessage = records.errorMessage;
                if(errorMessage == "terminated"){
                    console.log('verified its terminated policy');
                    component.set('v.policyTerminated',true);
                }
                if(records.effectiveDate != null){
                    var efdate = records.effectiveDate;
                    var efdatesplit = efdate.split('-');
                    records.effectiveDate = efdatesplit[1]+ '/' +efdatesplit[2]+ '/' +efdatesplit[0];
                }
                if(records.endDate != null){
                    var endDate = records.endDate;
                    var endDatesplit = endDate.split('-');
                    records.endDate = endDatesplit[1]+ '/' +endDatesplit[2]+ '/' +endDatesplit[0];
                }
                // set the response to display popup details
                component.set("v.displayPops", records); 
                
                		//to display age of selected member
                if(component.get('v.selectedMemberDOB') != undefined){
                    var selectedmemDob = component.get("v.selectedMemberDOB");
                    var selectedMemberAge = this.calculateAge(helper,selectedmemDob);
                    component.set("v.selectedMemberAge", selectedMemberAge);
                }else  if(component.get('v.memberDOB') != undefined){
                    var mdob = component.get('v.memberDOB');
                    var selectedMemberAge = this.calculateAge(helper,mdob);
                    component.set("v.selectedMemberAge", selectedMemberAge);
                }
                console.log('eligibility transaction Id::'+records.transactionId);
                var transactionId = records.transactionId;
                if(transactionId != undefined && transactionId != null){
                    console.log('transaction Id not null..hence calling extended eligibility and eligibility language preference services');
                
                    component.set("v.transactionId", transactionId);
                }
                console.log("calling fire oop");
                helper.fireOOPEvent(component, event, helper);
                //Call Component Event
                //helper.memEliEvent(component, event, helper);
            }
            
            
        });
        
        $A.enqueueAction(action);    
    },
    
    fireOOPEvent : function(component, event, helper){
        var cmpEvent = $A.get("e.c:ADB_OutofPocketEvent");
        console.log("in-event"+component.get("v.displayPops"));
        var displayPops = component.get("v.displayPops");
        cmpEvent.setParams( {"displayPops" : displayPops});
        cmpEvent.fire();
    }
      															
})