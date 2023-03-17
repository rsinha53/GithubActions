public with sharing class ACETRestrictionController {
    public ACETCallTopicsDataWrapper wrapper{get;set;}
    public string IsPageRestrict{get;set;}
    public string restrictedMessage{get;set;} 
   public ACETRestrictionController()
   {
      IsPageRestrict = ApexPages.currentPage().getParameters().get('blockpage');
      
      if(IsPageRestrict == 'group')
          restrictedMessage = label.ACETGroupPageRestrictionMessage;
      else
          restrictedMessage = label.ACETMemberPageRestrictionMessage;    
      
   }
}