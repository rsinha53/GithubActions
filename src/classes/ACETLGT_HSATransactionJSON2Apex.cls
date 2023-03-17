public class ACETLGT_HSATransactionJSON2Apex {
    public ACETLGT_HSATransactionJSON2Apex(){}
    public class Transactions {
        public String id;
        public String accountDescription;
        public String status;
        public String transactionDate;
        public String amount;
        public String transactionCode;
    }

    public class Pagination {
        public String pageNumber;
        public String pageSize;
        public String totalCount;
    }

    public List<Transactions> transactions;
    public Pagination pagination;
    
    
}