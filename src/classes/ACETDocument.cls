public with sharing class ACETDocument {
	public String DocumentId {get;set;}
	public String ContentType {get;set;}
	public Integer DocumentLength {get;set;}
	public List<DocumentKey> DocumentKeys {get;set;}
	
    public class DocumentKey {
    	public String WSName {get;set;}
    	public String Value {get;set;}
    	public String DataType {get;set;}
    	
    	public DocumentKey(String n, String v,String d){
    		WSName = n;
    		Value = v;
    		DataType = d;    		
    	}
    }
    
}