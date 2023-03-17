public without sharing class ACETLGT_Covid19Controller {
    @AuraEnabled
    public static List<String> getCovidVaccineDetails(String subjectFNm, String subjectLNm,String dob){
     if(subjectFNm!=null&&subjectLNm!=null&&dob!=null){
       List<String> covidDetails=ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(subjectFNm, subjectLNm, dob);
         system.debug('~~~After callout covidDetails'+covidDetails);
       return covidDetails;
     }else{
       return null;
     }
    }

}