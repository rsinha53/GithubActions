@isTest(SeeAllData=false)
public class ACETGroupSearchResultTest
{
   static testMethod void GroupSearchResultTestMethod() 
    {
    
        ACETGroupSearchResult groupResult = new ACETGroupSearchResult();
        groupResult.groupName = 'Test Group Name';
        groupResult.groupId = '1234567';
        groupResult.taxid = '12-123';
        groupResult.status = 'Active';
        groupResult.addresses = '123 street test';
        groupResult.city = 'Test city';
        groupResult.state = 'NJ';
        groupResult.zipcode = '07720';
        
    }    
}