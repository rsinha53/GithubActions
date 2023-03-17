public class ACETSNIEligibilityUpdAPIRequest {
    //String acetFamilyId,String initialCallDate,String policyID,String memberID,String adviserMsId,String advisorFullName,String designation,String acetIndividualId,string firstName,string lastName, string dob,string newlyDiagnosed,string medicalCondition,string behavioralCondition,string relationship,string isPrimary
    //public Family familyobj{get; set;}
    public class Family{
        public String acetFamilyId;
        public String initialCallDate;
        public String policyID;
        public String memberID;
        public String adviserMsId;
        public String advisorFullName;
        public String designation;
        public String lob;
        public String accountType;
        
        public Family(){
            lob='Do not Send';
            accountType='Do not Send';
        }
               
    }
    //public list<member> members{get; set;}
    public class member{
        public String acetIndividualId;
        public string firstName;
        public string lastName; 
        public string dob;
        public integer newlyDiagnosed;
        public string medicalCondition;
        public string behavioralCondition;
        public string relationship;
        public integer isPrimary;
    }
    
    public string prepareRequestBody(ACETSNIEligibilityUpdAPIRequest.Family fam,list<ACETSNIEligibilityUpdAPIRequest.member> mems){
        string json = '';
        //system.debug('prepareRequestBody-----------');
        if(fam != null ){
            json = getFamilyNode(fam);
            if(json != '' && mems != null){
                json =  '{ '+json +','+ getmemberNode(mems)+ '}';  
            }
        }
        system.debug('prepareRequestBody---------json---');
        system.debug(json);
        return json;
    }
    public string getFamilyNode(ACETSNIEligibilityUpdAPIRequest.Family fam){
        
        string jsonFam = '';
        if(fam.acetFamilyId != null ){
            jsonFam = '"family": {'+
                '"acetFamilyId": "'+fam.acetFamilyId+'"' ;
            if(fam.initialCallDate != ' ')
                jsonFam += ',"initialCallDate": "' +fam.initialCallDate+'"' ;           
           
                jsonFam += ',"policies": [ ' +
                    '{';
                            if(fam.policyID != ' ') jsonFam +='"policyID": "'+fam.policyID+'"' ;
                            if(fam.memberID != ' '){
                                if(fam.policyID != ' ')
                                  jsonFam += ',"memberID": "'+fam.memberID+'"' ;
                                else
                                    jsonFam += '"memberID": "'+fam.memberID+'"' ;
                            }
                jsonFam +=    '}';
                jsonFam +=  ']' ;
           
            if(fam.accountType != 'Do not Send') //As if they would be blank or null, We need to send to Elligibility Hub as blank or null.
            {
                if(fam.accountType==null) jsonFam += ',"accountType": '+fam.accountType ;
                else jsonFam += ',"accountType": "' +fam.accountType+'"' ;
            }
                
            if(fam.adviserMsId != ' ') {
                if(fam.advisorFullName.equalsIgnoreCase('Unassigned')) jsonFam += ',"adviserMsId": ""' ;
                else jsonFam += ',"adviserMsId": "' +fam.adviserMsId+'"' ;
            }
            if(fam.advisorFullName != ' ') jsonFam += ',"advisorFullName": "' +fam.advisorFullName+'"' ;
            if(fam.lob != 'Do not Send'){
                 if(fam.lob==null) jsonFam += ',"lob": '+fam.lob ;
                 else jsonFam += ',"lob": "' +fam.lob+'"' ;
            }   //As if they would be blank, We need to send to Elligibility Hub as Blank.
               
            if(String.isNotBlank(fam.designation)) {
                jsonFam += ',"designation": "' +fam.designation +'"' ;    
            }
            jsonFam += '}' ;
            
        }
        system.debug('eligibility hub getFamilyNode ----'+jsonFam);
        // system.debug(jsonFam);
        return jsonFam;
    }
    public string getmemberNode(list<ACETSNIEligibilityUpdAPIRequest.member> mems){
        string jsonMem = '';
        System.debug('=======mems========>>'+ mems.size() );
        if(mems.size() > 0){
            for(Integer i=0 ; i < mems.size() ;i++){
                
                ACETSNIEligibilityUpdAPIRequest.member curMem = mems[i];
                System.debug('=======mems=1=======>>'+ mems[i] );
                if(curMem != null && curMem.acetIndividualId != null && curMem.acetIndividualId != '')
                {
                    System.debug('=======mems=3=======>>'+ mems[i] );
                    jsonMem+= '{' +
                        '"acetIndividualId": "'+ curMem.acetIndividualId+'"' ;
                    if(curMem.firstName != ' ' ){
                      if(curMem.firstName != null)   
                          jsonMem+= ',"firstName": "'+curMem.firstName+'"' ;
                        else
                          jsonMem+= ',"firstName": '+curMem.firstName;
                    }
                    if(curMem.lastName != ' '  ) {
                        if(curMem.lastName != null)   
                             jsonMem+= ',"lastName": "'+ curMem.lastName+'"' ;
                        else
                             jsonMem+= ',"lastName": '+ curMem.lastName;
                    }
                    if(curMem.dob != ' '  ){
                        if(curMem.dob != null)
                         jsonMem+= ',"dob":"'+ curMem.dob+'"' ;
                        else
                         jsonMem+= ',"dob":'+ curMem.dob;
                    }
                    if(curMem.newlyDiagnosed == 0 ||  curMem.newlyDiagnosed == 1 ){
                         jsonMem+= ',"newlyDiagnosed":'+ curMem.newlyDiagnosed;
                    }
                    if(curMem.medicalCondition != ' ' && (curMem.isPrimary == 0 || curMem.isPrimary == 1 )) {
                          jsonMem+=',"medicalCondition":"'+ curMem.medicalCondition+'"';
                    }
                    if(curMem.behavioralCondition != ' ' ){
                        if(curMem.behavioralCondition != null)
                           jsonMem+= ',"behavioralCondition":"'+ curMem.behavioralCondition+'"' ;
                        else
                            jsonMem+= ',"behavioralCondition":'+ curMem.behavioralCondition;
                    }
                    if(curMem.relationship != ' '  ) {
                      if(curMem.relationship != null)
                        jsonMem+= ',"relationship":"'+ curMem.relationship+'"' ;
                      else  
                       jsonMem+= ',"relationship":'+ curMem.relationship;
                    }
                    if(curMem.isPrimary == 0 || curMem.isPrimary == 1)
                        jsonMem+= ',"isPrimary":'+ curMem.isPrimary ;
                    jsonMem += '}' ;
                    
                    if(i < mems.size() - 1)
                        jsonMem += ',' ;
                    
                }
            }
            if(jsonMem != '' && jsonMem != null){
                jsonMem = '"members": ['+
                    jsonMem +
                    ']' ;
            }
            system.debug('eligibility hub getMemberNode ----'+jsonMem);
            return jsonMem;
        }else{
            return null;
        }
    }
}