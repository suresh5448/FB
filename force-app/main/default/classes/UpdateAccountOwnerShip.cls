global class UpdateAccountOwnerShip implements Database.Batchable<sObject>, Database.Stateful {

        global Integer recordsProcessed = 0;
        global Integer totalRecords = 0;
    global Database.QueryLocator  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String Query='SELECT ID, OWNERID, Agent_Number__c FROM Account WHERE OWNER.NAME = \'Data Loader\'';
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        //Create Map of Agent to UserId
        List<Account> accounts = new List<Account>();

        Map<String, String> Agent2Champion = new Map<String, String>();
        for(Agent_to_Champion__c ac : [SELECT Agent_Number__c, Champion__c FROM Agent_to_Champion__c])
        {
            Agent2Champion.put(ac.Agent_Number__c, ac.Champion__c);
        }

        for (Account account : records) {
            totalRecords = totalRecords + 1;
            if(Agent2Champion.containsKey(account.Agent_Number__c))
            {

                account.OwnerId = Agent2Champion.get(account.Agent_Number__c);
                accounts.add(account);
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update accounts;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(recordsProcessed + ' records processed. Shazam! Total Input: ' + totalRecords);
    }    
}