trigger OpProduct on OpportunityLineItem (after insert, after update, after delete) {
    // На входе пачка OpportinityLineItems
	// Получаем ID всех Opportunity, которых коснулись изменения
    List<ID> opportunityId = CalculateSum.getOpportunityId(Trigger.New);
    CalculateSum.doCalc(opportunityId, null);
}