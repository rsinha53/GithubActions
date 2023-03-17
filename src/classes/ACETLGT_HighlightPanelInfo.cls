global class ACETLGT_HighlightPanelInfo {

    //First Level Fields added by Lahiru - US1931823
    @AuraEnabled public String originatorName { get; set; }
    @AuraEnabled public String originatorRel { get; set; }
    @AuraEnabled public String originatorDOB { get; set; }
    @AuraEnabled public String subjectName { get; set; }
    @AuraEnabled public String originatorID { get; set; }
    @AuraEnabled public String subjectID { get; set; }
    @AuraEnabled public String MemberId { get; set; }
    @AuraEnabled public String SubscriberId { get; set; }
    @AuraEnabled public String memberStatus { get; set; }
    @AuraEnabled public String MemberDOB { get; set; }
    @AuraEnabled public String GroupNumber { get; set; }
	@AuraEnabled public String GroupName { get; set; }
    @AuraEnabled public String Network { get; set; }
    @AuraEnabled public String EffectiveDate { get; set; }
    @AuraEnabled public String EndDate { get; set; }
    @AuraEnabled public String benefitBundleOptionId { get; set; }
    @AuraEnabled public String image { get; set; }
    @AuraEnabled public String accumAsOfDate { get; set; }
    @AuraEnabled public String onshoreValue{get;set;}
    @AuraEnabled public String onshoreCode{get;set;}
    @AuraEnabled public String Name{get;set;}
    @AuraEnabled public String EmployerName{get;set;}
    @AuraEnabled public String State{get;set;}
    @AuraEnabled public String ZIP{get;set;}
    @AuraEnabled public String PhoneNumber{get;set;}
    @AuraEnabled public String IsMemberNotfound{get;set;}
    @AuraEnabled public String relationShipCode{get;set;}
  	@AuraEnabled public String subjectRelationCode{get;set;} 
	  @AuraEnabled public String serviceGrp{get;set;} 
	  @AuraEnabled public String accTypes{get;set;} 
   	@AuraEnabled public String SitusState{get;set;}				//Added by Abhinav for US2667418 - Situs state to highlightspanel and case detail
    @AuraEnabled public String Product{get;set;}
//String ss2 = '{"image":"active","accumAsOfDate":"10/14/2019","benefitBundleOptionId":"1738484","EffectiveDate":"10/1/2018","EndDate":"12/31/9999","EnrolleeSurrogateKey":"654667179","GroupNumber":"1168520","GUID":"470b5081-7deb-45be-9b8f-f1a3543efd0f","isActive":true,"isTermed":false,"memberStatus":"ACTIVE","Network":"FREEDOM_CHOICEPLUS","SurrogateKey":"654651892","MemberId":"97161070001","MemberDOB":"2/24/1977"}';
//system.debug((ACETLGT_HighlightPanelInfo) System.JSON.deserialize(ss2, ACETLGT_HighlightPanelInfo.class));

	//Added below code by Abhinav for US3416165 for adding COVID-19 vaccinations details to the Highlights panel
    @AuraEnabled
    public List<String> immunizations{get;set;}
}