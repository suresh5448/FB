@isTest
private class TestAutoAssignAccountOwner {
    @testSetup static void setup() {

  

    }

    @isTest static void TestAddAccount() {
        Test.startTest();

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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

        Agent_to_Champion__c ac = new Agent_to_Champion__c(Agent_Number__c='1234', Champion__c=u2.id);
        insert ac;

        system.runAs(u)
        {
            id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

            Account a = new Account(FirstName='Account ', LastName='World', Agent_number__c='1234', Ownerid=u.Id, RecordTypeId=recordTypeId);
            insert a;
        }
        Test.stopTest();
        Account a = [SELECT Email_Status__pc, Owner.Name from Account LIMIT 1];
        System.assertEquals('Test User',a.Owner.Name);
        System.assertEquals('No Email', a.Email_Status__pc);

    }
}