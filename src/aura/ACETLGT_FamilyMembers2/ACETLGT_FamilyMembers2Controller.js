({
    init: function(cmp, event, helper) {
        console.log("init fam");
        //setTimeout(function(){window.lgtAutodoc.initAutodoc();},5000);

    },
    handleAppEventFam: function(cmp, event, helper) {
        console.log('++++++Inside FamilyMember handler fam');
        //helper.showSpinner2(component,event,helper);
        //var evntlist = event.getParam("familyMemberList");
        var evntlist = cmp.get("v.FamilyMemberList");
        //var evntMemDetail = event.getParam("MemberDetail");

        var famlist = [];
        console.log('++++---famlist---+++++ ' + evntlist);
        //console.log('++++---evntMemDetail---+++++ '+ evntMemDetail);
        if (evntlist != undefined) {
            evntlist.forEach(function(element) {
                console.log(element.fullName);
                //famlist.push( { value: element.fullName , label: element.fullName } );
                famlist.push(element);
            });
            console.log('+++++++++++++Fam Memb App handler ' + famlist);
        }
        cmp.set("v.FamilyMembers", famlist);
        //helper.hideSpinner2(component,event,helper);

    },

    handleAppEvent: function(cmp, event, helper) {
        var grp = event.getParam("covGroupSel");
        var eff = event.getParam("covEffDateSel");
        var srk = event.getParam("covSrkSel");
        var covLine = event.getParam("covLineSel");
        var covLineStr = JSON.stringify(covLine);

        cmp.set("v.groupNumber", grp);
        cmp.set("v.effectiveDate", eff);
        cmp.set("v.covLine", covLine);
        cmp.set("v.identifier", covLine.SurrogateKey);
        console.log('App event triggered ---- ');



    },
    covChanged: function(cmp, event, helper) {
        console.log('Cov tracker ---- call the service');
        //console.log(cmp.get("v.groupNumber")+cmp.get("v.groupNumber")+cmp.get("v.groupNumber")+cmp.get("v.groupNumber"));
        console.log('qqq' + cmp.get("v.identifier"));
        //setTimeout(function(){window.lgtAutodoc.initAutodoc();},1);
        //Old Code
        //helper.showfamilyMemberships(cmp,event, helper);

    },
    closeModal: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.isSameDetail", false);
        component.set("v.isOpenSubtabs", false);
        component.set("v.isNavMemError", false);
        
    },
    navMemberDetail: function(component, event, helper) {

        var result = true;
        var showpopup = false;
        var showErr1 = false;
        var showErr2 = false;
        var trimmedMemName;
        var trimmedOrigName;
        //US1928298 : Retain Originator
        var orgMemid = component.get("v.memId");

        var isSubscriber = "false";

        /*
         * US1928298 : US changed : No Subscriber required
         * 
        if(component.get("v.memberName") != undefined)
        	trimmedMemName = component.get("v.memberName").replace(/\s/g, "").toLowerCase();
        if(component.get("v.selectedOrginator") != undefined)
        	trimmedOrigName = component.get("v.selectedOrginator").replace(/\s/g, "").toLowerCase();
        console.log('trimmedMemName ::: '+ trimmedMemName + ' ::: '+trimmedOrigName);
        //if(orgMemid.substr(orgMemid.length-2,2) == '00' && component.get("v.selectedOrginator").trim() == component.get("v.originatorName").trim()){
        if(orgMemid.substr(orgMemid.length-2,2) == '00' && trimmedMemName == trimmedOrigName && trimmedMemName != undefined){
            isSubscriber = "true";
        }
        *
        */

        var userInfor = component.get("v.uInfo");
        isSubscriber = component.get("v.selectedOrginator");

        var workspaceAPI = component.find("workspace");
        var memId = event.currentTarget.getAttribute("data-memId");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
                var tabsLen = response.subtabs.length;
                var int = component.get("v.int");
                var showError = false;
                for (var i = 0; i < response.subtabs.length; i++) {
                    if (response.subtabs[i].recordId == null || !response.subtabs[i].recordId.startsWith('a0I') && !response.subtabs[i].recordId.startsWith('500') && !response.subtabs[i].recordId.startsWith('00T')) {
                        showError = true;
                    }
                    if(response.subtabs[i].recordId == null && response.subtabs[i].title.startsWith('New Task')){
                        showError = false;
                    }
                }

                if (tabsLen > 0 && showError)
                    showpopup = true;
                if (!showpopup && memId != component.get("v.memId")) {
                    //get the details from FindIndividualMembership webservice to open the Member Details page
                    //alert('----In 1---'+memId+'----->'+component.get("v.memId"));
                    var firstName = event.currentTarget.getAttribute("data-FN");
                    var lastName = event.currentTarget.getAttribute("data-LN");
                    var dob = event.currentTarget.getAttribute("data-dob");
                    var zip = '';
                    var state = '';
                    var interactionType = '';
                    var action = component.find("memSearchHelper").get("c.getSearchResults");
                    var dobstr = dob.split('/');
                    dob = dobstr[2] + '-' + dobstr[0] + '-' + dobstr[1];
                    //action.setStorable();

                    console.log('-MemId-->' + memId + '-firstName-->' + firstName + '-lastName-->' + lastName + '-dob-->' + dob + '-zip-->' + zip + '-intType-->' + interactionType + '-state-->' + state);
                    if (result) {
                        component.set("v.lstmembers");

                        // Setting the apex parameters
                        action.setParams({
                            memberId: memId,
                            firstName: firstName,
                            lastName: lastName,
                            dob: dob,
                            state: state,
                            zip: zip,
                            intType: interactionType
                        });
                        //helper.showSpinner2(component, event, helper);
                        //Setting the Callback
                        action.setCallback(this, function(a) {
                            //get the response state
                            var state = a.getState();
                            console.log('----state---' + state);
                            //check if result is successfull
                            if (state == "SUCCESS") {
                                var result = a.getReturnValue();
                                console.log('------result--------' + result);
                                if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                                    if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)) {

                                        component.set("v.lstmembers", result.resultWrapper);
                                        console.log(JSON.stringify(component.get("v.lstmembers")));
                                        var Individual = component.get("v.lstmembers");
                                        console.log('affiliationIndicatorrrrr : ', Individual[0].AffiliationIndicator);

                                        var isOnshore = component.get("v.isOnshore");
                                        console.log('~~~~isOnshore' + isOnshore);


                                        var cov;

                                        var Name = Individual[0].fullName;
                                        var lastName = Individual[0].lastName;
                                        var firstName = Individual[0].firstName;
                                        var fullssn = Individual[0].SSNum;
                                        var Id = Individual[0].Id;
                                        var grpNum;
                                        var scr = Individual[0].SCRId;
                                        var addr = Individual[0].address;
                                        var gen = Individual[0].gender;
                                        var sc = Individual[0].SourceCode;
                                        var srk = Individual[0].SurrogateKey;
                                        var ensrk = Individual[0].EnrolleeSurrogateKey;
                                        var subjectdob = Individual[0].dob;
                                        var coverage = Individual[0].CoverageLines;
                                        var IsMember = true;
                                        var individualIdentifier = Individual[0].individualIdentifier;
                                        var intType = '';
                                        var affiliationIndicator = Individual[0].AffiliationIndicator;
                                        console.log("-------co--->" + JSON.stringify(coverage));
                                        console.log("-------coverage--->" + coverage.length);
                                        console.log('Id ::: ' + Id);
                                        var specialtyBenefits = Individual[0].specialtyBenefits;
                                        console.log("xxx-------Spec Ben--->" + JSON.stringify(specialtyBenefits));

                                        for (var i = 0; i < coverage.length; i++) {
                                            if (coverage[i].isPreferred == true) {
                                                grpNum = coverage[i].GroupNumber;
                                            }
                                        }

                                        console.log("???======grpNum=====>>" + grpNum + srk + ensrk);
                                        component.set('v.Spinner', false);

                                        helper.navigateToDetail(component, event, helper, int.Id, Name, lastName, firstName, addr, sc, gen, fullssn, Id, scr, srk, subjectdob, IsMember, individualIdentifier, result, intType, coverage, int.Originator_Type__c, isOnshore, isSubscriber, grpNum, userInfor, JSON.stringify(specialtyBenefits), affiliationIndicator);
                                    }
                                }
                            } else if (state == "ERROR") {
                                component.set('v.Spinner', false);
                                component.set('v.isNavMemError', true);

                                component.set("v.lstmembers");
                            }
                            //helper.hideSpinner2(component, event, helper);
                        });

                        //adds the server-side action to the queue      
                        component.set('v.Spinner', true);
                        $A.enqueueAction(action);
                    }
                } else if (showpopup && memId != component.get("v.memId")) {
                    //alert('----In 2---');
                    component.set("v.isOpen", true);
                    component.set("v.isOpenSubtabs", true);
                    component.set("v.isSameDetail", false);
                } else if (memId == component.get("v.memId")) {
                    //alert('----In 3---');
                    component.set("v.isOpen", true);
                    component.set("v.isSameDetail", true);
                    component.set("v.isOpenSubtabs", false);
                }
            })
            .catch(function(error) {
                console.log(error);
            });



    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.Spinner", true);
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.Spinner", false);
    }


})