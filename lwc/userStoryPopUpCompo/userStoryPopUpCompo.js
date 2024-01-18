import { LightningElement,api} from 'lwc';
import getsObjectRecord from "@salesforce/apex/CentralClass.getsObjectRecord";
import sObjectRecordDeleted from "@salesforce/apex/CentralClass.sObjectRecordDeleted";
import sObjectRecordHardDeleted from "@salesforce/apex/CentralClass.sObjectRecordHardDeleted";

import { ShowToastEvent } from 'lightning/platformShowToastEvent' ; 

const columns=[];

const  columns1 = [
    { label: 'Name', fieldName: 'Name', editable: true },
    { label: 'Created By', fieldName: '	CreatedBy', editable: true },
    { label: 'Last Modified By', fieldName: 'LastModifiedBy', editable: true },
    { label: 'Created Date', fieldName: 'CreatedDate', editable: true },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', editable: true },
  ];


  const  columns2 = [
    { label: 'Name', fieldName: 'Name', editable: false },
    { label: 'Created By', fieldName: '	CreatedBy', editable: false },
    { label: 'Last Modified By', fieldName: 'LastModifiedBy', editable: false },
    { label: 'Created Date', fieldName: 'CreatedDate', editable: false },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', editable: false },
  ];



  

export default class UserStoryPopUpCompo extends LightningElement {


   @api sObjectRecordList
   
    sObjectSelectedRecordList 
   
    
    draftValues=[];
    columns = columns;
   
    
    selectedRecords
    selectedRecordsCount
    result
    error
    months=0
    totalRecords
    

    
    showScheduledFlag=false

    showSpinnerFlag = false

    selectedPopup = false

    selectedRecordsId

    @api objectReceived

    userStoryPopupHandler(){ 
          
            const myEvent = new CustomEvent("userstorypopupevent",{detail:false});
            this.dispatchEvent(myEvent);
        }
    
        
    selectedRecordsHandler(event){
            const selectedRows  =   event.detail.selectedRows;
            console.log("Selected Rows = "+selectedRows)
            this.selectedRecordsCount = event.detail.selectedRows.length;

            this.selectedRecords = selectedRows;
            console.log("selectedRecords = "+this.selectedRecords);
    
            let recordsSets = new Set();
    
            // getting selected record id
            for (let i = 0; i < selectedRows.length; i++) {
                recordsSets.add(selectedRows[i].Id);
            }
    
            // coverting to array

            this.selectedRecordsId = Array.from(recordsSets);

           
            
    }

    show3MonthButton=true
    show6MonthButton = true

    show3MonthBrandButton = false
    show6MonthBrandButton = false
    

      threeMonthHandler(){

        this.show3MonthButton = false;
        this.show3MonthBrandButton = true;
 
        this.show6MonthBrandButton = false;
        this.show6MonthButton = true;
 
 
               this.months=3 
                console.log('Months= '+this.months);
                console.log('Object Name ='+this.objectReceived);
                this.showSpinnerFlag = true;

            
if(this.show3MonthBrandButton = true){
                getsObjectRecord({months:this.months, objectName:this.objectReceived })
                                    .then( (result) => {
                                        this.showSpinnerFlag = false
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.sObjectRecordList = result;
                                        this.totalRecords = result.length;

                                    })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
                                })
                                this.columns=columns1;    
}
      }

threeMonthBrandHandler(){

    this.show3MonthBrandButton = false;
    this.show3MonthButton = true;
    this.show6MonthBrandButton = false;
    this.show6MonthButton = true;


    this.months=3 
    console.log('Months= '+this.months);
    console.log('Object Name ='+this.objectReceived);
    this.showSpinnerFlag = true;



    getsObjectRecord({months:this.months, objectName:this.objectReceived })
                        .then( (result) => {
                            this.showSpinnerFlag = false
                            this.result = result;
                            this.error = undefined
                            console.log(this.result );
                            this.sObjectRecordList = result;
                            this.totalRecords = result.length;

                        })
                        .catch( (error) => {
                        this.result = undefined;
                        this.error = error;
                        console.log(this.error);
                    })
                    this.columns=columns1;  
}

sixMonthHandler(){


    this.show6MonthButton = false;
    this.show3MonthBrandButton = false;
    this.show3MonthButton = true;
   this.show6MonthBrandButton = true;


     this.months=6
        console.log('Months= '+this.months);
        this.showSpinnerFlag = true

        getsObjectRecord({months:this.months,objectName:this.objectReceived })
                            .then( (result) => {
                                this.showSpinnerFlag = false
                                this.result = result;
                                this.error = undefined
                                console.log(this.result );
                                this.sObjectRecordList = result;
                                this.totalRecords = result.length;
                            })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                            console.log(this.error);
                        })
                        this.columns=columns1;
}


sixMonthBrandHandler(){

    this.show3MonthBrandButton = false;
    this.show3MonthButton =true;

        
    this.show6MonthBrandButton = false;
    this.show6MonthButton = true;
   
    
   
    this.months=6
    console.log('Months= '+this.months);
    this.showSpinnerFlag = true

    getsObjectRecord({months:this.months,objectName:this.objectReceived })
                        .then( (result) => {
                            this.showSpinnerFlag = false
                            this.result = result;
                            this.error = undefined
                            console.log(this.result );
                            this.sObjectRecordList = result;
                            this.totalRecords = result.length;
                        })
                        .catch( (error) => {
                        this.result = undefined;
                        this.error = error;
                        console.log(this.error);
                    })
                    this.columns=columns1;


}


selectedHandler(){
    if(this.selectedRecordsId != null ){
                this.selectedPopup = true;

                this.sObjectSelectedRecordList = this.selectedRecordsId;

                console.log('** ='+this.sObjectSelectedRecordList);

                this.totalselectedRecords = this.sObjectSelectedRecordList.length;

                this.columns=columns2;
    }

    else{
        this.showErrorToast2();
    }
}


    deleteHandler(){
        console.log('I m in delete');
        console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
        console.log('objectReceived'+this.objectReceived);

       let text;
       if (confirm("Do you really want to delete that record ?") == true) {
         
        sObjectRecordDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectReceived})
                               .then((result) => {
                               this.result = result;
                               this.error = undefined;
                               this.showSuccessToast();
                            
                               this.selectedPopup = false;
                               this.getRefeshData()
                               this.totalRecords = result.length;
                           })
                           .catch((error) => {
                                console.log(error)
                                this.error = error;
                                this.result = undefined;
                             
                                this.showErrorToast();
                           });
       
       } else {
         text = "You cancelled!";
       }

   }


   deleteAllHandler(){
    console.log('I m in delete');
    console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
    console.log('objectReceived'+this.objectReceived);

   let text;
   if (confirm("Do you really want to delete that record ?") == true){
     
    sObjectRecordHardDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectReceived})
                           .then((result) => {
                           this.result = result;
                           this.error = undefined;
                           this.showSuccessToast();
                          
                           this.selectedPopup = false;
                           this.getRefeshData()
                           this.totalRecords = result.length;
                       })
                       .catch((error) => {
                            console.log(error)
                            this.error = error;
                            this.result = undefined;
                           
                            this.showErrorToast();
                       });
   
   } else {
     text = "You cancelled!";
   }

}


   getRefeshData(){ 
 
    getsObjectRecord({months:this.months,objectName:this.objectReceived})
                    .then((result) => {

                        console.log(result)
                        this.sObjectRecordList = result       
                        this.error = undefined;
                        this.totalRecords = result.length;

                    })
                    .catch((error) => {
                        console.log(error)
                        this.error = error;
                        this.result = undefined;
                    });

}



   showSuccessToast() {
    const evt = new ShowToastEvent({
                                        title: 'Message',
                                        message: this.result,
                                        variant: 'success',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
}

showErrorToast() {
    const evt = new ShowToastEvent({
                                      title: 'Toast Error',
                                      message: this.error,
                                      variant: 'error',
                                      mode: 'dismissable'
                                  });
                                  this.dispatchEvent(evt);
                              }


 showErrorToast2() {
                                const evt = new ShowToastEvent({
                                                                  title: 'Toast Error',
                                                                  message: 'Please select some Records...!!!',
                                                                  variant: 'error',
                                                                  mode: 'dismissable'
                                                              });
                                                              this.dispatchEvent(evt);
                                                          }
    


        ScheduledJobHandler(){
            console.log('I am in scheduled');
            
            this.showScheduledFlag=true;

        }


        scheduleclosePopupHandler(event){
            this.showScheduledFlag=event.detail
        
        }

        ClosePopupHandler(){
            this.selectedPopup = false;
        }
}