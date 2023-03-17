@isTest
public class SNI_FLDirectMessageWrapperTest {

    @isTest static void SNI_FLDirectMessageWrapperTestMethod(){
        SNI_FLDirectMessageWrapper.SNI_FLUserDetails userDetails = new SNI_FLDirectMessageWrapper.SNI_FLUserDetails('a','b','c','d','e');
		SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments	dmFeedComments = new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments('a',userDetails,system.now(),'b','c','d',true,'e');
    	SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount peracc = new SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount('test','test',Userinfo.getUserId(),'test');
        List<SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount> peracclst = new List<SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount>();
        peracclst.add(peracc);
        SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam provTeam = new SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam(Userinfo.getUserId(),'test',peracclst);
        SNI_FLDirectMessageWrapper.SNI_FLMessage msg = new  SNI_FLDirectMessageWrapper.SNI_FLMessage(Userinfo.getUserId(),'abc','def',true,true);
         List<SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam > providerlst = new List<SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam >();
        providerlst.add(provTeam);
        SNI_FLDirectMessageWrapper.SNI_FLMessage msg2 = new  SNI_FLDirectMessageWrapper.SNI_FLMessage('def',true,true,peracc,providerlst);
        SNI_FLDirectMessageWrapper.DirectMessageFeed dmsg = new  SNI_FLDirectMessageWrapper.DirectMessageFeed(System.now(),'abc','def',userDetails);
        Case c = new Case(Subject='Test Case', Status = 'New');
        insert c;

        FeedItem f = new FeedItem(ParentId=c.Id, Body='Test Post');
        insert f;
        
        FeedComment fc = new FeedComment(CommentBody='Test Comment',FeedItemId = f.Id);
        SNI_FLDirectMessageWrapper.DirectMessageComments dmc = new SNI_FLDirectMessageWrapper.DirectMessageComments(System.now(),'abc',userDetails,fc.Id);
        SNI_FLDirectMessageWrapper.DirectMessageComments dmc2 = new SNI_FLDirectMessageWrapper.DirectMessageComments(fc.Id,System.now(),'abc',userDetails);
    	SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed dmfeed = new SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed(System.now(),System.now()+1,'test','test',userDetails);
   		List<SNI_FLDirectMessageWrapper.SNI_FLUserDetails > userdet = new List<SNI_FLDirectMessageWrapper.SNI_FLUserDetails>();
        List< SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments > msgcmt = new List< SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments>();
        msgcmt.add(dmFeedComments);
        userdet.add(userDetails);
        SNI_FLDirectMessageWrapper msgwrap = new SNI_FLDirectMessageWrapper(userdet,dmfeed,msg2,10,10,10,10,10,true);
        SNI_FLDirectMessageWrapper msgwrap2 = new SNI_FLDirectMessageWrapper(userdet,msgcmt,'test',dmfeed,msg2,10,10,10,10,10);
    }
}