/*
    Created By: Kavinda Inusha
    Created Date: 26th April 2021
    Description: To invoke the PaymentDetails::CheckDetail api calls
*/
public class ACET_ViewPaymentsCheckSearchWS {

	public static ACET_SAECalloutResult getCheckSearchData(ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject) {

		ACET_SAECalloutResult retResponse = new ACET_SAECalloutResult();
		HttpResponse httpResponse = new HttpResponse();
	
		try {
	
			ACET_ViewPaymentsRequest.Meta meta = new ACET_ViewPaymentsRequest.Meta();
			meta.sourceSystem = 'TOPS';
			meta.securityToken = '';

			ACET_ViewPaymentsRequest.Data data = new ACET_ViewPaymentsRequest.Data();
			data.searchType = 'DRAFT';
			data.seriesDesignator = requestObject.seriesDesignator;
			data.checkNumber = requestObject.checkNumber;
			data.accountNumber = '';
			data.policyNumber = '';
			data.subscriberId = '';
			data.firstName = '';
			data.lastName = '';
			data.draftStatus = '';

			ACET_ViewPaymentsRequest.PagingState pState = new ACET_ViewPaymentsRequest.PagingState();
			pState.moreData = 'true';
			pState.nextKey = (requestObject.nextKey == null ? '' : requestObject.nextKey);

			data.pagingState = pState;

			ACET_ViewPaymentsRequest.RequestBody request = new ACET_ViewPaymentsRequest.RequestBody();
			request.meta = meta;
			request.data = data;
			
			System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> request:' + request);

			ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
			wsCallOutFW.serviceName = 'PaymentCheckSearch';
			wsCallOutFW.requestBody = JSON.serialize(request);
			System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> wsCallOutFW: ' + wsCallOutFW);

			httpResponse = wsCallOutFW.getResponse(); 
	
			System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> httpResponse: ' + httpResponse);
			System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> StatusCode: ' + httpResponse.getStatusCode());
			retResponse.statusCode = httpResponse.getStatusCode();
			String strBody = httpResponse.getBody();
			System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> strBody: ' + strBody);
	
			if (httpResponse.getStatusCode() == 200) {
				retResponse.isSuccess = true;
				ACET_ViewPaymentsCheckSearchWrapper resp = (ACET_ViewPaymentsCheckSearchWrapper) JSON.deserialize(strBody, ACET_ViewPaymentsCheckSearchWrapper.class);
				retResponse.response = resp;
			} else {
				retResponse.isSuccess = false;
				retResponse.message = String.valueOf(strBody);
			}
	
		} catch(Exception e) {
			retResponse.statusCode = 400;
			retResponse.isSuccess = false;
			retResponse.message = String.valueOf(e);
			System.debug(LoggingLevel.ERROR, 'ACET_ViewPaymentsCheckSearchWS -> Exception: ' + e.getMessage() + '--->' + e.getLineNumber());
		}
	
		System.debug(LoggingLevel.INFO, 'ACET_ViewPaymentsCheckSearchWS -> retResponse: ' + retResponse);
		return retResponse;
	}

}