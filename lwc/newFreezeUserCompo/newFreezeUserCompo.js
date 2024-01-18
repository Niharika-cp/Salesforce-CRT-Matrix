import { LightningElement,track,wire,api } from 'lwc';
import FetchActiveProfiles from '@salesforce/apex/newFreezeUserApxClass.FetchActiveProfiles';
import FetchAllUser from '@salesforce/apex/newFreezeUserApxClass.FetchAllUser';
import getResults from '@salesforce/apex/PracticeUserFreezeApex.getResults';
import validate from "@salesforce/apex/freezeUserApexClass.validate";
import freezeUnfreeze from "@salesforce/apex/freezeUserApexClass.freezeUnfreeze";
import searchKey from "@salesforce/apex/newFreezeUserApxClass.searchKey";
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ;

const columns=[];

const columns1 = [
    { label: 'Profile Name', fieldName: 'Name' },
];

const columns2 = [
    { label: 'User Name', fieldName: 'Name' },
];
const  UserProfileTable = [
    { label: 'Profile', fieldName: 'profileName' },
    { label: 'Active User Count', fieldName: 'usrcount' }

];
export default class NewFreezeUserCompo extends LightningElement {

    @track profileList;
    @track allUserList;
    @track columns
    draftValues=[];
    columns = columns;
    columns1;
    columns2;
    UserProfileTable;
    @api searchKey = '';
    result;
    showActiveUserCountPopup = false
    selectedRecordsProfile 
    selectedRecordsUser
    
    @api objectName = 'User';
    @api fieldName = 'Name';
    @track searchRecords = [];
    @track selectedRecords = [];
    @api required = false;
    //@api iconName = 'utility:profile'
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    profileRecordsId
    userRecordsId
    profileName
    userName

    userList=[];
    showFreezeButtton = false
    showUnFreezeButtton = false
     disableUserDataTableFlag= true
     disableprofileDataTableFlag = true
     
     @track data = [];
     @track items = [];
     @track totalRecountCount = 0;
     @track totalPage = 0;
     @track pageSize ;
     @track endingRecord = 0; 

   
         @wire(FetchAllUser, {})
         wiredApexClasses({ error, data }) {
                 console.log( 'working fetchApexClasses in JS');
                 this.loader = true;
                 if (data) {
                     this.loader = false;
                     this.processRecords(data);
                     this.columns2 =columns2;
                     this.error = undefined;
                    
                 } else if (error) {
                     this.loader = false;
                     this.error = error;
                     this.data = undefined;
                 }
     }


     processRecords(data){
             this.items = data;
            this.totalRecountCount = data.length; 
             this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
             
             this.data = this.items.slice(0,this.pageSize); 
             this.endingRecord = this.pageSize;
             this.columns2 = columns2;
     }


     handleKeyChange( event ) {
         this.searchKey = event.target.value;
         console.log('searchKey ='+this.searchKey);
 
         this.loader = true
         if(this.searchKey != null){
         searchKey({searchKey: this.searchKey})
                         .then( (result) => {
                             this.loader = false
                             this.columns2 =columns2;
                             this.processRecords(result);
                             this.error = undefined
                             console.log(this.result );
                            
                         })
                         .catch( (error) => {
                         this.result = undefined;
                         this.error = error;
                         console.log(this.error);
                     })
                 }            
     }


        connectedCallback(){
            FetchActiveProfiles()
            .then(result => {
                this.profileList = result;
                this.columns1 = columns1
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
            });
        }    

    /*    @wire (FetchAllUser) wiredUser1({data,error}){
            if (data) {
                this.allUserList = data;
                this.columns2 = columns2
            console.log(data); 
            } else if (error) {
            console.log(error);
            }
        }*/

   
    validateHandler(){
        
        if(this.profileRecordsId != null){
                    validate({profileId : this.profileRecordsId})
                            .then( (result) => {
                                this.showActiveUserCountPopup = true
                                this.result = result;
                                this.error = undefined
                                console.log(this.result );
                                this.userList=result;
                                this.showvalidateButton= false
                                this.showfreezeButton = true
                                this.UserProfileTable = UserProfileTable;
                    })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                            console.log(this.error);
                    })
                    
            }
            else{
                this.showErrorToast1();
            }
        }
    
        freezeHandler(){
            console.log('In freezeHandler profileName ='+this.profileRecordsId);
           
            this.flagFreeze = true;
            this.message='Freezing Users Complete.'
    
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
         
        showErrorToast1() {
            const evt = new ShowToastEvent({
                                            title: 'Toast Error',
                                            message: 'Select atleast one Profile',
                                            variant: 'error',
                                            mode: 'dismissable'
                                        });
                                        this.dispatchEvent(evt);
                            }                                 
   
        ClosePopupHandler(){
            this.showActiveUserCountPopup = false
        }


        selectedRecordsHandler(event){

            const selectedRows  =   event.detail.selectedRows;
            console.log("Selected Rows = "+selectedRows)
            this.selectedRecordsCount = event.detail.selectedRows.length;
    
            this.selectedRecordsProfile = selectedRows;
            console.log("selectedRecords = "+this.selectedRecordsProfile);
    
            let recordsSets = new Set();
    
            // getting selected record id
            for (let i = 0; i < selectedRows.length; i++) {
                recordsSets.add(selectedRows[i].Id);
            }
    
            // coverting to array
    
            this.profileRecordsId = Array.from(recordsSets);
    
            console.log('this.profileRecordsId=='+this.profileRecordsId);
           
            this.disableUserDataTableFlag= true
            this.disableprofileDataTableFlag= false
    }


        selectedRecordsHandler2(event){
            
                const selectedRows  =   event.detail.selectedRows;
                console.log("Selected Rows = "+selectedRows);
                console.log('selectedRows===='+JSON.stringify(selectedRows));
               // this.selectedRecordsCount = event.detail.selectedRows.length;
        
                this.selectedRecordsUser = selectedRows;
                console.log("selectedRecords user= "+this.selectedRecordsUser);
        
                let recordsSets = new Set();
        
                // getting selected record id
                for (let i = 0; i < selectedRows.length; i++) {
                    recordsSets.add(selectedRows[i].Id);
                }
        
                // coverting to array
        
                this.userRecordsId = Array.from(recordsSets);
        
                console.log('this.profileRecordsId=='+this.userRecordsId);
               
                this.disableprofileDataTableFlag= true
                this.disableUserDataTableFlag= false
        }


       
}