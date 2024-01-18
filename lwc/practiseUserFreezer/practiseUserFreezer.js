import { LightningElement,api,track } from 'lwc';
import getResults from '@salesforce/apex/PracticeUserFreezeApex.getResults';
import validate from "@salesforce/apex/freezeUserApexClass.validate";
import freezeUnfreeze from "@salesforce/apex/freezeUserApexClass.freezeUnfreeze";
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ;

const columns=[];

const  UserProfileTable = [
    { label: 'Profile', fieldName: 'profileName' },
    { label: 'Active User Count', fieldName: 'usrcount' }

];
export default class practiceUserFreezer extends LightningElement {

    @api objectName = 'Profile';
    @api fieldName = 'Name';
    @api Label;
    @track searchRecords = [];
    @track selectedRecords = [];
    @api required = false;
    //@api iconName = 'utility:profile'
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    draftValues=[];
    columns = columns; 
    showuserDataTable = false
    showfreezeButton = false
    showvalidateButton= true

    searchField(event) {
        this.showvalidateButton= true
        this.showfreezeButton = false

        var currentText = event.target.value;
        var selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            selectRecId.push(this.selectedRecords[i].recId);
        }
       
       
        this.LoadingText = true;
        getResults({ ObjectName: this.objectName, fieldName: this.fieldName, value: currentText, selectedRecId : selectRecId })
        .then(result => {
            this.searchRecords= result;
            this.LoadingText = false;
            
            this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if(currentText.length > 0 && result.length == 0) {
                this.messageFlag = true;
            }
            else {
                this.messageFlag = false;
            }

            if(this.selectRecordId != null && this.selectRecordId.length > 0) {
                this.iconFlag = false;
                this.clearIconFlag = true;
            }
            else {
                this.iconFlag = true;
                this.clearIconFlag = false;
            }
        })
        .catch(error => {
            console.log('-------error-------------'+error);
            console.log(error);
        });
        
    }
    
    profileRecordsId
    profileName

   setSelectedRecord(event) {
        var recId = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        let newsObject = {'recId' : recId ,'recName' : selectName };
        
        this.profileName = selectName;
        console.log('Name = => '+this.profileName);
        this.selectedRecords.push(newsObject);
        
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        let selRecords = this.selectedRecords;
		this.template.querySelectorAll('lightning-input').forEach(each => {
            each.value = '';
        });
        const selectedEvent = new CustomEvent('selected', { detail: {selRecords}, });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        let recordsSets = new Set();

            // getting selected record id
            for (let i = 0; i < this.selectedRecords.length; i++) {
                recordsSets.add(this.selectedRecords[i].recId);
            }
            console.log('recordsSets ='+recordsSets);
        this.profileRecordsId = Array.from(recordsSets);
    }

    removeRecord (event){
        this.showvalidateButton= true
        this.showfreezeButton = false
        this.showuserDataTable = false

        let selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            if(event.detail.name !== this.selectedRecords[i].recId)
                selectRecId.push(this.selectedRecords[i]);
        }
        this.selectedRecords = [...selectRecId];
        let selRecords = this.selectedRecords;
        const selectedEvent = new CustomEvent('selected', { detail: {selRecords}, });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        let recordsSets = new Set();

            // getting selected record id
            for (let i = 0; i < this.selectedRecords.length; i++) {
                recordsSets.add(this.selectedRecords[i].recId);
            }
            console.log('recordsSets ='+recordsSets);
        this.profileRecordsId = Array.from(recordsSets);

        console.log('Selected profileRecordsId ==='+this.profileRecordsId);
        
    }



    @api flagFreeze 
    @api message
 


    validateHandler(){
        if(this.profileRecordsId != null){
                    validate({profileId : this.profileRecordsId})
                            .then( (result) => {
                                this.result = result;
                                this.error = undefined
                                this.showuserDataTable = true
                                console.log(this.result );
                                
                                this.userList=result;
                               
                                this.showvalidateButton= false
                                this.showfreezeButton = true
                    })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                            console.log(this.error);
                    })
                    this.columns = UserProfileTable;
            }
            else{
                this.showErrorToast1();
            }
        }

           

            userList=[];

    freezeHandler(){
        console.log('In freezeHandler profileName ='+this.profileRecordsId);
        this.flagFreeze = true;
        this.message='Freezing Users Complete.'

        if( this.profileName == 'System Administrator'){
          this.showErrorToast();
        }
        else{
                freezeUnfreeze({profileId : this.profileRecordsId, freeze:this.flagFreeze})
                                                        .then( (result) => {
                                                            this.result = result;
                                                            this.error = undefined
                                                            console.log(this.result );
                                                            this.showfreezeUnfreezeMsg(this.message);
                                                            
                                                })
                                                        .catch( (error) => {
                                                        this.result = undefined;
                                                        this.error = error;
                                                        console.log(this.error);
                                                })
            }
 }

    unfreezeHandler(){
        console.log('In unfreezeHandler profileName ='+this.profileRecordsId);
       this.flagFreeze =false;
        this.message='UnFreezing Users Complete.'
        freezeUnfreeze({profileId : this.profileRecordsId, freeze:this.flagFreeze })
                                                .then( (result) => {
                                                    this.result = result;
                                                    this.error = undefined
                                                    // this.UserProfileTable=result;
                                                    console.log(this.result );
                                                    this.showfreezeUnfreezeMsg(this.message);
                                        })
                                                .catch( (error) => {
                                                this.result = undefined;
                                                this.error = error;
                                                console.log(this.error);
                                        })

    }

    showfreezeUnfreezeMsg(message) {
        const evt = new ShowToastEvent({
                                          title: 'Message',
                                          message: message,
                                          variant: 'success',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                         }

    showErrorToast() {
        const evt = new ShowToastEvent({
                                        title: 'Toast Error',
                                        message: 'We can not freeze the System Administrator Profile',
                                        variant: 'error',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
                        }       
    showErrorToast1() {
        const evt = new ShowToastEvent({
                                        title: 'Toast Error',
                                        message: 'Select atleast one Profile',
                                        variant: 'error',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
                        }                                 
}