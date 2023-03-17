public class ACETSNIICUEDataParser {
   // public String requestType{get; set;}
    public String memFirstName{get; set;}
    public String memLastName{get; set;}
    public String memberDOB {get; set;}
    public String memberId{get; set;}
    Public String policy{get; set;}
    Public String serviceRef{get; set;}
    Public String HSCId{get; set;}
    Public String xrefID{get; set;}
    Public String statusDetail{get; set;}
    Public String reviewPriority{get; set;}
    Public String serviceSetting{get; set;}
    Public String startDate{get; set;}
    Public String endDate{get; set;}
    Public String hostSystemTimeStamp{get; set;}
    Public String expectedAdmissionDate{get; set;}
    Public String expectedDischargeDate{get; set;}
    Public String actualAdmissionDate{get; set;}
    Public String actualDischargeDate{get; set;}
    Public list<ProviderInfo> providerInfos{get; set;}
    Public list<ServiceLine> serviceLines{get; set;}
    Public list<String> diagnosisCodes{get; set;}
    public without sharing class ProviderInfo{
        Public String providerUniqueID{get; set;}
        Public list<String> providerRole{get; set;}
        Public String providerNetworkStatus{get; set;}
        Public String providerName{get; set;}
    }
    public without sharing class ServiceLine{
        Public String serviceLinkUniqueId{get; set;}
        Public String decisionOutCome{get; set;}
        Public String decisionSubType{get; set;}
        Public String decisionReason{get; set;}
        Public String procedureCode{get; set;}
        Public String procedureDescription{get; set;}
    }
    public static ACETSNIICUEDataParser parse(String json) {
        return (ACETSNIICUEDataParser) System.JSON.deserialize(json, ACETSNIICUEDataParser.class);
    }
}