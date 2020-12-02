@isTest
private class TestUpdateAccountOwnerShip {
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Data', LastName='Loader', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserasdkjsad@testorg.com.ABCD1234', Agent_number__c='');

        insert u;

        User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Test', LastName='User', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuserxsdkjsd@test.com.ABCD1234', Agent_number__c='1234');
        
        insert u2;

        Agent_to_Champion__c ac = new Agent_to_Champion__c(Agent_Number__c='1234', Champion__c=u2.id);
        insert ac;

        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, Agent_number__c='1234', Ownerid=u.Id));
        }
        insert accounts;
 
    }

    static testmethod void test() {        
        Test.startTest();
        UpdateAccountOwnerShip uca = new UpdateAccountOwnerShip();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Account where Owner.Name='Test User']);
    }


}