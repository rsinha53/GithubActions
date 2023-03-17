public class ACETErrorMessagePageController{

   public ACETErrorMessagePageController() {
     string message = 'DO NOT CLOSE THIS TAB or INTERACTION: You have encountered a system error that requires your assistance to resolve this issue.' +  '<br/>' + '1. Address all of the constituents needs.' +  '<br/>' +
'2. Release the caller and do not close out of the screen.'+  '<br/>' +'3. Immediately contact your supervisor.'+  '<br/>' +'4. Aux into Outage.'+  '<br/>' +
'5. Email screen shot to ACETOrionTeam_DL@ds.uhc.com.'+  '<br/>' +'6. Wait for someone from the ACET production support team to contact you.'+  '<br/>' +'7. After system analysis is completed, finalize the Case and close the Interaction.';
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
  }
}