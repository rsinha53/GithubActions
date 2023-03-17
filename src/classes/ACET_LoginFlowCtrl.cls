public class ACET_LoginFlowCtrl extends ACETWebservice {

    public boolean bannerPage {
        get;
        set;
    }
    public boolean loginPage {
        get;
        set;
    }
    public boolean showError {
        get;
        set;
    }
    public String errorMessage {
        get;
        set;
    }
    public Integer statusCode {
        get;
        set;
    }
    public string userName {
        get;
        set;
    }
    public string userPassword {
        get;
        set;
    }
    public boolean isSNIUser {
        get;
        set;
    } //Code Added By Chandan
    public String sniErrorMessage {
        get;
        set;
    } // US2500710 - Cancel button Tops Credential - Inshar [4/14/2020]
    public String expiryDate {
        get;
        set;
    }
    public Boolean showWarning {
        get;
        set;
    }
    /* US2260431 - Update Password Implementation*/
    public Boolean showToggle {
        get;
        set;
    } {
        showToggle = false;
    }
    public Boolean boolShowPasswordUpdatePanel {
        get;
        set;
    } {
        boolShowPasswordUpdatePanel = false;
    }
    public string strNewPassword {
        get;
        set;
    }
    public string strConfirmPassword {
        get;
        set;
    }
    public boolean isSucessfullyUpdated {
        get;
        set;
    }
    public boolean isUpdatePasswordOperation {
        get;
        set;
    } {
        isUpdatePasswordOperation = false;
    }
    public string strExistingUserName {
        get;
        set;
    } {
        strExistingUserName = '';
    }
    public string strExistingUserPassword {
        get;
        set;
    } {
        strExistingUserPassword = '';
    }
    public String strUserid {
        get;
        set;
    } {
        strUserid = '';
    }
    private String strDate {
        get;
        set;
    }
    public Boolean isUpdateFailed {
        get;
        set;
    }
    public Boolean showSuccessMessage {
        get;
        set;
    } {
        showSuccessMessage = false;
    }
    public static Integer Topsnoofexec = 1;
    private static string accesstoken;
    private static Integer expiresin;
    public static Boolean isondemandtoken;
    /* US2260431 - Update Password Implementation*/

    public class ControlModifiers {
        public TopsSourceSystemParameters topsSourceSystemParameters;
    }

    public PostInput postInput;

    public class PostInput {
        public List < ControlModifiers > controlModifiers;
        public String getOrsProfile;
        public String getTOPSToken;
        public String validateTOPSCredentials;
        public String encryptionIndicatorTOPS;
    }

    public class TopsSourceSystemParameters {
        public String userId;
        public String userPassword;
    }

    public ACET_LoginFlowCtrl() {
        super('EAIP');
        errorMessage = 'TOPS Credentials Failed';
        expiryDate = '';
        showWarning = false;
        bannerPage = true;
        loginPage = false;
        showError = false;
        isSNIUser = ACETUtility.fetchUser(); //Code Added By Chandan
        this.sniErrorMessage = ''; // US2500710 - Cancel button Tops Credential - Inshar [4/14/2020]
        /* US2260431 - Update Password Implementation*/
        try {
            String strUserid = ApexPages.currentPage().getParameters().get('id');
            if (String.isNotBlank(strUserid) == true) {
                bannerPage = false;
                loginPage = true;
                showToggle = true;
            }
            isSucessfullyUpdated = false;
        } catch (exception ex) {

        }

        /* US2260431 - Update Password Implementation*/
    }

    public override void getEndpoint() {
        BaseURL = '';
        /* US2260431 - Update Password Implementation*/
        if (isUpdatePasswordOperation == false) {
            GetEndpointDetail('ORSEAIPToken');
        } else {
            GetEndpointDetail('ORSEAIPUpdatePassword');
        }
    }

    //create request body
    public void getRequestBody(String userId, String password) {
        TopsSourceSystemParameters topsParams = new TopsSourceSystemParameters();
        topsParams.userId = userId;
        topsParams.userPassword = password;

        ControlModifiers cm = new ControlModifiers();
        cm.topsSourceSystemParameters = topsParams;

        List < ControlModifiers > ctrlModifiersList = new List < ControlModifiers > ();
        ctrlModifiersList.add(cm);

        PostInput postInput = new PostInput();
        postInput.controlModifiers = ctrlModifiersList;
        postInput.getOrsProfile = 'true';
        postInput.getTOPSToken = 'true';
        postInput.validateTOPSCredentials = 'true';
        postInput.encryptionIndicatorTOPS = 'true';
        RequestBody = JSON.serialize(postInput);
        RequestBody = '{"postInput":' + RequestBody + '}';
        System.debug('###REQUEST-BODY:' + RequestBody);
    }

    public HttpResponse getTOPSResponse(String userId, String password) {
        getEndpoint();
        getRequestBody(userId, password);
        HttpResponse response = new HttpResponse();
        response = send(OAuthConfig);
        return response;
    }
    public HttpResponse getResp(String userId, String password, string accesstoken) {
        getEndpoint();
        getRequestBody(userId, password);
        HttpRequest Request = new HttpRequest();
        HttpResponse Response;
        Http oHttp = new Http();
        ACETOAuthWebservice OAuthWS;

        try {
            GetHeaders(OAuthConfig);
            if (Headers != null) {


                Headers.put('Authorization', 'Bearer ' + accesstoken);

            }
            Request = CreateRequest();
            Response = oHttp.Send(Request);
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        } catch (Exception ex) {
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus('Internal Server Error');
            Response.setBody(GetErrorJSON('500', ex.getTypeName(), ex.getMessage(), Label.ACETUnexpectedErrorMessage));
        }

        return Response;
    }

    public PageReference createOrUpdateORSCredentials() {
        isUpdatePasswordOperation = false;
        String responseBody = null;
        HttpResponse response = new HttpResponse();
        List < Per_User_Credentials__c > userCredentialList = new List < Per_User_Credentials__c > ();
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c();
        try {
            response = getTOPSResponse(userName, ACET_TOPSEncryptionAlgorithm.getEncryptedString(userPassword));
            System.debug('@ ACET_LoginFlowCtrl: createOrUpdateORSCredentials: responseBody:' + response.getBody());
            responseBody = response.getBody();
            statusCode = response.getStatusCode();
            ACET_PerUserCredentialResultWrapper loginData;
            if (String.isNotBlank(responseBody)) {
                loginData = ACET_PerUserCredentialResultWrapper.parse(responseBody);
            }
            
            if (statusCode == 200) {
                if (responseBody.containsIgnoreCase('userProfile')) {
                    userCredentialList = [SELECT Id, User__c, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
                    system.debug(userCredentialList);
                    if (!userCredentialList.isempty()) {
                        userCredentialRec = new Per_User_Credentials__c(Id = userCredentialList[0].Id,
                            UserName__c = userName,
                            Password__c = ACET_TOPSEncryptionAlgorithm.getEncryptedString(userPassword),
                            User__c = UserInfo.getUserId());
                        Update userCredentialRec;
                    } else {
                        userCredentialRec = new Per_User_Credentials__c(UserName__c = userName,
                            Password__c = ACET_TOPSEncryptionAlgorithm.getEncryptedString(userPassword),
                            User__c = UserInfo.getUserId());
                        Insert userCredentialRec;
                    }
                    Cache.Session.put('local.TOPSProfileInfo.userId', loginData.PostResult.userProfile.userId, 28800, Cache.Visibility.ALL, true);
                    Cache.Session.put('local.TOPSProfileInfo.businessGroups', loginData.PostResult.userProfile.businessGroups, 28800, Cache.Visibility.ALL, true);
                    /*US3273505 - Adding CosmosUserId to cache for COB*/
                    Cache.Session.put('local.TOPSProfileInfo.cosmosId', loginData.PostResult.userProfile.cosmosUserId, 28800, Cache.Visibility.ALL, true);
                    /*US3308339 - Adding userToken to cache for Accumulation Non Therapy */
                    Cache.Session.put('local.TOPSProfileInfo.userToken', loginData.PostResult.userTokens[0].userToken, 28800, Cache.Visibility.ALL, true);
                    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
                    for (ACET_PerUserCredentialResultWrapper.userTokens tokenData: loginData.PostResult.userTokens) {
                        if (!isSNIUser && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) <= 14 && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) > 1) {
                            expiryDate = String.valueOf(system.today().adddays(Integer.valueOf(tokenData.daysRemainingPasswordExpiration)));
                            expiryDate = formatDate(expiryDate);
                            showWarning = true;
                            loginPage = true;
                            boolShowPasswordUpdatePanel = false;
                        } else if (!isSNIUser && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) <= 1) {
                            expiryDate = String.valueOf(system.today().adddays(Integer.valueOf(tokenData.daysRemainingPasswordExpiration)));
                            expiryDate = formatDate(expiryDate);
                            showWarning = false;
                            loginPage = true;
                            boolShowPasswordUpdatePanel = false;
                        } else {
                            loginPage = true;
                            showWarning = false;
                            boolShowPasswordUpdatePanel = false;
                        }
                    }
                    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/

                    if (!showWarning && !boolShowPasswordUpdatePanel) {
                        String isUserPage = ApexPages.currentPage().getParameters().get('id');
                        if (String.isBlank(isUserPage)) {
                            return Auth.SessionManagement.finishLoginFlow();
                        }
                    }
                } else {
                    showError = true;
                    userName = '';
                    if (isSNIUser) {
                        sniErrorMessage = ACETUtility.getErrorMessage('GN500');
                    }
                    return null;
                }
            } else if (statusCode == 400) {
                showError = true;
                userName = '';
                // US2500710 - Cancel button Tops Credential - Inshar [4/17/2020]
                if (isSNIUser) {
                    sniErrorMessage = ACETUtility.getErrorMessage('TS400');
                }
                for (ACET_PerUserCredentialResultWrapper.Errors errorData: loginData.PostResult.errors) {
                    if (errorData.code == 400) {
                        errorMessage = errorData.description;
                    }
                }
            } else if (statusCode == 404) {
                errorMessage = ACETUtility.getErrorMessage('CLD200');
                showError = true;
            } else if (statusCode == 500) {
                userName = '';
                showError = true;
                errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                if (isSNIUser) {
                    sniErrorMessage = ACETUtility.getErrorMessage('GN500');
                }
            } else {
                showError = true;
                userName = '';
                // US2500710 - Cancel button Tops Credential - Inshar [4/14/2020]
                if (isSNIUser) {
                    sniErrorMessage = ACETUtility.getErrorMessage('GN500');
                }
            }
        } catch (exception ex) {
            System.debug('@ ACET_LoginFlowCtrl: createOrUpdateORSCredentials: exception:' + ex.getStackTraceString() + ex.getMessage());
            if (isSNIUser) {
                sniErrorMessage = ACETUtility.getErrorMessage('GN500');
            }
        }
        return null;
    }

    public PageReference validateTopsCredentials() {
        Login_Flow_Configs__c loginFlowConfigs = Login_Flow_Configs__c.getInstance(UserInfo.getUserId());
        System.debug('====loginFlowConfigs===='+loginFlowConfigs);
        List < String > businessGroupsList = new List < String > ();
        PageReference pageRef = ApexPages.currentPage();
        System.debug('===loginFlowConfigs.SkipLoginFlow__c===='+loginFlowConfigs.SkipLoginFlow__c);
        if (loginFlowConfigs != null && loginFlowConfigs.SkipLoginFlow__c) {
            Cache.Session.put('local.TOPSProfileInfo.userId', loginFlowConfigs.AgentId__c + '/' + loginFlowConfigs.OfficeId__c, 28800, Cache.Visibility.ALL, true);
            if (loginFlowConfigs.BusinessGroups__c != null) {
                businessGroupsList.addAll(loginFlowConfigs.BusinessGroups__c.split(','));
            }
            Cache.Session.put('local.TOPSProfileInfo.businessGroups', businessGroupsList, 28800, Cache.Visibility.ALL, true);
            /*US3273505 - Adding CosmosUserId to cache for COB*/
            Cache.Session.put('local.TOPSProfileInfo.cosmosId', loginFlowConfigs.CosmosId__c, 28800, Cache.Visibility.ALL, true);
            /*US3308339 - Adding userToken to cache for Accumulation Non Therapy */
            Cache.Session.put('local.TOPSProfileInfo.userToken', loginFlowConfigs.UserToken__c, 28800, Cache.Visibility.ALL, true);
            if (Test.isRunningTest() || (pageRef != null && pageRef.getUrl().containsignoreCase('ACET_LoginFlowPage'))) {
                return Auth.SessionManagement.finishLoginFlow();
            } else {
                return null;
            }
        }
        showSuccessMessage = false;
        isUpdatePasswordOperation = false;
        bannerPage = false;
        showWarning = false;
        loginPage = true;
        string responseBody = null;
        HttpResponse response = new HttpResponse();
        List < Per_User_Credentials__c > userList = new List < Per_User_Credentials__c > ();
        try {
            userList = [SELECT Id, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
            if (userList.isEmpty()) {
                showWarning = false;
                statusCode = 999;
                return null;
            }
            strExistingUserName = userList[0].UserName__c;
            strExistingUserPassword = userList[0].Password__c;
            if (isondemandtoken == true) {

                response = getResp(userList[0].UserName__c, userList[0].Password__c, accesstoken);
                System.debug('======response1======='+response);
            } else {

                response = getTOPSResponse(userList[0].UserName__c, userList[0].Password__c);
                System.debug('======response2======='+response);
            }
            System.debug('@ ACET_LoginFlowCtrl: validateTopsCredentials: responseBody:' + response.getBody());
            responseBody = response.getBody();
            statusCode = response.getStatusCode();
            ACET_PerUserCredentialResultWrapper loginData;
            if (String.isNotBlank(responseBody)) {
                loginData = ACET_PerUserCredentialResultWrapper.parse(responseBody);
            }
            if (statusCode == 200) {
                if (responseBody != null && responseBody.containsIgnoreCase('userProfile')) {
                    System.debug('loginData.PostResult.userProfile.businessGroups::' + loginData.PostResult.userProfile.businessGroups);
                    Cache.Session.put('local.TOPSProfileInfo.userId', loginData.PostResult.userProfile.userId, 28800, Cache.Visibility.ALL, true);
                    Cache.Session.put('local.TOPSProfileInfo.businessGroups', loginData.PostResult.userProfile.businessGroups, 28800, Cache.Visibility.ALL, true);
                    /*US3273505 - Adding CosmosUserId to cache for COB*/
                    Cache.Session.put('local.TOPSProfileInfo.cosmosId', loginData.PostResult.userProfile.cosmosUserId, 28800, Cache.Visibility.ALL, true);
                    /*US3308339 - Adding userToken to cache for Accumulation Non Therapy */
                    Cache.Session.put('local.TOPSProfileInfo.userToken', loginData.PostResult.userTokens[0].userToken, 28800, Cache.Visibility.ALL, true);
                    if (Test.isRunningTest() || (pageRef != null && pageRef.getUrl().containsignoreCase('ACET_LoginFlowPage'))) {
                        /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
                        for (ACET_PerUserCredentialResultWrapper.userTokens tokenData: loginData.PostResult.userTokens) {
                            tokenData.daysRemainingPasswordExpiration = (WSConfigurations.get('MVPTokenDaysPasswordExp') != null && WSConfigurations.get('MVPTokenDaysPasswordExp').Is_Available__c) ?
                                String.valueOf(WSConfigurations.get('MVPTokenDaysPasswordExp').value__c) : tokenData.daysRemainingPasswordExpiration;
                            if (!isSNIUser && !showWarning && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) <= 14 && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) > 1) {
                                System.debug(' ****** Inside Days less than 14 ');
                                expiryDate = String.valueOf(system.today().adddays(Integer.valueOf(tokenData.daysRemainingPasswordExpiration)));
                                expiryDate = formatDate(expiryDate);
                                showWarning = true;
                                loginPage = false;
                                boolShowPasswordUpdatePanel = true;
                            } else if (!isSNIUser && !showWarning && Integer.valueOf(tokenData.daysRemainingPasswordExpiration) <= 1) {
                                System.debug(' ****** Inside Days less than 1 ');
                                expiryDate = String.valueOf(system.today().adddays(Integer.valueOf(tokenData.daysRemainingPasswordExpiration)));
                                expiryDate = formatDate(expiryDate);
                                showWarning = false;
                                loginPage = false;
                                boolShowPasswordUpdatePanel = true;
                            } else {
                                loginPage = false;
                                showWarning = false;
                                boolShowPasswordUpdatePanel = false;
                            }
                        }
                        /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
                        if (!showWarning && !boolShowPasswordUpdatePanel && !loginPage) {
                            return Auth.SessionManagement.finishLoginFlow();
                        }
                    }
                } else {
                    statusCode = 997;
                    return null;
                }
            } else if (statusCode == 400) {
                showError = true;
                for (ACET_PerUserCredentialResultWrapper.Errors errorData: loginData.PostResult.errors) {
                    if (errorData.code == 400) {
                        errorMessage = errorData.description;
                    }
                }
            } else if (statusCode == 404) {
                errorMessage = ACETUtility.getErrorMessage('CLD200');
                showError = true;
                showWarning = false;
            } else if (statusCode == 500) {
                errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                showError = true;
            } else if (statusCode == 401) { //US3136501 - on demand token generation
                system.debug('-------Topsnoofexec------' + Topsnoofexec);
                if (Topsnoofexec == 1) {
                    Topsnoofexec = 2;
                    HttpResponse httpRes = ACET_WebserviceCalloutFramework.getStargateAccessToken('StarGateTokenAPI');
                    Map < String, Object > oAuthResponseMap = (Map < String, Object > ) JSON.deserializeUntyped(httpRes.getBody());
                    accesstoken = oAuthResponseMap.containsKey('access_token') ? (String) oAuthResponseMap.get('access_token') : null;
                    expiresIn = (Integer) oAuthResponseMap.get('expires_in');
                    if (string.isNotBlank(accessToken) && accessToken != null) {
                        isondemandtoken = true;
                        validateTopsCredentials();
                    }
                }
            } else {
                showError = true;
            }
            if (isondemandtoken == true) {
                isondemandtoken = false;

                ACET_WebserviceCalloutFramework.storeStargateToken(accesstoken, expiresIn);
            }

        } catch (Exception ex) {
            System.debug('@ ACET_LoginFlowCtrl: validateTopsCredentials: exception:' + ex.getMessage());
        }
        return null;
    }

    public static String getAuthToken() {
        return ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c;
    }
    // US2500710 - Cancel button Tops Credential - Inshar [4/14/2020]
    public PageReference skipTOPSLogin() {
        return Auth.SessionManagement.finishLoginFlow();
    }

    public static string formatDate(String dateStr) {
        List < String > dateArr = new List < String > ();
        try {
            if (String.isNotBlank(dateStr)) {
                dateArr = dateStr.split('-');
            }
            String returnStr;
            if (dateArr != null && dateArr.size() > 0) {
                return returnStr = dateArr[1] + '/' + dateArr[2] + '/' + dateArr[0];
            } else
                return dateStr;
        } catch (Exception e) {
            System.debug('Exception occured=' + e.getStackTraceString());
            return '';
        }
    }

    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public pageReference renderUpdatePasswordPanel() {
        boolShowPasswordUpdatePanel = true;
        loginPage = false;
        bannerPage = false;
        showWarning = false;
        List < Per_User_Credentials__c > existinguserCredentialList = new List < Per_User_Credentials__c > ();
        existinguserCredentialList = [SELECT Id, User__c, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];

        if (!existinguserCredentialList.isEmpty()) {
            strExistingUserName = existinguserCredentialList[0].UserName__c;
            strExistingUserPassword = existinguserCredentialList[0].Password__c;
        }
        return null;
    }


    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public HttpResponse getUpdateORSPasswordResponse(string userName, string userPassword, String userNewPassword) {
        isUpdatePasswordOperation = true;
        getEndpoint();
        // Request Body
        postInputforUpdate postInput = new postInputforUpdate();
        topsSourceSystemParametersUpdate topsParameters = new topsSourceSystemParametersUpdate();
        topsParameters.userId = userName;
        topsParameters.userPassword = userPassword;
        topsParameters.newUserPassword = userNewPassword;
        List < controlModifiersUpdate > lstofControlModifiers = new List < controlModifiersUpdate > ();
        controlModifiersUpdate ctrlModifier = new controlModifiersUpdate();
        ctrlModifier.topsSourceSystemParameters = topsParameters;
        lstofControlModifiers.add(ctrlModifier);
        postInput.encryptionIndicatorTOPS = true;
        postInput.controlModifiers = lstofControlModifiers;
        RequestBody = JSON.serialize(postInput);
        RequestBody = '{"putInput":' + RequestBody + '}';
        Method = WSConfigurations.get('EAIPUpdatePasswordLoginHTTPMethod') != NULL ? string.valueof(WSConfigurations.get('EAIPUpdatePasswordLoginHTTPMethod').Value__c) : 'PUT';
        HttpResponse response = new HttpResponse();
        response = send(OAuthConfig);
        return response;
        // Request Body End
    }

    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public PageReference UpdateORSCredentials() {
        showSuccessMessage = false;
        String responseBody = null;
        HttpResponse response = new HttpResponse();
        try {
            response = getUpdateORSPasswordResponse(strExistingUserName, strExistingUserPassword, ACET_TOPSEncryptionAlgorithm.getEncryptedString(strNewPassword));
            responseBody = response.getBody();
            Integer statusCode = response.getStatusCode();
            system.debug('==@@ StatusCode1 =' + statusCode + '==@@ responsebody is ' + responseBody);
            if (statusCode == 200) {
                isUpdatePasswordOperation = false;
                Method = WSConfigurations.get('EAIPLoginFlowHttpMethod') != NULL ? string.valueof(WSConfigurations.get('EAIPLoginFlowHttpMethod').Value__c) : 'POST';
                httpResponse tokenResponse = getTOPSResponse(strExistingUserName, ACET_TOPSEncryptionAlgorithm.getEncryptedString(strNewPassword));
                System.debug('@ ACET_LoginFlowCtrl: UpdateORSCredentials: tokenresponseBody:' + tokenResponse.getBody());
                string tokenResponseBody = tokenResponse.getBody();
                Integer tokenStatusCode = tokenResponse.getStatusCode();
                ACET_PerUserCredentialResultWrapper loginData;
                system.debug('==@@ StatusCode =' + tokenStatusCode + '==@@ tokenBdy is ' + tokenResponseBody);
                if (tokenStatusCode == 200 && string.isNotBlank(tokenResponseBody)) {
                    isUpdateFailed = false;
                    loginData = ACET_PerUserCredentialResultWrapper.parse(tokenResponseBody);
                    if (tokenResponseBody.containsIgnoreCase('userProfile')) {
                        Cache.Session.put('local.TOPSProfileInfo.userId', loginData.PostResult.userProfile.userId, 28800, Cache.Visibility.ALL, true);
                        Cache.Session.put('local.TOPSProfileInfo.businessGroups', loginData.PostResult.userProfile.businessGroups, 28800, Cache.Visibility.ALL, true);
                        /*US3273505 -  Adding CosmosUserId to cache for COB*/
                        Cache.Session.put('local.TOPSProfileInfo.cosmosId', loginData.PostResult.userProfile.cosmosUserId, 28800, Cache.Visibility.ALL, true);
                        /*US3308339 - Adding userToken to cache for Accumulation Non Therapy */
                        Cache.Session.put('local.TOPSProfileInfo.userToken', loginData.PostResult.userTokens[0].userToken, 28800, Cache.Visibility.ALL, true);
                    }
                } else if (tokenStatusCode == 400) {
                    isUpdateFailed = true;
                    isSucessfullyUpdated = false;
                    showSuccessMessage = false;
                    for (ACET_PerUserCredentialResultWrapper.Errors errorData: loginData.PostResult.errors) {
                        if (errorData.code == 400) {
                            errorMessage = errorData.description;
                        }
                    }
                } else if (tokenStatusCode == 404) {
                    errorMessage = ACETUtility.getErrorMessage('CLD200');
                    isUpdateFailed = true;
                    isSucessfullyUpdated = false;
                    showSuccessMessage = false;
                } else if (tokenStatusCode == 500) {
                    errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                    isUpdateFailed = true;
                    isSucessfullyUpdated = false;
                    showSuccessMessage = false;
                } else {
                    errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                    isUpdateFailed = true;
                    isSucessfullyUpdated = false;
                    showSuccessMessage = false;
                }
                //Second callout end
                List < Per_User_Credentials__c > existinguserCredentialList = new List < Per_User_Credentials__c > ();
                existinguserCredentialList = [SELECT Id, User__c, UserName__c, Password__c, old_password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
                if (!existinguserCredentialList.isEmpty()) {
                    existinguserCredentialList[0].Password__c = ACET_TOPSEncryptionAlgorithm.getEncryptedString(strNewPassword);
                    existinguserCredentialList[0].old_password__c = strExistingUserPassword;
                    update existinguserCredentialList;
                }
                String isUserPage = ApexPages.currentPage().getParameters().get('id');
                if (String.isBlank(isUserPage)) {
                    showSuccessMessage = true;
                } else {
                    isSucessfullyUpdated = true;
                }
            } else if (statusCode == 400) {
                ACET_TOPSUpdatepasswordResultWrapper errorResponse = ACET_TOPSUpdatepasswordResultWrapper.parse(responseBody);
                for (ACET_TOPSUpdatepasswordResultWrapper.Errors errorData: errorResponse.putResult.errors) {
                    if (errorData.code == 400) {
                        errorMessage = errorData.description;
                    }
                }
                //errorMessage = 'Error! TOPS Credentials password update Failed';
                isUpdateFailed = true;
                isSucessfullyUpdated = false;
                showSuccessMessage = false;
            } else if (statusCode == 404) {
                errorMessage = ACETUtility.getErrorMessage('CLD200');
                isUpdateFailed = true;
                isSucessfullyUpdated = false;
                showSuccessMessage = false;
            } else if (statusCode == 500) {
                errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                isUpdateFailed = true;
                isSucessfullyUpdated = false;
                showSuccessMessage = false;
            } else {
                errorMessage = ACETUtility.getErrorMessage('AEFNEE');
                isUpdateFailed = true;
                isSucessfullyUpdated = false;
                showSuccessMessage = false;
            }
        } catch (exception ex) {
            System.debug('@ ACET_LoginFlowCtrl: UpdateORSCredentials: exception:' + ex.getStackTraceString() + ex.getMessage());
        }
        system.debug('=isSucessfullyUpdated= ' + isSucessfullyUpdated);
        return null;
    }

    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public class postInputforUpdate {
        public List < controlModifiersUpdate > controlModifiers;
        public boolean encryptionIndicatorTOPS;
    }

    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public class controlModifiersUpdate {
        public topsSourceSystemParametersUpdate topsSourceSystemParameters;
    }

    /*US2260431 - Update Password Implementation - Durga [27/05/2020]*/
    public class topsSourceSystemParametersUpdate {
        public String userId;
        public String userPassword;
        public String newUserPassword;
    }
}