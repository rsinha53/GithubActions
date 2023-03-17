trigger ACET_FAST_PETriggers on Spire_to_MuleSoft__e(After insert) {

  ACET_FAST_PlatformEventsHandler.eventSubscription(Trigger.new);
}