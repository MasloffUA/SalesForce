@isTest
public class TestOppChanges {
    @isTest static void testOne(){
        
        // Создаём 2 аккаунта (сначала Opportunity будет привязан к EVO, потом к EVB)
        List<Account> accs = new List<Account>();
      	Account a = new Account(Name='EVO');
        accs.add(a);
        Account b = new Account(Name='EVB');
        accs.add(b);
        insert accs;
    	Opportunity o = new Opportunity(Name='ContactA', AccountId=a.id, CloseDate=date.parse('04/04/2020'), StageName='New');
        insert o;
        Product2 p2 = new Product2(Name='TestProduct2', isActive=true);
        insert p2;
        Pricebook2 pb2 = new Pricebook2(Name='TestPriceBook2');
        insert pb2;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pe = new PricebookEntry(UnitPrice = 777, Pricebook2Id = pricebookId, Product2Id = p2.ID, isActive = true);
   		insert pe;	
    	OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.id, Quantity=2, UnitPrice=10, PricebookEntryId = pe.ID);
        insert oli;
        
        List<Account> accsNew = [SELECT Name, Products__c, Quantity_SUM__c, Prices_SUM__c FROM Account WHERE (Name='EVO' OR Name='EVB')];
        for (Account acc : accsNew){
            if (acc.name=='EVO'){
                a = acc;
            }
            if (acc.name=='EVB'){
                b = acc;
            }
        }        
        System.assertEquals(1, a.Products__c);
        System.assertEquals(20, a.Prices_SUM__c);
        System.assertEquals(2, a.Quantity_SUM__c);
        System.assertEquals(null, b.Products__c);
        System.assertEquals(null, b.Prices_SUM__c);
        System.assertEquals(null, b.Quantity_SUM__c);
        
        o.AccountId=b.ID;
		update o;
        
        accsNew = [SELECT Name, Products__c, Quantity_SUM__c, Prices_SUM__c FROM Account WHERE (Name='EVO' OR Name='EVB')];
        for (Account acc : accsNew){
            if (acc.name=='EVO'){
                a = acc;
            }
            if (acc.name=='EVB'){
                b = acc;
            }
        }        
        System.assertEquals(1, b.Products__c);
        System.assertEquals(20, b.Prices_SUM__c);
        System.assertEquals(2, b.Quantity_SUM__c);
        System.assertEquals(0, a.Products__c);
        System.assertEquals(0, a.Prices_SUM__c);
        System.assertEquals(0, a.Quantity_SUM__c);
        
        
    }
}