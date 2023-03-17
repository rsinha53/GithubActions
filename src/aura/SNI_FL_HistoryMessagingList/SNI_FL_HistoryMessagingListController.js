({
	selectMessageThread : function(component, event, helper) {
        var currSelCard = document.getElementsByClassName("selected");
        for (var i=0; i<currSelCard.length; i++) {
            $A.util.removeClass(currSelCard[i], 'selected');
        	$A.util.addClass(currSelCard[i], 'unselected');
        }
        var selCard = event.target;
        $A.util.removeClass(selCard, 'unselected');
        $A.util.addClass(selCard, 'selected');
        var memAffId =event.target.getAttribute('data-memberAffid');
        var authorName =event.target.getAttribute('data-authorName');
        var messageTime =event.target.getAttribute('data-messageTime');
        var cmpEvent = component.getEvent("SNI_FL_SendMemberAffiliationEvt");
        cmpEvent.setParams({
            memberAffiliationId : memAffId,
            ListauthorName: authorName,
            ListDateTime: messageTime
        });
        cmpEvent.fire();
	},
    handleNext : function(component,event,helper){
        helper.handlerSpinner(component,event,true);
        helper.sendBlankMemAffId(component,event);
        var nextPage = component.get('v.provCurrentPage') + 1;
        var personId = component.get('v.providerAffId');
        var action=component.get("c.getProviderMessages");
        action.setParams({
            "Id": personId,
            "pageNumber": nextPage
        });
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                var result = response.getReturnValue();
                if(result.length != 0){
                    if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                        component.set('v.providerHeaderList', result.providerMessages);
                        component.set('v.providerHasNext', result.hasNext);
                        component.set('v.provCurrentPage', component.get('v.provCurrentPage')+1);
                    } else {
                        helper.fireToast(result.statusMessage, result.statusCode);
                    }
                } else{
                    helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
                }
            } else {
                helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
            }
            helper.handlerSpinner(component,event,false);
        });
        $A.enqueueAction(action);
    },
    handlePrevious : function(component,event,helper){
        helper.handlerSpinner(component,event,true);
        helper.sendBlankMemAffId(component,event);
        var nextPage = component.get('v.provCurrentPage') - 1;
        var personId = component.get('v.providerAffId');
        var action=component.get("c.getProviderMessages");
        action.setParams({
            "Id": personId,
            "pageNumber": nextPage
        });
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                var result = response.getReturnValue();
                if(result.length != 0){
                    if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                        component.set('v.providerHeaderList', result.providerMessages);
                        component.set('v.providerHasNext', result.hasNext);
                        component.set('v.provCurrentPage', component.get('v.provCurrentPage')-1);
                    } else {
                        helper.fireToast(result.statusMessage, result.statusCode);
                    }
                } else{
                    helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
                }
            } else {
                helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
            }
            helper.handlerSpinner(component,event,false);
        });
        $A.enqueueAction(action);
    },
    scrollIntoView : function(component,event,helper){
        var authName = component.get("v.scrollToAuthName");
        if(authName != undefined && authName != null && authName != ''){
            var element = document.getElementById(authName);
            element.scrollIntoView(true);
            component.set("v.scrollToAuthName",'');
        }
    },
})