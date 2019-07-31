({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
          
        var currentUrl = decodeURIComponent(window.location);
        var accountId = currentUrl.substring(currentUrl.indexOf('/001') +1,currentUrl.indexOf('/001') + 16 );
          
        var url = '/apex/VFP14_DemarrageCompteRenduRempli?accId='+accountId;
        if(recordId != null && recordId !=''){
            url+= '&id=' + recordId;
        }
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getAllTabInfo().then(function(response) {
            // console.log(response);
            var BreakException = {};
            var index=0;
            try{
                 response.forEach(function(childArray) {
                     //alert(childArray['focused'] );
                     if(childArray['focused'] == true || childArray['focused'] == 'true'){
                         //alert('ok' );
                        throw BreakException;
                     } 
                    index = index+1;
                 });
                
            }
            catch(err) {
             console.log(err.message);
            }
            var parentTab= response[index];
            
            var childTabs = parentTab.subtabs;
            var childTab = childTabs[parentTab.subtabs.length-1].tabId;
            
            workspaceAPI.openTab({
                url: parentTab.url,
                title: 'Global Media'
            })
            .then(function(response) {
                workspaceAPI.openSubtab({
                    parentTabId : parentTab.tabId,
                    url: url,
                    title: 'Glo',
                    focus: true
                })
            }).then(function(response) {
                workspaceAPI.closeTab({tabId: childTab})
            });
        });
        
    }
})