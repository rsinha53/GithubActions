({
    
    doInit : function(component, event, helper) {
        helper.setFocusedTabLabel(component, event, helper);
        helper.fetchAnswers(component, event, helper);
        var pickvar = component.get("c.getPickListValuesIntoList");
        pickvar.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var fsgId = component.get("v.fsgId");
                var list = response.getReturnValue();
                component.set("v.picklistValues", list);
                if(list.length > 0){
                                        
                    var fsgStatus = component.get("c.getFsgStatus");
                    fsgStatus.setParams({
                        "fsgId": fsgId
                    });
                    fsgStatus.setCallback(this, function(resStatus) {
                        var state1 = resStatus.getState();
                        if(state1 === 'SUCCESS'){
							
                            var fsgStat = resStatus.getReturnValue();
                            if( fsgStat &&  fsgStat != ''){
                                if(fsgStat == 'Completed'){
                                    
                                    component.set("v.dispNotes",false);
                                    component.set("v.curTopic",'Notes/Results');
                                   
									var actionAnswers = component.get("c.forNotesSection");
                                    actionAnswers.setParams({"fsgId":fsgId,"lstTopics":list});
                                    actionAnswers.setCallback(this, function(response) {
										
                                        var state = response.getState();
                                        if(state === 'SUCCESS'){
                                            var retVal = response.getReturnValue();
                                            if( retVal && retVal != ''  ){
                                                var optionsList = [];
                                                for (var key in retVal) {
                                                    if(retVal[key] == null || retVal[key] == '')
                                                        optionsList.push({key: key, value: null});
                                                    else
                                                        optionsList.push({key: key, value: retVal[key]});
                                                };
                                                component.set('v.notesAnswers', optionsList);
                                                component.set("v.selValue",'');  
                                                component.set("v.actValue",''); 
                                                component.set("v.curNotes",'');
                                                component.set("v.oldNotes",'');
                                                component.set("v.oldFsgid",'');
                                                
                                                for(var i=0; i<component.find("main").getElement().childNodes.length; i++){
                                                    if(component.find("main").getElement().childNodes[i].childNodes[0].id != 'Notes/Results'){
                                                        $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");    
                                                        $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0], "green");
                                                        $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[1], "hideText");
                                                    }
                                                    else{
                                                        $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0],"selectedRow");
                                                    }
                                                    
                                                    
                                     }
                                        $A.util.removeClass(component.find("completedText").getElement(), "hideText");
                                        
                                    }
                                }
                            });
                                 $A.enqueueAction(actionAnswers);
                                
                             }
                             else if(fsgStat == 'Partially Completed'){
                                
                                 var listAnswrs = component.get("v.listAnswrs");
                                 if(listAnswrs.length > 0){ 
                                     var lastTopic = listAnswrs[listAnswrs.length-1].Family_Story_Guide_Questionare__r.Topic__c;
                                     component.set("v.curTopic",lastTopic);
                                     component.set("v.lastTopic",lastTopic);
									 
                                     helper.getnextTopicQuestion(component, event,helper);
                                    
                                  }
                              }
                                  else{
                                      
                                      component.set("v.curTopic",list[0]);
                                      helper.findDefaultQuestion(component, event, helper);
                                      for(var i=0; i<component.find("main").getElement().childNodes.length; i++){
                                          if(component.find("main").getElement().childNodes[i].childNodes[0].id != list[0]){
                                              $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");    
                                          }
                                          else{
                                              $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0],"selectedRow");
                                          }
                                          
                                      } 
                                  }
                             
                         }
                      }
                    });
                    $A.enqueueAction(fsgStatus);
                    
                    
                }
                
            }
            else if(state === 'ERROR'){
                console.log("Error");
            }
        })
        $A.enqueueAction(pickvar);
        
    },
    showQuestions : function(component, event, helper) {
      
        $A.util.addClass(component.find("completedText").getElement(), "hideText");
        var action = component.get("c.getTopicQuestions");
        var topicName = event.target.id;
        
        
        for(var i=0; i<component.find("main").getElement().childNodes.length; i++){
            $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");
        }
        var targetElement = event.target;
        $A.util.addClass(targetElement,"selectedRow");
        
        
        if(topicName == 'Notes/Results'){
           
            var fsgId = component.get("v.fsgId");
            var fsgStatus = component.get("c.getFsgStatus");
            fsgStatus.setParams({
                "fsgId": fsgId
            });
            fsgStatus.setCallback(this, function(resStatus) {
                var state1 = resStatus.getState();
                if(state1 === 'SUCCESS'){
                    var fsgStat = resStatus.getReturnValue();
                    
                    if( fsgStat &&  fsgStat != ''){
                        if(fsgStat == 'Completed' || fsgStat == 'Partially Completed'){
                           
                            $A.util.removeClass(component.find("completedText").getElement(), "hideText");
                        }
                    }
                }
            });
            $A.enqueueAction(fsgStatus);                 
            component.set("v.dispNotes",false);
            var list = component.get("v.picklistValues");
			
            var actionAnswers = component.get("c.forNotesSection");
            actionAnswers.setParams({"fsgId":fsgId,"lstTopics":list});
            actionAnswers.setCallback(this, function(response) {
				
                var state = response.getState();
                
                if(state === 'SUCCESS'){
					
                    var retVal = response.getReturnValue();
                    if( retVal && retVal != ''  ){
                      
                        var optionsList = [];
                        for (var key in retVal) {
                           if(retVal[key] == null || retVal[key] == '')
                                optionsList.push({key: key, value: null});
                            else
                                optionsList.push({key: key, value: retVal[key]});
                           
                        };
                        component.set('v.notesAnswers', optionsList);
                        component.set("v.selValue",'');  
                        component.set("v.actValue",''); 
                        component.set("v.curNotes",'');
                        component.set("v.oldNotes",'');
                        component.set("v.oldFsgid",'');
                        
                    }
                }
            });
            $A.enqueueAction(actionAnswers);
            
            
        }else{
			
            component.set("v.dispNotes",true);
            component.set("v.curTopic",topicName);
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
                        var listAnswrs = component.get("v.listAnswrs");
						var matchedVals = '' ; 
						var matchnotes ;
						var isQa31 = false;
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
        }
    },
    next : function(component, event,helper){
        $A.util.addClass(component.find("completedText").getElement(), "hideText");
       
        helper.saveCurrentAnswers(component, event,helper);
        var sObjectList = component.get("v.TopicQuestions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var totalRecs = component.get("v.totalRecords");
        var qNumber  = component.get("v.questioNumber");
		
        var qJumpsec = false;
        var qJumpnxtQs = false;
        if(qNumber == '1.3' || qNumber == '6.2' || qNumber == '6.1'){
             var curSelVal = component.get("v.selValue");
			
             var curPagLst = component.get("v.PaginationList");
             if(curPagLst.length>0){
                 for(var key in curPagLst[0].answerOptions){
                    var curVal = curPagLst[0].answerOptions[key];
					
                    if(key.indexOf(' ') > -1){
                        var ckey = key.split(' ')[1];
						
                        if(curVal == curSelVal && ( ckey == 'No' || ckey == 'N/A')){
						
                            if(qNumber == '1.3' || qNumber == '6.2')
                              qJumpsec = true;
                            if(qNumber == '6.1'){
                               qJumpnxtQs = true;
							   component.set("v.prevQuestion",'jump');
							}
                        }
					    if(qNumber == '6.1' && ckey == 'Yes') {
						   component.set("v.prevQuestion",'');
						}
                    }
                }
             }
        }
		
        if(end >= totalRecs-1 || qJumpsec){
        
            var cutTopic = component.get("v.curTopic");
            component.set("v.lastTopic",cutTopic);
        
            var pickVals = component.get("v.picklistValues");
            if(pickVals.length >0){
        
                for(var m=0; m<pickVals.length;m++){
                    if(cutTopic == pickVals[m]){
                        component.set("v.curTopic",pickVals[m+1]);
                        if( m < pickVals.length-2){
                            helper.getnextTopicQuestion(component, event,helper);
                        }
                        else if( m == pickVals.length-2){ 
                            
                            for(var i=0; i<component.find("main").getElement().childNodes.length; i++){
                                if(component.find("main").getElement().childNodes[i].childNodes[0].id != 'Notes/Results'){
                                    $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[0], "selectedRow");    
                                    if(component.find("main").getElement().childNodes[i].childNodes[0].id == cutTopic){
                                        $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0],"green");
                                        $A.util.removeClass(component.find("main").getElement().childNodes[i].childNodes[1], "hideText");
                                    }
                                }
                                else{
                                    $A.util.addClass(component.find("main").getElement().childNodes[i].childNodes[0],"selectedRow");
                                }
                            }
                            
                            var fsgId = component.get("v.fsgId");
                            var fsgStatus = component.get("c.getFsgStatus");
                            fsgStatus.setParams({
                                "fsgId": fsgId
                            });
                            fsgStatus.setCallback(this, function(resStatus) {
                                var state1 = resStatus.getState();
                                if(state1 === 'SUCCESS'){
                                    var fsgStat = resStatus.getReturnValue();
                                    if( fsgStat &&  fsgStat != ''){
                                        if(fsgStat == 'Completed' || fsgStat == 'Partially Completed'){
                                            $A.util.removeClass(component.find("completedText").getElement(), "hideText");
                                        }
                                    }
                                }
                            });
                            $A.enqueueAction(fsgStatus);
                            
                            component.set("v.dispNotes",false);
                            var list = component.get("v.picklistValues");
                            
                            
                            var actionAnswers = component.get("c.forNotesSection");
                            actionAnswers.setParams({"fsgId":fsgId,"lstTopics":list});
                            actionAnswers.setCallback(this, function(response) {
                            
                                var state = response.getState();
                                if(state === 'SUCCESS'){
                                    var retVal = response.getReturnValue();
                                    if( retVal && retVal != ''  ){
                                        
                                        var optionsList = [];
                                        for (var key in retVal) {
                                            
                                            if(retVal[key] == null || retVal[key] == '')
                                                optionsList.push({key: key, value: null});
                                            else
                                                optionsList.push({key: key, value: retVal[key]});
                                            
                                            
                                        };
                                        component.set('v.notesAnswers', optionsList);
                                        
                                        component.set("v.selValue",'');  
                                        component.set("v.actValue",''); 
                                        component.set("v.curNotes",'');
                                        component.set("v.oldNotes",'');
                                        component.set("v.oldFsgid",'');
                                        
                                    }
                                }
                            });
                            $A.enqueueAction(actionAnswers);
                        }
                    }
                    
                }
            }
        }
        else{
            var PaginationList = [];
            var counter = 0;
          
            for(var i=end+1; i<end+pageSize+1; i++){
                if(sObjectList.length > i){
			
					if(qJumpnxtQs){
                       PaginationList.push(sObjectList[i+1]);
                   }
				   else{
                    PaginationList.push(sObjectList[i]);
				   }
                }
                counter ++ ;
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
                                    optionmatched = true;
                                    
                                }
                            }
                        } 
                        
                    }
                    
                    if(!optionmatched ){
                    
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
            if(qJumpnxtQs){
				start = start + counter + 1;
                end = end + counter + 1;
			}else{
                start = start + counter;
				end = end + counter;
			}
            component.set("v.startPage",start);
            component.set("v.endPage",end);
            
            component.set('v.PaginationList', PaginationList);
            
        }
    },
    
    previous : function(component, event,helper){
        helper.saveCurrentAnswers(component, event,helper);
	
		    var qJumpsec = false;
			if(component.get("v.questioNumber") == '6.2' && component.get("v.prevQuestion") == 'jump'){
				qJumpsec = true;
			}
	
        var sObjectList = component.get("v.TopicQuestions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PaginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
				if(qJumpsec && i-1 > -1){
                   PaginationList.push(sObjectList[i-1]);
				   counter ++;
                }else{
					PaginationList.push(sObjectList[i]);
				}
                counter ++;
            }else{
                start++;
            }
        }
        var answerList = [];
        var orderedAnswerList = [];
        var listAnswrs = component.get("v.listAnswrs");
		
        if(PaginationList.length>0){
            var curQstn = PaginationList[0].Question;
            var optionmatched = false;
			component.set("v.questioNumber",PaginationList[0].QuestionNumber);
		
            for(var key in PaginationList[0].answerOptions){
                answerList.push({
                    'label' : key,
                    'value': PaginationList[0].answerOptions[key]
                });
             
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
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
      
        component.set('v.PaginationList', PaginationList);
        
    },
    changeOption : function(component, event){
        
         if( component.get("v.shwChk")){
            var changeValue = event.getParam("value");
        
            if(changeValue != ''){
                component.set("v.disableNext",false);
                var curPagLst = component.get("v.PaginationList");
                var nonesel = '';
                var match = false;
        
                for(var key in curPagLst[0].answerOptions){
                  
                    if(! match ){
                        if(changeValue.indexOf(curPagLst[0].answerOptions[key]) > -1 &&  key.trim() == 'H) N/A'){
                            nonesel = curPagLst[0].answerOptions[key];
                            match = true;
                        }
                        else if(changeValue.indexOf(curPagLst[0].answerOptions[key]) > -1 && key.trim() == 'I) None of the above' ){
                             nonesel = curPagLst[0].answerOptions[key];
                             match = true;
                        }
                         
                    }
                }
                if(nonesel != '')
                  component.set("v.selValue",nonesel);  
            }else{
                 component.set("v.disableNext",true);
            }
        }
        else{
            component.set("v.disableNext",false);
        }
       
    }
})