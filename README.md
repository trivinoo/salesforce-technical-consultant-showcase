# 🚀 Salesforce Technical & Functional Consultant Showcase

[![Salesforce DX](https://img.shields.io/badge/Salesforce-DX%20v60.0-00A1E0?style=for-the-badge&logo=salesforce&logoColor=white)](https://developer.salesforce.com/)
[![Apex Enterprise Patterns](https://img.shields.io/badge/Apex-Enterprise%20Patterns-blue?style=for-the-badge&logo=salesforce&logoColor=white)](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
[![LWC Supported](https://img.shields.io/badge/LWC-Lightning%20Web%20Components-0176D3?style=for-the-badge&logo=salesforce&logoColor=white)](https://developer.salesforce.com/docs/component-library/overview/components)
[![AI Augmented](https://img.shields.io/badge/AI%20Co--Pilot-Antigravity%20Engineered-purple?style=for-the-badge)](https://github.com/trivinoo)

> **Bridging Business Strategy with AI-Augmented Full-Stack Salesforce Engineering**  
> *Functional Consulting Expertise (Sales Cloud, Service Cloud, Flow, Business Rules, SAP Integrations, UAT) + Technical Delivery (Apex, LWC, SOQL, Unit Testing, SFDX CLI, Git).*

---

## 🌟 Career Philosophy & Profile

I am a **Salesforce Functional Consultant** empowered by **AI Co-Pilot Engineering**. 

In today's ecosystem, the line between functional analysts and developers is blurring. Traditional developers often lack deep business context, while functional consultants may feel limited by low-code alone. 

By pairing my **deep domain knowledge** (requirements gathering, business process design, client stakeholder management, SAP/ERP integrations, and UAT) with **AI-driven development tools**, I build, test, version, and deploy production-grade Salesforce solutions from end to end.

---

## 📖 Journeys & Technical Discoveries During Projects

A living journal of architectural trade-offs, governor limit edge cases, integration gotchas, and technical breakthroughs uncovered while bridging functional requirements with Salesforce engineering.

| Entry | Category | Technical Discovery & Problem Statement | Solution & Architectural Impact |
| :--- | :--- | :--- | :--- |
| [**01. SAP Callout Exception in Triggers**](docs/journeys/01-sap-credit-check-governor-limits.md) | Integration & Governor Limits | Attempting synchronous HTTP REST callout inside `before insert` trigger failed with `System.CalloutException: You have uncommitted work pending`. | Implemented asynchronous Queueable Apex (`Database.AllowsCallouts`) + Imperative LWC callout pattern. |
| [**02. LWC Wire Service vs. Imperative Apex**](docs/journeys/02-lwc-wire-service-vs-imperative-apex.md) | LWC & UI Architecture | `@wire` adapter caches reactive data immutably; manual user button actions cannot invoke wire services directly. | Combined `@wire` for initial load with Imperative Apex & `refreshApex()` for user-triggered SAP re-sync. |
| [**03. Flow vs. Apex Decision Matrix**](docs/journeys/03-declarative-flow-vs-apex-trigger-matrix.md) | Solution Architecture | Balancing Low-Code maintainability vs. Pro-Code performance for enterprise validation logic. | Standardized an 80/20 decision framework: Low-Code Flow for standard rules, Apex Trigger Handler for complex loops. |

---

## 🏗️ Architecture & Business Case Study

### Business Problem
> *A B2B Enterprise Client needs to automatically block Order placement if the customer's credit account is blocked in SAP or exceeds their approved credit threshold, while logging integration audit events and presenting real-time credit status to Sales Reps.*

### 5-Layer Solution Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│                        1. Business Requirement                         │
│     Validate customer credit limits & prevent blocked order creation   │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                     2. Declarative / Flow layer                        │
│    Record-Triggered Flow triggers validation prior to Apex invocation  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                3. Pro-Code Apex Enterprise Patterns                    │
│   OrderTriggerHandler ──► OrderCreditCheckService ──► IntegrationLogger│
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                     4. Lightning Web Components (LWC)                  │
│    <c-order-credit-status> displays status badge & manual re-check UI  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   5. Salesforce DX & DevOps Pipeline                   │
│   Git Branching ──► Apex Tests (100% Coverage) ──► sf project deploy   │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```text
salesforce-technical-consultant-showcase/
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           │   ├── OrderCreditCheckService.cls       # Enterprise Service Layer
│           │   ├── OrderCreditCheckService.cls-meta.xml
│           │   ├── OrderTriggerHandler.cls           # Trigger Handler Pattern
│           │   ├── OrderTriggerHandler.cls-meta.xml
│           │   ├── OrderCreditCheckTest.cls          # 100% Coverage Unit Test
│           │   ├── OrderCreditCheckTest.cls-meta.xml
│           │   ├── IntegrationLogger.cls             # Async @future Audit Logger
│           │   └── IntegrationLogger.cls-meta.xml
│           ├── triggers/
│           │   ├── OrderTrigger.trigger              # Standard One-Line Trigger
│           │   └── OrderTrigger.trigger-meta.xml
│           ├── lwc/
│           │   └── orderCreditStatus/                # Modern LWC UI
│           │       ├── orderCreditStatus.html
│           │       ├── orderCreditStatus.js
│           │       └── orderCreditStatus.js-meta.xml
│           └── permissionsets/
│               └── Salesforce_Technical_Consultant_Access.permissionset-meta.xml
├── index.html                                        # Interactive Web Portfolio Dashboard
├── styles.css                                        # Modern Glassmorphic SLDS Styling
├── app.js                                            # Interactive Portfolio Application
├── sfdx-project.json                                 # SFDX Configuration
└── README.md                                         # Documentation
```

---

## 🛠️ Key Code Snippets & Technical Highlights

### 1. Enterprise Apex Service Layer (`OrderCreditCheckService.cls`)
```apex
public with sharing class OrderCreditCheckService {
    public static final String STATUS_BLOCKED = 'Blocked';
    public static final String STATUS_APPROVED = 'Approved';

    public static void validateOrderCreditLimits(List<Order> newOrders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : newOrders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, Name, Credit_Limit__c, Credit_Status__c, Total_Outstanding__c
            FROM Account
            WHERE Id IN :accountIds
        ]);

        for (Order ord : newOrders) {
            Account acc = accountMap.get(ord.AccountId);
            if (acc != null) {
                if (acc.Credit_Status__c == STATUS_BLOCKED) {
                    ord.addError('Order cannot be submitted. Account credit status is BLOCKED in SAP.');
                } else if (acc.Credit_Limit__c != null && 
                           (acc.Total_Outstanding__c + ord.TotalAmount) > acc.Credit_Limit__c) {
                    ord.addError('Order total ($' + ord.TotalAmount + ') exceeds available credit limit.');
                }
            }
        }
    }
}
```

### 2. Modern Lightning Web Component (`orderCreditStatus.html`)
```html
<template>
    <lightning-card title="Customer Credit Status" icon-name="custom:custom17">
        <div class="slds-p-around_medium">
            <template if:true={isBlocked}>
                <div class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error">
                    <h2>⚠️ Account Credit Status: BLOCKED</h2>
                </div>
            </template>
            <template if:false={isBlocked}>
                <div class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_success">
                    <h2>✅ Account Credit Status: APPROVED</h2>
                </div>
            </template>
            <div class="slds-m-top_medium">
                <lightning-button label="Re-validate SAP Credit Status" onclick={handleRecheck} variant="brand"></lightning-button>
            </div>
        </div>
    </lightning-card>
</template>
```

---

## ⚡ Deployment Guide (Salesforce CLI)

To deploy this metadata into your Salesforce Developer Org or Scratch Org:

```bash
# 1. Authenticate to your Org
sf org login web --alias my-dev-org --set-default

# 2. Deploy source to Org
sf project deploy start --target-org my-dev-org

# 3. Run Apex Unit Tests with Code Coverage
sf apex run test --code-coverage --result-format human --target-org my-dev-org

# 4. Assign Permission Set
sf org assign permset --name Salesforce_Technical_Consultant_Access --target-org my-dev-org
```

---

## 👨‍💻 Connect with Me

- **GitHub**: [@trivinoo](https://github.com/trivinoo)
- **Role**: Salesforce Functional Consultant & Technical Solution Builder
