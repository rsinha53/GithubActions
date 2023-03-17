({
    ssnFormat: function(component, event, helper){
        var ssnValue = component.get("v.memberDetails.member.ssn");
        component.set("v.ssnFormated",(ssnValue.substr(0, 3) + '-'+ ssnValue.substr(3, 2) + '-'+ ssnValue.substr(5, 4)));
    },
    
     dateFormat : function(component, event, helper){
        var dateString = component.get("v.memberDetails.member.birthDate");
        
        component.set("v.dateFormated",$A.localizationService.formatDate(dateString, "MM/dd/YYYY"));
        
    },
    
    employeDetails : function(component, event, helper){
        //US3703234: Member with No Accounts
		var ssnMemberDetails = component.get("v.memberDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
               && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
         var accountDetails = Object.values(component.get("v.memberDetails.accountDetails"));
        
    if(accountDetails.some(obj => obj.hasOwnProperty("notionalAccountDetails")) && accountDetails.some(obj => obj.hasOwnProperty("nonNotionalAccountDetails"))){
                     for(var i=0; i<accountDetails.length; i++){
                 if(accountDetails[i].hasOwnProperty("notionalAccountDetails"))
                 {
                   component.set("v.employerName",accountDetails[i].employerGroupName);  
                   component.set("v.employerId",accountDetails[i].employerId);
                   
                  }
                        else {
                            if(accountDetails[i].hasOwnProperty("nonNotionalAccountDetails")){
                              component.set("v.groupId",accountDetails[i].employerId);
                     component.set("v.employerName",accountDetails[i].employerGroupName); 
                            }
                        }
                 
                    }
                }
        
    else if(accountDetails.some(obj => obj.hasOwnProperty("nonNotionalAccountDetails"))) {
           
             for(var i=0; i<accountDetails.length; i++){
                 if(accountDetails[i].hasOwnProperty("nonNotionalAccountDetails")){
					 component.set("v.employerName",accountDetails[i].employerGroupName); 
                      if(accountDetails[i].accountType == 'HSA' && (accountDetails[i].accountType != 'WEX HSA' && accountDetails[i].accountType != 'Notional'))
                      
             component.set("v.employerId", "NA");
           component.set("v.groupId", accountDetails[i].employerId);
                      break;
                   }
            
            }
        }
            
       else if(accountDetails.some(obj => obj.hasOwnProperty("notionalAccountDetails"))){
                    for(var i=0; i<accountDetails.length; i++){
                 if(accountDetails[i].hasOwnProperty("notionalAccountDetails")){
                    component.set("v.employerName",accountDetails[i].employerGroupName);  
              component.set("v.employerId",accountDetails[i].employerId);
            component.set("v.groupId","NA");
                      break;
                  }
                 
                    }
                }
            }
   },
   //Added by prasad-US3223518:Tech Story: Auto Doc General Information
	setAutodocCardData: function (cmp, event, helper) {
        var maskSSN = cmp.get("v.memberDetails.member.ssn");
        maskSSN = 'XXX-XX-'+maskSSN.substr(maskSSN.length-4,maskSSN.length);
        cmp.set("v.MaskedSSN",maskSSN);
        var middleName = cmp.get("v.memberDetails.member.middleName");
        var fistname = cmp.get("v.memberDetails.member.firstName");
        var lastName = cmp.get("v.memberDetails.member.lastName");
         if (typeof middleName !== "undefined" || middleName != null || !middleName ==="") {
            var fullName = fistname+" "+ middleName +" "+ lastName;
                cmp.set("v.fullName", fullName);
         }else{
             	cmp.set("v.fullName", fistname+ " "+lastName);
         }
          //US3703234: Member with No Accounts
        var ssnMemberDetails = cmp.get("v.memberDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
           && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
            var emp =cmp.get("v.groupId") + '/'+cmp.get("v.employerId");
        }
      var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
        if(!$A.util.isEmpty(autodocCmp)){
            cmp.set("v.cardDetails", autodocCmp);
        }
        var cardDetails = new Object();
            cardDetails.componentName = "General Information";
            cardDetails.componentOrder = 1;
            cardDetails.noOfColumns = "slds-size_1-of-2";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "defaultChecked": true,
                    "fieldName": "Name",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.fullName"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Member Status",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.memberDetails.accountDetails[0].employStatusDesc"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Date Of Birth",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.dateFormated"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "defaultChecked": true,
                    "fieldName": "SSN",
                    "fieldType": "maskedText",
                    "fieldValue": cmp.get("v.MaskedSSN"),
                    "unmaskedValue":cmp.get("v.memberDetails.member.ssn"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employer Name",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.employerName"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Group Id/Employer Id",
                    "fieldType": "outputText",
                    "fieldValue": emp,
                    "showCheckbox": true,
                    "isReportable":true
                }
                 ];
            
            cmp.set("v.cardDetails", cardDetails);
       },
//Added by Iresh DE411196: To fix the space between Middle name and Last name
    getMiddleName: function (component, event, helper) {
        var middleName = (component.get("v.memberDetails.member.middleName"));
        	if (typeof middleName !== "undefined" || middleName != null || !middleName ==="") {
        		component.set("v.middleName",middleName+" ");
         }
    },
    
    })