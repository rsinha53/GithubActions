/*
 * * Author : Sai Kolluru
 */

public without sharing class ADBFollowupsWorkloadListReqWrapper {

    public ControlModifiersType controlModifiersType;
	public class ControlModifiersType {
		public OrsSystemParameter orsSystemParameter;
	}

	public class WorkLoadSelection {
		public String associateId;
		public String officeId;
		public String departmentCode;
	}

	public class ServiceOption {
		public String key;
		public String value;
	}

	public class OrsSystemParameter {
		public String logonId;
		public String logonOffice;
	}

	public class RequestHeader {
		public String applicationName;
		public String applicationInstanceName;
		public String logLevel;
		public List<ServiceOption> serviceOption;
	}

	
	public List<WorkLoadSelection> workLoadSelection;
	public String businessIndicator;
	public String requestIndicator;
	public String sortOrder;
	public RequestHeader requestHeader;


}