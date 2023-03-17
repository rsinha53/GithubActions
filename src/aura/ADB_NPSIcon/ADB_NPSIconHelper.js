({
npsIconDataList : function(component,helper){
        var action = component.get("c.callNPSService");
        var memberId = component.get("v.decodedMemberId");
        action.setParams({ memberId : memberId});
        action.setCallback(this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                var npsDetails = response.getReturnValue();
                component.set("v.surveyList", npsDetails);
                if(npsDetails != null && npsDetails.length > 0){
                    var firstList = npsDetails[0];
                    if(firstList != null && firstList.length > 0){
                        for(var i in firstList){
                            if((i == 0) && (!$A.util.isEmpty(firstList[i])) && (!$A.util.isUndefined(firstList[i]))){
                                var surveyName = firstList[i];
                                component.set("v.surveyName", surveyName);
                            }
                            if((i == 1) && (!$A.util.isEmpty(firstList[i])) && (!$A.util.isUndefined(firstList[i]))){
                                var surveyDate = firstList[i];
                                component.set("v.surveyDate",surveyDate);
                            }
                            if((i == 2) && (!$A.util.isEmpty(firstList[i])) && (!$A.util.isUndefined(firstList[i]))){
                                var surveyScore = firstList[i];
                                component.set("v.surveyScore", surveyScore);
                            }
                        }  
                    }
                    var secondList = npsDetails[1];
                    if(secondList != null && secondList.length > 0){
                        for(var i in secondList){
                            if((i == 0) && (!$A.util.isEmpty(secondList[i])) && (!$A.util.isUndefined(secondList[i]))){
                                var secondIconName = secondList[i];
                                component.set("v.secondIconName", secondIconName);
                            }
                            if((i == 1) && (!$A.util.isEmpty(secondList[i])) && (!$A.util.isUndefined(secondList[i]))){
                                var secondIconDate = secondList[i];
                                component.set("v.secondIconDate", secondIconDate);
                            }
                            if((i == 2) && (!$A.util.isEmpty(secondList[i])) && (!$A.util.isUndefined(secondList[i]))){
                                var secondIconScore = secondList[i];
                                component.set("v.secondIconScore",secondIconScore);
                            }
                        }  
                    }
                    var thirdList = npsDetails[2];
                    if(thirdList != null && thirdList.length > 0){
                        for(var i in thirdList){
                            if((i == 0) && (!$A.util.isEmpty(thirdList[i])) && (!$A.util.isUndefined(thirdList[i]))){
                                var thirdIconName = thirdList[i];
                                component.set("v.thirdIconName", thirdIconName);
                            }
                            if((i == 1) && (!$A.util.isEmpty(thirdList[i])) && (!$A.util.isUndefined(thirdList[i]))){
                                var thirdIconDate = thirdList[i];
                                component.set("v.thirdIconDate", thirdIconDate);
                            }
                            if((i == 2) && (!$A.util.isEmpty(thirdList[i])) && (!$A.util.isUndefined(thirdList[i]))){
                                var thirdIconScore = thirdList[i];
                                component.set("v.thirdIconScore",thirdIconScore);
                            }
                        }  
                    }
                }else{
                    component.set("v.defIcon", true);
                }
            }
			component.set('v.showSpinner',false);									 
        });
        $A.enqueueAction(action);
    }
})