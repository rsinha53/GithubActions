public class ACETGetEmployeeRequestWrapper {
    public EmployerGroupRequest getEmployerGroupRequest;
    
    public class EmployerGroupRequest{
        public String groupNumber;
        public EmployerGroupRequest(String groupNumberParam){
            this.groupNumber = groupNumberParam;
        }
    }
    
    public ACETGetEmployeeRequestWrapper(String groupNumberParam){
        getEmployerGroupRequest = new EmployerGroupRequest(groupNumberParam);
    }
}