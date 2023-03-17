/**
 * Data wrapper class for data table component
*/
public with sharing class ACETDataTableWrapper {
    public String Service { get; set; } //serialized service instance
    public String ServiceName { get; set; } //serivce class name
    public List<DataColumn> Columns { get; set; } //columns displayed on table UI  
    public Integer PageNumber { get; set; }
    public Integer PageSize { get; set; }
    public Integer StartRecord { get; set; }
    public String PagingType { get; set; }
    public Boolean InitOnDocumentReady { get; set; }
    public Integer PageStartNumber { get; set; }   
    public Boolean IsSortEnabled { get; set; } 
    public Integer DefaultSortBy {get; set;}
    public String DefaultSortDir { get; set; }
    public String datatablename { get; set; }
    public String errorMessage {get;set;}
    
    
    public ACETDataTableWrapper(String serviceName, Object serviceObj){
        this.ServiceName = serviceName;
        this.Service = JSON.serialize(serviceObj).replace('\'', '&#x27;');  
        this.Columns = new List<DataColumn>();
        this.PageNumber = 1;
        this.PageSize = 10;
        this.StartRecord = 1;
        this.PagingType = 'simple_numbers';
        this.InitOnDocumentReady = true;
        this.PageStartNumber = 1;  
        this.IsSortEnabled = false; 
        this.DefaultSortBy = 0;  
        this.DefaultSortDir = 'asc';   
    }
    
    public ACETDataTableWrapper(String serviceName, ACETWebService serviceObj){
        this.ServiceName = serviceName;
        this.Service = JSON.serialize(serviceObj).replace('\'', '&#x27;');  
        this.Columns = new List<DataColumn>();
        this.PageNumber = 1;
        this.PageSize = 10;
        this.StartRecord = 1;
        this.PagingType = 'simple_numbers';
        this.InitOnDocumentReady = true;
        this.PageStartNumber = 1;  
        this.IsSortEnabled = false; 
        this.DefaultSortBy = 0;  
        this.DefaultSortDir = 'asc';   
    } 
    
    public String getStrColumns() {
        return JSON.serialize(Columns); 
    }
    
    public class DataColumn {
        public String title { get; set; } //column header name
        public String data { get; set; } //column data field name
        public String defaultContent { get; set; } //column default value set to empty string        
        
        public DataColumn(String columnName, String DataName){
            title = columnName;
            data = DataName;
            defaultContent = '';            
        }
    }                  
}