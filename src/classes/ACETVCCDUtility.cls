public class ACETVCCDUtility{
     public static Interaction__c populateVCCDInfo(Interaction__c intraction){
        String vccdParams = ApexPages.currentPage().getParameters().get('vccdParams');
        system.debug('vccdParams in VCCD utility '+vccdParams);
        if(vccdParams != null && vccdParams != ''){
            ACETVCCDInteractionInfo vccdInfo = (ACETVCCDInteractionInfo)JSON.deserialize(vccdParams,ACETVCCDInteractionInfo.class);
            system.debug('vccdInfo >>>> '+vccdInfo);
            if(vccdInfo.callerANI != null){
                intraction.Caller_Id_ANI__c = vccdInfo.callerANI;
            }
                
            intraction.Question_Type__c = vccdInfo.callTopic;
            intraction.TFN_Toll_Free_Number__c = vccdInfo.TFN;
            
            if(vccdInfo.CallerType == 'Member')
                intraction.id__c = vccdInfo.MemberID;
            else if(vccdInfo.CallerType == 'Provider' && vccdinfo.npi != '' && vccdinfo.npi != null )
                intraction.id__c = vccdInfo.MemberID;
            else if(vccdInfo.CallerType == 'Provider' && vccdinfo.TaxID != '' && vccdinfo.TaxID != null)
                intraction.id__c = vccdinfo.TaxID;
            else if(vccdInfo.CallerType == 'Group')
                intraction.id__c = vccdinfo.groupId;
            else if(vccdInfo.CallerType == 'Producer')
                intraction.id__c = vccdInfo.producerId;
                
            intraction.Caller_Type__c = vccdInfo.CallerType;
            if(vccdinfo.CallerID != null){
                intraction.Caller_Id_ANI__c = vccdinfo.CallerID;
            }

            if(vccdinfo.dob != null && vccdinfo.dob != '')
                intraction.Member_Date_of_Birth__c = Date.parse(vccdinfo.dob);//Date.valueof(vccdinfo.MemberDOB);
            intraction.Tax_Id__c = vccdinfo.TaxID;
            intraction.NPI__c = vccdinfo.npi;
            intraction.Member_Id__c = vccdinfo.MemberID;
            intraction.Caller_Type__c = vccdinfo.callerType;
            
            if(!String.isEmpty(vccdinfo.groupId)){
                 intraction.Group_ID__c = vccdinfo.groupId;
            }
            
            if(!String.isEmpty(vccdinfo.ReferralNumber)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ReferralNumber;
            }
            if(!String.isEmpty(vccdinfo.AuthorizationNumber)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.AuthorizationNumber;
            }            
            if(!String.isEmpty(vccdinfo.ClaimID)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ClaimID;
            }            
            
            
            
        }
        return intraction;
    }
    
    public static Interaction__c populateVCCDInfo(Interaction__c intraction, String vccdParams){
        system.debug('vccdParams in VCCD utility '+vccdParams);
        if(vccdParams != null && vccdParams != ''){
            ACETVCCDInteractionInfo vccdInfo = (ACETVCCDInteractionInfo)JSON.deserialize(vccdParams,ACETVCCDInteractionInfo.class);
            system.debug('vccdInfo >>>> '+vccdInfo);
            if(vccdInfo.callerANI != null){
                intraction.Caller_Id_ANI__c = vccdInfo.callerANI;
            }
                
            intraction.Question_Type__c = vccdInfo.callTopic;
            intraction.TFN_Toll_Free_Number__c = vccdInfo.TFN;
            
            if(vccdInfo.CallerType == 'Member')
                intraction.id__c = vccdInfo.MemberID;
            else if(vccdInfo.CallerType == 'Provider' && vccdinfo.npi != '' && vccdinfo.npi != null )
                intraction.id__c = vccdInfo.MemberID;
            else if(vccdInfo.CallerType == 'Provider' && vccdinfo.TaxID != '' && vccdinfo.TaxID != null)
                intraction.id__c = vccdinfo.TaxID;
            else if(vccdInfo.CallerType == 'Group')
                intraction.id__c = vccdinfo.groupId;
            else if(vccdInfo.CallerType == 'Producer')
                intraction.id__c = vccdInfo.producerId;
                
            intraction.Caller_Type__c = vccdInfo.CallerType;
            if(vccdinfo.CallerID != null){
                intraction.Caller_Id_ANI__c = vccdinfo.CallerID;
            }

            if(vccdinfo.dob != null && vccdinfo.dob != '')
                intraction.Member_Date_of_Birth__c = Date.parse(vccdinfo.dob);//Date.valueof(vccdinfo.MemberDOB);
            intraction.Tax_Id__c = vccdinfo.TaxID;
            intraction.NPI__c = vccdinfo.npi;
            intraction.Member_Id__c = vccdinfo.MemberID;
            intraction.Caller_Type__c = vccdinfo.callerType;
            
            if(!String.isEmpty(vccdinfo.groupId)){
                 intraction.Group_ID__c = vccdinfo.groupId;
            }
            
            if(!String.isEmpty(vccdinfo.ReferralNumber)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ReferralNumber;
            }
            if(!String.isEmpty(vccdinfo.AuthorizationNumber)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.AuthorizationNumber;
            }            
            if(!String.isEmpty(vccdinfo.ClaimID)){
                 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ClaimID;
            }            
            
            
            
        }
        if(intraction != null)
        update intraction;
        
        return intraction;
    }
}