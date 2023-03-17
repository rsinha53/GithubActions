/* Author - Krish
 * Edited by - 
 * Last Updated - 5th May 2021
 * Tested Classes - Utils
 * */

@isTest
public class UtilsTest {
    @isTest
    static void getQueryParamTest(){
        String key = 'Test';
        String defaultValue = '';
        Test.startTest();
        String queryParam = Utils.getQueryParam(key, defaultValue);
        Test.stopTest();
    }

}