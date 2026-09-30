# 📖 Journey & Discovery 03: The Declarative Flow vs. Apex Trigger Decision Framework

**Date:** September 2026  
**Category:** Solution Architecture & Automation  
**Role:** Salesforce Technical Consultant  

---

## 🎯 Business Context
Clients often ask: *"Should we build this requirement using Salesforce Flow Builder or Apex Code?"*

As a Functional Consultant with AI technical capabilities, answering this question accurately prevents technical debt, maintainability nightmares, and governor limit breaches.

---

## 💡 The 80/20 Decision Framework

```
                          ┌──────────────────────────┐
                          │   Business Requirement   │
                          └────────────┬─────────────┘
                                       │
            Is it a standard record update, email alert, or simple validation?
                                       │
                      ┌────────────────┴────────────────┐
                      ▼                                 ▼
                   [ YES ]                           [ NO ]
                      │                                 │
           ┌──────────────────────┐         Does it involve complex math,
           │  Use Salesforce Flow │         external API callouts, or >10k
           └──────────────────────┘         bulk record loops?
                                                        │
                                                        ▼
                                            ┌───────────────────────┐
                                            │    Use Apex Trigger   │
                                            │    & Service Layer    │
                                            └───────────────────────┘
```

---

## 📊 Comparison Matrix

| Factor | Salesforce Flow (Low-Code) | Apex Trigger & Service (Pro-Code) |
| :--- | :--- | :--- |
| **Maintainability** | High (Visual for admins) | Requires developer / VS Code deployment |
| **Bulk Performance** | Good for standard scenarios | Superior for high-volume transactions |
| **Complex Logic** | Can become messy with nested loops | Clean using collections & map indexing |
| **Integration** | Limited native REST HTTP support | Full REST/SOAP callout flexibility |
| **Unit Testing** | Flow Tests / Declarative | Automated Apex Unit Tests (100% Coverage) |

---

## 🔑 Key Takeaways & Lessons Learned
- **Start with Low-Code (Flow)** whenever possible to empower admin teams.
- **Transition to Apex** when CPU limits, map-based lookups, or strict enterprise trigger handler patterns are required.
- **The Hybrid Approach**: Use Record-Triggered Flow to invoke `@InvocableMethod` Apex actions for the best of both worlds.
