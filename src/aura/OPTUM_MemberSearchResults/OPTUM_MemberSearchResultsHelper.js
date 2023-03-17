({
    // Added by Dimpy for US3135948 Tech Story: Fuzzy search API integration
    changeFormat: function (component, event, helper, memberSearchList, searchType) {
        var memberList = [];
        if (searchType == "Advance") {
            memberList = memberSearchList;
        } else {
            memberList.push(memberSearchList.member);
            //US3703234: Member with No Accounts
            if(memberSearchList.accountDetails != null && !($A.util.isUndefinedOrNull(memberSearchList.accountDetails)) 
               && !((Object.keys(memberSearchList.accountDetails).length)==0)) {
                helper.getEmployerID(component, event, helper, memberSearchList.accountDetails);
            	memberList[0].aliasAdded = memberSearchList.accountDetails[0].accountAlias;
            }
            memberList[0].employerNameAdded = component.get("v.employerName");
        }
        if (memberList != 'undefined')
            for (var i = 0; i < memberList.length; i++) {
                var phoneMobile = memberList[i].phoneMobile;
                var phoneWork = memberList[i].phoneWork;
                var phoneHome = memberList[i].phoneHome;
                var ssnValue = memberList[i].ssn;
                var dateString = memberList[i].birthDate;

                memberList[i].formattedDate = $A.localizationService.formatDate(dateString, "MM/dd/YYYY");
                component.set("v.faroId", memberList[i].faroId);
                memberList[i].formattedSSN = ssnValue.substr(0, 3) + '-' + ssnValue.substr(3, 2) + '-' + ssnValue.substr(5, 4);

                if (typeof phoneMobile !== "undefined" && phoneMobile !== null) {
                    if (phoneMobile.length == 10) {
                        phoneMobile = '(' + phoneMobile.substring(0, 3) + ')' + ' ' + phoneMobile.substring(3, 6) + '-' + phoneMobile.substring(6, 10) + ' (M)';
                        memberList[i].formattedPhMobile = phoneMobile;
                    }
                }
                if (typeof phoneWork !== "undefined" && phoneWork !== null) {
                    if (phoneWork.length == 10) {
                        phoneWork = '(' + phoneWork.substring(0, 3) + ')' + ' ' + phoneWork.substring(3, 6) + '-' + phoneWork.substring(6, 10) + ' (W)';
                        memberList[i].formattedPhWork = phoneWork;

                    }
                }

                if (typeof phoneHome !== "undefined" && phoneHome !== null) {
                    if (phoneHome.length == 10) {
                        phoneHome = '(' + phoneHome.substring(0, 3) + ')' + ' ' + phoneHome.substring(3, 6) + '-' + phoneHome.substring(6, 10) + ' (H)';
                        memberList[i].formattedPhHome = phoneHome;
                    }
                    else {
                        phoneHome = phoneHome + ' (M)';
                        memberList[i].formattedPhHome = phoneHome;
                    }
                }
            }
        component.set("v.memeberList", memberList);
    },

    getEmployerID: function (component, event, helper, accountDetails) {
        for (var i = 0; i < accountDetails.length; i++) {
            if (accountDetails[i].hasOwnProperty("notionalAccountDetails")) {
                if (accountDetails[i].employerId != null) {
                    component.set("v.employerId", accountDetails[i].employerAlias);
                    component.set("v.employerGroupName", accountDetails[i].employerGroupName);
                    var IDName = component.get("v.employerGroupName") + '(' + component.get("v.employerId") + ')';
                    component.set("v.employerName", IDName);
                }
                else if (accountDetails[i].employerId == null) {
                    component.set("v.employerName", accountDetails[i].employerGroupName);
                }
            }
            else if (accountDetails[i].hasOwnProperty("nonNotionalAccountDetails")) {
                component.set("v.employerName", accountDetails[i].employerGroupName);
            }
        }
    },

     //Updated this method as part of US3329760 by Venkat
    openTab: function (component, event, helper,personAccId) {
        var workspaceAPI = component.find("workspace");
                        workspaceAPI.openTab({
                            pageReference: {
                                "type": "standard__recordPage",
                                "attributes": {
                                    "recordId":personAccId,
                                    "actionName":"view"
                                },
                                "state": {
                                }
                            },
                            focus: true
                        }).then(function (response) {
                            workspaceAPI.getTabInfo({
                                tabId: response

                            }).then(function (tabInfo) {
                                var middleName = component.get("v.MemberDetails.member.middleName");
        						var fistname = component.get("v.MemberDetails.member.firstName");
       						 	var lastName = component.get("v.MemberDetails.member.lastName");
         							if (typeof middleName !== "undefined" || middleName != null || !middleName ==="") {
            							var labelName = fistname+" "+ middleName +" "+ lastName;
                					}else{
                                        var labelName = fistname+" "+lastName;
                                    }
                                var focusedTabId = tabInfo.tabId;
                                workspaceAPI.setTabLabel({
                                    tabId: focusedTabId,
                                    label: labelName,
                                });
                                workspaceAPI.setTabIcon({
                                    tabId: focusedTabId,
                                    icon: "standard:contact_list",
                                    iconAlt: "Member Overview"
                                });
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
    },

    //Edited by Dimpy for DE384310: One member Account Details are displayed on another member
    addPersonAndInteraction: function (component, event, helper) {
        component.set("v.Spinner", true);
        //US3703234: Member with No Accounts
        var participantEmpExtlId;
        var participantEmpCode;
        var participantAdAlias;
        var ssnMemberDetails = component.get("v.MemberDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
           && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
            participantEmpExtlId =component.get("v.MemberDetails.accountDetails[0].accountId");
            participantEmpCode = component.get("v.MemberDetails.accountDetails[0].accountAlias");
            participantAdAlias = component.get("v.MemberDetails.accountDetails[0].employerAlias");
        }
        var action = component.get('c.addPersonAccount');
        action.setParams({
            "firstName": component.get("v.MemberDetails.member.firstName"),
            "lastName": component.get("v.MemberDetails.member.lastName"),
            "dob": component.get("v.MemberDetails.member.birthDate"),
            "eid": component.get("v.MemberDetails.member.faroId"),
            "participantEmployeeExternalId": participantEmpExtlId,
            "participantEmployerCode": participantEmpCode,
            "participantAdminAlias": participantAdAlias
            
        });

        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var InteractionType = component.get("v.InteractionType");
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                var personAccId=responseValue.Id;// Added as part of US3329760 by Venkat
                component.set("v.optumEID", component.get("v.MemberDetails.member.faroId"));
                var actionAccount = component.get('c.createInteraction');
                actionAccount.setParams({
                    "interactionType": InteractionType,
                    "originatorType": "Member",
                    "con": responseValue,
                    "question": null,
                    "memberDetails":component.get("v.MemberDetails") // Added as part of US3329760 by Venkat

                });
                actionAccount.setCallback(this, function (response) {
                    var state = response.getState(); // get the response state
					if (state == 'SUCCESS') {
                        component.set("v.Spinner", false);
                        var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                        component.set("v.optumInt", responseValue);
                        helper.openTab(component, event, helper, personAccId);
                    }
                    else if (state === "INCOMPLETE") {
                        alert("I am INCOMPLETE")
                        component.set("v.Spinner", false);
                    }
                    else if (state === "ERROR") {
                        console.log("Unknown error");
                        component.set("v.Spinner", false);

                    }
                });
                $A.enqueueAction(actionAccount);
            }
            else if (state === "INCOMPLETE") {
                alert("I am INCOMPLETE")
                component.set("v.Spinner", false);
            }
            else if (state === "ERROR") {
                console.log("Unknown error");
                component.set("v.Spinner", false);

            }
        });
        $A.enqueueAction(action);

    },

    callSearchApi: function (component, event, helper, faroId) {
        var action = component.get("c.searchMemberWithSSN");
        component.set("v.Spinner", true);
        action.setParams({
            "faroId": faroId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                if (!(Object.keys(responseValue.result.data).length) == 0) {
                    component.set("v.MemberDetails", responseValue.result.data);
                    helper.addPersonAndInteraction(component, event, helper);
                } else {
                    component.set("v.Spinner", false);
                }

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                component.set("v.Spinner", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                        alert(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

        });
        $A.enqueueAction(action);
    }

})