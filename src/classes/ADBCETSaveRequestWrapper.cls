/*
 * Created BY : Madhura Priyadarshana
 * Description : Used to structue the request body of Client Event Tracker save api
 * Created Date : 11/28/2020
 * User Story : US3084442
 */
public without sharing class ADBCETSaveRequestWrapper {

	public String assessmentID;
	public String conductedByUserID;
	public String conductedByUserName;
	public Integer assessmentTemplateID;
	public Integer totalScoreNumber;
	public Integer assessmentStatusTypeID;
	public String assessmentStatusReasonTypeID;
	public Integer deliveryMethodTypeID;
	public String builderAssessmentID;
	public Integer builderAssessmentVersionNumber;
	public Integer groupTotalScoreNumber;
	public Integer totalAvgQuestScore;
	public List<AssessmentResponseVOs> assessmentResponseVOs;
	public List<AssessmentResponseChoiceVOs> assessmentResponseChoiceVOs;
	public List<AssessmentResponseVOs> assessmentResponseGridVOs;
	public List<AssessmentSubjectVOs> assessmentSubjectVOs;
	public Integer parentAssessmentID;
	public String timeZoneOffset;
	public Integer sourceApplicationType;
	public String userID;

	public class AssessmentResponseChoiceVOs {
		public String questionID;
		public Integer responseChoiceID;
        	public String responseValue;
	}

	public class AssessmentSubjectVOs {
		public Integer primarySubjectIndicator;
		public Integer sourceApplicationType;
		public Integer sourceApplicationSubjectTypeID;
		public Integer sourceApplicationSubjectID;
	}

	public class AssessmentResponseVOs {
	}
}