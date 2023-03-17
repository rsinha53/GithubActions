public class ACETGroupDetailsWrapper
{
    public String UHCBS{get;set;}
    public String GroupName{get;set;}
    public String GroupStatus{get;set;}
    public String ServiceTeam{get;set;}
    public String EffectiveStartDate{get;set;}
    public String RiskManagement{get;set;}
    public String RatingMethod{get;set;}
    public String RenewalDate{get;set;}
    public String RelationshipType{get;set;}
    public string groupSName{get;set;}
    
    public ACETGroupDetailsWrapper(String UHCBS,String GroupName,String GroupStatus,String ServiceTeam,String EffectiveStartDate,String RiskManagement,String RatingMethod,String RenewalDate,string RelationshipType,string groupSName)
    {
       this.UHCBS = UHCBS;
       this.GroupName = GroupName;
       this.GroupStatus = GroupStatus;
       this.ServiceTeam = ServiceTeam;
       this.EffectiveStartDate = EffectiveStartDate;
       this.RiskManagement = RiskManagement;
       this.RatingMethod = RatingMethod;
       this.RenewalDate = RenewalDate;
       this.RelationshipType = RelationshipType;
       this.groupSName = groupSName;
                     
    }
    
    
 }