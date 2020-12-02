trigger AutoAssignAccountOwner on Account (before insert) {
    boolean isDataLoader = [Select Data_Loader__c From User Where Id = :UserInfo.getUserId()][0].Data_Loader__c;
  
    if(isDataLoader)
    {
        List<User> AllUsers = [SELECT Agent_Number__c, Id From User];

        //Load Map with Agent Number as Key
        Map<String, String> Agent2Champion = new Map<String, String>();
        for(Agent_to_Champion__c ac : [SELECT Agent_Number__c, Champion__c FROM Agent_to_Champion__c])
        {
            Agent2Champion.put(ac.Agent_Number__c, ac.Champion__c);
        }

        //Bulkify Trigger...> 
        for(Account a : Trigger.New) {
            if(Agent2Champion.containsKey(a.Agent_Number__c) )
            {
                a.OwnerId = Agent2Champion.get(a.Agent_Number__c);
            }

            if(String.IsBlank(a.PersonEmail) && String.IsBlank(a.Email_2__c))
            {
                a.EMAIL_STATUS__PC = 'No Email';            
            }
        }
    }
}