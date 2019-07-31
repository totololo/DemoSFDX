/*
 * @description  : update or insert sobject in the future
 */
public class Queue_AsyncExecution implements Queueable{
    List<sObject> LSObject;
    Boolean isUpdate;
    public void execute(QueueableContext context){
        system.debug('hello '+index);
        system.debug('MisUpdate ' +MisUpdate);
        system.debug('MisUpdate.containsKey(index) ' +MisUpdate.containsKey(index));
        if(MisUpdate.containsKey(index)){
            if(MisUpdate.get(index)){
                System.debug('Updating SObject...');
                System.debug('sObject List size: ' + MLsObjectsToInsertUpdate.get(index).size());
                System.debug('sObject List type: ' + MLsObjectsToInsertUpdate.get(index)[0].getSObjectType());
                update MLsObjectsToInsertUpdate.get(index);
            }
            else{
                System.debug('Inserting SObject...');
                System.debug('sObject List     : ' + MLsObjectsToInsertUpdate);
                System.debug('sObject List size: ' + MLsObjectsToInsertUpdate.get(index).size());

                insert MLsObjectsToInsertUpdate.get(index);
            }
            
            if(++index < MLsObjectsToInsertUpdate.keySet().size() && !test.isRunningTest()){
                System.enqueueJob(new Queue_AsyncExecution(MLsObjectsToInsertUpdate, MisUpdate, index));}
        }
    }
    
    Map<Integer, List<sObject>> MLsObjectsToInsertUpdate;
    Map<Integer, Boolean> MisUpdate;
    Integer index;
    
    public Queue_AsyncExecution(Map<Integer, List<sObject>> MLsObjectsToInsertUpdate, Map<Integer, Boolean> MisUpdate, Integer index){
        System.debug('@FEK ' + index);
        system.debug('MLsObjectsToInsertUpdate '+MLsObjectsToInsertUpdate);

        this.MLsObjectsToInsertUpdate = MLsObjectsToInsertUpdate;
        this.MisUpdate = MisUpdate;
        this.index = index;
    }
}