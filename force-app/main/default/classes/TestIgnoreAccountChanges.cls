@isTest
private class TestIgnoreAccountChanges {


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

        accounts.add(new Account(Firstname='Account', LastName='1', Agent_number__c='3456', Ownerid=u.Id, No_Fault_Status__c='Contact Made',In_Progress_status__c='Contact Made', RecordTypeId = recordTypeId, Email_2__c='test@test.com', PersonEmail='test@test.com')); //Data loader -test insert

        accounts.add(new Account(Firstname='Account',LastName='2', Agent_number__c='1234', Ownerid=u2.Id, RecordTypeId = recordTypeId)); //Test User - test update

        insert accounts;

    }

    @isTest static void TestDataLoader()
    {
        User u = [Select id from User Where UserName='standarduserasdkjsad@testorg.com.ABCD1234'];
        Account a = [SELECT id, No_Fault_Status__c, Email_2__c,PersonEmail FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.startTest();


        System.runAs(u) {
            a.No_Fault_Status__c = 'Not Started';
            a.Email_2__c = 'newEmail@email.org';
            a.PersonEmail = 'newEmail@yahoo.com';
            update a;
        }
        a = [SELECT id, No_Fault_Status__c, Email_2__c,PersonEmail  FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.stopTest();
        System.assertEquals('Contact Made', a.No_Fault_Status__c); //Not Started should be ignored.
        System.assertEquals('test@test.com', a.PersonEmail); //Not Started should be ignored.
        System.assertEquals('test@test.com', a.Email_2__c); //Not Started should be ignored.

    }

    @isTest static void TestPickListSyncsNoFaultToInProg()
    {
         User u = [Select id from User Where UserName='testuserxsdkjsd@test.com.ABCD1234'];
         Account a = [SELECT id, No_Fault_Status__c,In_Progress_status__c FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.startTest();
        System.runAs(u) {
            a.No_Fault_Status__c = 'Client Focus';
            update a;
        }
        a = [SELECT id, No_Fault_Status__c, In_Progress_status__c FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.stopTest();

        System.assertEquals('Client Focus', a.In_Progress_status__c);


    }

    @isTest static void TestPickListSyncsInProgToNoFault()
    {
         User u = [Select id from User Where UserName='testuserxsdkjsd@test.com.ABCD1234'];
         Account a = [SELECT id, No_Fault_Status__c,In_Progress_status__c FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.startTest();
        System.runAs(u) {
            a.In_Progress_status__c = 'Contact Made';
            update a;
        }
        a = [SELECT id, No_Fault_Status__c, In_Progress_status__c FROM ACCOUNT WHERE Name = 'Account 1'];

        Test.stopTest();

        System.assertEquals('Contact Made', a.No_Fault_Status__c);


    }

    
}