global class Survey {
    public static List<Survey.Requests> toListRequestID (Set<Id> alertsId){
      List<Alert__c> alerts = [Select ID, Name, alert_type__c,Missguided_Type__c,Carrier_name__c,DETECTED_CLOSED_DATE__C,International_Site_Id__c,TemplateIdMsgPudo__c,Contractual_threshold__c,Max_threshold__c from ALert__c where ID in:alertsId];
      List<Survey.Requests> listSurvey = new List<Survey.Requests>();
      
      For(Alert__c alert:alerts){
        if(alert.alert_type__c=='1'){
          Survey.Requests oveloadSurvey= toRequestOverload(alert);
          listSurvey.add(oveloadSurvey);
        }
        if(alert.alert_type__c=='2' && alert.Missguided_Type__c=='2'){
          Survey.Requests partMissguideSurvey= toRequestPartMissGuided(alert);
          listSurvey.add(partMissguideSurvey);
        }
       if(alert.alert_type__c=='2' && alert.Missguided_Type__c=='1'){
          Survey.Requests fullMissguideSurvey= toRequestFullMissGuided(alert);
          listSurvey.add(fullMissguideSurvey);
        }
      }
      return listSurvey;
    }
    public Static Survey.Requests toRequestOverload(Alert__c alert) {
      String ContractThreshold=String.valueOf(alert.Contractual_threshold__c);
      String MaxThreshold=String.valueOf(alert.Max_threshold__c);
      //String MinThreshold=Label.MinThreshold;
      String MinThreshold=String.valueOf(alert.Contractual_threshold__c);
      String site_id=alert.International_Site_Id__c;
      String source=Label.Source;
      String IdAlert=alert.Id;
      String templatekey=alert.TemplateIdMsgPudo__c;
      List<Survey.InputData> listInputValue = new List<Survey.InputData>();
      Survey.InputData inputContThreshold= new Survey.InputData('ContractThreshold',ContractThreshold);
      listInputValue.add(inputContThreshold);
      Survey.InputData inputMaxThreshold = new Survey.InputData('MaxThreshold',MaxThreshold);
      listInputValue.add(inputMaxThreshold);
      Survey.InputData inputMinThreshold= new Survey.InputData('MinThreshold',MinThreshold);
      listInputValue.add(inputMinThreshold);
      Survey.Request arequest= new Survey.Request(site_id,source,templatekey,listInputValue);
      Survey.Requests requests= new Survey.Requests(IdAlert,arequest);
      return requests;
    }
    public Static Survey.Requests toRequestPartMissGuided(Alert__c alert) {
      String carrierName=alert.Carrier_name__c;
      String site_id=alert.International_Site_Id__c;
      String source=Label.Source;
      String IdAlert=alert.Id;
      String templatekey=alert.TemplateIdMsgPudo__c;
      List<Survey.InputData> listInputValue = new List<Survey.InputData>();
      Survey.InputData carrierNameTemplate= new Survey.InputData('CarrierName',carrierName);
      listInputValue.add(carrierNameTemplate);
      Survey.Request arequest= new Survey.Request(site_id,source,templatekey,listInputValue);
      Survey.Requests requests= new Survey.Requests(IdAlert,arequest);
      return requests;
    }
    public static Survey.Requests toRequestFullMissGuided(Alert__c alert) {
      String carrierName=alert.Carrier_name__c;
      String detectedDate= string.valueof(alert.Detected_Closed_Date__c);
      String site_id=alert.International_Site_Id__c;
      String source=Label.Source;
      String IdAlert=alert.Id;
      String templatekey=alert.TemplateIdMsgPudo__c;
      List<Survey.InputData> listInputValue = new List<Survey.InputData>();
      Survey.InputData carrierNameTemplate= new Survey.InputData('CarrierName',carrierName);
      listInputValue.add(carrierNameTemplate);
      Survey.InputData detectedDateTemplate= new Survey.InputData('CloseDate',detectedDate);
      listInputValue.add(detectedDateTemplate);
      Survey.Request arequest= new Survey.Request(site_id,source,templatekey,listInputValue);
      Survey.Requests requests= new Survey.Requests(IdAlert,arequest);
      return requests;
    }

  public List<Requests> Requests {get;set;}

  public Survey(List<Requests> listRequests){
    Requests=listRequests;

  }

  /*public Survey(JSONParser parser) {
    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
      if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
        String text = parser.getText();
        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
          if (text == 'Requests') {
            Requests = arrayOfRequests(parser);
          } else {
            System.debug(LoggingLevel.WARN, 'Survey consuming unrecognized property: '+text);
            consumeObject(parser);
          }
        }
      }
    }
  }*/
  public class Request {
    public String Recipient {get;set;} 
    public String Source {get;set;} 
    public String TemplateKey {get;set;} 
    public List<InputData> InputData {get;set;}
    
    public Request(String arecipient, string asource, string atemplatekey, List<Survey.InputData> listinputdata){
      Recipient=arecipient;
      Source=asource;
      TemplateKey=atemplatekey;
      InputData=listinputdata; 
    }

    /*public Request(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'Recipient') {
              Recipient = parser.getText();
            } else if (text == 'Source') {
              Source = parser.getText();
            } else if (text == 'TemplateKey') {
              TemplateKey = parser.getText();
            } else if (text == 'InputData') {
              InputData = arrayOfInputData(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'Request consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }*/
  }
  
  public class InputData {
    public String Name {get;set;} 
    public String Value {get;set;} 
    public InputData(String property,String aValue){
            Name=Property;
            Value=aValue;
    }
    /*public InputData(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'Name') {
              Name = parser.getText();
            } else if (text == 'Value') {
              Value = parser.getText();
            } else {
              System.debug(LoggingLevel.WARN, 'InputData consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }*/
  }

  public class Requests {
    public String ContextIdentifier {get;set;} 
    public Request Request {get;set;} 
    public Requests(String Idalert, Survey.Request arequest){
      ContextIdentifier=Idalert;
      Request=arequest;
    }

    /*public Requests(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'ContextIdentifier') {
              ContextIdentifier = parser.getText();
            } else if (text == 'Request') {
              Request = new Request(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'Requests consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }*/
  }

  /*public static Survey parse(String json) {
    System.JSONParser parser = System.JSON.createParser(json);
    return new Survey(parser);
  }*/

  /*public static void consumeObject(System.JSONParser parser) {
    Integer depth = 0;
    do {
      System.JSONToken curr = parser.getCurrentToken();
      if (curr == System.JSONToken.START_OBJECT || 
        curr == System.JSONToken.START_ARRAY) {
        depth++;
      } else if (curr == System.JSONToken.END_OBJECT ||
        curr == System.JSONToken.END_ARRAY) {
        depth--;
      }
    } while (depth > 0 && parser.nextToken() != null); 
  }*/

    /*private static List<Requests> arrayOfRequests(System.JSONParser p) {
        List<Requests> res = new List<Requests>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Requests(p));
        }
        return res;
    }*/

    /*public static List<InputData> arrayOfInputData(System.JSONParser p) {
        List<InputData> res = new List<InputData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InputData(p));
        }
        return res;
    }*/

}