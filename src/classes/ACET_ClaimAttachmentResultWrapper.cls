public class ACET_ClaimAttachmentResultWrapper {
    
    public String ticketNumber;
    public String ticketType;
    public String fileNm;
    public String reportTypeCode;
    public String reportTypeDesc;
    public String attachmentId;
    
    
    public static List < ACET_ClaimAttachmentResultWrapper > parse(String json) {
        return (List < ACET_ClaimAttachmentResultWrapper > ) System.JSON.deserialize(json, List < ACET_ClaimAttachmentResultWrapper > .class);
    }
}