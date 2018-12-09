public class AssetTriggerHandler extends TriggerHandler {
  public override void beforeInsert(List<SObject> newItems) {
      Assets assets = new Assets((List<Asset>)newItems);
      assets.onBeforeInsert();
  }

  public override void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
      Assets assets = new Assets((List<Asset>)newItems.values());
      assets.onBeforeUpdate();
  }
}