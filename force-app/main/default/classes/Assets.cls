public class Assets {
  public List<Asset> records { get; private set; }
  Set<String> truncatedSnsInDB { 
    get {
      if(truncatedSnsInDB == null){
        truncatedSnsInDB = AssetsSelector.getAllTruncatedSn();
      }
      return truncatedSnsInDB;
    } 
    private set; 
  }

  public Assets(List<Asset> records) {
    this.records = records;
  }

  public void onBeforeInsert(){
    //TODO:
  }

  public void onBeforeUpdate(){
    //TODO:
  }
}