/* 
 * @name         :   ACET_GetBAServiceWrapper
 * @description  :   This wrapper  is created to transfer the parameters between the controller and the service
 * @author       :   Sai Kolluru
 * @createddate  :   17-09-2021
 * @lastmodifiedby:
 *
 */
public class ACET_GetBAServiceWrapper {
	public String BenefitBundleOptId;
    public String EnrolleeIdentifierType; 
    public String EnrolleeIdentifierId;
    public String SubscriberIdentifierId; 
    public String EffectiveStartDate; 
    public String EffectiveEndDate; 
    public String CoverageType; 
    public String BenefitVerIndicator; 
    public String BenefitCode; 
    public String accumAsOf;
    public String GroupNumber; 
    public String SubscriptionServiceResponse;
    public String MembershipDuration;
    public String SubscriptionResponse;
    public List< String> existsOnRiderPlanArray;
}