/****************************************************************************** 
Class Name     : SNI_FL_ProviderReadInterface
Description    : Interface that will be impletemented by Adivisor and backupagent class to 
                 read data for dropdowns in newprovidermessage popup
Created By     : Sameera - ACDC US3075477,US3078403,US3121134
Created Date   : 12/16/2020
******************************************************************************/
public interface SNI_FL_ProviderReadInterface {

    
    List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderAffliations();
    List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembers();
    List<SNI_FL_ProviderMessageUtil.ProviderData> getMessagingToUsers();

}