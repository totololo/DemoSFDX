/*
* Author: RFO
* Modified By: -
* Date : 05/06/2018
* 
* This class is used to extract and store the device's type and the device's ids from the description field received by the telecollete. 
*
* Description of an anomaly can be :
*   - PDA_WINDOWS/M3/////GA5GNCNJD3995639 (one device)
*   - 2//[PDA_ANDROID/Athesi//5.3.0.84178.0/012802B12172302209]/[PDA_WINDOWS/M3///WA10SWCNNK47654] (2 or more devices)
*
* Test classe: AP03_Anomalie_Test
* Coverage : 95%
*/
public class AP03_Anomalie {
    
    public static void extractTypeAndDeviceID(List<Anomalie__c> newAnomalieList){
    
        for (Anomalie__c ano : newAnomalieList){
            try{
                String description = ano.Description__c;
                if (description != null){
                    //test if it's a single device or multiple device info
                    if(description.contains('[')){
                        //remove the 3 first caracters
                        String newDesc = description.mid(3,description.length());
                        String[] devicesInfo = newDesc.split('\\]/\\[');
                        System.debug('multiple device info'+devicesInfo);
                        ano.NB_PDA__c = devicesInfo.size();
                        for( Integer i=0 ; i < ano.NB_PDA__c ; i++){                            
                            String devicex = devicesInfo[i];
                            devicex  = devicex.remove('[');
                            devicex  = devicex.remove(']');
                            String[] info = devicex.split('/');
                            //Concat all device type into the Type field separated by |
                            if(String.isBlank(ano.PDA_type__c)){
                                ano.PDA_type__c = info[0];
                            }else{
                                ano.PDA_type__c = ano.PDA_type__c + '|' + info[0];
                            }    
                            //Concat all device ids into the id field separated by |
                            if(String.isBlank(ano.PDA_ids__c)){
                                ano.PDA_ids__c = info[info.size()-1];
                            }else{
                                ano.PDA_ids__c = ano.PDA_ids__c + '|' + info[info.size()-1];
                            }    
                        }
                        
                    }else{
                        String[] values = description.split('/');
                        System.debug('single device info'+values);
                        //1rst element is the device type
                        ano.PDA_type__c = values[0];
                        //last element is the id of the device
                        ano.PDA_ids__c = values[values.size()-1];
                        ano.NB_PDA__c = 1;
                    }
                }
            }catch(Exception e){
                System.debug(e);
            }
         }
    }
    
}