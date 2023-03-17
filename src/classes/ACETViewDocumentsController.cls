public class ACETViewDocumentsController {   
    Public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    public boolean DisplayBtn{get;set;}    
    public transient ACETDatatableWrapper DocsDataWrapper {get;set;}
    public string DocumentTypeWSName {get;set;}

    public ACETViewDocumentsController(){
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        DisplayBtn = false;
        //DocsDataWrapper = new ACETDatatableWrapper();
    }

   public void initDocuments(){
   String GroupID ;
       system.debug('AdditionalInfo '+AdditionalInfo);
        if(AdditionalInfo.GroupNumber != null){
         GroupID = AdditionalInfo.GroupNumber;
        }
        else{
        GroupID =AdditionalInfo.groupFlowGroupNumber;
        }
        String  BBundleId = AdditionalInfo.BenefitBundleOptionId; 
       system.debug('bundles '+BBundleId);
        DocsDataWrapper = initDocDatatable(DocumentTypeWSName , GroupID, BBundleId);
         }
    
    Public ACETDatatableWrapper initDocDatatable(String docType, String GroupID, String BBundleId){
        ACETFindDocWebservice findDocService = new ACETFindDocWebservice();
        List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
        
        if(!String.isEmpty(GroupID)){
            ACETFindDocWebservice.documentKey groupIdKey = new ACETFindDocWebservice.documentKey();
            GroupIdKey.value = GroupID ;
            GroupIdKey.name = 'u_grp_id';
            GroupIdKey.dataTypeIndicator = 'string';
            GroupIdKey.operator = '=';
            findDocKeys.add(GroupIdKey);
        }
        
        if(!String.isEmpty(BBundleId)){
            ACETFindDocWebservice.documentKey BBundleIdKey = new ACETFindDocWebservice.documentKey();
            BBundleIdKey.value = BBundleId;
            BBundleIdKey.name = 'u_grp_contr_ben_bndl_opt_id';
            BBundleIdKey.dataTypeIndicator = 'string';
            BBundleIdKey.operator = '=';
            findDocKeys.add(BBundleIdKey);
        }
                
        //change operator to = ANY for WS MultiValue Field
        List<Document_Type_Search_By_Field__mdt> listSearchByFields = [SELECT Document_Type__r.WS_Field_Name__c, WS_MultiValue_Field__c, Document_Type_Field__r.WS_Field_Name__c FROM Document_Type_Search_By_Field__mdt];
       
        for(Document_Type_Search_By_Field__mdt sf : listSearchByFields){
            if(sf.WS_MultiValue_Field__c == true){
             
                for(ACETFindDocWebservice.documentKey docKey : findDocKeys){
                    if(docType == sf.Document_Type__r.WS_Field_Name__c && sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                        docKey.operator += ' ANY';
                    }   
                }   
            }
        }
        
        findDocService.init(docType, findDocKeys);      
        ACETDatatableWrapper DTWrapper = new ACETDatatableWrapper('ACETFindDocWebservice', findDocService);
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Document ID', 'DocumentId')); 
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Name', 'u_grp_nm'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Number', 'u_grp_id'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Group Tax ID', 'u_tin')); 
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Benefit Bundle Option ID', 'u_grp_contr_ben_bndl_opt_id')); 
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Plan Effective Date', 'u_pln_eff_dt')); 
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Created Date/Time', 'u_orig_creation_date')); 
        DTWrapper.InitOnDocumentReady = false;
        DTWrapper.PageSize = 25;    
        DTWrapper.IsSortEnabled = true;
        DTWrapper.DefaultSortBy = 0;
        DTWrapper.DefaultSortDir ='asc';
        return DTWrapper;   
        
    } 

    /**
    * @description US3543138 - Team Styx - Preparing Doc360 Document View URL
    * @author Raviteja | 06-25-2021
    * @return string 
    **/
    @RemoteAction
    public static String getDoc360URL(String documentId, String doctypeWSName){
        return ACETLGT_DocumentController.getdoc360Url(documentId,doctypeWSName);
    }
}