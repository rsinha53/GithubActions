public class ACET_ModalPopupController {
    
    public String message{get;set;}
    public boolean header {get; set;}
	public boolean displayPopup {get; set;}   
    
    public ACET_ModalPopupController(){
        
    }
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
}