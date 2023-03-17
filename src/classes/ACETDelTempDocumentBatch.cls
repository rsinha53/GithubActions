//to delete temp document and the attachment under it, temp document and attachment is created temporarily (salesforce attachment is used as a content service for iFrame) while viewing document within browser.
global with sharing class ACETDelTempDocumentBatch implements Database.Batchable<sObject>{
 	global Database.QueryLocator start(Database.BatchableContext BC) {
 		Datetime dt = system.now().addHours(-24);
 		return Database.getQueryLocator('select Id from Temp_Document__c where CreatedDate < :dt'); 
 	}   
 	
 	 global void execute(Database.BatchableContext BC, List<Temp_Document__c> scope) {
 	 	Database.Delete (scope);
 	 }
 	 
 	 global void finish(Database.BatchableContext BC) {
 	 	//
 	 }
}