/*****************************************************************************************************
ACET_FAST_Constants
Author: Shaik Mohammad Yaseen
Date: 10/20/2020
Description: This is a constants class where we will have static variables like errors, messages and lists. 
Initial: Shaik Mohammad Yaseen
*****************************************************************************************************/
public class ACET_FAST_Constants {

    public static String reactiveResolution='Reactive Resolution';
    public static String proactAction='Proactive Action';
    static String proactiveAction='Proactive Action';
    static String RegionV='Region V';
    //Valid Roles 
    public static Set<String> validRoles = new Set<String>{'OPO PIR','PIR - Reactive/Proactive Supervisor','System Administrator'};
   //Valid Profile 
   public static Set<String> validProfiles = new Set<String>{'Integration Only','System Administrator'};
    //Valid ACET case recordtypes
    public static Set<String> validACETCaseRecordTypes = new Set<String>{reactiveResolution, proactiveAction, 'Reactive Resolution Closed', 'Proactive Action Closed'};
    //Case Record Type Name Record Type Developer Name Map
    public static Map<String,String> caseRcTypNameRcTypDevNameMap = new Map<String,String>{reactiveResolution =>'Reactive_Resolution',proactiveAction =>'Proactive_Action','Reactive Resolution Closed'=>'Reactive_Resolution_Closed','Proactive Action Closed'=>'Proactive_Action_Closed'};
    
    //Fast Role Access Error
    public static string notaValiFastRoleError = 'Only SMEs, Supervisors and OPO PIR team members can edit cases they do not own.';
    //cannot create or update closed case task
    public static string cannotAddTaskToClosedCases = 'Tasks can only be added to open cases.';
    //task fields are mandatory error
    public static string taskFieldsMandatoryError = 'Please enter all required fields(Due Date, Status, Priority)';
    //task due date cannot be changed error
    public static string taskDueDateChangeError = 'Due date Cannot be changed';
    //task due date cannot be a past date
    public static string taskDueDatepastDateError = 'Due date Cannot be a PastDate';
    //Field is mandatory Error
    public static string mandatoryFieldError = 'Complete this Field';
    //FAST Case Origin List
    public static List<String> caseOriginList = new List<String>{'Phone Call','Email/Fax','Internal','PDAR','Portal - Contact Us','Provider Meeting','Uno','Web'};
   	//FAST Case Topic List
    public static List<String> caseTopicList = new List<String>{'Accounts Receivable','Balance Billing','FFA','Proactive EWS',reactiveResolution};
    public static List<String> caseSpecialtyList = new List<String>{'ePals','Local Ancillary','National Ancillary','NE Ancillary','NE ROS','PICT',RegionV,'SNI','SPAR','Supervisor Escalation Team'};
  	//Open tasks and Resolution parter Error for Closing cases
  	public static string OpenTasksError = 'Please review open task and Resolution partner details';

 	//Open PIR details Error for Closing cases 
  	//public static string OpenPIRDetailsError = 'Please close open PIR details before closing the Case';
	public static string OpenPIRDetailsError = 'Please fill the required fields in PIR Details to close this case';
    //Interaction controller constants
 	public static List<String> typeList = new List<String>{'Community and State','Employer and Individual','Medicare and Retirement'};   
    public static List<String> subTypeList = new List<String>{'Central','Global','Northeast',RegionV,'Southeast','West'};
}