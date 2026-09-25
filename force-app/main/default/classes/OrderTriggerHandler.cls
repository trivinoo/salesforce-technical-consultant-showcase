/**
 * @description Trigger Handler following Enterprise Architecture Patterns for Order Trigger.
 * @author Trivino (Salesforce Technical Consultant)
 */
public with sharing class OrderTriggerHandler {
    
    // Prevent recursion
    private static Boolean isExecuting = false;
    
    public static void handleBeforeInsert(List<Order> newOrders) {
        if (isExecuting) return;
        isExecuting = true;
        
        try {
            OrderCreditCheckService.validateOrderCreditLimits(newOrders);
        } finally {
            isExecuting = false;
        }
    }
    
    public static void handleBeforeUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        if (isExecuting) return;
        isExecuting = true;
        
        try {
            OrderCreditCheckService.validateOrderCreditLimits(newOrders);
        } finally {
            isExecuting = false;
        }
    }
}
