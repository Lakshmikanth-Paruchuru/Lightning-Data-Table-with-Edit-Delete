//accountsDisplayApp.app
<aura:application extends="force:slds">
  <c:accountsDisplay2/>
</aura:application>



//LightningEvent.evt
<aura:event type="APPLICATION" description="Event template" >
    <aura:attribute name="sendata" type="string"/>    
    <aura:attribute name="sendId" type="string"/>
    <aura:attribute name="bool" type="boolean"/>
</aura:event>



//accountsDisplay.cmp
<aura:component controller="accountsDisplay" implements="flexipage:availableForRecordHome,force:hasRecordId" access="global">
    <aura:attribute name="accounts" type="Account[]"/>
    <aura:attribute name="contacts" type="Contact[]"/>
    <aura:attribute name="edit" type="boolean"/>
    <aura:attribute name="view" type="boolean"/>
    <aura:attribute name="viewedit" type="id"/>
    <aura:attribute name="visible" type="boolean" default="true"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <aura:registerEvent name="message" type="c:LightningEvent"/>
    <aura:renderIf isTrue="{!v.visible}">
    <div class="slds-page-header">
    Welcome to Lightning  
    </div>
    <table class="slds-table">
      <thead>
        <tr>
            <th scope="col">Account Name</th>
            <th scope="col">Account Phone</th>
            <th scope="col">Account Industry</th>
            <th scope="col">Account Rating</th>
            <th scope="col">Account Type</th>
          </tr>
        </thead>
        <tBody>
        <aura:iteration items="{!v.accounts}" var="a">
         <tr>
            <th scope="col">
                <a href="#" id="{!a.Id}" onclick="{!c.handleClick}">{!a.Name}</a>   
          <!--a onclick="{!c.handleClick}" value="{!a.Name}">{!a.Name}</a-->                
             </th>           
             <th scope="col">
             <ui:outputText value="{!a.Phone}"></ui:outputText>
             </th>
            <th scope="col">
             <ui:outputText value="{!a.Industry}"></ui:outputText>
             </th>     
            <th scope="col">
             <ui:outputText value="{!a.Rating}"></ui:outputText>
             </th>      
            <th scope="col">
             <ui:outputText value="{!a.Type}"></ui:outputText>
             </th> 
             <th scope="col">
             <p><a onclick="{!c.Edit}" id="{!a.Id}">Edit</a></p>
             </th>
             <th scope="col">
             <p>|</p>
             </th>
             <th scope="col">
             <p><a onclick="{!c.Del}" id="{!a.Id}">Del</a></p>
             </th>
            </tr>
            </aura:iteration> 
            <br/><br/><br/><br/>
        </tBody>
    </table>
    <aura:renderIf isTrue="{!v.edit}">
      
         <div role="dialog" tabindex="-1" aria-labelledby="header99" class="slds-modal slds-fade-in-open ">
        <div class="slds-modal__container">
          <!-- ###### MODAL BOX HEADER Part Start From Here ######-->
          <div class="slds-modal__header">
            <button class="slds-button slds-modal__close slds-button--icon-inverse" title="Close" onclick="{!c.closeModel}">
            X
            <span class="slds-assistive-text">Close</span>
            </button>
            <h2 id="header99" class="slds-text-heading--medium">edit record</h2>
          </div>
          <!--###### MODAL BOX BODY Part Start From Here ######-->
          <div class="slds-modal__content slds-p-around--medium">
            <p>  <!--force:recordEdit aura:id="edit" recordId="{!v.viewedit}"/-->
          <lightning:recordEditForm recordId="{!v.viewedit}" objectApiName="Account">
        <lightning:messages />
        <lightning:inputField fieldName="Name" />
        <lightning:inputField fieldName="Phone" />
        <lightning:inputField fieldName="Industry" />
        <lightning:inputField fieldName="Rating" />
        <lightning:inputField fieldName="Type" />
            
        <lightning:button class="slds-m-top_small" variant="brand" type="submit" name="update" label="Update" />
        <lightning:button class="slds-m-top_small" variant="brand" onclick="{!c.closeModel}" label="cancel"/>

    </lightning:recordEditForm>
              </p>
          </div>
        </div>
      </div>
      <div class="slds-backdrop slds-backdrop--open"></div>
     </aura:renderIf>
    </aura:renderIf>
</aura:component>



//accountsDisplayController..js
({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.accounts",response.getReturnValue());
            }
            
        })
        $A.enqueueAction(action);
	},
    handleClick: function(component,event,helper){
        var get = event.target.id;
        var getevent = component.getEvent("message");
        getevent.setParams({
            'sendId' : get,
            'bool'   : true
        });
        getevent.fire();
       // component.set("v.visible",false);
    },

    Edit: function(component,event,helper){
     var editRec = component.set("v.edit",true);
     component.set("v.viewedit",event.target.id);
    // component.set("v.accounts",event.target.id);
     
    },
    saveRecord: function(component,event,helper){
      
       component.find("edit").get("e.recordSave").fire();
        location.reload();
        component.set("v.edit",false);
    },
    closeModel: function(component,event,helper){
        component.set("v.edit",false);
    },
    Del: function(component,event,helper){
        if(confirm('Are you sure?')){
             var action = component.get("c.delteAccountById");
        action.setParams({accid:event.target.id});
        action.setCallback(this, function(response) {
        	component.set("v.accounts",response.getReturnValue());
        });
        $A.enqueueAction(action);
        }
    }
    
})




//accountsDisplay2.cmp
<aura:component implements="flexipage:availableForRecordHome,force:hasRecordId" access="global" >
    <aura:handler name="message" event="c:LightningEvent" action="{!c.handleComponentEvent}"/>
    <aura:attribute name="getrecord" type="Id"/>
    <aura:attribute name="edit2" type="boolean"/>
    <aura:attribute name="edit3" type="boolean"/>
		<c:accountsDisplay />       
    <force:recordView aura:id="edit" recordId="{!v.getrecord}"/>    
</aura:component>





//accountsDisplay2Controller.js
({
	handleComponentEvent : function(component, event, helper) {
        var receiveinfo = event.getParam("sendId");
                var receivebool = event.getParam("bool");
        		//component.set("v.edit2",true);
        component.set("v.edit3",receivebool);
        component.set("v.getrecord",receiveinfo);
	},
    goback : function(component, event, helper){
        component.set("v.edit3",false);
        component.set("v.edit2",true);

    }
})




//accountsDisplay.apxc

public class accountsDisplay {
@AuraEnabled
    public static list<account> getAccounts(){
        list<account> acc =[select Name, Phone, Industry, Rating, Type FROM Account ORDER BY CREATEDDATE DESC LIMIT 10];
            return acc;
    } 
    @AuraEnabled
    public static list<contact> getContacts(String name){
        list<contact> con =[Select Email, Phone, MobilePhone FROM Contact WHERE Account.Name =:name];
            return con;
    }
     @Auraenabled
    public static List<Account> delteAccountById(String accid)
    {
        System.debug('In controller delteAccountById method..');
        Account delAccount=[Select Id from Account where id=:accid];
        delete delAccount;
        return [Select ID, Name, Phone, Industry, Rating, Type from Account ORDER BY CREATEDDATE DESC LIMIT 10];
    }
}