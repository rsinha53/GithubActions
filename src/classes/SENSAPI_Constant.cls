public class SENSAPI_Constant {
    
    //router layer
    public static final String SOURCE_SERVICE_ERROR = 'Service not found or Incorrect Source';
    public static final String SOURCE_ERROR = 'Source is empty or incorrect';
    

    public static final String REQUIREDFIELD_MISSING = 'Required parameters cannot be blank';
    public static final String NOUSER_EXIST = 'No user exists for ROI record owner';
    public static final String NORECORDS_FOUND = 'No records found';
    public static final String ALLACTIVE_ROIRECORDS = 'All ROI records are active';
    public static final String CTM_ALREADY_REGISTERED = 'Member is already registered!';
    public static final String INVALID_EMAIL_SENSID = 'Email Id and Sens Id is required.';
    public static final String NO_CTM_FOUND = 'No Care Team Member found';
    public static final String CTM_REGISTERED_STATUS = 'Registered';
    public static final String ACTION_NOT_BLANK = 'Action Cannot Be Blank';
    public static final String NO_ID_INSERT = 'SENS Id Not Needed For INSERT Call';
    public static final String NO_FAMILYACCOUNT = 'No family account exists with the subscriber id';
    public static final String NO_FEEDFOUND = 'Thread does not exists';
    public static final String NO_CARETEAM = 'No Care Team member found with this subscriber id';
    public static final String NO_FAMILYFOUND = 'Invalid family sens id';
    public static final String INVALID_FAMILYID = 'Invalid family sens id';
    public static final String NO_ROIEXISTS = 'No ROI exists for the member';
    public static final String NO_ROICREATED = 'No Care Team Member found to create ROI records';
    public static final String INVALID_MEMBERID = 'Invalid member Id or member does not belong to this family';
    public static final String INCORRECT_COMBO = 'Combination of subscriber id and sens id is incorrect';
    public static final String CARETEAM_REGISTER = 'Care team member is already registered';
    
    public static final String JSON_PARSER_ERROR = 'JSON Parser Error: ';
    public static final String NO_FAMILY_FOUND = 'No family record found for given Subscriber Id';
    public static final String SUBSCRIBER_ID_REQUiRED = 'Subscriber Id is required';
    public static final String TRY_AGAIN = 'Request Failed. Try again.';
    public static final String CTM_STATUS_REMOVED = 'Removed';

    public static final String MEMBER_INFO_MISSING = 'Member Information Missing';
    public static final String NO_DOCUMENTS = 'No Documents Uploaded';
    public static final String USER_INACTIVE = 'No user found or user is inactive';
    
    //Update Member API
    public static final String MOBILE_NUMBER_VALIDATION = 'Phone Number must be 10 digit number';
    public static final String INVALID_USER_DETAILS = 'Invalid user details';
    public static final String PASS_MOBILE_NUMBER = 'Phone number must be passed to enable Text SMS Notification';
    
    // GET Content Document API
    public static final String NO_DOCUMENTS_FOUND = 'No Document(s) Found';
    
    //POST MarkThreadAsRead API
    public static final String INVALID_THREADID = 'Invalid thread id';
    public static final String NO_STATUS_RECORD = 'User is not part of this Conversation';
    
    public static final String EMAIL_ADDRESS_INVALID = 'Email Address is invalid';
	
    public static final String MEMBER_ALREADY_REMOVED = 'Member is already removed';
    
    //GET Threads API
    public static final String PAGINATION_COUNT_ERROR = 'Count should be greater than 0';
    public static final String PAGINATION_OFFSET_ERROR = 'Offset should be greater than or equal to 0';
    public static final String PAGINATION_OFFSET_COUNT_TOGETHER = 'Offset and Count should be passed together';
    
    //ROI APIs
    public static final String ROI_STATUS_ACTIVE = 'Active';
    public static final String ROI_STATUS_INACTIVE = 'InActive';
    
    public static final Boolean CREATE_LOGS = True;
    
    public static final String ACTIVITY_TYPE_ERROR = 'Please provide correct action type';
}