public with sharing class ETSBE_AttchmtWrapper {
	@auraEnabled
    public string fileId { get; set; }
    @auraEnabled
    public string attchId { get; set; }
    @auraEnabled
    public string fileName { get; set; }
    @auraEnabled
    public string fdsFileName { get; set; }    
    @auraEnabled
    public DateTime createdDate { get; set; }
	@auraEnabled
    public String Description  { get; set; }    
    @auraEnabled
    public string fileType { get; set; }
    @auraEnabled
    public boolean isContent { get; set; }
    @auraEnabled
    public boolean isAttachment { get; set; }    
}