public class CaseDataWrapper {
        public Map<String, case> mapCaseData {get; set;}
        public CaseDataWrapper() {
        	system.debug(LoggingLevel.INFO, 'mapCaseData: ' + mapCaseData);
        	if (mapCaseData == null) {
            	mapCaseData = new Map<String, case>();
        	}	
        }
    }