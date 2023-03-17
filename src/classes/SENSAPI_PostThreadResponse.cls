public class SENSAPI_PostThreadResponse implements IRestResponseWrapper {
    
    public SENSAPI_StatusResponse status;
    public SENSAPI_PostThreadResponse(){
        status = new SENSAPI_StatusResponse();
    }
    public threadDetails thread;
    public class threadDetails{
        public string title;
        public string threadId;
        public string threadBody;
        public string family;
        public datetime createdDate;
        public fromUserDetails fromUser;
        public list<toUserDetails> toUser;
        public datetime latestMessageDate;
        public String latestMessageId;
    }
    public class fromUserDetails{
        public string sensId;
        public string name;
        public boolean isRead;
    }
    public class toUserDetails{
        public string sensId;
        public string name;
        public boolean isRead;
    }
    
    public SENSAPI_PostThreadResponse(List<DirectMessageFeed>dmFeed,List<Account>famAccount,map<String,User>toUsers,List<String>toUsersId,User fromUser){
        status = new SENSAPI_StatusResponse(true,200);
        thread = new threadDetails();
        thread.toUser = new list<toUserDetails>();
        thread.fromUser = new fromUserDetails ();
        thread.title = dmFeed[0].Parent.Subject;
        thread.threadBody = dmFeed[0].body;
        thread.threadId = dmFeed[0].Id;
        thread.createdDate = dmFeed[0].createdDate;
        thread.latestMessageDate = dmFeed[0].createdDate;
        thread.latestMessageId = dmFeed[0].FeedComments.size() > 0 ? dmFeed[0].FeedComments[0].Id : null;
        thread.family = famAccount[0].Name;
        
        for(String toUsr : toUsersId){
            if(toUsers.containsKey(toUsr) && toUsr != fromUser.id ){
                toUserDetails ui = new toUserDetails();
                ui.sensId = toUsers.get(toUsr).id;
                ui.name = toUsers.get(toUsr).name;
                ui.isRead = false;
                thread.toUser.add(ui); 
            }
        }
        
        fromUserDetails fuser = new fromUserDetails();
        fuser.sensId = fromUser.Id;
        fuser.isRead = true;
        fuser.name = fromUser.name;
        thread.fromUser = fuser;
    }
}