({
	fetchAnswers : function(component, event, helper) {
        
        var action = component.get("c.getSavedAnswers");
        var fsgId = component.get("v.fsgId");
        action.setParams({
                "fsgId": fsgId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response){
                    var retVal = response.getReturnValue();
                    if(retVal != ''){
                        
                       component.set("v.listAnswrs",retVal);
                        if(retVal.length > 0){
                          
                            var actInterven = component.get("c.getSavedInterventions");
                          
                            actInterven.setParams({
                                "fsgId": fsgId
                            });
                            actInterven.setCallback(this, function(resp) {
                            var stat = resp.getState();
                            if(stat === 'SUCCESS'){
                                if(resp){
                                    var intervenRet = resp.getReturnValue();
                                    var setInterven = [];
                                    if(intervenRet.length > 0){
                                        for(var k=0;k<intervenRet.length;k++){
                                            
                                           setInterven.push(intervenRet[k]);
                                          
                                        }
                                    }
                                    var interventionsSet = new Set();
                                    for(var inter in setInterven){
                                        var uniqueInter = setInterven[inter].split("•");
                                        for(var interSplit in uniqueInter){
                                            if(uniqueInter[interSplit] != "")
                                            interventionsSet.add(uniqueInter[interSplit].trim());
                                        }
                                    }
                                    let interventionsArray = Array.from(interventionsSet);
                                    component.set("v.inteventions",interventionsArray);
                                }
                            }
                            });
                            $A.enqueueAction(actInterven);
                        }
                      
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    findDefaultQuestion : function(component, event, helper) {
		var action = component.get("c.getDefaultTopicQuestions");
        var pageSize = component.get("v.pageSize");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var pageSize = component.get("v.pageSize");
                component.set("v.TopicQuestions",response.getReturnValue());
                component.set("v.totalRecords", component.get("v.TopicQuestions").length);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.TopicQuestions").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PaginationList);
                var answerList = [];
                var orderedAnswerList = [];
                var listAnswrs = component.get("v.listAnswrs");
                if(PaginationList.length>0){
                    var curQstn = PaginationList[0].Question;
                    var optionmatched = false;
                    for(var key in PaginationList[0].answerOptions){
                         answerList.push({
                            'label' : key,
                            'value': PaginationList[0].answerOptions[key]
                        });
                        component.set("v.questioNumber",PaginationList[0].QuestionNumber);
						
                        if(PaginationList[0].QuestionNumber == '3.1'){
                            component.set('v.shwChk',true);    
                        }
                        else{
                          component.set('v.shwChk',false);    
                        }
                        if(! optionmatched){
                         for(var k=0;k<listAnswrs.length>0;k++){
                           
                           if( PaginationList[0].answerOptions[key] == listAnswrs[k].Family_Story_Guide_Questionare__c){
                                 
                                 component.set("v.selValue",PaginationList[0].answerOptions[key]);  
                                component.set("v.actValue",PaginationList[0].answerOptions[key]); 
                               component.set("v.curNotes",listAnswrs[k].Notes__c); 
                               component.set("v.oldNotes",listAnswrs[k].Notes__c); 
                               
                             
                                component.set("v.oldFsgid",listAnswrs[k].Name);
                                component.set("v.disableNext",false);
                                 optionmatched = true;
                             }
                         }
                        } 
                        
                    }
					answerList = answerList.sort(function (a, b){
                      return   (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0)
                    });
                    //answerList.sort((a,b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
                    for(var key in answerList){
                      
                        var orderedAnswerListVar = answerList[key].label.split(')');
                      
                        orderedAnswerList.push({
                            'label' : orderedAnswerListVar[1],
                            'value': answerList[key].value
                        });
                    }
                    component.set("v.answerList",orderedAnswerList);
                }
            }
            else if(state === 'ERROR'){
                console.log("Error");
            }
        })
        $A.enqueueAction(action);
	},
    saveCurrentAnswers : function(component, event,helper) {
        
      var curVal = component.get("v.selValue");
      if(curVal != ''){
        var oldVal = component.get("v.actValue");
        var curNotes = component.get("v.curNotes");
        var oldNotes = component.get("v.oldNotes");
        var curSelVal = '';
       
        if(component.get("v.questioNumber") == '3.1'){
           
            if(curVal.length > 0){
                if(curVal.length == 18){
                    curSelVal = curVal;
                }
                else{
                   
                    if(curVal.indexOf(',') > -1){
                        var curValSplt = curVal.split(',');
                        for(var i=0; i< curValSplt.length; i++){
							  if(curSelVal == ''){
                                  curSelVal = curValSplt[i];
                               }
                               else{
                                   curSelVal = curSelVal+';'+curValSplt[i]; 
                               }                            
                        }
                    }else{
                         for(var i=0; i< curVal.length; i++){
                               if(curSelVal == ''){
                                   curSelVal = curVal[i];
                               }
                               else{
                                   curSelVal = curSelVal+';'+curVal[i]; 
                               }
                           }
                    }
                    
                }
                
            }
        }else{
            curSelVal = curVal;
        }
          
      
        if(curSelVal !=  oldVal || curNotes != oldNotes || component.get("v.questioNumber") == '3.1'){
            var action = component.get("c.saveDeleteAnswers");
            var fsgId = component.get("v.fsgId");
            
               action.setParams({
                   "fsgId": fsgId,
                   "newQsRecId": curSelVal,
                   "oldAnswId": component.get("v.oldFsgid"),
                   "curNotes" : curNotes,
                   "qNum" : component.get("v.questioNumber")
               });
               action.setCallback(this, function(response) {
                    var state = response.getState();
                 
                    if(state === 'SUCCESS'){
                 
                        helper.fetchAnswers(component, event, helper);
                 
                    }
               })
           $A.enqueueAction(action);
        }
        }
    },
    getnextTopicQuestion : function(component, event, helper) {
        
		var action = component.get("c.getTopicQuestions");
        var topicName = component.get("v.curTopic");
       
		var fsgId = component.get("v.fsgId");
        var sectCompltd = component.get("c.getCompletedData");
                     sectCompltd.setParams({
                        "fsgId": fsgId
                     });
					 
		sectCompltd.setCallback(this, function(resSecCompltd) {
		
			if(resSecCompltd.getState() === 'SUCCESS'){
				var sectsCmpltd = resSecCompltd.getReturnValue();
				
					for(var i=0; i<component.find("main").getElement().childNodes.length; i++){
						if(component.find("main").getElement().childNodes[i].childNodes[0].id != topicName){
							$A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");    
						}
						else{
							$A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0],"selectedRow");
					    }
					    if(sectsCmpltd.indexOf(component.find("main").getElement().childNodes[i].childNodes[0].id) != -1){
							$A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");    
                            $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0], "green");
						    $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[1], "hideText");
                        }
					}
			}
		});	 
	   $A.enqueueAction(sectCompltd);
       
        var pageSize = component.get("v.pageSize");
        action.setParams({"TopicName":topicName});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                
                var pageSize = component.get("v.pageSize");
                component.set("v.TopicQuestions",response.getReturnValue());
                component.set("v.totalRecords", component.get("v.TopicQuestions").length);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.TopicQuestions").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                var comp = document.getElementById(topicName);
               
                $A.util.addClass(comp, 'fsg-border-line');
                component.set('v.PaginationList', PaginationList);
                var answerList = [];
                var orderedAnswerList = [];
             
                if(PaginationList.length>0){
                    var optionmatched = false;
					var matchedVals = '' ; 
					var matchnotes ;
					var isQa31 = false;
                    var listAnswrs = component.get("v.listAnswrs");
					 component.set("v.questioNumber",PaginationList[0].QuestionNumber);
					
                    for(var key in PaginationList[0].answerOptions){
                         answerList.push({
                            'label' : key,
                            'value': PaginationList[0].answerOptions[key]
                        });
                       
                       
						if(PaginationList[0].QuestionNumber == '3.1'){
							isQa31 = true;	
							component.set('v.shwChk',true);    
							for(var k=0;k<listAnswrs.length>0;k++){
								if( PaginationList[0].answerOptions[key] == listAnswrs[k].Family_Story_Guide_Questionare__c){
								
									if(matchedVals == ''){
									  matchedVals = PaginationList[0].answerOptions[key];
									}
									else{
										matchedVals = matchedVals+','+PaginationList[0].answerOptions[key];
									}
									matchnotes = listAnswrs[k].Notes__c;
									optionmatched = true;
								}
							}
						}
                        else {
							component.set('v.shwChk',false);    
							if(! optionmatched){
							 for(var k=0;k<listAnswrs.length>0;k++){
								if( PaginationList[0].answerOptions[key] == listAnswrs[k].Family_Story_Guide_Questionare__c){
									
									 component.set("v.selValue",PaginationList[0].answerOptions[key]);  
									 component.set("v.actValue",PaginationList[0].answerOptions[key]); 
									 component.set("v.curNotes",listAnswrs[k].Notes__c);
									 component.set("v.oldNotes",listAnswrs[k].Notes__c); 
									 component.set("v.oldFsgid",listAnswrs[k].Name);
									 optionmatched = true;
								 }
							 }
							}
					    } 						
                    }
					if(optionmatched && isQa31){
						
							
						    component.set("v.selValue",matchedVals);  
							component.set("v.actValue",matchedVals); 
							component.set("v.curNotes",matchnotes); 
							component.set("v.oldNotes",matchnotes); 
							component.set("v.oldFsgid",null);
							
									
					}
                    if(!optionmatched){
                        component.set("v.selValue",'');  
                        component.set("v.actValue",''); 
                        component.set("v.curNotes",'');
                        component.set("v.oldNotes",'');
                        component.set("v.oldFsgid",'');
                        component.set("v.disableNext",true);
                     }
                    else{
                        component.set("v.disableNext",false);
                    }
                }
                 
				answerList = answerList.sort(function (a, b){
                    return   (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0)
                });
                //answerList.sort((a,b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
                for(var key in answerList){
                   
                    var orderedAnswerListVar = answerList[key].label.split(')');
                   
                    orderedAnswerList.push({
                        'label' : orderedAnswerListVar[1],
                        'value': answerList[key].value
                    });
                }
                component.set("v.answerList",orderedAnswerList);
                
            }
            else if(state === 'ERROR'){
                console.log("Error");
            }
        })
        $A.enqueueAction(action);
    },
    setFocusedTabLabel : function(component, event, helper) {
        
       var interval = window.setTimeout(            
       $A.getCallback(function() {  
         
		var workspaceAPI = component.find("curworkspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Family Story Guide"
            });
           
            workspaceAPI.setTabIcon({
            tabId: focusedTabId,
            icon: "standard:account", 
            iconAlt: "Family Story Guide"
        });
           
        })
        .catch(function(error) {
            console.log(error);
        });
        }), 100
        );  
    }
    
})