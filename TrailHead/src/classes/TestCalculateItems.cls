@isTest
public class TestCalculateItems {
    
    @isTest static void testOne(){
        
      	Account a = new Account(Name='EVO');
        insert a;
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
        
        Account acc = [SELECT Products__c, Quantity_SUM__c, Prices_SUM__c FROM Account];
        System.assertEquals(1, acc.Products__c);
        System.assertEquals(20, acc.Prices_SUM__c);
        System.assertEquals(2, acc.Quantity_SUM__c);
    }

    
}