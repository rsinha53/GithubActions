({
    getMemberSearch : function(component, event, helper){
        var memberId = component.get("v.decodedMemberId");
        var memberDob = component.get("v.memberDateofBirth");
        if(memberDob != null){
            var bdylist = memberDob.split("/");
            var memDob = bdylist[2]+bdylist[0]+bdylist[1];
        }
        var memFirstName = component.get("v.firstName");
        var memLastName = component.get("v.lastName");
        var date = new Date();
        var timestamp = date.getTime();
        var action = component.get("c.getMemberSearch");
        action.setParams({ 
            memberId : memberId,
            memDob : memDob,
            firstName : memFirstName,
            lastName : memLastName,
            timestamp : timestamp
        });
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.rxDetails", records);
                helper.fireRxEvent(component, event, helper);
            }
            component.set('v.showSpinner',false);
        });
        $A.enqueueAction(action);  
    },
    
    fireRxEvent : function(component, event, helper){
        var cmpEvent = component.getEvent("rxDetailsEvent");
        var rxDetails = component.get("v.rxDetails");
        cmpEvent.setParams( {"rxDetails" : rxDetails});
        cmpEvent.fire();
        helper.getClaimsSearch(component, event, helper);
    },
    
    //Get Claims Search V2 Service.
    getClaimsSearch : function(component, event, helper){
        var rxDetails = component.get("v.rxDetails");
        var carrierID = rxDetails.carrierId; //'UHCACIS01';
        var accountId = rxDetails.accountId; //'A';
        var groupId = rxDetails.groupId; //'016850412971171';
        var rxMemberId = rxDetails.memberId; //'95659395800';
        var instanceId = rxDetails.instanceId; //'BOOK2';
        var date = new Date();
        var timestamp = date.getTime();
        var fillDateThru = $A.localizationService.formatDate(date, "YYYYMMDD");
        var dateFrom = date.setDate(date.getDate() - 365);
        var fillDateFrom = $A.localizationService.formatDate(dateFrom, "YYYYMMDD");
        var action = component.get("c.getClaimsSearch");
        action.setParams({ 
            carrierID : carrierID,
            accountId : accountId,
            groupId : groupId,
            rxMemberId : rxMemberId,
            instanceId : instanceId,
            timestamp : timestamp,
            fillDateThru : fillDateThru,
            fillDateFrom : fillDateFrom
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordsList = response.getReturnValue();
                if(recordsList != null && recordsList.claimSearchV2ServiceItem != null){
                    if(recordsList.claimSearchV2ServiceItem.length  > 0){
                        var claimObj = {
                            'claimStatus':recordsList.claimStatus,
                            'fillDate':recordsList.fillDate,
                            'productNameAbbreviation':recordsList.productNameAbbreviation,
                            'pharmacyName':recordsList.pharmacyName,
                            'daysSupply':recordsList.daysSupply
                        };
                    }
                    var currentDate = new Date();
                    var lastDate = new Date();
                    lastDate.setDate(lastDate.getDate() - 365); 
                    var withinPeriod = [], outofPeriod = [];
                    for (var key in recordsList.claimSearchV2ServiceItem){
                        // check 12 months logic
                        var fillDate = new Date(recordsList.claimSearchV2ServiceItem[key].fillDate); 
                        if(lastDate > fillDate){
                            outofPeriod.push(recordsList.claimSearchV2ServiceItem[key]);
                        }else{
                            withinPeriod.push(recordsList.claimSearchV2ServiceItem[key]); 
                        }
                    }
                    if(withinPeriod.length == 0 && outofPeriod.length > 0){
                        component.set("v.phyOutofPeriodMsg", true);
                    }
                    component.set("v.claimDetails", withinPeriod);
                }
            }
        });
        $A.enqueueAction(action);
    }
})