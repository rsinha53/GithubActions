public with sharing class Motion_MemberInformationController {
    
    @AuraEnabled public String eligibleId ;
    @AuraEnabled public String registeredId;
    public Motion_MemberInformationController(){}
    
    @AuraEnabled
    public static Motion_MemberInformationController.SnapshotDataData featchMemberInformation(String dermID, String memeligibleID, String lastName, String firstName, String memberEmail, String memberDob, String interactType, Boolean isCheckboxDisabled){
        System.debug('Registered Memebr Id: '+dermID + 'Eligible member id:'+memeligibleID);
        Motion_MemberInformationController.SnapshotDataData returnWrapper = new Motion_MemberInformationController.SnapshotDataData(); 
        MotionMemberDetailWrapper memberInfo  = new MotionMemberDetailWrapper();
        MotionMemberDetailWrapper.MemberConsoleInfo consoleInfo  = new MotionMemberDetailWrapper.MemberConsoleInfo();
        MotionMemberDetailWrapper.MemberConsoleInfo consoleresult;
        Motion_PlanWaiver medicalWaivers;
        HttpResponse response;
        HttpResponse consoleResponse;
        
        returnWrapper.PlanWaiverDetails = fetchMemberPlainWaiverRecords(dermID, '', isCheckboxDisabled);
        
        if(!String.isEmpty(dermID) || !String.isEmpty(memeligibleID)){                
            response = MOTION_MemberAPIServiceController.memberDetailService(dermID,memeligibleID);
        } 
        if(!String.isEmpty(dermID))
        {
        	consoleResponse	= MOTION_MemberAPIServiceController.streamLineConsoleForDeviceInfo(dermID); 
            returnWrapper.PlanWaiverDetails = fetchMemberPlainWaiverRecords(dermID, '', isCheckboxDisabled);
        }
        Boolean disabled = true;
        if(isCheckboxDisabled){
            disabled = false;
        }
        
        if(response != null && response.getStatusCode()==200){
            System.debug('response.getBody()>>>>'+response.getBody());
            memberInfo = parseMemberDermInfo(response.getBody());
            returnWrapper.digitalThermoticesdetails = setdigitalCardData(memberInfo,'',disabled);
            returnWrapper.demographicdetails = setdemographicsCardData(memberInfo, '',disabled);
        } else{
            returnWrapper.digitalThermoticesdetails = setdigitalCardData(NULL,'',disabled);
            returnWrapper.demographicdetails 		= setdemographicsCardData(NULL, '',disabled);
        }
        
        if(consoleResponse != null && consoleResponse.getStatusCode()==200  ){
            consoleInfo = consoleAPIResponseParser(consoleResponse.getBody());
        }
        
        if(consoleResponse != null){
            returnWrapper.diviceInfodetails = setDeviceInfoData(memberInfo,consoleInfo,'',disabled);
            returnWrapper.Hightpaneldetails = setHilightpanelData(memberInfo,consoleInfo,'');
        } else{
            returnWrapper.diviceInfodetails = setDeviceInfoData(memberInfo,NULL,'',disabled);
            returnWrapper.Hightpaneldetails= setHilightpanelData(memberInfo,NULL,'');
        }
        
        return returnWrapper;
    }
    
    public static MotionMemberDetailWrapper parseMemberDermInfo(String json) {
        system.debug('json'+json);        
        MotionMemberDetailWrapper memdeviecInfo = new MotionMemberDetailWrapper();
        System.JSonParser dermparser = System.Json.CreateParser(json);
        
        While(dermparser.nextToken()!=null){
            if(dermparser.getCurrentToken() == JsonToken.START_OBJECT) {
                memdeviecInfo = (MotionMemberDetailWrapper) dermparser.readValueAs(MotionMemberDetailWrapper.class);   
            }  
        }
        return memdeviecInfo;         
    }
    
    //Method Start
    public static MotionMemberDetailWrapper.MemberConsoleInfo consoleAPIResponseParser (String json) {        
        MotionMemberDetailWrapper.MemberConsoleInfo consoleInfo = new MotionMemberDetailWrapper.MemberConsoleInfo();
        System.JSonParser dermparser = System.Json.CreateParser(json);  
        
        While(dermparser.nextToken()!=null){
            if(dermparser.getCurrentToken() == JsonToken.START_OBJECT) {
                consoleInfo = (MotionMemberDetailWrapper.MemberConsoleInfo) dermparser.readValueAs(MotionMemberDetailWrapper.MemberConsoleInfo.class);   
            }  
        }
        return consoleInfo; 
    }
    //New Method End
    
    @AuraEnabled
    public static Motion_MemberInformationController.SnapshotDataData getThirdparty(String firstName, String lastName, string emailaddress, string phone, String groupname, string groupnumber, string dob, String state, string zip, string inttype){
        MotionMemberDetailWrapper.MemberNotFound membernotFound=new MotionMemberDetailWrapper.MemberNotFound();
        MotionMemberDetailWrapper.MemberNotFoundHighlightsHeader highlightsHeader= new MotionMemberDetailWrapper.MemberNotFoundHighlightsHeader();
        Motion_MemberInformationController.SnapshotDataData returnWrapper = new Motion_MemberInformationController.SnapshotDataData();
        Interaction__c intrec = MOTION_CreatePersonAccountInteractions.creatThirdPartyAndInteraction(firstName, lastName, emailaddress, phone, groupname, groupnumber, dob, state, zip, inttype);
        
        returnWrapper.InteractionRecord = intrec;
        
        if(intrec != null){  
            membernotFound.fname=intrec.Originator_Name__c;
            membernotFound.dob=String.valueOf(intrec.third_party__r.DOB__c);
            membernotFound.EmailAddress=intrec.third_party__r.Email__c;
            membernotFound.GroupName=intrec.third_party__r.Group_Name__c;
            membernotFound.GroupNumber=intrec.third_party__r.Group_Number__c;
            membernotFound.Zip=intrec.third_party__r.Mailing_PostalCode__c;
            membernotFound.State=intrec.third_party__r.Mailing_State__c;
            membernotFound.Phone=intrec.third_party__r.Phone_Number__c;
            returnWrapper.highlightsPanelMemberNotFound=setHilightpanelDatamemberNotFound(membernotFound,'');
            returnWrapper.generalInfoPanelMemberNotFound=setGeneralInfopanelDatamemberNotFound(membernotFound,'');
        }
        
        system.debug((returnWrapper.highlightsPanelMemberNotFound));    
        
        return returnWrapper;
    }
    
    /*Plan Waiver method */
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails setCredentialData(Motion_PlanWaiver memberDetailResult, Boolean isCheckboxDisabled) {
        StaticResource static_resource = [SELECT Id,Name,SystemModStamp
                                          FROM StaticResource 
                                          WHERE Name = 'Plan_Waivers_Icon'
                                          LIMIT 1];
        
        List < Motion_PlanWaiver.Data > credDetails;
        Motion_PlanWaiver.PageDetails paginations;
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        
        if(memberDetailResult!=null){
            paginations=memberDetailResult.pagination;
            credDetails = memberDetailResult.MedicalWaivers;
            
            affTable.type = 'table';
            affTable.componentName='Plan Waivers';
            affTable.autodocHeaderName='Plan Waivers';
            affTable.tableHeaders = new List < String > {
                'Status',
                    'Type',
                    'Start Date',
                    'End Date',
                    'Entered by',
                    'Date Entered',
                    'Client Admin Notes'
                    
                    };
            
            List <ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
            system.debug('credDetails'+ credDetails);
            
            if (credDetails != null) {
                String resourceName = '';
                for (integer i = 0; i < credDetails.size(); i++) {
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    if(isCheckboxDisabled)
                		tableRow.checkBoxDisabled = true;
                	else
                    	tableRow.checkBoxDisabled = false;
                    
                    List < ACET_AutoDocUtil.rowColumnData > rowColumns = new List < ACET_AutoDocUtil.rowColumnData > ();
                    String statusvalue = !String.isEmpty(credDetails[i].Status)? credDetails[i].Status:'--';
                    
                    System.debug('Planwaiver Details'+statusvalue);
                    if(statusvalue == 'Active'){
                        
                        resourceName = '/resource/'
                            + String.valueOf(((DateTime)static_resource.get('SystemModStamp')).getTime())
                            + '/' 
                            + static_resource.get('Name')                   
                            + '/complete.svg';
                        
                    }else if(statusvalue == 'Expired'){
                        resourceName = '/resource/'
                            + String.valueOf(((DateTime)static_resource.get('SystemModStamp')).getTime())
                            + '/' 
                            + static_resource.get('Name')                   
                            + '/Expired.svg';
                    }else if(statusvalue == 'Incomplete'){
                        resourceName = '/resource/'
                            + String.valueOf(((DateTime)static_resource.get('SystemModStamp')).getTime())
                            + '/' 
                            + static_resource.get('Name')                   
                            + '/Warning.svg';
                    }
                    
                    //////////////////////////////////////
                    // Harkunal:06/04/2021:US3596560:Start
                    // Adding a boolean attribute value to "true" as the last attribute to the rowColumns of the table to enable the fields for auto doc reporting. For the first rowcolumns adding "true"as a third attribute as it calls method with different signature from apex class.
                    //////////////////////////////////////

                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('ToolTipIcon', statusvalue,false,resourceName));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].Type_Z !=''? credDetails[i].Type_Z:'--',false));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].StartDate!='' &&  credDetails[i].StartDate!='0' ? (MotionCommonUtil.Dateconversion(credDetails[i].StartDate)):'--',false));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].EndDate !='' &&  credDetails[i].EndDate!='0' ?(MotionCommonUtil.Dateconversion(credDetails[i].EndDate)):'--',false));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].EnteredBy !=''? credDetails[i].EnteredBy:'--',false));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].DateEntered !='' &&  credDetails[i].DateEntered!='0'? MotionCommonUtil.Dateconversion(credDetails[i].DateEntered):'--',false));
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].ClientAdminNotes !=''? credDetails[i].ClientAdminNotes:'--',false));
                    
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('ToolTipIcon', statusvalue,true,resourceName));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].Type_Z !=''? credDetails[i].Type_Z:'--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].StartDate!='' &&  credDetails[i].StartDate!='0' ? (MotionCommonUtil.Dateconversion(credDetails[i].StartDate)):'--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].EndDate !='' &&  credDetails[i].EndDate!='0' ?(MotionCommonUtil.Dateconversion(credDetails[i].EndDate)):'--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].EnteredBy !=''? credDetails[i].EnteredBy:'--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].DateEntered !='' &&  credDetails[i].DateEntered!='0'? MotionCommonUtil.Dateconversion(credDetails[i].DateEntered):'--',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].ClientAdminNotes !=''? credDetails[i].ClientAdminNotes:'--',true));
                    
                    ///////////////////////////////////
                    //Harkunal:06/04/2021:US3596560:End
                    ///////////////////////////////////
                    
                    tableRow.rowColumnData = rowColumns;
                    tableRow.uniqueKey = String.valueOf(credDetails[i]) + System.now() ;          
                    tableRows.add(tableRow);
                }
                affTable.tableBody = tableRows; 
                
                Integer pageNumber = paginations.Offset;
                Integer totalRecords = paginations.Total;
                Integer pageSize = 25; 
                
                if(totalRecords < 25){
                    affTable.endNumber = totalRecords;
                }else{
                    affTable.endNumber = (pageSize * pageNumber)>totalRecords ? totalRecords : (pageSize * pageNumber);
                        }
                
                if(totalRecords==0){	
                    affTable.startNumber = 0;
                }else if((pageSize * pageNumber)-25 == 0){
                    affTable.startNumber = 1;
                }else if(((pageSize * pageNumber)- 24)>affTable.endNumber){
                    affTable.startNumber = affTable.endNumber;
                }else{
                    affTable.startNumber = (pageSize * pageNumber) - 24;
                }
                
                affTable.recordCount 	= totalRecords;
                
                Integer wholeNumCheck = math.mod(totalRecords, 25);
                
                if(wholeNumCheck==0){
                    affTable.noOfPages 		= totalRecords/25 != 0 ? (totalRecords/25) : 1;
                }
                else{
                    affTable.noOfPages 		= totalRecords/25 != 0 ? (totalRecords/25)+1 : 1;    
                }
                
            } 
        }
        system.debug('affTable'+ affTable);
        return affTable;       
    }
    
    public static ACET_AutoDocUtil.CardDetails setdigitalCardData(MotionMemberDetailWrapper ProviderCardDetails, String providerType, Boolean disabled) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_3-of-12';
        providerDetails.componentName = 'Digital Therapeutics';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > (); 
       ///////////////////////////////////////
        // Harkunal:06/04/2021:US3596560:Start
        // Adding a boolean attribute value as the last attribute to "true" to the Field Details method of the card data of the table to enable the fields for auto doc reporting.
        /////////////////////////////////////
        //if(ProviderCardDetails != null && String.valueOf(ProviderCardDetails.AlternateActivityEligible) == ''){
        //    cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Eligible', '--', 'outputText',false));    
        //}else{
        //    cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Eligible', ProviderCardDetails != null && ProviderCardDetails.AlternateActivityEligible != 'false' ? 'Yes' : 'No', 'outputText',false));
        //}
        //if(ProviderCardDetails != null && String.valueOf(ProviderCardDetails.AlternateActivityOptInStatus) == ''){
        //    cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Opt-in', '--', 'outputText',true));    
        //}else{
        //    cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Opt-in', ProviderCardDetails != null && ProviderCardDetails.AlternateActivityOptInStatus != 'false' ? 'Yes' : 'No', 'outputText',true));   
        //}
        if(ProviderCardDetails != null && String.valueOf(ProviderCardDetails.AlternateActivityEligible) == ''){
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Eligible', '--', 'outputText',true));    
        }else{
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Eligible', ProviderCardDetails != null && ProviderCardDetails.AlternateActivityEligible != 'false' ? 'Yes' : 'No', 'outputText',true));
        }
        if(ProviderCardDetails != null && String.valueOf(ProviderCardDetails.AlternateActivityOptInStatus) == ''){
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Opt-in', '--', 'outputText',true));    
        }else{
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Alternate Activity Opt-in', ProviderCardDetails != null && ProviderCardDetails.AlternateActivityOptInStatus != 'false' ? 'Yes' : 'No', 'outputText',true));   
        }
        
        ///////////////////////////////////
        //Harkunal:06/04/2021:US3596560:End
        ///////////////////////////////////
        providerDetails.cardData = cardData;
       return providerDetails;
    }
    public static ACET_AutoDocUtil.CardDetails setDeviceInfoData(MotionMemberDetailWrapper ProviderCardDetails,MotionMemberDetailWrapper.MemberConsoleInfo consoleCardDetails, String providerType, Boolean disabled) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_3-of-12';
        providerDetails.componentName = 'Device Info';
       String lstsyncAppversion = (consoleCardDetails != null && consoleCardDetails.LastSyncStepDateTime!='' && consoleCardDetails.LastSyncStepDateTime!=null)?(consoleCardDetails.LastSyncStepDateTime.substring(0,10)+' '+consoleCardDetails.LastSyncStepDateTime.substring(11,16)):'';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();  
        //////////////////////////////////////
        // Harkunal:06/04/2021:US3596560:Start
        // Adding a boolean attribute value as the last attribute to "true" to the Field Details method of the card data of the table to enable the fields for auto doc reporting.
        /////////////////////////////////////
        
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Device Model', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.DeviceModelPaired) ? consoleCardDetails.DeviceModelPaired : '--', 'outputText',true));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Sync Step Date Time', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.LastSyncStepDateTime) ? lstsyncAppversion : '--', 'outputText',false));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Sync App Version', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.LastSyncAppVersion) ? consoleCardDetails.LastSyncAppVersion : '--', 'outputText',true));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Firmware Version', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.FirmwareVersion) ? consoleCardDetails.FirmwareVersion : '--', 'outputText',true));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Sync Frequency', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.SyncFrequency) && Integer.valueOf(ProviderCardDetails.SyncFrequency) > 0? ProviderCardDetails.SyncFrequency : '--', 'outputText',false));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Time Zone', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.TimeZone)? ProviderCardDetails.TimeZone : '--', 'outputText',false));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Device Model', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.DeviceModelPaired) ? consoleCardDetails.DeviceModelPaired : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Sync Step Date Time', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.LastSyncStepDateTime) ? lstsyncAppversion : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Sync App Version', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.LastSyncAppVersion) ? consoleCardDetails.LastSyncAppVersion : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Firmware Version', consoleCardDetails != null && String.isNotEmpty(consoleCardDetails.FirmwareVersion) ? consoleCardDetails.FirmwareVersion : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Sync Frequency', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.SyncFrequency) && Integer.valueOf(ProviderCardDetails.SyncFrequency) > 0? ProviderCardDetails.SyncFrequency : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Time Zone', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.TimeZone)? ProviderCardDetails.TimeZone : '--', 'outputText',true));
        
        ////////////////////////////////////
        //Harkunal:06/04/2021:US3596560:End
        ///////////////////////////////////
        providerDetails.cardData = cardData;
        return providerDetails;
    }
    
    public static ACET_AutoDocUtil.CardDetails setdemographicsCardData(MotionMemberDetailWrapper ProviderCardDetails, String providerType, Boolean disabled) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_3-of-12';
        providerDetails.componentName = 'Demographics';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        //String SSNNumber = (ProviderCardDetails!= null && String.isNotEmpty(ProviderCardDetails.SSN)? ProviderCardDetails.SSN: '');
        String formatSSNumber =MotionCommonUtil.GetSSNFormat(ProviderCardDetails!= null && String.isNotEmpty(ProviderCardDetails.SSN)? ProviderCardDetails.SSN: ''); 
        //ProviderCardDetails!= null && String.isNotEmpty(ProviderCardDetails.SSN)?(SSNNumber.substring(0,3)+'-'+SSNNumber.subString(3,5)+'-'+SSNNumber.substring(5,9)):'--';
        String Height = (ProviderCardDetails!=null && String.isNotempty(ProviderCardDetails.Height) && Integer.valueOf(ProviderCardDetails.Height)>0? MotionCommonUtil.heightConvInFeetAndInch(ProviderCardDetails.Height): '0');
        String Weight = (ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.Weight) && Integer.valueOf(ProviderCardDetails.Weight)>0? MotionCommonUtil.weightConversion(ProviderCardDetails.Weight):'0');
        if(Height==null ){
            Height='';
        }
        else if(Weight==null ){
            Weight='';
        }
        String Heightweight = Height + ', '+Weight;
        Heightweight =(Heightweight==', ') ?'--':Heightweight;
        Heightweight = (Heightweight == '--, --')?'--':Heightweight;
        Heightweight = (Heightweight == '0, 0')?'0\''+'0"'+', 0 lbs':Heightweight;
        String birthdate =  ProviderCardDetails!= null && ProviderCardDetails.BirthDate!= null ?MotionCommonUtil.Dateconversion(ProviderCardDetails.BirthDate):'';
        String programstartdate = ProviderCardDetails!= null && ProviderCardDetails.ProgramStartDate!= null ? MotionCommonUtil.Dateconversion(ProviderCardDetails.ProgramStartDate) : '';
        String programCanceldate = ProviderCardDetails!= null && ProviderCardDetails.CancelledDateTime!= null?MotionCommonUtil.Dateconversion(ProviderCardDetails.CancelledDateTime):'';
        
        String AddressLine1 = (ProviderCardDetails != null && ProviderCardDetails.Address	!='' ? ProviderCardDetails.Address+'<br/>' : '');
        String AddressCity 	= (ProviderCardDetails != null && ProviderCardDetails.City		!='' ? ProviderCardDetails.City+',' : '');
        String AddressState = (ProviderCardDetails != null && ProviderCardDetails.State	!='' ? ProviderCardDetails.State : '');
        String AddressZip 	= (ProviderCardDetails != null && ProviderCardDetails.ZipCode	!='' ? ProviderCardDetails.ZipCode : '');
       String completeAddress = AddressLine1+AddressCity+' '+AddressState+' '+AddressZip;
        
        String EmailNotification = '';
        if(ProviderCardDetails!= null && ProviderCardDetails.OptOutAllEmails == 'true'){
            EmailNotification = 'Opt Out';
        }else if(ProviderCardDetails!= null && ProviderCardDetails.MonthlyEMail == 'true' && ProviderCardDetails.WeeklyEmail == 'true'){
            EmailNotification = 'Weekly'+','+'Monthly';
        }else if(ProviderCardDetails!= null && ProviderCardDetails.MonthlyEMail == 'true'){
            EmailNotification = 'Monthly';   
        }else if(ProviderCardDetails!= null && ProviderCardDetails.WeeklyEMail == 'true'){
            EmailNotification = 'Weekly';
        }
        //////////////////////////////////////
        // Harkunal:06/04/2021:US3596560:Start
        // Adding a boolean attribute value as the last attribute to "true" to the Field Details method of the card data of the table to enable the fields for auto doc reporting.
        //////////////////////////////////////
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'First Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.FirstName) ? ProviderCardDetails.FirstName : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.LastName) ? ProviderCardDetails.LastName : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Date of Birth', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.BirthDate) ? birthdate : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'SSN', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.SSN) ? formatSSNumber : '--', 'outputText'));
        ////Second Row    
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Gender', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.Gender) ? ProviderCardDetails.Gender : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Address', ProviderCardDetails != null && String.isNotEmpty(completeAddress) ? completeAddress: '--', 'unescapedHtml'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Email Address', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.EmailAddress) ? ProviderCardDetails.EmailAddress : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Phone', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.HomePhone) ? ProviderCardDetails.HomePhone : '--', 'outputText'));
        ////Third Row
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Role', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.Role) ? ProviderCardDetails.Role : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Height & Weight', ProviderCardDetails != null && Heightweight!=''? Heightweight: '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Group Name', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.GroupName) ? ProviderCardDetails.GroupName : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Group Number', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.OfferCode) ? ProviderCardDetails.OfferCode : '--', 'outputText'));
        ////4th Row
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Client Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.ClientName) ? ProviderCardDetails.ClientName : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Email Notification', ProviderCardDetails != null && String.isNotEmpty(EmailNotification)?EmailNotification:'--' , 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Status', ProviderCardDetails != null && String.isnotEmpty(ProviderCardDetails.Status) ? ProviderCardDetails.Status : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Program Start Date', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.ProgramStartDate) ? programstartdate : '--', 'outputText'));
        ////5th Row
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Program Cancel Date', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.CancelledDateTime) ? programCanceldate : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Max Daily Earnings', ProviderCardDetails != null&& String.isNotempty(ProviderCardDetails.MaxDailyEarnings) && ProviderCardDetails.MaxDailyEarnings != '0'? MotionCommonUtil.dollerconvertion(ProviderCardDetails.MaxDailyEarnings) : '--', 'outputText'));
        //cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Plan Type', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.PlanType) ? ProviderCardDetails.PlanType : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'First Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.FirstName) ? ProviderCardDetails.FirstName : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Last Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.LastName) ? ProviderCardDetails.LastName : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Date of Birth', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.BirthDate) ? birthdate : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'SSN', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.SSN) ? formatSSNumber : '--', 'outputText',true));
        //Second Row    
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Gender', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.Gender) ? ProviderCardDetails.Gender : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Address', ProviderCardDetails != null && String.isNotEmpty(completeAddress) ? completeAddress: '--', 'unescapedHtml',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Email Address', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.EmailAddress) ? ProviderCardDetails.EmailAddress : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Phone', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.HomePhone) ? ProviderCardDetails.HomePhone : '--', 'outputText',true));
        //Third Row
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Role', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.Role) ? ProviderCardDetails.Role : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Height & Weight', ProviderCardDetails != null && Heightweight!=''? Heightweight: '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Group Name', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.GroupName) ? ProviderCardDetails.GroupName : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Group Number', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.OfferCode) ? ProviderCardDetails.OfferCode : '--', 'outputText',true));
        //4th Row
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Client Name', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.ClientName) ? ProviderCardDetails.ClientName : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Email Notification', ProviderCardDetails != null && String.isNotEmpty(EmailNotification)?EmailNotification:'--' , 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Status', ProviderCardDetails != null && String.isnotEmpty(ProviderCardDetails.Status) ? ProviderCardDetails.Status : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Program Start Date', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.ProgramStartDate) ? programstartdate : '--', 'outputText',true));
        //5th Row
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Program Cancel Date', ProviderCardDetails != null && String.isNotEmpty(ProviderCardDetails.CancelledDateTime) ? programCanceldate : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Max Daily Earnings', ProviderCardDetails != null&& String.isNotempty(ProviderCardDetails.MaxDailyEarnings) && ProviderCardDetails.MaxDailyEarnings != '0'? MotionCommonUtil.dollerconvertion(ProviderCardDetails.MaxDailyEarnings) : '--', 'outputText',true));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,disabled,'Plan Type', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.PlanType) ? ProviderCardDetails.PlanType : '--', 'outputText',true));
        
        ///////////////////////////////////
        //Harkunal:06/04/2021:US3596560:End
        ///////////////////////////////////
        
        providerDetails.cardData = cardData;
       return providerDetails;
    }
    public static ACET_AutoDocUtil.CardDetails setHilightpanelData(MotionMemberDetailWrapper ProviderCardDetails,MotionMemberDetailWrapper.MemberConsoleInfo consoleCardDetails, String providerType) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_2-of-12';
       List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > (); 
        
        String AddressLine1 = (String.isNotEmpty(ProviderCardDetails.Address)? ProviderCardDetails.Address+'<br/>' : '');
        String AddressCity 	= (String.isNotEmpty(ProviderCardDetails.City)	? ProviderCardDetails.City+',' : '');
        String AddressState = (String.isNotEmpty(ProviderCardDetails.State)	 ? ProviderCardDetails.State : '');
        String AddressZip 	= (String.isNotEmpty(ProviderCardDetails.ZipCode) ? ProviderCardDetails.ZipCode : '');
       String completeAddress = AddressLine1+AddressCity+' '+AddressState+' '+AddressZip;
       completeAddress = (completeAddress!= '  '?completeAddress:'--');
        String birthdate = MotionCommonUtil.Dateconversion(ProviderCardDetails.BirthDate); 
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Dependent Code', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.Relationship) ? ProviderCardDetails.Relationship : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Device Model', consoleCardDetails != null && String.isNotempty(consoleCardDetails.DeviceModelPaired) ? consoleCardDetails.DeviceModelPaired : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Address', ProviderCardDetails != null && String.isNotempty(completeAddress) ? completeAddress : '--', 'unescapedHtml'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Date of Birth', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.BirthDate) ? birthdate : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Email Address', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.EmailAddress) ? ProviderCardDetails.EmailAddress : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Derm ID', ProviderCardDetails != null && String.isNotempty(ProviderCardDetails.RegisteredMemberID) ? ProviderCardDetails.RegisteredMemberID : '--', 'outputText'));        
        providerDetails.cardData = cardData;
        return providerDetails;
    }
    
      public static ACET_AutoDocUtil.CardDetails setHilightpanelDatamemberNotFound(MotionMemberDetailWrapper.MemberNotFound ProviderCardDetails, String providerType) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_2-of-12';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();  
         String Address=ProviderCardDetails.State+ ' '+ ProviderCardDetails.Zip;
          String dateofBirth=ProviderCardDetails.dob!= null && ProviderCardDetails.dob != ''?MotionCommonUtil.DateConversion(ProviderCardDetails.dob):'';
          cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Dependent Code', ProviderCardDetails != null  ? '--': '--', 'outputText'));
         cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Device Model', ProviderCardDetails != null  ? '--': '--', 'outputText'));
       cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Address', ProviderCardDetails != null && ProviderCardDetails.State != null ? Address : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Date of Birth', ProviderCardDetails != null && ProviderCardDetails.dob != null ? dateofBirth : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'Email Address', ProviderCardDetails != null && ProviderCardDetails.EmailAddress != null ?  ProviderCardDetails.EmailAddress : '--', 'outputText'));
          cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,false,'DERM ID', ProviderCardDetails != null  ? '--': '--', 'outputText'));
        providerDetails.cardData = cardData;
        System.debug('#$#$#Card Details'+providerDetails);
        return providerDetails;
    }
    
    public static ACET_AutoDocUtil.CardDetails setGeneralInfopanelDatamemberNotFound(MotionMemberDetailWrapper.MemberNotFound ProviderCardDetails, String providerType) {
        ACET_AutoDocUtil.CardDetails providerDetails = new ACET_AutoDocUtil.CardDetails();
        providerDetails.componentOrder = 1;
        providerDetails.type = 'card';
        providerDetails.noOfColumns = 'slds-size_3-of-12';
        providerDetails.componentName = 'General Information: Individual';
        String dateofBirth=ProviderCardDetails.dob != null && ProviderCardDetails.dob!= ''?MotionCommonUtil.DateConversion(ProviderCardDetails.dob):'';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();  
        
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Group Name', ProviderCardDetails != null && ProviderCardDetails.GroupName != null ? ProviderCardDetails.GroupName : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Group Number', ProviderCardDetails != null && ProviderCardDetails.GroupNumber != null ? ProviderCardDetails.GroupNumber : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Member ID', ProviderCardDetails != null && ProviderCardDetails.memberId != '' ? '--' : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Name', ProviderCardDetails != null && ProviderCardDetails.fname != '' ? ProviderCardDetails.fname : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Date of Birth', ProviderCardDetails != null && ProviderCardDetails.dob != null ? dateofBirth : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'State', ProviderCardDetails != null && ProviderCardDetails.State != null ? ProviderCardDetails.State : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Zip Code', ProviderCardDetails != null && ProviderCardDetails.Zip != null ? ProviderCardDetails.Zip : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Phone Number', ProviderCardDetails != null && ProviderCardDetails.Phone != '' ? ProviderCardDetails.Phone : '--', 'outputText'));
        cardData.add(new ACET_AutoDocUtil.FieldDetails(false,false,true,'Email Address', ProviderCardDetails != null && ProviderCardDetails.EmailAddress != null ?  ProviderCardDetails.EmailAddress : '--', 'outputText'));  
        providerDetails.cardData = cardData;
        return providerDetails;
    }

    /**
     * method name: fetchMemberPlainWaiverRecords
     */
    @AuraEnabled
    public static  ACET_AutoDocUtil.TableDetails  fetchMemberPlainWaiverRecords(String dermID, String reqPageNum, Boolean isCheckboxDisabled){
       Motion_PlanWaiver medicalWaivers;
        ACET_AutoDocUtil.TableDetails planWaiverDetails;
        HttpResponse response;
       response = MOTION_MemberAPIServiceController.memberDetailMedicalwaiverService(dermID,reqPageNum);
           if(response.getStatusCode() == 200 ){
               system.debug('inside response mdeciall waiver');
               medicalWaivers=Motion_PlanWaiver.parse(response.getBody());    
           }
               
        planWaiverDetails=setCredentialData(medicalWaivers, isCheckboxDisabled);
        System.debug('planWaiverDetails::::'+planWaiverDetails);
        return planWaiverDetails;        
    }

    /**
     * method to search a person account
     * create person account if not found in search
     * update person account if member has mismatch data
     */
    @AuraEnabled 
    public static Interaction__c searchAndCreateMotionPersonAccount(String dermID, String memberEligibleId, String firstName, String lastName, String memberEmail, String memberDob, String interactType, String phoneNo ){
      
        System.debug('Values to create account:::'+ firstName +' , '+lastName+' , '+ memberDob+' , '+ memberEmail+' , '+ interactType+' , '+ dermID +' , '+ memberEligibleId);
        Interaction__c interaction;
        Account ACETAccount = MOTION_CreatePersonAccountInteractions.createAccount(firstName, lastName, memberDob, memberEmail, 'Member', dermID, memberEligibleId, phoneNo);
        System.debug('Account details: '+ACETAccount);
        if(ACETAccount.Id != null){
            interaction = MOTION_CreatePersonAccountInteractions.createInteraction(interactType, 'Member', ACETAccount, '');
            if(interaction != null && interaction.Id != null){
                interaction = MOTION_CreatePersonAccountInteractions.queryInteraction(interaction.Id);    
            }            
            if(interaction.Id != null){
                return interaction;
            }
        }
        return interaction;
    }
    
    public class SnapshotDataData {
        @AuraEnabled public ACET_AutoDocUtil.CardDetails digitalThermoticesdetails;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails diviceInfodetails;
        @auraEnabled public ACET_AutoDocUtil.CardDetails demographicdetails;
        @auraEnabled public ACET_AutoDocUtil.CardDetails Hightpaneldetails;  
        @AuraEnabled public ACET_AutoDocUtil.TableDetails PlanWaiverDetails;
        
        @AuraEnabled public ACET_AutoDocUtil.CardDetails highlightsPanelMemberNotFound;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails generalInfoPanelMemberNotFound;
        
        @AuraEnabled public MotionMemberDetailWrapper.MemberNotFoundHighlightsHeader highlightsHeader;
        @AuraEnabled public Interaction__c InteractionRecord;
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String errorMessage;
    }
    /**
     * Get User Information
     */
    @AuraEnabled 
    public static User getUser(){
     // query current user information  
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
    /**
     * Get Organization details
     */
     @AuraEnabled 
    public static  Organization getorg(){
     // query to get Organization
      Organization org = [SELECT id, IsSandbox FROM Organization];
        return org;
    }
    
    @AuraEnabled
    public static ACETLGT_HighlightPanelInfo prepareHighlightsInfo(String highlightPanelInfo, String mbrGrpNo, String mbrGrpName){
        System.debug('highlightPanelInfo in class:: '+highlightPanelInfo);
        ACETLGT_HighlightPanelInfo hpInfo= new ACETLGT_HighlightPanelInfo();
        String dateOfBirth;
        Map<String,Object> hisData;
        Integer memAge;
        String originatorName;
        String subjectName;
        
        List<Object> hList = (List<Object>)JSON.deserializeUntyped('['+highlightPanelInfo+']');        
        for(Object fld : hList){
            if((Map<String,Object>)fld !=null){    //Harkunal:06/14/2021:TA1074512:Added:To handle Null pointer exception
                hisData = (Map<String,Object>)fld;
                System.debug('-----Member information Highlights Data----->'+hisData);
                
                
                if (hisData != null && !hisData.IsEmpty() && hisData.get('Originator__r') != null){
                    System.debug('hisData.MemberId: '+ hisData.get('Originator__r'));
                    for(Object objFld : (List<Object>)JSON.deserializeUntyped('['+JSON.serialize(hisData.get('Originator__r'))+']')){
                        Map<String,Object> mbrMap = (Map<String,Object>)objFld;
                        hisData.put('MemberId', mbrMap.get('AccountId'));
                        hisData.put('MemberDOB', mbrMap.get('Birthdate'));
                        hisData.put('subjectID', mbrMap.get('Id'));                   
                    }                
                }
                hisData.put('GroupNumber', mbrGrpNo);
                hisData.put('GroupName', mbrGrpName);
                System.debug('final value of hisData:'+hisData);			
                hpInfo = (ACETLGT_HighlightPanelInfo) System.JSON.deserialize(JSON.serialize(hisData), ACETLGT_HighlightPanelInfo.class);
            }               //Harkunal:06/14/2021:TA1074512:Added:To handle Null pointer exception
        }
        return hpInfo;
    }
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails setDermInquiryInformations(){    	
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentName='DERM Inquiry';
		affTable.autodocHeaderName='DERM Inquiry';
        affTable.caseItemsEnabled=true;
        affTable.tableHeaders = new List < String > {'Action'};
        List <ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        for(Motion_Inquiry_Information__mdt motionInquiryDetails: [Select Id, MasterLabel,DeveloperName,Inquiry_Type__c,Order__c,Inquiry_Action__c from  Motion_Inquiry_Information__mdt WHERE Inquiry_Type__c='Derm' ORDER BY Order__c]){
        	ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                 List < ACET_AutoDocUtil.rowColumnData > rowColumns = new List < ACET_AutoDocUtil.rowColumnData > (); 
            	rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', motionInquiryDetails.Inquiry_Action__c,true));
            tableRow.rowColumnData = rowColumns;
				tableRow.uniqueKey = String.valueOf(motionInquiryDetails);            
                tableRows.add(tableRow);        
        }
        affTable.tableBody = tableRows;
        return affTable;    
    }
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails setConsoleInquiryInformations(){
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentName='Console Inquiry';
		affTable.autodocHeaderName='Console Inquiry';
        affTable.caseItemsEnabled=true;
        affTable.tableHeaders = new List < String > {'Action'};
        List <ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        for(Motion_Inquiry_Information__mdt motionInquiryDetails: [Select Id, MasterLabel,DeveloperName,Inquiry_Type__c,Order__c,Inquiry_Action__c from  Motion_Inquiry_Information__mdt WHERE Inquiry_Type__c='Console' ORDER BY Order__c]){
        	ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            	List < ACET_AutoDocUtil.rowColumnData > rowColumns = new List < ACET_AutoDocUtil.rowColumnData > (); 
            	rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', motionInquiryDetails.Inquiry_Action__c,true));
            tableRow.rowColumnData = rowColumns;
				tableRow.uniqueKey = String.valueOf(motionInquiryDetails);            
                tableRows.add(tableRow);
        }
        affTable.tableBody = tableRows;
        return affTable;    
    }
	
	@AuraEnabled
    public static Boolean setMemInteractions(string intId, string memId){

        System.debug('intID: '+intId+', memId: '+memId);
        Boolean isSuccess = false;        
        Interaction__c intRec = [Select Id, Name, Third_Party__c, Originator__c From Interaction__c Where Id=: intId];
        if (intRec != null){
            intRec.Originator__c = memId;
            intRec.Third_Party__c = null;
            upsert intRec;

            if (intRec != null)
                isSuccess = true;                
        }       

        return isSuccess;
    }
    
    @AuraEnabled
    public static Boolean setTPInteractions(string intId, string subjectId, String origVal){

        System.debug('intID: '+intId+', subjectId: '+subjectId+', origVal: '+origVal);
        Boolean isSuccess = false;
        String tpId = null;
        if(subjectId != null){
		
            List<Third_Party_Originator__c> TPOriginatorList = [SELECT Id, Third_Party__r.Id, Third_Party__r.FullName__c  FROM Third_Party_Originator__c WHERE Subject__c =:SubjectId];        
					
        	if(!TPOriginatorList.isEmpty() && origVal != null){
            	for(Third_Party_Originator__c TPOriginator : TPOriginatorList){
                	if(TPOriginator.Third_Party__r.FullName__c == origVal){
                    	tpId = TPOriginator.Third_Party__r.Id;
                    }
            	}
        	}
        }
        
        Interaction__c intRec = [Select Id, Name, Third_Party__c, Originator__c From Interaction__c Where Id=: intId];
        if (intRec != null){
            intRec.Originator__c = null;
            intRec.Third_Party__c = tpId;
            upsert intRec;

            if (intRec != null)
                isSuccess = true;							 
        }       
        return isSuccess;
    }
    
}