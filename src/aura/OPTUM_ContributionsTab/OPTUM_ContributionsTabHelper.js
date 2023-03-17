({
	autoDocCont : function(cmp, event, helper) {
         var autoDocTabData = cmp.get("v.accountList");
         var ContriDetails = [];
         var details={cyFilingStatus:autoDocTabData[0].nonNotionalAccountDetails[0].cyFilingStatus
                     ,cyContributionLimit:autoDocTabData[0].nonNotionalAccountDetails[0].cyContributionLimit
                     ,totalContribution:autoDocTabData[0].nonNotionalAccountDetails[0].totalContribution
                     ,cyEmployeeContribution:autoDocTabData[0].nonNotionalAccountDetails[0].cyEmployeeContribution
                     ,cyEmployerContribution :autoDocTabData[0].nonNotionalAccountDetails[0].cyEmployerContribution
                     ,currentYear:cmp.get("v.currentYear")
                     ,previousYear:cmp.get("v.previousYear")
                     ,totalContribution:cmp.get("v.totalContribution")
                     ,rollOver:''
                    };
        var detailsTwo={pyEmployeeContributionForCy:autoDocTabData[0].nonNotionalAccountDetails[0].pyEmployeeContributionForCy
                     ,pyEmployerContributionForCy:autoDocTabData[0].nonNotionalAccountDetails[0].pyEmployerContributionForCy
                     ,currentYear:cmp.get("v.currentYear")
                     ,previousYear:cmp.get("v.previousYear")
                     };
        ContriDetails.push(details);
        ContriDetails.push(detailsTwo);
        var action = cmp.get('c.getautoDocContributions');
        action.setParams({
            "contDetails": ContriDetails
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.autoDocContributions" ,response.getReturnValue());
             }
        });
        $A.enqueueAction(action);
    },
    
    autoDocContForPy : function(cmp, event, helper) {
         var autoDocTabData = cmp.get("v.accountList");
         var ContriDetailsForPy = [];
         var details={pyFilingStatus:autoDocTabData[0].nonNotionalAccountDetails[0].pyFilingStatus
                     ,pyContributionLimit:autoDocTabData[0].nonNotionalAccountDetails[0].pyContributionLimit
                     ,totalPrevious:autoDocTabData[0].nonNotionalAccountDetails[0].totalPrevious
                     ,pyEmployeeContribution:autoDocTabData[0].nonNotionalAccountDetails[0].pyEmployeeContribution
                     ,pyEmployerContribution :autoDocTabData[0].nonNotionalAccountDetails[0].pyEmployerContribution
                     ,previousYear:cmp.get("v.previousYear")
                     ,totalPrevious:cmp.get("v.totalPrevious")
                     ,rollOver:''
                    };
         ContriDetailsForPy.push(details);
         var action = cmp.get('c.getautoDocContpreviousyear');
        action.setParams({
            "contDetailsForPy": ContriDetailsForPy
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.autoDocContributionsForPy" ,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
	
})