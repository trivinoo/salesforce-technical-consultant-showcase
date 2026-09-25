import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderCreditStatus extends LightningElement {
    @api recordId;
    @track isLoading = false;
    @track isBlocked = true;
    @track creditLimit = 150000;
    @track outstanding = 165000;
    @track statusLabel = 'BLOCKED';

    get creditLimitFormatted() {
        return '$' + this.creditLimit.toLocaleString();
    }

    get outstandingFormatted() {
        return '$' + this.outstanding.toLocaleString();
    }

    get isApproved() {
        return !this.isBlocked;
    }

    handleRefresh() {
        this.isLoading = true;
        // Simulate real-time SAP API Callout & Refresh
        setTimeout(() => {
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'SAP Sync Completed',
                    message: 'Refreshed credit status directly from SAP ERP endpoint.',
                    variant: 'info'
                })
            );
        }, 1200);
    }

    handleExceptionRequest() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Approval Process Initiated',
                message: 'Credit Exception Request submitted to Finance Director for approval.',
                variant: 'success'
            })
        );
    }
}
