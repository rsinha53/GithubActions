public without sharing class ACETCaseDetailController {
    public String casenumber{get; set;}
    public String originalType {get; set;}
    public String originalSubType {get; set;}
    public String CaseOwner {get; set;}
    public String caseCommentString {get; set;}
    public String ExternalIDs {get; set;}
    public String CaseItemStatus{get; set;}
    public List<CaseDataWrapper> caseDataList {get; set;}
    public List<caseitemdata> caseitemList {get; set;}
    public String pageName{get;set;}
   
    public boolean  displayCaseActions {get;set;}//To display the case action and default is 'True'   
    public double Offset{get;set;}
    public ACETCaseDetailController(){
    
    displayCaseActions = false;
    pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
      string IncludePagenames = System.Label.ACETRelatedCasesLabel;   
     if( IncludePagenames.contains(pageName)){  
     //To display the case action will be false on Detail Pages      
               displayCaseActions = false;

            }else{            
     //To display the case action will be false on Detail Pages 
        displayCaseActions = true;
    }
    }
    public void displayCaseComments() { 
        caseDataList = new List<CaseDataWrapper>();
        caseitemList  = new list<caseitemdata>();
     
        list<String> extids = ExternalIDs.split(',');
        list<String> caseitemstatus = CaseItemStatus.split(',');
        
        //iteration starts
        integer i = 0;
        for(string eachExtId:extids ){
        caseitemdata cd = new caseitemdata();
        cd.extId = eachExtId;
        cd.status = caseitemstatus[i];
        i++;
        caseitemList .add(cd);
        }
        //iteration end
        List<String> caseSlit = new List<String>();
        if(caseCommentString != '[]' && String.isNotEmpty(caseCommentString)) {
            caseSlit = caseCommentString.split(',');
            system.debug('caseSlit is '+caseSlit);
            if(!caseSlit.isEmpty()) {
                for(String str: caseSlit) {
                    CaseDataWrapper caseData = new CaseDataWrapper();
                    if(String.isNotEmpty(str)) {
                        List<String> str1 = str.split('<br/>');
                        List<String> aplitStret = str1[0].split('<1>');
                        if(aplitStret.size() >0)
                        {
                        String strSplit1 = aplitStret[0].replace('[','');
                        strSplit1 = strSplit1.replace('(','');
                        strSplit1 = strSplit1.replace('\"','');
                        caseData.createdByName = strSplit1;
                        }
                        system.debug('aplitStret size is '+aplitStret.size());
                        if(aplitStret.size() >1)
                        {
                        String strSplit2 = aplitStret[1];                        
                        
                        String commentsCreatedDate = strSplit2;
                        commentsCreatedDate = commentsCreatedDate.replace('T',' ');
                        commentsCreatedDate = commentsCreatedDate.replace('.000Z','');
                        
                        timeZone tz = UserInfo.getTimeZone();
                        offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
                        DateTime dt = DateTime.valueOf(commentsCreatedDate)+Offset;
                        System.debug(dt);
                        
                        String commentsCreatedDate1 = dt.format('MM/dd/yyyy hh:mm a');
                        System.debug(commentsCreatedDate1);
                        caseData.createdByDate = commentsCreatedDate1;
                        }
                        if(str1.size() > 1){
                        String str12 = str1[1].replace(']','');
                        system.debug('str12 is '+str12);
                        str12 = str12.replace('\"','');
                        str12 = str12.replace('\\n',' ');
                        caseData.commentBodyCase = str12;
                        }
                    }
                    caseDataList.add(caseData);
                }   
            }
        }
        
    }
    
    public class CaseDataWrapper {
        public string createdByDate {get; set;}
        public string createdByName {get; set;}
        public string commentBodyCase {get; set;}
    }
    
    public class CaseItemData {
        public string extId{get; set;}
        public string status{get; set;}
    }
}