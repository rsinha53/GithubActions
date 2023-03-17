/* This class related to "ACETMembersClaimSearch Visual Force Page"
Developed By: Prakash Swain
Date created:08/11/2016
Rally User Stories ID: US335825
Task ID: TA1016961
*/

public class ACETMemberClaimSearchController {

public String searchBy{get;set;}
    public String dateOfService{get;set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    public String status{get;set;}
    public Boolean deductible{get;set;}
    public String inNetwork{get;set;}
    public String claimnumber{get;set;}
    public boolean claimnumberhide{get;set;}
    public String claimtype{get;set;}
    public boolean startdatedisabled{get;set;}
    public boolean enddatedisabled{get;set;}
    public boolean  dateofservicedisabled {get;set;}
    public boolean taxidhide{get;set;}
    public String taxid{get;set;}
    public String AuthorizationNumber{get;set;}
    public String ReferralNumber{get;set;}
    public boolean authnumberhide{get;set;}
    public String casenumber{get;set;}
    public boolean casenumberhide{get;set;}
    public boolean networkstatushide{get;set;}
    public boolean deductiblehide{get;set;}
    public boolean claimtypehide{get;set;}
    //Constructor Class
    public ACETMemberClaimSearchController()
    {
        claimnumberhide = false;
        
        casenumberhide = false;
        networkstatushide=true;
        startdatedisabled=true;
        enddatedisabled=true;
        dateofservicedisabled =true;
        deductiblehide=true;
        taxidhide=true;
        inNetwork='All';
        claimtype='All';
        claimtypehide=true;
    }
    
    public PageReference clear()
    {
        startDate = null;
        enddate = null;
        deductible =false;
        inNetwork = 'All';
        taxidhide= null;
        dateOfService = 'Date Range';
        searchBy = 'Subject';
        claimtype='All';
        searchbyaction();
        return null;
    }

    public PageReference search()
    {
        
        return null;
    }
    
    public PageReference cancel()
    {
      return null;
    }
    public PageReference searchbyaction() {
        claimnumber = '';
        AuthorizationNumber='';
        casenumber ='';
        if(searchBy == 'ClaimNumber'){
            claimnumberhide = true;
            startdatedisabled = false;
            enddatedisabled = false;
            dateofservicedisabled = false;
            
            casenumberhide = false;
            networkstatushide=false;
            taxidhide=false;
            deductiblehide=false;
            claimtypehide=false;
        }
       
        else if(searchBy == 'CaseNumber'){
            casenumberhide=true;
            claimnumberhide = false;
           startdatedisabled = false;
            enddatedisabled = false;
            dateofservicedisabled = false;
            networkstatushide=false;
            taxidhide=false;
            deductiblehide=false;
            claimtypehide=false;
        }
        
        else if(searchby=='AuthorizationNumber'){
        claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            casenumberhide = false;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=true;
         }
         else if(searchby=='referralnumber'){
        claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            casenumberhide = false;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=true;
         }
         
       
         else {
        claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            casenumberhide = false;
            taxidhide=true;
            deductiblehide=true;
            claimtypehide=true;
         }
        return null;
    }
    
    public PageReference dateServiceChange()
    {
        startdatedisabled = true;
        enddatedisabled = true;
        if(dateOfService == 'Day'){
            startDate = Date.today();
            endDate = Date.Today();
            enddatedisabled=false;
            
        }
        else if(dateOfService == 'ThisYear'){
            Date dt = Date.today();
            startDate = Date.newInstance(dt.year(), 1, 1);
            endDate = Date.newInstance(dt.year(), 12, 31);
        }
        else if(dateOfService == 'LastYear'){
            Date dt = Date.today();
            startDate = Date.newInstance(dt.year()-1, 1, 1);
            endDate = Date.newInstance(dt.year()-1, 12, 31);
        }
        else
        {
            startDate = null;
            endDate = null;
        }
        return null;
    }
}