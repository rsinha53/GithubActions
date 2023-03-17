({
    fetchMockStatus : function(component) { 
        let action = component.get("c.getMockStatus");
        action.setCallback( this, function(response) {
            let state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.isMockEnabled", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    fetchExlusionMdtData : function( component,event, helper ) {
        let action = component.get("c.getOptumExlusions");
        action.setCallback( this, function( response ) {
            let state = response.getState();
            if( state === "SUCCESS") {
                
                component.set( "v.lstExlusions", response.getReturnValue() );
                let lstExclusions = component.get("v.lstExlusions");
            } else {
                console.log('##UNKNOWN-STATE:',state);
            }
        });
        $A.enqueueAction(action);
    },
    callHouseHoldWS : function(component,event,helper) {
        
        var action = component.get("c.getHouseHoldData");
        action.setParams({
            "transactionId": component.get("v.tranId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            
            if(state == 'SUCCESS') {
                //US1857687
                var result = response.getReturnValue();
                
                component.set("v.houseHoldData",result.resultWrapper.houseHoldList);
                var houseHoldList = component.get("v.houseHoldData");
                var memberRelationship = '';
                if(houseHoldList != undefined && houseHoldList != null && houseHoldList.length > 0) {
                    for(var i=0; i<houseHoldList.length; i++) {
                        if(houseHoldList[i].isMainMember == true) {
                            memberRelationship = houseHoldList[i].relationship;
                            
                            component.set("v.relationShip",memberRelationship);
                            break;
                        }
                    }    
                }
            } else {
                //US1857687
                // helper.hideGlobalSpinner(component);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    navigateToRecord : function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");   
        navEvt.setParams({ 
            "recordId": component.get("v.RequestDetailObjectRecordID"),
            "slideDevName": "detail"
        });  
        navEvt.fire();
        
    },
    
    navigateToCaseRecord : function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");   
        navEvt.setParams({ 
            "recordId": component.get("v.caseRecordID"),
            "slideDevName": "detail"
        });  
        navEvt.fire();      
        
    },
    
    noFuturedate  : function (component){
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; 
        var yyyy = today.getFullYear();
        let button = component.find('disablebuttonid');
        var validdata = this.validateRequired(component,event, this);
       if(dd < 10){
            dd = '0' + dd;
        } 
       if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.DateOfBirth") != '' && component.get("v.DateOfBirth") > todayFormattedDate){
            component.set("v.dobvalidationError" , true);
        }else{
            component.set("v.dobvalidationError" , false);           
        }   
        
        if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError") && validdata==true){            
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true); 
        }
           
            
          
    },
    
    navigateToStreamRecord : function (component, event, helper){
        
        var navEvt = $A.get("e.force:navigateToSObject");   
        navEvt.setParams({ 
            "recordId": component.get("v.RequestDetailObjectRecordID"),
            "slideDevName": "detail"
        });  
        navEvt.fire();
        
    },
    
    showSuccessToast: function(component, event, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();     
    },
    
    /*Added:Change:Not Exists*/
    fireToast :function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            //message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();  
        
    },
    
    showInformationalToast : function(component, event, helper, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();  
        
    },
    
    showErrorToast : function(component, event, helper, message){       
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        
    },
    
    refreshComponent : function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    },
    
    fetchRelatioshipPicklist : function(component){
        var action = component.get("c.getRelationshipValues");
        action.setParams({
            'platform': component.get("v.Platform"),
            
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.relationShipPicklist", a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },  
    
    fetchGenderPicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.Gender"),
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.GenderPicklist",a.getReturnValue());
                console.log('return value' +a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    fetchDelvryPrefPicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.deliveryPreffered"),
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.delPreferencePicklist",a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    /*  showRequiredFields: function(component, event, helper){              
       $A.util.removeClass(component.find("Input_contract_type__c"), "none");
     }, */
    
    validateRequired:function(component, event, helper){
        //debugger;
        var valid=false;
        var counter = 0;
        
        var reltnion = component.find("reltnion");
        if (!$A.util.isUndefinedOrNull(reltnion)) {
            var reltnionValid = reltnion.get("v.validity");
            
            if(reltnionValid.valid == false){
                counter =counter+1;
            }
            reltnion.showHelpMessageIfInvalid();
        }
        
        var firstName = component.find("firstname");
        if (!$A.util.isUndefinedOrNull(firstName)) {
            var firstNameValid = firstName.get("v.validity");
            
            if(firstNameValid.valid == false){
                counter =counter+1;
            }
            firstName.reportValidity();
        }
        var lastname = component.find("lastname");
        if (!$A.util.isUndefinedOrNull(lastname)) {
            var lastnameValid = lastname.get("v.validity");
            
            if(lastnameValid.valid == false){
                counter =counter+1;
            }
            
            lastname.reportValidity();
        }
        var dateofbirth = component.find("dateofbirth");
        if (!$A.util.isUndefinedOrNull(dateofbirth)) {
            var dateofbirthValid = dateofbirth.get("v.validity");
            
            if(dateofbirthValid.valid == false){
                counter =counter+1;
            }
            dateofbirth.reportValidity();
        }       
        
        var genID = component.find("genID");
        if (!$A.util.isUndefinedOrNull(genID)) {
            var genIDValid = genID.get("v.validity");
            //alert(genIDValid);
            
            if(genIDValid.valid == false){
                counter =counter+1;
            }
            console.log(genIDValid.ValidityState);
            genID.showHelpMessageIfInvalid();
            //genID.reportValidity();
        }
        
        var empID = component.find("empID");
        if (!$A.util.isUndefinedOrNull(empID)) {
            var empIDValid = empID.get("v.validity");
            
            if(empIDValid.valid == false){
                counter =counter+1;
            }
            empID.reportValidity();
        }
        
        var ssnId = component.find("ssnId");
        if (!$A.util.isUndefinedOrNull(ssnId)) {
            var ssnIdValid = ssnId.get("v.validity");
            
            if(ssnIdValid != undefined){
            if(ssnIdValid.valid == false){
                counter =counter+1;
            }
            }
            ssnId.reportValidity();
        }
        var addrs = component.find("addrs");
        if (!$A.util.isUndefinedOrNull(addrs)) {
            var addrsValid = addrs.get("v.validity");
            
            if(addrsValid.valid == false){
                counter =counter+1;
            }
            addrs.reportValidity();
        }
        var cty = component.find("cty");
        if (!$A.util.isUndefinedOrNull(cty)) {
            var ctyValid = cty.get("v.validity");
            
            if(ctyValid.valid == false){
                counter =counter+1;
            }
            cty.reportValidity();
        }        
        var stat = component.find("stat");
        if (!$A.util.isUndefinedOrNull(stat)) {
            var statValid = stat.get("v.validity");
            
            if(statValid.valid == false){
                counter =counter+1;
            }
            stat.reportValidity();
        }
        
        var zp = component.find("zp");
        if (!$A.util.isUndefinedOrNull(zp)) {
            var zpValid = zp.get("v.validity");
            
            if(zpValid.valid == false){
                counter =counter+1;
            }
            zp.reportValidity();
        }
        let button = component.find('disablebuttonid'); 
        if(counter>0){
            valid= false;
            button.set('v.disabled',true);
        }
        else{
            button.set('v.disabled',false);
            valid=true;
        }
        return valid;     
    },
    setRequiredfields : function(component, event, helper){
        
        var relatImp = component.find("reltnshp")
        var relatVal=relatImp.get("v.value");
        
        var addrInp=component.find("addrs");
        var addVal = addrInp.get("v.value");
        
        var cityInp=component.find("cty");
        var cityVal=cityInp.get("v.value");
        
        var stateInp=component.find("stat");
        var stateVal=stateInp.get("v.value");
        
        var zipInp=component.find("zp");
        var zipval= zipInp.get("v.value");
        
        
        
        if(relatVal="Employee"){
            if(addVal==null || addVal===''){
                addrInp.setCustomValidity('Enter a Address');
            }
            if(cityVal==null || cityVal===''){
                cityInp.setCustomValidity('Enter a City');
            }
            if(stateVal==null || stateVal===''){
                stateInp.setCustomValidity('Enter a State');
            }  
            if(zipval==null || zipval===''){
                zipInp.setCustomValidity('Enter a Zip');
            }
            
            addrInp.reportValidity();
            cityInp.reportValidity();
            stateInp.reportValidity();
            zipInp.reportValidity();     
        }
        
    },
    
    countRelationship : function(enrolleeRecordList){
        var childRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Child');
        }, 0);             
        
        var spouseRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Spouse');
        }, 0); 
        
        var studentRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Student');
        }, 0); 
        
        var employRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Employee');
        }, 0);
        
        var domPartRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Domestic Partner');
        }, 0);
        
        var disabDepndntRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Disabled Dependent');
        }, 0);
        
        var overageDepRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Overage Dependent/Young Adult');
        }, 0);
        
        var retireeRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Retiree');
        }, 0);
        
        var survivingRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Surviving Spouse');
        }, 0);
        
        
        
        var stndRelatn = enrolleeRecordList.reduce(function (n, person) {
            return n + (person.relationship == 'Student');
        }, 0);
        
        var totaldependentcount=childRelatn+spouseRelatn+studentRelatn+domPartRelatn+disabDepndntRelatn+overageDepRelatn+retireeRelatn+survivingRelatn+stndRelatn+employRelatn;
        return totaldependentcount;
        
    },
    
    validateChild :  function(component,enrolleeRecordListVar){
       /* var message='1.You must enter the same amount of enrollees as specified in the family section.\n';
        message+= '2.You must submit an "EE" enrollee.';
        
        var message1='You must enter the same amount of enrollees as specified in the family section.';
        var message2='You must submit an "EE" enrollee.';*/
        
        var message3='1.The relationship types of the enrollees created does not match what was selected.';
        var message4='2.You must submit an "EE" enrollee.';
        
        var message5='1.The relationship types of the enrollees created does not match what was selected.\n';
        message5+= '2.You must submit an "EE" enrollee.';
        
        var childRelatn = enrolleeRecordListVar.reduce(function (n, person) {
            return n + (person.relationship == 'Child');
        }, 0);
        
        if(component.get("v.ChildCount")==1){
            // alert('34');
            if(childRelatn>=1 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                            
            }else if(childRelatn!=1 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){  
                this.showSuccessToast(component,event,message3);
            }else if(childRelatn>=1 && enrolleeRecordListVar.some(code => code.relationship != 'Employee')){  
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                        
            
        }else if(component.get("v.ChildCount")==2){
            //alert('35');
            if(childRelatn>=2 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                              
            }else if(childRelatn!=2 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);                            
            }else if(childRelatn>=2 && enrolleeRecordListVar.some(code => code.relationship != 'Employee')){                            
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                          
        }else if(component.get("v.ChildCount")==3){
            //alert('36');
            if(childRelatn>=3 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                                 
            }else if(childRelatn!=3 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);                
            }else if(childRelatn>=3 && enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                               
        }else if(component.get("v.ChildCount")==4){
            //alert('37');
            if(childRelatn>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                                 
            }else if(childRelatn!=4 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);                
            }else if(childRelatn>=4 && enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                               
        }else if(component.get("v.ChildCount")==5){
            //alert('38');
            if(childRelatn>=5 && enrolleeRecordList.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                                 
            }else if(childRelatn!=5 && enrolleeRecordList.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);               
            }else if(childRelatn>=5 && enrolleeRecordList.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                               
        }else if(component.get("v.ChildCount")==6){
            //alert('39');
            if(childRelatn>=6 && enrolleeRecordList.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                                 
            }else if(childRelatn!=6 && enrolleeRecordList.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);               
            }else if(childRelatn>=6 && enrolleeRecordList.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message4);
            } else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                               
        }else if(component.get("v.ChildCount")>=7){
            //alert('40');
            if(childRelatn>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                component.set("v.isEmployeeRelatnCreated",true);                                 
            }else if(childRelatn!=7 && enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);                
            }else if(childRelatn>=7 && enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message4);
            }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message3);
            }else{                            
                this.showSuccessToast(component,event,message5);
            }                               
        }
    },
    
    validateNoChild :  function(component, enrolleeRecordListVar, familySec){

        var message='1.The relationship types of the enrollees created does not match what was selected.\n';
        message+='2.You must enter the same amount of enrollees as specified in the family section.\n';
        message+= '3.You must submit an "EE" enrollee.';
        
        var message2='1.The relationship types of the enrollees created does not match what was selected.\n';
        message2+='2.You must enter the same amount of enrollees as specified in the family section.';
        
        var message3='1.The relationship types of the enrollees created does not match what was selected.\n';
        message3+='2.You must submit an "EE" enrollee.';
        
        var message4='2.You must submit an "EE" enrollee.';
        
        var message5='1.The relationship types of the enrollees created does not match what was selected.';  
        
        var message6='2.You must enter the same amount of enrollees as specified in the family section.';
        
       /* var message1='You must enter the same amount of enrollees as specified in the family section.';
        var message2='You must submit an "EE" enrollee.';
        
        var message3='1.The relationship types of the enrollees created does not match what was selected';
        var message4='2.You must submit an "EE" enrollee.';
        
        var message5='1.The relationship types of the enrollees created does not match what was selected.\n';
        message5+= '2.You must submit an "EE" enrollee.';*/
        
        var childRelatn = enrolleeRecordListVar.reduce(function (n, person) {
            return n + (person.relationship == 'Child');
        }, 0);
        
        var enrolleeRecordListVar = component.get("v.enrolleeObjectList");
        var countEnrolless=this.countRelationship(enrolleeRecordListVar);
        //alert(countData);
        if(!familySec.includes("Child(ren)")){
            
            if(familySec=='Employee'){
                //alert('1 Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    component.set("v.isEmployeeRelatnCreated",true);  
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                    this.showSuccessToast(component,event,message4);
                }
                
            }
            if(familySec=='Spouse'){
               //alert('2nd Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse')){
                    component.set("v.isEmployeeRelatnCreated",true); 
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<=1){
                    this.showSuccessToast(component,event,message2);
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>1){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>1){
                    this.showSuccessToast(component,event,message3); 
                } else{
                    this.showSuccessToast(component,event,message);
                }                   
            }
            if(familySec=='Domestic Partner/Civil Union'){
                //alert('3rd Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner')){                        
                    component.set("v.isEmployeeRelatnCreated",true); 
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<=1){
                    this.showSuccessToast(component,event,message2);
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>1){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>1){
                    this.showSuccessToast(component,event,message3); 
                } else{
                    this.showSuccessToast(component,event,message);
                }                       
            } 
            if(familySec.includes("Employee") && familySec.includes("Spouse") && familySec.includes("Domestic Partner/Civil Union")){
                //alert('All 3 Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner')){
                    component.set("v.isEmployeeRelatnCreated",true);                        
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<=2){
                    this.showSuccessToast(component,event,message2);
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&  countEnrolless>2){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>2){
                    this.showSuccessToast(component,event,message3);
                }else{
                     this.showSuccessToast(component,event,message);
                }
                           
            }
            if(familySec.includes("Spouse") && familySec.includes("Domestic Partner/Civil Union") && !familySec.includes("Employee")){
                //alert('2 and 3 Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner'))){
                    component.set("v.isEmployeeRelatnCreated",true);                        
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless<=2)){
                    this.showSuccessToast(component,event,message2);                     
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless>2)){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>2 && (enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner'))){
                    this.showSuccessToast(component,event,message4);                     
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>2){
                        this.showSuccessToast(component,event,message3);  
                }else{
                     this.showSuccessToast(component,event,message); 
                }        
            } 
            if(familySec.includes("Employee") && familySec.includes("Spouse") && !familySec.includes("Domestic Partner/Civil Union")){
                // alert('1 and 2 Selected');
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && enrolleeRecordListVar.some(code => code.relationship === 'Spouse'))){
                    component.set("v.isEmployeeRelatnCreated",true);                        
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless<=1)){
                    this.showSuccessToast(component,event,message2);                     
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless>1)){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee' && countEnrolless>1)){
                    this.showSuccessToast(component,event,message3);                     
                }else{
                    this.showSuccessToast(component,event,message); 
                }     
            }
            if(familySec.includes("Employee") && familySec.includes("Domestic Partner/Civil Union") && !familySec.includes("Spouse")){
               // alert('1 and 3 Selected');
                console.log('enrolee var here' +JSON.stringify(enrolleeRecordListVar));
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner'))){
                    component.set("v.isEmployeeRelatnCreated",true);                        
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless<=1)){
                    this.showSuccessToast(component,event,message2);                     
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee' && countEnrolless>1)){
                    this.showSuccessToast(component,event,message5);
                }else if(enrolleeRecordListVar.some(code => code.relationship !== 'Employee' && countEnrolless>1)){               
                    this.showSuccessToast(component,event,message3);                     
                }else{
                     this.showSuccessToast(component,event,message); 
                }                                        
            }
        }
        else{
            //When Child Includes in All combinations
            if(familySec.includes("Employee") && familySec.includes("Spouse") && familySec.includes("Domestic Partner/Civil Union") && familySec.includes("Child(ren)")){   
              // alert('1 2,3 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                }else if(component.get("v.ChildCount")==2){
                   if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                    
                }else if(component.get("v.ChildCount")==3){
                   if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                    
                }else if(component.get("v.ChildCount")==4){
                   if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                   }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                    
                }else if(component.get("v.ChildCount")==5){
                   if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                    
                }else if(component.get("v.ChildCount")==6){
                   if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }           
                } else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){                        
                        component.set("v.isEmployeeRelatnCreated",true);                                                                           
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<10){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=10){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=10 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=10){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message); 
                    }
                }                                               
            }else if(familySec.includes("Employee") && familySec.includes("Child(ren)") && !familySec.includes("Spouse") && !familySec.includes("Domestic Partner/Civil Union")){
                //alert('1 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<2){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=2){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=2){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=2 && childRelatn>=1 ){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                } else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<3){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3 && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }  else if(component.get("v.ChildCount")==3){
                    //alert('56')
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }else if(component.get("v.ChildCount")==4){
                    //alert('56')
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }else if(component.get("v.ChildCount")==5){
                    //alert('56')
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }else if(component.get("v.ChildCount")==6){
                    //alert('56')
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }else if(component.get("v.ChildCount")>=7){
                    //alert('56')
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true);   
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                         
                }
                
            }else if(familySec.includes("Employee") && familySec.includes("Spouse") && familySec.includes("Child(ren)")){
                //alert('1, 2 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<3){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                            
                }else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }   
                }else if(component.get("v.ChildCount")==3){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                
                }else if(component.get("v.ChildCount")==4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                
                }else if(component.get("v.ChildCount")==5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                
                }else if(component.get("v.ChildCount")==6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                
                }else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                
                }
                
            }else if(familySec.includes("Employee") && familySec.includes("Domestic Partner/Civil Union") && familySec.includes("Child(ren)")){
               // alert('1 , 3 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<3){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                                                        
                }else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }                            
                }else if(component.get("v.ChildCount")==3){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    } 
                }else if(component.get("v.ChildCount")==4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    } 
                }else if(component.get("v.ChildCount")==5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    } 
                }else if(component.get("v.ChildCount")==6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    } 
                }else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    } 
                }
            }else if(familySec.includes("Spouse") && familySec.includes("Child(ren)") && !familySec.includes("Domestic Partner/Civil Union")){
                 //alert('2 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<3){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message3);
                    }else{
                          this.showSuccessToast(component,event,message);
                     }  
                }else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==3){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }
                
            }else if(familySec.includes("Domestic Partner/Civil Union") && familySec.includes("Child(ren)") && !familySec.includes("Spouse")){
                //alert('3 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<3){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=3){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }     
                }else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==3){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }
                
            }else if(familySec.includes("Spouse") && familySec.includes("Domestic Partner/Civil Union") && familySec.includes("Child(ren)")){
                //alert('2, 3 and 4 Selected');
                if(component.get("v.ChildCount")==1){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=1){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<4){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=1){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=4){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==2){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=2){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<5){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=2){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=5){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==3){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=3){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<6){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=3){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=6){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=4){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<7){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=4){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=7){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=5){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<8){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=5){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=8){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")==6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=6){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<9){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=6){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=9){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }else if(component.get("v.ChildCount")>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && childRelatn>=7){
                        component.set("v.isEmployeeRelatnCreated",true); 
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless<10){
                        this.showSuccessToast(component,event,message2);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') && countEnrolless>=10){
                        this.showSuccessToast(component,event,message5);                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=10 && enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') && enrolleeRecordListVar.some(code => code.relationship === 'Spouse') && childRelatn>=7){
                        this.showSuccessToast(component,event,message4);
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && countEnrolless>=10){
                        this.showSuccessToast(component,event,message3);
                    }else{
                        this.showSuccessToast(component,event,message);
                    }
                }
            }
            
        }
    },
    
    validateDependentCount  : function(component,enrolleeRecordListVar,dependentCount,totaldependentcount){
        var message='1.You must have an Enrollee for each termed dependent.\n';
        message+='2.You must submit an EE Enrollee.';
        
        var message3='You must enter the same amount of enrollees as specified in the family section.';
        
        var message1='You must submit an EE Enrollee.';
        var message2='You must have an Enrollee for each termed dependent.';
        
        if(dependentCount===1){                     
            if(component.get('v.counter')>=2){
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                   (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                    enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                    //alert('26');
                    if(totaldependentcount>=1){
                        // alert('44');
                        component.set("v.isEmployeeRelatnCreated",true);  
                    }else{
                        this.showSuccessToast(component,event,message1); 
                    }                              
                    
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){ 
                    //alert('1');
                    this.showSuccessToast(component,event,message2);                            
                }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                    //alert('2');
                    this.showSuccessToast(component,event,message1);
                }                                                      
            }
            else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);
                
            }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                this.showSuccessToast(component,event,message1);                
            } else{
                this.showSuccessToast(component,event,message);
                
            }                                          
        }
        else if(dependentCount===2){
            if(component.get('v.counter')>=3){
                if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                   (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                    enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                    enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                    //alert('28');
                    if(totaldependentcount>=2){
                        component.set("v.isEmployeeRelatnCreated",true);  
                    }else{
                        this.showSuccessToast(component,event,message2); 
                    }  
                    
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                    this.showSuccessToast(component,event,message2);                            
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                    this.showSuccessToast(component,event,message1);   
                }                                                     
            }
            else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                this.showSuccessToast(component,event,message2);               
            } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=2){
                this.showSuccessToast(component,event,message1);                
            }                      
             else{
                this.showSuccessToast(component,event,message);     
             }                                              
            
        }
            else if(dependentCount==3){
                if(component.get('v.counter')>=4){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                       (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                        enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                        //alert('29');
                        if(totaldependentcount>=3){
                            component.set("v.isEmployeeRelatnCreated",true);  
                        }else{
                            this.showSuccessToast(component,event,message2); 
                        }                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                        this.showSuccessToast(component,event,message2);                            
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                        this.showSuccessToast(component,event,message1); 
                    }                                                      
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);
                    
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=3){
                    this.showSuccessToast(component,event,message1);                
                }                                 
                 else{
                    this.showSuccessToast(component,event,message);     
                 }                      
            } else if(dependentCount==4){
                if(component.get('v.counter')>=5){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                       (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                        enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                        //alert('30');
                        if(totaldependentcount>=4){
                            component.set("v.isEmployeeRelatnCreated",true);  
                        }else{
                            this.showSuccessToast(component,event,message2); 
                        }                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                        this.showSuccessToast(component,event,message2);                            
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                        this.showSuccessToast(component,event,message1); 
                    }                                                      
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);
                    
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=4){
                    this.showSuccessToast(component,event,message1);                
                }                                 
                    else{
                        this.showSuccessToast(component,event,message);     
                    }                      
            } else if(dependentCount==5){
                if(component.get('v.counter')>=6){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                       (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                        enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                        //alert('31');
                        if(totaldependentcount>=5){
                            component.set("v.isEmployeeRelatnCreated",true);  
                        }else{
                            this.showSuccessToast(component,event,message2); 
                        }                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                        this.showSuccessToast(component,event,message2);                            
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                        this.showSuccessToast(component,event,message1); 
                    }                                                      
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);                                
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=5){
                    this.showSuccessToast(component,event,message1);                
                }                                 
                    else{
                        this.showSuccessToast(component,event,message);     
                    }                      
            } else if(dependentCount==6){
                if(component.get('v.counter')>=7){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                       (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                        enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                        //alert('32');
                        if(totaldependentcount>=6){
                            component.set("v.isEmployeeRelatnCreated",true);  
                        }else{
                            this.showSuccessToast(component,event,message2); 
                        }                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                        this.showSuccessToast(component,event,message2);                            
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                        this.showSuccessToast(component,event,message1); 
                    }                                                      
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);
                    
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=6){
                    this.showSuccessToast(component,event,message1);                
                }                                 
                    else{
                        this.showSuccessToast(component,event,message);     
                    }                      
            } else if(dependentCount>=7){
                if(component.get('v.counter')>=8){
                    if(enrolleeRecordListVar.some(code => code.relationship === 'Employee') &&
                       (enrolleeRecordListVar.some(code => code.relationship === 'Retiree') || 
                        enrolleeRecordListVar.some(code => code.relationship === 'Domestic Partner') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Disabled Dependent') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Overage Dependent/Young Adult') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Child') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Surviving Spouse') ||
                        enrolleeRecordListVar.some(code => code.relationship === 'Spouse') || enrolleeRecordListVar.some(code => code.relationship === 'Student'))) {
                        //alert('33');
                        if(totaldependentcount>=7){
                            component.set("v.isEmployeeRelatnCreated",true);  
                        }else{
                            this.showSuccessToast(component,event,message2); 
                        }                              
                    }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){                         
                        this.showSuccessToast(component,event,message2);                            
                    }else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee')){
                        this.showSuccessToast(component,event,message1); 
                    }                                                      
                }else if(enrolleeRecordListVar.some(code => code.relationship === 'Employee')){
                    this.showSuccessToast(component,event,message2);                                
                } else if(enrolleeRecordListVar.some(code => code.relationship != 'Employee') && totaldependentcount>=7){
                    this.showSuccessToast(component,event,message1);                
                }                                 
                    else{
                        this.showSuccessToast(component,event,message);     
                    }                      
            } 
        
        
    }
    
})