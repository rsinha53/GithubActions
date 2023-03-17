public class ACETLGT_ContractDetailController {
 public class DetailResultWrapper {
  @AuraEnabled public string NTypeList {
   get;
   set;
  }
  @AuraEnabled public string pricingSetId {
   get;
   set;
  }
  @AuraEnabled Public List < ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement > lstAgreementDetail {
   get;
   set;
  }
  @AuraEnabled Public ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement AgreementDetail {
   get;
   set;
  }
 }
 @AuraEnabled
 Public static DetailResultWrapper GetMedProvAgreementWebservice(string ProviderId, string TaxId, string providerTINTypeCode, string addressId,
  string addressTypeCode, string ContractHeaderId, string ContractDetailId, string NetworkId, string NetworkScheduleId, string BenefitPlanId) {
  ACETLGT_GetMedProvAgreementWebservice medw = new ACETLGT_GetMedProvAgreementWebservice();
  string pricingSetId = '';
  ACETWSCalloutResult GetMPACalloutResult = medw.GetProvider(ProviderId, TaxId, providerTINTypeCode, addressId, addressTypeCode, ContractHeaderId, ContractDetailId, NetworkId, NetworkScheduleId, BenefitPlanId);
  ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement AgreementDetail = (ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement) GetMPACalloutResult.Response;
  list < ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement > lstAgreementDetail = new list < ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement > ();
  lstAgreementDetail.add(AgreementDetail);
  for (ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement l: lstAgreementDetail) {
   if (l.PricingSet.id != null)
    pricingSetId = l.PricingSet.id;
  }
  String NTypeList = '';
  if (AgreementDetail != null && AgreementDetail.network != null && AgreementDetail.network.typeCode != null) {
   for (String NTypeCode: AgreementDetail.network.typeCode) {
    system.debug('NTypeCode***' + NTypeCode);
    NTypeList += NTypeCode + ',';
   }
   NTypeList = !String.isBlank(NTypeList) ? NTypeList.substring(0, NTypeList.length() - 1) : '';
  }
  DetailResultWrapper dtw = new DetailResultWrapper();
  dtw.NTypeList = NTypeList;
  dtw.pricingSetId = pricingSetId;
  dtw.lstAgreementDetail = new List < ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement > ();
  dtw.lstAgreementDetail.addAll(lstAgreementDetail);
  dtw.AgreementDetail = new ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement();
  dtw.AgreementDetail = AgreementDetail;
      system.debug('dtw===>'+dtw);
  return dtw;
 }
}