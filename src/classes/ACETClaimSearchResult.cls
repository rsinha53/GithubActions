public class ACETClaimSearchResult implements Comparable
{
    public String PHIRestriction { set; get; }
    public String ClaimID { set; get; }
    public String SourceClaimId { set; get; }
    public String TaxID { set; get; }
    public String Provider { set; get; }
    public String Network { set; get; }
    public String ServiceStart { set; get; }
    public String ServiceEnd { set; get; }
    public String TotalCharged { set; get; }
    public String TotalPaid { set; get; }
    public String Deductible { set; get; }
    public String Processed { set; get; }
    public String BenefitLevel { set; get; }
    public String Status { set; get; }
    public String Statuscode { set; get; }
    public String claimEventStatusDate { set; get; }
    public String PrimaryDiagnosisCode { set; get; }
    public String levelTypeCode { set; get; }
    public String claimEvtType{get;set;}
    public string patientResponsibility{get;set;}
    public string claimType{get;set;}
    Public string Encounters{get;set;}
    
    public Boolean selected {get; set;}
    Public String claimEncounterIndicator{get;set;}

   
    public ACETClaimSearchResult()
    {
        selected = false;
    } 
    
    public static String SortBy = 'ClaimID';
    public static String SortOrder = 'Asc';
    
    
    public Integer compareTo(Object objToCompare)
    {
        ACETClaimSearchResult ClaimToCompare = (ACETClaimSearchResult)objToCompare;
        Integer CompareResult = 0;
        if (SortOrder == 'Asc')
        {
            if (SortBy == 'PHIRestriction')
            {
                CompareResult = PHIRestriction.compareTo(ClaimToCompare.PHIRestriction);
            }
            else if (SortBy == 'ClaimID')
            {
                CompareResult = ClaimID.compareTo(ClaimToCompare.ClaimID);
            }
            else if (SortBy == 'TaxID')
            {
                CompareResult = TaxID.compareTo(ClaimToCompare.TaxID);
            }
            else if (SortBy == 'Provider')
            {
                CompareResult = Provider.compareTo(ClaimToCompare.Provider);
            }
            else if (SortBy == 'Network')
            {
                CompareResult = Network.compareTo(ClaimToCompare.Network);
            }
          //  else if (SortBy == 'ServiceStart')
          //  {
          // //     CompareResult = ServiceStart.compareTo(ClaimToCompare.ServiceStart);
          //  }
           // else if (SortBy == 'ServiceEnd')
           // {
                 
               
               
               // CompareResult = ServiceEnd.compareTo(ClaimToCompare.ServiceEnd);
          //  }
          //  else if (SortBy == 'TotalCharged')
         //   {
         //       CompareResult = TotalCharged.compareTo(ClaimToCompare.TotalCharged);
          //  }
        //    else if (SortBy == 'TotalPaid')
        //    {
        //        CompareResult = TotalPaid.compareTo(ClaimToCompare.TotalPaid);
        //    }
        //     else if (SortBy == 'Deductible')
        //    {
        //        CompareResult = Deductible.compareTo(ClaimToCompare.Deductible);
       //     }
        //    else if (SortBy == 'Processed')
        //    {
        //        CompareResult = Processed.compareTo(ClaimToCompare.Processed);
        //    }
            else if (SortBy == 'BenefitLevel')
            {
                CompareResult = BenefitLevel.compareTo(ClaimToCompare.BenefitLevel);
            }
            else if (SortBy == 'Status')
            {
                CompareResult = Status.compareTo(ClaimToCompare.Status);
            }
            else
            {
                CompareResult = PrimaryDiagnosisCode.compareTo(ClaimToCompare.PrimaryDiagnosisCode);
            }
        }
        else
        {
            if (SortBy == 'PHIRestriction')
            {
                CompareResult = ClaimToCompare.PHIRestriction.compareTo(PHIRestriction);
            }
            else if (SortBy == 'ClaimID')
            {
                CompareResult = ClaimToCompare.ClaimID.compareTo(ClaimID);
            }
            else if (SortBy == 'TaxID')
            {
                CompareResult = ClaimToCompare.TaxID.compareTo(TaxID);
            }
            else if (SortBy == 'Provider')
            {
                CompareResult = ClaimToCompare.Provider.compareTo(Provider);
            }
            else if (SortBy == 'Network')
            {
                CompareResult = ClaimToCompare.Network.compareTo(Network);
            }
          //  else if (SortBy == 'ServiceStart')
          //  {
           //     CompareResult = ClaimToCompare.ServiceStart.compareTo(ServiceStart);
         //   }
          //  else if (SortBy == 'ServiceEnd')
         //   {
          //      CompareResult = ClaimToCompare.ServiceEnd.compareTo(ServiceEnd);
           // }
         //   else if (SortBy == 'TotalCharged')
         //   {
          //      CompareResult = ClaimToCompare.TotalCharged.compareTo(TotalCharged);
          //  }
          //  else if (SortBy == 'TotalPaid')
         //   {
         //       CompareResult = ClaimToCompare.TotalPaid.compareTo(TotalPaid);
        //    }
         //     else if (SortBy == 'Deductible')
        //    {
         //       CompareResult = ClaimToCompare.Deductible.compareTo(Deductible);
         //   }
        //    else if (SortBy == 'Processed')
         //   {
        //        CompareResult = ClaimToCompare.Processed.compareTo(Processed);
        //    }
            else if (SortBy == 'BenefitLevel')
            {
                CompareResult = ClaimToCompare.BenefitLevel.compareTo(BenefitLevel);
            }
            else if (SortBy == 'Status')
            {
                CompareResult = ClaimToCompare.Status.compareTo(Status);
            }
            else
            {
                CompareResult = ClaimToCompare.PrimaryDiagnosisCode.compareTo(PrimaryDiagnosisCode);
            }
        }
        return CompareResult;
    }
}