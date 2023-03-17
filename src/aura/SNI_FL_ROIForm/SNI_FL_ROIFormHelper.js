({
	createUser : function(component, memberCtmId) {
        var isUserExist=component.get("v.isUserExist");
        console.log('isUserExist='+isUserExist);
        if(!isUserExist){
        var createUserAction = component.get('c.createComUser');
        console.log('memberCtmId='+memberCtmId);
        createUserAction.setParams({
            "memberCtmId" : memberCtmId
        });
        createUserAction.setCallback(this, function(response) {
            //Code is not coming inside this as future method is invloved when user gets created
            var state = response.getState();
            console.log('createUserAction----state---'+state);
            
            //this.refreshCareTeam(component, event, helper);
            if (state == "SUCCESS") {
               component.set("v.isInvited",false);//on success we have to make isinvited false
            }
         });
        $A.enqueueAction(createUserAction); 
        }
	},
    fetchRecords : function(component, event, helper) {
        //debugger;
        //console.log('inside fetchRecords');
        var street='';
        var city='';
        var state='';
        var postalCode='';
        var country='';
        var peraddress = component.get('v.careTeamMemAdd');
        var comma=',';
        if(peraddress != undefined && peraddress != ''){
            peraddress = JSON.parse(peraddress);
            if(peraddress.street!=undefined){ street=peraddress.street; }
            if(peraddress.city!=undefined){ city=peraddress.city; }
            if(peraddress.state!=undefined){ state=peraddress.state; }
            if(peraddress.postalCode!=undefined){ postalCode=peraddress.postalCode; }
             if(peraddress.country!=undefined){ country=peraddress.country; }
            if(peraddress.state==undefined && peraddress.postalCode==undefined ){comma='';}
            component.set("v.careTeamMemAdd",street+' '+city+comma+' '+state+' '+postalCode+' '+country);
            //console.log("careTeamMemAdd"+component.get("v.careTeamMemAdd"));
        }
        
        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        component.set('v.today', today);
        var isInvited= component.get("v.isInvited");
        console.log('isInvited='+isInvited);
        
        var action1 = component.get('c.getSignROIMembers');
        var selectFamId= component.get("v.familyId");
        var recId; 
        var roiId= component.get("v.recordId");
        var ctmrecId = component.get("v.careTeamId");
        console.log('authopen---'+component.get("v.isViewAuth"));
        if(component.get("v.isViewAuth")){
            var isCTM;
            if(component.get("v.careTeamId") != undefined && component.get("v.careTeamId") != ''){
                isCTM = true;
                component.set("v.viewRecId",ctmrecId);
                component.set("v.isCTM",true);
                recId = ctmrecId;
            }
            else{
                isCTM = false; 
                component.set("v.viewRecId",roiId);
                component.set("v.isCTM",false);
                recId = roiId;
            }
            
            var actionView = component.get("c.ROImembers");
            actionView.setParams({
                "roiRecId" : recId,
                "isCTM" : isCTM
            });
            actionView.setCallback(this, function(response) {
                var state = response.getState();
                console.log('----state---'+state);
                if (state == "SUCCESS") {
                    
                    var responeWrapper = response.getReturnValue();
                    
                    if(responeWrapper != null &&  responeWrapper!=undefined){
                        //console.log(responeWrapper+JSON.Stringify(responeWrapper));
                        component.set("v.viewROIwrapp",responeWrapper);
                    }
                }
            });
            $A.enqueueAction(actionView);
        }else{
                        
            var memberCtmId = component.get("v.careTeamId");
            /*if(!isInvited){
	    var memberCtmName = component.get("v.careTeamMemberName");
	    console.log('Original memberCtmId='+memberCtmId+ ' '+memberCtmName)
	    component.set("v.displayCareTeamId",memberCtmId);
	    component.set("v.displayCTMName",memberCtmName);
	}*/
            var ctmIdList = [];
            ctmIdList.push(memberCtmId);
            //console.log('ctmIdList '+ctmIdList);
            //console.log('selectFamId '+selectFamId);
            //console.log('isInvited '+isInvited);
            action1.setParams({
                "ctmIdList" : ctmIdList,
                "famId" : selectFamId,
                "initCall": false,
                "isInvited": isInvited
            });
            action1.setCallback(this, function(response) {
                var state = response.getState();
                console.log('getLoginUserName----state---'+state);
                if (state == "SUCCESS") {
                    //console.log('getLoginUserName----username---'+response.getReturnValue());
                    
                    var responeWrapper = response.getReturnValue();
                    console.log('responeWrapper='+responeWrapper);
                    if(responeWrapper != null && responeWrapper.length>0){
                        console.log('isROIdone='+responeWrapper[0].isROIdone);
                        component.set("v.FLAccOwnerList",responeWrapper[0].FLAccOwnerList);
                        if(responeWrapper[0].isROIdone =='Completed'){
                            component.set("v.isSignAuth",false);
                            this.refreshCareTeam(component, event, helper);
                            if(isInvited){
                                //logic comes here for user creation 
                                component.set("v.isInvited",false);
                                this.createUser(component, memberCtmId);
                            } 
                        }
                        else{  
                            console.log('isInvited111='+isInvited);
                            if(isInvited){
                                var ctmPendingList=responeWrapper[0].ctmPendingList;
                                console.log('ctmPendingList')
                                console.log(ctmPendingList);
                                if(ctmPendingList && ctmPendingList.length>0){
                                    console.log('coming here 111');
                                    var ctmPen=[];
                                    var ctmAll=[];
                                    ctmPen.push(ctmPendingList);
                                    component.set('v.ctmPendingList',ctmPen);
                                    
                                    var ctmAllList=responeWrapper[0].ctmAllList;
                                    ctmAll.push(ctmAllList);
                                    component.set('v.ctmInviteAllList',ctmAll);
                                    var ctmFinalList = [];
                                    if(ctmAllList && ctmAllList.length>0){
                                        for(var i = 0; i < ctmAllList.length; i++) {
                                            if(ctmAllList[i].Id!=ctmPendingList[0].Id)
                                                ctmFinalList.push(ctmAllList[i]);
                                        }
                                    }
                                    
                                    component.set('v.careTeamList', ctmFinalList);
                                    var today = new Date();
                                    console.log('This Year='+today.getFullYear());
                                    var dob=ctmPendingList[0].SNI_FL_Member__r.PersonBirthdate;
                                    console.log('dob='+dob);
                                    var age=0;
                                    if(dob){
                                        var action2 = component.get('c.getAge');
                                        action2.setParams({
                                            "dob" : dob
                                        });
                                        action2.setCallback(this, function(response) {
                                            var state = response.getState();
                                            console.log('getAge----state---'+state);
                                            if (state == "SUCCESS") {
                                                age = response.getReturnValue();
                                                console.log('age-'+age);
                                                if(age<13){
                                                    component.set('v.child', ctmPendingList[0].SNI_FL_Member__r.Name.toUpperCase());
                                                    component.set('v.childName', ctmPendingList[0].SNI_FL_Member__r.Name.toUpperCase()+'\''+'s');
                                                    var flName=component.get("v.flAccOwnerMemName");
                                                    var flCtmId=component.get("v.isFLAccOwnerCareTeamId");
                                                    console.log('flName='+flName);
                                                    console.log('flCtmId='+flCtmId);
                                                    component.set("v.displayCareTeamId",flCtmId);
                                                    component.set("v.displayCTMName",flName.toUpperCase());
                                                    component.set("v.childCTMId",ctmPendingList[0].Id);
                                                    component.set("v.careTeamperMemAdd",FLAccOwnerList[0].SNI_FL_Family__r.Member_ID__c);
                                                    component.set("v.birthdate",FLAccOwnerList[0].SNI_FL_Member__r.PersonBirthdate);
                                   					helper.parseMailAddress(component,FLAccOwnerList[0].SNI_FL_Member__r.PersonMailingAddress) ;
                                                }
                                                else{
                                                    component.set('v.child', "I");
                                                    component.set('v.childName', "my");
                                                    component.set("v.childCTMId","");
                                                    console.log('displayCTMName' +ctmPendingList[0].SNI_FL_Member__r.Name.toUpperCase());
                                                    component.set("v.displayCareTeamId",ctmPendingList[0].Id);
                                                    console.log('displayCareTeamId'+component.get("v.displayCareTeamId"));
                                                    component.set('v.displayCTMName', ctmPendingList[0].SNI_FL_Member__r.Name.toUpperCase());  
                                                    helper.parseMailAddress(component,ctmPendingList[0].SNI_FL_Member__r.PersonMailingAddress) ; 
                                                    component.set("v.careTeamperMemAdd",ctmPendingList[0].SNI_FL_Family__r.Member_ID__c);
                                                    component.set("v.birthdate",ctmPendingList[0].SNI_FL_Member__r.PersonBirthdate);
                                                }
                                            }
                                        });
                                        $A.enqueueAction(action2);
                                    }
                                    
                                }
                                else{
                                    component.set("v.isSignAuth",false);
                                    this.createUser(component, memberCtmId);
                                }
                            }
                            else{
                                var isChild=responeWrapper[0].isChild;
                                console.log('is Under 13 Child='+isChild);
                                component.set('v.careTeamList', responeWrapper[0].ctmAllList);
                                var memberCtmName = component.get("v.careTeamMemberName");
                                console.log('Original memberCtmId='+memberCtmId+ ' '+memberCtmName);
                                if(isChild){
                                    component.set('v.child', memberCtmName.toUpperCase());     
                                    component.set('v.childName', memberCtmName.toUpperCase()+'\''+'s');
                                    component.set("v.displayCareTeamId",memberCtmId);
                                    var flName=component.get("v.flAccOwnerMemName");
                                    var flCtmId=component.get("v.isFLAccOwnerCareTeamId");
                                    component.set("v.displayCTMName",flName.toUpperCase());
                                    component.set("v.displayCareTeamId",flCtmId);
                                    component.set("v.childCTMId",memberCtmId);
                                    component.set("v.careTeamperMemAdd",FLAccOwnerList[0].SNI_FL_Family__r.Member_ID__c);
                                    component.set("v.birthdate",FLAccOwnerList[0].SNI_FL_Member__r.PersonBirthdate);
                                    helper.parseMailAddress(component,FLAccOwnerList[0].SNI_FL_Member__r.PersonMailingAddress) ;
                                }
                                else{
                                    component.set("v.displayCareTeamId",memberCtmId);
                                    component.set("v.displayCTMName",memberCtmName.toUpperCase());
                                    helper.parseMailAddress(component,ctmPendingList[0].SNI_FL_Member__r.PersonMailingAddress) ; 
                                    component.set("v.careTeamperMemAdd",ctmPendingList[0].SNI_FL_Family__r.Member_ID__c);
                                    component.set("v.birthdate",ctmPendingList[0].SNI_FL_Member__r.PersonBirthdate);
                                }
                            }
                            
                            
                        }
                        
                    }
                }
            });
            $A.enqueueAction(action1);  
        }
    },
    reFetch : function(component, event, helper) {
        //debugger;
        component.set("v.disableSignButton",true);
        var fullNamCmp = component.find('signButton');
        var mNameComp = component.find('msignButton');
        $A.util.removeClass(fullNamCmp, 'BgColorEnable');
        $A.util.addClass(fullNamCmp, 'BgColor');
        $A.util.removeClass(mNameComp, 'BgColorEnable');
        $A.util.addClass(mNameComp, 'BgColor');
        var memberCtmId = component.get("v.careTeamId");
        var ctmDoneList = component.get("v.ctmDoneList");
	var ctmPendingList= component.get("v.ctmPendingList");
        var ctmInviteAllList= component.get("v.ctmInviteAllList");
        var careTeamList=component.get("v.careTeamList");
        var FLAccOwnerList = component.get("v.FLAccOwnerList");
	var check;
        console.log('ctmDoneList---');
        console.log(ctmDoneList);
        console.log('ctmPendingList=');
        console.log(ctmPendingList);
        if(ctmDoneList!=null && ctmDoneList.length>0) {
           
          var ctmDoneArray=[];
            for(var k=0;k<ctmDoneList.length;k++){
                ctmDoneArray.push(ctmDoneList[k]);
            }
		  console.log('ctmDoneArray---');
          console.log(ctmDoneArray);
          if(ctmDoneArray!=null && ctmDoneArray.length>0){
            if(ctmPendingList != null && ctmPendingList.length>0){
              var ctmPendingArray=ctmPendingList[0];
              console.log('ctmPendingArray---');
              console.log(ctmPendingArray);
              if(ctmPendingArray != null && ctmPendingArray.length>0){
               for(var j=0; j<ctmPendingArray.length; j++){
                 var ctm=ctmPendingArray[j];
				 if(!ctmDoneArray.includes(ctm.Id)){
					  check=true;
					  console.log('coming here');
                      var ctmFinalList = [];
                      if(ctmInviteAllList && ctmInviteAllList.length>0){
                         var ctmInviteArray=ctmInviteAllList[0];
                          if(ctmInviteArray!=null && ctmInviteArray.length>0){
                              for(var i = 0; i < ctmInviteArray.length; i++) {
                                 if(ctmInviteArray[i].Id!=ctm.Id)
                                   ctmFinalList.push(ctmInviteArray[i]);
                              }   
                          }
                      }
                      component.set('v.careTeamList', ctmFinalList);
                      var today = new Date();
                      console.log('This Year='+today.getFullYear());
                      var dob=ctm.SNI_FL_Member__r.PersonBirthdate;
                      console.log('dob='+dob);
                      var age=0;
                      if(dob){
                          var action2 = component.get('c.getAge');
                           action2.setParams({
                               "dob" : dob
                           });
                           action2.setCallback(this, function(response) {
                           var state = response.getState();
                           console.log('getAge----state---'+state);
                           if (state == "SUCCESS") {
                              age = response.getReturnValue();
                              console.log('age='+age);
                              if(age<13){
                                   component.set('v.child', ctm.SNI_FL_Member__r.Name.toUpperCase());
                                   component.set('v.childName', ctm.SNI_FL_Member__r.Name.toUpperCase()+'\''+'s');
                                   var flName=component.get("v.flAccOwnerMemName");
                                   var flCtmId=component.get("v.isFLAccOwnerCareTeamId");
                                   console.log('flName='+flName);
                                   console.log('flCtmId='+flCtmId);
                                   component.set("v.displayCareTeamId",flCtmId);
                                   component.set("v.displayCTMName",flName.toUpperCase());
                                   component.set("v.childCTMId",ctm.Id);
                                   component.set("v.careTeamperMemAdd",FLAccOwnerList[0].SNI_FL_Family__r.Member_ID__c);
                                   component.set("v.birthdate",FLAccOwnerList[0].SNI_FL_Member__r.PersonBirthdate);
                                   helper.parseMailAddress(component,FLAccOwnerList[0].SNI_FL_Member__r.PersonMailingAddress) ;
                                }
                                else{
                                   component.set('v.child', "I");
                                   component.set('v.childName', "my");
                                   component.set("v.childCTMId","");
                                   console.log('displayCTMName' +ctm.SNI_FL_Member__r.Name.toUpperCase());
                                   component.set("v.displayCareTeamId",ctm.Id);
                                   component.set('v.displayCTMName', ctm.SNI_FL_Member__r.Name.toUpperCase());  
                                   component.set("v.careTeamperMemAdd",ctm.SNI_FL_Family__r.Member_ID__c);
                                   component.set("v.birthdate",ctm.SNI_FL_Member__r.PersonBirthdate);
                                   helper.parseMailAddress(component,ctm.SNI_FL_Member__r.PersonMailingAddress) ;
                                }
                           }
                         });
        				 $A.enqueueAction(action2);
                       }
					  break;
					 }
					}
              }
			  if(!check){
				component.set("v.isSignAuth",false);
                this.refreshCareTeam(component, event, helper);
                component.set("v.isInvited",false);
                this.createUser(component, memberCtmId); 
			   }
             }
          }
        }
     },
    refreshCareTeam : function(component, event, helper) {
        //debugger;
        var evt = $A.get("e.c:SNI_FL_RefreshCmp");
                        evt.setParams({ 
                            "isRefresh" : true
                        });
                        evt.fire();
    },
    parseMailAddress : function(component,peraddress) {
        debugger;
        var street='';
        var city='';
        var state='';
        var postalCode='';
        var country='';
        var comma=',';
        if(peraddress != undefined){
            if(peraddress.street!=undefined){ street=peraddress.street; }
            if(peraddress.city!=undefined){ city=peraddress.city; }
            if(peraddress.state!=undefined){ state=peraddress.state; }
            if(peraddress.postalCode!=undefined){ postalCode=peraddress.postalCode; }
            if(peraddress.country!=undefined){ country=peraddress.country; }
            if(peraddress.state==undefined && peraddress.postalCode==undefined ){comma='';}
            component.set("v.careTeamMemAdd",street+' '+city+comma+' '+state+' '+postalCode+' '+country);
        }
    }
    
})