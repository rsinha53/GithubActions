/**
 * @description       : US3385722 - Doc360 Document Search Request Wrapper
 * @author            : Raviteja
 * @group             : Team Styx
 * @last modified on  : 06-16-2021
 * @last modified by  : Raviteja
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   06-08-2021   Raviteja       Initial Version
**/
public with sharing class ACETFindDoc360SearchRequest {
   public String indexName{get;set;}
    public Criteria criteria{get;set;}
   public Integer startRow{get;set;}
   public Integer totalRecords{get;set;}
    public class Criteria{
        public list<Filters> filterClauses;
    }
    public class Filters{
        public String type{get;set;}
        public String name{get;set;}
        public String value{get;set;}
        public Range range{get;set;}
        public list<String> values{get;set;}
    }
    public class Range{
        public String gte{get;set;}
        public String lte{get;set;}
        public String gt{get;set;}
        public String lt{get;set;}
    }
}