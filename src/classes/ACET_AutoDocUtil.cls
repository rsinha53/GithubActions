// Contains methods related to autodoc
public with sharing class ACET_AutoDocUtil {
    // Table Class
    public static RowColumnData setRowColumnData(String fieldType, String fieldValue) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isCurrencyOutputText = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        return rowColumnData;
    }

    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, Boolean isReportable) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('noRecords'.equalsIgnoreCase(fieldType)) { // US2808569 - Thanish - 27th Oct 2020
            rowColumnData.isNoRecords = true;
        } else if ('ToolTipIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isToolTipIcon = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isCurrencyOutputText = true;
        }
         else {
            rowColumnData.isOutputText = true;
        }
        rowColumnData.isReportable = isReportable;
        return rowColumnData;
    }

    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, String fieldLabel) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        rowColumnData.fieldLabel = fieldLabel;
        rowColumnData.isReportable = true;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('noRecords'.equalsIgnoreCase(fieldType)) { // US3269760 - Thanish - 15th Feb 2021
            rowColumnData.isNoRecords = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
                      rowColumnData.isCurrencyOutputText = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        return rowColumnData;
    }

    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, String fieldLabel, String titleName) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        rowColumnData.fieldLabel = fieldLabel;
        rowColumnData.titleName = titleName;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isCurrencyOutputText = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        return rowColumnData;
    }

    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, String fieldLabel, String titleName, Boolean isReportable) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        rowColumnData.fieldLabel = fieldLabel;
        rowColumnData.titleName = titleName;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isCurrencyOutputText = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        rowColumnData.isReportable = isReportable;
        return rowColumnData;
    }

    //US2992845 - Update Dollar Sign Icon to Match Style Guide - Praveen 21/01/2021
    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, String fieldLabel, String titleName, String tdStyle) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        rowColumnData.fieldLabel = fieldLabel;
        rowColumnData.titleName = titleName;
        rowColumnData.tdStyle = tdStyle;
        if ('link'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isLink = true;
        } else if ('outputText'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isIcon = true;
        } else if ('Accordian'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isAccordian = true;
        } else if ('Currency'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isCurrencyOutputText = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        // Making reporting default for all the cells
        rowColumnData.isReportable = true;
        return rowColumnData;
    }
	//US3269699- Motion Team- This method is used to display the tooltip on the Plan Waivers components
    //iconName - for passing static resource file path
    public static RowColumnData setRowColumnData(String fieldType, String fieldValue, Boolean isReportable, String iconName ) {
        RowColumnData rowColumnData = new RowColumnData();
        rowColumnData.fieldType = fieldType;
        rowColumnData.fieldValue = fieldValue;
        rowColumnData.isReportable = isReportable;
        	rowColumnData.iconName = iconName;    
        if ('ToolTipIcon'.equalsIgnoreCase(fieldType)) {
            rowColumnData.isToolTipIcon = true;
        } else{
        	rowColumnData.isToolTipIcon = false;    
        }
        return rowColumnData;
    }																								   

    public class TableDetails {
        @AuraEnabled public String type;
        @AuraEnabled public String componentName;
        @AuraEnabled public String componentHeaderVal;
        @AuraEnabled public String autodocHeaderName;
        @AuraEnabled public Boolean showComponentName;
        @AuraEnabled public Boolean caseItemsEnabled;
        @AuraEnabled public Boolean showCardStyle;
        @AuraEnabled public Boolean isSortable;
        @AuraEnabled public List < String > tableHeaders;
        @AuraEnabled public List < TableRow > tableBody{get;set;}
        @AuraEnabled public List < TableRow > selectedRows{get;set;} // US3192316 - Thanish - 27th Jan 2021
        @AuraEnabled public Integer componentOrder;
        @AuraEnabled public Integer statusCode;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public String caseItemExtId;

        // Service level Pagination
        @AuraEnabled public Integer startNumber;
        @AuraEnabled public Integer endNumber;
        @AuraEnabled public Integer recordCount;
        @AuraEnabled public Integer noOfPages;

        // US3653575
        @AuraEnabled public String reportingHeader;

        //policyLineNumber
        @AuraEnabled public Integer policyIndex;

        // table hover
        @AuraEnabled public List < HoverHeader > tableHoverHeaders;

        public TableDetails() {
            type = 'table';
            componentName = '';
            autodocHeaderName = '';
            showComponentName = true;
            showCardStyle = true;
            isSortable = false;
            tableHeaders = new List < String > ();
            tableBody = new List < TableRow > ();
            selectedRows = new List < TableRow > (); // US3192316 - Thanish - 27th Jan 2021
            componentOrder = 0;
        }
    }

    public class TableRow {
        @AuraEnabled public Boolean checked {get;set;}
        @AuraEnabled public Boolean resolved {get;set;}
        @AuraEnabled public Boolean linkDisabled {get;set;}
        @AuraEnabled public Boolean checkBoxDisabled {get;set;}
        @AuraEnabled public String rowDetails {get;set;}
        @AuraEnabled public String uniqueKey {get;set;}
        @AuraEnabled public String caseItemsExtId {get;set;}
        @AuraEnabled public List < RowColumnData > rowColumnData {get;set;}
        @AuraEnabled public Object createSRNProviderDetails {get;set;}
        @AuraEnabled public Boolean isChildRow {get;set;}
        @AuraEnabled public Boolean hideChildRow {get;set;}
        @AuraEnabled public Map < String, Object > additionalData {get;set;} //ketki claim service routing
        @AuraEnabled public Boolean isResolvedDisabled = false;
        // US3691213
        @AuraEnabled public Boolean isNoRecords = false;
    }

    public class RowColumnData {
        @AuraEnabled public String fieldType{get;set;}
        @AuraEnabled public String fieldLabel{get;set;}
        @AuraEnabled public String fieldValue{get;set;}
        @AuraEnabled public String autodocFieldValue{get;set;}
        @AuraEnabled public String titleName{get;set;}
        @AuraEnabled public String iconName{get;set;}
        @AuraEnabled public Boolean isOutputText{get;set;}
        @AuraEnabled public Boolean isLink{get;set;}
        @AuraEnabled public Boolean isIcon{get;set;}
        @AuraEnabled public Boolean isNoRecords{get;set;} // US2808569 - Thanish - 27th Oct 2020
        @AuraEnabled public Boolean isAccordian{get;set;}
        @AuraEnabled public Boolean isResolved{get;set;}
        @AuraEnabled public Boolean isToolTipIcon{get;set;}
        @AuraEnabled public Boolean isReportable{get;set;}
        @AuraEnabled public String tdStyle{get;set;} //US2992845 - Update Dollar Sign Icon to Match Style Guide - Praveen 21/01/2021
        @AuraEnabled public Boolean isCurrencyOutputText{get;set;}
        @AuraEnabled public String currencySymbol{get;set;}
    }

    // hover header
    public class HoverHeader {
        @AuraEnabled public String popupId;
        @AuraEnabled public String headerValue;
        @AuraEnabled public String hoverDescription;
        @AuraEnabled public String hoverWidth;
        @AuraEnabled public Boolean hasHover;
        @AuraEnabled public Boolean alignRight;
        @AuraEnabled public List < String > hoverDescriptionList;

        public HoverHeader() {
            hoverDescriptionList = new List < String > ();
            hasHover = false;
            alignRight = true;
        }
    }

    // Card Classes
    public class CardDetails {
        @AuraEnabled public String type;
        @AuraEnabled public String componentName;
        @AuraEnabled public String noOfColumns;
        @AuraEnabled public List < FieldDetails > cardData;
        @AuraEnabled public Integer componentOrder;
        @AuraEnabled public String caseItemExtId;
        @AuraEnabled public String caseItemsExtId;
        @AuraEnabled public Boolean caseItemsEnabled;
        // US3691213
        @AuraEnabled public String reportingHeader;
    }

    public class FieldDetails {
        @AuraEnabled public Boolean checked;
        @AuraEnabled public Boolean defaultChecked;
        @AuraEnabled public Boolean showCheckbox;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String fieldType;
        @AuraEnabled public Boolean isReportable;
        @AuraEnabled public Boolean hideField;
        // if has hover
        @AuraEnabled public String popupId;
        @AuraEnabled public Boolean isNubbinLeft;
        @AuraEnabled public String moveLeft;
        @AuraEnabled public String moveRight;
        @AuraEnabled public String description;
        @AuraEnabled public List < String > descriptionList;
        @AuraEnabled public String popupWidth;
        @AuraEnabled public String urlLabel;
        @AuraEnabled public String urlValue;
        @AuraEnabled public String name;

        @AuraEnabled public String reportingFieldName;

        @AuraEnabled public Boolean isParent;
        @AuraEnabled public String parentName;
        @AuraEnabled public Boolean isChild;

        // for icon type
        @AuraEnabled public String iconName;
        //for icon Text
        @AuraEnabled public String iconText;
        //for toggle class
        @AuraEnabled public String toggleClass;
        //field Value style
        @AuraEnabled public String fieldValueStyle;
        //field width
        @AuraEnabled public String width;

        public FieldDetails(Boolean c, Boolean dc, Boolean sc, String fn, String fv, String ft) {
            checked = c;
            defaultChecked = dc;
            showCheckbox = sc;
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            isReportable = true;
        }

         public FieldDetails(Boolean c, Boolean dc, Boolean sc, String fn, String fv, String ft, Boolean ip, String pn, Boolean ic) {
            checked = c;
            defaultChecked = dc;
            showCheckbox = sc;
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            isParent = ip;
            parentName = pn;
            isChild = ic;
        }

        public FieldDetails(Boolean c, Boolean dc, Boolean sc, String fn, String fv, String ft, Boolean ir) {
            checked = c;
            defaultChecked = dc;
            showCheckbox = sc;
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            isReportable = ir;
        }

        public FieldDetails(Boolean c, Boolean dc, Boolean sc, String fn, String fv, String ft, Boolean ir, String fvs, String wd) {
            checked = c;
            defaultChecked = dc;
            showCheckbox = sc;
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            isReportable = ir;
            fieldValueStyle = fvs;
            width = wd;
        }

        public FieldDetails(Boolean c, Boolean dc, Boolean sc, String fn, String fv, String ft, String it, Boolean ir, String tc) {
            checked = c;
            defaultChecked = dc;
            showCheckbox = sc;
            fieldName = fn;
            fieldValue = fv;
            fieldType = ft;
            isReportable = ir;
            iconName = it;
            toggleClass = tc;
        }
    }

    public class PaginationInfo {
        public Integer startNo {
            get;
            set;
        }
        public Integer endNo {
            get;
            set;
        }
        public Integer recordCount {
            get;
            set;
        }
        public Integer pageSize {
            get;
            set;
        }
    }

    public static PaginationInfo processPaginationData(Integer startNo, Integer listSize, Integer actualSize, Integer reqSize) {
        PaginationInfo p_Info = new PaginationInfo();

        if (actualSize < reqSize) {
            p_Info.startNo = startNo;
            p_Info.endNo = listSize;
            p_Info.recordCount = listSize;
            p_Info.pageSize = 1;
        } else if (actualSize > reqSize && actualSize > ((startNo + listSize) - 1)) {
            p_Info.startNo = startNo;
            p_Info.endNo = (startNo + listSize) - 1;
            p_Info.recordCount = actualSize;
            p_Info.pageSize = (Integer) Math.ceil((Decimal) actualSize / reqSize);
        } else {
            p_Info.startNo = startNo;
            p_Info.endNo = (startNo + listSize) - 1;
            p_Info.recordCount = (startNo + listSize) - 1;
            p_Info.pageSize = (Integer) Math.ceil((Decimal) actualSize / reqSize);
        }

        return p_Info;
    }

    // US3429736 - Case Item relationship change
    public static Map<String,String> getCaseItemMap(String caseId){
        Map<String,String> returnMap = new Map<String,String>();
        List<Case_Item__c> caseItems = [SELECT  Id, ExternalID__c, Benefit_Level__c, Case__c FROM Case_Item__c WHERE Case__c = :caseId];
        for (Case_Item__c ci : caseItems) {
            if(ci.Benefit_Level__c != null) {
                returnMap.put(ci.ExternalID__c + ci.Benefit_Level__c, ci.Id);   
            } else {
                returnMap.put(ci.ExternalID__c, ci.Id);
            }
        }
        return returnMap;
    }
}