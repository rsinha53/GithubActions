/**
 * @name         :  ACETThirdPartyContactsController
 * @description  :  Controller for ACETThirdPartyComponent. this component is responsible for fetching, updating and creating third parties.
 * @author       :  Bhanu Jain
 * @createddate  :  20/11/2016
 **/

public with sharing class  ACETThirdPartyContactsController {

    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<Third_Party_Originator__c> TPOriginatorList {get;set;}
    public Third_Party_Originator__c TPOriginator {get;set;}
    public Third_Party_Originator__c TPOriginatortRelContact {get;set;}
    public String SubjectId{get;set;}
    public boolean showNoThirdPartyError {get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfo {get;set;}
    public String additionalInfoStr {get;set;}
    public String SourceOriginator{get;set;}
    public Interaction__c interaction {get;set;}
    public Map<String,Third_Party_Originator__c> MaptpoIDvstpo {get;set;}
    public String tpliststr {get;set;}
    public String agentProfile {get;set;}
    private boolean isInitialised;
    public String selectedThirdPartyId {get;set;}
    public ACETThirdPartyContactsController (){
        //TPOriginatorList =new List<Third_Party_Originator__c>();
        //system.debug('showNoThirdPartyError >> '+showNoThirdPartyError);
        //TPOriginatortRelContact = new Third_Party_Originator__c();
     //   TPOriginator = new Third_Party_Originator__c();
     init();
    }

    private void init(){
        showNoThirdPartyError = false;
        TPOriginatortRelContact = new Third_Party_Originator__c();
        TPOriginator = new Third_Party_Originator__c();
        if(agentProfile == null || agentProfile == ''){
                profile researchProf = [SELECT id from Profile where name = 'Research User'];
                if(userinfo.getProfileId() != researchProf.id){
                    TPOriginator.third_party__r = new Third_Party__c();
                }
            }else if(!agentProfile.contains('Research')){
                TPOriginator.third_party__r = new Third_Party__c();
            }

    }
/**
* @name         :   getThirdPartyList
* @description  :   This method/action function is responsible getting the third party list associated to current subject
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void getThirdPartyList(){
        TPOriginator = new Third_Party_Originator__c();
        system.debug('SubjectId@@ ' + SubjectId);
      /*  TPOriginatorList = [select id,Third_Party__r.Lastname__c,Third_Party__r.First_Name__c,Third_Party__r.FullName__c,Third_Party__r.Phone_Number__c , Name, Third_Party__r.Tax_ID__c,Third_Party__r.Group_Name__c, other_originator__c from Third_Party_Originator__c where Subject__c =:SubjectId ORDER BY Third_Party__r.Lastmodifieddate DESC ];
        system.debug('TPOriginatorList @@ ' + TPOriginatorList.size() + ' >>Val>> ' + TPOriginatorList);
        if(TPOriginatorList.isEmpty()){
            showNoThirdPartyError =true;
            TPOriginator = new Third_Party_Originator__c();
            TPOriginator.Third_Party__r = new Third_Party__c();
        }else{
            TPOriginator = new Third_Party_Originator__c();
            TPOriginator.Third_Party__r = new Third_Party__c();
            tpliststr = JSON.serialize(TPOriginatorList);
            showNoThirdPartyError = false;
        }        */

        if(String.isNotBlank(SubjectId)){
          TPOriginatorList = [select id,Third_Party__r.Lastname__c,Third_Party__r.First_Name__c,Third_Party__r.FullName__c,Third_Party__r.Phone_Number__c , Name, Third_Party__r.Tax_ID__c,Third_Party__r.Group_Name__c, other_originator__c from Third_Party_Originator__c where Subject__c =:SubjectId ORDER BY Third_Party__r.Lastmodifieddate DESC ];
          system.debug('TPOriginatorList @@ ' + TPOriginatorList.size() + ' >>Val>> ' + TPOriginatorList);
          TPOriginator = new Third_Party_Originator__c();
            TPOriginator.Third_Party__r = new Third_Party__c();
            tpliststr = JSON.serialize(TPOriginatorList);
            showNoThirdPartyError = false;
        }else {
          List<Third_Party__c> thirdPartyList = [SELECT id,First_Name__c,Lastname__c FROM Third_Party__c ];
            showNoThirdPartyError =true;
            TPOriginator = new Third_Party_Originator__c();
            TPOriginator.Third_Party__r = new Third_Party__c();
        }

    }
/**
* @name         :   updatehighlightPanelStr
* @description  :   This method/action function will be called from UI to variable to with selected third party. So that it can be used to display in highlisht panel.
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void updatehighlightPanelStr(){
        //ACETHighlightsPanelAdditionalInfo hpInfo = (ACETHighlightsPanelAdditionalInfo )JSON.deserialize(highlightPanelStr,ACETHighlightsPanelAdditionalInfo.class);
        String selectedTPId = ApexPages.currentPage().getParameters().get('selectedRow');
        System.debug(LoggingLevel.Info,'TPOriginatorList @@ ' + TPOriginatorList);
        System.debug(LoggingLevel.Info,'selectedTPId @@ ' + selectedTPId);
        if(String.isEmpty(selectedTPId)){
            selectedTPId = TPOriginator.third_party__c;
        }
        //system.debug('row id >> '+TPOriginatorList);
        //system.debug('row id >> '+TPOriginatorList);
        if(TPOriginatorList != null && !TPOriginatorList.isEmpty()) {
            for(Third_Party_Originator__c tpo : TPOriginatorList){
                system.debug('2323thirdparty  '+ tpo.third_party__c + ' 2323' + tpo);
                if(tpo.third_party__c == selectedTPId ){
                    //system.debug('tpo.Name :: ' + tpo.Name);
                    if(tpo != null ){
                        System.debug(LoggingLevel.Info,'Inside selectedTPId @@ ' + selectedTPId);
                        if( additionalInfo != null && tpo.Name != null){
                            additionalInfo.OriginatorRelationship = tpo.Name;
                            additionalInfo.RelationshipType = tpo.Name;
                        }
                        additionalInfo.contactName = tpo.third_party__r.First_Name__c+' '+ tpo.third_party__r.Lastname__c;
                        SourceOriginator = tpo.third_party__r.First_Name__c;

                        //update Interaction obj
                        interaction.Third_Party__r = tpo.third_party__r;
                        interaction.Third_Party__c = tpo.third_party__c;
                        interaction.Originator_Name__c = tpo.third_party__r.First_Name__c+' '+ tpo.third_party__r.Lastname__c;
                        Interaction.Contact_Name__c = tpo.third_party__r.First_Name__c+' '+ tpo.third_party__r.Lastname__c;
                    }
                }
            }
        }
        additionalInfoStr = JSON.serialize(additionalInfo);
        upsert interaction;
//        interaction = ACETMemberQueryUtil.queryInteraction(interaction.Id);
        system.debug('interaction after updateHighlightPanel'+interaction);
        //additionalInfo.OriginatorRelationship = 'testing';

    }
        /**
* @name         :   addNewThirdParty
* @description  :   This method/action function will create new  the third party record and its junction. Also will refresh the third party list which is displayed on UI.
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void addNewThirdParty(){
        //create new third party
        if(TPOriginatorList == Null)
        {
            TPOriginatorList = new List<Third_Party_Originator__c>();
        }
        //TPOriginatortRelContact = new Third_Party_Originator__c();
        system.debug('TPOriginator >>222 '+TPOriginator.third_party__r.first_name__c);
        Third_Party__c newThirdParty = new Third_Party__c();
         newThirdParty.first_name__c = TPOriginator.third_party__r.first_name__c;
         newThirdParty.Lastname__c = TPOriginator.third_party__r.Lastname__c;
        newThirdParty.Phone_Number__c  = TPOriginator.third_party__r.Phone_Number__c ;
        newThirdParty.Group_Name__c = TPOriginator.third_party__r.Group_Name__c;
           newThirdParty.FullName__c =   newThirdParty.First_name__c + ' '+newThirdParty.Lastname__c ;
           newThirdParty.Other_Originator__c = (TPOriginatortRelContact!= null)?TPOriginatortRelContact.other_originator__c:''; 
        insert newThirdParty;

        TPOriginator= new Third_Party_Originator__c();
        TPOriginator.subject__c =SubjectId;
        TPOriginator.third_party__c = newThirdParty.Id;
        TPOriginator.third_party__r = newThirdParty;
        if(TPOriginatortRelContact != null){
            system.debug('TPOriginatortRelContact.other_originator__c @@ ' + TPOriginatortRelContact.other_originator__c);
            TPOriginator.name = TPOriginatortRelContact.other_originator__c;
            TPOriginator.Other_Originator__c = TPOriginator.name;
        }
         
        insert TPOriginator;
        system.debug('TPOriginator 111 ' + TPOriginator);
        showNoThirdPartyError =false;
        TPOriginatorList.add(TPOriginator);
        ApexPages.currentPage().getParameters().put('selectedRow','');
        getThirdPartyList();
        updatehighlightPanelStr();

    }
/**
* @name         :   updateThirdParty
* @description  :   This method/action function will update the third party objectand its junction. Also will refresh the third party list which is displayed on UI.
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void updateThirdParty(){
        system.debug('TPOriginator >> '+TPOriginator);
         system.debug('TPOriginator.third_party__r >> '+TPOriginator.third_party__r);
         String selectedTPId = ApexPages.currentPage().getParameters().get('updatedTOP');

        system.debug(JSON.serialize(TPOriginatorList));
        system.debug('selectedTPId' + selectedTPId);
        Third_Party_Originator__c selectedThirdParty= null;
        for(Third_Party_Originator__c tpo : TPOriginatorList){
            System.debug('tpo.third_party__c ' + tpo.third_party__r);
            if(tpo.third_party__c == selectedTPId ){
               selectedThirdParty = tpo;
               break;
            }
        }
        if(TPOriginatortRelContact != null){
            TPOriginator.name= TPOriginatortRelContact.other_originator__c;
             TPOriginator.Other_Originator__c =TPOriginator.name;
        }
        Third_Party__c thirdPartyObj = TPOriginator.third_party__r;
        if(selectedThirdParty != null){
            TPOriginator.id = selectedThirdParty.id;
            thirdPartyObj.id = selectedTPId;
            TPOriginator.third_party__c = selectedTPId;

        }


        thirdPartyObj.FullName__c =   thirdPartyObj.First_name__c + ' '+thirdPartyObj.Lastname__c ;

        update TPOriginator.third_party__r;
        update TPOriginator;
        System.debug('@@@##'+TPOriginator);
        Integer count =0;
           for(Third_Party_Originator__c tpo : TPOriginatorList){
            System.debug(count++ +' tpo ' + tpo );
                    if(tpo.third_party__c == TPOriginator.third_party__c){
                         TPOriginator = tpo ;
                         //break;
                    }
                }
           getThirdPartyList();
           updatehighlightPanelStr();
           tpliststr = JSON.serialize(TPOriginatorList);

              system.debug('tpliststr >> '+tpliststr);
    }
/**
* @name         :   updateUI
* @description  :   This method/action function is responsible getting the third party list associated to current subject
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void updateUI(){

    }
/**
* @name         :   updateInteraction
* @description  :   This method/action function will update current interaction with selected third party contact.
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void updateInteraction(){
        upsert interaction;
    }
/**
* @name         :   populateEditPopup
* @description  :   This method/action function is responsible for setting selected third party object which will be populated in edit pop up.
* @param        :   void
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:
**/
    public void populateEditPopup(){
        String selectedTPId = ApexPages.currentPage().getParameters().get('selectedEditRow');
        System.debug(LoggingLevel.Info,'TPOriginatorList @@ ' + TPOriginatorList);
        TPOriginator = null;
        for(Third_Party_Originator__c tpo : TPOriginatorList){
            if(tpo.third_party__c == selectedTPId ){
                TPOriginator = tpo.clone();
                TPOriginator.id = tpo.id;
                TPOriginator.third_party__r = tpo.third_party__r.clone();
                TPOriginator.third_party__c = String.valueof(tpo.third_party__c);
                TPOriginator.third_party__r.id =  TPOriginator.third_party__c;
                 System.debug('TPOriginator ' + TPOriginator);
                if(TPOriginatortRelContact != null && tpo != null){
                TPOriginatortRelContact.Other_Originator__c = tpo.name;
                TPOriginator.third_party__r.Other_Originator__c = tpo.name;
                }
              }
        }

    }
}