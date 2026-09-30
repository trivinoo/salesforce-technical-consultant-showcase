# 📖 Journey & Discovery 02: LWC Wire Service vs. Imperative Apex

**Date:** September 2026  
**Category:** User Interface & Lightning Web Components  
**Role:** Salesforce Technical Consultant  

---

## 🎯 Business Context
Sales Representatives using the Order record page needed a real-time status indicator showing whether an Account's SAP credit limit was valid, alongside a "Re-Sync with SAP" button to refresh data on demand.

---

## 💥 The Technical Discovery
When building the Lightning Web Component (`orderCreditStatus`), I initially attempted to use `@wire` for both continuous data streaming and the button click handler.

### The Catch with `@wire`
1. **Immutable Reactive Cache**: The Lightning Data Service (LDS) `@wire` adapter caches data on the client side. Calling a wire service on a button click event is impossible because `@wire` is invoked automatically by the LWC engine during component lifecycle, not imperatively by user actions.
2. **`refreshApex()` Requirement**: To refresh wired data programmatically, `refreshApex()` must be passed the exact provisioned wire property object.

---

## 💡 The Solution: Hybrid Wire + Imperative Pattern

```javascript
import { LightningElement, api, wire, track } from 'lwc';
import getCreditStatus from '@salesforce/apex/OrderCreditCheckService.getCreditStatus';
import { refreshApex } from '@salesforce/apex';

export default class OrderCreditStatus extends LightningElement {
    @api recordId;
    wiredStatusResult; // Store wire provisioned object

    @wire(getCreditStatus, { recordId: '$recordId' })
    imperativeWiredStatus(result) {
        this.wiredStatusResult = result;
        if (result.data) {
            // Update reactive UI properties
        }
    }

    // User button click handler uses Imperative Apex + refreshApex
    handleRefresh() {
        this.isLoading = true;
        refreshApex(this.wiredStatusResult)
            .finally(() => {
                this.isLoading = false;
            });
    }
}
```

---

## 🔑 Key Takeaways & Lessons Learned
- **Use `@wire` when data needs to load automatically on component initialization.**
- **Use Imperative Apex when data retrieval is triggered by a specific user interaction** (e.g. clicking a button, submitting a modal form).
- **Functional Clarity**: Understanding user behavior first helped choose the right technical pattern faster.
