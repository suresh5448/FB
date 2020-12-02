global class SetAutoRenewAccounts implements Schedulable {
    global void execute(SchedulableContext ctx) {
        SetAutoRenewBatchable bc = new SetAutoRenewBatchable();
        database.executebatch(bc);

    }
    
}