public class ACETLGT_ReferralWebserviceRequest {
    public PcpReferralsRequest pcpReferralsRequest{get;set;}
    public class PcpReferralsRequest{
        public String searchType;
        public Member member;
        public RequestDateRange requestDateRange;
        public Pagination pagination;
    }
    public class Member{
        public enrolleeIdentifier enrolleeIdentifier;
        Public String firstName;
        Public String lastName;
        Public String birthDate;
    }
    public class EnrolleeIdentifier {
        Public String id;
        Public String type;
    }
    public class RequestDateRange{
        Public String startDate;
        Public String stopDate;
        Public String dateRangeTypeCode;
    }
    public class Pagination{
        Public String pageNumber;
        Public String pageSize;
        Public String startRecord;
    }
    
    /*public string prepareRequest(){
        PcpReferralsRequest pr = new PcpReferralsRequest();
        pr.searchType = 'M';
        enrolleeIdentifier eid = new enrolleeIdentifier();
        eid.id = '{3}';
        eid.type = 'SRK';
        member m = new member();
        m.firstName = '{0}';
        m.lastName = '{1}';
        m.birthDate = '{2}';
        m.enrolleeIdentifier = eid;
        pr.member = m;
        requestDateRange rdr = new requestDateRange();
        rdr.startDate = '{4}';
        rdr.stopDate = '9999-12-31';
        rdr.dateRangeTypeCode = '';
        pagination p = new pagination();
        p.pageNumber = '';
        p.pageSize = '';
        p.startRecord = '';
        pr.requestDateRange = rdr;
        pr.pagination = p;
        ACETLGT_ReferralWebserviceRequest rw = new ACETLGT_ReferralWebserviceRequest();
        rw.PcpReferralsRequest = pr;
        return JSON.serialize(rw);  
    }*/
    public String addSearchInput(String srkId, String firstName, String lastName, String dob, String startDate, String pageNumber, String pageSize, String startRecord){        
       	pcpReferralsRequest = new PcpReferralsRequest();
        pcpReferralsRequest.searchType = 'M';
        EnrolleeIdentifier eid = new EnrolleeIdentifier();
        eid.id = srkId;
        eid.type = 'SRK';
        Member m = new Member();
        m.firstName = firstName;
        m.lastName = lastName;
        m.birthDate = dob;
        m.enrolleeIdentifier = eid;
        pcpReferralsRequest.member = m;
        RequestDateRange rdr = new RequestDateRange();
        rdr.startDate = startDate;
        rdr.stopDate = '9999-12-31';
        rdr.dateRangeTypeCode = '';
        Pagination p = new Pagination();
        p.pageNumber = pageNumber;
        p.pageSize = pageSize;
        p.startRecord = startRecord;
        pcpReferralsRequest.requestDateRange = rdr;
        pcpReferralsRequest.pagination = p;
 
        return JSON.serialize(this);
    }
}