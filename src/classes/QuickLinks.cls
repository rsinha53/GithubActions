public with sharing class QuickLinks{
        public String linkName{get;set;}
        public String linkId{get;set;}
        public QuickLinks(){}
        public QuickLinks(String linkName,String linkId){
            this.linkName = linkName;
            this.linkId = linkId;
        }
    }