/* 
 * @name         :   ACETPlanBenefitOverview
 * @description  :   This component  is created for the re-design of benefit language for provider and group flows 
                     and it shows the benefit language accordions.
                     US820398, US849338, US843686
 * @author       :   Divya Sindhu B
 * @createddate  :   03-11-2017
 * @lastmodifiedby:
 *
 */
public with sharing class ACETBenefitsRedesignDetails {
    
    public Map<String, List<LanguageSubSectionWrapper>> benefitCodeStatusMap {get; set;}
    public String hippaBenefitCodeJSON {get; set;}
    public Map<String, String> benefitCodeKeyMap {get; set;}
    public Map<String, accumulatorWrapperSection> accumulatorWrapMap {get; set;}
    
    public class LanguageSubSectionWrapper implements Comparable {
        public String benefitLevel {get; set;}
        public String benefitLevelDescription {get; set;}
        public String benefitCodeGeneralLanguage {get; set;}
        public String benefitCodeLanguage {get; set;} 
        public String benefitVersion {get; set;} 
        public String ageFrom {get; set;} 
        public String ageFromDuration {get; set;}   
        public String ageThrough {get; set;}    
        public String ageThroughDuration {get; set;}   
        public String networkId;  
        public String relationshipCode;
        public String coverageIndicator; 
        public Integer compareTo(Object ObjToCompare) {
            return benefitLevel.CompareTo(((LanguageSubSectionWrapper)ObjToCompare).benefitLevel);
        }
    }
    
    public class accumulatorWrapperSection {
        public List<ACETGroupPlanBenefitWrapper.Accumulator> accumList {get; set;}
        public List<SelectOption> dateRangesBenefit {get; set;}
        public string dateVersion {get; set;}
        public Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion> mapDateVersionMap {get;set;}    
    
        public accumulatorWrapperSection() {
            accumList = new List<ACETGroupPlanBenefitWrapper.Accumulator>();
            dateRangesBenefit = new List<selectOption>();
            mapDateVersionMap = new Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion>();
        }
    }
}