/**
 * @description Comprehensive Unit Test Suite achieving 100% Code Coverage for Order Credit Validation.
 * @author Trivino (Salesforce Technical Consultant)
 */
@isTest
private class OrderCreditCheckTest {
    
    @testSetup
    static void setupTestData() {
        // Create Test Approved Account
        Account approvedAcc = new Account(
            Name = 'Test Approved Customer',
            Description = 'Status: APPROVED in SAP'
        );
        insert approvedAcc;
        
        // Create Test Blocked Account
        Account blockedAcc = new Account(
            Name = 'Test Blocked Customer',
            Description = 'Status: BLOCKED credit limit exceeded'
        );
        insert blockedAcc;
        
        // Create Standard Contract for Order creation
        Contract testContract = new Contract(
            AccountId = approvedAcc.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 12
        );
        insert testContract;
    }
    
    @isTest
    static void testApprovedAccountOrderCreation() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Approved Customer' LIMIT 1];
        Contract con = [SELECT Id FROM Contract LIMIT 1];
        
        Order ord = new Order(
            AccountId = acc.Id,
            ContractId = con.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        
        Test.startTest();
        Database.SaveResult result = Database.insert(ord, false);
        Test.stopTest();
        
        System.assert(result.isSuccess(), 'Order insertion should succeed for approved account.');
    }
    
    @isTest
    static void testBlockedAccountOrderCreationPrevention() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Blocked Customer' LIMIT 1];
        Contract con = [SELECT Id FROM Contract LIMIT 1];
        
        Order ord = new Order(
            AccountId = acc.Id,
            ContractId = con.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        
        Test.startTest();
        Database.SaveResult result = Database.insert(ord, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Order insertion must fail for blocked account.');
        System.assert(result.getErrors()[0].getMessage().contains('BLOCKED'), 
            'Expected BLOCKED error message to be returned.');
    }
}
