@IsTest
public class ETSBE_DynamicDataTableController_Test{
    
    private testmethod static void testmethod3(){
        List<Case> acclist=new List<Case>();
        Case newcase =new Case();
        newcase.subject='test';
                Id caserecid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('BEO').getRecordTypeId();
        newcase.Special_Instructions_Business_Unit__c='test';
        newcase.status='Open';
        newcase.Case_Type__c ='BEO Case';
        newcase.RecordTypeId=caserecid;
        insert newcase;
        Case pcase =new Case();
        pcase.subject='test';
        pcase.Special_Instructions_Business_Unit__c='test';
        pcase.status='Open';
        pcase.ownerid = userinfo.getuserid();
        pcase.priority='Urgent';
        pcase.Case_Type__c ='BEO Case';
        pcase.RecordTypeId=caserecid;
        insert pcase;
        Case ocase =new Case();
        ocase.subject='test';
        ocase.Special_Instructions_Business_Unit__c='test';
        ocase.status='Open';
        ocase.Follow_Up_Date__c=date.today().adddays(-30);
        ocase.ownerid = userinfo.getuserid();
        ocase.priority='Urgent';
        ocase.Case_Type__c ='BEO Case';
        ocase.RecordTypeId=caserecid;
        insert ocase;
         newcase =[select  id,CaseNumber,Case_Age__c,CreatedBy.Name,recordtype.name,Status,IsEscalated,
                   Follow_Up_Date__c,Subject_Name__c,Group_Name__c,Department__c,Special_Instructions_Subject__c,
                   CreatedDate,SLA__c,Task_Category_Subtype_Desc__c,Owner.Name from Case 
                   where  id=: newcase.id];
        
        pcase =[select  id,CaseNumber,Case_Age__c,CreatedBy.Name,recordtype.name,Status,IsEscalated,
                Follow_Up_Date__c,Subject_Name__c,Group_Name__c,Department__c,Special_Instructions_Subject__c,
                CreatedDate,SLA__c,Task_Category_Subtype_Desc__c,Owner.Name from Case 
                where id=: pcase.id];
        Interaction__c inter = new Interaction__c();
        Id intrecid = Schema.SObjectType.Interaction__c.getRecordTypeInfosByDeveloperName().get('BEO_Interaction').getRecordTypeId();
        inter.RecordTypeId =intrecid;
        inter.current_status__c='Open';
        inter.Evt_Recvd_Dt_Time__c=date.today();
        insert inter;
        
        ETSBE_DynamicDataTableController.getFieldSet1('Case','My_Cases');
        ETSBE_DynamicDataTableController.getFieldSet('Case','My_Cases');
        ETSBE_DynamicDataTableController.getFieldSet('','My_Cases'); 
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('USD');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('CAD');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('EUR');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('GBP');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('JPY');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('KRW');
        ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('CNY');
      
        string JSONData3=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'test','',true,25);
        string JSONData4=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'test','',false,25);
        string JSONData6=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber','tesr','test','',false,25);
        string JSONData5=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'','',true,25);
        string IntJSONData1=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',true,25);
        string IntJSONData3=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,25);
        string IntJSONData2=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'','',true,25);
        string IntJSONData5=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,25);
        string IntJSONData6=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'None','test22',false,25);
        ETSBE_DynamicDataTableController.updateCase(pcase.id) ;
    }

    private testmethod static void tabletestMethod(){
        
        Id AdminProfileID = [Select Id From profile Where Name = 'System Administrator' Limit 1].Id;
        User userRec = new User(
            email='acettest@optum.com',
            profileid = AdminProfileID ,
            UserName='beoadmintest9@acet.optum.com',
            alias='Admin',
            TimeZoneSidKey='America/New_York',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            LanguageLocaleKey='en_US',
            FirstName = 'testAdminFirstName',
            LastName = 'testAdminLastName',
            IsActive = true );
        insert userRec;
        
        System.runAs(userRec){
            List<Case> acclist=new List<Case>();
            Case newcase =new Case();
            newcase.subject='test';
            Id caserecid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('BEO').getRecordTypeId();
            newcase.Special_Instructions_Business_Unit__c='test';
            newcase.status='Open';
            newcase.Case_Type__c ='BEO Case';
            newcase.RecordTypeId=caserecid;
            insert newcase;
            Case pcase =new Case();
            pcase.subject='test';
            pcase.Special_Instructions_Business_Unit__c='test';
            pcase.status='Open';
            pcase.ownerid = userinfo.getuserid();
            pcase.priority='Urgent';
            pcase.Case_Type__c ='BEO Case';
            pcase.RecordTypeId=caserecid;
            insert pcase;
            Case ocase =new Case();
            ocase.subject='test';
            ocase.Special_Instructions_Business_Unit__c='test';
            ocase.status='Open';
            ocase.Follow_Up_Date__c=date.today().adddays(-30);
            ocase.ownerid = userinfo.getuserid();
            ocase.priority='Urgent';
            ocase.Case_Type__c ='BEO Case';
            ocase.RecordTypeId=caserecid;
            insert ocase;
            
            newcase =[select  id,CaseNumber,Case_Age__c,CreatedBy.Name,recordtype.name,Status,IsEscalated,
                      Follow_Up_Date__c,Subject_Name__c,Group_Name__c,Department__c,Special_Instructions_Subject__c,
                      CreatedDate,SLA__c,Task_Category_Subtype_Desc__c,Owner.Name from Case 
                      where  id=: newcase.id];
            
            pcase =[select  id,CaseNumber,Case_Age__c,CreatedBy.Name,recordtype.name,Status,IsEscalated,
                    Follow_Up_Date__c,Subject_Name__c,Group_Name__c,Department__c,Special_Instructions_Subject__c,
                    CreatedDate,SLA__c,Task_Category_Subtype_Desc__c,Owner.Name from Case 
                    where id=: pcase.id];
            Interaction__c inter = new Interaction__c();
            Id intrecid = Schema.SObjectType.Interaction__c.getRecordTypeInfosByDeveloperName().get('BEO_Interaction').getRecordTypeId();
            inter.RecordTypeId =intrecid;
            inter.current_status__c='Open';
            inter.Evt_Recvd_Dt_Time__c=date.today();
            insert inter;
            
            ETSBE_DynamicDataTableController.getFieldSet('Case','My_Cases');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('USD');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('CAD');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('EUR');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('GBP');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('JPY');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('KRW');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('CNY');
            ETSBE_DynamicDataTableController.GetCurrencySymbolFromISO('');
            
            string JSONData3=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'test','',true,25);
            string JSONData4=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'test','',false,50);
            string JSONData6=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c","Priority"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,urgent,Owner ID','CaseNumber','tesr','test','',false,25);
            string JSONData5=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'','',true,25);
            
            string IntJSONData1=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',true,50);
            string IntJSONData3=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,50);
            string IntJSONData2=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'','',true,50);
            string IntJSONData5=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,50);
            
            ETSBE_DynamicDataTableController.updateCase(pcase.id) ;
            string JSONData=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c","Priority"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,urgent,Owner ID','CaseNumber',userinfo.getname(),'','',true,25);
            string JSONData1=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',true,50);
            string JSONData2=  ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,50);
            string IntJSONData=ETSBE_DynamicDataTableController.generateDataSet('Interaction__c','["Name","Email_Attached__c","CreatedDate","Owner.Name","Age__c","Current_Status__c","Escalated__c","Follow_Up_Date__c","Evt_Recvd_Dt_Time__c"]','Interaction ID,Email Attached,Created Date,Owner ID,Age,Current Status,Escalated,Follow Up Date,Event Received Date/Time','Name',userinfo.getname(),'test','',false,35);
            string JSONDa=ETSBE_DynamicDataTableController.generateDataSet('Case','["CaseNumber","Case_Age__c","CreatedBy.Name","Status","IsEscalated","Follow_Up_Date__c","Subject_Name__c","Group_Name__c","Department__c","Special_Instructions_Subject__c","CreatedDate","SLA__c","Task_Category_Subtype_Desc__c"]','Case Number,Age,Created By ID,Status,Escalated,Follow Up Date,Subject Name,Group Name,Department,Subject,Created Date,SLA Day,Task Category Subtype,Owner ID','CaseNumber',userinfo.getname(),'None','',true,25);
        }
        
    }
 
    //cover ETSBE_PolicyDetailsResults wrapper
    @isTest
    Static void ETSBE_PolicyDetailsResultsTest(){
        ETSBE_PolicyDetailsResults resultWrapper=new ETSBE_PolicyDetailsResults();
        ETSBE_PolicyDetailsResults.ProviderCoverageLevel covLevel=new ETSBE_PolicyDetailsResults.ProviderCoverageLevel();
        ETSBE_PolicyDetailsResults.policyResults policyRes=new ETSBE_PolicyDetailsResults.policyResults();
        resultWrapper.policyRes=policyRes;
        ETSBE_PolicyDetailsResults.Members membr=new ETSBE_PolicyDetailsResults.Members();
        policyRes.sourceCode='txt';
        policyRes.timelyFilling='tex';
        policyRes.MaintenanceDate='tee';
        policyRes.payerId='2323';
        policyRes.claimsMailingAddress='dsds';
        policyRes.fundingArrangement='dsdda';
        policyRes.sharedSavings='dad';
        policyRes.regionCode='policyRes';
        policyRes.groupName='policyRes@';
        policyRes.marketType='cap';
        policyRes.fundingType='policyRes@';
        policyRes.groupNumber='213213';
        policyRes.productType='ded';
        policyRes.stateOfIssueCode='dsd';
        policyRes.HealthPlanSite='rwr';
        policyRes.productId='dsdsds';
        policyRes.cosmosDivision='dasa';
        policyRes.groupPanelNumber='43243';
        policyRes.homeTelephoneNumber='42321';
        policyRes.isPHSPlan=true;
        policyRes.isMedicarePlan=true;
        policyRes.isMedicaidPlan=true;
        policyRes.isComPlan=false;
        policyRes.claimAddress=false;
        policyRes.showAllFields=false;
        System.assert(policyRes.isMedicaidPlan);
        policyRes.isCdhp=true;
        policyRes.isHsa=true;
        policyRes.xrefId='ddad';       
        covLevel.CoverageLevel='teck';
        covLevel.Success=true;
        covLevel.StatusCode=201;
        covLevel.Message='tecyok';
        covLevel.GroupNumber='te3243ck';        
    }
    
    //cover ETSBE_COBWrapper wrapper
    @isTest
    Static void ETSBE_COBWrapperTest(){
        
        ETSBE_COBWrapper cobWrap=new ETSBE_COBWrapper();
        ETSBE_COBWrapper.Cob cobWraprr=new  ETSBE_COBWrapper.Cob();
        List< ETSBE_COBWrapper.additionalCoverage > adcLst=new List< ETSBE_COBWrapper.additionalCoverage>();
        ETSBE_COBWrapper.additionalCoverage adC=new ETSBE_COBWrapper.additionalCoverage();
        cobWraprr.cobLastUpdate='test';
        cobWraprr.cobUpdateMessage='test';
        cobWraprr.medicareIndicator='test';
        cobWraprr.medicareEntitlementReason='test';
        cobWraprr.cobType='test';
        cobWraprr.otherPrimaryInsurance='Truelee';
        cobWraprr.coverageStartDate='23/03/2020';
        cobWraprr.coverageEndDate='24.44.3939';
        System.assertEquals('24.44.3939', cobWraprr.coverageEndDate);   
        adC.primaryGroupIndicator='sds';
        adC.policyEffectiveDates='sds';
        adC.payerName='sds';
        adC.coverageType='sds';
        adC.policyEffectiveStartDate='sds';
        adcLst.add(adC);
        cobWrap.cob=cobWraprr;
        cobWrap.additionalCoverageList=adcLst;        
    }
    
    //cover ETSBE_TTSCaseWrapper wrapper
    @isTest
    Static void ETSBE_TTSCaseWrapperTest(){
        ETSBE_TTSCaseWrapper wrapdata=new ETSBE_TTSCaseWrapper();
        wrapdata.providerNotFound=true;
        wrapdata.noProviderToSearch=true;
        wrapdata.isOtherSearch=true;
        wrapdata.noMemberToSearch=true;
        wrapdata.mnf='test';
        wrapdata.memberContactId='test22';
        wrapdata.providerContactId='skd';
        wrapdata.Status='oks';
        wrapdata.Interaction='test';
        wrapdata.ContactId='test';
        wrapdata.providerId='test';
        wrapdata.OriginatorName='test';
        wrapdata.OriginatorRelationship='test';
        wrapdata.OriginatorType='test';
        wrapdata.OriginatorPhone='test';
        wrapdata.OriginatorEmail='test';
        wrapdata.OriginatorContactName='test';
        wrapdata.SubjectName='test';
        wrapdata.SubjectType='test';
        wrapdata.SubjectDOB='test';
        wrapdata.SubjectId='test';
        wrapdata.SubjectGroupId='test';
        wrapdata.MisdirectReason='test';
        wrapdata.AddInfoTopic='test';
        wrapdata.AddInfoOrginType='test';
        wrapdata.AddInfoOrginSubType='test';
        wrapdata.CommentPublic='test';
        wrapdata.CommentDesc='test';
        wrapdata.PolicyCount=23;
        wrapdata.CaseCreationFrom='test';
        wrapdata.TaxId='test';
        wrapdata.ttsType='test';
        wrapdata.ttsSubType='test';
        wrapdata.AutoDoc='test';
        wrapdata.AutoDocCaseItems='test';
        System.assert(wrapdata.providerNotFound);          
    }
    
}