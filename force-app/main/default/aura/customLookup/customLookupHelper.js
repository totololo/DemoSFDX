({
    //added by John
    setContact : function(component,event) {
        //getting contact ID and Name
        var params = event.getParam('arguments');
        if(Boolean(params != null) && JSON.stringify(params) != '{}')
        {
            component.set("v.ContactID", params.param1);
            component.set("v.AccountID", params.param2);
            var contactName = '';
            // call the apex class method 
            var action = component.get("c.getContactNameApex");
            // set param to method  
            action.setParams({
                'ContactID' : component.get("v.ContactID")
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") { 
                    contactName = response.getReturnValue();
                    var forclose = component.find("lookup-pill");
                    $A.util.addClass(forclose, 'slds-show');
                    $A.util.removeClass(forclose, 'slds-hide');
                    
                    var forclose = component.find("searchRes");
                    $A.util.addClass(forclose, 'slds-is-close');
                    $A.util.removeClass(forclose, 'slds-is-open');
                    
                    var lookUpTarget = component.find("lookupField");
                    $A.util.addClass(lookUpTarget, 'slds-hide');
                    $A.util.removeClass(lookUpTarget, 'slds-show');  

                    if(Boolean(String(params.param1) != 'undefined'))
                    {
                        component.set("v.selectedRecord" , JSON.parse('{"Id":"' + params.param1 + '","Name":"'+ contactName +'"}') );
                    }
                    else
                    {
                        var pillTarget = component.find("lookup-pill");
                        var lookUpTarget = component.find("lookupField"); 
                        
                        $A.util.addClass(pillTarget, 'slds-hide');
                        $A.util.removeClass(pillTarget, 'slds-show');
                        
                        $A.util.addClass(lookUpTarget, 'slds-show');
                        $A.util.removeClass(lookUpTarget, 'slds-hide');
                        
                        component.set("v.SearchKeyWord",null);
                        component.set("v.listOfSearchRecords", null );
                        component.set("v.selectedRecord", {} );    
                    }
                    
                }
            });
            $A.enqueueAction(action);            
        }
    },

    searchHelper : function(component,event,getInputkeyWord) { 
        if(String(component.get("v.SearchKeyWord")) == 'null'
          || String(component.get("v.SearchKeyWord")) == 'undefined'
          || String(component.get("v.SearchKeyWord")) == '')
        {
            component.set('v.RequiredValidContact', '');
        }
        else 
        {
            component.set('v.RequiredValidContact', $A.get("$Label.c.DA_OptionNonValide"));
        }
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'AccountID' : component.get("v.AccountID"),
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set('v.RequiredValidContact', $A.get("$Label.c.DA_OptionNonValide"));
                    
                    component.set("v.Message", $A.get("$Label.c.DA_AucunResultat"));	
                    component.set("v.MessageInvaliOption", $A.get("$Label.c.DA_OptionNonValide2"));
                    
                } else {
                    //component.set('v.RequiredValidContact', '');
                    component.set("v.Message", '');
                    component.set("v.MessageInvaliOption", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})