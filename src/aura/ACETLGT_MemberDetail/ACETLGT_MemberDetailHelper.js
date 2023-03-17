({
    
	displayToast: function(title, messages, component, helper, event){
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
        
    },

    setHighlightData: function(component, event, helper, currentResponse){

        console.log(component.get("v.highlightPanelData"));
        
        
        component.set("v.highlightPanelData", currentResponse);
        currentResponse.SpecialNeedsStatus = component.get('v.SNIStatus');
        var newResString = JSON.stringify(currentResponse);
        console.log("newResString :: "+newResString);
        component.set("v.highlightPanelDataStr", newResString);
    },
    onOriginatorChange: function(cmp,event,helper){
    try{
        var originatorval = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
        
        if(!$A.util.isEmpty(originatorval)){
            cmp.set("v.originatorval",originatorval);
        }
        var IntRec = cmp.get("v.intId");
        var hp = cmp.get("v.HighlightPaneldetail");
        var Ismnf = cmp.get("v.Ismnf");

        // Added for Member Not found flow
        if(hp ==null && Ismnf){
            console.log('-------preferedhp-----');
           cmp.set("v.HighlightPaneldetail",null);
            var hgltData = JSON.stringify(hp);            
            var action = cmp.get("c.prepareHighlightPanelWrapper");
            action.setParams({
                highlightPanelDetails : hgltData
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log('-------storeResponse-----'+storeResponse);
                    cmp.set("v.HighlightPaneldetail", storeResponse);
                    var hpd = cmp.get("v.HighlightPaneldetail");
                    console.log('---------hpd-----'+hpd);
                    hpd.Name = cmp.get("v.mnfName");
                    hpd.MemberDOB = cmp.get("v.mnfDOB");
                    hpd.GroupNumber = cmp.get("v.mnfgrpNum");
                    hpd.MemberId = cmp.get("v.mnfmemId");
                    hpd.EmployerName = cmp.get("v.mnfEmpName");
                    hpd.State = cmp.get("v.mnfState");
                    hpd.ZIP = cmp.get("v.mnfzipcode");
                    hpd.PhoneNumber = cmp.get("v.mnfPhoneNumber"); 
                    hpd.IsMemberNotfound = cmp.get("v.Ismnf"); 
                    hpd.onshoreCode = "00";
           			hpd.onshoreValue = "No";
                    hpd.serviceGrp = cmp.get("v.serviceGrp");
                    hpd.accTypes = cmp.get("v.accTypes");
                    cmp.set("v.HighlightPaneldetail",hpd);
                    var hgltData = JSON.stringify(hpd);
                    var hgltaction = cmp.get("c.prepareHighlightPanelWrapper");
                    hgltaction.setParams({
                        highlightPanelDetails : hgltData,
                        intId : IntRec
                    });
                    
                    hgltaction.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state == "SUCCESS") {
                            var storeResponse = response.getReturnValue();
                            console.log('hglt values mem notfound details::: '+JSON.stringify(storeResponse));   
                            cmp.set("v.highlightPanel",storeResponse);
                            helper.setHighlightData(cmp, event, helper, storeResponse);
                        }else{
                            console.log('state :: '+state);
                        }
                    });
                    $A.enqueueAction(hgltaction);
                }else{
                    console.log('state :: '+state);
                }
            });
            $A.enqueueAction(action);
            
            
        }
        if((cmp.get("v.SubjectId") != undefined || originatorval != undefined) && hp!=null ){    
            hp.subjectID = cmp.get("v.SubjectId");
            hp.originatorID = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
			hp.serviceGrp = cmp.get("v.serviceGrp");
            hp.accTypes = cmp.get("v.accTypes");
            var familymems = cmp.get("v.FamilyMembersObjs");
            var tpRel;
            var tpLabel = $A.get("$Label.c.ACETThirdParty");
		if(hp.originatorID !=null && !hp.originatorID.startsWith('003') && hp.originatorID != tpLabel)
                	tpRel = cmp.get("v.tpRelationSelected");
                else
                	tpRel = cmp.get("v.tpRelation");
                
            if(familymems != undefined){ 
                familymems.forEach(function(element) {
                    //alert('--------Relationship------'+hp.originatorID +'-----'+ element.SFrecId);
                    //alert('--------Relationship------'+hp.originatorID == element.SFrecId);
                    console.log(">>>>>tpRel final"+tpRel);
                    if(tpRel != undefined && tpRel!='' && tpRel!=null){
                       hp.originatorRel = tpRel; 
                    }else{
                        if(element.Relationship != undefined && element.Relationship != null && hp.originatorID == element.SFrecId){
                            //alert('--------1------'+hp.originatorID );
                            hp.originatorRel = element.Relationship != null && element.Relationship != '' ? element.Relationship.trim(): '';
                        }
                        // Added for US2436607 HIPPA
                        if(element.DOB != undefined && element.DOB != null && hp.originatorID == element.SFrecId){
                            console.log('Orig DOB>>'+element.DOB );
                            hp.originatorDOB = element.DOB != null && element.DOB != '' ? element.DOB: '';
                        }
                    }
                    });
                
            }
            
            var hgltData = JSON.stringify(hp);
            //alert('---1-->'+hp);
            var action = cmp.get("c.prepareHighlightPanelWrapper");
            action.setParams({
                highlightPanelDetails : hgltData,
                intId : IntRec
                //memDOB : memDOB
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    //  US2263098   removing HSA Bank Account when originatr get changed to a non-subscriber
                    var subjectRelation = storeResponse.subjectName;
                    if(subjectRelation != undefined && subjectRelation != '') {
                        subjectRelation = subjectRelation.substring(subjectRelation.indexOf('(') + 1, subjectRelation.indexOf(')'));
                        console.log('subjectRelations : ', subjectRelation);
                        //console.log('originatorRelations : ', storeResponse.originatorRel);
                        if(subjectRelation.trim() != 'Self' || storeResponse.originatorRel != undefined && storeResponse.originatorRel.trim() != 'Self') {
                            var selectedTopics = cmp.get("v.selectedLookUpRecords");
                            //alert('selectedTopics : ', selectedTopics);
                            if(selectedTopics != undefined && selectedTopics != null) {
                                for(var j = 0; j < selectedTopics.length; j++) {
                                    if(selectedTopics[j].Name.trim() == 'HSA Bank Account') {
                                        selectedTopics.splice(j, 1);
                                        cmp.set("v.selectedLookUpRecords", selectedTopics);
                                        //ConstantSourceNode.log('removed : ', JSON.stringify(cmp.get("v.selectedLookUpRecords")));
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    console.log('hglt values mem details::: '+JSON.stringify(storeResponse));   
                    //cmp.set("v.highlightPanelData", storeResponse);
                    
                    cmp.set("v.highlightPanel",storeResponse);
                    //alert("+++"+JSON.stringify(cmp.get("v.highlightPanel")));
                    helper.setHighlightData(cmp, event, helper, storeResponse);
                    
                }else{
                    console.log('state :: '+state);
                }
            });
            $A.enqueueAction(action);
        }
     //  event.stopPropagation(); 
    setTimeout(function(){ 
       var GlobalAutocompleteCmp = cmp.find("GlobalAutocomplete");
        GlobalAutocompleteCmp.OnchangeOrg_method();
      }, 3000);
        }catch(e){
            helper.logError(component,e);
        }   
    },	
    getEligibility : function(component, event, helper,memberId,policyId,firstName,lastName,dob) {
      try{
         var action = component.get("c.getEligibility");
        var memId = memberId;
        action.setParams({ memberId : memId,
                          policyId:localStorage.getItem(memId+'_memPolicyId'),
                          firstName:localStorage.getItem(memId+'_memFirstName'),
                          lastName:localStorage.getItem(memId+'_memLastName'),
                          dob:localStorage.getItem(memId+'_memDOBUnFormatted')
                         });
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              var resp = response.getReturnValue();
			  if(resp != null ){
                var status  = resp.sniEligibility =='not eligible'? 'Not Eligible':
                status =='eligible'? 'Eligible': 
                status =='engaged'? 'Engaged':resp.sniEligibility;
                component.set('v.SNIStatus',status);
                    if(!$A.util.isUndefinedOrNull(resp.hassnipermission)){
                    if(!$A.util.isUndefinedOrNull(resp.serviceGroup)){
                    component.set('v.serviceGrp',resp.serviceGroup);   
                    }

                    if(!$A.util.isUndefinedOrNull(resp.accountTypes)){
                        component.set('v.accTypes',resp.accountTypes);
                    }
                    }
                var highlightPanelObj = component.get('v.highlightPanel');
                if(highlightPanelObj){
                    highlightPanelObj.SpecialNeedsStatus = status;
                   if(!$A.util.isUndefinedOrNull(resp.serviceGroup)){
                    highlightPanelObj.serviceGrp = resp.serviceGroup;
                    }

                    if(!$A.util.isUndefinedOrNull(resp.accountTypes)){
                    highlightPanelObj.accTypes = resp.accountTypes;
                    }

                    component.set('v.highlightPanel',highlightPanelObj);
                }
			  }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
 
        $A.enqueueAction(action);
            
        }catch(e){
            helper.logError(component,e);
        }  
	},
  logError: function(component,e){
        try{
            debugger;
            console.log(e);
            var errorArray=e.stack.split("\n");
            var errorcause;
            var errorline;
            if(errorArray && errorArray.length>=2)
                errorcause=errorArray[0]+ ' \n' +errorArray[1];
            else
                errorcause=e.stack;
            var errorlineArray =errorcause.split(":");
            if(errorlineArray && errorArray.length>=3)
                errorline=errorlineArray[3];
            var errormessage =e.message;
            var errortype =e.name;
            errorcause+=' \n in ' +window.location.pathname;
            var logAction = component.get("c.logError");
            logAction.setParams({
                "Application": 'Polaris',
                "errorcause" : errorcause,
                "errorline" :errorline,
                "errormessage" : errormessage, 
                "errorType" : errortype
            });
            
            logAction.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Error Logged Succesfully');
                    console.log(e);
                    this.showError();
                }
            });
            $A.enqueueAction(logAction);
        }catch(err){
            console.log('Exception happened ');
            console.log(err);
        }
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Unexpected error occurred. Please try again. If problem persists, contact the Help Desk.',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    
    formatDateStr : function(cmp,event,helper,dateStr){
        var dateFrmt = '';
        if(dateStr != '' && dateStr != undefined){
            var datetmp = dateStr.split('-');
            var dtMn = datetmp[1];
            if(dtMn.indexOf('0') == 0 && dtMn < 10){
                dtMn = dtMn.replaceAll('0','');
            }
            var dtD = datetmp[2];
            if(dtD.indexOf('0') == 0 && dtD < 10){
                dtD = dtD.replaceAll('0','');
            }
            dateFrmt = dtMn+'/'+dtD+'/'+datetmp[0];
            return dateFrmt;
        }
    },
    
    formatDateStrForAPI : function(cmp,event,helper,dateStr){
        var dateFrmtd = '';
        if(dateStr != '' && dateStr != undefined){
            var datetmp = dateStr.split('-');
            var dtMn = datetmp[1];
           /* if(dtMn.indexOf('0') == -1 && dtMn < 10){
                dtMn = '0'+dtMn;
            }*/
            var dtD = datetmp[2];
            /*if(dtD.indexOf('0') == -1 && dtD < 10){
                dtD = '0'+dtD;
            }*/
            dateFrmtd = dtMn+'/'+dtD+'/'+datetmp[0];
            return dateFrmtd;
        }
    }
})