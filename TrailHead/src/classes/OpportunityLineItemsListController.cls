public class OpportunityLineItemsListController {
    private final Account acc;
    
    public OpportunityLineItemsListController(ApexPages.StandardController sc){
        this.acc = (Account) sc.getRecord();
    }

    public List<OpportunityLineItem> getItems(){
        Id accountId = acc.ID;
        List<OpportunityLineItem> result = [SELECT Name, Quantity, UnitPrice, TotalPrice, OpportunityID FROM OpportunityLineItem WHERE OpportunityID IN (SELECT ID FROM Opportunity WHERE AccountID=:accountId)];
        return result;                                    
    }
}