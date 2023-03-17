public class ACETOILIndividual {
	public String FirstName { get; set; }
	public String LastName { get; set; }
	public String suffix { get; set; }
	public String middleInitial { get; set; }
	public Date Birthdate { get; set; }
	public Set<String> SurrogateKeys { get; set; }
	public String EId { get; set; }
	public String Phone { get; set; }

	public ACETOILIndividual() {
		SurrogateKeys = new Set<String>();
	}

	public ACETOILIndividual(String FirstName, String LastName, Date Birthdate, Set<String> SurrogateKeys, String EId, String Phone,String suffix, String middleInitial) {
		this.FirstName = FirstName;
		this.LastName = LastName;
		this.Birthdate = Birthdate;
		this.SurrogateKeys = SurrogateKeys;
		this.EId = EId;
		this.Phone = Phone;
		this.suffix = suffix;
		this.middleInitial = middleInitial;
	}
}