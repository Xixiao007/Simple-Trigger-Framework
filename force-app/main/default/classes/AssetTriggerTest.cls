@isTest
public class AssetTriggerTest {
  private static List<Account> accounts = [SELECT Id, Name FROM Account ORDER BY Id];
  private static List<Asset> assets = [SELECT Id, truncated_sn__c FROM Asset ORDER BY Id];

  @TestSetup
  static void makeData(){
    accounts = Test.loadData(Account.sObjectType, 'unit_test_accounts');
    assets = Test.loadData(Asset.sObjectType, 'unit_test_AssetsTest_assets');
  }

  static void validateMakeData(){
    System.assert(accounts.size() > 0, 'DATA FAILURE: no accounts.');
    System.assert(assets.size() > 0, 'DATA FAILURE: no assets.');
  }

  @isTest
  static void insertSucces_whenNoDuplicates(){
    validateMakeData();

    Asset asset1 = new Asset(SerialNumber= '1234567', Name='testAsset', AccountId=accounts[0].Id);
    Asset asset2 = new Asset(SerialNumber= '12345678', Name='testAsset', AccountId=accounts[0].Id);
    List<Asset> assetsToInsert = new List<Asset>{asset1, asset2};

    try{
      insert assetsToInsert;
    } catch (DMLException e){
      System.assert(false, 'Should not be here. ' + e.getMessage());
    }
  }

  @isTest
  static void insertFailure_identicalSn_inUploading(){
    validateMakeData();
    validateTwoDuplicatesInUploading('12345678', '12345678');
  }

  @isTest
  static void insertFailure_afterLetterTruncation_inUploading(){
    validateMakeData();
    validateTwoDuplicatesInUploading('123test45678', '12345678test');
  }

  @isTest
  static void insertFailure_afterSpaceTruncation_inUploading(){
    validateMakeData();
    validateTwoDuplicatesInUploading(' 1 2  3  4 56 78', '123  45 6 7 8');
  }

  @isTest
  static void insertFailure_afterLetterAndSpaceTruncation_inUploading(){
    validateMakeData();
    validateTwoDuplicatesInUploading(' 1 2test  3  4test 56 78test', 'test12test3  45 6 7 8');
  }

  static void validateTwoDuplicatesInUploading(String serialNumber1, String serialNumber2){
    Asset asset1 = new Asset(SerialNumber= serialNumber1, Name='testAsset', AccountId=accounts[0].Id);
    Asset asset2 = new Asset(SerialNumber= serialNumber2, Name='testAsset', AccountId=accounts[0].Id);
    List<Asset> assetsToInsert = new List<Asset>{asset1, asset2};

    Test.startTest();
    try{
      insert assetsToInsert;
    } catch (DMLException e){
      System.assertEquals(1, e.getNumDml());
      System.assertEquals('Two records that are in uploading have the same SerialNumber value.', e.getDmlMessage(0));
      System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
    }
    Test.stopTest();
  }
}
