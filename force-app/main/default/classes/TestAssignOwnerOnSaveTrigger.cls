@isTest
private class TestAssignOwnerOnSaveTrigger {
    @testSetup static void setup() {

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


            User u3 = new User(Alias = 'standt', Email='standarduser@testorg.com.ABCD1234', 
            EmailEncodingKey='UTF-8', FirstName='Magic', LastName='Johnson', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuserxsdkjsd@test.com.XXABCD1234', Agent_number__c='3456');
        
        insert u3;

        Agent_to_Champion__c ac = new Agent_to_Champion__c(Agent_Number__c='1234', Champion__c=u2.id); //Account of Test user
        insert ac;

        accounts.add(new Account(name='Account 1', Agent_number__c='3456', Ownerid=u.Id)); //Data loader -test insert

        accounts.add(new Account(name='Account 2', Agent_number__c='1234', Ownerid=u2.Id)); //Test User - test update



        insert accounts;

    }

    @isTest static void TestUpdate(){
        Test.startTest();

        //Update agent_to_champion. Will trigger to move accounts
        Agent_to_Champion__c ac = [SELECT id, Agent_Number__c, Champion__c FROM Agent_to_Champion__c WHERE Agent_Number__c='1234'];
        ac.Assign_on_Save__c = True; //To Force Assignment...
        
        User toBeAssigned = [Select id from User Where Name = 'Magic Johnson'];
        ac.Champion__c = toBeAssigned.id;
        update ac; //Will transfer ownership of Account 2 from Test user to Magic Johnson.
        Test.stopTest();

        Account a = [SELECT Owner.Name from Account WHERE Name='Account 2'];
        System.assertEquals('Magic Johnson',a.Owner.Name);



    }

    @isTest static void TestInsert() {
        Test.startTest();
        User toBeAssigned = [Select id from User Where Name = 'Magic Johnson'];
        Agent_to_Champion__c ac = new Agent_to_Champion__c(Agent_Number__c='3456', Champion__c=toBeAssigned.id); //Account of Test user
        ac.Assign_on_Save__c = True; //To Force Assignment...

        insert ac;
       
        Test.stopTest();
        Account a = [SELECT Owner.Name from Account WHERE Name='Account 1'];
        System.assertEquals('Magic Johnson',a.Owner.Name);
    }
}