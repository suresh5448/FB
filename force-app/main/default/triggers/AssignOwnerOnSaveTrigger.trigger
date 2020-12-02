trigger AssignOwnerOnSaveTrigger on Agent_to_Champion__c (before insert, before update) {

        for(Agent_to_Champion__c ac : Trigger.New) {
            //Agent_to_Champion__c OldVer = Trigger.oldMap.get(a.Id);
            if(ac.Assign_on_Save__c)
            {
                ac.Assign_on_Save__c = false; //Reset this...
                //Champion__c
                //Agent_Number__c
                if (Trigger.isUpdate) {
                    //Take old Champion, and find all accounts and transfer ownership.
                    List<Account> acctsToUpdate = new List<Account>();
                    Agent_to_Champion__c OldVer = Trigger.oldMap.get(ac.Id);
                    List<Account> CurrentAccounts = [SELECT id, OwnerId FROM ACCOUNT WHERE OwnerId=:OldVer.Champion__c];
                    Integer size = CurrentAccounts.size();
                    
                    for(Integer i = 0; i < size; ++i)
                    {            
                        CurrentAccounts[i].OwnerId = ac.Champion__c;
                        //acctsToUpdate.add(CurrentAccounts[i]);
                    }
                    update CurrentAccounts;    
                }
                else if(Trigger.isInsert)
                {
                    //Select all accounts with Agent Number
                    List<Account> acctsToUpdate = new List<Account>();
                    for(Account a : [SELECT id, OwnerId FROM ACCOUNT WHERE Agent_Number__c=:ac.Agent_Number__c])
                    {
                        a.OwnerId = ac.Champion__c;
                        acctsToUpdate.add(a);
                    }
                    update acctsToUpdate;    
                }
            }
        }

}