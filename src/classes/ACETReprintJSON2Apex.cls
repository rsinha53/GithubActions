/**
* Author: Hasara Disanayaka
* Date Created: 16/06/2021
* Purpose: Response Wrapper of Reprint Integration. Used in ACETDocRedeliveryWebservice Apex Class
**/
public class ACETReprintJSON2Apex {
    public String reprintId;
    public String clientReprintId;
    public String documentClassName;
    public String documentId;
    public String sourceId;
    public String receivedDate;
    public String status;
    public Error error;
    public class Error {
        public String typeZ;
        public Integer status;
        public String detail;
        public Integer errorCode;
    } 
    public static ACETReprintJSON2Apex parse(String json) {
        return (ACETReprintJSON2Apex) System.JSON.deserialize(json, ACETReprintJSON2Apex.class);
    }
}