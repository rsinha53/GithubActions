public without sharing class ADBFinancialOverviewUIWrapper {

    @AuraEnabled public Deductible deductible{get;set;}
    @AuraEnabled public OOPMaximums oopMaximums{get;set;}
    @AuraEnabled public CopayMax copay;
    
    public class Deductible{
        @AuraEnabled public DeductibleIndividual individual{get;set;}
        @AuraEnabled public DeductibleFamily family{get;set;}
        @AuraEnabled public String type;
    }
    
    public class OOPMaximums{
        @AuraEnabled public OOPMaximumsIndividual individual{get;set;}
        @AuraEnabled public OOPMaximumsFamily family{get;set;}
        @AuraEnabled public String type;
    }
    
    public class DeductibleIndividual{
        @AuraEnabled public DeductibleAttributes inNetwork;
        @AuraEnabled public DeductibleAttributes outNetwork;        
    }
    
    public class DeductibleAttributes{
        @AuraEnabled public String ytdAmount;//accumulated amount
        @AuraEnabled public String deductibleAmount;//total deductible amount
        @AuraEnabled public String planRemainingDeductibleAmount;        
    }
    
    public class DeductibleFamily{
        @AuraEnabled public DeductibleAttributes inNetwork;
        @AuraEnabled public DeductibleAttributes outNetwork;
    }    
    
    public class OOPMaximumsIndividual{
        @AuraEnabled public OOPMaximumsIndividualAttributes inNetwork;
        @AuraEnabled public OOPMaximumsIndividualAttributes outNetwork;        
    }
    
    public class OOPMaximumsFamily{
        @AuraEnabled public OOPMaximumsFamilyAttributes inNetwork;
        @AuraEnabled public OOPMaximumsFamilyAttributes outNetwork;
    }
    
    public class OOPMaximumsIndividualAttributes{
		@AuraEnabled public String planIndividualOOPRemaining;
        @AuraEnabled public String oopYTDAmount;
        @AuraEnabled public String planIndividualOOP;
                    
        @AuraEnabled public String individualCoreYTD;
        @AuraEnabled public String individualCore;
        @AuraEnabled public String planIndividualCoreRemaining;
    }
    
    public class OOPMaximumsFamilyAttributes{
        @AuraEnabled public String planFamilyOOPRemaining;
        @AuraEnabled public String oopYTDAmount;
        @AuraEnabled public String planFamilyOOP;
            
        @AuraEnabled public String planFamilyCoreRemaining;
        @AuraEnabled public String familyCoreYTD;
        @AuraEnabled public String familyCore;
    }
    
    //	Copay starts
    public class CopayMaxAttributes {
        @AuraEnabled public String ytdAmount;//accumulated amount
        @AuraEnabled public String copayMaxAmount;//total copay amount
        @AuraEnabled public String planRemainingCopayAmount;
    }
    
    public class CopayIndividual{
        @AuraEnabled public CopayMaxAttributes inNetwork;
        @AuraEnabled public CopayMaxAttributes outNetwork;        
    }
    
    public class CopayFamily{
        @AuraEnabled public CopayMaxAttributes inNetwork;
        @AuraEnabled public CopayMaxAttributes outNetwork;        
    }
    
    public class CopayMax{
        @AuraEnabled public CopayIndividual individual{get;set;}
        @AuraEnabled public CopayFamily family{get;set;}
    }
    //	Copay ends
    
}