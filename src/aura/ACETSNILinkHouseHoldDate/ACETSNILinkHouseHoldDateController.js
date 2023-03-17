({
    createFamilyPersonAccountNew : function(cmp, event,helper) {
        var memberData = event.getParam('arguments');
        
        if(memberData.householdWrapperComponent != null && memberData.householdWrapperComponent.isAcetSearch == 'SearchFamily')
        {   
            helper.searchInExistingMembers(cmp, event, helper); // search in family
        }    
        else if(memberData.householdWrapperComponent != null && memberData.householdWrapperComponent.isAcetSearch == 'SearchACET'){
            helper.searchInACETMembers(cmp,event, helper); // search in Acet
        }
            else{ // first time search comes here
                var action = cmp.get("c.getSaveHouseHoldData");
                var workspaceAPI = cmp.find("workspace");
                
                var householdInfo = memberData.householdWrapperComponent;
                var dateDob = memberData.dateDob;
                var workorderId = memberData.workorderId;
                var memberId = memberData.memberId;
                var advisorName = memberData.advisorName;
                var sniEligible = memberData.sniEligible;
                var policyIdVal = memberData.policyId;
                //alert('policyIdVal'+memberData.policyId);
                //alert('policyIdOriginal--householdDataController--Line 24-->'+memberData.policyIdOriginal);
                //console.log('policyId'+memberData.policyId);
                //console.log('policyIdOriginal'+memberData.policyIdOriginal);
                var policyIdOriginal = memberData.policyIdOriginal;
                var assignTo = memberData.assignTo;
                //Code added By Chandan -US2776388 -Begin
                var lob = memberData.lob;
                var productTypes = memberData.productTypes;
                var serviceGroup = memberData.serviceGroup;
                var groupNumber = memberData.groupNumber;
                //console.log('lob in household='+lob);
                //console.log('productTypes in household='+productTypes);
                //console.log('serviceGroup in household='+serviceGroup);
                //end
                
                cmp.set("v.householdWrapper", householdInfo);
                action.setParams({
                    "houseHoldData": householdInfo,
                    "dob": dateDob,
                    "WoId":workorderId,
                    "memberId":memberId,
                    "advFullName":advisorName,
                    "sniEligibleStatus":sniEligible,
                    "policyId":policyIdVal,
                    "policyIdOrignal":policyIdOriginal,
                    "assignTo":assignTo,
                    "lob":lob,
                    "productTypes":productTypes,
                    "serviceGroup":serviceGroup,
                    "groupNumber":groupNumber
                });
                action.setCallback(this, function (response) {
                    var state = response.getState(); // get the response state
                    var result = response.getReturnValue();
                    //console.log('result' +JSON.stringify(result));
                    if(state == 'SUCCESS') {
                        if(! result.isSniUser && !  result.isSniEligible ){
                            if( result.newMemberMatch  && !$A.util.isEmpty(result.isAcetSearch) )
                            {
                             if( result.isAcetSearch == 'SearchACET')
                             cmp.set("v.showMemDetailsModalSecnd",true);
                             else
                            cmp.set("v.showMemDetailsModal",true);
                             var newServiceSplit =(result.memberName) != null ? (result.memberName).toString().split('~'):'';
                             var newServiceMem = '';
                             for(var str in newServiceSplit){
                                newServiceMem  += newServiceSplit[str]+' ';
                             }
                             var pol = ' - Policy Number: '+result.policyId+' ';
                             // Started by Karthik
                             var rmap = result.nameRelationMap;
                             // End by Karthik   
                             var newMemExistingDetails = [];
                             var addnewUser = [];
                             var acetMemResult = result.newMemberMatch;
                             var tempMap = [];
                                for(var key in acetMemResult)
                                {
                                    //var relationMap = rmap[key];
                                    //var policyidd = pol[key];
                                    var rows =acetMemResult[key];	
                                    var nameSplit =key.toString().split('~');
                                    var keyName = '';
                                    var sliceName = '';
                                    for(var str in nameSplit){
                                        keyName  += nameSplit[str]+' ';
                                        var splitName = keyName.split('-');
                                        sliceName = splitName.slice(0,1).toString();
                                        
                                    }
                                    if(result.isAcetSearch == 'SearchACET')
                                    keyName  +=pol;
                                    else
                                    keyName  +=' - '+rmap[key];   
                                    //var NotMatch = {Name: 'Add new member to family'};
                                    //rows.push(NotMatch);
                                    var addnew =  {Name: key,serviceMember: key};
                                    addnewUser.push(addnew);
                                    for (var i = 0; i < rows.length; i++) {
                                        var row = rows[i];
                                        if (row.Account) {
                                            row.Assigned_Advisor__c = row.Account.Assigned_Advisor__c;
                                        }
                                        if (row.Contact) {
                                            row.Name = row.Contact.Name;
                                            row.DateOfBirth = $A.localizationService.formatDate(row.Contact.Birthdate, "M/d/yyyy");
                                            row.serviceMember = key;
                                            
                                        }
                                        else{
                                            row.serviceMember = key;  
                                        }
                                        
                                    }
                                    if(result.isAcetSearch == 'SearchACET')
                                    newMemExistingDetails.push({
                                        key : keyName,
                                        value : rows
                                        //memName:sliceName
                                        //relation:relationMap,
                                        //policyidpopc:pol
                                    });

                                    else
                                    newMemExistingDetails.push({
                                        key : keyName,
                                        value : rows,
                                        memName:sliceName
                                        //relation:relationMap,
                                        //policyidpopc:pol
                                    });
                                } 
                                cmp.set('v.addnewUser',addnewUser); 
                                result.newMemberMatch = newMemExistingDetails;   
                                cmp.set("v.newMemberMatch",newMemExistingDetails);
                                //result.newAddressMatch = newMemExistingDetails;   
                                //cmp.set("v.newAddressMatch",newMemExistingDetails);
                                cmp.set("v.memberDetails",result);
                             //var memberdeta = [];
                             //memberdeta = cmp.get('v.memberDetails.newMemberMatch');
		                     //result
                            //alert('newMemExistingDetails--> '+JSON.stringify(newMemExistingDetails));
		                    debugger;
                             var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                             setEvent.fire();
                            }
                            if(result.accountId != null && $A.util.isEmpty(result.isAcetSearch)){
                                var IdsPersonFamilyAccount = (result.accountId).split('@');
                                if(document.location.pathname.indexOf("/lightning/") != 0){
                                    var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                        "recordId": IdsPersonFamilyAccount[2],
                                        //"slideDevName": "related"
                                    });
                                    navEvt.fire();
                                }else{
                                    workspaceAPI.openTab({
                                        url: '/lightning/r/Account/'+IdsPersonFamilyAccount[1]+'/view',
                                        focus: true
                                        
                                    }).then(function(response) {
                                        var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                                        setEvent.fire();// US2021959 :Code Added By Chandan
                                        if(IdsPersonFamilyAccount[0]=='ITE'){
                                            //console.log('IdsPersonFamilyAccount[0]='+IdsPersonFamilyAccount[0]);
                                            //for(i=2;i<IdsPersonFamilyAccount.size();i++){
                                            workspaceAPI.openSubtab({
                                                parentTabId: response,
                                                url: '/lightning/r/Account/'+IdsPersonFamilyAccount[2]+'/view',
                                                focus: true
                                            });
                                            //}
                                        }
                                        var focusedTabId = response;
                                        //alert('response--> '+response);
                                        workspaceAPI.refreshTab({
                                            tabId: focusedTabId,
                                            includeAllSubtabs: true
                                        });
                                    }).catch(function(error) {
                                        
                                    });
                                }
                            }
                        }
                        else if( result.isSniUser){
                            cmp.set('v.showServiceErrors', true);
                            if (cmp.get("v.showHideMemAdvSearch") == true && cmp.get("v.displayMNFFlag") == true) {
                                cmp.set("v.mnf", 'mnf');
                                cmp.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                            }
                            cmp.set('v.serviceMessage', 'Family does not exist in ACET.');
                            helper.fireToast('Family does not exist in ACET.');   
                            var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                            setEvent.setParam("sniNotElligible", false); //US2216710 :Code Added By Chandan
                            setEvent.fire();// US2021959 :Code Added By Chandan
                        }
                            else if( result.isSniEligible){
                                cmp.set('v.showServiceErrors', true);
                                if (cmp.get("v.showHideMemAdvSearch") == true && cmp.get("v.displayMNFFlag") == true) {
                                    cmp.set("v.mnf", 'mnf');
                                    cmp.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                                }
                                cmp.set('v.serviceMessage', 'This member is not SNI Eligible.');
                                helper.fireToast('This member is not SNI Eligible.');
                                var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                                setEvent.setParam("sniNotElligible", true); //US2216710 :Code Added By Chandan
                                setEvent.fire();// US2021959 :Code Added By Chandan
                            }
                    }
                    else{ // data nulll
                        cmp.set('v.showServiceErrors', true);
                        if (cmp.get("v.showHideMemAdvSearch") == true && cmp.get("v.displayMNFFlag") == true) {
                            cmp.set("v.mnf", 'mnf');
                            cmp.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        cmp.set('v.serviceMessage', 'Unexpected error occurred. Please try again.');
                        helper.fireToast('Unexpected error occurred. Please try again.');   
                        var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start
                        setEvent.setParam("sniNotElligible", false); //US2216710 :Code Added By Chandan
                        setEvent.fire();// US2021959 :Code Added By Chandan
                    } 
                });
                $A.enqueueAction(action);
            }
   		 }
})