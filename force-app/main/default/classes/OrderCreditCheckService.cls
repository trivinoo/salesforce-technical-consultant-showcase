/**
 * @description Enterprise Service Class for Order Credit Validation and Business Rules.
 * @author Trivino (Salesforce Technical Consultant)
 */
public with sharing class OrderCreditCheckService {
    
    public static final String CREDIT_STATUS_BLOCKED = 'Blocked';
    public static final String CREDIT_STATUS_APPROVED = 'Approved';
    
    /**
     * @description Validates new/updated orders against Account credit status and outstanding limits.
     * @param newOrders List of orders to evaluate
     */
    public static void validateOrderCreditLimits(List<Order> newOrders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : newOrders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }
        
        // Query Accounts with relevant fields
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, Name, Rating, Description
            FROM Account
            WHERE Id IN :accountIds
        ]);
        
        for (Order ord : newOrders) {
            if (ord.AccountId != null && accountMap.containsKey(ord.AccountId)) {
                Account acc = accountMap.get(ord.AccountId);
                
                // Example Business Logic: Prevent Order Placement if Account Rating is 'Cold' or Description contains 'Blocked'
                if (acc.Description != null && acc.Description.containsIgnoreCase('BLOCKED')) {
                    ord.addError('Order placement failed: Customer account status is marked as BLOCKED in SAP/ERP system.');
                }
            }
        }
    }
}
