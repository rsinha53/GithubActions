public class ACETContactHistoryCase
{
    public String SFDCId { get; set; }
    public String CaseNumber { get; set; }
    public String SubjectName { get; set; }
    public String contactName { get; set; }
    public String CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; }
    public String CallTopic { get; set; }
    public String Status { get; set; }
    public String OriginatorType { get; set; }
    public String InteractionType { get; set; }
    public String InteractionSFDCId { get; set; }
    public String InteractionName { get; set; }
    public Integer FullfillmentSize {get; set; }
    public String caseParentId {get; set;}
    public String caseParentNumber {get; set;}
    public String OriginalType {get;set;}
}