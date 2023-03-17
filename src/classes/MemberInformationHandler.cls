public class MemberInformationHandler {
    public static void handleBeforeUpdate(List<Member_Information__c> memInfoList, map<id, Member_Information__c> newMap,map<id, Member_Information__c> oldMap){
        //Newly_Diagnosed_Date__c	, Medical_Condition__c	, Behavioral_Condition__c, Primary__c
        for(Member_Information__c memInfo : memInfoList){
          if( (newMap.get(memInfo.id).Newly_Diagnosed_Date__c != oldMap.get(memInfo.id).Newly_Diagnosed_Date__c ) ||
               (newMap.get(memInfo.id).Medical_Condition__c != oldMap.get(memInfo.id).Medical_Condition__c ) ||
               (newMap.get(memInfo.id).Behavioral_Condition__c != oldMap.get(memInfo.id).Behavioral_Condition__c ) ||
               (newMap.get(memInfo.id).Primary__c != oldMap.get(memInfo.id).Primary__c ) ){
                   memInfo.EHub_Update_Check__c = true;
               } 
		}
    }
   public static void handleAfterInsert(List<Member_Information__c> triggernew, map<id, Member_Information__c> triggerNewMap){
       system.debug('handle after insert -------------');
       map<string,string> mapPrgrmAssnt = new map<string,string>();
       for(Member_Information__c cur : triggernew){
		    if(cur.Program_Associations__c != null){
                // system.debug('id is------------------'+cur.id);
                // system.debug('account id is------------------'+cur.Account__c);
               //system.debug('handleAfterInsert -------11------'+cur.Program_Associations__c);
                mapPrgrmAssnt.put(cur.account__c,cur.Program_Associations__c);
            }
       }
       //system.debug('handleAfterInsert -------11---mapPrgrmAssnt-----'+mapPrgrmAssnt);
	   List<Id>  listIds1 = new List<Id>();
       for(AccountContactRelation curAccConRel : [Select accountId,contactid from AccountContactRelation where contact.accountId IN:mapPrgrmAssnt.keyset()]){
            listIds1.add(curAccConRel.accountId);
           //system.debug('handleAfterInsert -------22------');
       }
	   map<id,account>  mapFamAcc = new map<id,account>();
	   for(Account curAccConRel : [Select id,Program_Associations_RichText__c from Account where id in :listIds1]){
            mapFamAcc.put(curAccConRel.id,curAccConRel); 
           //system.debug('handleAfterInsert -------33------');
       }
	   
	    listIds1 = new List<Id>();
	   map<string,list<AccountContactRelation>>  mapAcConIds = new map<string,list<AccountContactRelation>>();
	   for(AccountContactRelation curAccConRel : [Select accountId,contact.accountId,contact.name from AccountContactRelation where accountId IN:mapFamAcc.keyset()]){
            //system.debug('handleAfterInsert -------44------');
            if(mapAcConIds.containskey(curAccConRel.accountId)){
			    list<AccountContactRelation> lstIds = mapAcConIds.get(curAccConRel.accountId);
				lstIds.add(curAccConRel);
			}
			else{
			   mapAcConIds.put(curAccConRel.accountId, new list<AccountContactRelation>{curAccConRel});
			}
			listIds1.add(curAccConRel.contact.accountId);
           
       }
	   //system.debug('handleAfterInsert -------55------'+listIds1);
	   map<string,string> mapStr = new map<string, string>();
	   for(Member_Information__c memInf :  [select id,Account__c,Program_Associations__c from Member_Information__c where Account__c IN:listIds1]){
	      mapStr.put(memInf.Account__c,memInf.Program_Associations__c);
	   }
       list<account> accToUpdate = new list<account>();   
       for(string accid : mapFamAcc.keyset()){
          // system.debug('handleAfterInsert -------66------');
	      if(mapAcConIds.containskey(accid)){
             // system.debug('handleAfterInsert -------77------');
		     list<AccountContactRelation> lstaccCon = mapAcConIds.get(accid);
			 String pass = '';
			 for(AccountContactRelation str : lstaccCon){
			    if(mapStr.containskey(str.contact.accountId)){
					string name = str.contact.name;
					string prgAss = mapStr.get(str.contact.accountId);
					    system.debug('handleAfterInsert -------99----prgAss-----'+prgAss+'----name-----'+name);
						if(prgAss != null && prgAss != ''){
							pass = '<span style="color:black">'+ name +'</span>'+'-'+prgAss+'<br/>'+pass+' ';
						}if(prgAss == null || prgAss == ''){
							pass = '<span style="color:black">'+name+'</span>'+'-'+'None'+'<br/>'+pass+'';
						}
						
					
				}
			 }
			 if(pass != ''){
			    account acc = mapFamAcc.get(accid);
				acc.Program_Associations_RichText__c = pass;
				accToUpdate.add(acc);
			 }
			 
		  }
	   
	   }
       //system.debug('handleAfterInsert ---accToUpdate------'+accToUpdate);
       if(accToUpdate.size()>0){
           update accToUpdate;
       }

}
   
public static void handleAfterUpdate(List<Member_Information__c> triggerOld, map<id, Member_Information__c> triggerNewMap, map<id,Member_Information__c> triggerOldMap){
      system.debug('handle After update -------------');
       map<string,string> mapPrgrmAssnt = new map<string,string>();
       for(Member_Information__c cur : triggerNewMap.values()){
		    if(cur.Program_Associations__c != triggerOldMap.get(cur.id).Program_Associations__c){
                system.debug('id is------------------'+cur.id);
                system.debug('account id is------------------'+cur.Account__c);
                system.debug('handleAfterInsert -------11------'+cur.Program_Associations__c);
                mapPrgrmAssnt.put(cur.account__c,cur.Program_Associations__c);
            }
       }
       system.debug('handleAfterInsert -------11---mapPrgrmAssnt-----'+mapPrgrmAssnt);
	   List<Id>  listIds1 = new List<Id>();
       for(AccountContactRelation curAccConRel : [Select accountId,contactid from AccountContactRelation where contact.accountId IN:mapPrgrmAssnt.keyset()]){
            listIds1.add(curAccConRel.accountId);
            system.debug('handleAfterInsert -------22------');
       }
	   map<id,account>  mapFamAcc = new map<id,account>();
	   for(Account curAccConRel : [Select id,Program_Associations_RichText__c from Account where id in :listIds1]){
            mapFamAcc.put(curAccConRel.id,curAccConRel); 
            system.debug('handleAfterInsert -------33------');
       }
	   
	    listIds1 = new List<Id>();
	   map<string,list<AccountContactRelation>>  mapAcConIds = new map<string,list<AccountContactRelation>>();
	   for(AccountContactRelation curAccConRel : [Select accountId,contact.accountId,contact.name from AccountContactRelation where accountId IN:mapFamAcc.keyset()]){
            system.debug('handleAfterInsert -------44------');
            if(mapAcConIds.containskey(curAccConRel.accountId)){
			    list<AccountContactRelation> lstIds = mapAcConIds.get(curAccConRel.accountId);
				lstIds.add(curAccConRel);
			}
			else{
			   mapAcConIds.put(curAccConRel.accountId, new list<AccountContactRelation>{curAccConRel});
			}
			listIds1.add(curAccConRel.contact.accountId);
           
       }
	   system.debug('handleAfterInsert -------55------'+listIds1);
	   map<string,string> mapStr = new map<string, string>();
	   for(Member_Information__c memInf :  [select id,Account__c,Program_Associations__c from Member_Information__c where Account__c IN:listIds1]){
	      mapStr.put(memInf.Account__c,memInf.Program_Associations__c);
	   }
       list<account> accToUpdate = new list<account>();   
       for(string accid : mapFamAcc.keyset()){
           system.debug('handleAfterInsert -------66------');
	      if(mapAcConIds.containskey(accid)){
              system.debug('handleAfterInsert -------77------');
		     list<AccountContactRelation> lstaccCon = mapAcConIds.get(accid);
			 String pass = '';
			 for(AccountContactRelation str : lstaccCon){
			    if(mapStr.containskey(str.contact.accountId)){
					string name = str.contact.name;
					string prgAss = mapStr.get(str.contact.accountId);
					    system.debug('handleAfterInsert -------99----prgAss-----'+prgAss+'----name-----'+name);
						if(prgAss != null && prgAss != ''){
							pass = '<span style="color:black">'+ name +'</span>'+'-'+prgAss+'<br/>'+pass+' ';
						}if(prgAss == null || prgAss == ''){
							pass = '<span style="color:black">'+name+'</span>'+'-'+'None'+'<br/>'+pass+'';
						}
						
					
				}
			 }
			 if(pass != ''){
			    account acc = mapFamAcc.get(accid);
				acc.Program_Associations_RichText__c = pass;
				accToUpdate.add(acc);
			 }
			 
		  }
	   
	   }
       system.debug('handleAfterInsert ---accToUpdate------'+accToUpdate);
       if(accToUpdate.size()>0){
           update accToUpdate;
       }
}

}