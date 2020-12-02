global class UpdateEmailToNoEmail implements Database.Batchable<sObject>, Database.Stateful {

        global Integer recordsProcessed = 0;
        global Integer totalRecords = 0;
    global Database.QueryLocator  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String Query='SELECT ID, EMAIL_STATUS__PC FROM Account WHERE PersonEmail = \'\' AND Email_2__c = \'\' AND EMAIL_STATUS__PC = \'Unverified\'';
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        //Create Map of Agent to UserId
        List<Account> accounts = new List<Account>();

        for(Account a : records)
        {
            a.EMAIL_STATUS__PC = 'No Email';
            recordsProcessed++;
        }
        update records;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(recordsProcessed + ' records processed. Shazam!');
    }    
}