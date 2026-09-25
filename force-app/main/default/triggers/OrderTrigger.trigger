/**
 * @description Standard Apex Trigger on Order object using Trigger Handler pattern.
 * @author Trivino (Salesforce Technical Consultant)
 */
trigger OrderTrigger on Order (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            OrderTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            OrderTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
