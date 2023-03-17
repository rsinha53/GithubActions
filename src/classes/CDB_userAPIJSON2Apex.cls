public class CDB_userAPIJSON2Apex {
	public class Fids {
		public String id;
		public String sourceCD;
	}

	public String eid;
	public List<Fids> fids;
	//public List<Crids> crids;
	//public List<Crids> cmpsMbrNum;
	//public List<Crids> srcSysIds;
	public Object hhsId;

	public class Crids {
	}

	
	public static CDB_userAPIJSON2Apex parse(String json) {
		return (CDB_userAPIJSON2Apex) System.JSON.deserialize(json, CDB_userAPIJSON2Apex.class);
	}
}