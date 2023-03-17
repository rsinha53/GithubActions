@isTest
public class ACETLGT_QueryUtilTest {
 @isTest static void QueryUtil1Method() {
  account acc = TestDataFactory.CreateAccount();
  List < id > accidslist = new List < id > ();
  accidslist.add(acc.id);
  List < string > exculdeList = new List < string > ();
  exculdeList.add('FirstName');
  List < string > assignmentFiledList = new List < string > ();
  assignmentFiledList.add('EID__c');
  id accountidstr = acc.id;
  ACETLGT_QueryUtil.query(accountidstr, 'account');
  ACETLGT_QueryUtil.getQuotedIds(accidslist);
  ACETLGT_QueryUtil.consructCustomFieldQuery('account', exculdeList, assignmentFiledList);
  ACETLGT_QueryUtil.getCustomFieldQuery('Account');
  ACETLGT_QueryUtil.getQueryValue(accidslist);
 }

}