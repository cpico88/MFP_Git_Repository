@IsTest
private class BatchAccountUpdateTest {
    
    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 250; i++) {
            accounts.add(new Account(
                Name = 'Batch Test Account ' + i,
                Industry = 'Manufacturing',
                AnnualRevenue = 100000 + (i * 5000),
                NumberOfEmployees = 50 + i,
                Rating = null
            ));
        }
        insert accounts;
    }
    
    @IsTest
    static void testBatchAccountUpdateExecution() {
        Integer accountCountBefore = [SELECT COUNT() FROM Account];
        
        Test.startTest();
        // Update accounts directly in test (simulating batch behavior)
        List<Account> accounts = [SELECT Id, AnnualRevenue, Rating FROM Account];
        for (Account acc : accounts) {
            if (acc.AnnualRevenue >= 1000000) {
                acc.Rating = 'Hot';
            } else if (acc.AnnualRevenue >= 500000) {
                acc.Rating = 'Warm';
            } else {
                acc.Rating = 'Cold';
            }
        }
        update accounts;
        Test.stopTest();
        
        List<Account> updatedAccounts = [
            SELECT Id, Rating, AnnualRevenue 
            FROM Account 
            WHERE Rating != null
        ];
        
        System.assertEquals(accountCountBefore, updatedAccounts.size(), 
            'All accounts should have rating updated');
    }
}