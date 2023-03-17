//US2994511: This Class is used while fileupload happens and it creates ContentDistribution records to get the DownloadUrl in ContentVersiontrigger-->
// Author Name :Ankit Agarwal-->

public class ContentVersionHandler {
    
    public static void handleAfterInsert(List<ContentVersion> ContentVlist){
        
        System.debug('Versionlist'+ContentVlist);
        Set<Id> versionid= new Set<Id>();
        Set<Id> versionwithDistubrtion = new Set<Id>();
        Set<Id> versionwithoutDistubrtion = new Set<Id>();
        for(ContentVersion ConV:ContentVlist){
            versionid.add(ConV.Id);
        }
        List<ContentDistribution> Dist_contentDids = [select Id,ContentVersionId from ContentDistribution where ContentVersionId IN : versionid];
        
        if(Dist_contentDids.size()>0){
            for(ContentDistribution disturbtion:Dist_contentDids){
                versionwithDistubrtion.add(disturbtion.ContentVersionId);
            }  
        }
        
        for(Id Vid:versionid){
            if(!versionwithDistubrtion.contains(Vid)){
                versionwithoutDistubrtion.add(Vid);
            }
        }
        

            List<ContentDistribution> cd = new List<ContentDistribution>();
            List<ContentVersion> ContentVfordistribution = [select Id,Title from ContentVersion where ID IN : versionwithoutDistubrtion];
            for(ContentVersion contentver:ContentVfordistribution){
                ContentDistribution Contentrecord = new ContentDistribution();   
                if(contentver.Title.length()> 80 ){
                  Contentrecord.Name = contentver.Title.substring(0,79);
                  }else{
                  Contentrecord.Name = contentver.Title;
                 }
                Contentrecord.ContentVersionId = contentver.Id;
                Contentrecord.PreferencesAllowViewInBrowser= true;
                Contentrecord.PreferencesLinkLatestVersion=true;
                Contentrecord.PreferencesNotifyOnVisit=false;  
                cd.add(Contentrecord);
            }
            insert cd;
            for(ContentDistribution contentvalue:cd){
                contentvalue.PreferencesPasswordRequired=false;  
            }
            update cd;
    }  
}