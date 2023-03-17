public class JSON2ApexPracSearch {

    public class Meta {
        public List<String> profile {get;set;} 
    }
    
    public String resourceType {get;set;} 
    public Meta meta {get;set;} 
    public String type {get;set;} 
    public Integer total {get;set;} 
    public List<Entry> entry {get;set;} 

    public class Address {
        public String type {get;set;} 
        public List<String> line {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String postalCode {get;set;} 
        public Integer rank {get;set;} 
    }
    
    /*public class ValueMetadata_Z {
        public String modifiedDateTime {get;set;} 
        public Boolean validated {get;set;} 
        public Boolean valid {get;set;} 
        public Boolean cleansed {get;set;} 
        public String sourceSystemCd {get;set;} 
    }*/

    public class Given {
        public List<Extension> extension {get;set;} 
    }
    
    public class Coding {
        public String system_Z {get;set;} // in json: system
        public String code {get;set;} 
        public String display {get;set;} 
    }
    
    /*public class Source {
        public String endpoint {get;set;} 
    }*/
    
    public class Name {
        public String use {get;set;} 
        public String family {get;set;} 
        public List<String> given {get;set;} 
        public List<Given> x_given {get;set;} // in json: _given
    }
    
    public class Entry {
        public Resource resource {get;set;} 
        public Search search {get;set;} 
        public Response response {get;set;} 
    }
    
    public class Identifier {
        public Type type {get;set;} 
        public String value {get;set;} 
        public List<Characteristic> characteristic {get;set;} 
        public Period period {get;set;} 
    }
    
    public class Resource {
        public String resourceType {get;set;} 
        public List<Identifier> identifier {get;set;} 
        public List<Telecom> telecom {get;set;} 
        public Address singleAddress {get;set;} 
        public List<Address> address {get;set;}
        public List<Name> name {get;set;} 
        public String gender {get;set;} 
        public List<Qualification> qualification {get;set;} 
        public List<Specialty> specialty {get;set;} 
        public EventCoding eventCoding {get;set;} 
        //public Source source {get;set;} 
        public List<Focus> focus {get;set;} 
    }
    
    public class Search {
        public String mode {get;set;} 
        public Double score {get;set;} 
    }
    
    public class Characteristic {
        public String name {get;set;} 
        public String value {get;set;} 
    }
    
    public class Period {
        public Boolean active {get;set;} 
    }
    
    public class Extension {
        public String url {get;set;} 
        public Boolean valueBoolean {get;set;} 
        //public ValueMetadata_Z valueMetadata {get;set;} 
    }
    
    public class Code {
        public List<EventCoding> coding {get;set;} 
    }
    
    public class Specialty {
        public List<Extension> extension {get;set;} 
        public List<Coding> coding {get;set;} 
    }
    
    public class Response {
        public String status {get;set;} 
        public Outcome outcome {get;set;} 
    }
    
    public class Telecom {
        public String system_Z {get;set;} // in json: system
        public String value {get;set;} 
    }
    
    public class Type {
        public List<Coding> coding {get;set;} 
    }
    
    public class Qualification {
        public Code code {get;set;} 
    }
    
    public class EventCoding {
        public String code {get;set;} 
        public String display {get;set;} 
    }
    
    public class Focus {
        public String reference {get;set;} 
    }

    public class Outcome {
        public String resourceType {get;set;} 
        public String id {get;set;} 
        public Meta meta {get;set;} 
        public List<Entry> entry {get;set;} 
    }

    public static JSON2ApexPracSearch parse(String json) {
        return (JSON2ApexPracSearch) System.JSON.deserialize(json, JSON2ApexPracSearch.class);
    }
    
}