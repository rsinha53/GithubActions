/*
 * Created by Sai Kolluru for COVID-19 Vaccine API service
 */
public class ACETLGT_CovidVaccineAPIService {

    public static List<String> getCovidVaccineIndicatorDetails(String subjectFNm, String subjectLNm,String dob){
        Map<String,Object> resultMap = new Map<String,Object>();
        ACETLGT_CovidVaccineIndicatorWrapper wrapper;
        List<String> doseStr = new List<String>();
        try{
            // generating the request body
            List<String> values;
            if(!String.isBlank(subjectFNm) && String.isNotBlank(dob)){
                String[] dobArr = dob.split('/');
                if(dobArr != null && dobArr.size() > 2){
                    dob = dobArr[2] + '-' + dobArr[0] + '-' + dobArr[1];
                }
                subjectFNm = (!String.isBlank(subjectFNm))?subjectFNm.touppercase():'';
                subjectLNm = (!String.isBlank(subjectLNm))?subjectLNm.touppercase():'';
                values = new List<String>{subjectFNm,subjectLNm,dob};
                    
                StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'COVID19_API_Request'];	//	getting the request template
                String strBody = requestTemplate.Body.toString();
                System.debug('strBody : ' + strBody);
                String body = String.format(strBody, values).replaceAll('~', '{');	// replacing the template values with actuals
                System.debug('template after replacing with actual values : ' + body);
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Covid19_ImmunizationEndpoint', body, null);
                HttpResponse response = wsCallOutFW.getResponse();
                system.debug('response before serialize'+response);
                // Checking the status code is success
                if(response.getStatusCode() == 200){
                    String resp = response.getBody();
                    wrapper = (ACETLGT_CovidVaccineIndicatorWrapper) JSON.deserialize(resp, ACETLGT_CovidVaccineIndicatorWrapper.class);

                    if(wrapper != null && wrapper.data != null && wrapper.data.immunization_indv != null){
                        system.debug('wrapper'+wrapper);
                        List<ACETLGT_CovidVaccineIndicatorWrapper.Immunization_indv> immIndv =  wrapper.data.immunization_indv;
                        if(immIndv != null && !immIndv.isEmpty()){
                            List<ACETLGT_CovidVaccineIndicatorWrapper.Immunizations> immunizations = immIndv[0].immunizations;
                            for(ACETLGT_CovidVaccineIndicatorWrapper.Immunizations indv: immunizations){
                                String dosageString = '';
                                String dostDt = formatDate(indv.service_dt);
                                dosageString = 'Dose #'+indv.dose_number+' - '+indv.manufacturer+' - '+dostDt;
                                doseStr.add(dosageString);
                            }
                            doseStr.sort();
                            system.debug('UI wrapper'+wrapper);
                        }else{
                            doseStr.add('No vaccination information found.');
                        }

                    }else{
                        doseStr.add('No vaccination information found.');
                    }
                    system.debug('response'+wrapper);
                }
                else{
                    system.debug('COVID-19 Vaccine Indicator API is failing ::' + response.getStatusCode() +'-'+ response.getBody());
                }
            }
        }catch(Exception ex){
            System.debug('ERROR at COVID-19 Vaccine Indicator API is failing : ' + ex.getMessage());
        }
        system.debug('doseStr'+doseStr);
        return doseStr;            
    }

    public static String formatDate(String dateStr){
        String frmtdDate= '';
        if(dateStr != null){
            frmtdDate = dateStr.split('-')[1] + '/' +dateStr.split('-')[2] +'/'+dateStr.split('-')[0];
        }
        return frmtdDate;
    }
}