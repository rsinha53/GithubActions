@isTest
public class Motion_MemberSearchUtilTest {
 @isTest
    static void setRowColumnDataTest()
    {
        Motion_MemberSearchUtil.setRowColumnData('link','James','','','','','','','','','');
        Motion_MemberSearchUtil.setRowColumnData('outputText','James','','','','','','','','','');
        Motion_MemberSearchUtil.setRowColumnData('isStatusIcon','James','','','','','','','','','');
        Motion_MemberSearchUtil.setRowColumnData('unescapedHtml','James','','','','','','','','','');
        Motion_MemberSearchUtil.setRowColumnData('','','','','','','','','','','');
        Motion_MemberSearchUtil.TableDetails obj=new Motion_MemberSearchUtil.TableDetails ();
        Motion_MemberSearchUtil.FieldDetails obj1=new Motion_MemberSearchUtil.FieldDetails ('FirstName','James','link');
    }
    
    
}