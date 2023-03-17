public class ACET_ClaimActionResultWrapper {

	public class TicketInfo {
		public String ticketNumber;
		public String ticketStatus;
		public String submissionDate;
	}

	public List<Actions> actions;

	public class Actions {
		public String ticketType;
		public String allowedAction;
		public List<TicketInfo> ticketInfo;
	}

	
	public static ACET_ClaimActionResultWrapper parse(String json) {
		return (ACET_ClaimActionResultWrapper) System.JSON.deserialize(json, ACET_ClaimActionResultWrapper.class);
	}
}