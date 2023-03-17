({
    pollApex : function(component, event, helper) {         
        //execute callApexMethod() again after 5 sec each
       window.setInterval(
            $A.getCallback(function() {
        const toggle_Input = component.find("toggle_Input_id").get("v.checked");
         if(toggle_Input){
        helper.callApexMethod(component,helper)
           }
            }), 5000
        );
    },
    handleResponse : function (component,vccdobj,Dobstring,SubjectDOBstring,userptofilename){
         var vccdParams = new Object();
          vccdParams.vccdobjectid = vccdobj.Id;
          vccdParams.noAutoSearch = true;
          if(vccdobj.QuestionType__c != undefined && vccdobj.QuestionType__c != '' && vccdobj.QuestionType__c != null){
                vccdParams.callTopic = vccdobj.QuestionType__c;
               }
              if(vccdobj.Caller_Type__c != undefined && vccdobj.Caller_Type__c != '' && vccdobj.Caller_Type__c != null){
                if(vccdobj.Caller_Type__c == 'MM')
                    vccdParams.CallerType = 'Member';
                if(vccdobj.Caller_Type__c == 'PV')
                    vccdParams.CallerType = 'Provider';
                if(vccdobj.Caller_Type__c == 'BA')
                    vccdParams.CallerType = 'Group';
                if(vccdobj.Caller_Type__c == 'BR')
                    vccdParams.CallerType = 'Producer';
                    }           
              if(vccdobj.Ani__c != undefined && vccdobj.Ani__c != '' && vccdobj.Ani__c != null){
                  vccdParams.phone = vccdobj.Ani__c;
                  }
              if(vccdobj.MemberId__c != undefined && vccdobj.MemberId__c != '' && vccdobj.MemberId__c != null){
                  vccdParams.memberId =  vccdobj.MemberId__c;
                    }   
              if(vccdobj.SubjectDOB__c != undefined && vccdobj.SubjectDOB__c != '' && vccdobj.SubjectDOB__c != null){
                  vccdParams.MemberDOB =  SubjectDOBstring;
                    } 
              if(vccdobj.DOB__c != undefined && vccdobj.DOB__c != '' && vccdobj.DOB__c != null){
                  vccdParams.dob =  Dobstring;
                    }
              if(vccdobj.TaxId__c != undefined && vccdobj.TaxId__c != '' && vccdobj.TaxId__c != null){
                  vccdParams.TaxID =  vccdobj.TaxId__c;
                    }
              if(vccdobj.NPI__c != undefined && vccdobj.NPI__c != '' && vccdobj.NPI__c != null){
                  vccdParams.npi =  vccdobj.NPI__c;
                    }
              if(vccdobj.TFN__c != undefined && vccdobj.TFN__c != '' && vccdobj.TFN__c != null){
                  vccdParams.TFN =  vccdobj.TFN__c;
                    }
              if(vccdobj.QuestionTypeCode__c != undefined && vccdobj.QuestionTypeCode__c != '' && vccdobj.QuestionTypeCode__c != null){
                  vccdParams.QuestionType =  vccdobj.QuestionTypeCode__c;
                    }
              if(vccdobj.ClaimId__c != undefined && vccdobj.ClaimId__c != '' && vccdobj.ClaimId__c != null){
                  vccdParams.ClaimID =  vccdobj.ClaimId__c;
                    }
              if(vccdobj.producerID__c != undefined && vccdobj.producerID__c != '' && vccdobj.producerID__c != null){
                  vccdParams.producerId =  vccdobj.producerID__c;
                    }
              if(vccdobj.groupID__c != undefined && vccdobj.groupID__c != '' && vccdobj.groupID__c != null){
                  vccdParams.groupId =  vccdobj.groupID__c;
                    }
              if(vccdobj.Ani__c != undefined && vccdobj.Ani__c != '' && vccdobj.Ani__c != null){
                  vccdParams.CallerID =  vccdobj.Ani__c;
                    }
              if(vccdParams.callTopic != undefined && vccdParams.callTopic != '' && vccdParams.callTopic != null){ 
                  component.set("v.QuestionTypeInfo",vccdParams.callTopic);
                  component.set("v.userptofilename",userptofilename);
              }
          var myEvent = $A.get("e.c:ACETLGT_VCCDBridgeSuppEvent");
            myEvent.setParams({
                VCCDResponceObj: vccdParams
            });
            myEvent.fire();
        
      this.updateCurrentRecordToInactive(component,vccdobj.Id);

    },
    callApexMethod : function (component,helper){    
        var action = component.get("c.getVCCDData");        
        action.setCallback(this, function(response) {
            const result = response.getReturnValue();
            console.log('response===>'+JSON.stringify(result));
             var isMyObjectEmpty = !Object.keys(result).length;
                 if( isMyObjectEmpty != true && result.vccdObject.Id != undefined && result.vccdObject.Id != '' && result.vccdObject.isActive__c == true){
                         this.handleResponse(component,result.vccdObject,result.Dobstring,result.SubjectDOBstring,result.userptofilename);
            }
        });
        $A.enqueueAction(action); 
    },
    updateCurrentRecordToInactive : function (component,vccdrecordstring){    
        var action = component.get("c.updateCurrentRecordToInactive"); 
         action.setParams({
            vccdrecordstring : vccdrecordstring
        })
        action.setCallback(this, function(response) {
            if(!$A.util.isUndefinedOrNull(response)){
                console.log('Inactivated RecorId ==>'+vccdrecordstring);
            }
        });
        $A.enqueueAction(action); 
    } 
})