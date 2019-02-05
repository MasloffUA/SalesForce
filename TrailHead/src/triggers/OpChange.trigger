trigger OpChange on Opportunity (after insert, after update, after delete) {
	// На входе пачка Opportinity
	// Получаем ID всех Opportunity, которых коснулись изменения   
	List<ID> opportunityId = new List<ID>();
    List<ID> accounts = new List<ID>();
	if (Trigger.isUpdate){
		for(Id opp : Trigger.newMap.keySet()) {
			if(Trigger.oldMap.get(opp).AccountID != Trigger.newMap.get(opp).AccountID){
				opportunityId.add(opp);
                accounts.add(Trigger.oldMap.get(opp).AccountId);
			}
		}
        CalculateSum.doCalc(opportunityId, accounts);
	} else {
		opportunityId = CalculateSum.getOpportunityId(Trigger.New);
        CalculateSum.doCalc(opportunityId, null);
	}
	
}