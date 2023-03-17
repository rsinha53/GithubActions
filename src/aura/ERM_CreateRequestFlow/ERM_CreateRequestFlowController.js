({
    doInit : function(component, event, helper) { 
        //debugger;
        helper.fetchExlusionMdtData(component);
        component.set("v.showAddEnrolleeSection",true);      
        helper.fetchGenderPicklist(component);
        helper.fetchDelvryPrefPicklist(component);
        helper.fetchMockStatus(component);
        var recordId = component.get("v.recordId");        
        var pageReference = component.get("v.pageReference");
        
        if(!$A.util.isUndefinedOrNull(pageReference)){
            var recid = pageReference.state.c__recordId;
            var reqType = pageReference.state.c__reqType;
            var platform = pageReference.state.c__platform;
            component.set("v.RequestDetailObjectRecordID",recid);
            var editenrolee=pageReference.state.c__editEnrollee;
            if(editenrolee){   
                component.set("v.editEnrollee",true);
            }
            
            let action = component.get("c.getEnrolleList");
            action.setParams({"caseId":recid });
            action.setCallback( this, function( response ) {
                let state = response.getState();
                if( state === "SUCCESS") {                    
                    component.set( "v.enrolleList", response.getReturnValue() );
                    if(response.getReturnValue().length>0){
                        component.set("v.showTable",true);
                    }else{
                        component.set("v.showTable",false);
                    }
                    
                } else {
                    //console.log('##UNKNOWN-STATE:',state);
                }
            });
            $A.enqueueAction(action);
            if(!$A.util.isUndefinedOrNull(recid)){
                component.set('v.caseRecordID',recid);
                component.set('v.TerminationLevelVariable','test');
                component.set('v.FamilySectionVariable','test');
                component.set("v.RequestTypeVar",reqType);
                
                component.set("v.Platform",platform);
            }
        }
        helper.fetchRelatioshipPicklist(component);
        if(!$A.util.isUndefinedOrNull(recordId)){           
            component.set("v.caseRecordID",recordId);
            component.set("v.showAddEnrolleeSection",true);
        }
        //helper.showRequiredFields(component,event,helper);//This method gets called based on Request Type:And will change input fields section color required
        var actions = [
            { label: 'Edit', name: 'show_details' },
            { label: 'Delete', name: 'show_details' }
        ];
        
        component.set("v.enrolleeColumns", [
            {label:"Name", fieldName:"firstName", type:"text"},
            {label:"SSN", fieldName:"SSN", type:"text"},
            {label:"Date of Birth", fieldName:"DateOfBirth", type:"text"} ,
            {type: 'button-icon',fixedWidth:30, typeAttributes: { iconName:{ fieldName: 'displayiconname' },
                                                                 label:'Action',
                                                                 
                                                                 name: 'Edit',
                                                                 title: 'Edit',
                                                                 disabled:{ fieldName: 'disablebutton' } ,
                                                                 value: 'Edit',
                                                                 iconPosition: 'left'
                                                                }},
            
            { type: 'action', typeAttributes: { rowActions: actions }}
            //Set columns
            /*{type: "button", typeAttributes: {
                label: 'Delete',
                name: 'Delete',
                title: 'Delete',
                disabled: false,
                value: 'Delete',
                iconPosition: 'left'
            }}*/
        ]);
                
        var CaserecordID = component.get("v.caseRecordID");
        var requestObjectRecord=component.get("v.RequestDetailObjectRecordID");
        var dependentCount=component.get("v.DependentCountVariable");
        var termvar=component.get("v.TerminationLevelVariable");
        var sreamRequestId=component.get("v.RequestDetailObjectRecordID");
        var requestType=component.get("v.RequestTypeVar");
        var familySec=component.get("v.FamilySectionVariable");
        
        if(dependentCount!=null){
            component.set("v.DependentCountVariable",dependentCount);
        }
        if(termvar!=null){
            component.set("v.TerminationLevelVariable",termvar);
        }
        if(sreamRequestId != null){
            component.set("v.RequestDetailObjectRecordID",sreamRequestId);
        }
     
        if(CaserecordID != null && component.get("v.ChildCountVariable")==null && component.get("v.TerminationLevelVariable")==null && familySec==null){                
            helper.refreshComponent(component,event,helper);
            helper.navigateToRecord(component,event,helper);
        }
        
    },
    
    editEnrolle:function(component, event, helper){
        debugger;
        var selectedEnrolle = event.currentTarget.dataset.enrolle;
        
        var enrolleList = component.get("v.enrolleList");
        component.set("v.isEditEnrolle",true);
        
        var selectedEnrolleData = enrolleList[selectedEnrolle];
        component.set("v.selectedEnrolleeIndex",selectedEnrolle);
        if(selectedEnrolleData.Relationship__c =='Employee'|| selectedEnrolleData.Relationship__c == 'Retiree'){
            component.set("v.editisssnrequired",true);
            component.set("v.editshowSSN",true);
        }
        else{
            component.set("v.editisssnrequired",false);
            component.set("v.editshowSSN",false);
        }
        var enrolleeDetails = {
            id:selectedEnrolleData.Id,
            firstName: selectedEnrolleData.First_Name__c,
            middleName: selectedEnrolleData.MiddleName__c,
            lastName:selectedEnrolleData.Last_Name__c,
            SSN: selectedEnrolleData.SSN__c	,
            updatedSSN :selectedEnrolleData.CorrectedUpdatedSSN__c,
            DateOfBirth: selectedEnrolleData.Date_of_Birth__c,
            gender: selectedEnrolleData.Gender__c,
            EmployeeId : selectedEnrolleData.Employee_ID__c,
            relationship : selectedEnrolleData.Relationship__c,
            address: selectedEnrolleData.Address__c,
            city: selectedEnrolleData.City__c,
            state: selectedEnrolleData.State__c,
            zip:selectedEnrolleData.Zip__c,
            HomePhone :selectedEnrolleData.HomePhone__c,
            PrimaryCarePhysician :selectedEnrolleData.PrimaryCarePhysician__c,
            PrimaryCareDentist : selectedEnrolleData.PrimaryCareDentist__c,
            anuualSalary: selectedEnrolleData.AnnualSalary__c,
            cobBeginDate: selectedEnrolleData.CoordinationofBenefitsBegin_Date__c,
            cobEndDate: selectedEnrolleData.CoordinationofBenefitsEnd_Date__c,
            medCareAStrtDate: selectedEnrolleData.MedicarePartAStartDate__c,
            medCareAEndDate: selectedEnrolleData.MedicarePartAEndDate__c,
            medCareBStrtDate: selectedEnrolleData.MedicarePartBStartDate__c,
            medCareBEndDate: selectedEnrolleData.MedicarePartBEndDate__c,
            medCareDStrtDate: selectedEnrolleData.MedicarePartDStartDate__c,
            medCareDEndDate:selectedEnrolleData.MedicarePartDEndDate__c,
            priorCovBegnDate: selectedEnrolleData.PriorCoverageBeginDate__c,
            priorCovEndDate: selectedEnrolleData.PriorCoverageEndDate__c,
            existingPatient: selectedEnrolleData.ExistingPatient__c,
            emailAttr:selectedEnrolleData.Email__c,
            deliveryPreffered:selectedEnrolleData.DeliveryPreference__c
            
        };  
        component.set("v.selectedEnrolle",enrolleeDetails);
        component.set("v.updateEnrolle",selectedEnrolleData);
    },
    deleteEnrolle:function(component,event,helper){
        var selectedEnrolle = event.currentTarget.dataset.enrolle;
        
        var enrolleList = component.get("v.enrolleList");
        var enrolleObjList =  component.get("v.enrolleeObjectList");
        var selectedEnrolleData = enrolleList[selectedEnrolle];
        
        let action = component.get("c.deleteEnrolleData");
        action.setParams({"deleteData":selectedEnrolleData});
        action.setCallback( this, function( response ) {
            let state = response.getState();
            var reqData = response.getReturnValue();
            if( state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    
                    "type":"success",
                    "message": "The Enrollee has been deleted successfully."
                });
                toastEvent.fire();
                if (selectedEnrolle > -1) {
                    enrolleList.splice(selectedEnrolle, 1);
                    enrolleObjList.splice(selectedEnrolle, 1);
                    
                }
                
                component.set("v.enrolleList",enrolleList);
                
                component.set("v.enrolleeObjectList",enrolleObjList);
                if(enrolleList.length>0){
                    component.set("v.showTable",true);
                }else{
                    component.set("v.showTable",false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getMemberInfo: function(component, event, helper) {
    var spinner = component.find("dropdown-spinner2");
    $A.util.removeClass(spinner, "slds-hide");
    $A.util.addClass(spinner, "slds-show");
    
      component.set("v.displayMember", false);
      var selLabel = event.currentTarget.getAttribute("data-label");
      var selValue = JSON.parse(event.currentTarget.getAttribute("data-value"));
      var memId = component.get("v.searchMemberIdSSN");
      var memberData = {
        sourceCode: selValue.sourceSysCode,
        Name: selValue.fullName,
        DOB: selValue.birthDate,
        firstName: selValue.firstName,
        lastName: selValue.lastName,
          middleName:selValue.middleName,
        memberID: memId.trim(),
        payerID: selValue.payerID,
          
        groupNumber: selValue.groupNumber,
        searchOption: "MemberIDDateOfBirth",
        SSN: selValue.SSN
      };
        console.log(selValue);
      var newLabel1 = memberData.memberID ;

      component.set("v.searchMemberIdSSN", newLabel1);
      var formatDate = memberData.DOB;
      component.set("v.memberSelected", memberData);
		component.set("v.firstName",memberData.firstName);
        component.set("v.lastName",memberData.lastName);
         component.set("v.middleName",memberData.middleName);
        // alert(memberData.DOB);
        var formatDate = memberData.DOB;
        if(formatDate.includes('/')){
            formatDate = formatDate.split('/')[2] + '-' + formatDate.split('/')[0] + '-' + formatDate.split('/')[1];	                            
        }
        component.set("v.DateOfBirth",formatDate);
        component.set("v.SSN",memberData.SSN);
        component.set("v.ssnvalidationError" , false);
        component.set("v.Address",selValue.address.addressLine1);
        component.set("v.city",selValue.address.city);
        component.set("v.state",selValue.address.stateCode);
        component.set("v.zip",selValue.address.postalCode);
      if (formatDate.includes("/")) {
        formatDate =
          formatDate.split("/")[2] +
          "-" +
          formatDate.split("/")[0] +
          "-" +
          formatDate.split("/")[1];
      }
      let lstExclusions = component.get("v.lstExlusions");
      //alert(lstExclusions.length);
      let mapExclusions = new Map();
      //mapExclusions.set('903797');
      for (let i = 0; lstExclusions.length > i; i++) {
        mapExclusions.set(
          lstExclusions[i].MasterLabel,
          lstExclusions[i].MasterLabel
        );
      }

      //US1761826 - UHC/Optum Exclusion UI : END
      var action;
      var isCallout = true;
      if (component.get("v.isMockEnabled")) {
        action = component.get("c.getElibilityMockData");
      } else {
        action = component.get("c.getMemberDetails");
      }
      var payerId = component.get("v.platformSelected");
      var memberDOBVar = component.get("v.memberDOB");
      var memberDOB = "";
      if (!$A.util.isEmpty(memberDOBVar)) {
        var memberDOBArray = memberDOBVar.split("/");
        memberDOB =
          memberDOBArray[2] + "-" + memberDOBArray[0] + "-" + memberDOBArray[1];
      }

      /*** US3076045 - End **/
      action.setParams({
        transactionId: null,
        memberId: memId,
        memberDOB: formatDate,
        firstName: memberData.firstName,
        lastName: memberData.lastName,
        groupNumber: "",
        searchOption: "MemberIDNameDateOfBirth",
        payerID: payerId
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        
        var result = response.getReturnValue();
       
        console.log(response.getReturnValue());
        
			debugger;
        if (state == "SUCCESS") {
          if (result.statusCode == 200) {
            if (
              result.resultWrapper != null &&
              result.resultWrapper != undefined
             
            ) {
              
              console.log("UPDATED MEMBER: " + JSON.stringify(memberData));
              var gropnumber = result.resultWrapper.subjectCard.groupNumber;
               if(result.resultWrapper.gender == 'M'){
                   component.set('v.PickVal.Gender__c','Male');
               }
                if(result.resultWrapper.gender == 'F'){
                   component.set('v.PickVal.Gender__c','FeMale');
               }
                component.set('v.PickVal.Relationship__c',result.resultWrapper.relationship);
                component.set('v.middleName', result.resultWrapper.middleName);
                var isRestricted = false;
                component.set("v.memberSelected",memberData);
                                            var newLabel = memId;
                                           // component.set("v.searchMemberIdSSN", newLabel);
              if (mapExclusions.has(gropnumber)) {
                component.set("v.uhgAccess", "Yes");
                //DE414377
                if (component.get("v.userInfo").UHG_Access__c == "No") {
                  isRestricted = true;
                  var spinner2 = component.find("dropdown-spinner2");
                  $A.util.removeClass(spinner2, "slds-show");
                  $A.util.addClass(spinner2, "slds-hide");
                  component.set("v.memberSelected", "{}");
                  var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    component.get("v.searchMemberIdSSNdata")
                  );
                  helper.fireToast(
                    $A.get("$Label.c.UHG_Restriction_Validation")
                  );
                  component.set("v.displayMember", false);
                  component.set("v.memberList", []);
                  return;
                }
              }
              var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
              component.set("v.memberSelected", memberData);
              var newLabel = memberData.memberID ;
              component.set("v.searchMemberIdSSN", newLabel);
            }else{
                var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
                
                 var newLabel = memberData.memberID ;

                  component.set(
                    "v.searchMemberIdSSN",
                    newLabel
                  );
            }
          }
            else {
                var spinner2 = component.find("dropdown-spinner2");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                component.set("v.isMemberNotFound", true);
                component.set("v.searchMemberFirstName", "");
                component.set("v.searchMemberLastName", "");
                component.set("v.searchMemberDOB", "");
                
                component.set("v.searchMemberIdSSN", component.get("v.searchMemberIdSSNdata"));
                //result.message = null;
                if(result != null && result.message != null && result.message != ''){
                    helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                } else if(result != null && result.message == '' ){
                    helper.fireToast("No Results Found.", "10000");
                } else {
                    helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                }
            }
        }
      });
      $A.enqueueAction(action);
    
  },
    
    searchForMember: function(component,event,helper){   
        var spinner = component.find("dropdown-spinner2");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        
        component.set("v.displayMember", false);
        component.set("v.isMemberNotFound", false);
        component.set("v.displayMemberSection",false); //US2773499:Change
        component.set("v.uhgAccess", "No");
        var memId = component.get("v.searchMemberIdSSN");
        component.set("v.searchMemberIdSSNdata",memId);
        if(memId != null && memId != undefined){
            memId = memId.trim();
        }
        if(component.get('v.isResearchUser')) {
            component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
        component.set("v.isMemberSearch", true);
        console.log('SELECTED PLATFORM: ' + (component.get("v.platformSelected")));
        if((memId != null && memId != undefined && memId != '' && !memId.includes('-') && memId.length >= 9) && component.get("v.platformSelected") != 'None'){
            var searchOptionVal ='';
            var action = component.get('c.searchMembers');
            var memberDetails = {
                "memberId": memId,
                "memberDOB": '',
                "firstName": '',
                "lastName": '',
                "groupNumber": '',
                "searchOption": '',
                "payerID":   '', //"87726", US1944108 - Accommodate Multiple Payer ID's 
                "providerFlow": "Other"
                
            };
            var memberDetailsJSON = JSON.stringify(memberDetails);
            console.log('member search res' +JSON.stringify(memberDetails.payerID));
            action.setParams({
                "memberDetails": memberDetailsJSON
            });
            action.setCallback(this, function (response) {
                
                var state = response.getState(); // get the response state
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    //console.log('##RESP:'+JSON.stringify(result));
                    console.log('code?>>>> ' + result.statusCode);
                    if (result.statusCode == 200) {
                        var storeResponse = result.resultWrapper.lstSAEMemberStandaloneSearch;
                        if(storeResponse != null && storeResponse != undefined && storeResponse.length > 0){
                            var dropdownOptions = [];
                            for (var i = 0; i < storeResponse.length; i++) {
                                dropdownOptions.push({
                                    label: storeResponse[i].sourceSysCode + '   ' + storeResponse[i].fullName + '   ' + storeResponse[i].birthDate,
                                    value: JSON.stringify(storeResponse[i])
                                });
                            }
                            if (dropdownOptions.length >= 1) {
                                component.set('v.memberList', dropdownOptions);
                                component.set('v.displayMember', true);
                                component.set("v.isMemberSearch", false);
                                var spinner2 = component.find("dropdown-spinner2");
                                $A.util.removeClass(spinner2, "slds-show");
                                $A.util.addClass(spinner2, "slds-hide");
                             }
                            else if(dropdownOptions.length == 1){
                                var selLabel = dropdownOptions[0].label;
                                var selValue = JSON.parse(dropdownOptions[0].value);
                                var memId = component.get("v.searchMemberIdSSN");
                                var memberData = {
                                    "sourceCode": selValue.sourceSysCode,
                                    "Name": selValue.fullName,
                                    "DOB": selValue.birthDate,
                                    "firstName": selValue.firstName,
                                    "lastName": selValue.lastName,
                                    "memberID": memId.trim(),
                                    "payerID":selValue.payerID,
                                    "groupNumber":selValue.groupNumber,
                                    "searchOption":'MemberIDDateOfBirth',
                                    "SSN":selValue.SSN
                                }
                        		
                                var formatDate = memberData.DOB;
	                            if(formatDate.includes('/')){
	                            	formatDate = formatDate.split('/')[2] + '-' + formatDate.split('/')[0] + '-' + formatDate.split('/')[1];	                            
	                            }
	                            let lstExclusions = component.get("v.lstExlusions");
	                            let mapExclusions = new Map();
	                            //mapExclusions.set('706577', '706577');
	                            for(let i=0; lstExclusions.length > i; i++) {
	                                mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
	                            }
                                var action;
      var isCallout = true;
      if (component.get("v.isMockEnabled")) {
        action = component.get("c.getElibilityMockData");
      } else {
        action = component.get("c.getMemberDetails");
      }
      var payerId = component.get("v.platformSelected");
      var memberDOBVar = component.get("v.memberDOB");
      var memberDOB = "";
      if (!$A.util.isEmpty(memberDOBVar)) {
        var memberDOBArray = memberDOBVar.split("/");
        memberDOB =
          memberDOBArray[2] + "-" + memberDOBArray[0] + "-" + memberDOBArray[1];
      }

      /*** US3076045 - End **/
      action.setParams({
        transactionId: null,
        memberId: memId,
        memberDOB: formatDate,
        firstName: memberData.firstName,
        lastName: memberData.lastName,
        groupNumber: "",
        searchOption: "MemberIDNameDateOfBirth",
        payerID: payerId
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        
        var result = response.getReturnValue();
       
        console.log(response.getReturnValue());
        

        if (state == "SUCCESS") {
          if (result.statusCode == 200) {
            if (
              result.resultWrapper != null &&
              result.resultWrapper != undefined &&
              result.resultWrapper.subjectCard != null &&
              result.resultWrapper.subjectCard != undefined
            ) {
              memberData.memberID =
                result.resultWrapper.subjectCard.memberId != null
                  ? result.resultWrapper.subjectCard.memberId
                  : memberData.memberID;
              console.log("UPDATED MEMBER: " + JSON.stringify(memberData));
              var gropnumber = result.resultWrapper.subjectCard.groupNumber;
              
                var isRestricted = false;
              if (mapExclusions.has(gropnumber)) {
                component.set("v.uhgAccess", "Yes");
                //DE414377
                if (component.get("v.userInfo").UHG_Access__c == "No") {
                  isRestricted = true;
                  var spinner2 = component.find("dropdown-spinner2");
                  $A.util.removeClass(spinner2, "slds-show");
                  $A.util.addClass(spinner2, "slds-hide");
                  component.set("v.memberSelected", "{}");
                  var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    component.get("v.searchMemberIdSSNdata")
                  );
                  helper.fireToast(
                    $A.get("$Label.c.UHG_Restriction_Validation")
                  );
                  component.set("v.displayMember", false);
                  component.set("v.memberList", []);
                  return;
                }
              }
              var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
              component.set("v.memberSelected", memberData);
              var newLabel = memberData.memberID + " - " + selLabel;
              component.set("v.searchMemberIdSSN", newLabel);
            }else{
                var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
               
                 var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    newLabel
                  );
            }
          }
            else {
                var spinner2 = component.find("dropdown-spinner2");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                component.set("v.isMemberNotFound", true);
                component.set("v.searchMemberFirstName", "");
                component.set("v.searchMemberLastName", "");
                component.set("v.searchMemberDOB", "");
                
                component.set("v.searchMemberIdSSN", component.get("v.searchMemberIdSSNdata"));
                //result.message = null;
                if(result != null && result.message != null && result.message != ''){
                    helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                } else if(result != null && result.message == '' ){
                    helper.fireToast("No Results Found.", "10000");
                } else {
                    helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                }
            }
        }
      });
      $A.enqueueAction(action);
                                
    
       } else {
                                component.set('v.displayMember', false);
                                component.set('v.memberList', []);
                                var spinner2 = component.find("dropdown-spinner2");
                                $A.util.removeClass(spinner2, "slds-show");
                                $A.util.addClass(spinner2, "slds-hide");
                            }
                            component.set("v.memberList", dropdownOptions);
                            console.log('testing findIndividual....');
                            console.log(component.get("v.responseData"));
                            console.log('**********');
                            console.log(component.get("v.memberList"));
                            if (component.get('v.responseData') == undefined) {
                                component.set('v.invalidResultFlag', true);
                            } else {
                                component.set('v.invalidResultFlag', false);
                            }
                            
                            
                        } else {
                            component.set("v.isMemberNotFound", true);
                            component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                                helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
                                helper.fireToast("No Results Found.", "10000");
                            } else {
                                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        }
                    } else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                        component.set("v.isMemberNotFound", true);
                        component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
                        $A.util.removeClass(spinner2, "slds-show");
                        $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                            helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                        } else if(result != null && result.message == '' ){
                            helper.fireToast("No Results Found.", "10000");
                        } else {
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } else if (result.statusCode == 404 ) {
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                        if(result.message != undefined){
                            component.set("v.isMemberNotFound", true);
                            component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                                helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
                                helper.fireToast("No Results Found.", "10000");
                            } else {
                                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        } else {
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                        
                    } else {
                        //var responseMsg = result.message;
                        //var jsonString = JSON.parse(responseMsg);
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        //component.set('v.serviceMessage',jsonString.message);
                        // US1813580 - Error Message Translation
                        component.set('v.serviceMessage', result.message);
                        // If need
                        component.set("v.isMemberNotFound", true);
                        component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
                        $A.util.removeClass(spinner2, "slds-show");
                        $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                            helper.fireToast(result.message,"10000");
                        } else if(result != null && result.message == '' ){
                            helper.fireToast("No Results Found.", "10000");
                        } else {
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } 
                } else {
                    component.set("v.isMemberNotFound", true);
                    component.set("v.searchMemberFirstName", "");
                    component.set("v.searchMemberLastName", "");
                    component.set("v.searchMemberDOB", "");
                    var spinner2 = component.find("dropdown-spinner2");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    if(result != null && result.message != null && result.message != ''){
                        helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                    } else if(result != null && result.message == '' ){
                        helper.fireToast("No Results Found.", "10000");
                    } else { 
                        helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                    }
                }
                
            });
            $A.enqueueAction(action);
        } else if(memId == null || memId == undefined || memId == ''){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            component.set("v.memberSelected",'');
            component.set("v.isMemberSearch", false);
        } else if(component.get("v.platformSelected") == 'None'){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            helper.fireToast("Choose a Platform and Try Again.", "10000");
        } else {
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
    },
    
    handleComponentEvent : function(component, event) {
        debugger;
        var memberSelected = event.getParam("memberSelected");
        component.set("v.memberSelected", memberSelected);      
    },
    
    /*closeAddEnrolleeModel: function(component, event, helper){
        //alert('close model');
        component.set("v.showAddEnrolleeSection",false);
        component.set("v.isEnrolleeTable",true);
        component.set("v.showTable",false);//change 2
        helper.refreshComponent(component,event,helper);
    },*/
    
    redirectCasepage : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
        
        
    },
    
    setPickLStValue : function(component, event, helper){
        var selRelVal=component.find("reltnion").get("v.value");
        let button = component.find('disablebuttonid');
        var validdata = helper.validateRequired(component,event, helper);
        if(selRelVal !='') {
            component.set("v.isrequired",true);
            if(selRelVal =='Employee'|| selRelVal == 'Retiree'){
                component.set("v.isssnrequired",true);
                component.set("v.showSSN",true);
            }else{
                component.set("v.isssnrequired",false);
                component.set("v.showSSN",false);
            }
        }else{ 
            component.set("v.isrequired",false); 
            component.set("v.isssnrequired",false);
        }
        component.set("v.Relationship",selRelVal);
        
        
        if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError") && validdata==true){
            
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true); 
        }
        
    },
    
    checkSSNValidity : function(component,event, helper){
        var inputCmp = component.find("ssnId");
        var value = inputCmp.get("v.value");
        let isnum = /^\d+$/.test(value);
        let button = component.find('disablebuttonid');
        //var validdata = helper.validateRequired(component,event, helper);
        if(value!=undefined){
            if(value.length<9 && isnum){
                component.set("v.ssnvalidationError" , true);
            }
            else if(!isnum){
                component.set("v.ssnvalidationError" , true);
            } else{
                component.set("v.ssnvalidationError" , false);
            }
        }               
        // Only ASCII character in that range allowed
        // var ASCIICode = (event.which) ? event.which : event.keyCode;
        // alert(ASCIICode);
        // if (ASCIICode > 31 && (ASCIICode < 48 || ASCIICode > 57))
        // if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError") && validdata==true){  
        if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError")){                    
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true); 
        }        
    },
    
    addEnrollee : function(component, event, helper){   
        var dateOfBirth;
        var dependentCount;
        var termvar;
        var requestType;
        var familySec;
        var enrolleeDetails;
        var enrolleeRecordList;
        var JSvalue;
        var enrolleeArry;
        
        //var validdata = helper.validateRequired(component,event, helper); 
        //   if(validdata == true && !component.get("v.dobvalidationError")){
        component.set("v.isEnrolleeTable",true);
        component.set("v.showAddEnrolleeSection",true);  
        component.set("v.isButtonActive",false);  
        dependentCount=parseInt(component.get("v.DependentCountVariable"));
        termvar=component.get("v.TerminationLevelVariable");
        requestType=component.get("v.RequestTypeVar");
        familySec=component.get("v.FamilySectionVariable");           
        // let button = event.getSource();
        //alert(component.get("v.DateOfBirth"));
        if(component.get("v.DateOfBirth")!=null && component.get("v.DateOfBirth")!=''){
            dateOfBirth=$A.localizationService.formatDate(component.get("v.DateOfBirth"),'YYYY-MM-DD');
        }else{
            dateOfBirth=null;
        }
        enrolleeDetails = {
            firstName: component.get("v.firstName"),
            middleName: component.get("v.middleName"),
            lastName:component.get("v.lastName"),
            SSN: component.get("v.SSN"),
            updatedSSN :component.get("v.updatedSSN"),
            DateOfBirth: dateOfBirth,
            gender: component.get("v.PickVal.Gender__c"),
            EmployeeId : component.get("v.EmployeeId"),
            relationship :component.get("v.PickVal.Relationship__c"),
            address: component.get("v.Address"),
            city: component.get("v.city"),
            state: component.get("v.state"),
            zip: component.get("v.zip"),
            homephone : component.get("v.HomePhone"),
            PrimaryCarePhysician : component.get("v.PrimaryCarePhysician"),
            PrimaryCareDentist : component.get("v.PrimaryCareDentist"),
            anuualSalary: component.get("v.anuualSalary"),
            cobBeginDate: component.get("v.cobBeginDate"),
            cobEndDate: component.get("v.cobEndDate"),
            medCareAStrtDate: component.get("v.medCareAStrtDate"),
            medCareAEndDate: component.get("v.medCareAEndDate"),
            medCareBStrtDate: component.get("v.medCareBStrtDate"),
            medCareBEndDate: component.get("v.medCareBEndDate"),
            medCareDStrtDate: component.get("v.medCareDStrtDate"),
            medCareDEndDate:component.get("v.medCareDEndDate"),
            priorCovBegnDate: component.get("v.priorCovBegnDate"),
            priorCovEndDate: component.get("v.priorCovEndDate"),
            existingPatient: component.get("v.existingPatient"),
            emailAttr: component.get("v.emailAttr"),
            deliveryPreffered: component.get("v.PickVal.DeliveryPreference__c")
            
        };                   
        component.set("v.enrollee",enrolleeDetails);   
        
        enrolleeArry = []; 
        enrolleeRecordList=component.get("v.enrolleeObjectList");
        console.log('enrollee List here' +JSON.stringify(enrolleeRecordList));
        JSvalue=JSON.parse(JSON.stringify(enrolleeRecordList));
        
        /*Logic to Add Enrollee in a List */            
        if(component.get("v.enrolleeObjectList").length>=1){         
            enrolleeArry.push(enrolleeDetails);
            JSvalue.forEach(function(r){
                // console.log(enrolleeArry);
                enrolleeArry.push(r);   
                
            });
            component.set('v.counter',component.get('v.counter')+1);           
        }        
        else{
            enrolleeArry.push(enrolleeDetails);
            enrolleeRecordList.push(enrolleeDetails);
            component.set('v.counter',component.get('v.counter')+1);           
        }          
        
        component.set("v.enrolleeObjectList",enrolleeArry); 
        var existingEnrolles=[];
        existingEnrolles = component.get("v.enrolleList");
        // for(var i=0;i<enrolleeArry.length;i++){
        var selectedEnrolleData = enrolleeDetails;
        var enrolleeDetails = {
            First_Name__c:selectedEnrolleData.firstName,
            MiddleName__c:selectedEnrolleData.middleName,
            Last_Name__c:selectedEnrolleData.lastName,
            SSN__c:selectedEnrolleData.SSN,
            CorrectedUpdatedSSN__c:selectedEnrolleData.updatedSSN,
            //Date_of_Birth__c:selectedEnrolleData.DateOfBirth,
            Date_of_Birth__c:dateOfBirth,
            Gender__c:selectedEnrolleData.gender,
            Employee_ID__c:selectedEnrolleData.EmployeeId,
            Relationship__c:selectedEnrolleData.relationship,
            Address__c:selectedEnrolleData.address,
            City__c:selectedEnrolleData.city,
            State__c:selectedEnrolleData.state,
            Zip__c:selectedEnrolleData.zip,
            HomePhone__c:selectedEnrolleData.HomePhone,
            PrimaryCarePhysician__c:selectedEnrolleData.PrimaryCarePhysician,
            PrimaryCareDentist__c:selectedEnrolleData.PrimaryCareDentist,
            AnnualSalary__c:selectedEnrolleData.anuualSalary,
            CoordinationofBenefitsBegin_Date__c:selectedEnrolleData.cobBeginDate,
            CoordinationofBenefitsEnd_Date__c:selectedEnrolleData.cobEndDate,
            MedicarePartAStartDate__c:selectedEnrolleData.medCareAStrtDate,
            MedicarePartAEndDate__c:selectedEnrolleData.medCareAEndDate,
            MedicarePartBStartDate__c:selectedEnrolleData.medCareBStrtDate,
            MedicarePartBEndDate__c:selectedEnrolleData.medCareBEndDate,
            MedicarePartDStartDate__c:selectedEnrolleData.medCareDStrtDate,
            MedicarePartDEndDate__c:selectedEnrolleData.medCareDEndDate,
            PriorCoverageBeginDate__c:selectedEnrolleData.priorCovBegnDate,
            PriorCoverageEndDate__c:selectedEnrolleData.priorCovEndDate,
            ExistingPatient__c:selectedEnrolleData.existingPatient,
            Email__c:selectedEnrolleData.emailAttr,
            DeliveryPreference__c:selectedEnrolleData.deliveryPreffered
            
        };  
        
        
        var enrolleeRecordListVar = component.get("v.enrolleeObjectList");
        
        //Logic:To Check which relationship is been added into the EnrolleeList
        var totaldependentcount=helper.countRelationship(enrolleeRecordListVar);
        
        /*Logic:Add Enrollee for Add,Cobra Add,Reinstate:child Count/*/ 
        if(component.get("v.TerminationLevelVariable")==null){ 
            //Logic :When Only children is selected rest family section are not checked
            if(component.get("v.ChildCount")!=null && (!familySec.includes('Employee') && !familySec.includes('Spouse') && !familySec.includes('Domestic Partner/Civil Union'))){
                helper.validateChild(component,enrolleeRecordListVar);            
            }
            //Logic:When All 4 Family Sections are Selected 
            else if(component.get("v.ChildCount")!=null && (familySec.includes('Employee') || familySec.includes('Spouse') || familySec.includes('Domestic Partner/Civil Union'))){   
                helper.validateNoChild(component, enrolleeRecordListVar, familySec);
            }
            //Logic: When Children is not selected
            if(component.get("v.ChildCount")==null){
                helper.validateNoChild(component, enrolleeRecordListVar, familySec);
            }
            
        }
        /*Logic :To Add enrollee for Term and Cobra Term */
        if(requestType=='Term' || requestType=='Cobra Term'){
            var message='You must submit an EE Enrollee';
            if(termvar=='EE/Full Family'){ 
                if(component.get("v.Relationship")=='Employee'){	
                    component.set("v.isEmployeeRelatnCreated",true);                            
                }
                else{                           
                    helper.showSuccessToast(component,event,message);                            
                }                                                               
            }if(termvar=='Dependent(s) Only'){
                helper.validateDependentCount(component,enrolleeRecordListVar,dependentCount,totaldependentcount);
            }
            
        }
        
        if(component.get("v.isEmployeeRelatnCreated") || component.get("v.editEnrollee")==true){    
            component.set('v.isButtonActive',false);      
            
        } else{
            component.set('v.isButtonActive',true);  
        }
        if(component.get('v.editEnrollee') == true){
            
            var enrolleeListJSON = JSON.stringify(component.get("v.enrollee"));
            
            var action = component.get("c.insertDataEnrollee");
            action.setParams({
                'enrolleeListJSON': enrolleeListJSON,
                'RequestDetailObjectRecordID' : component.get("v.RequestDetailObjectRecordID"),
                'caseRecordId' : component.get("v.caseRecordID")
            });  
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var message='';
                    //alert(response.getReturnValue());
                    enrolleeDetails.Id = response.getReturnValue();
                    existingEnrolles.push(enrolleeDetails);
                    
                    component.set("v.enrolleList",existingEnrolles);
                    if(existingEnrolles.length>0 ){
                        component.set("v.showTable",true);
                    }else{
                        component.set("v.showTable",false);
                    }
                    if(component.get("v.caseRecordID") == ''){
                        message='Request Details Created Successfully';
                    }else{
                        message='Enrollee Created Successfully';
                    }
                    helper.showSuccessToast(component,event,message);
                    //helper.navigateToStreamRecord(component,event,helper);
                    //helper.refreshComponent(component,event,helper);
                    //component.set("v.showAddEnrolleeSection",false);                         
                }
                else if (state === "ERROR") {
                    var message='Error Occurs';
                    helper.showErrorToast(component,event,helper,message);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);                                 
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    console.log("FAILED");
                }
            });
            $A.enqueueAction(action); 
        }else{
            existingEnrolles.push(enrolleeDetails);
            
            component.set("v.enrolleList",existingEnrolles);
            
            if(existingEnrolles.length>0 || enrolleeRecordListVar.length>0){
                component.set("v.showTable",true);
            }else{
                component.set("v.showTable",false);
            }
        }
        
    },
    
    insertEnrollee : function(component, event, helper){       
        var enrolleeListJSON = JSON.stringify(component.get("v.enrolleeObjectList"));
        console.log("ENROLLEE JSON: " + enrolleeListJSON);
        var action = component.get("c.insertDataEnrolleeList");
        console.log(enrolleeListJSON);
        action.setParams({
            'enrolleeListJSON': enrolleeListJSON,
            'RequestDetailObjectRecordID' : component.get("v.RequestDetailObjectRecordID"),
            'caseRecordId' : component.get("v.caseRecordID")
        });      
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var message='';
                
                message='Request Details Created Successfully';
                
                helper.showSuccessToast(component,event,message);
                helper.navigateToStreamRecord(component,event,helper);
                helper.refreshComponent(component,event,helper);
                component.set("v.showAddEnrolleeSection",false);                         
            }
            else if (state === "ERROR") {
                var message='Error Occurs';
                helper.showErrorToast(component,event,helper,message);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);                                 
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log("FAILED");
            }
        });
        $A.enqueueAction(action); 
        
    },
    validateData:function(component, event, helper){
        helper.validateRequired(component, event, helper);
        
    },
    setMemberSection:function(component, event, helper){
        component.set("v.displayMemberSection",true);       
        component.set("v.isMemberNotFound", true);
        component.set("v.displayMember", false);       
    },
    
    validateDate : function(component, event, helper){
        helper.noFuturedate(component);
    },
    handleComponentEvent:function(component, event, helper){
        
        component.set("v.isEditEnrolle", false);
        var enrolleList = component.get("v.enrolleList");
        var enrolleObjList = component.get("v.enrolleeObjectList");
        var index = event.getParam("index");
        var updatedData = event.getParam("updatedData");
        if(updatedData != undefined) {
            var insertedId = event.getParam("enrolleId");
            enrolleList[index]=updatedData;
            var selectedEnrolleData =updatedData;
            var enrolleeDetails = {
                id:selectedEnrolleData.Id,
                firstName: selectedEnrolleData.First_Name__c,
                middleName: selectedEnrolleData.MiddleName__c,
                lastName:selectedEnrolleData.Last_Name__c,
                SSN: selectedEnrolleData.SSN__c	,
                updatedSSN :selectedEnrolleData.CorrectedUpdatedSSN__c,
                DateOfBirth: selectedEnrolleData.Date_of_Birth__c,
                gender: selectedEnrolleData.Gender__c,
                EmployeeId : selectedEnrolleData.Employee_ID__c,
                relationship : selectedEnrolleData.Relationship__c,
                address: selectedEnrolleData.Address__c,
                city: selectedEnrolleData.City__c,
                state: selectedEnrolleData.State__c,
                zip:selectedEnrolleData.Zip__c,
                HomePhone :selectedEnrolleData.HomePhone__c,
                PrimaryCarePhysician :selectedEnrolleData.PrimaryCarePhysician__c,
                PrimaryCareDentist : selectedEnrolleData.PrimaryCareDentist__c,
                anuualSalary: selectedEnrolleData.AnnualSalary__c,
                cobBeginDate: selectedEnrolleData.CoordinationofBenefitsBegin_Date__c,
                cobEndDate: selectedEnrolleData.CoordinationofBenefitsEnd_Date__c,
                medCareAStrtDate: selectedEnrolleData.MedicarePartAStartDate__c,
                medCareAEndDate: selectedEnrolleData.MedicarePartAEndDate__c,
                medCareBStrtDate: selectedEnrolleData.MedicarePartBStartDate__c,
                medCareBEndDate: selectedEnrolleData.MedicarePartBEndDate__c,
                medCareDStrtDate: selectedEnrolleData.MedicarePartDStartDate__c,
                medCareDEndDate:selectedEnrolleData.MedicarePartDEndDate__c,
                priorCovBegnDate: selectedEnrolleData.PriorCoverageBeginDate__c,
                priorCovEndDate: selectedEnrolleData.PriorCoverageEndDate__c,
                existingPatient: selectedEnrolleData.ExistingPatient__c,
                emailAttr:selectedEnrolleData.Email__c,
                deliveryPreffered:selectedEnrolleData.DeliveryPreference__c
                
            };  
            enrolleObjList[index] = enrolleeDetails;
            component.set("v.enrolleList", enrolleList);
            component.set("v.enrolleeObjectList", enrolleObjList);
        }        
    },   
    setMemberSection:function(component, event, helper){
        //var message='Member not found';
        //helper.showInformationalToast(component, event, helper, message);
        component.set("v.displayMember", false);     
        component.set("v.firstName","");
        component.set("v.firstName","");
        component.set("v.middleName","");
        component.set("v.lastName","");
        component.set("v.DateOfBirth","");
        component.set("v.SSN","");
        component.set("v.Address","");
        component.set("v.city",""); 
        component.set("v.state","");
        component.set("v.zip","");
        component.set("v.PickVal.Gender__c","");
        
    }
})