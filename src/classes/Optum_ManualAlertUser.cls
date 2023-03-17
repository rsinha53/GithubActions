/*
 Name           : OPTUM_ManualAlertUser
 Created By     : Dimpy Arora
 Created Date   : Sep 28th, 2020
 Description    : Wrapper for ManualAlert */

public class Optum_ManualAlertUser{
    @AuraEnabled
    public String responseCode;
    @AuraEnabled
    public String responseMsg;
    @AuraEnabled
	public cls_meta meta;
    @AuraEnabled
	public cls_result result;
    @AuraEnabled
	public cls_status status;
   
	class cls_meta {
	}
	class cls_result {
        @AuraEnabled
		public cls_resultMeta resultMeta;
        @AuraEnabled
		public cls_data data;
	}
	class cls_resultMeta {
	}
	class cls_data {
        @AuraEnabled
		public cls_accountsInfos[] accountsInfos;
	}
	class cls_accountsInfos {
        @AuraEnabled
		public String dateOfBirth;	//1954-03-27T00:00:00
        @AuraEnabled
		public Integer accountNumber;	//270000000
        @AuraEnabled
		public String ssn;	//565656565
        @AuraEnabled
		public String accountStatus;	//0
        @AuraEnabled
		public String firstName;	//Marketing
        @AuraEnabled
		public String middleInitial;
        @AuraEnabled
		public String lastName;	//TestMYUHC
        @AuraEnabled
		public String address;	//2770 blue water rd apt 24
        @AuraEnabled
		public String city;	//Plymouth
        @AuraEnabled
		public String state;	//MN
        @AuraEnabled
		public String zip;	//55446-0002
        @AuraEnabled
		public String homePhone;	//1234567891
        @AuraEnabled
		public String workPhone;	//1234567892
        @AuraEnabled
		public String cellPhone;	//9876543210
        @AuraEnabled
		public String email;	//jeremie@optum.com2
        @AuraEnabled
		public String groupID;	//TEST5
        @AuraEnabled
		public String groupName;	//TESTUHC
        @AuraEnabled
		public String dateOpened;	//2004-12-03T00:00:00
        @AuraEnabled
		public Double currentBalance;	//-99999967398.59
        @AuraEnabled
		public Double statementRate;	//0.0001
        @AuraEnabled
		public String dateLastDeposit;	//2020-08-18T00:00:00
        @AuraEnabled
		public Double amountLastDeposit;	//99999999.99
        @AuraEnabled
		public String webBrandId;	//UHEAL
        @AuraEnabled
		public String employeeID;	//0000testemp
        @AuraEnabled
		public String activeNotes;	//test enter||Bulk Upload no date||This is a test from non elevated role||Test Test||Single entry no expiration||Bulk entry no expiration||File import only PCV no expiration||File import only PCV no expirationkk||||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Delivery Preference Updated||Returned Mail Delivery Preference Updated
	}
	
	class cls_status {
        @AuraEnabled
		public cls_messages[] messages;
	}
	class cls_messages {
        @AuraEnabled
		public String code;	//000
        @AuraEnabled
		public String name;	//Success
        @AuraEnabled
		public String severity;	//Info
        @AuraEnabled
		public String description;	//Success
	}
	public static Optum_ManualAlertUser parse(String json){
		return (Optum_ManualAlertUser) System.JSON.deserialize(json, Optum_ManualAlertUser.class);
	}

	}