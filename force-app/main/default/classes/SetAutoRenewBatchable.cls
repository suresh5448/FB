global class SetAutoRenewBatchable implements Database.Batchable<sObject>, Database.Stateful {

        global Integer recordsProcessed = 0;
        global Integer totalRecords = 0;
    global Database.QueryLocator  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        

        String Query='SELECT Id, No_Fault_Status__c, In_Progress_Status__c FROM Account WHERE Action_Date__c <= TODAY AND No_Fault_Status__c NOT IN (\'Renew to No Fault\', \'Rewrite to No Fault\',\'System Renew\',\'Cancelled per Insured Request\')';


        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        //Create Map of Agent to UserId
        //List<Account> accounts = new List<Account>();
        totalRecords = records.size();
        for (Account a : records) {
            a.No_Fault_Status__c = 'System Renew';
            //System.Debug('Current User: ' + UserInfo.getUserId());
            recordsProcessed = recordsProcessed + 1;
        }
        update records;


    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(recordsProcessed + ' records processed. Shazam! Total Input: ' + totalRecords);
    }    
}