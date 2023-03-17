public with sharing virtual class ACETErrorHandler {
    public Set<String> ErrorMSGSet  =new Set<String>();
    public List<AcetErrorMessage__mdt> ErrorSet  = new List<AcetErrorMessage__mdt>();
    List<AcetErrorMessage__mdt> erList=new List<AcetErrorMessage__mdt>();
    public boolean isServiceError=false;
    public boolean isTopPriorityPrsnt=false;
    map<String,AcetErrorMessage__mdt> errorMap=new map<String,AcetErrorMessage__mdt>();
    public static map<String,AcetErrorMessage__mdt> lightningErrorMap=new map<String,AcetErrorMessage__mdt>();
    public ACETErrorHandler(){ 
      try{
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            errorMap.put(em.masterlabel, em);
        }
      }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Exception Happened '+e.getstacktracestring());

      }
    }
    public static void createAppErrorLog( string errorcause, string reqBody, string errorline, string errormessage, string errortype){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationExcepLog('', 'Exception', errorcause, '', errorline, errormessage, errortype);
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILRequest', reqBody));
        //AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILResponse', resBody));
        system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
            Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }    
    }
	public Set<String> setErrorMsgInDataTable(String errorCode,Exception e){
      try{
        System.debug('errorCode='+errorCode);
        
        if(errorMap!=null && errorMap.size()>0){
          if(!String.isBlank(errorCode)){
           AcetErrorMessage__mdt er=errorMap.get(errorCode);
           if(er!=null){
            if(er.TopPriority__c){
                //erList.clear();
                //erList.add(er);
                isServiceError=true;
                isTopPriorityPrsnt=true;
            }
            else if(er.ServiceError__c){
                isServiceError=true;
            }
            String errorMessage='';
            if(isServiceError){
                if(isTopPriorityPrsnt){
                    if(er.TopPriority__c){
                        erList=new List<AcetErrorMessage__mdt>();
                        erList.add(er);
                    }
                }
                else if(er.TopPriority__c){
                    erList=new List<AcetErrorMessage__mdt>() ;
                    erList.add(er);
                }
                else if(er.ServiceError__c){
                    erList.add(er);}
            }else
                 erList.add(er);
            if(erList!=null && erList.size()>0){
              for(AcetErrorMessage__mdt am:erList){
                if(String.isNotBlank(am.Error_Message__c) && !ErrorMSGSet.contains(am.Error_Message__c)){
                  ErrorMSGSet.add(am.Error_Message__c);
                  System.debug('Error Message='+am.Error_Message__c);
                  //CONFIRM ,ERROR,FATAL,INFO,WARNING
		  if(e != null){
			string linenum = string.valueOf(e.getLineNumber());
			createAppErrorLog( '',  e.getStackTraceString(), linenum, e.getMessage(), e.getTypeName());
		  }
                  return ErrorMSGSet;
                 }
              }
            }            
         }
	}
      }
      return null;  
      }catch(Exception exp){
          system.debug(LoggingLevel.INFO, 'Exception Happened '+exp.getstacktracestring());
	 return null;
      }
    }
    public void setErrorMsg(String errorCode,Exception e){
      try{
        System.debug('errorCode='+errorCode);
        
        if(errorMap!=null && errorMap.size()>0){
          if(!String.isBlank(errorCode)){
            AcetErrorMessage__mdt er=errorMap.get(errorCode);
            if(er!=null){
             if(er.TopPriority__c){
                //erList=new List<AcetErrorMessage__mdt>();
                //erList.add(er);
                isServiceError=true;
                isTopPriorityPrsnt=true;
            }
            else if(er.ServiceError__c){
                isServiceError=true;
            }
            String errorMessage='';
            if(isServiceError){
                if(isTopPriorityPrsnt){
                    if(er.TopPriority__c){
                        erList=new List<AcetErrorMessage__mdt>();
                        erList.add(er);
                    }
                }
                else if(er.TopPriority__c){
                    erList=new List<AcetErrorMessage__mdt>() ;
                    erList.add(er);
                }
                else if(er.ServiceError__c){
                    erList.add(er);}
            }else
                 erList.add(er);
            System.debug('erList='+erList);
            if(erList!=null && erList.size()>0){
              for(AcetErrorMessage__mdt am:erList){
                if(am != null && String.isNotBlank(am.Error_Message__c) && !ErrorMSGSet.contains(am.Error_Message__c)){
                  ErrorMSGSet.add(am.Error_Message__c);
                  ErrorSet.add(am);
                  System.debug('Error Message='+am.Error_Message__c);
                    //CONFIRM ,ERROR,FATAL,INFO,WARNING
                  
                 }
              }
              for(AcetErrorMessage__mdt am:ErrorSet){
                if(am != null && String.isNotBlank(am.Error_Message__c)){
                  
                  if((am.Message_Type__c).equalsIgnoreCase('ERROR'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('INFO'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('CONFIRM'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('WARNING'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('FATAL'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL, am.Error_Message__c));
                 }
              }
            }            
         }
	}
      }
        if(e != null && errorCode != 'GN997'){
	string linenum = string.valueOf(e.getLineNumber());
            createAppErrorLog( '',  e.getStackTraceString(), linenum, e.getMessage(), e.getTypeName());
      	}
      }catch(Exception exp){
          system.debug(LoggingLevel.INFO, 'Exception Happened '+exp.getstacktracestring());

      }
    }

// This method is used to get the errors for specific service instead of all services errors 
    public void setErrorMsg(String errorCode){
        try{
        Set<String> setErrMsgs = new Set<String>();
        List<AcetErrorMessage__mdt> lstErrs=new List<AcetErrorMessage__mdt>();
        
        if(errorMap!=null && errorMap.size()>0){
          if(!String.isBlank(errorCode)){
           AcetErrorMessage__mdt er=errorMap.get(errorCode);
           if(er!=null){
                 lstErrs.add(er);
            if(lstErrs!=null && lstErrs.size()>0){
              for(AcetErrorMessage__mdt am:lstErrs){
                if(String.isNotBlank(am.Error_Message__c) && !setErrMsgs.contains(am.Error_Message__c)){
                  setErrMsgs.add(am.Error_Message__c);
                  System.debug('Error Message='+am.Error_Message__c);
                    //CONFIRM ,ERROR,FATAL,INFO,WARNING
                  if((am.Message_Type__c).equalsIgnoreCase('ERROR'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('INFO'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('CONFIRM'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('WARNING'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, am.Error_Message__c));
                  else if((am.Message_Type__c).equalsIgnoreCase('FATAL'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL, am.Error_Message__c));
                 }
              }
            }            
         }
        }
      }
      }catch(Exception exp){
          system.debug(LoggingLevel.INFO, 'Exception Happened '+exp.getstacktracestring());

      }
    }
    public static string setLightningErrorMsg(String errorCode){
        system.debug('========errorCode======'+errorCode);
        try{
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            lightningErrorMap.put(em.masterlabel, em);
        }
        Set<String> setErrMsgs = new Set<String>();
        List<AcetErrorMessage__mdt> lstErrs=new List<AcetErrorMessage__mdt>();
        if(lightningErrorMap!=null && lightningErrorMap.size()>0){
          if(!String.isBlank(errorCode)){
           AcetErrorMessage__mdt er=lightningErrorMap.get(errorCode);
           if(er!=null){
           	return er.Error_Message__c;                 
           }else
            return 'System Unavailable';
            }else
                return 'System Unavailable';
            }else
                return 'System Unavailable';
      }catch(Exception exp){
          system.debug(LoggingLevel.INFO, 'Exception Happened '+exp.getstacktracestring());
			return 'System Unavailable';
      }
    }
}