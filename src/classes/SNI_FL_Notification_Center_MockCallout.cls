global class SNI_FL_Notification_Center_MockCallout implements HttpCalloutMock {
 global HTTPResponse respond(HTTPRequest req) {
     
     if('https://gateway-stage.optum.com/auth/oauth2/cached/token' == req.getEndpoint())
        {
            string  respBody =  '{"token_type": "bearer","access_token": "Obs6y4cUeQpF4I4K8gWOsLcjJe8tHkfh","expires_in": 234}';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(respBody);
            res.setStatusCode(200);
            return res;
        }
         if('https://gateway-stage.optum.com/api/test/ccs/comm/communications/electronic-mails/v2' == req.getEndpoint())
        {
            string  respBody =  '{"responseStatusMessage": "Message Successfully saved and sent","notificationStatus": "Sent","notificationEntityId": 9933010}';            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(respBody);
            res.setStatusCode(200);
            return res;
        }
        if('https://gateway-stage.optum.com/api/test/ccs/comm/communications/text-messages/v2' == req.getEndpoint())
        {
            string  respBody =  '{"responseStatusMessage": "Message Successfully saved and sent","notificationStatus": "Sent","notificationEntityId": 9933010}';            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(respBody);
            res.setStatusCode(200);
            return res;
        }
     return null;
        // Create a fake response.
        // Set response values, and 
        // return response.
    }
}