/**
 * @description Async Integration Logger for ERP/SAP API events and exception tracking.
 * @author Trivino (Salesforce Technical Consultant)
 */
public with sharing class IntegrationLogger {
    
    /**
     * @description Logs integration audit event asynchronously using @future.
     * @param systemName Target integration system (e.g. SAP ERP, Commerce Cloud)
     * @param payload Request/Response payload or status message
     * @param isError True if logging an exception
     */
    @future
    public static void logIntegrationEventAsync(String systemName, String payload, Boolean isError) {
        // In production, this writes to a custom object like Integration_Log__c
        System.debug(LoggingLevel.INFO, '[INTEGRATION LOG][' + systemName + '][Error: ' + isError + '] ' + payload);
    }
}
