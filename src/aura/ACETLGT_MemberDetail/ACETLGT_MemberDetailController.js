({
    doIInit : function(component, event, helper) {
        //debugger;
component.set("v.pageReferenceobj",component.get("v.pageReference").state);
        component.set("v.orgid",component.get("v.pageReference").state.c__orgid);
        component.set("v.fastrrackflow",component.get("v.pageReference").state.c__fastrrackflow);
        var fastrrackflow = component.get("v.pageReference").state.c__fastrrackflow;
        if(fastrrackflow=='yes'){
          component.set("v.isfastrrackflow",true);
        } 
                component.set("v.calltopicnamefastrack",component.get("v.pageReference").state.c__calltopicnamefastrack);
	component.set("v.vccdParams",component.get("v.pageReference").state.c__vccdParams);
        
        var vccdPar = component.get("v.pageReference").state.c__vccdParams;
        var vccdParams;
        if(vccdPar != undefined && vccdPar != '' ) {
            vccdParams =  JSON.parse(vccdPar);
            if (vccdParams.callTopic != '') {
                //alert("--vccdParams.callTopic--->>"+vccdParams.callTopic);
                var topicList=[];
                var topic = new Object();
                //alert("--topic--->>"+topic);
                topic.Name = vccdParams.callTopic;
                topic.Id =vccdParams.CallTopicID;
                //alert("--topic.Name--->>"+topic);
                topicList.push(topic);
                
          		component.set("v.currentCall",vccdParams.callTopic);
        		//alert("--topic--->>"+topic);
                component.set("v.selectedLookUpRecords",topicList);
            }
        }
        component.set("v.origType",component.get("v.pageReference").state.c__InteractionOrigType);
        component.set("v.isOnshore",component.get("v.pageReference").state.c__isOnshore);
        //var element1 = document.getElementsByClassName("slds-button slds-button_brand slds-m-top--large slds-col");
        //alert("element1 " + element1.length)
        
        var childComponent = component.find("geninfo");
        childComponent.callGenInfoMethods();
        console.log('------IN 111-------');
        
        var suscriberval = component.get("v.pageReference").state.c__subscriber;
        console.log('suscriberval ::: '+suscriberval);
        component.set("v.SelectedSubscriber", suscriberval);
        console.log('suscriberval 2 ::: '+component.get("v.SelectedSubscriber"));
        if(suscriberval=='Third Party'){
            component.set('v.isTPModalOpen',false);
        }
        //US1935707 : Research user        
        var userInf = component.get("v.pageReference").state.c__usInfo;
        if(!$A.util.isEmpty(userInf))
            console.log('userInf ::: '+userInf.Profile_Name__c);
        component.set("v.userInfo", userInf);
        if(!$A.util.isEmpty(userInf))  
            console.log('userInfo 2 ::: '+component.get("v.userInfo").Profile_Name__c);
        
        var interactionId = component.get("v.pageReference").state.c__InteractionId;
        //alert('==='+interactionId);
        component.set("v.intId",interactionId);
        var memId = component.get("v.pageReference").state.c__Id;
        var autodockey = interactionId + "MemberDetail";
        //alert("-----AUtoKey---"+ autodockey);
        component.set("v.AutodocKey",autodockey );
        component.set("v.memId",memId);
        console.log('-------IDD----->'+ component.get("v.pageReference").state.c__Id);
        var name = component.get("v.pageReference").state.c__Name;
        component.set("v.Name",name);
        var firstName = component.get("v.pageReference").state.c__firstName;
        component.set("v.firstName",firstName);
        var lastName = component.get("v.pageReference").state.c__lastName;
        component.set("v.lastName",lastName);
        var srkKeyChain = component.get("v.pageReference").state.c__SRKKeyChain;
        component.set("v.srkkeychain",srkKeyChain);
        var eid = component.get("v.pageReference").state.c__individualIdentifier;
        component.set("v.eid",eid);
        var SSN;
        if(component.get("v.pageReference").state.c__fullssn != undefined)
        	SSN = window.atob(component.get("v.pageReference").state.c__fullssn);
        if(!$A.util.isEmpty(SSN))
            component.set("v.memSSN",'xxx-xx-'+SSN.substring(5,9));
		component.set("v.memdecodedSSN",component.get("v.pageReference").state.c__fullssn);
        var Sc = component.get("v.pageReference").state.c__sc;
        component.set("v.memSc",Sc);
        var grpnum = component.get("v.pageReference").state.c__grpnum;
        //alert(component.get("v.pageReference").state);
        //component.set("v.grpNum",grpnum);
        component.set("v.grpNum",grpnum);
        
        //alert('---->'+currURL);
        var Gen = component.get("v.pageReference").state.c__gen;
        component.set("v.memGen",Gen);
        var Add = decodeURIComponent(component.get("v.pageReference").state.c__addr);
        component.set("v.memAdd",Add);
        var DOB = component.get("v.pageReference").state.c__subjectdob;
        component.set("v.memDOB",DOB);
        console.log('------------>'+ component.get("v.pageReference").state.c__subjectdob);
        var coverageslst;
        if(component.get("v.pageReference").state.c__coverages != undefined){
            coverageslst = window.atob(component.get("v.pageReference").state.c__coverages);
        }
        var coverages = '';
        // console.log('------------>'+ JSON.parse(component.get("v.pageReference").state.c__coverages));
        if(!$A.util.isEmpty(coverageslst )){
            coverages = JSON.parse(coverageslst);
            

            component.set("v.memberCoverages",coverages);
                  var prefCoverage;
                  for(var k=0;k<= coverages.length;k++){
                   if(coverages[k] != undefined && coverages[k] != null && coverages[k] != '' ){
                       if(coverages[k].isPreferred){
                     prefCoverage = coverages[k];
				      }
				      }
                      }
		      component.set("v.memberPrefferedCoverage",prefCoverage); //Added by Ravi  Styx US3727594
              if(!$A.util.isUndefinedOrNull(prefCoverage.LatestCOStartDate)){
               component.set("v.COStartDate",prefCoverage.LatestCOStartDate); 
               }
              if(!$A.util.isUndefinedOrNull(prefCoverage.LatestCOEndDate)){
               component.set("v.COEndDate",prefCoverage.LatestCOEndDate); 
               }
             if(!$A.util.isUndefinedOrNull(prefCoverage.customerPurchaseId)){
                component.set("v.customerPurchaseId",prefCoverage.customerPurchaseId);
               }
              if(!$A.util.isUndefinedOrNull(prefCoverage.Product)){
                component.set("v.Product",prefCoverage.Product);
               }  

        }
        var specBenefits;
        if(component.get("v.pageReference").state.c__specialtyBenefits != undefined){
            specBenefits = component.get("v.pageReference").state.c__specialtyBenefits;
            component.set("v.specialtyBenefits",specBenefits);
        }
            console.log('vishal 1',coverages);
	    if(coverages && Array.isArray(coverages) && coverages.length > 0) {
            for(var i=0;i<coverages.length;i++){
                if(coverages[i].isPreferred)
                    localStorage.setItem(memId+'_surrogateKey', coverages[i].SurrogateKey);
            }
	    }
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        //var cov = cmp.get("v.covdata");
        var srk = component.get("v.pageReference").state.c__SRK;
        component.set("v.srk",srk);
        console.log('----srk--->'+srk); 
        console.log('doinit'+interactionId);
        //Member Not found details
        var mnfName = component.get("v.pageReference").state.c__mnfName;
        component.set("v.mnfName",mnfName);
        var mnfEmpName = component.get("v.pageReference").state.c__mnfEmpName;
        component.set("v.mnfEmpName",mnfEmpName);
        var mnfLastName = component.get("v.pageReference").state.c__mnflastName;
        component.set("v.mnfLastName",mnfLastName);
        var mnfFirstName = component.get("v.pageReference").state.c__mnffirstName;
        component.set("v.mnfFirstName",mnfFirstName);
        var mnfzipcode = component.get("v.pageReference").state.c__mnfzip;
        component.set("v.mnfzipcode",mnfzipcode);
        var mnfState = component.get("v.pageReference").state.c__mnfstate;
        component.set("v.mnfState",mnfState);
        var mnfPhoneNumber = component.get("v.pageReference").state.c__mnfphonenum;
        component.set("v.mnfPhoneNumber",mnfPhoneNumber);
        var mnfDOB = component.get("v.pageReference").state.c__mnfdob;
        component.set("v.mnfDOB",mnfDOB);
        var mnfmemId = component.get("v.pageReference").state.c__mnfId;
        component.set("v.mnfmemId",mnfmemId);
        var mnfgrpNum = component.get("v.pageReference").state.c__mnfgrpnum;
        component.set("v.mnfgrpNum",mnfgrpNum);
        
        var Ismnf = component.get("v.pageReference").state.c__Ismnf;
        component.set("v.Ismnf",Ismnf);
        console.log('ismnf----'+Ismnf);
        console.log('ismnf-A---'+!$A.util.isEmpty(Ismnf));
        
        var isMemberFoundFound = component.get("v.pageReference").state.c__isMemberFoundFound;
        if(isMemberFoundFound!=undefined&&isMemberFoundFound!=null){
            component.set("v.isMemberFoundFound",isMemberFoundFound);
        console.log('isMemberFoundFound----'+isMemberFoundFound);
        }
        
        
         var memfirstname  = component.get("v.pageReference").state.c__firstName;
        var memlastname  = component.get("v.pageReference").state.c__lastName;
       // helper.getEligibility(component, event, helper,memId,grpnum,memfirstname,memlastname,DOB);
    
        //  Dual indicator to pass into Coverage section in ACETGT_TabSet US1840846
        var affiliationIndicator = component.get("v.pageReference").state.c__affiliationIndicator;
        console.log('member ddddd : ', affiliationIndicator);
        component.set("v.affiliationIndicator",affiliationIndicator);
        console.log('compppppp : ', component.get("v.affiliationIndicator"));
        
        if(!$A.util.isEmpty(Ismnf) && Ismnf){
            console.log('ismnf--if--'+Ismnf);
            component.set("v.horizontalView",false);
            component.set("v.detailPgName","Member Not Found");
            component.set("v.Name",mnfName);
        }
        
        var int = component.get("c.queryInteraction");
        int.setParams({
            InteractionId : interactionId,
            vccdParams : vccdPar
        }); 
        int.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('test'+response.getReturnValue());
                var result = response.getReturnValue();
                //console.log('query Success'+result+'>>'+result.Id);
                component.set("v.int",result);
                //console.log('----Interaction----'+component.get("v.int")+'>>'+result.Id);
                if(result != null)
                    component.set("v.intId",result.Id);
                var famlist =[];
                if(!$A.util.isEmpty(Ismnf) && Ismnf){
                    var intthpid =  result.Third_Party__c;                    
                    var intthpval;
                    if(!$A.util.isEmpty(result.Originator_Name__c)){
                        intthpval = result.Originator_Name__c;
                    }else{
                        intthpval = result.Contact_Name__c;
                    }
                    famlist.push( { value: intthpid , label: intthpval } );
                    component.set("v.FamilyMembersList", famlist);
                    component.set("v.originatorId", intthpid); 
                    //component.set("v.onshoreRestrictionDisp","No");
                }
		
                //                component.set("v.eid", result.Originator__r.EID__c);
                //                console.log('interaction EID: ' + component.get("v.eid"));
                console.log('interaction JSON: ' + JSON.stringify(component.get("v.int")));
                //component.set("v.origType",result.Originator_Type__c);
                console.log("SS Check for any error" + JSON.stringify(event))
            }
        });
        $A.enqueueAction(int);
        
    },
    handleCaseEvent : function(cmp, event) {
        console.log("SS2");
        var isModal = event.getParam("isModalOpen");
        console.log("===>>>==3==>>>---"+ isModal);
        cmp.set("v.isModalOpen", isModal);
    },
    handleTPEvent : function(cmp, event) {
        var lblThirdParty = $A.get("$Label.c.ACETThirdParty");
        console.log('third party : ', lblThirdParty);
        var isModal = event.getParam("isTPModalOpen");
        var orgi = event.getParam("originator");
        var tpRel = event.getParam("tpRelation");
        console.log("===>>>==3==>>>---"+ isModal);
        console.log('orgi 1::tprel>>> '+orgi+tpRel);
        cmp.set("v.tpRelation",tpRel);
        cmp.set("v.tpRelationSelected",tpRel);
        cmp.set("v.isTPModalOpen", isModal);
        var isOrgiNotPresent = true;
        var famlist = cmp.get("v.FamilyMembersList");
        if(orgi != undefined && orgi != null && orgi != ''){
            if(famlist != undefined && famlist != null && famlist != '')
                famlist.splice(famlist.length - 1, 1);
            if(famlist != undefined){
                famlist.forEach(function(element) {
                    console.log('-----FULLNAME---->>'+element.value+'---orgi---->'+orgi);
                    if(element.value == orgi  )
                        isOrgiNotPresent = false;
                    else{
                        if(!element.value.startsWith('003')){
                            famlist.pop();
                        }
                    }
                });
                console.log('-----isOrgiNotPresent---->>'+isOrgiNotPresent);
                if(isOrgiNotPresent){
                    famlist.push( { value: orgi , label: orgi} );
                    
                } 
                
            }
            if (famlist.filter(function(e) { return e.value === lblThirdParty; }).length <= 0) {
                
                famlist.push( { value: lblThirdParty , label: lblThirdParty} );	
            }
            console.log('+++++++++++++ '+ famlist); 
            cmp.set("v.FamilyMembersList", famlist);
            cmp.set("v.originator", orgi);
            
            if (orgi != lblThirdParty && !cmp.get("v.originatorId").startsWith('003') ){
                cmp.set("v.originatorId", orgi);
                cmp.set("v.tpRelation",null);
            }
            
            //Observation : 
            console.log('orgi :: '+orgi);
            if (orgi == lblThirdParty) {
                console.log('orgi 2:: '+orgi);
                cmp.set("v.originatorId", null);  
                cmp.set("v.originator", null); 
                cmp.set("v.tpRelation",null);
            }     
            
            console.log('originator and Id :: '+ cmp.get("v.originator") + ' :: '+cmp.get("v.originatorId"));
            //cmp.set("v.originatorId", orgi);
        }else{
            cmp.set("v.originatorId", null);  
            cmp.set("v.originator", null); 
            cmp.set("v.tpRelation",null);
            
        }
    },
    handleGetIndividualEvent : function(cmp, event,helper) {
        var errormsg = event.getParam("errorMessage");
        if($A.util.isEmpty(errormsg) || $A.util.isUndefined(errormsg)){
        console.log("SS4");
        var EmploymentStartDate = event.getParam("dateOfEmployment");
        var EmploymentStatus = event.getParam("employmentStatus");
        var SpokenLanguage = event.getParam("spokenLanguage");
        var WrittenLanguage = event.getParam("writtenLanguage");
        var memdet = event.getParam("MemberdetailInd");
        console.log("SS Event value" + event);
        console.log("SS Event value 1" + JSON.stringify(event));
		if(memdet!= undefined && memdet!=null){
            if(memdet.firstName != undefined && memdet.firstName != null && memdet.lastName != undefined && memdet.lastName != null){
            	console.log('>>>> SS4 Name'+memdet.firstName+memdet.lastName);
        		cmp.set("v.VA_firstName",memdet.firstName);
        		cmp.set("v.VA_lastName",memdet.lastName);
        	}
        }
        cmp.set("v.SubjectId", memdet.SFrecId);
        cmp.set("v.MemberdetailInd", memdet);
        cmp.set("v.EmploymentStartDate", EmploymentStartDate);
        cmp.set("v.EmploymentStatus", EmploymentStatus);
        cmp.set("v.SpokenLanguage", SpokenLanguage);
        cmp.set("v.WrittenLanguage", WrittenLanguage);
        cmp.set("v.SpinnerDM", false);
        cmp.set("v.SpinnerOC",false);
        //cmp.set("v.SpinnerMD",false);
        //cmp.set("v.SpinnerMI",false);
        //cmp.set("v.SpinnerPCP",false);
        console.log('======>'+EmploymentStartDate+EmploymentStatus+SpokenLanguage);
        //alert('===DEMOOO===>'+cmp.get("v.MemberdetailInd.Email"));
        //cmp.set("v.Memberdetail.languageMap", memberDetail);  
        if(!$A.util.isEmpty(memdet) && !$A.util.isUndefined(memdet)) {
            var tempAddress = memdet.Addresses;
            var city,zip,state;
            if(!$A.util.isEmpty(tempAddress) && !$A.util.isUndefined(tempAddress)){
                for (var i = 0; i < tempAddress.length; i++) {
                    if(!$A.util.isEmpty(tempAddress[i].AddressType) && tempAddress[i].AddressType == 'Home'){
                        city = tempAddress[i].City;
                        cmp.set("v.providerCity",city);
                        zip =  tempAddress[i].Zip;
                        cmp.set("v.providerZip",zip);
                        console.log('city' +city);
                        console.log('zip' +zip);
                    }
                    if(!$A.util.isEmpty(tempAddress[i].State) && tempAddress[i].State == 'PR') {
                        state = tempAddress[i].State;
                        cmp.set("v.providerState",state);
                        console.log('state' +state);
                    }
                }
            }
        }
        }else{
            helper.displayToast('Error!', errormsg, cmp, helper, event);
        }
        
    },
    handleParentPEO : function(cmp, event, helper){
        var parentPEOId = event.getParam("parentPEOId");
        cmp.set('v.parentPEOId',parentPEOId); 
    },
    handleCoveragesGroupEvent : function(cmp, event, helper) {
        try{
            var errormsg = event.getParam("errorMessage");
            if($A.util.isEmpty(errormsg) || $A.util.isUndefined(errormsg)){
                console.log("SS5");
                console.log('memeber coverages');
                var coveragesSize = cmp.get('v.memberCoverages').length;
                var groupattr = event.getParam("MemberDetailFromGroup");
				var cpsList = event.getParam("customerPurchases");												  
                
                if(groupattr!= undefined && groupattr!= null ){
                    console.log('!!!!Detial Group attr'+groupattr.onshoreRestrictionDisp);
                    
                    if(groupattr.enrollmentMethod != undefined && groupattr.enrollmentMethod != null){
                        cmp.set("v.enrollmentMethod", groupattr.enrollmentMethod);
                    }else{
                        cmp.set("v.enrollmentMethod", '');
                    }
                    
                    //Contract options attributes
                    if(groupattr.coverageGroupContractOptionId != undefined && groupattr.coverageGroupContractOptionId!= null){
                        cmp.set("v.contractOptionId", groupattr.coverageGroupContractOptionId);
                    }else{
                        cmp.set("v.contractOptionId", '');
                    }
                    if(groupattr.coverageGroupContractOptionId != undefined && groupattr.coverageGroupContractOptionEffDate!= null){
                        cmp.set("v.contractOptionEffDate", groupattr.coverageGroupContractOptionEffDate);
                    }else{
                        cmp.set("v.contractOptionEffDate", '');
                    }
                    if(groupattr.coverageGroupContractOptionId != undefined && groupattr.coverageGroupContractOptionStatus!= null){
                        cmp.set("v.contractOptionStatus", groupattr.coverageGroupContractOptionStatus);
                    }else{
                        cmp.set("v.contractOptionStatus", '');
                    }
                    
                    
                    if( groupattr.isRestrict != undefined && groupattr.isRestrict == true && groupattr.onshoreRestrictionDisp == 'Yes'){
                        cmp.set("v.isRestrict", groupattr.isRestrict)
                    }
                    //Mapping for exchange type on plan benefits
                    if(coveragesSize >=1 && groupattr.exchangeType != undefined && groupattr.exchangeType!= null && groupattr.exchangeType == 'Public State Exchange'){
                        cmp.set("v.exchangeState", groupattr.exchangeState+'Shop');
                    }else{
                        cmp.set("v.exchangeState", 'None');
                    }
                    //Mapping for situsstate on plan benefits
                    if(groupattr.SitusState != undefined && groupattr.SitusState!= null){
                        cmp.set("v.SitusState", groupattr.SitusState);
                    }else{
                        cmp.set("v.SitusState", '');
                    }
                    //Mapping for funding arrangement on plan benefits
                    if(coveragesSize >=1 && groupattr.FundingArragement != undefined && groupattr.FundingArragement!= null){
                        cmp.set("v.fundingArrangement", groupattr.FundingArragement);
                    }else{
                        cmp.set("v.fundingArrangement", '');
                    }
                    console.log('funding arrangement');
                    console.log(cmp.get('v.fundingArrangement'));
                    if(groupattr.onshoreRestrictionDisp != '' && groupattr.onshoreRestrictionDisp != undefined && groupattr.onshoreRestrictionCode != '' && groupattr.onshoreRestrictionCode != undefined){
                        cmp.set("v.onshoreRestrictionDisp", groupattr.onshoreRestrictionDisp);
                        cmp.set("v.onshoreRestrictionCode", groupattr.onshoreRestrictionCode);
                        var hgltData;
                        var hlpwithorc = cmp.get("v.HighlightPaneldetail");
                        if(hlpwithorc != null && hlpwithorc!= undefined){
                            hlpwithorc["onshoreValue"] = groupattr.onshoreRestrictionDisp; 
                            hlpwithorc["onshoreCode"] = groupattr.onshoreRestrictionCode;
                            //Added by Abhinav for US2667418 - Situs state to highlightspanel and case detail
                            hlpwithorc["SitusState"] = (groupattr.SitusState != undefined && groupattr.SitusState!= null)?groupattr.SitusState:''; 
                            
                            hgltData = JSON.stringify(hlpwithorc);
                            if (hlpwithorc["GUID"] != null || hlpwithorc["GUID"] != undefined)
                            {
                                console.log("hlpwithorc guid "+ hlpwithorc["GUID"]);
                                cmp.set("v.guid",hlpwithorc["GUID"]);    
                            }
                        }
                        var action = cmp.get("c.prepareHighlightPanelWrapper");
                        action.setParams({
                            highlightPanelDetails : hgltData
                        });
                        
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state == "SUCCESS") {
                                var storeResponse = response.getReturnValue();
                                
                                cmp.set("v.highlightPanel",storeResponse);
                                helper.setHighlightData(cmp, event, helper, storeResponse);
                                
                            }else{
                                console.log('state :: '+state);
                            }
                        });
                        $A.enqueueAction(action);
                        
                    }
                    else
                        cmp.set("v.onshoreRestrictionDisp",'');
                    
                }
                else
                    cmp.set("v.onshoreRestrictionDisp",'');
                
				if(cpsList != undefined && cpsList !=null){
                    cmp.set('v.customerPurchaseList',cpsList);
                }											  
            }else{
                helper.displayToast('Error!', errormsg, cmp, helper, event);
            }
            
        }catch(e){
            helper.logError(cmp,e);
        }  
    },
    handleCoveragesFamilyEvent : function(cmp, event, helper) {
        try{
        var errormsg = event.getParam("error");
        if($A.util.isEmpty(errormsg) || $A.util.isUndefined(errormsg)){
		helper.getEligibility(cmp, event, helper,cmp.get("v.memId"),null,null,null,null);
        console.log('Coming from event when coverages change');
        
        var Familymembers = event.getParam("familyMemberList");
        if(Familymembers){
           cmp.set("v.FamilyMembersObjs", Familymembers);  
        }
        console.log('@@@familylist'+JSON.stringify(Familymembers));
		var memberDetail = event.getParam("MemberDetail");
           if(!$A.util.isUndefinedOrNull(memberDetail)){
                cmp.set('v.BenefitPlanId',memberDetail.BenefitPlanId);
        		localStorage.setItem(cmp.get('v.memId')+'_benefitPlanId', memberDetail.BenefitPlanId);
            }
        if(!$A.util.isUndefinedOrNull(event.getParam("membIdselected"))){
            var childComponent = cmp.find("geninfo");
            childComponent.famEventmethod(event.getParam("membIdselected"));
        }
        //var childComponent = component.find("geninfo").find("cComp");
        //childComponent.childMethodForloadType('Member Overview');
        
        var subsval = cmp.get("v.SelectedSubscriber");
        console.log('subsval ::: '+subsval);
        
        var EmploymentStartDate = cmp.get("v.EmploymentStartDate");
        var EmploymentStatus = cmp.get("v.EmploymentStatus");
        var SpokenLanguage = cmp.get("v.SpokenLanguage");
        var WrittenLanguage = cmp.get("v.WrittenLanguage");
        var customerPurchaseId = event.getParam("customerPurchaseId");
            if(!$A.util.isUndefinedOrNull(customerPurchaseId)){
               cmp.set("v.customerPurchaseId",customerPurchaseId); 
            }
	    var Product = event.getParam("Product");
            if(!$A.util.isUndefinedOrNull(Product)){
               cmp.set("v.Product",Product); 
            }  
        var COStartDate = event.getParam("COStartDate");
            if(!$A.util.isUndefinedOrNull(COStartDate)){
               cmp.set("v.COStartDate",COStartDate); 
            }
        var COEndDate = event.getParam("COEndDate");
              if(!$A.util.isUndefinedOrNull(COEndDate)){
               cmp.set("v.COEndDate",COEndDate); 
            }
        //console.log('~~~EmploymentStartDate---->'+EmploymentStartDate);
        //console.log('~~~EmploymentStatus---->'+EmploymentStatus);
        //console.log('~~~SpokenLanguage---->'+SpokenLanguage);
        //console.log('~~~WrittenLanguage----->'+WrittenLanguage);
        
        //console.log('&&&&&&&&family Event Member Detail'+JSON.stringify(memberDetail.PreferredCoverageInfo));
        //console.log('Benifit budle Id :: '+memberDetail.PreferredCoverageInfo.benefitBundleOptionId);
        cmp.set("v.SpinnerMD",false);
        cmp.set("v.SpinnerPCP",false);
        // This is fix the issue of spinner loading indefinately for Demographic and Other Contact
        cmp.set("v.SpinnerDM", false);
        cmp.set("v.SpinnerOC",false);
        if(memberDetail != undefined && memberDetail != null )
            cmp.set("v.covInfoBenefits",memberDetail.PreferredCoverageInfo);
        cmp.set('v.doCollapseDeductible', false);
        cmp.set("v.Memberdetail", memberDetail);
        // No other contacts found
        //console.log('Other contact detail' + JSON.stringify(memberDetail.ROIcontacts));
        
        if(memberDetail != undefined && memberDetail != null && memberDetail.MemberId != undefined)
            cmp.set("v.memId", memberDetail.MemberId);
        //console.log('-----memId---->'+ memberDetail.MemberId);
        //console.log('-----grpNum---->'+ memberDetail.groupNumberValue);
        var memGrpNum = event.getParam("groupNumber");
        if(memberDetail != undefined && memberDetail != null && memberDetail.groupNumberValue != undefined)
            cmp.set("v.grpNum", memberDetail.groupNumberValue);
        if(memGrpNum != undefined)
            cmp.set("v.grpNum", memGrpNum);
        if(cmp.get("v.Memberdetail") != null && cmp.get("v.Memberdetail") != undefined){
            cmp.set("v.Memberdetail.EmploymentStartDate", EmploymentStartDate);
            cmp.set("v.Memberdetail.EmploymentStatus", EmploymentStatus);
            cmp.set("v.Memberdetail.SpokenLanguage ", SpokenLanguage);
            cmp.set("v.Memberdetail.WrittenLanguage  ", WrittenLanguage);
        }
        console.log('~~~WrittenLanguage----->'+WrittenLanguage);
        //var covLineMap = event.getParam("covLineSelMap");
        //console.log(covLineMap);
        console.log('-----------Memberdetail------>'+cmp.get("v.Memberdetail"));
        
        console.log('~~~Event~~~Familimembers~~~'+Familymembers);
        //var evntlist = cmp.get("v.FamilyMembersList");
        var famlist =[];
        var subscriber;
        if(Familymembers != undefined){
            Familymembers.forEach(function(element) {
                console.log(element.fullName);
                console.log(element.subscriberIndividualId);
                if(element.subscriberIndividualId.substr(element.subscriberIndividualId.length-2,2) == '00' && element.fullName != null && element.fullName != undefined)
                {
                    subscriber = element.fullName.trim(); 
                }  
                //alert('---CHECK1---');
                //console.log('element.fullName ::: '+element.fullName.trim());
                //alert('---CHECK2---');
                if(element.SFrecId != null && element.SFrecId != undefined && element.fullName != null && element.fullName != undefined )
                    famlist.push( { value: element.SFrecId.trim() , label: element.fullName.trim() } );//SFrecId
                //alert('---CHECK3---');
            });
            if(famlist.filter(function(e) { return e.value === $A.get("$Label.c.ACETThirdParty") ; }).length <= 0) {
                famlist.push( { value: $A.get("$Label.c.ACETThirdParty") , label: $A.get("$Label.c.ACETThirdParty") } );
            }
            console.log('+++++++++++++covfameve '+ famlist); 
            cmp.set("v.FamilyMembersList", famlist);
            //window.lgtAutodoc.initAutodoc();
            //setTimeout(function(){window.lgtAutodoc.initAutodoc();},1);
        }
        else
        {
            if((famlist.filter(function(e) { return e.value === $A.get("$Label.c.ACETThirdParty") ; }).length <= 0) ){
                cmp.set("v.FamilyMembersList", [{ value: $A.get("$Label.c.ACETThirdParty") , label: $A.get("$Label.c.ACETThirdParty") }]);
            }
            cmp.set("v.SpinnerMI",false);    
        }
        // set the handler attributes based on event data
        //var subsriber = cmp.get("v.originator");
        console.log('!@#'+subscriber);
        //if (subsval == "true")
        //	cmp.find('OriginatorAndTopic').find('selOrginator').set("v.value",subscriber);
        
        if (!$A.util.isEmpty(subsval))
            cmp.find('OriginatorAndTopic').find('selOrginator').set("v.value",subsval);
        
        console.log('fin val ::: ' + cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value"));
        
        //Add Further values to the JSON
        var memberId = cmp.get("v.memId");
        var memDOB = cmp.get("v.memDOB");        
        var groupNum = cmp.get("v.grpNum");
        var covEffDate = cmp.get("v.covEffDate");
        //alert(covEffDate);
        
        console.log('Addi value ::: '+ memberId +' -'+memDOB+' - '+groupNum+' - '+covEffDate);
        console.log(JSON.stringify(memberDetail));
        var hgltData;
        //alert(cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value"));
        var origid = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
        //alert("------>"+cmp.get("v.SubjectId"));
        if(memberDetail != undefined && memberDetail != null  && memberDetail.PreferredCoverageInfo != undefined){
            //memberDetail.PreferredCoverageInfo.MemberId = memberId;
            memberDetail.PreferredCoverageInfo.subjectID = cmp.get("v.SubjectId");
            if(!$A.util.isEmpty(origid)){
                memberDetail.PreferredCoverageInfo.originatorID = origid;
            }
            memberDetail.PreferredCoverageInfo.MemberDOB = memDOB;
            
        }
        if(memberDetail != undefined && memberDetail != null ){
            cmp.set("v.HighlightPaneldetail",memberDetail.PreferredCoverageInfo);
            cmp.set("v.bundleId",memberDetail.BundleOptionID);
            if(memberDetail.PreferredCoverageInfo != undefined && memberDetail.PreferredCoverageInfo != null )
            {
                cmp.set("v.covEffDate",memberDetail.PreferredCoverageInfo.EffectiveDate);
                //alert(memberDetail.PreferredCoverageInfo.EffectiveDate);
                cmp.set("v.groupName",memberDetail.PreferredCoverageInfo.GroupName);
				 //Mapping of hsa plan on plan benefits
                if(!$A.util.isEmpty(memberDetail.PreferredCoverageInfo.hsaPlan) && !$A.util.isUndefined(memberDetail.PreferredCoverageInfo.hsaPlan)) {
                    cmp.set("v.hsaPlan",memberDetail.PreferredCoverageInfo.hsaPlan);
                }
            }
            
        }
        
        cmp.set("v.SpinnerMI",false);
        //cmp.set("v.SpinnerOC",false);
        //cmp.set("v.SpinnerDM",false);
        if(memberDetail != undefined && memberDetail != null && memberDetail.PreferredCoverageInfo != undefined){
            hgltData = JSON.stringify(memberDetail.PreferredCoverageInfo);
            
            if(memberDetail.PreferredCoverageInfo.SurrogateKey != undefined)
                cmp.set("v.subsrk",memberDetail.PreferredCoverageInfo.SurrogateKey);
        }
        
        //console.log('SSS hgltData mem details :: '+hgltData+memDOB);
        var action = cmp.get("c.prepareHighlightPanelWrapper");
        action.setParams({
            highlightPanelDetails : hgltData
            //memDOB : memDOB
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('hglt values mem details::: '+JSON.stringify(storeResponse));   
                
                cmp.set("v.highlightPanel",storeResponse);
                //alert("+++"+JSON.stringify(cmp.get("v.highlightPanel")));
                helper.setHighlightData(cmp, event, helper, storeResponse);
                helper.onOriginatorChange(cmp,event,helper);
            }else{
                console.log('state :: '+state);
            }
        });
        
        $A.enqueueAction(action);
        }else{
            cmp.set("v.SpinnerMD",false);
            cmp.set("v.SpinnerPCP",false);
            cmp.set("v.SpinnerDM", false);
            cmp.set("v.SpinnerOC",false);
            cmp.set("v.SpinnerMI",false);
            helper.displayToast('Error!', errormsg, cmp, helper, event);
        }
             }catch(e){
            helper.logError(cmp,e);
        } 
        
    },
    handleSpinnerLoad:function(cmp, event) {
        cmp.set("v.SpinnerMI",true);
        cmp.set("v.SpinnerDM", true);
        //cmp.set("v.SpinnerOC",true);
        //cmp.set("v.SpinnerPCP",true);
        cmp.set("v.SpinnerMD",true);
        cmp.set("v.guid",event.getParam("GUID"));
        cmp.set("v.covEffDate",event.getParam("EffectiveDate"))
        
        //alert(event.getParam("GUID"));
        
    },
    
    CreateCase:function(cmp,helper,event){
        console.log("SS7");
        
        var int = cmp.get("v.int").Id; 
        console.log('~~~Interaction'+JSON.stringify(int));
        var action = cmp.get("c.createCase");
        action.setParams({
            "interactionId": int
        });
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            console.log('Inside Created Case'+JSON.stringify(result));
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": result.Id,
                "slideDevName": "related"
            });
            navEvt.fire();
        });
        $A.enqueueAction(action);
    },
    
    OnshoreSaveValidation:function (component, event, helper){
        
        var val = component.get("v.OnshoreRestTrigger");
        
        if(val = true){
            console.log("onshore ++ Test Fired ");
            
            
            component.set("v.isTopicSelected", "false");
            component.set("v.topicError", "");     
            
            var GlobalAutocompletecmp = component.find('GlobalAutocomplete').find('lookup-pill');  
            $A.util.addClass(GlobalAutocompletecmp, "slds-has-error");      
            component.set("v.isOnshoreError", "true");
            component.set("v.onshore_Error", $A.get("$Label.c.ACETOnshoreNotFoundError"));  
            component.set("v.OnshoreRestTrigger", "false");
            
        }else{
            console.log("onshore ++ Avoided")
        }
        
        
    },
    handleShowTopic:function (component, event, helper){
        alert("XX");
        
    },
    
    onClickOfEnter : function(component,event, helper) {
        
        if (event.which == 13){
            //alert("HITS");
            console.log('hits :: '+component.find('GlobalAutocomplete').get("v.listOfSearchRecords"));
            if (component.find('GlobalAutocomplete').get("v.listOfSearchRecords") == null){
                
                var a = component.get('c.showDetails');
                $A.enqueueAction(a);
                
            }
            
        }
        
    },
    
    handleEnterKeyEvent3 : function(component,event, helper){
        console.log('HERE');
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var valueSelected = event.getParam("isSelectValue");
        
        console.log("selectedAccountGetFromEvent :: "+selectedAccountGetFromEvent);
        console.log("valueSelected 22:: "+valueSelected);
        
        component.find('showDetButtonId').focus();
        
    },
    
    
    
    
    //userstory : US1917159 
    showDetails:function (component, event, helper){
        
        //alert("fired from click");
        var val = component.get("v.isOnshoreError");
        console.log("onshore ++ "+val);
        //alert(JSON.stringify(component.get("V.Memberdetail")))
        //View Authorization Values
        //var getfname = component.find('MemberInformation2').get("{! v.MemberdetailInd.firstName }");
        //var fname = component.set("v.VA_firstName",getfname);
        
        //var getlname = component.find('MemberInformation2').get("{! v.MemberdetailInd.lastName }");
        //var lname = component.set("v.VA_lastName",getlname);
        //alert(getfname)
        //alert(getlname)
        //alert(component.get("v.guid"));
        
        if(component.find('MemberInformation2')!=undefined){
            var getfname = component.find('MemberInformation2').get("{! v.MemberdetailInd.firstName }");
            component.set("v.VA_firstName",getfname);
            var fname_Value = component.get("{! v.VA_firstName }");
            
            var getlname = component.find('MemberInformation2').get("{! v.MemberdetailInd.lastName }");
            component.set("v.VA_lastName",getlname);
            var lname_Value = component.get("{! v.VA_lastName }");
            var mName_Value = component.find('MemberInformation2').get("{! v.MemberdetailInd.middleName }");
            var suffixName = component.find('MemberInformation2').get("{! v.MemberdetailInd.suffix }");
        }
        var va_dob = component.get("{! v.VA_DOB }");
        
        var GlobalAutocomplete = component.find('GlobalAutocomplete');
        var selectedTopicList = GlobalAutocomplete.get('v.lstSelectedRecords');
        console.log('selectedTopicList' +selectedTopicList);
        var x;
        var topicArray = [];
        var topic;
        var int = component.get("v.int");
        var intId = component.get("v.intId");
        var srk = component.get("v.srk");
        var workspaceAPI = component.find("workspace");
        var originatorval = component.find('OriginatorAndTopic').find('selOrginator').get("v.value");
        var originatorcmp = component.find('OriginatorAndTopic').find('selOrginator'); 
        
        var GlobalAutocompletecmp = component.find('GlobalAutocomplete').find('lookup-pill');  
        var memberId = component.get("v.memId");
        var covEffDate = component.get("v.covEffDate");
        var eid = component.get("v.eid");
        var groupNum = component.get("v.grpNum");
        var uniqueKey = memberId + groupNum + covEffDate;
        var onshoreValue = component.get("v.onshoreRestrictionDisp");
        var subsrk = component.get("v.subsrk");
        console.log("!!!!+++++ " + originatorval+onshoreValue);
        component.set("v.originatorval",originatorval);
        var Ismnf = component.get("v.Ismnf");
        if(Ismnf){
            onshoreValue ="No";
        }
        
        //alert('----Tracking Orig----3---'+originatorval);
        //US:1928298 : Originator Validations
        
        if (originatorval == undefined || originatorval == "undefined" || $A.util.isEmpty(originatorval)){
            //component.set("v.isOrigSelected", "true");
            //component.set("v.originatorError", "Error: You must select an Originator");
            originatorcmp.set("v.value","");
            originatorcmp.reportValidity(); 
            
            return;
            
        }else{
            //$A.util.removeClass(originatorcmp, "slds-has-error");
            //component.set("v.isOrigSelected", "false");
            //component.set("v.originatorError", "");            
            console.log(">>>>>>>>>>>>>1<<<<<<<<<<<<<<");
            if ($A.util.isEmpty(selectedTopicList)){           
                
                component.set("v.isOnshoreError", "true");
                component.set("v.onshore_Error", "");  
                
                $A.util.addClass(GlobalAutocompletecmp, "slds-has-error");
                
                component.set("v.isTopicSelected", "true");
                component.set("v.topicError", $A.get("$Label.c.ACETNoTopicError"));   
                return;
                
            }else{
                $A.util.removeClass(GlobalAutocompletecmp, "slds-has-error");
            }
            //Changes : 25/11/2019 Onshore Restriction 
            if((onshoreValue == '' || onshoreValue == undefined))   {
                
                
                $A.util.addClass(GlobalAutocompletecmp, "slds-has-error");
                
                component.set("v.isOnshoreError", "true");
                component.set("v.onshore_Error", $A.get("$Label.c.ACETOnshoreNotFoundError"));  
                
                
            }else if (onshoreValue == 'No' || onshoreValue == 'Yes'){
                
                component.set("v.isOnshoreError", "false");
                component.set("v.onshore_Error", "");  
                $A.util.removeClass(GlobalAutocompletecmp, "slds-has-error");
                
                //Reset all values
                component.set("v.isTopicSelected", "false");
                component.set("v.topicError", "");  

                var hgltData = component.get("v.highlightPanel");   
		        hgltData.SpecialNeedsStatus = component.get('v.SNIStatus');
		        hgltData.serviceGrp = component.get('v.serviceGrp');
                hgltData.accTypes = component.get('v.accTypes');
                var hgltDataString = component.get("v.highlightPanelDataStr");
				console.log('originator'+component.get('v.originator'));   
                console.log('originatorId'+component.get('v.originatorId'));    
                console.log('originatorDisplayed'+component.get('v.originatorDisplayed'));    
                console.log('originatorval'+component.get('v.originatorval'));    
                var hgltDataString = component.get("v.highlightPanelDataStr");
                hgltDataString = JSON.parse(hgltDataString);
                hgltDataString.originatorName = originatorval.startsWith('003')?component.get('v.originator'):originatorval;
                hgltDataString.subjectName = component.get('v.Name');
                hgltDataString.MemberId =component.get('v.memId')?component.get('v.memId'):component.get('v.mnfmemId');
                hgltDataString.originatorRel = hgltData.originatorRel;
                hgltDataString.MemberDOB = component.get('v.memDOB');
                hgltDataString.SitusState = component.get('v.SitusState');
                hgltDataString.GroupNumber = component.get('v.grpNum');
				if(!hgltDataString.memberStatus)
					hgltDataString.memberStatus = component.get('v.EmploymentStatus');    
                hgltDataString.benefitBundleOptionId = component.get('v.bundleId');
				                hgltDataString.SpecialNeedsStatus = component.get('v.SNIStatus');
                hgltDataString.serviceGrp = component.get('v.serviceGrp');
                hgltDataString.accTypes = component.get('v.accTypes');
                hgltDataString.Product = component.get('v.Product');
                hgltDataString = JSON.stringify(hgltDataString);
                
                window.localStorage.setItem(srk, JSON.stringify(hgltData));
                console.log("SS1" + JSON.stringify(hgltData));
                console.log("GUID in Show Detail " +  component.get("v.guid"));  
                //var isPharmacySelected = false;
                console.log(">>>>>>>>>>>>>2<<<<<<<<<<<<<<");
                for(x in selectedTopicList){
                    //alert(memberId + groupNum + effectivedate);
                    topicArray[x] = selectedTopicList[x].Name;
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewClaims")){
                        var mdInd = component.get("v.MemberdetailInd");
                        var memGender = component.get("v.memGen");
                        var SSN = (mdInd != undefined && mdInd.FullSSN!= undefined && mdInd.FullSSN != null)?mdInd.FullSSN:'';
                        //isPharmacySelected = true;
                        topic = $A.get("$Label.c.ACETCallTopicViewClaims");
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ClaimsSearch"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                         "c__subSrk":subsrk,
										  "c__suffixName": suffixName,
                                         "c__SSN": window.btoa(SSN),
										 "c__memGender":memGender,
										"c__mName": mName_Value,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                        "c__bobcode":component.get("v.pageReference").state.c__bookOfBusinessTypeCode
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: "Claims Search"
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicCommunications")){
                        var d = new Date();
                          var n = d.getTime();
                        var tabuniqueid = n;
                        //isPharmacySelected = true;
                        topic = $A.get("$Label.c.ACETCallTopicCommunications");
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_CommunicationSearch"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                         "c__tabuniqueid":tabuniqueid,
                                        "c__parentPEOId":component.get('v.parentPEOId'),
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                        "c__bobcode":component.get("v.pageReference").state.c__bookOfBusinessTypeCode
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicCommunications")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicPharmacyInquiry")){
                        
                        topic = $A.get("$Label.c.ACETCallTopicPharmacyInquiry");
                        
                        
                        var uif = component.get("v.userInfo");
                        
                        console.log('uif ::: '+ component.get("v.userInfo").Profile_Name__c);               
                        
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_PharmacyInquiry"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__Id":memberId,
                                        "c__gId":groupNum,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__Ismnf":Ismnf,
                                        "c__memGender":component.get("v.memGen"),
                                        "c__fname":fname_Value,
                                        "c__lname":lname_Value,
                                        "c__subSrk":subsrk,
                                        "c__coverageInfoBenefits":component.get("v.covInfoBenefits"),
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                        "c__CPID":component.get('v.customerPurchaseId'),
                                        "c__COStartDate":component.get("v.COStartDate"),
                                        "c__COEndDate":component.get("v.COEndDate")
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicPharmacyInquiry")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        
                    }
                    
                    //US1981718 (Nadeem): Member Other Inquiry Topic
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicMemberOtherInquiry")){
                        //isPharmacySelected = true;
                        console.log(">>>>>>>>>>>>>4<<<<<<<<<<<<<<");
                        topic =  $A.get("$Label.c.ACETCallTopicMemberOtherInquiry");
                        var hgltData = component.get("v.highlightPanel");
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_MemberOtherInquiry"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__Id":memberId,
                                        "c__gId":groupNum,
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__Ismnf":Ismnf,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label:  $A.get("$Label.c.ACETCallTopicMemberOtherInquiry")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    
                    
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicProviderLookup")){
                        var networkId =  component.get("v.Memberdetail.networkId");
                        var mdInd = component.get("v.MemberdetailInd");
                        var memGender = component.get("v.memGen");
                        var SSN = (mdInd != undefined && mdInd.FullSSN!= undefined && mdInd.FullSSN != null)?mdInd.FullSSN:'';
                        console.log('>>>'+fname_Value+lname_Value+mName_Value+suffixName);
                        topic = $A.get("$Label.c.ACETCallTopicProviderLookup");
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ProviderLookup"
                                    },
                                    "state": {
                                        
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__subSrk":subsrk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__memGender":memGender,
					                    "c__mName": mName_Value,
                                        "c__suffixName": suffixName,
                                        "c__SSN":window.btoa(SSN),
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__coverageInfoBenefits":component.get("v.covInfoBenefits"),
                                        "c__city":component.get("v.providerCity"),
                                        "c__zip":component.get("v.providerZip"),
                                        "c__groupName":component.get("v.groupName"),
                                        "c__providerState":component.get("v.providerState"),
                                        "c__Ismnf":Ismnf,
                                        "c__networkId":networkId,
                                        "c__benefitPlanId":component.get('v.BenefitPlanId'),
					                   "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                       "c__CPID":component.get('v.customerPurchaseId'),
                                       "c__COStartDate":component.get("v.COStartDate"),
                                       "c__COEndDate":component.get("v.COEndDate")
                                        
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicProviderLookup")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewPayments")){
                        topic = $A.get("$Label.c.ACETCallTopicViewPayments");
                        
                        var uif = component.get("v.userInfo");
                        var hgltData = component.get("v.highlightPanelData");
                        console.log('uif ::: '+ component.get("v.userInfo").Profile_Name__c);
                        
                        
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_PaymentSearch"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicViewPayments")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}
                    }
                    
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewPCPReferrals")){
                        
                        //isPharmacySelected = true;
                       
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                        topic = $A.get("$Label.c.ACETCallTopicViewPCPReferrals");
                        var hgltData = component.get("v.highlightPanel");
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ReferralSearch"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__Id":memberId,
                                        "c__gId":groupNum,                                
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,                                 
                                        "c__dateOfBirth":hgltData.MemberDOB,
                                        "c__hgltPanelData":hgltData,
                                        "c__eid":eid,
                                        "c__originatorval": originatorval,                               
                                        "c__va_dob": va_dob,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicViewPCPReferrals")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    
                    //US2430908
					if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewConsumerDashboard")){
                    
                        
                        topic = $A.get("$Label.c.ACETCallTopicViewConsumerDashboard");
                        var hgltData = component.get("v.highlightPanel");
                        console.log('fname_Value : ', fname_Value);
                        console.log('lname_Value : ', lname_Value);
                        var interaction = component.get("v.int");
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ViewConsumerDashboard"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__Id":memberId ,
                                        "c__gId":groupNum,
                                        "c__coveffdate":covEffDate,
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__subject_firstname": fname_Value,
                                        "c__subject_lastname": lname_Value,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicViewConsumerDashboard")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                    }                    
                    
                    //US : 2027401
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewAuthorizations")){
                        console.log('>>>'+memberId+fname_Value+lname_Value+va_dob+originatorval);
                        console.log('OP -->');
                        topic = $A.get("$Label.c.ACETCallTopicViewAuthorizations");
                        var hgltData = component.get("v.highlightPanel");
                        
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ViewAuthorizations_Main"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__Id":memberId,
                                        "c__gId":groupNum,
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                        
                                        
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicViewAuthorizations")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    //	US2071098	by Madhura
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicUpdateMemberDetail")){
                        topic = $A.get("$Label.c.ACETCallTopicUpdateMemberDetail");
                        var hgltData = component.get("v.highlightPanel");
                        console.log('member : \n', component.get("v.Memberdetail"));
                        
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_UpdateMemberDetail"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction" : int,
                                        "c__intId" : intId,
                                        "c__srk" : srk,
                                        "c__identifierType" : 'srk',
                                        "c__Id" : memberId,                            
                                        "c__gId" : groupNum,
                                        "c__originatorval" : originatorval,
                                        "c__userInfo" : component.get("v.userInfo"),
                                        "c__enrollmentMethod" : component.get("v.enrollmentMethod"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                        //"c__fname": fname_Value,
                                        //"c__lname": lname_Value,
                                        //"c__va_dob": va_dob                                                       
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicUpdateMemberDetail")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        
                    }
                    
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicIDCardRequest")){
                        
                        //isPharmacySelected = true;
                        topic = $A.get("$Label.c.ACETCallTopicIDCardRequest");
                        var hgltData = component.get("v.highlightPanel");
                        
                        var uif = component.get("v.userInfo");
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_IdCardRequest"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":subsrk,
                                        "c__Id":memberId ,
                                        "c__gId":groupNum,
                                        "c__coveffdate":covEffDate,
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__userInfo":uif,
					"c__userProfile":uif.Profile_Name__c,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicIDCardRequest")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicCoordinationofBenefits")){
                        var memGender = component.get("v.memGen");  
						//isPharmacySelected = true;
                        topic = $A.get("$Label.c.ACETCallTopicCoordinationofBenefits");
                        var hgltData = component.get("v.highlightPanel");
                        
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_CoordinationOfBenefits"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":subsrk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__coveffdate":covEffDate,
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__memGender":memGender,
					                    "c__mName": mName_Value,
                                        "c__suffixName": suffixName,
                                        "c__SSN": component.get("v.memdecodedSSN"),
                                        "c__va_dob": va_dob
                                }
						     }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicCoordinationofBenefits")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }


                    //Created : 04/12/2019 : Nadeem : 
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicConsumerAccounts")){
                        
                        topic = $A.get("$Label.c.ACETCallTopicConsumerAccounts");
                        
                        var uif = component.get("v.userInfo");
                        
                        console.log('uif ::: '+ component.get("v.userInfo").Profile_Name__c);               
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_ConsumerAccount"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction" : int,
                                        "c__intId" : intId,
                                        "c__srk" : srk,
                                        "c__identifierType" : 'srk',
                                        "c__Id" : memberId,                            
                                        "c__gId" : groupNum,
                                        "c__originatorval" : originatorval,
                                        "c__userInfo" : component.get("v.userInfo"),
                                        "c__enrollmentMethod" : component.get("v.enrollmentMethod"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')                                                 
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicConsumerAccounts")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                    }
                    
                    
                    
                    //Created : 19/12/2019 : Nadeem : 
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicHSAAccount")){
                        
                        topic = $A.get("$Label.c.ACETCallTopicHSAAccount");
                        
                        var uif = component.get("v.userInfo");
			var mdInd = component.get("v.MemberdetailInd");
                        
			var CPTIN = (mdInd != undefined && mdInd.fullCPTIN != undefined && mdInd.fullCPTIN != null)?mdInd.fullCPTIN:'';
                        var SSN = (mdInd != undefined && mdInd.FullSSN!= undefined && mdInd.FullSSN != null)?mdInd.FullSSN:'';
                        var SSNCPTIN;
                        
                        if(CPTIN != null && CPTIN !=''){
                            SSNCPTIN = window.btoa(CPTIN);
                        }
                        else
                            SSNCPTIN = window.btoa(SSN);
                        
                        console.log('uif ::: '+ component.get("v.userInfo").Profile_Name__c);               
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_HSABankAccount"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction" : int,
                                        "c__intId" : intId,
                                        "c__srk" : srk,
                                        "c__identifierType" : 'srk',
                                        "c__Id" : memberId,                            
                                        "c__gId" : groupNum,
                                        "c__originatorval" : originatorval,
                                        "c__userInfo" : component.get("v.userInfo"),
                                        "c__enrollmentMethod" : component.get("v.enrollmentMethod"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString ,
                                        "c__CPTIN":SSNCPTIN
                                    }
                                }
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: "HSA Summary"
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        
                    }
                    
                    
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicMaterialsRequest")){
                        
                        //isPharmacySelected = true;
                        topic =  $A.get("$Label.c.ACETCallTopicMaterialsRequest");
                        //if (isPharmacySelected) {
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_MaterialRequest"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label:  $A.get("$Label.c.ACETCallTopicMaterialsRequest")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    //Plan Benefits
                     if(selectedTopicList[x].Name ===  $A.get("$Label.c.ACETCallTopicPlanBenefits")){
                        topic = $A.get("$Label.c.ACETCallTopicPlanBenefits");
						var cvrges = component.get('v.memberCoverages');
                         var cplist = component.get('v.customerPurchaseList');
                         console.log('customer purchase list'+JSON.stringify(cplist));
                         var planDatesList = [];
                         console.log('member coverages1'+JSON.stringify(cvrges));
                         //Iterating over coverages
                         //cvrges.forEach(function(el) 
                         for(var el in cvrges){
                             console.log('plan1 loop1');
                             if(cvrges[el].LatestCOStartDate != ''){
                                 
                            	var actCPs = cvrges[el].activeCPs;
                                 //iterating over each customer purchase record and each cplist to match and find the bundleOptionId
                                 //actCPs.forEach(function(cv){
                                 for(var cv in actCPs){
                                     console.log('plan1 loop2');
                                     //cplist.forEach(function(cp){
                                     for(var cp in cplist){
                                         console.log('plan1 loop3');
                                         var cpStrtDt = helper.formatDateStr(component,event,helper,cplist[cp].coverageStartDate);
                                         var cpEndDt = helper.formatDateStr(component,event,helper,cplist[cp].coverageExpirationDate);
                                         
                                        var cpStrtDtapi = helper.formatDateStrForAPI(component,event,helper,cplist[cp].coverageStartDate);
                                         var cpEndDtapi = helper.formatDateStrForAPI(component,event,helper,cplist[cp].coverageExpirationDate);
                                         if(cvrges[el].planOptionID == cplist[cp].memberGroupContractPlanOptionID &&
                                            actCPs[cv].contractOptionStartDate == cpStrtDt &&
                                            actCPs[cv].contractOptionEndDate == cpEndDt){
                                             //, 
                                             var dtObj = {};
                                             dtObj.benefitBundleOptionId = cplist[cp].benefitBundleOptionID;
                                             dtObj.customerPurchaseId = actCPs[cv].customerPurchaseId;
                                             dtObj.contractOptionStartDate = cpStrtDt;
                                             dtObj.contractOptionEndDate = cpEndDt;
                                             dtObj.displayText = dtObj.contractOptionStartDate+'-'+dtObj.contractOptionEndDate;
                                             dtObj.selected=false;
                                             dtObj.cpStrtDtapi = cpStrtDtapi;
                                             dtObj.cpEndDtapi = cpEndDtapi;
                                             planDatesList.push(dtObj); 
                                             break;
                                         }
                                         
                                     }
                                 }
                                
                                
                                 
                             }
                         }
                         console.log('plan Dates List'+planDatesList);
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_PlanBenefits"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__fname": fname_Value,
                                        "c__lname": lname_Value,
                                        "c__va_dob": va_dob,
                                        "c__originatorval": originatorval,
                                        "c__coverageInfoBenefits":component.get("v.covInfoBenefits"),
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__exchangeType":component.get("v.exchangeState"),
                                        "c__SitusState":component.get("v.SitusState"),
                                        "c__fundingArrangement":component.get("v.fundingArrangement"),
                                        "c__hsaPlan":component.get("v.hsaPlan"),
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode'),
                                        "c__CPID":component.get('v.customerPurchaseId'),
                                        "c__COStartDate":component.get("v.COStartDate"),
                                        "c__COEndDate":component.get("v.COEndDate"),
										"c__planDatesList":planDatesList
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicPlanBenefits")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    //  US2167825 : Group Eligibility
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicGroupEligibility")){
                        topic = $A.get("$Label.c.ACETCallTopicGroupEligibility");
                        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                            workspaceAPI.openSubtab({
                                parentTabId: enclosingTabId,
                                pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__ACETLGT_GroupEligibility"
                                    },
                                    "state": {
                                        "uid": uniqueKey,
                                        "c__callTopic" : topic,
                                        "c__interaction": int,
                                        "c__intId":intId,
                                        "c__srk":srk,
                                        "c__memberid":memberId,
                                        "c__gId":groupNum,
                                        "c__eid":eid,
                                        "c__userInfo":component.get("v.userInfo"),
                                        "c__originatorval": originatorval,
                                        "c__hgltPanelData":hgltData,
                                        "c__hgltPanelDataString":hgltDataString,
                                        "c__isMemberFlow":true,
                                        "c__contractOptionId": component.get("v.contractOptionId"),
                                        "c__contractOptionEffDate": component.get("v.contractOptionEffDate"),
                                        "c__contractOptionStatus": component.get("v.contractOptionStatus"),
                                        "c__covInfoBenefits":component.get("v.covInfoBenefits"),
                                        "c__bookOfBusinessTypeCode":component.get('v.bookOfBusinessTypeCode')
                                    }
                                },
                                focus: true
                            }).then(function(response) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function(tabInfo) {
                                    workspaceAPI.setTabLabel({
                                        tabId: tabInfo.tabId,
                                        label: $A.get("$Label.c.ACETCallTopicGroupEligibility")
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: tabInfo.tabId,
                                        icon: "standard:people",
                                        iconAlt: "Member"
                                    });
                                });
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }); 
                        //}//
                    }
                    
                }
            }
        }
        
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    handleShowOriginatorErrstop: function(component,event,helper){
        
        component.set("v.showOriginatorErrorFired",true);
    },
    mnfpopulateHilightpaneldata: function(cmp,event,helper){
        
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
        
        cmp.set("v.HighlightPaneldetail",hpd);
        var hgltData = JSON.stringify(hpd);
        var hgltaction = cmp.get("c.prepareHighlightPanelWrapper");
        hgltaction.setParams({
            highlightPanelDetails : hgltData
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
    },
    handleOriginatorChangeEvent: function(cmp,event,helper){
        helper.onOriginatorChange(cmp,event,helper);
    },
    updateBookOfBusinessTypeCode:function(cmp,event,helper){
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            var tabIdParam = event.getParam('tabId');
            var customerPurchaseId = event.getParam('customerPurchaseId');
            if(!$A.util.isUndefinedOrNull(customerPurchaseId)){
            cmp.set('v.customerPurchaseId',customerPurchaseId);
            }
            if(tabId == tabIdParam){
                cmp.set('v.bookOfBusinessTypeCode',event.getParam('bookOfBusinessTypeCode'));
            }
        })
        .catch(function(error) {
            console.log(error);
        });        
	},
    handleDestroy : function(cmp,event,helper){
        var memId = cmp.get("v.memId");
        localStorage.removeItem(memId+'_benefitPlanId');
        localStorage.removeItem(memId+'_surrogateKey');
    },
    handleSENSevent: function(cmp,event,helper){
      try{
         var FamilyMembersObjs =  cmp.get("v.FamilyMembersObjs");
          // var SNIStatus =  cmp.get("v.SNIStatus");
        //if(SNIStatus =='Eligible'){
         var createFamilyaction = cmp.get("c.createFamilyaccountstree");
        createFamilyaction.setParams({
            FamilyMembersList : JSON.stringify(FamilyMembersObjs)
        });
        createFamilyaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
        var storeResponse = response.getReturnValue();
        var highlightPanel = cmp.get('v.highlightPanel');
        localStorage.setItem('memId', highlightPanel.MemberId);
        localStorage.setItem('isACETNavigation' , true); 
        var memId = highlightPanel.MemberId;
        //localStorage[memId+'_memDOB']= dat;
        localStorage.setItem(memId+'_isOxford', true);
        //localStorage.setItem(memId+'_surrogateKey', cmp.get('v.srk'));  
        localStorage.setItem(memId+'_groupNumber', highlightPanel.GroupNumber);
        //localStorage.setItem(memId+'_effectiveDate', highlightPanel.EffectiveDate);
        localStorage.setItem(memId+'_benefitBundleOptionId', highlightPanel.benefitBundleOptionId);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/Member_Search_SNI"
        });
        urlEvent.fire();
            }else{
                console.log('state :: '+state);
            }
        });
        $A.enqueueAction(createFamilyaction);   
        }catch(e){
            helper.logError(component,e);
        }      
    
	}
})