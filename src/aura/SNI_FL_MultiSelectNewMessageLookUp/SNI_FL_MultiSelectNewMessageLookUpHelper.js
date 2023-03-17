({
    searchHelper : function(component,event,getInputkeyWord) {
         
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        var flg =  component.get("v.isFlg");
        var selectedRecord = component.get("v.evtSelectedRecords");
        var isFamilyLevel = component.get("v.isFamilyLevel");
        var familyId = component.get("v.familyId");
        var isFamilyLinkcondition = component.get("v.isFamilyLink");
        if(isFamilyLevel){
            selectedRecord = familyId;
        } 
        if(selectedRecord == null){
            return;
        }
        
        // set param to method  
        // if(component.get("v.evtSelectedRecords") && flg){
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        
        var backupAgntId;
        if(!isBackupAgentViewcondition)
            backupAgntId = component.get("v.selectedTabId");
        
        if(flg){
            action.setParams({
                'searchKeyWord': getInputkeyWord,
                'ObjectName' : component.get("v.objectAPIName"),
                'selectedRecordId' : (selectedRecord.value == undefined)?selectedRecord:selectedRecord.value
                
            });
            
            // set a callBack    
            action.setCallback(this, function(response) {
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    // if storeResponse size is equal 0 ,display No Records Found... message on screen. 
                    if (storeResponse.length == 0) {
                        component.set("v.Message", "No match found with... '" + getInputkeyWord + "'");
                    } else {
                        component.set("v.Message", '');
                        // set searchResult list with return value from server.
                    }
                    var qbNurse = 'Quarterback Registered Nurse';
                    var behavioralSpecialist = 'Behavioral Health Specialist';
                    var pharmacist = 'Pharmacist';
                    storeResponse.forEach(function(record){
                       if( typeof record.LastName !== 'undefined' && record.LastName != null){
                           
                            
                            if(typeof record.UserRole.Name !== 'undefined'){
                                if(record.UserRole.Name.includes('FEC'))
                                    record.Name = (typeof record.Name !== 'undefined' ? record.Name : ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? 
                                                   record.FirstName : '') +' '+ ((isFamilyLinkcondition == true)
                                                   ? record.LastName.substring(0,1)+
                                                   ' ( '+$A.get('$Label.c.FEC')+' )':record.LastName+ ' ( '+$A.get('$Label.c.FEC')+' )')); //$Label.c.FEC
                                else if(record.UserRole.Name.includes('Registered Nurse'))
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? record.FirstName : '') +' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1)+ ' ( '+$A.get('$Label.c.Registered_Nurse')+' )':record.LastName+ ' ( '+$A.get('$Label.c.Registered_Nurse')+' )');
                                else if(record.UserRole.Name.includes('Lifestyle and SDoH Coach'))
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? record.FirstName : '' )+' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1)+ ' ( '+$A.get('$Label.c.Regional_PDC')+' )':record.LastName+ ' ( '+$A.get('$Label.c.Regional_PDC')+' )');
                                else if(record.UserRole.Name.includes('Quarterback Registered Nurse'))
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? record.FirstName : '' )+' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1)+ ' ( '+qbNurse+' )':record.LastName+ ' ( '+qbNurse+' )');
                                else if(record.UserRole.Name.includes('Pharmacist'))
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? record.FirstName : '' )+' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1)+ ' ( '+pharmacist+' )':record.LastName+ ' ( '+pharmacist+' )');
                                else if(record.UserRole.Name.includes('Behavioral Health Specialist'))
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null) ? record.FirstName : '' )+' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1)+ ' ( '+behavioralSpecialist+' )':record.LastName+ ' ( '+behavioralSpecialist+' )');
                                else
                                   record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null ? record.FirstName : '')) +' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1):record.LastName);
                            }
                            else{
                              record.Name = ((typeof record.FirstName !== 'undefined' && record.FirstName != null ? record.FirstName : '')) +' '+ ((isFamilyLinkcondition == true)?record.LastName.substring(0,1):record.LastName);
                            }
                        }
                        else if (typeof record.SNI_FL_Member__c !== 'undefined') {
                            
                          record.Name = record.SNI_FL_Member__r.Name;
                          
                        } 
                        else if( typeof record.Partner__c !== 'undefined'){
                            
                            if(typeof record.Partner__r.UserRole !== 'undefined' ){
                                 
                                if(record.Partner__r.UserRole.Name.includes('FEC'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+$A.get('$Label.c.FEC')+' )':record.Partner__r.LastName+ ' ( '+$A.get('$Label.c.FEC')+' )'); //$Label.c.FEC
                                if(record.Partner__r.UserRole.Name.includes('Registered Nurse'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+$A.get('$Label.c.Registered_Nurse')+' )':record.Partner__r.LastName+ ' ( '+$A.get('$Label.c.Registered_Nurse')+' )');
                                if(record.Partner__r.UserRole.Name.includes('Lifestyle and SDoH Coach'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+$A.get('$Label.c.Regional_PDC')+' )':record.Partner__r.LastName+ ' ( '+$A.get('$Label.c.Regional_PDC')+' )');
                                if(record.Partner__r.UserRole.Name.includes('Behavioral Health Specialist'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+behavioralSpecialist+' )':record.Partner__r.LastName+ ' ( '+behavioralSpecialist+' )');
                                if(record.Partner__r.UserRole.Name.includes('Pharmacist'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+pharmacist+' )':record.Partner__r.LastName+ ' ( '+pharmacist+' )');
                                if(record.Partner__r.UserRole.Name.includes('Quarterback Registered Nurse'))
                                   record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1)+ ' ( '+qbNurse+' )':record.Partner__r.LastName+ ' ( '+qbNurse+' )');
                            }
                            else {  
                               record.Name = ((typeof record.Partner__r.FirstName !== 'undefined' && record.Partner__r.FirstName != null) ? record.Partner__r.FirstName : '' )+' '+((isFamilyLinkcondition == true)?record.Partner__r.LastName.substring(0,1):record.Partner__r.LastName);
                            }
                        }
                        
                    })
                    component.set("v.listOfSearchRecords", storeResponse);
                    var toolTipList = component.get("v.toolTipList");
                    var searchRecordsList = component.get("v.listOfSearchRecords");
                    var mapRoleToolTip = [];
                    for(var i =0; i<searchRecordsList.length;i++) {
                        var recordName = searchRecordsList[i].Name;
                        if(!$A.util.isUndefinedOrNull(recordName)) {
                            if(recordName.indexOf('(') >-1) {
                              var roleName = recordName.split('(')[1].replace(')','').trim();
                                if(toolTipList.length > 0){  
                                  for(var j=0; j< toolTipList.length; j++) {
                                      if(roleName == toolTipList[j].key) {
                                          mapRoleToolTip.push({key :recordName,value :toolTipList[j].value});
                                      } 
                                  } 
                                } else {
                                    mapRoleToolTip.push({key :recordName,value :''});
                                }
                            }else if(recordName.indexOf('(') == -1) {
                                mapRoleToolTip.push({key :recordName,value :''});
                            }
                        }             
                    }
                    console.log(mapRoleToolTip);
                    component.set("v.mapRoleNameToolTip",mapRoleToolTip);
                    component.set('v.showDropdown',true);
                    var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
                    cmpEvent.setParams({
                        showOnclickCurtain : true
                    });
                    cmpEvent.fire();
                }
            });
            // enqueue the Action  
            $A.enqueueAction(action);
        }  
    },
    
    loadFamilyOwner: function(component,event,helper){
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        
        var selectedTabId = component.get("v.selectedTabId");
        var action = component.get('c.fetchUserRecord');
        action.setParams({
            'selectedTabId' : selectedTabId
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                listSelectedItems.push(storeResponse[0]);
                
                component.set("v.lstSelectedRecords" , listSelectedItems); 
            } else {
                console.log('from bckp adv nw msg : ' + response.getState());
            }
        });
        $A.enqueueAction(action);
    },
    
    //Retrieves the Family Account agent informations and set the agent data 
    //defaulted in "To" dropdown familyLink
    //Author:Sameera ACDC
    getFamilyAgentDetails:function(component,event,helper){
        
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var accountID = component.get("v.evtSelectedRecords");
        var action = component.get('c.getFamilyAgentDetails');
        
        action.setParams({
            'AccountID' : accountID
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                storeResponse.forEach(function(record){
                    record.Name = record.FirstName+' '+record.LastName.substring(0,1);
                })     
                listSelectedItems.push(storeResponse[0]);
                
                component.set("v.lstSelectedRecords" , listSelectedItems);
                
            } else {
            }
        });
        
        $A.enqueueAction(action);
    },
    getToolTip : function(component,event,helper) {
        console.log(component.get("v.oRecord.Name}"));
		var action = component.get("c.mapOfToolTipRoles");
        action.setCallback(this, function(response) { 
           var state = response.getState(); 
           if(state == "SUCCESS"){
              var result = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(result)){
                    var toolTipList = [];
                    for (var key in result ) {
                      toolTipList.push({"key":key,"value":result[key]});
                   }
                   console.log(toolTipList);
                   component.set("v.toolTipList",toolTipList);
               }
           }
        });
       $A.enqueueAction(action);
	}
})