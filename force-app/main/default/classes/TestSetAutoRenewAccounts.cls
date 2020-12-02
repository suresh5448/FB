@isTest
private class TestSetAutoRenewAccounts {


 @testSetup static void setup() {

        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        Profile p = [SELECT Id FROM Profile WHERE Name='MFBI Admin']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Data', LastName='Loader', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserasdkjsad@testorg.com.ABCD1234', Agent_number__c='', Data_Loader__c=True);

        insert u;

        User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Test', LastName='User', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuserxsdkjsd@test.com.ABCD1234', Agent_number__c='1234');
        
        insert u2;


            User u3 = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Magic', LastName='Johnson', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuserxsdkjsd@test.com.XXABCD1234', Agent_number__c='3456');
        
        insert u3;

        Agent_to_Champion__c ac = new Agent_to_Champion__c(Agent_Number__c='1234', Champion__c=u2.id); //Account of Test user
        insert ac;

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        accounts.add(new Account(Firstname='Account', LastName='1', Agent_number__c='3456', Ownerid=u.Id ,Action_date__c =  Date.today().addDays(-1), No_Fault_Status__c='Contact Made',In_Progress_status__c='Contact Made', RecordTypeId = recordTypeId, Email_2__c='test@test.com', PersonEmail='test@test.com')); //Data loader -test insert

        accounts.add(new Account(Firstname='Account',LastName='2', Agent_number__c='1234', Ownerid=u2.Id,Action_date__c =  Date.today().addDays(-1),No_Fault_Status__c='Contact Made',RecordTypeId = recordTypeId)); //Test User - test update

        insert accounts;

    }

    @isTest static void TestSchedule()
    {
        User u = [Select id from User Where UserName='standarduserasdkjsad@testorg.com.ABCD1234'];
        Account a = [SELECT id, No_Fault_Status__c, Email_2__c,PersonEmail FROM ACCOUNT WHERE Name = 'Account 1'];

        String CRON_EXP = '0 0 0 3 9 ? 2022';
    System.runAs(u) {
        Test.startTest();
       SetAutoRenewAccounts sara =  new SetAutoRenewAccounts();
            String jobId = System.schedule('TestSetAutoRenewAccounts', CRON_EXP, sara);
       sara.execute(null);
        Test.stopTest(); //Schedule will kick off here
        }
        System.assertEquals(2, [SELECT COUNT() FROM ACCOUNT WHERE No_Fault_Status__c='System Renew']);


    }

    
}