trigger ACET_FAST_PEMtoSTrigger on MuleSoft_To_Spire__e (After insert) {
    ACET_FAST_PlatformEventsHandler.eventSubscriptionMtoS(Trigger.new);
}