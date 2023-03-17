({
	checkProfile : function(cmp, event, helper) {
        //US1935707
        
        var action = cmp.get("c.getProfileUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                //console.log('storeResponse::: '+storeResponse);
                cmp.set("v.usInfo", storeResponse);
                //helper.checkProfileType(cmp, event, helper);
            }
        });
        $A.enqueueAction(action);
		
	},
    createGUID: function(component, event, helper) {
        var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.guid",GUIkey);
    },
    //US1935707: Research user - User doesnt see misdirect button
    checkProfileType: function(component, event, helper){
        
        var userProfileName = component.get("v.usInfo").Profile_Name__c;
        if (userProfileName == $A.get("$Label.c.ACETResearchUserProfile")){
            component.set("v.showSave", "false");
		}
    },
    
    //	US2552389	: by Madhura to get ISET URL from ISETWrap
    getISETURL : function(component, helper) {
        var action = component.get("c.getISETURL");
        var carrierId = component.get("v.carrierId");        
        console.log('??'+carrierId);
        action.setParams({
            memberId : component.get("v.memId"),
            groupNember : component.get("v.grpNum"),
            srk : component.get("v.srk"),
            memberGender : component.get("v.memberGender"),
            memberFirstName : component.get("v.memberFirstName"),
            memberLastName : component.get("v.memberLastName"),
            SSBCarrierId : carrierId,
            memberDOB : component.get("v.memberDOB")
        });
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            window.open(result, 'ISETwindow', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
        });
        $A.enqueueAction(action); 
    },
    
    getCarrierId : function(component) {
        var covInfoBenefits = component.get('v.coverageInfoBenefits');
        
        if(covInfoBenefits != undefined){
            var surrogateKey = covInfoBenefits.SurrogateKey;
            var bundleId = covInfoBenefits.benefitBundleOptionId;
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var benstartDate = covInfoBenefits.BenEffectiveDate;
            var benendDate = covInfoBenefits.BenEndDate;
            var groupNumber = covInfoBenefits.GroupNumber; 
            var action = component.get("c.getCarrierId");
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': '',
                'groupNumber': groupNumber,
                'accumAsOf': '',
                'SitusState' : '',
                'customerPurchaseId':component.get("v.customerPurchaseId")
            };
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if(!$A.util.isEmpty(result)) {
                        component.set("v.carrierId", result);
                    }  else if (state === "ERROR") {
                        console.log('ERROR at PlarmacyInquiryHelper.getCarrierId');
                    }
                }                
            });
            
            $A.enqueueAction(action);
        }
    }
})