({
	loadSwivelData : function(component, event,topicName) {
		//var topic = component.get("v.attrCallTopic");
		//alert("====3====");
		var topic = topicName;
        var tabKey;
        var tabKeyParam;
        var params = event.getParam('arguments');
        if (params) {
            tabKeyParam = params.autodockey;
            // add your code here
        }
        if(tabKeyParam != undefined)
            tabKey = tabKeyParam;
        else
        	tabKey = component.get("v.AutodocKey");
        //alert(tabKey);
        // Get Swivel Topic List from DB
        var action = component.get("c.getSwivelTopicList");
        action.setParams({
            topic: topic
        });
        var state;
        action.setCallback(this,function(a){
            //alert("====4====");
            state = a.getState();
            if(state == "SUCCESS"){
                //

                var swt = a.getReturnValue();
                if(!$A.util.isEmpty(swt) && !$A.util.isUndefined(swt)){
                     
                    if(swt != null) {
                        
                        if(topic == "Consumer Accounts"){
                            
                            var accountTypes=[];

                            //var result = swt.find(t=>t.Account_Type__c);
                            for (var i in swt) {
                                //alert(JSON.stringify(swt[i].Account_Type__c))
                                var value = swt[i].Account_Type__c;
                                if($A.util.isEmpty(value)){
                                    
                                }else{
                                    
                                    //alert(JSON.stringify(swt[i].Account_Type__c))
                                    
                                    //Push value Account Type Value to list
                                    accountTypes.push(value);
                                    //Delete From existing position
                                    //delete swt[i];

                                }

                            }
                        
                            //Add "Other" Call Type value to end
                            //Filter Call Types
                            var callTypes =  swt.filter(function(callTypeValue) {
                                return callTypeValue.Call_Type__c != 'Other';
                            });
                            //Add 'Other' to end of call type list
                            callTypes.push({Call_Type__c:'Other'});
                            
                            //Filtered Account Types
                            var filtered = Array.from(new Set(accountTypes));

                              //Set filtered and sorted list of Account Types  
                              component.set("v.accList",filtered.sort());
                              component.set("v.callTypes",callTypes);
                              
                        }else{
                            component.set("v.callTypes",swt);
                        }

                    }


                    
                    
                    
                    setTimeout(function(){
                        window.lgtAutodoc.initAutodoc(tabKey);
                        component.set("v.spinner", "false");
                    },1);
                    
                   
                }
    
            } 
            else if(state == "ERROR"){
                //console.log("getSwivelTopicList Error");
            }
        });    
        $A.enqueueAction(action);
        //if(state=="SUCCESS"){
        //    setTimeout(function(){
                //alert('----1----');
                //window.lgtAutodoc.initAutodoc();
        //    },1);
       // }
	}
})