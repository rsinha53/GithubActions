({
    getICUEURL : function(component, event, helper) {
        var ICUEURL = component.get("v.ICUEURL");
        console.log('icueURL New :: '+ICUEURL);
        
        window.open(ICUEURL, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },    
    getAuthorizationsByType:function(component,event,helper,authType){
        
        
        component.set("v.inPatientList",[]);
        component.set("v.outPatientFacilityList",[]);
        component.set("v.outPatientList",[]);
        
        var all = component.get("v.mainList");
        var inPatientList=[];
        var outPatientFacilityList=[];
        var outPatientList=[];
        //console.log('>>>>'+all[0]);
        if (!$A.util.isEmpty(all)){
            //console.time("---in getAuthorizationsByType-----");
            console.log('inside auth');
            for( var i=0 ; i<all.length ; i++){
                if(authType == all[i].Case_Type_Desc && authType != 'All' ){
                    if(all[i].Case_Type_Desc == 'Inpatient'){
                        //console.log("+++ In Push " + all[i]);
                        inPatientList.push(all[i]);
                    } else if(all[i].Case_Type_Desc == 'Outpatient'){
                        //console.log("+++ Out Push " + all[i]);
                        outPatientList.push(all[i]);
                    } else if(all[i].Case_Type_Desc == 'Outpatient Facility'){
                        //console.log("+++ OutFac Push " + all[i]);
                        outPatientFacilityList.push(all[i]);
                    }
                }else if(authType == 'All')
                {
                    if(all[i].Case_Type_Desc == 'Inpatient'){
                        //console.log("+++ In Push " + all[i]);
                        inPatientList.push(all[i]);
                    } else if(all[i].Case_Type_Desc == 'Outpatient'){
                        //console.log("+++ Out Push " + all[i]);
                        outPatientList.push(all[i]);
                    } else if(all[i].Case_Type_Desc == 'Outpatient Facility'){
                        //console.log("+++ OutFac Push " + all[i]);
                        outPatientFacilityList.push(all[i]);
                    }  
                }
                component.set("v.inPatientList",inPatientList);
                //console.log('In patient List :: '+component.get("v.inPatientList"));
                component.set("v.outPatientFacilityList",outPatientFacilityList);
                component.set("v.outPatientList",outPatientList);
            }
            //console.timeEnd("---in getAuthorizationsByType-----");
            if(window.lgtAutodoc != undefined){
                setTimeout(function(){ 
                    //alert("----1-----");
                    //console.time("---in autodoc-----");
                    var tabKey = component.get("v.AutodocKey");
                    window.lgtAutodoc.initAutodoc(tabKey);
                    component.set("v.Spinner",false);
                    //console.timeEnd("---in autodoc-----");
                }, 1);
            }
        }else{
            
                    component.set("v.Spinner",false);
        }
            /*
            var action = component.get("c.getAuthorizationsByType");
            
            action.setParams({
                allAuths : all,
                authType : authType
                
            });
            
            action.setCallback(this, function(a) {
                
                var state = a.getState();
                console.log('----state---AuthbyType'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log('------result--------Test'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        if (!$A.util.isEmpty(result.inpatientWrapper) && !$A.util.isUndefined(result.inpatientWrapper)){
                            component.set("v.inPatientList",result.inpatientWrapper);
                        }
                        else
                            component.set("v.inPatientList",[]);
                        if (!$A.util.isEmpty(result.outpatientWrapper) && !$A.util.isUndefined(result.outpatientWrapper)){
                            component.set("v.outPatientList",result.outpatientWrapper);
                        }
                        else
                            component.set("v.outPatientList",[]);
                        if (!$A.util.isEmpty(result.outpatientfacilityWrapper) && !$A.util.isUndefined(result.outpatientfacilityWrapper)){
                            component.set("v.outPatientFacilityList",result.outpatientfacilityWrapper);
                        }
                        else
                            component.set("v.outPatientFacilityList",[]);
                        
                    }
                }
            });
            
            $A.enqueueAction(action);
        }*/
    
    
},
 
 findAuthsOnLoad: function(component, event, helper){    
    
    var pageReference = component.get("v.pageReference");
    
    var cseTopic = pageReference.state.c__callTopic;
    var srk = pageReference.state.c__srk;
    var int = pageReference.state.c__interaction;
    var intId = pageReference.state.c__intId;
    var uInfo = pageReference.state.c__userInfo;
    //var contactName = pageReference.state.c__originatorval;
    var dob = pageReference.state.c__va_dob;
    var memId = pageReference.state.c__Id;
    var hlpinfo = component.get("v.highlightPanel");
    var contactName = (hlpinfo!= undefined && hlpinfo!= null)?hlpinfo.originatorName:'';
    console.log(contactName);
    
    //var groupNumber;
    var firstName = pageReference.state.c__fname;
    var lastName = pageReference.state.c__lname;
    var startDate ;// = dob;
    var endDate = '9999-12-31';
    var strList,mm,dd;
    console.log( dob+firstName+lastName+startDate+endDate+srk);
    component.set("v.firstName",firstName);
    component.set("v.lastName",lastName);
    component.set("v.contactName",contactName);
    component.set("v.memberId",memId);
    
    component.set("v.userInfo",uInfo);
    component.set("v.srk",srk);
    console.log('Auth onload'+uInfo+srk);
    if(dob !=null){
        strList=dob.split('/',3);
    }
    console.log(strList);
    if(strList.length==3){     
        mm =   (parseInt(strList[0]) < 10 ? '0' : '') + strList[0];
        dd =   (parseInt(strList[1]) < 10 ? '0' : '') + strList[1];
        dob =  strList[2]+'-'+mm+'-'+dd;
        
    }
    else{
        dob ='';
    }
    
    startDate = dob;
    
    console.log( dob+firstName+lastName+startDate+endDate+srk);
    
    //alert('Inside helper');
    helper.callout(component,event,helper,srk,dob,firstName,lastName,startDate,endDate);
    
    helper.buttonAccess(component,event,helper);
},
    
    callout:function(component,event,helper,srk,dob,firstName,lastName,startDate,endDate){
        //alert('Inside callout');
        
        var action = component.get("c.findAuthorizations");
        //action.setStorable();
        
        action.setParams({
            srk : srk,
            DOB : dob,  
            FirstName : firstName,
            LastName : lastName,
            StartDate : startDate,
            EndDate : endDate
            
        });
        
        action.setCallback(this, function(a) {
            
            var state = a.getState();
            //alert('----state---'+state);
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.log('------result--------'+result);
                    if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result) && !$A.util.isUndefined(result) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                        console.log('!!!Auths'+result.resultWrapper);
                        // Insert into respective lists
                        //alert(JSON.stringify(result));
                        
                        //Set Values to A Main List
                        component.set("v.mainList",result.resultWrapper);
                        
                        var mainList = component.get("v.mainList");
                        var inPatientList = [];
                        var outPatientFacilityList = [];
                        var outPatientList = [];
                        
                        
                        for( var i=0 ; i<mainList.length ; i++){
                            if(mainList[i].Case_Type_Desc == 'Inpatient'){
                                console.log("+++ In Push " + mainList[i]);
                                inPatientList.push(mainList[i]);
                                
                            } else if(mainList[i].Case_Type_Desc == 'Outpatient'){
                                
                                outPatientList.push(mainList[i]);
                                
                            } else if(mainList[i].Case_Type_Desc == 'Outpatient Facility'){
                                
                                outPatientFacilityList.push(mainList[i]);
                                
                            }
                            //alert(mainList[i]);
                            
                        }
                        component.set("v.inPatientList",inPatientList);
                        component.set("v.outPatientFacilityList",outPatientFacilityList);
                        component.set("v.outPatientList",outPatientList);
                        
                        console.log('List sizes :: inPatientList :: '+inPatientList.length);
                        console.log('List sizes :: outPatientFacilityList :: '+outPatientFacilityList.length);
                        console.log('List sizes :: outPatientList :: '+outPatientList.length);
                        var isfromclaimdetails = component.get("v.pageReference").state.c__fromClaimDetail;
                        if(isfromclaimdetails){
                            setTimeout(function(){ 
                                helper.applyFilters(component,event,helper);
                            }, 1);
                        }
                        //alert("----01-----");
                        if(window.lgtAutodoc != undefined){
                            setTimeout(function(){ 
                                //alert("----1-----");
                                var tabKey = component.get("v.AutodocKey");
                                window.lgtAutodoc.initAutodoc(tabKey);
                                component.set("v.Spinner",false);
                            }, 1);
                		}
                        
                    } else {
                        console.log('retValue.ErrorMessage : ', result.ErrorMessage);
                        helper.displayToast('Error!', result.ErrorMessage);
                        component.set("v.Spinner",false);
                    }
                
            }else if(state == "ERROR"){
                component.set("v.inPatientList");
                component.set("v.outPatientFacilityList");
                component.set("v.outPatientList");
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(action);
        
        
    },
        
        buttonAccess:function(component,event,helper){
            console.log('Butotn access');
            var userInfo = component.get("v.userInfo");
            console.log('Auth access'+userInfo.Role_Name__c+userInfo.Profile_Name__c);
            
            var actionb = component.get("c.buttonAccess");
            //actionb.setStorable();
            
            actionb.setParams({
                userRole : userInfo.Role_Name__c
            });
            actionb.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();                
                    console.log('storeResponse'+storeResponse);    
                    if(userInfo.Profile_Name__c != 'Research User' && storeResponse == 'true')
                        component.set("v.allowedUser",'true');
                    else
                        component.set("v.allowedUser",'false');
                }
                
                console.log('???'+component.get("v.allowedUser"));
            });
            $A.enqueueAction(actionb);
        },
            
            applyFilters: function(component,event,helper){
                console.time("---in Filter-----");
                var allAuths = component.get("v.mainList");
                var AuthNumber = component.get("v.Auth_Number");
                
                var AuthType = component.get("v.Auth_Type");
                var AuthStatus = component.get("v.Auth_Status");
                //var AuthStartDate = component.get("v.startDateValue");
                //var AuthStartDate = component.get("v.startdate");
                var AuthStartDate = component.get("v.startDateValue");
                
                //var AuthStartDate = component.get("v.dob1");
                //var AuthStartDateSTR = component.get("v.startDateValueSTR");
                //var AuthStartDateSTR = component.find("startDate").get("v.value");
                
                //var AuthEndDate = component.get("v.endDateValue");
                //var AuthEndDate = component.get("v.dob2");
                //var AuthEndDate = component.get("v.enddate");
                var AuthEndDate = component.get("v.endDateValue");
                
                
                //console.log('DOB 1:: '+component.get(AuthStartDate));
                //console.log('DOB 2:: '+component.get(AuthEndDate));
                
                //alert(component.find("startDate").get("v.value"));
                //alert(component.get("v.startDateValue"));
                var inPatientAuthorizedList,facilityAuthorizedList,outPatientAuthorizedList;
                //Clear Inpatient, outpatient and outpatient facility lists
                component.set("v.inPatientList",[]);
                component.set("v.outPatientFacilityList",[]);
                component.set("v.outPatientList",[]);
                
                console.log('Main Selections ::: '+AuthNumber+'-'+AuthType+'-'+AuthStatus+'-'+AuthStartDate+'-'+AuthEndDate+'-');
                console.log('Auth_Status2 :: '+component.get("v.Auth_Status2"));
                
                if (!$A.util.isEmpty(AuthStartDate)){
                    var ps = AuthStartDate.split(/\D/g);
                    AuthStartDate =  [ps[1],ps[2],ps[0] ].join("/");
                    console.log('newDate :: '+AuthStartDate);
                    console.log('newDate :: '+Date.parse(AuthStartDate));
                }
                
                if (!$A.util.isEmpty(AuthEndDate)){
                    var pe = AuthEndDate.split(/\D/g);
                    AuthEndDate =  [pe[1],pe[2],pe[0] ].join("/");
                    console.log('EndDate :: '+AuthEndDate);
                    console.log('EndDate :: '+Date.parse(AuthEndDate));
                }
                
                console.log('Main Selections ::: '+AuthNumber+'-'+AuthType+'-'+AuthStatus+'-'+AuthStartDate+'-'+AuthEndDate+'-');		
                
                //Load Selected Authorization type only
                if(AuthType == 'None'){
                    helper.getAuthorizationsByType(component,event,helper,'All');
                    
                }else if (AuthType == 'Inpatient') {
                    helper.getAuthorizationsByType(component,event,helper,'Inpatient');
                    
                }
                    else if (AuthType == 'Outpatient Facility') {
                        console.log('outpatient Fac');
                        helper.getAuthorizationsByType(component,event,helper,'Outpatient Facility');
                        
                    }
                        else {
                            helper.getAuthorizationsByType(component,event,helper,'Outpatient');
                            
                        }
                
                
                
                
                //if(AuthNumber != ''){
                if(!$A.util.isEmpty(AuthNumber)){
                    var inList,outList,outFacList,tempList = [];
                    inList = component.get("v.inPatientList");
                    component.set("v.inPatientList",[]);
                    if(inList.length >0){
                        
                        console.log("Inpatient Exists");
                        for( var i=0 ; i<inList.length ; i++){
                            if(inList[i].Authorization_Number == AuthNumber){
                                console.log("+++ In Push " + inList[i]);
                                tempList.push(inList[i]);
                                
                            } 
                        }
                        component.set("v.inPatientList",tempList);
                    }
                    outList = component.get("v.outPatientList");
                    component.set("v.outPatientList",[]);
                    if(outList.length >0){
                        tempList=[];
                        console.log("outPatientList Exists");
                        for( var i=0 ; i<outList.length ; i++){
                            if(outList[i].Authorization_Number == AuthNumber){
                                console.log("+++ Out Push " + outList[i]);
                                tempList.push(outList[i]);
                                
                            } 
                        }
                        component.set("v.outPatientList",tempList);
                    }
                    outFacList = component.get("v.outPatientFacilityList");
                    component.set("v.outPatientFacilityList",[]);
                    if(outFacList.length >0){
                        tempList=[];
                        console.log("Inpatient Exists");
                        for( var i=0 ; i<outFacList.length ; i++){
                            if(outFacList[i].Authorization_Number == AuthNumber){
                                console.log("+++ In Push " + outFacList[i]);
                                tempList.push(outFacList[i]);
                                
                            } 
                        }
                        component.set("v.outPatientFacilityList",tempList);
                    }
                    
                }
                
                if(AuthStatus != 'None'){
                    inList = component.get("v.inPatientList");
                    component.set("v.inPatientList",[]);
                    if(inList.length >0){
                        tempList=[];
                        console.log("Inpatient Exists Status");
                        for( var i=0 ; i<inList.length ; i++){
                            if(inList[i].Case_Status.indexOf(AuthStatus) == 0){
                                console.log("+++ In Push " + inList[i]);
                                tempList.push(inList[i]);
                            } 
                        }
                        component.set("v.inPatientList",tempList);
                    }
                    outList = component.get("v.outPatientList");
                    component.set("v.outPatientList",[]);
                    if(outList.length >0){
                        tempList=[];
                        console.log("outPatientList Exists");
                        for( var i=0 ; i<outList.length ; i++){
                            if(outList[i].Case_Status.indexOf(AuthStatus) == 0){
                                console.log("+++ Out Push " + outList[i]);
                                tempList.push(outList[i]);
                                
                            } 
                        }
                        component.set("v.outPatientList",tempList);
                    }
                    outFacList = component.get("v.outPatientFacilityList");
                    component.set("v.outPatientFacilityList",[]);
                    if(outFacList.length >0){
                        tempList=[];
                        console.log("Inpatient Exists");
                        for( var i=0 ; i<outFacList.length ; i++){
                            if(outFacList[i].Case_Status.indexOf(AuthStatus) == 0){
                                console.log("+++ In Push " + outFacList[i]);
                                tempList.push(outFacList[i]);
                                
                            } 
                        }
                        component.set("v.outPatientFacilityList",tempList);
                    }
                    
                    /*if(inPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){ 
                   system.debug(LoggingLevel.INFO, 'IP objAcetSerchResult: ' + objAcetSerchResult);      
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
            }
            
            if(facilityAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){
                    system.debug(LoggingLevel.INFO, 'FC objAcetSerchResult: ' + objAcetSerchResult);             
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
            }   
            
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){
                    system.debug(LoggingLevel.INFO, 'OP objAcetSerchResult: ' + objAcetSerchResult);             
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);  
            }*/
        }       
        
        
        //Only StartDate  
        //$A.util.isEmpty(AuthStartDate) $A.util.isEmpty(AuthEndDate)
        if (!$A.util.isEmpty(AuthStartDate) && $A.util.isEmpty(AuthEndDate)) {      
            //if (AuthStartDate !=null && AuthEndDate ==null) 
            console.log('AuthStartDate :: '+AuthStartDate);
            var startDateFMT = Date.parse(AuthStartDate);
            console.log('startDateFMT ::: '+startDateFMT);
            console.log('norm fomat :: '+AuthStartDate);            
            
            var inListAuth = component.get("v.inPatientList");
            component.set("v.inPatientList",[]);
            if(inListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<inListAuth.length ; i++){                   
                    
                    if (startDateFMT <= Date.parse(inListAuth[i].Expected_Admit_Date) || startDateFMT <= Date.parse(inListAuth[i].Actual_Admit_Date)){
                        tempList.push(inListAuth[i]);
                    }          
                    
                    /*
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Expected_Admit_Date) || 
                    StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Actual_Admit_Date)){
                    tempList.add(objAcetSerchResult);
                    }
                    */
                     
                 }
                component.set("v.inPatientList",tempList);
            }
            
            var outListAuth = component.get("v.outPatientList");
            component.set("v.outPatientList",[]);
            if(outListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outListAuth.length ; i++){                  
                    
                    if (startDateFMT <= Date.parse(outListAuth[i].Start_Date)){
                        tempList.push(outListAuth[i]);
                    }
                    /*
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Start_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                    */
                 }
                component.set("v.outPatientList",tempList);
            }
            
            
            var outFacListAuth = component.get("v.outPatientFacilityList");
            component.set("v.outPatientFacilityList",[]);
            if(outFacListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outFacListAuth.length ; i++){ 
                    
                    if (startDateFMT <= Date.parse(outFacListAuth[i].Expected_Start_Date) || startDateFMT <= Date.parse(outFacListAuth[i].Actual_Start_Date)){
                        tempList.push(outFacListAuth[i]);
                    }
                    
                    /*
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Expected_Start_Date) || 
                        StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Actual_Start_Date) ){
                        tempList.add(objAcetSerchResult);
                    }
                    */
                    
                    
                }
                component.set("v.outPatientFacilityList",tempList);
            }
            
        }
        
        //Only EndDate          
        if ($A.util.isEmpty(AuthStartDate) && !$A.util.isEmpty(AuthEndDate)) {
            //if (AuthEndDate !=null && AuthStartDate == null)
            
            console.log('AuthEndDate :: '+AuthEndDate);
            var endDateFMT = Date.parse(AuthEndDate);
            console.log('startDateFMT ::: '+endDateFMT);
            console.log('norm fomat :: '+AuthEndDate);
            
            
            var inListAuth = component.get("v.inPatientList");
            component.set("v.inPatientList",[]);
            if(inListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<inListAuth.length ; i++){                       
                    
                    if (endDateFMT >= Date.parse(inListAuth[i].Expected_Dscharg_Date) || endDateFMT >= Date.parse(inListAuth[i].Actual_Dscharg_Date)){
                        tempList.push(inListAuth[i]);
                    }
                    /*
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)|| 
                        EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)){
                        tempList.add(objAcetSerchResult);
                        system.debug('---DATES-END DATE-EndDate.tst_Date_Field__c--:'+EndDate.tst_Date_Field__c+'---objAcetSerchResult.Expected_Dscharg_Date--:'+returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date));
                    }
                    */
                     
                 }
                component.set("v.inPatientList",tempList);
            }
            
            
            var outListAuth = component.get("v.outPatientList");
            component.set("v.outPatientList",[]);
            if(outListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outListAuth.length ; i++){                    
                    
                    if (endDateFMT >= Date.parse(outListAuth[i].End_Date)){
                        tempList.push(outListAuth[i]);
                    }
                    /*
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.End_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                    */
                 }
                component.set("v.outPatientList",tempList);
            }
            
            
            var outFacListAuth = component.get("v.outPatientFacilityList");
            component.set("v.outPatientFacilityList",[]);
            if(outFacListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outFacListAuth.length ; i++){                   
                    
                    if (endDateFMT >= Date.parse(outFacListAuth[i].Expected_End_Date) || endDateFMT >= Date.parse(outFacListAuth[i].Actual_End_Date)){
                        tempList.push(outFacListAuth[i]);
                    }
                    
                    /*
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Expected_End_Date)|| 
                        EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Actual_End_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                    */
                    
                    
                }
                component.set("v.outPatientFacilityList",tempList);
            }
            
        } 
        
        //Both StartDate and EndDate
        if (!$A.util.isEmpty(AuthStartDate) && !$A.util.isEmpty(AuthEndDate)) {
            //if (AuthStartDate !=null && AuthEndDate !=null)            
            
            var endDateFMT = Date.parse(AuthEndDate);
            var startDateFMT = Date.parse(AuthStartDate);
            console.log('comes not null');            
            
            var inListAuth = component.get("v.inPatientList");
            component.set("v.inPatientList",[]);
            if(inListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<inListAuth.length ; i++){  
                    var expAdmitDate = Date.parse(inListAuth[i].Expected_Admit_Date);  
                    var actAdmitDate = Date.parse(inListAuth[i].Actual_Admit_Date);
                    var expDischargeDate = Date.parse(inListAuth[i].Expected_Dscharg_Date);
                    var actDischargeDate = Date.parse(inListAuth[i].Actual_Dscharg_Date);                   
                    
                    if ((expAdmitDate >= startDateFMT && expAdmitDate <= endDateFMT) ||
                        (actAdmitDate >= startDateFMT && actAdmitDate <= endDateFMT) ||
                        (expDischargeDate >= startDateFMT && expDischargeDate <= endDateFMT) ||
                        (actDischargeDate >= startDate && actDischargeDate <= endDateFMT)){
                        
                        tempList.push(inListAuth[i]);
                    }                   
                    
                    /*
                    if((returnDateFormat(objAcetSerchResult.Expected_Admit_Date) >=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Admit_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_Admit_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Admit_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)<=EndDate.tst_Date_Field__c)) {
                        tempList.add(objAcetSerchResult);
                    }
                    */                    
                 }
                component.set("v.inPatientList",tempList);
            }
            
            
            
            var outListAuth = component.get("v.outPatientList");
            component.set("v.outPatientList",[]);
            if(outListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outListAuth.length ; i++){
                    var startDate = Date.parse(outListAuth[i].Start_Date);  
                    var endDate = Date.parse(outListAuth[i].End_Date);                       
                    
                    if ((startDate >= startDateFMT && startDate <= endDateFMT) ||
                        (endDate >= startDateFMT && endDate <= endDateFMT)){
                        tempList.push(outListAuth[i]);
                    }
                    
                    /*
                    if((returnDateFormat(objAcetSerchResult.Start_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Start_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.End_Date)<=EndDate.tst_Date_Field__c)){
                        tempList.add(objAcetSerchResult);
                    }
                    */
                 }
                component.set("v.outPatientList",tempList);
            }
            
            
            
            
            
            var outFacListAuth = component.get("v.outPatientFacilityList");
            component.set("v.outPatientFacilityList",[]);
            if(outFacListAuth.length >0){
                var tempList=[];
                
                for( var i=0 ; i<outFacListAuth.length ; i++){
                    
                    //var expStartDate = Date.parse(outFacListAuth[i].Expected_Admit_Date);
                    var expStartDate = Date.parse(outFacListAuth[i].Expected_Start_Date);    
                    var actStartDate = Date.parse(outFacListAuth[i].Actual_Start_Date);
                    var expEndDate = Date.parse(outFacListAuth[i].Expected_End_Date);
                    var actEndDate = Date.parse(outFacListAuth[i].Actual_End_Date);   
                    
                    console.log('AuthStartDate :: '+AuthStartDate + ' '+startDateFMT);
                    console.log('AuthEndDate :: '+AuthEndDate + ' '+endDateFMT);
                    
                    console.log('expStartDate :: '+outFacListAuth[i].Expected_Start_Date + ' '+expStartDate);
                    console.log('actStartDate :: '+outFacListAuth[i].Actual_Start_Date + ' '+actStartDate);
                    console.log('expEndDate :: '+outFacListAuth[i].Expected_End_Date + ' '+expEndDate);
                    console.log('actEndDate :: '+outFacListAuth[i].Actual_End_Date + ' '+actEndDate);
                    
                    console.log('first val 1::: '+(expStartDate >= startDateFMT));
                    console.log('first val 2::: '+(expStartDate <= endDateFMT));
                    console.log('first val concat::: '+(expStartDate >= startDateFMT && expStartDate <= endDateFMT));
                    
                    if ((expStartDate >= startDateFMT && expStartDate <= endDateFMT) ||
                        (actStartDate >= startDateFMT && actStartDate <= endDateFMT) ||
                        (expEndDate >= startDateFMT && expEndDate <= endDateFMT) ||
                        (actEndDate >= startDateFMT && actEndDate <= endDateFMT)){
                        tempList.push(outFacListAuth[i]);
                    }
                    
                    /*
                    if((returnDateFormat(objAcetSerchResult.Expected_Start_Date) >=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Start_Date)<=EndDate.tst_Date_Field__c) ||

                        (returnDateFormat(objAcetSerchResult.Actual_Start_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Start_Date)<=EndDate.tst_Date_Field__c) || 

                        (returnDateFormat(objAcetSerchResult.Expected_End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_End_Date)<=EndDate.tst_Date_Field__c) || 

                        (returnDateFormat(objAcetSerchResult.Actual_End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_End_Date)<=EndDate.tst_Date_Field__c)) 
                        
                        {
                        tempList.add(objAcetSerchResult);
                    }
                    */
                    
                    
                }
                component.set("v.outPatientFacilityList",tempList);
            }
            
        } 
        console.timeEnd("---in Filter-----");
    },
        
        
        isValidDate: function(component,event,helper,dateString) {
            var dobcomp = component.find("startdateValue");  
            var regEx = /^\d{4}-\d{2}-\d{2}$/;
            var isValidDate = dateString.match(regEx) != null;
            console.log('======VALIDATE====='+isValidDate);
            if (isValidDate){  
                $A.util.removeClass(dobcomp, "slds-has-error-date");
                component.set("v.Start_ErrorMessage","");  
                $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
                $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");
                return true;
                
            }else{
                
                $A.util.addClass(dobcomp, "slds-has-error-date");
                component.set("v.Start_ErrorMessage","Error : Invalid Start Date");  
                $A.util.removeClass(component.find("sd_msgTxt"), "slds-hide")
                $A.util.addClass(component.find("sd_msgTxt"), "slds-show");
                return false;
            }    
        },
    
    displayToast: function(title, messages){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        
        return;        
    }                       
})