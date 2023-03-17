public with sharing class Motion_MemberSearchUtil {

    // Contains methods related to autodoc

    // Table Classes
    public static RowColumnData setRowColumnData( String fieldType, String fieldValue,String lastName,String firstName, String RegisteredMemberId,String EligibleMemberId, String email, String dob, String groupName, String groupNo, String phone) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
         	rowColumnData.lastName=lastName;
            rowColumnData.firstName=firstName;
            rowColumnData.dob = dob;
            rowColumnData.email = email;
            rowColumnData.RegisteredMemberId=RegisteredMemberId;
            rowColumnData.EligibleMemberId=EligibleMemberId;
            rowColumnData.groupName = groupName;
            rowColumnData.groupNo = groupNo;
            rowColumnData.phone = phone;
            
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if('unescapedHtml'.equalsIgnoreCase(fieldType)){
            rowColumnData.isUnescapedHtml = true;
        }else {
            rowColumnData.isOutputText = true;
        }
        return rowColumnData;
    }

    public class TableDetails {
        @AuraEnabled public String type;
       
        @AuraEnabled public String componentHeaderVal;
       
        @AuraEnabled public List < String > tableHeaders;
        @AuraEnabled public List < TableRow > tableBody;
        @AuraEnabled public Pagination paginations;

        

        public TableDetails() {
            type = 'table';
           
            tableHeaders = new List < String > ();
            tableBody = new List < TableRow > ();
            paginations = new Pagination();
            //componentOrder = 0;
        }
    }

    public class TableRow {
      
        @AuraEnabled public String rowDetails;        
        @AuraEnabled public List < RowColumnData > rowColumnData;
        @AuraEnabled public List < PlanWaiverRowColumnData> PlanWaiverRowColumnData;
        @AuraEnabled public Pagination paginations;
    }
    
    public class PlanWaiverRowColumnData {
        @AuraEnabled public String fieldType;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String Status ;
        @AuraEnabled public String WaiverType;
        @AuraEnabled public String StartDate ;
        @AuraEnabled public String EndDate ;
        @AuraEnabled public String EnteredBy ;
        @AuraEnabled public String DateEntered ;
         @AuraEnabled public String ClientAdminNotes  ;
        
        
        @AuraEnabled public Boolean isOutputText;
        @AuraEnabled public Boolean isLink;
        @AuraEnabled public Boolean isIcon;
      
    }
    
    

    public class RowColumnData {
        @AuraEnabled public String fieldType;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String lastName;
        @AuraEnabled public String firstName;
        @AuraEnabled public String RegisteredMemberId;
        @AuraEnabled public String EligibleMemberId;
        @AuraEnabled public String dob;
        @AuraEnabled public String email;
        @AuraEnabled public String groupName;
        @AuraEnabled public String groupNo;
        @AuraEnabled public String phone;
        
        
        @AuraEnabled public Boolean isOutputText;
        @AuraEnabled public Boolean isLink;
        @AuraEnabled public Boolean isIcon;
        @AuraEnabled public Boolean isUnescapedHtml;
    }
    public class Pagination{
        // Service level Pagination
        @AuraEnabled public Integer startNumber;
        @AuraEnabled public Integer endNumber;
        @AuraEnabled public Integer recordCount;
        @AuraEnabled public Integer noOfPages;
        @AuraEnabled public Integer numberOfRecordsPerPage;
    }

// Card Classes
    public class CardDetails {
        @AuraEnabled public String type;
        @AuraEnabled public String componentName;
        @AuraEnabled public String noOfColumns;
        @AuraEnabled public List < FieldDetails > cardData;
        @AuraEnabled public Integer componentOrder;
    }
   
    public class FieldDetails {
     
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String fieldType;
		
        public FieldDetails(String fn, String fv, String ft) {
           
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            
        }
    }
    

}