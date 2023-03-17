global  without sharing class ADBORSCommitmentsWrapper implements Comparable {
	@AuraEnabled
    public Commitment oppy{ get; set; }
	public class Commitment{
        @AuraEnabled
        public String type{ get; set; }
        @AuraEnabled
        public Date create_Date{ get; set; }
        @AuraEnabled
        public String commitment{ get; set; }
        @AuraEnabled
        public String due_Date{ get; set; }
        @AuraEnabled
        public Boolean isOverdue{ get; set; }
    }
    // Constructor
    public ADBORSCommitmentsWrapper(Commitment op) {
        oppy = op;
    }

    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to ADBORSCommitmentsWrapper
        ADBORSCommitmentsWrapper compareToOppy = (ADBORSCommitmentsWrapper)compareTo;

        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (oppy.create_Date > compareToOppy.oppy.create_Date) {
            // Set return value to a positive value.
            returnValue = -1;
        } else if (oppy.create_Date < compareToOppy.oppy.create_Date) {
            // Set return value to a negative value.
            returnValue = 1;
        }

        return returnValue;       
    }
}