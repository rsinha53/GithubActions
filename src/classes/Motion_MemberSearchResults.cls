public with sharing class Motion_MemberSearchResults {
    @AuraEnabled
public static Motion_MemberSearchUtil.TableDetails setCredentialData(MotionMemberwrapper memberDetailResult) {
        List < MotionMemberwrapper.Data > credDetails = memberDetailResult.memberRecord;
        MotionMemberwrapper.PageDetails wraperPaginations = memberDetailResult.pagination;
        Motion_MemberSearchUtil.TableDetails affTable = new Motion_MemberSearchUtil.TableDetails();
    
        affTable.type = 'table';
       
        affTable.tableHeaders = new List < String > {
            'DERM ID',
            'First Name',
            'Last Name',
			'Dependent Code',
			'DOB',
			'Email Address',
			'Address',
			'Client',
			'Group Number',
            'Group Name',
			'Status',
			'Plan Type'
        };
        List <Motion_MemberSearchUtil.TableRow > tableRows = new List < Motion_MemberSearchUtil.TableRow > ();
            
        if (credDetails != null) {
            system.debug('credDetailsforAddress: '+credDetails);
            for (integer i = 0; i < credDetails.size(); i++) {
                String dtBirth = MotionCommonUtil.convertToDateFormat(credDetails[i].BirthDate);
                
                String AddressLine1 = (credDetails[i].Address	!='' && credDetails[i].Address	!= NULL ? credDetails[i].Address+'<br/>' : '');
                String AddressCity 	= (credDetails[i].City		!='' && credDetails[i].City		!= NULL? credDetails[i].City+',' : '');
                String AddressState = (credDetails[i].State		!='' && credDetails[i].State	!= NULL? credDetails[i].State : '');
                String AddressZip 	= (credDetails[i].ZipCode	!='' && credDetails[i].ZipCode	!= NULL? credDetails[i].ZipCode : '');
                         
                //String completeAddress =credDetails[i].Address1+'<br/>'+credDetails[i].City+' '+ credDetails[i].State+' '+ credDetails[i].ZipCode;
                String completeAddress =AddressLine1+AddressCity+' '+ AddressState+' '+ AddressZip;
               
                Motion_MemberSearchUtil.TableRow tableRow = new Motion_MemberSearchUtil.TableRow();
                List < Motion_MemberSearchUtil.RowColumnData > rowColumns = new List < Motion_MemberSearchUtil.RowColumnData > ();
                rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', (credDetails[i].RegisteredMemberID!= '0'?credDetails[i].RegisteredMemberID:'--' ),'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('link', credDetails[i].FirstName,credDetails[i].LastName,credDetails[i].FirstName,credDetails[i].RegisteredMemberID,credDetails[i].EligibleMemberID, credDetails[i].EmailAddress , credDetails[i].BirthDate, credDetails[i].GroupName, credDetails[i].GroupNumber, credDetails[i].HomePhone));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('link', credDetails[i].LastName,credDetails[i].LastName,credDetails[i].FirstName,credDetails[i].RegisteredMemberID,credDetails[i].EligibleMemberID, credDetails[i].EmailAddress , credDetails[i].BirthDate, credDetails[i].GroupName, credDetails[i].GroupNumber,credDetails[i].HomePhone));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].DependentCode,'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', dtBirth,'','','','','','','','',''));
                rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].EmailAddress,'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('unescapedHtml',  completeAddress,'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].ClientName,'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].GroupNumber,'','','','','','','','',''));
                rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].GroupName,'','','','','','','','',''));
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('outputText', credDetails[i].Status,'','','','','','','','',''));			    
				rowColumns.add(Motion_MemberSearchUtil.setRowColumnData('unescapedHtml', credDetails[i].PlanType,'','','','','','','','',''));
               
                tableRow.rowColumnData = rowColumns;
               
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
            affTable.paginations = setPaginations(wraperPaginations);
        }
        return affTable;
    }

    public static Motion_MemberSearchUtil.Pagination setPaginations(MotionMemberwrapper.PageDetails paginations){
        Motion_MemberSearchUtil.Pagination tablePagination = new Motion_MemberSearchUtil.Pagination();
        
        tablePagination.startNumber = paginations.Offset;
        if(paginations.Offset > 0){
         tablePagination.endNumber = (paginations.LastPage == true? 0:1);   
        }else{
            tablePagination.endNumber = (paginations.LastPage == true? 1:0);
        }
        
        tablePagination.recordCount = paginations.Total;
        tablePagination.noOfPages = paginations.Totalpages;
        tablePagination.numberOfRecordsPerPage  = paginations.Limit_Z;       
        return tablePagination;
    }
    
    
}