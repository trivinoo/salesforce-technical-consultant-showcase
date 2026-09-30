# 📖 Journey & Discovery 01: Resolving SAP Callout Exceptions in Trigger Contexts

**Date:** September 2026  
**Category:** Integration & Governor Limits  
**Role:** Salesforce Technical Consultant  

---

## 🎯 Business Context
During an enterprise SAP ERP integration project, the business required real-time customer credit checks when a Sales Order was placed in Salesforce. If the customer's credit status was blocked in SAP, the Order creation needed to be halted immediately.

---

## 💥 The Technical Challenge & Discovery
When implementing the initial Apex trigger, attempting a synchronous HTTP REST callout inside `OrderTrigger` (`before insert`) raised a critical runtime exception:

```text
System.CalloutException: You have uncommitted work pending before this callout. 
Must commit or rollback before calling out.
```

### Why Did This Happen?
1. **Salesforce Execution Governor Limits**: In Salesforce execution order, if any DML statement or uncommitted record state exists before an HTTP Callout in the same transaction context, Salesforce blocks the callout to preserve transaction integrity.
2. **Synchronous Trigger Limitations**: Apex triggers run synchronously within the database transaction savepoint.

---

## 💡 The Architectural Solution
As a Functional Consultant using AI-augmented engineering, I evaluated three potential architectural patterns:

| Architecture Pattern | Evaluation & Trade-offs | Decision |
| :--- | :--- | :--- |
| **A. Synchronous Callout in Trigger** | Fails with `CalloutException`. Unviable. | ❌ Rejected |
| **B. `@future(callout=true)` Async Apex** | Executes callout asynchronously outside transaction, but cannot block synchronous DML directly inside `before insert`. | ⚠️ Partial Solution |
| **C. Staged Validation Pattern (Flow + LWC + Queueable)** | 1. Low-code Flow pre-checks cached SAP status.<br>2. LWC component invokes Imperative Apex for real-time callout.<br>3. Queueable Apex handles fallback bulk integrations. | ✅ **Selected Architecture** |

---

## 🛠️ Code Implementation Highlights

### Queueable Apex Fallback (`SAPCreditCheckQueueable.cls`)
```apex
public class SAPCreditCheckQueueable implements Queueable, Database.AllowsCallouts {
    private Set<Id> accountIds;

    public SAPCreditCheckQueueable(Set<Id> accIds) {
        this.accountIds = accIds;
    }

    public void execute(QueueableContext context) {
        for (Id accId : accountIds) {
            // Safe asynchronous HTTP callout to SAP ERP endpoint
            HttpResponse res = SAPIntegrationService.fetchCreditStatus(accId);
            SAPIntegrationService.updateAccountCreditStatus(accId, res.getBody());
        }
    }
}
```

---

## 🔑 Key Takeaways & Lessons Learned
- **Never attempt synchronous HTTP callouts in raw trigger execution paths.**
- **Combine Low-Code + Pro-Code**: Use LWC for real-time user-triggered checks on the record page, and Queueable/Batch Apex for asynchronous bulk data processing.
- **AI Co-Pilot Advantage**: Leveraging AI allowed us to rapidly test and compare Queueable vs. `@future` implementations without spending hours debugging governor limit stack traces manually.
