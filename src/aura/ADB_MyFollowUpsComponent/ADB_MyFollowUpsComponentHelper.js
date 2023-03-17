({
    getSelectWorkloadList : function(component,helper){
        component.set('v.renderSpinner',true);
       console.log('calling my followups select workload list');
       var logonId = component.get('v.logonId');
       //logonId = '';
       var officeId = component.get('v.officeId');
       // officeId = '673';
        console.log('agent Id'+logonId+'::officeId'+officeId);
        
        var action = component.get("c.getMyFollowupsWorkloadList");
        action.setParams({logonId : logonId, officeId:officeId }); 
            action.setCallback(this, function(response) {
                var state = response.getState();   
                component.set('v.renderSpinner',false);
                if (state === 'SUCCESS') {
                    var codeHover = [];
                    var result = response.getReturnValue();
                    var serviceErr = result['serviceError'];
                    console.log('service Err'+serviceErr);
                    if(serviceErr != '' && serviceErr != undefined){
						component.set('v.renderMyFollowupsError',true);
                            component.set('v.validationErr',serviceErr);
                    }else{
                        var noOpenFollowups = $A.get("$Label.c.ADB_NoOpenFollowups");
                        if(result != null){
                            var rs = result['followupsMap'];
                            if(rs!=null){
                                var commitmentCodeMap = result['commitmentCodeMap'];
                                console.log('commitmentCodeMap'+JSON.stringify(commitmentCodeMap));
                                console.log('response for my followups-->'+JSON.stringify(response.getReturnValue()));
                                var worklist = rs['workList'];
                                if(worklist.length>0){
                                    component.set('v.renderMyFollowupsError',false);
                                    console.log('woklist'+worklist);
                                    var followuplist = [];
                                    worklist.forEach(function(el){
                                        var followup = {};
                                        var sr = el['followUpOwner'];
                                        if(sr != null && sr['statusDescription'] == 'OPEN'){
                                            var duedtval = sr['nextActionDueDate'];
                                             if(duedtval!= null){
                                                var duedtArry = duedtval.split("-");
                                                var duedt = duedtArry[1]+"/"+duedtArry[2]+"/"+duedtArry[0];
                                                followup['dueDate'] = duedt;
                                              }
                                            followup['code'] = sr['purposeCode'];
                                            var commitCd = sr['purposeCode'];
                                            //var commitDesc = '';
                                            var commitDesc = commitmentCodeMap[commitCd];
                                           // codeHover.push(commitDesc);
                                            console.log('nextActionDueDate'+sr['nextActionDueDate']);
                                            var sro = el['serviceRequestOwner'];
                                            var requestNmber = sro['issueId'];
                                            if(requestNmber.length>0){
                                            followup['requestId'] = requestNmber;
                                            requestNmber = requestNmber.substring(requestNmber.length-4,requestNmber.length);
                                            followup['request'] = requestNmber;
                                            }
                                        
                                            followuplist.push(followup);
                                        }
                            });
                                    var sortedFollowups = this.sortList(component,followuplist,'dueDate');
                                    sortedFollowups.forEach(function(flwup){
                                        var commtCd = flwup['code'];
                                        var commitDsc = commitmentCodeMap[commtCd];
                                        codeHover.push(commitDsc);
                                    });
                                    if(!$A.util.isEmpty(sortedFollowups)){
                                        component.set("v.MyfollowUpsData",sortedFollowups);
                                        component.set("v.codeHoverList",codeHover);
                                    }else{
                                        component.set('v.renderMyFollowupsError',true);
                            			component.set('v.warningMsg',noOpenFollowups);
                                    }
                                }else{
                                    component.set('v.renderMyFollowupsError',true);
                            		component.set('v.warningMsg',noOpenFollowups);
                                }
                            }
                        }else{
                            component.set('v.renderMyFollowupsError',true);
                            component.set('v.warningMsg',noOpenFollowups);
                        }
                    }
                }
                
            });
         $A.enqueueAction(action);
        
    },
    
     sortList: function(component, records, field) {
        var sortAsc = true;
        records.sort(function(a,b){
            var t1 = new Date(a[field]) == new Date(b[field]),
                t2 = new Date(a[field]) > new Date(b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        return records;
    }
})