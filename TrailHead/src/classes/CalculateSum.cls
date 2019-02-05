public class CalculateSum {
    public static Boolean test = false;
    public static void doCalc(List<ID> opportunityId, List<ID> oldAccId){
    	
        // Выборка этих Opportunity
        Set<Opportunity> opportunities = CalculateSum.getOpportunities(opportunityId);
        
		// Делаем выборку по всем OpportunityItem, принадлежащих изменённым Opportunity
    	Set<OpportunityLineItem> opportunityLineItems = CalculateSum.getItems(opportunityId);
    	
        // Получаем все аккаунты с нужными полями, которых коснулись изменения
        List<ID> accountsId = CalculateSum.getAccountId(opportunities);
        if (oldAccId!=null){
            for (ID o : oldAccId){
                accountsId.add(o);
            }
        }
        
        List<Account> accounts = CalculateSum.getAccounts(accountsId);
        CalculateSum.calculate(accounts, opportunities, opportunityLineItems);
        
    }
    
    /**public static void calculate(List<Account> accounts, Set<Opportunity> opportunities, Set<OpportunityLineItem> opportunityLineItems){
            DateTime start = System.now();

            for (Account a : accounts){
        	a.Products__c = 0;
        	a.Quantity_SUM__c = 0;
        	a.Prices_SUM__c= 0;
        	List<Opportunity> forRemoveOpps = new List<Opportunity>();
        
        	for (Opportunity o : opportunities){
            	if (o.AccountId == a.Id){
                	forRemoveOpps.add(o);
                
                	List<OpportunityLineItem> forRemoveItems = new List<OpportunityLineItem>();
                	for (OpportunityLineItem i : opportunityLineItems){
                		if(i.OpportunityId == o.Id){
                            a.Products__c++;
                    		a.Quantity_SUM__c+=i.Quantity;
                    		a.Prices_SUM__c+=(i.UnitPrice*i.Quantity);
                    		forRemoveItems.add(i);
                		}
            		}
            		opportunityLineItems.removeAll(forRemoveItems);
            	}

        	}
        	opportunities.removeAll(forRemoveOpps);
    	}

        DateTime fin = System.now();
        Integer resTime = (Integer) fin.millisecond() - (Integer) start.millisecond();
        System.debug('Result time 1: ' + resTime);
        if (!test){
        	update accounts;   
        }
    } */
    
    public static void calculate(List<Account> accounts, Set<Opportunity> opportunities, Set<OpportunityLineItem> opportunityLineItems){
        
        // Обнуляем поля и добавляем Account в MAP
        Map<ID, Account> accMap = new Map<ID, Account>();
        for (Account a : accounts){
        	a.Products__c = 0;
        	a.Quantity_SUM__c = 0;
        	a.Prices_SUM__c= 0;
            accMap.put(a.ID, a);
        }
             
        // Сортируем в Map Opportunities <OpportunityID, Account>
        Map<ID, Account> oppsMap = new Map<ID, Account>();
        for(Opportunity o : opportunities){
            oppsMap.put(o.ID, accMap.get(o.AccountID));
        }
        
		// Проходимся по всем OpportunityLineItem
        for(OpportunityLineItem i : opportunityLineItems){
            Account a = oppsMap.get(i.OpportunityID);
            a.Products__c++;
            a.Quantity_SUM__c+=i.Quantity;
            a.Prices_SUM__c+=(i.UnitPrice*i.Quantity);        
        }
        
        // Сохраняем изменения
        if (!test){
        	update accounts;   
        }
    }
    
    public static List<ID> getOpportunityId(List<OpportunityLineItem> items){
        List<ID> opportunityId = new List<ID>();
    	for (OpportunityLineItem o : items){
        	opportunityId.add(o.OpportunityId);
    	}
        
        return opportunityId;
    }
    
   	public static List<ID> getOpportunityId(List<Opportunity> opps){
        List<ID> opportunityId = new List<ID>();
    	for (Opportunity o : opps){
        	opportunityId.add(o.ID);
    	}
        return opportunityId;
    }
    
    public static Set<Opportunity> getOpportunities(List<ID> opportunityId){
        List<Opportunity> opportunities = [SELECT AccountID FROM Opportunity WHERE ID IN :opportunityID];
        Set<Opportunity> opps = new Set<Opportunity>(opportunities);
        return opps;
    }
    
    public static List<Account> getAccounts(List<ID> accountsId){
        List<Account> accounts = [SELECT ID FROM Account WHERE ID IN :accountsId];
        return accounts;
    }
    
    public static List<ID> getAccountId(Set<Opportunity> opportunities){
    	List<ID> accountsId = new List<ID>();
    	for (Opportunity o : opportunities){
    	    accountsId.add(o.AccountId);
    	}
        return accountsId;
    }
    
    public static Set<OpportunityLineItem> getItems(List<ID> opportunityId){
        List<OpportunityLineItem> opportunityLineItems = [SELECT OpportunityId, UnitPrice, Quantity FROM OpportunityLineItem WHERE OpportunityId IN :opportunityId];
        Set<OpportunityLineItem> items = new Set<OpportunityLineItem>(opportunityLineItems);
        return items;
    }
   
    
    

}