@isTest
private class ECMBusinessHoursUtilTest{

    /*
    Assumption Memeber call center is avliable in org.And timzone is ET
    Sunday  No Hours
    Monday  8:00 AM to  6:00 PM
    Tuesday 8:00 AM to  6:00 PM
    Wednesday   8:00 AM to  6:00 PM
    Thursday    8:00 AM to  6:00 PM
    Friday  8:00 AM to  6:00 PM
    Saturday    No Hours

    */
    private static BusinessHours getBusinessHours() {
          List<BusinessHours> bhs=[select id from BusinessHours where name = 'Member Call Center'];
       //System.assert(bhs.size()==1);
       return bhs[0];
    }
    

    @isTest
    static void testTargetDatePopulation() {
        Milestone_Performance__c msp = null;
        BusinessHours bs = getBusinessHours();
        
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
         msp = new Milestone_Performance__c ();
        msp.MilestoneStartDateTime__c = Datetime.newInstance(2017, 5, 4, 10, 32, 13);
        msp.PlannedMilestoneMinutestoComplete__c = 661;
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
    
        //System.assertEquals('1 Day : 1 Hour : 1 Minute',msp.Target_Time_DDD_HH_MM__c);
    }

    @isTest
    static void tesCompletionDatePopulation() {
        BusinessHours bs = getBusinessHours();
        Milestone_Performance__c msp = new Milestone_Performance__c ();
        msp.MilestoneStartDateTime__c = Datetime.newInstance(2017, 5, 4, 10, 32, 13);
        msp.ActualMilestoneCompletionDateTime__c = Datetime.newInstance(2017, 5, 4, 10, 32, 13);
        msp.PlannedMilestoneMinutestoComplete__c = 1400;
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
        //System.assertEquals('0 Day :  0 Hour : 0 Minute',msp.Completion_Time_DDD_HH_MM__c);
        msp.ActualMilestoneMinutestoComplete__c  = 1395;
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
        //System.debug(msp);
        //System.assertEquals('2 Days : 3 Hours : 15 Minutes',msp.Completion_Time_DDD_HH_MM__c);
        //System.assertEquals('- 0 Day :  0 Hour : 5 Minutes',msp.Variance_Time_DDD_HH_MM__c);
        
    }

    @isTest
    static void tesVarianceDatePopulation() {
        BusinessHours bs = getBusinessHours();
        Milestone_Performance__c msp = new Milestone_Performance__c ();
        msp.MilestoneStartDateTime__c = Datetime.newInstance(2017, 5, 4, 6, 32, 13);
        msp.ActualMilestoneCompletionDateTime__c = Datetime.newInstance(2017, 5, 4, 10, 32, 13);
        msp.PlannedMilestoneMinutestoComplete__c = 1400;
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
        msp.ActualMilestoneMinutestoComplete__c  = 1405;
        ECMBusinessHoursUtil.setBusinessCalculation(bs.id,msp);
        //System.assertEquals('0 Day :  0 Hour : 5 Minutes',msp.Variance_Time_DDD_HH_MM__c);
    }
}