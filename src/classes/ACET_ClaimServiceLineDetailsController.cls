public class ACET_ClaimServiceLineDetailsController {
   
@AuraEnabled
public static list<Tool_Tip__c> getToolTips( List<String> rcodes)
    {
              
        List<Tool_Tip__c> tips = [Select Tip__c,SOP_or_Document_Link__c,SOP_or_Document_Name__c,Value__c from tool_tip__c where Value__c in :rcodes and Tool_Tip_Type__c = 'Claim' ];    
        List<Tool_Tip__c> tips_appended = new List<Tool_Tip__c>();
        List<Tool_Tip__c> tips_notFoundList = new List<Tool_Tip__c>();

       boolean found = false;
        System.debug('Ketki log  tips size::'+tips.size());
        System.debug('Ketki log  rcodes::'+rcodes);
        System.debug('Ketki log  rcodes size::'+rcodes.size());

        for ( integer i = 0; i< rcodes.size(); i++)
        {
            System.debug('Ketki log  inside rcode for loop');
            found = false;



            for (integer j =0; j< tips.size();j++)
            {
                if(rcodes[i] == tips[j].Value__c)
                {
                    found = true;
                    System.debug('Ketki log is found tips for loop::'+ found);
                    tips_appended.add(tips[j]);
                    break;
                }
            }

            if (found == false)
            {
                System.debug('Ketki log is found  if tip not found::'+ found);
                Tool_Tip__c Tip = new Tool_Tip__c();
                Tip.Value__c = rcodes[i];
                Tip.Tool_Tip_Type__c='Claim';
                tips_notFoundList.add(Tip);
                //insert Tip;
            }

        }
        insert tips_notFoundList;
        tips_appended.addAll(tips_notFoundList);
        
        return tips_appended;
    }
    
}