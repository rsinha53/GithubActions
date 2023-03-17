({
    // get the complete date by making a health assessment service call
    getcompletionDate :function(component, event, helper) {
        
        var action = component.get("c.getCompletionDate");
        
        //get big 5 to pass to the service
        var memberId = component.get("v.decodedMemberId");
        var firstName = component.get("v.memFirstName");
        var lastName = component.get("v.memLastName");
        var contractNumber = component.get("v.memberPolicy");
        var memberdob = component.get("v.memberDob");
        console.log('DOB from ISET'+memberdob);
        console.log('Params ::::',memberId+firstName+lastName+memberdob+contractNumber);
        action.setParams({ memberId : memberId,
                          firstName: firstName,
                          lastName : lastName,
                          memberDob : memberdob,
                          contractNumber : contractNumber}); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cDate = response.getReturnValue();
                console.log('completion date ', cDate);
                // Remove previous logic and call dateFormatting method - Hasara - 04/05/2020
                var completionDate = this.dateFormatting(helper,cDate);
                if(completionDate != null){
                    component.set("v.completion_Date", completionDate);
                } 
            }else{
                component.set('v.dataNotLoaded',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getIncentiveDetails :function(component, event, helper) {
        var action = component.get("c.getIncentives");
        
        var memberId = component.get("v.decodedMemberId");
        var firstName = component.get("v.memFirstName");
        var lastName = component.get("v.memLastName");
        var groupNumber = component.get("v.memberPolicy");
        var DOB = component.get("v.memberDob");
        
        // change date format as per the request
        if(DOB != undefined){
            var memberDOB = DOB.split("/");
            var memberdob = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        } 
        
        console.log('Params get incentives::::',memberId+firstName+lastName+memberdob+groupNumber);
        action.setParams({ memberNumber : memberId,
                          firstName: firstName,
                          lastName : lastName,
                          dob : memberdob,
                          groupNumber : groupNumber}); 
        
        action.setCallback(this, function(response) {
            console.log('in set callback of get incentives');
            component.set('v.dataNotLoaded',false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordsList = response.getReturnValue();
                component.set("v.completedActivities", recordsList.completedActivitiesList);
                component.set("v.pendingActivities", recordsList.pendingActivitiesList);
                component.set("v.planDetails", recordsList.plan);
                component.set("v.totalCOinYield", recordsList.totalCOinYield);
                
                // For Formatte Completion Date 
                if(recordsList!= null && recordsList.completedActivitiesList != null){
                for (let i=0; i < recordsList.completedActivitiesList.length; i++){
                    var completiondate = recordsList.completedActivitiesList[i].activityCompletionDate;
                    
                    var FormattedCompletionDate = this.dateFormatting(helper,completiondate);
                    if(FormattedCompletionDate != null){
                        var tempCmplist = [];
                        tempCmplist = component.get("v.completionDate");
                        tempCmplist.push(FormattedCompletionDate);
                        component.set("v.completionDate",tempCmplist);
                    } 
                } 
            }
                if(recordsList!= null && recordsList.plan != null){
                // For Formate Plan Name
                var planName = recordsList.plan.planName;
                
                var planNameList = (planName!= null)?planName.split('_'):'';
                var pName = planNameList[1];
                component.set("v.planName", pName);
                
                // For Formate Start Date of Plan
                var strdate = recordsList.plan.planStartDate;
                var startDtFrmtd = this.dateFormatting(helper,strdate);
                if(startDtFrmtd != null){
                    component.set("v.startDate", startDtFrmtd);
                }
                var enddate = recordsList.plan.planEndDate;  
                var endDtFrmtd = this.dateFormatting(helper,enddate);
                if(endDtFrmtd != null){
                    component.set("v.endDate", endDtFrmtd);
                }
            	}
            }
               
        });
        $A.enqueueAction(action);
    },
    dateFormatting : function(helper,date) {
        if(date !=  null && date.includes('T')){
            var datePartsList = date.split('T');
            var datePart = datePartsList[0];
            if(datePart != null){
                var datesplit = datePart.split('-');
                var formatDate = datesplit[1]+ '/' +datesplit[2]+ '/' +datesplit[0];
                return formatDate;
            }
        }
        else if(date !=  null && date.includes('-')){
            var datePartsList = date.split('-');
            var formatDate = datesplit[1]+ '/' +datesplit[2]+ '/' +datesplit[0];
            return formatDate;
        }
    },
    
     openWellnessHASummaryUrl: function(component, event, helper) {
        var action = component.get("c.getWellnessHASummaryUrl");
         var userId = component.get("v.agentUserId");
         var cdbXrefId = component.get("v.memberXrefId");
         action.setParams({ cdbXrefId : cdbXrefId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('redirect url'+resp);
                // to navigate to ISET pharmacy claims
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
            }
           
        });
        $A.enqueueAction(action);
    },
    
    openWellnessDefaultUrl: function(component, event, helper) {
        var action = component.get("c.getWellnessDefaultUrl");
        var userId = component.get("v.agentUserId");
       	var cdbXrefId = component.get("v.memberXrefId");
         action.setParams({ cdbXrefId : cdbXrefId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                // to navigate to ISET pharmacy claims
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
            }
           
        });
        $A.enqueueAction(action);
    },
})