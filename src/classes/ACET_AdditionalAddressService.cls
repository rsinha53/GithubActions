public class ACET_AdditionalAddressService extends ACETWebservice {
   static final string COMMON_ERROR_MESSAGE ='No Additional Addresses Active Results';
    public override void GetEndpoint() {
        
    }

    @Auraenabled
    public Static ACET_AutoDocUtil.TableDetails getAdditionalAddressesService(String providerId, String taxId, Integer start, Integer endCount, Boolean filtered, Boolean onlyActive) {
        ACET_AutoDocUtil.TableDetails addAddressTable = new ACET_AutoDocUtil.TableDetails();
        addAddressTable.type = 'table';
        addAddressTable.showComponentName = false;
        addAddressTable.showCardStyle = false;
        addAddressTable.isSortable = false;
        addAddressTable.componentName = 'Additional Addresses';
        addAddressTable.autodocHeaderName = 'Additional Addresses';
        addAddressTable.componentOrder = 6;
        addAddressTable.tableHeaders = new List < String > {
            'ADDRESS TYPE',
            'ACTIVE',
            'ADDRESS',
            'COUNTY',
            'PHONE',
            'FAX',
            'EMAIL'
        };
        addAddressTable.startNumber = 0;
        addAddressTable.endNumber = 0;
        addAddressTable.recordCount = 0;
        addAddressTable.noOfPages = 0;

        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        try {

            String activeInd = onlyActive ? 'ACTIVE' : 'BOTH';

            String url = '?app-nm=acet&active-ind=' + activeInd + '&start=' + start + '&count=50' + '&prov-id=' + providerId + '&tax-id-nbr=' + taxId + '&attribute-set=summary_0002';

            SAE_ProviderCardCtrl.ProviderDetails reqParams = new SAE_ProviderCardCtrl.ProviderDetails();
            reqParams.IsSnapshot = true;
            reqParams.SnapshotParameters = url;
            Map < String, Object > provData = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParams, false);

            Integer statCode = Integer.valueOf(provData.get('statusCode'));
            String message = '';
            
            addAddressTable.statusCode = statCode;
            addAddressTable.errorMessage = message;

            List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > returnResponse = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
            
            if (statCode == 200) {
                String DataString = provData.get('providerResponseJSON').toString();
                SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse(DataString);

                Integer recordCount = Integer.valueOf(responseDes.metadata.total);

                returnResponse = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();

                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > primaryAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > comboAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > billingAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > servicingAddrs = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();

                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > primaryAddrsInactive = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > comboAddrsInactive = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > billingAddrsInactive = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();
                List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > servicingAddrsInactive = new List < SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper > ();

                SAE_ProviderSnapshotWrapper.AdditionalAddressCard returnCard = new SAE_ProviderSnapshotWrapper.AdditionalAddressCard();

                Integer currentResponseSize = 0;

                if (responseDes.PhysicianFacilitySummary0002Response != null && !responseDes.PhysicianFacilitySummary0002Response.isEmpty()) {
                    currentResponseSize = responseDes.PhysicianFacilitySummary0002Response.size();
                    for (SAE_ProviderResponse.PhysicianFacilitySummary0002Response resp: responseDes.PhysicianFacilitySummary0002Response) {
                        SAE_ProviderResponse.Address returnAddress = resp.physicianFacilityInformation.address;
                        SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper addr = new SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper();

                        addr.AddressType = returnAddress.addressTypeDescription;
                        addr.IsFreeStandingFacility = '';
                        addr.Address = SAE_ProviderSnapshotController.createAddress(returnAddress, true);
                        addr.Country = returnAddress.postalAddress.county;
                        SAE_ProviderResponse.Phone phoneNo = resp.physicianFacilityInformation.phone.get(0);
                        addr.PhoneNumber = (phoneNo != null ? phoneNo.areaCode : '') + '-'
                                            + (phoneNo.phoneNumber.length() > 3 ? phoneNo.phoneNumber.substring(0, 3) : '')
                                            + '-' + (phoneNo.phoneNumber.length() > 3 ? resp.physicianFacilityInformation.phone.get(0).phoneNumber.substring(3) : '');



                        if (returnAddress.addressContractOrg.size() > 0) {
                            String CancelDate = returnAddress.addressContractOrg.get(0).contrOrgCancDate;
                            if (!String.isBlank(CancelDate) && CancelDate != null) {
                                Date dt = Date.valueOf(CancelDate);
                                if (dt >= System.today()) {
                                    addr.ActiveClass = 'action:approval';
                                    addr.ActiveStatus = 'Active';
                                } else {
                                    addr.ActiveClass = 'action:close';
                                    addr.ActiveStatus = 'Inactive';
                                }
                            } else {
                                addr.ActiveClass = 'standard:empty';
                                addr.ActiveStatus = 'N/A';
                            }
                        }

                        for (SAE_ProviderResponse.ElectronicCommunication ecom: resp.physicianFacilityInformation.electronicCommunication) {
                            if (ecom.communicationTypeCode == 'E') {
                                addr.Email = addr.Email == '' ? ecom.communicationAddress : addr.Email;
                            } else {
                                addr.FAXNumber = addr.FAXNumber == '' ? ecom.communicationAddress : addr.FAXNumber;
                            }
                        }

                        if (returnAddress.addressTypeCode == 'D') {
                            if (addr.ActiveStatus == 'Active') {
                                comboAddrs.add(addr);
                            } else {
                                comboAddrsInactive.add(addr);
                            }
                        } else if (returnAddress.addressTypeCode == 'H') {
                            if (addr.ActiveStatus == 'Active') {
                                billingAddrs.add(addr);
                            } else {
                                billingAddrsInactive.add(addr);
                            }
                        } else if (returnAddress.addressTypeCode == 'L') {
                            if (addr.ActiveStatus == 'Active') {
                                servicingAddrs.add(addr);
                            } else {
                                servicingAddrsInactive.add(addr);
                            }
                        } else {
                            //Not sure
                            if (addr.ActiveStatus == 'Active') {
                                primaryAddrs.add(addr);
                            } else {
                                primaryAddrsInactive.add(addr);
                            }
                        }
                    }

                    if (filtered) {
                        returnResponse.addAll(comboAddrs);
                        returnResponse.addAll(servicingAddrs);
                        if (!onlyActive) {
                            returnResponse.addAll(comboAddrsInactive);
                            returnResponse.addAll(servicingAddrsInactive);
                        }
                    } else {
                        returnResponse.addAll(primaryAddrs);
                        returnResponse.addAll(comboAddrs);
                        returnResponse.addAll(billingAddrs);
                        returnResponse.addAll(servicingAddrs);
                        if (!onlyActive) {
                            returnResponse.addAll(primaryAddrsInactive);
                            returnResponse.addAll(comboAddrsInactive);
                            returnResponse.addAll(billingAddrsInactive);
                            returnResponse.addAll(servicingAddrsInactive);
                        }
                    }
                }

                // Pagination
                ACET_AutoDocUtil.PaginationInfo p_info = ACET_AutoDocUtil.processPaginationData(start,returnResponse.size(),currentResponseSize,50);
                addAddressTable.startNumber = start != 0 ? start : 1;
                // Integer startNo = addAddressTable.startNumber;
                // addAddressTable.endNumber = ((startNo + 50) -1) <= recordCount ? ((startNo + 50) -1) : recordCount;
                // addAddressTable.recordCount = recordCount;
                addAddressTable.endNumber = p_info.endNo;
                addAddressTable.recordCount = p_info.recordCount;
                addAddressTable.noOfPages = p_info.pageSize;

            } else {
                if (statCode == 400) {
                    message = 'Bad Request';
                } else if (statCode == 404) {
                    message = 'Not Found';
                } else if (statCode == 500) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                } else if (statCode == 100) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN100);
                } else {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }
            }

            if (addAddressTable != null) {
                for (SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper address: returnResponse) {
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = address.Address;
                    List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                    ACET_AutoDocUtil.RowColumnData rowData1 = ACET_AutoDocUtil.setRowColumnData('outputText', address.AddressType, 'ADDRESS TYPE');
                    rowData1.isReportable = true;
                    rowColumns.add(rowData1);
                    ACET_AutoDocUtil.RowColumnData rowData2 = ACET_AutoDocUtil.setRowColumnData('isStatusIcon', address.ActiveClass, 'ACTIVE');
                    rowData2.isReportable = true;
                    rowData2.iconName = address.ActiveClass;
                    rowData2.fieldValue = address.ActiveStatus;
                    rowColumns.add(rowData2);
                    ACET_AutoDocUtil.RowColumnData rowData3 = ACET_AutoDocUtil.setRowColumnData('outputText', address.Address, 'ADDRESS');
                    rowData3.isReportable = true;
                    rowColumns.add(rowData3);
                    ACET_AutoDocUtil.RowColumnData rowData4 = ACET_AutoDocUtil.setRowColumnData('outputText', address.Country, 'COUNTY');
                    rowData4.isReportable = true;
                    rowColumns.add(rowData4);
                    ACET_AutoDocUtil.RowColumnData rowData5 = ACET_AutoDocUtil.setRowColumnData('outputText', address.PhoneNumber, 'PHONE');
                    rowData5.isReportable = true;
                    rowColumns.add(rowData5);
                    ACET_AutoDocUtil.RowColumnData rowData6 = ACET_AutoDocUtil.setRowColumnData('outputText', address.FAXNumber, 'FAX');
                    rowData6.isReportable = true;
                    rowColumns.add(rowData6);
                    ACET_AutoDocUtil.RowColumnData rowData7 = ACET_AutoDocUtil.setRowColumnData('outputText', address.Email, 'EMAIL');
                    rowData7.isReportable = true;
                    rowColumns.add(rowData7);
                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                }
            }
            
            if(returnResponse.isEmpty()) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey =COMMON_ERROR_MESSAGE;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'ADDRESS TYPE'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'ACTIVE'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'ADDRESS'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',COMMON_ERROR_MESSAGE, true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'PHONE'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'FAX'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'EMAIL'));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            addAddressTable.tableBody = tableRows;
        } catch (exception e) {
            system.debug('exce::' + e.getStackTraceString());
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
            rowColumns.add(ACET_AutoDocUtil.setRowColumnData('noRecords',COMMON_ERROR_MESSAGE, true));
            tableRow.rowColumnData = rowColumns;
            tableRows.add(tableRow);
            addAddressTable.tableBody = tableRows;
            addAddressTable.statusCode = 999;

        }

        return addAddressTable;
    }
}