({
    onInit: function(component, event, helper) {
        console.log("init is called of claim status");
        var  claimStatusList = component.get("v.selectedClaimStatusTable");
        console.log("v.selectedClaimStatusTable in ACET_ClaimStatusTable: "+ JSON.stringify(claimStatusList));

        //KJ multiple tabs autodoc component order begin
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
        claimStatusList.componentOrder = claimStatusList.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        //KJ multiple tabs autodoc component order end

        //US3120337 - Chandra Start
        helper.getPaymentNumber(component, event, helper);
        //component.set("v.claimStatusList",claimStatusList);
        //US3120337 - Chandra End
        //
        var memberDob = component.get("v.memberDOB");
        if(!$A.util.isUndefinedOrNull(memberDob) && !$A.util.isEmpty(memberDob)){
            let dt = new Date(memberDob),
                month = '' + (dt.getMonth() + 1),
                day = '' + dt.getDate(),
                year = dt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            memberDob = year + '-' + month + '-' + day;
            component.set("v.startDate", memberDob);
        }
    },
    getSelectedRecords: function (component, event, helper) {
        var data = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        var cellIndex = event.getParam("currentCellIndex");
        var cellData = data.rowColumnData[cellIndex].cellData;
        console.log("Row data "+ JSON.stringify(data));
        if(cellIndex == 14){
            if(component.get("v.intrestCardEnable")){
                let claimSvcLineDtl = {};
                //claimSvcLineDtl.rcode = '5U';
                var interactionRec = component.get("v.interactionRec");
                var intrestCardData = component.get("v.intrestCardData");
                if(!$A.util.isUndefinedOrNull(intrestCardData) && !$A.util.isEmpty(intrestCardData)){
                    for( var j = 0;j<intrestCardData.cardData.length;j++)
                    {
                        if(j == 0){
                            claimSvcLineDtl.rcode = intrestCardData.cardData[j].fieldValue.split(' - ')[0];
                        }else{
                            claimSvcLineDtl.rcode = claimSvcLineDtl.rcode+', '+intrestCardData.cardData[j].fieldValue.split(' - ')[0];
                        }
                    }
                }
                let componentUniqueid = 'svcdltcmp';
                $A.createComponent('c:ACET_ClaimServiceLineDetails', {
                    "aura:id" : componentUniqueid,
                    autodocUniqueId: component.get("v.autodocUniqueId"),
                    autodocUniqueIdCmp: component.get("v.autodocUniqueIdCmp"),
                    selectedSvcLineDtlCard: component.get("v.intrestCardData"),
                    serviceLineDtls: claimSvcLineDtl,
                    interactionId:interactionRec.Name,
                    isIntrest:false,
                    version:data.rowColumnData[0].fieldValue,
                    componentUniqueid : componentUniqueid,
                    rowIndex : componentUniqueid,
                    currentIndexOfOpenedTabs:component.get("v.currentIndexOfOpenedTabs"),
                },
                                   function (newClmSvcInfoCard, status, errorMessage) {
                                       if (status === "SUCCESS"){
                                          var paymentStatusList = component.get("v.paymentStatusList");
                                           paymentStatusList.unshift(newClmSvcInfoCard);
                                           component.set("v.paymentStatusList", paymentStatusList);
                                           helper.sortPayStatusCards(component);
                                           setTimeout(function(){
                                               try {
                                                   component.find(componentUniqueid).getElement().scrollIntoView({
                                                       behavior: 'smooth',
                                                       block: 'center'
                                                   });
                                               } catch(exception) {
                                                   console.log(' exception ' + exception);
                                               }
                                           }, 100);
                                       }
                                   });
                component.set("v.intrestCardEnable", false);
            }
        }else if(component.get("v.paymentStatusCardEnable") || (component.get("v.paymentStatusNYCardEnable") && cellIndex == 17)){
            let claimStatus = {};
            claimStatus.status = data.rowColumnData[2].fieldValue;
            claimStatus.paymentNo = data.rowColumnData[13].fieldValue;
            //Added by Mani -- 11/20/2020 US1866504 -- start
            var claimInput = component.get("v.claimInput");
            var transactionId = component.get("v.transactionId");
            console.log("**21**"+JSON.stringify(claimInput));
            console.log("**21**"+transactionId);
            // Added by mani -- End
            let componentUnique = 'svcdltcmp1';
             if(cellIndex == 17){
                  componentUnique = 'svcdltcmp2';
                  claimStatus.paymentNo = data.rowColumnData[17].fieldValue;
            }
            $A.createComponent('c:ACET_PaymentStatus', {
                "aura:id" : componentUnique,
                statuCmpId: claimStatus.status,
                paymentNo: claimStatus.paymentNo,
                selectedClaimDetailCard: component.get("v.selectedClaimDetailCard"),
                isClaim:component.get("v.isClaim"),
                autodocUniqueId: component.get("v.autodocUniqueId"),
                autodocUniqueIdCmp: component.get("v.autodocUniqueIdCmp"),
                claimInput: claimInput,
                transactionId: transactionId,
                currentIndexOfOpenedTabs:component.get("v.currentIndexOfOpenedTabs"),
                relatedDocData:component.get("v.relatedDocData"),
                //US3705824: View Payments: Select Claim # Hyperlink in Payment Status Card
                cobMNRCommentsTable:component.get("v.cobMNRCommentsTable"),
                regionCode:component.get("v.regionCode"),
                cobENIHistoryTable:component.get("v.cobENIHistoryTable"),
                AuthAutodocPageFeature:component.get("v.AuthAutodocPageFeature"),
                SRNFlag:component.get("v.SRNFlag"),
                isHippaInvokedInProviderSnapShot:component.get("v.isHippaInvokedInProviderSnapShot"),
                dependentCode:component.get("v.dependentCode"),
                secondaryCoverageList:component.get("v.secondaryCoverageList"),
                isMRlob:component.get("v.isMRlob"),
                houseHoldData:component.get("v.houseHoldData"),
                cobData:component.get("v.cobData"),
                memberTabId:component.get("v.memberTabId"),
                policyDetails:component.get("v.PolicyDetails"),
                claimInput:component.get("v.claimInput"),
                policyNumber:component.get("v.policyNumber"),
                policySelectedIndex:component.get("v.policySelectedIndex"),
                memberPolicies:component.get("v.memberPolicies"),
                selectedPolicy:component.get("v.selectedPolicy"),
                callTopicLstSelected:component.get("v.callTopicLstSelected"),
                providerDetails:component.get("v.providerDetails"),
                hipaaEndpointUrl:component.get("v.hipaaEndpointUrl"),
                contactUniqueId:component.get("v.contactUniqueId"),
                interactionRec:component.get("v.interactionRec"),
                interactionOverviewTabId:component.get("v.interactionOverviewTabId"),
                caseWrapperMNF:component.get("v.caseWrapperMNF"),
                componentId:component.get("v.componentId"),
                memberDOB:component.get("v.memberDOB"),
                memberFN:component.get("v.memberFN"),
                memberCardData:component.get("v.memberCardData"),
                memberCardSnap:component.get("v.memberCardSnap"),
                houseHoldMemberId:component.get("v.houseHoldMemberId"),
                currentPayerId:component.get("v.currentPayerId"),
                autoDocToBeDeleted:component.get("v.autoDocToBeDeleted"),
                memberLN:component.get("v.memberLN"),
                authContactName:component.get("v.authContactName"),
                interactionType:component.get("v.interactionType"),
                AutodocPageFeatureMemberDtl:component.get("v.AutodocPageFeatureMemberDtl"),
                AutodocKeyMemberDtl:component.get("v.AutodocKeyMemberDtl"),
                noMemberToSearch:component.get("v.noMemberToSearch"),
                interactionCard:component.get("v.interactionCard"),
                selectedTabType:component.get("v.selectedTabType"),
                originatorType:component.get("v.originatorType"),
                callTopicOrder:component.get("v.callTopicOrder"),
                planLevelBenefitsRes:component.get("v.planLevelBenefitsRes"),
                eligibleDate:component.get("v.eligibleDate"),
                highlightedPolicySourceCode:component.get("v.highlightedPolicySourceCode"),
                isSourceCodeChanged:component.get("v.isSourceCodeChanged"),
                policyStatus:component.get("v.policyStatus"),
                isTierOne:component.get("v.isTierOne"),
                callTopicTabId:component.get("v.callTopicTabId"),

                pageNumber:component.get("v.pageNumber"),
                memberautodocUniqueId:component.get("v.memberautodocUniqueId"),
                insuranceTypeCode:component.get("v.insuranceTypeCode"),
                memberId:component.get("v.memberId"),
                contactName:component.get("v.contactName"),
                providerDetailsForRoutingScreen:component.get("v.providerDetailsForRoutingScreen"),
                flowDetailsForRoutingScreen:component.get("v.flowDetailsForRoutingScreen")

            },
                               function (newPaymentStatusCard, status, errorMessage) {
                                   if (status === "SUCCESS"){
                                       var paymentStatusList = component.get("v.paymentStatusList");
                                       paymentStatusList.unshift(newPaymentStatusCard);
                                       component.set("v.paymentStatusList", paymentStatusList);
                                       helper.sortPayStatusCards(component);
                                       setTimeout(function(){
                                               try {
                                                   component.find(componentUnique).getElement().scrollIntoView({
                                                       behavior: 'smooth',
                                                       block: 'center'
                                                   });
                                               } catch(exception) {
                                                   console.log(' exception ' + exception);
                                               }
                                           }, 100);
                                   }
                               });
            if(cellIndex == 17)
             component.set("v.paymentStatusNYCardEnable", false);
            else
              component.set("v.paymentStatusCardEnable", false);
        }

    },
    navigateToCallTopic : function(component, event, helper) {
        setTimeout(function() {
            var params= event.getParam('arguments').topicName;
            //var callTopicName = component.get("v.callTopicName");
            //var callTopicName = event.getParam('selectedCallTopic');
            if (!$A.util.isUndefinedOrNull(params) && params == "referrals") {
                component.find("viewReferralsDetails").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });

            } else if (!$A.util.isUndefinedOrNull(params) && params == "authorizations") {
                component.find("AuthorizationDetails").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });

            }
        }, 100);
    },
    //Jay Start
    setClaimDetailsTopic : function(component, event, helper) {
        var topicname = event.getParam("topicname");
        if(topicname == 'authorizations')
        {
            component.set("v.topicAuthNO",1);
            component.set("v.topicRefNO",2);
            component.set("v.authorizations",true);
        }

        else if( topicname == 'referrals')
        {
            component.set("v.topicRefNO",1);
            component.set("v.topicAuthNO",2);
            component.set("v.referrals",true);
        }
        helper.navigateToCallTopic(component, event, helper);
    },
    //Jay End
    handlecloseServiceLine : function (component, event, helper){
        var componentUniqueid = event.getParam("componentUniqueid");
        var rowIndex = event.getParam("rowIndex");
        var clmSvcInfoList = component.get("v.paymentStatusList");

        var componentfound = component.find(componentUniqueid);
        //remove component
        for( var i = 0; i < clmSvcInfoList.length; i++){
            if ( clmSvcInfoList[i] === componentfound) {
                clmSvcInfoList.splice(i, 1);
                component.set("v.intrestCardEnable", true);
            }
        }

        component.set("v.paymentStatusList", clmSvcInfoList);
    }

})