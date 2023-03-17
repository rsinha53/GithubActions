public class ACETSendMemberlistEmail implements Queueable, Database.AllowsCallouts {
Public string hasPop;
Public string groupName;
Public string groupId;
Public string contractId;
Public string request;
Public string statusPDF;
Public string bundleID;
Public string inquiryDate;
Public Integer cobraCount;
Public string continuationType;
Public string selectedPopulation;
Public string attachid;
Public string contenttype;

    public ACETSendMemberlistEmail (string hasPop,string groupName,string groupId,string contractId,string request,string statusPDF,string bundleID,string inquiryDate,Integer cobraCount,string continuationType,string selectedPopulation,String attachid,string contenttype){
        this.hasPop = hasPop ; 
        this.groupName = groupName ;  
        this.groupId = groupId ;  
        this.contractId = contractId ;  
        this.request = request ;  
        this.statusPDF = statusPDF ;  
        this.bundleID = bundleID ;  
        this.inquiryDate = inquiryDate ;  
        this.cobraCount = cobraCount ;  
        this.continuationType = continuationType ;  
        this.selectedPopulation = selectedPopulation ;  
        this.inquiryDate = inquiryDate ;  
        this.attachid=attachid;
        this.contenttype=contenttype;
    }
    public void execute(QueueableContext context) {
           system.debug('hasPop==>'+hasPop);

    PageReference pdf = Page.ACETViewMemberListPDFJob;
    pdf.getParameters().put('hasPop', hasPop);
    pdf.getParameters().put('groupName', groupName);
    pdf.getParameters().put('groupId', groupId);
    pdf.getParameters().put('contractId', contractId);
    pdf.getParameters().put('request', request);
    pdf.getParameters().put('statusPDF', statusPDF);
    pdf.getParameters().put('bundleID', bundleID);
    pdf.getParameters().put('inquiryDate', inquiryDate);
    pdf.getParameters().put('cobraCount', String.valueOf(cobraCount));
    pdf.getParameters().put('continuationType', continuationType);
    pdf.getParameters().put('selectedPopulation', selectedPopulation);
    pdf.getParameters().put('inquiryDate', inquiryDate);
    pdf.getParameters().put('attachmentid',attachid);

    Blob body;
    try {
     body = pdf.getContent();
    } catch (VisualforceException e) {
     body = Blob.valueOf('Some Text');
    }
    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
    efa.setContentType('application/pdf');
    efa.setFileName('Member Listing for Group' + groupId + '.pdf');
    efa.setInline(false);
    efa.setBody(body);

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    system.debug(UserInfo.getUserEmail());
    String[] toAddresses = new String[] {
     UserInfo.getUserEmail()
    };
    mail.setToAddresses(toAddresses);
    mail.setSubject('Member Listing for Group ' + groupId);

    mail.plainTextBody = 'Member Listing for Group '+groupId+' is attached.';

    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {
     efa
    });
    Messaging.SendEmail(new Messaging.SingleEmailMessage[] {
     mail
    });
        
    }
}