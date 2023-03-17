({
	getEngagementDetails : function(component, helper) {
		var action = component.get("c.getMemEngagementDetails");
        var eId = component.get("v.contactHistoryDetailData")[0].engagementId;
        console.log('eId for get engagement details : ', eId)
        action.setParams({
            engagementId : eId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('details : ', JSON.stringify(resp));
                if(!$A.util.isEmpty(resp)){
                    if(!$A.util.isEmpty(resp.engagementDetails)){
                        var detail = resp.engagementDetails;
                        if(!$A.util.isEmpty(detail.memberVO)){
                            var memVO = detail.memberVO;
                            component.set("v.relationship", memVO.relationshipCode);
                        }
                        if(!$A.util.isEmpty(detail.engagementVO)){
                            var engVO = detail.engagementVO;
                            component.set("v.assistedBy", engVO.createUserId);
                            component.set("v.type", engVO.engagementStatusType);
                            component.set("v.reason", engVO.engagementReasonText);
                            component.set("v.category", engVO.engagementCategoryType);
                        }
                        //	notes section(members & services)
                        console.log('detail.response : ', resp.response);
                        if(!$A.util.isEmpty(resp.response) && !$A.util.isEmpty(resp.response.responseBody) &&
                          !$A.util.isEmpty(resp.response.responseBody.memberAttributes)){
                            var contactId = resp.response.responseBody.memberAttributes.engageID;
                            var memAttr = resp.response.responseBody.memberAttributes;
                            var notes = new Array();

                            if(!$A.util.isEmpty(memAttr.noteDetails)){	// when there's one note
                                var note = new Object();
                                var thisNote = memAttr.noteDetails;
                                note.contactId = contactId;
                                note.createDateTime = this.formatDate(thisNote.createDate);
                                note.convDateTime = new Date(thisNote.createDate);
                                note.createdBy = thisNote.createUserName + '-' + thisNote.functionalRoleDescription;
                                note.noteType = thisNote.noteTypeDescription;
                                note.subjectType = thisNote.noteCategoryDescription;
                                note.noteText = thisNote.noteText;
                                notes.push(note);
                            }else if(!$A.util.isEmpty(memAttr.lstNoteDetails)){	// when there are multiple notes
                                var note = new Object();
                                var noteDetails = memAttr.lstNoteDetails;
                                for(var n=0; n < memAttr.lstNoteDetails.length; n++){
                                    var curr = memAttr.lstNoteDetails[n];
                                    note.contactId = contactId;
                                    note.createDateTime = this.formatDate(curr.createDate);
                                    note.convDateTime = new Date(curr.createDate);
                                    note.createdBy = curr.createUserName + '-' + curr.functionalRoleDescription;
                                    note.noteType = curr.noteTypeDescription;
                                    note.subjectType = curr.noteCategoryDescription;
                                    note.noteText = curr.noteText;
                                    notes.push(note);
                                    note = new Object();
                                }
                                notes.sort(function(a, b){
                                    var t1 = a["convDateTime"] == b["convDateTime"],
                                        t2 = (!a["convDateTime"] && b["convDateTime"]) || (a["convDateTime"] < b["convDateTime"]);
                                    return t1? 0: ( false ?-1:1)*(t2?1:-1);
                                });
                            }
                            console.log('collected notes : ', notes);
                            component.set("v.notes", notes);
                        }else{
                            var noteError = resp.notesErrorMsg;
                            console.log('error retrieving member engagement notes : ', noteError);
                            component.set("v.notesError", noteError);
                        }
                    }else if(!$A.util.isEmpty(resp.systemErrorMsg)){
                        component.set("v.systemErrorMsg", resp.systemErrorMsg);
                    }
                }
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

    formatDate : function(dt){
        var formattedDate = '';
        if(!$A.util.isEmpty(dt)){
            var splits1 = dt.split(':');
            if(!$A.util.isEmpty(splits1[3])){
                var splits2 = splits1[3].split(' ');
                if(!$A.util.isEmpty(splits2)){
                    formattedDate = splits1[0] + ':' + splits1[1] + ':' + splits1[2] + ' ' + splits2[1];
                }
            }
        }
        return formattedDate.replace('-', '/').replace('-', '/').replace('-', '/');
    }
})