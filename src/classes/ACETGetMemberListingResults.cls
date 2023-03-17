public class ACETGetMemberListingResults implements Queueable, Database.AllowsCallouts {
 Public string inquiryDate;
 Public String request;
 Public string statusPDF;
 Public string groupId;
 Public string bundleID;
 Public List < String > listbundles;
 Public string selectedPopulation;
 Public List < String > listpops;
 Public string continuationType;
 Public Integer intcallscount;
 Public string hasPop;
 Public String groupName;
 Public String contractId;
 Public Integer cobraCount;
 Public List < ACETViewMemberListingResultsWrapper > finalListadded;
 Public List < ACETViewMemberListingResultsWrapper > finalList;
 Public string contenttype;
 Public string error;
 Public Boolean startnextjob;
 Public Boolean checker;
 Public Boolean sendresults;
 Public Integer i;

 public ACETGetMemberListingResults(string inquiryDate, String request, string statusPDF, string groupId, string bundleID, List < String > listbundles, string selectedPopulation, List < String > listpops, string continuationType, Integer intcallscount, string hasPop, string groupName, string contractId, Integer cobraCount, List < ACETViewMemberListingResultsWrapper > finalListadded, string contenttype) {
  this.inquiryDate = inquiryDate;
  this.request = request;
  this.statusPDF = statusPDF;
  this.groupId = groupId;
  this.bundleID = bundleID;
  this.listbundles = listbundles;
  this.selectedPopulation = selectedPopulation;
  this.listpops = listpops;
  this.continuationType = continuationType;
  this.intcallscount = intcallscount;
  this.groupName = groupName;
  this.contractId = contractId;
  this.cobraCount = cobraCount;
  this.finalListadded = finalListadded;
  this.contenttype = contenttype;
  this.hasPop = hasPop;
 }

 public void execute(System.QueueableContext qc) {
  List < SelectOption > options;
  Map < String, String > viewMap = ACETViewMemberListingController.getMapViewValues();
  Map < String, String > statusMap = ACETViewMemberListingController.getMapStatusValues();
  ACETWSCalloutResult searchResults = new ACETWSCalloutResult();
  List < ACETViewMemberListingResultsWrapper > searchMemberListingResults = new List < ACETViewMemberListingResultsWrapper > ();
  List < ACETViewMemberListingResultsWrapper > bundleList = new List < ACETViewMemberListingResultsWrapper > ();
  List < ACETViewMemberListingResultsWrapper > statusList = new List < ACETViewMemberListingResultsWrapper > ();
  List < ACETViewMemberListingResultsWrapper > filteredList = new List < ACETViewMemberListingResultsWrapper > ();
  finalList = new List < ACETViewMemberListingResultsWrapper > ();
  String dateValues = ACETViewMemberListingController.convertDateFormat(inquiryDate);
  Boolean isSubscriber = ACETViewMemberListingController.isSubscriber(viewMap.get(request));
  String Status;
  String statusValue = statusMap.get(statusPDF);
  integer Index = 0, j;
  ACETViewMemberListingWebService getMemberListing = new ACETViewMemberListingWebService();
  if (statusValue == 'Future')
   status = 'ActiveFuture';
  else {
   status = statusValue;

  }
  system.debug('groupName-->' + groupName);
  system.debug('~~~status before for' + status + index);

  system.debug('~~~status' + status + '~' + index + '~' + j);
  getMemberListing.init(groupId, dateValues, isSubscriber, status, bundleID);
  i = intcallscount;
  system.debug('intcallscount' + intcallscount);
  Integer k = 1;
  Integer MemberListingRecordsPerCall = integer.valueof(System.Label.ACETMemberListingRecordsPerCall);

  checker = true;

  do {
   searchResults = getmemberlisting.querypaginateddata(i, MemberListingRecordsPerCall, 1);
   system.debug('***' + searchResults);
   if (searchResults.Success) {
    List < ACETViewMemberListingResultsWrapper > tempList = (List < ACETViewMemberListingResultsWrapper > ) searchResults.Response;
    searchMemberListingResults.addAll(tempList);
    system.debug('***checker' + checker);
    system.debug('!!!!!!! New ' + i + ':' + searchMemberListingResults);

   } else {
    error = String.valueOf(searchResults.StatusCode);
   }
   i = i + 1;
   k = k + 1;
   boolean jobstarted;
   if (searchResults.hasNextPage == false && jobstarted != true || k == 10 && jobstarted != true || i == 300 && jobstarted != true) {

    checker = false;
    if (searchResults.hasNextPage == true && k == 10) {
     startnextjob = true;
    } else if (searchResults.hasNextPage == false) {
     sendresults = true;
    }
   }

  } while (checker == true);
  system.debug('searchMemberListingResults size-->' + searchMemberListingResults.size());
  if (searchMemberListingResults != null) {
   for (ACETViewMemberListingResultsWrapper fil: searchMemberListingResults) {
    if (listbundles != null) {
     for (string s: listbundles) {
      if (fil.bundleId == s) {
       bundleList.add(fil);
      }
     }
    }
   }
  } else {
   bundleList = searchMemberListingResults;

  }

  system.debug('bundleList ' + bundleList.size());

  if (bundleList != null) {

   if (statusValue == 'Future') {
    for (ACETViewMemberListingResultsWrapper sta: bundleList) {
     if (sta.Status.toLowerCase() == statusValue.toLowerCase()) {
      statusList.add(sta);
     }
    }
   } else
    statusList = bundleList;
  }
  system.debug('selectedPopulation-->' + selectedPopulation);
  if (selectedPopulation != 'All' && selectedPopulation != null && selectedPopulation != '' && selectedPopulation != 'undefined') {
   for (ACETViewMemberListingResultsWrapper pop: statusList) {
     string pop1 = pop.population.deleteWhitespace();
       string pop2 =  selectedPopulation.deleteWhitespace();
       if(pop1.trim() == pop2.trim()){
     filteredList.add(pop);
    }
   }

  } else if (selectedPopulation == 'All') {
   for (ACETViewMemberListingResultsWrapper pop: statusList) {
    if (listpops != null && listpops.size() > 0) {
     for (string s: listpops) {
	 string pop1 = pop.population.deleteWhitespace();
       string pop2 =  s.deleteWhitespace();
       if(pop1.trim() == pop2.trim()){
      
       filteredList.add(pop);
      }
     }
    }
   }
  } else {
   filteredList = statusList;
  }


  if (filteredList != null) {
   for (ACETViewMemberListingResultsWrapper filItem: filteredList) {
    if (filItem.continuationType == 'Y') {
     filItem.continuationType = continuationType;
    } else {
     filItem.continuationType = '';
    }
    finalList.add(filItem);
   }
  }

  if (finalListadded != null) {
   finalList.addall(finalListadded);
  }
  finalList.sort();
  system.debug('sendresults' + sendresults);
  system.debug('finalList size--->' + finalList.size());
  if (sendresults == true && error == null) {
   Temp_Document__c tempdoc = new Temp_Document__c();
   insert tempdoc;

   string body1 = JSON.serialize(finalList);
   Blob b = Blob.valueOf(body1);
   Attachment attach1 = new Attachment();
   attach1.ParentId = tempdoc.id;
   attach1.Name = string.valueof(system.now());
   attach1.Body = b;
   insert attach1;
   string attachid = String.valueOf(attach1.id);

   System.enqueueJob(New ACETSendMemberlistEmail(hasPop, groupName, groupId, contractId, request, statusPDF, bundleID, inquiryDate, cobraCount, continuationType, selectedPopulation, attachid, contenttype));
  }
  integer MemListingEmailLimit = integer.valueof(system.label.ACETMemListingEmailLimit);
  Boolean MemListingmaxlimit;
  if (finalList.size() > MemListingEmailLimit) {
   MemListingmaxlimit = true;

  }
  if (error != null) {
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {
    UserInfo.getUserEmail()
   };
   mail.setToAddresses(toAddresses);
   mail.setSubject('Error: Member Listing request failed for Group ' + groupId);
   mail.plainTextBody = 'Member Listing request failed. Please try again. \r\n\r\n If the problem persist, email ACETOrionTeam_DL@ds.uhc.com with the Group ID & Group Name for a member listing. This email is for internal use only.';
   Messaging.SendEmail(new Messaging.SingleEmailMessage[] {
    mail
   });
  }
if (startnextjob == true) {
   System.enqueueJob(new ACETGetMemberListingResults(inquiryDate, request, statusPDF, groupId, bundleID, listbundles, selectedPopulation, listpops, continuationType, i, hasPop, groupName, contractId, cobraCount, finalList, contenttype));
  }
 }
}