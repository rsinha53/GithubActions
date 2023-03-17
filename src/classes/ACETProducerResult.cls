public class ACETProducerResult 
{
     public List<ACETProducerDemography> addresslist{get;set;}
     public ACETProducerDemography addressInfo{get;set;}
     public List<ACETGroupInfoWrapper> producerGrouplist{get;set;}
 
    public String tax_SSN { get; set;}
    public String tax_id { get; set;}
    public String taxSSNType { get; set;}
    public String primaryContactName { get; set;}
    public String effectiveStartDate { get; set; }
    public String groupName { get; set; }
    public id contactid{ get; set;}
    public String CompanyName{ get; set;}
    public String contactType{ get; set;}
    public String interactionId {get;set;}
    public String Id { get; set;}
    public Interaction__c Interaction { get; set;}
    public Contact Subject { get; set;}
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String MiddleInitial {get;set;}
    public String producerId { get; set; }
    public String ProducerType { get; set;}
    public String legacyBrokerCode{ get; set;}
    public String type { get; set;}   
    public string producerEffectiveStartDate{get;set;}
    public string producerEffectiveEndDate{get;set;}
    
    public class ACETProducerDemography
    {
        public String addressType {set; get;}
        public String streetAddress {set; get;}
        public String city {set; get;}
        public String zip {set; get;}
        public String state {set; get;}
        public String phone {set; get;}
        public String country {set; get;}
    }
    
    public class ACETGroupInfoWrapper 
    {
        public String groupNumber{get;set;}
        public String groupName{get;set;}
        public String status{get;set;}
        public String groupStartDate{get;set;}
        public String groupEndDate{get;set;}
    }        
  
       
}