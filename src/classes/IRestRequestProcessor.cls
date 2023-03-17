/*------------------------------------------------------------
Author:        Prajnith Karra
Description:   

History
24-07-2022  Prajnith Karra        Initial Release
------------------------------------------------------------*/
public interface IRestRequestProcessor {
    IRestResponseWrapper process(String requestStructure);
}