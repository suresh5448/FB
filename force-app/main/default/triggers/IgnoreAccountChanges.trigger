trigger IgnoreAccountChanges on Account (before update) {
    
    boolean isDataLoader = [Select Data_Loader__c From User Where Id = :UserInfo.getUserId()][0].Data_Loader__c;
  
    for(Account a : Trigger.New) {
        Account OldVer = Trigger.oldMap.get(a.Id);


        //Dataload not allowed to make status changes. MC User should not be a dataloader
        if(isDataLoader)
        {
            //Ignore No Fault Status Updates
            if(a.No_Fault_Status__c == 'Not Started')
            {
                a.No_Fault_Status__c = OldVer.No_Fault_Status__c; //ignore changes coming from Data loader trying to set to not started.
            }

            a.Email_Status__pc = OldVer.Email_Status__pc; //Will this work!?
            //a.No_Fault_Status__c = OldVer.No_Fault_Status__c;
            a.Action_Date__c = OldVer.Action_Date__c;
            if(!String.IsBlank(OldVer.PersonEMail))
            {
                a.PersonEMail = OldVer.PersonEMail;
                a.Email_Source1__c = OldVer.Email_Source1__c;
            }
            if(!String.IsBlank(OldVer.Email_2__c))
            {
                a.Email_2__c = OldVer.Email_2__c;
                a.Email_2_Source__c = OldVer.Email_2_Source__c;
             }
        }
        
        
        if(OldVer.In_Progress_status__c != a.In_Progress_status__c) //A Change was made!
        {
            a.No_Fault_Status__c = a.In_Progress_Status__c;
        }
        else if(OldVer.No_Fault_Status__c != a.No_Fault_Status__c)
        {
            if((a.No_Fault_Status__c == 'Contact Made')
                ||
                (a.No_Fault_Status__c == 'Client Focus')
                ||
                (a.No_Fault_Status__c == 'DocuSign Sent')
                ||
                (a.No_Fault_Status__c == 'DocuSign Received')
                ||
                (a.No_Fault_Status__c == 'DocuSign Terminated')
                ||
                (a.No_Fault_Status__c == 'Paper Form Agent')
                ||
                (a.No_Fault_Status__c == 'Paper Form Home Office'))
            {
                a.In_Progress_Status__c = a.No_Fault_Status__c;
            }
                
        }

    }   
}