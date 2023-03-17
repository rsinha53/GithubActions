@IsTest
public class ACETLGT_DynamicCallTypesTest {
    public static testmethod void getSwivelTopic(){
        Swivel_Topic__c st = new Swivel_Topic__c();
        st.Swivel_Topic__c = 'Appeal';
        st.Active__c = true;
        st.Call_Type__c = 'Other';
        insert st;
        ACETLGT_DynamicCallTypesController.getSwivelTopicList(st.Swivel_Topic__c);
    }
}