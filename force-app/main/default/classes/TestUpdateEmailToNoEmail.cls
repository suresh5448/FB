@isTest
private class TestUpdateEmailToNoEmail {
    @testSetup 
    static void setup() {
        // insert 10 accounts
        
 
    }

    static testmethod void test() {        
        Test.startTest();
        List<Account> accounts = new List<Account>();

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Data', LastName='Loader', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserasdkjsad@testorg.com.ABCD1234', Agent_number__c='');

        insert u;


        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account a = new Account(Firstname='Account', LastName='1', Agent_number__c='3456', Ownerid=u.Id ,Action_date__c =  Date.today().addDays(-1), No_Fault_Status__c='Contact Made',In_Progress_status__c='Contact Made', RecordTypeId = recordTypeId, Email_2__c='', PersonEmail='', Email_Status__pc='Unverified'); //Data loader -test insert

        accounts.add(a);
        //accounts.add(new Account(name='Account 1', Agent_number__c='1234', Ownerid=u.Id));
   
        insert accounts;


        UpdateEmailToNoEmail uca = new UpdateEmailToNoEmail();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select count() from Account where Email_Status__pc='No Email']);
    }


}