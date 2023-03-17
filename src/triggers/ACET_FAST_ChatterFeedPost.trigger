trigger ACET_FAST_ChatterFeedPost on FeedItem (before delete) {
    
    ACET_FAST_CaseController.handleFeedPostDelete(Trigger.old);
    
}