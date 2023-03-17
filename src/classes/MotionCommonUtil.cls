public with sharing class MotionCommonUtil {

	public static boolean handlerecursivecheck = true;
    public static string displayDateTimeFormat(string strDatetimeFormat){
        list<string> lstSplit = strDatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        integer myHour = Integer.valueOf(lsttimeformat[0]);
        string strAMPM = myHour>=12?'PM':'AM';
        Integer myClockHour = 12;
        Integer myTime = myHour>12?myHour-myClockHour:myHour;
        
        string strDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0]+' '+myTime+':'+lsttimeformat[1]+' '+strAMPM;
        return strDateFormat;
    } 
    
    public static string strDateFormat(string strDateFormat){
        list<string> lstDateformat = strDateFormat.split('-');
        if(lstDateformat.size()==3){
            return lstDateformat[1]+'/'+lstDateformat[2]+'/'+lstDateformat[0];
        }
        else
            return '';
    }
    
    public static string convertToDateFormat(string strDatetimeFormat){
        list<string> lstSplit = strDatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
                
        string finalDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0];
        return finalDateFormat;
    }

    public static String changeDateWithHypen(String strDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(strDate)) {
            List<String> strDateSplit = strDate.split('/');
            if(strDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(strDateSplit[0]);
                Integer strDay = integer.ValueOf(strDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                            
                FormattedDate = strDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return FormattedDate;
    }

    public static string returnDateFormat(string inputStr){
        if(inputStr != null && inputStr != ''){
            return inputStr.split('-')[1]+'/'+inputStr.split('-')[2]+'/'+inputStr.split('-')[0];
        }
        return inputStr;
    }
    
	public static String heightConversion(String str){
        System.debug('#$#$#$'+str);
        String formatedString='';
        if(str!='' && str!='0' && Integer.valueOf(str)>0){
             
             formatedString = str.replace('.', '\'');
            
           system.debug('length'+formatedString.length());
            if(formatedString.length()!= 1){
               formatedString = formatedString+ '\"';
                }
            else if(formatedString.length()== 1){
                formatedString = formatedString + '\''+'0'+'\"';
            }
           
        }       

        return formatedString;
    }

    public static String heightConvInFeetAndInch(String heightInInches){
        String heightInFtAndInch;
        Integer heightIntValue = Integer.valueOf(heightInInches);
        if(heightInInches != null && heightInInches!='' && Integer.valueOf(heightInInches)>0){
            Decimal height = heightIntValue/12.0;
            Integer ftVal = heightIntValue/12;            
            Decimal inchVal = height - ftVal;
            String strInchVal = String.valueOf(inchVal);
			Decimal x=inchVal.setScale(1, RoundingMode.HALF_UP);												   
			String y=String.valueOf(x);
            if(y.contains('.')){
               List<String> strInchValSplit =  y.split('\\.');
                //system.debug('split list'+ strInchValSplit);
                if(strInchValSplit[1].length() > 1 ){
                 inchVal =Integer.valueOf(strInchValSplit[1] );
                    //system.debug('inchval inside if'+inchVal );
                } else {
                  inchVal =  Integer.valueOf(strInchValSplit[1]);
                  
               }
                }								
			 
            heightInFtAndInch = ftVal+ '\'' + inchVal +'\"';         
        } 
        System.debug('Height In Ft and Inch::'+heightInFtAndInch);       
        return heightInFtAndInch;
    }

    public static String weightConversion(String str){
        String returnstr;
        if(str!='' && str=='0' && Integer.valueOf(str)==0 ){
            returnstr = '';
        }else{
            returnstr = Integer.valueOf(str)+'lbs';
        }
        return returnstr;
    }
    
    public static String Dateconversion(String dt){
        if(String.isNotEmpty(dt)){
            Date d=Date.valueOf(dt);
            String formatedDate=DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/yyyy');
            return formatedDate;
        }       
        return '';
    }
    
	public static String dollerconvertion(String maxearnings){
    	string maxearningvalue;
        if(maxearnings.startsWith('$')){
            maxearningvalue = maxearnings;
        }else{
            maxearningvalue = String.valueOf(Integer.valueOf(maxearnings));
        }
        return maxearningvalue;
    }
    
    public static void completeMilestone(List<Id> caseIds, Set<String> milestoneName, DateTime complDate) {  
        
        List<CaseMilestone> cmsToUpdate = [SELECT Id, completionDate
                                           FROM CaseMilestone cm
                                           WHERE caseId in :caseIds AND cm.MilestoneType.Name IN: milestoneName 
                                           AND completionDate = null];
        System.debug('cmsToUpdate: '+cmsToUpdate);
        if ( cmsToUpdate!=null && !cmsToUpdate.isEmpty()){
            for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
            }
            update cmsToUpdate;
        }
    }
    
	public static String validEmailconversion (String memberEmail) {
		String returnValue = '';
		if(!String.isEmpty(memberEmail)){
			String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
			Pattern emailPattern = Pattern.compile(emailRegex);
			Matcher emailMatcher = emailPattern.matcher(memberEmail);
			if (emailMatcher.matches()) {
				returnValue = memberEmail;
			}
		System.debug('Email format-->'+returnValue);
		}
		return returnValue;
	}
    
    public static string GetOrgName(Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap) {
        String SFDCInstanceHostName = URL.getSalesforceBaseUrl().getHost().toLowerCase();
        system.debug(LoggingLevel.INFO, 'SFDCInstanceHostName: ' + SFDCInstanceHostName);
        String orgName;

        for(ACETOrgInstanceURLToOrgNameMap__c OrgInstance2OrgName :OrgInstance2OrgNameMap.values()) {
            if (SFDCInstanceHostName.contains(OrgInstance2OrgName.Name))    {
                orgName = OrgInstance2OrgName.Org_Name__c;
                break;
            }
        }
        //US3098067 - Avish & vishnu
        orgName=(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c)?'prd':orgName;

        system.debug(LoggingLevel.INFO, 'OrgName: ' + orgName);

        return (Test.isRunningTest()) ? 'qa' : orgName;
    }
    
    public static string GetOrgName() {
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgName = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        return GetOrgName(OrgInstance2OrgName);
    }
	public static string GetSSNFormat(String memberSSN) {
    	string returnSSNNumber='';
        try{
            if(String.isNotEmpty(memberSSN) && memberSSN.length() ==9){
                Integer newmemberSSN = Integer.valueOf(memberSSN);
                returnSSNNumber = (String.valueOf(newmemberSSN).substring(0,3)+'-'+String.valueOf(newmemberSSN).subString(3,5)+'-'+String.valueOf(newmemberSSN).substring(5,9));
            }else{
                returnSSNNumber='';
            }
        }catch(Exception Ex){
        	returnSSNNumber='';
            system.debug('error mesage-->'+Ex.getMessage());
        }
        System.debug('returnSSNNumber-->'+returnSSNNumber);
        return returnSSNNumber;
    }													 
}