/**
 * @description       : Ancillary Plans Request Wrapper - US3727594
 * @author            : Raviteja
 * @group             : Styx
 * @last modified on  : 08-06-2021
 * @last modified by  : Raviteja
**/
public class ACETAncillaryPlansRequest {
    public SearchInput searchInput;
    public class SearchInput{
        public String identifier;
        public String identifierType;
        public String groupNumber;
        public String benefitBundleOptionId;
        public String asOfDate;
        public Boolean suppressPlanLanguage;
        public SearchInput(){
            this.groupNumber = '';
            this.benefitBundleOptionId = '';
            this.identifier = '';
            this.asOfDate = '';
            this.identifierType = '';
            this.suppressPlanLanguage = false;
        } 
    }    
}