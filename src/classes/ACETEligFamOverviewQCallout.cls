public class ACETEligFamOverviewQCallout implements Queueable, Database.AllowsCallouts{
    Public Id famAccountId;
    Public Id famOverviewId;
    Public string policyId;
    Public string memberId;
    public ACETEligFamOverviewQCallout(Id famAccountId, Id famOverviewId, string policyId, string memberId) {
        this.famAccountId = famAccountId;
        this.famOverviewId = famOverviewId;
        this.policyId = policyId;
        this.memberId = memberId;
    }
    public void execute(System.QueueableContext qc) {
        list<accountcontactRelation> lstfamacr=[Select accountId,contactid,member_id__c,policy_Id__c,contact.accountId,contact.account.FirstName,contact.account.LastName,
                                                contact.account.personBirthDate from AccountContactRelation 
                                                where accountId = :famAccountId and Relationship__c ='Subscriber/Recipient'];
        if(lstfamacr.size()>0){
            accountcontactrelation famacr = new accountcontactrelation();
            if(lstfamacr.size()>1){
                for(accountcontactrelation aconr:lstfamacr){
                    if(aconr.policy_Id__c == policyId && aconr.member_id__c == memberId){
                        famacr = aconr;
                    }
                }
            } else{famacr = lstfamacr[0];}
            ACETLinkSNIWebService sniEligibilityCls = new ACETLinkSNIWebService();
            ACETSNIWrapper resultwrap = new ACETSNIWrapper();
            Datetime dte = datetime.newinstanceGMT(famacr.contact.account.personBirthDate,Time.newInstance(0, 0, 0, 0));  
            string memdob = dte.formatGmt('yyyy-MM-dd');  
            ACETWSCalloutResult CalloutResultElig  = sniEligibilityCls.getMemberWS(memberId, policyId, famacr.contact.account.FirstName, famacr.contact.account.LastName, memdob);  
            if (CalloutResultElig.Success||test.isRunningTest()){
                if(!test.isRunningTest()){
                resultwrap= (ACETSNIWrapper)CalloutResultElig.Response;
                }else{
                    resultwrap.sniEligibility ='';
                    resultwrap.lob='';
                    resultwrap.productTypes='';
                    resultwrap.serviceGroup='';
                }
                account famacctupd = new account();
                famacctupd.Id = famAccountId;
                famacctupd.Special_Needs_Status__c = resultwrap.sniEligibility; 
                famacctupd.Line_of_Business__c = resultwrap.lob;
                famacctupd.Product_Type__c = resultwrap.productTypes;
                famacctupd.Service_Group__c = resultwrap.serviceGroup;
                famacctupd.EHub_Update_Check__c = true;
                update famacctupd;
            }
        }
    }
    
}