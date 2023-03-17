public without sharing class ACETSNIMemberInformation {
  Public Static void createMemberInformation(list<Account> lstPersonAccnts,string polId,string typeOFOper,Map<Id,List<String>> existingPolicyDetails, Boolean onshoreRestricted) {
	    system.debug('createMemberInformation------');
		list<Account> lstPAWoMemInfo = new list<Account>();
        Map<Id,Account> lstExstingMemInfo = new Map<Id,Account>();
        Map<Id,Id> mapAccMemInfo = new Map<Id,Id>();
		if(typeOFOper == 'update'){
			system.debug('createMemberInformation-----11-');

			map<string,Account> mapPAcc = new map<string,Account>();
			for(Account perAcc: lstPersonAccnts){
			   mapPAcc.put(perAcc.id,perAcc);
			}
			system.debug('createMemberInformation-----mapPAcc-'+mapPAcc);
			list<string> lstMemCheck = new list<string>();
			for(Member_Information__c memInfo :[select id,Account__c from Member_Information__c where Account__c IN : mapPAcc.keyset()]){
				lstMemCheck.add(memInfo.Account__c);
                mapAccMemInfo.put(memInfo.Account__c,memInfo.Id);
            }
            //if(lstMemCheck.size()>0){
            for(string key : mapPAcc.keyset()){
                if(! lstMemCheck.contains(key)){
                    lstPAWoMemInfo.add(mapPAcc.get(key));
                }
               else if(lstMemCheck.contains(key)){
                       lstExstingMemInfo.put(mapAccMemInfo.get(key),mapPAcc.get(key));
                   }
               }
            //}
		}
		 system.debug('createMemberInformation-----22--- v1--lstPAWoMemInfo-'+lstPAWoMemInfo);
		if(typeOFOper == 'insert'){
		   lstPAWoMemInfo.addAll(lstPersonAccnts);
		}
        if(lstPAWoMemInfo.size()>0){
		system.debug('createMemberInformation-----33-');
			 list<Member_Information__c> lstMemInf = new list<Member_Information__c>();
			 Boolean isPolicyUhg = ACETUtility.checkUHGPolicy(polId);
			 for(Account act:lstPAWoMemInfo){

				Member_Information__c memInfo = new Member_Information__c();
				memInfo.Name = act.firstName+' '+act.lastName;
				memInfo.Account__c = act.id;
                memInfo.Gender__c = act.Gender__pc;
                 if(onshoreRestricted){
                     memInfo.Onshore_Restriction__c = 'Yes';
                 } else {
                     memInfo.Onshore_Restriction__c = 'No';
                 }
                if(existingPolicyDetails.get(act != null ? act.Id:null ) != null &&  existingPolicyDetails.get(act != null ? act.Id:null ).size() >0){
                    for(String restrction : existingPolicyDetails.get(act.Id)){
                        if(restrction == 'Yes'){
                            memInfo.UHG_Restriction__c = 'Yes';
                            break;
                        }
                        else
                            memInfo.UHG_Restriction__c = 'No';
                    }
                }

			   lstMemInf.add(memInfo);
			 }
			 if(! lstMemInf.isEmpty()){
				 system.debug('createMemberInformation-----44-');
				insert lstMemInf;
			 }
		}
        if(lstExstingMemInfo.size()>0){
            list<Member_Information__c> updateLstMemInf = new list<Member_Information__c>();
            for(Id act:lstExstingMemInfo.keyset()){
                Member_Information__c memInfo = new Member_Information__c();
                memInfo.Id =act;
                memInfo.Gender__c = (lstExstingMemInfo.get(act)).Gender__pc;
                System.debug('existingPolicyDetails==='+existingPolicyDetails);
                System.debug('lstExstingMemInfo.get(act)==='+lstExstingMemInfo.get(act));
                if(onshoreRestricted){
                     memInfo.Onshore_Restriction__c = 'Yes';
                 } else {
                     memInfo.Onshore_Restriction__c = 'No';
                 }
                if(existingPolicyDetails.get(lstExstingMemInfo.get(act) != null ? lstExstingMemInfo.get(act).Id : null).size() >0){
                    System.debug('restrictionList'+existingPolicyDetails.get(lstExstingMemInfo.get(act).Id));
                    for(String restrction : existingPolicyDetails.get(lstExstingMemInfo.get(act).Id)){
                        if(restrction == 'Yes'){
                            memInfo.UHG_Restriction__c = 'Yes';
                            break;
                        }
                        else{
                            memInfo.UHG_Restriction__c = 'No';
                        }
                    }

                }
                SYstem.debug('memInfo=='+memInfo);
                updateLstMemInf.add(memInfo);
            }
            if(! updateLstMemInf.isEmpty()){
				 system.debug('createMemberInformation-----44-memInfo');
				update updateLstMemInf;
			 }


    }
    }
}