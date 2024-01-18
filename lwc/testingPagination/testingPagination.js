import { LightningElement, wire } from 'lwc';
import retrieveAccounts from '@salesforce/apex/DataController.retrieveAccounts';
import getsObjectRecord from '@salesforce/apex/DataController.getsObjectRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Type', fieldName: 'Type' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'BillingCountry', fieldName: 'BillingCountry' },
];

const  columnsRecordCleanup1 = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate'},
    { label: 'Status', fieldName: 'copado__Status__c'},
];

export default class TestingPagination extends LightningElement {
    page = 1; //initialize 1st page
    recordsToDisplay1Data =[];
    allRecordListItem = [];
    columns; //holds column info.
    columnsRecordCleanup1;
    startingRecord = 1; //start record position per page
    endingRecord = 0; //end record position per page
    pageSize = 10; //default value we are assigning
    totalRecountCount = 0; //total record count received from all retrieved records
    totalPage = 0; //total number of page is needed to display all records
    selectedRowsArch = [];
    pageSizeOptions1 = [10, 25, 50, 75, 100];
    selectedRecountCount = 0;

    handleNextScreen3(){
        getsObjectRecord({})
                .then( (result) => {
                    this.allRecordListItem = result;
                    this.totalRecountCount = result.length;
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                    //here we slice the data according page size
                    this.recordsToDisplay1Data = this.allRecordListItem.slice(0, this.pageSize);
                    this.endingRecord = this.pageSize;
                    this.pageSize= this.pageSizeOptions1[0]; //set pageSize with default value as first option
                    this.columnsRecordCleanup1=columnsRecordCleanup1;
                    this.error = undefined
                })
                .catch( (error) => {
                this.result = undefined;
                this.error = error;
                console.log(this.error);
                })
    }

     handleRecordsPerPage1(event) {
          this.pageSize = event.target.value;
          console.log('this.pageSize'+this.pageSize);
          this.displayRecordPerPage(this.page);
      }

    firstHandler() {
            this.page = 1;
            this.displayRecordPerPage(this.page);
    }

    //press on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    //press on next button this method will be called
    nextHandler() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }


    lastHandler() {
            this.page = this.totalPage ;
            this.displayRecordPerPage(this.page);
    }

    //this method displays records page by page
    displayRecordPerPage(page) {

        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount)
            ? this.totalRecountCount : this.endingRecord;

        this.recordsToDisplay1Data = this.allRecordListItem.slice(this.startingRecord, this.endingRecord);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRowsArch;
    }

    handleRowSelection(event) {
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRowsArch);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();

        this.recordsToDisplay1Data.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });

        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });

            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }

        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });

        this.selectedRowsArch = [...selectedItemsSet];
        console.log('selectedRows==> ' + JSON.stringify(this.selectedRowsArch));
        this.selectedRecountCount = this.selectedRowsArch.length;
        console.log('length==='+this.selectedRowsArch.length);
    }

    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }



    /* pageArch = 1; //initialize 1st page
    recordsToDisplayArchData =[];
    sObjectRecordarchivedList = [];
    columns; //holds column info.
    columnsq;
    startingRecordArch = 1; //start record position per page
    endingRecordArch = 0; //end record position per page
    pageSizeArch = 10; //default value we are assigning
    totalRecountCountArch = 0; //total record count received from all retrieved records
    totalPageArch = 0; //total number of page is needed to display all records
    selectedRows = [];
    pageSizeOptionsArch = [10, 25, 50, 75, 100];
    selectedRecountCountArch = 0;

    handleNextScreen3(){
        getsObjectRecord({})
                .then( (result) => {
                    this.sObjectRecordarchivedList = result;
                    this.totalRecountCountArch = result.length;
                    this.totalPageArch = Math.ceil(this.totalRecountCountArch / this.pageSizeArch);
                    //here we slice the data according page size
                    this.recordsToDisplayArchData = this.sObjectRecordarchivedList.slice(0, this.pageSizeArch);
                    this.endingRecordArch = this.pageSizeArch;
                    this.pageSizeArch= this.pageSizeOptionsArch[0]; //set pageSize with default value as first option
                    this.columnsq=columnsRecordCleanup1;
                    this.error = undefined
                })
                .catch( (error) => {
                this.result = undefined;
                this.error = error;
                console.log(this.error);
                })
    }

     handleRecordsPerPageArch(event) {
          this.pageSizeArch = event.target.value;
          console.log('this.pageSize'+this.pageSizeArch);
          this.displayRecordPerPageArch(this.pageArch);
      }

    firstHandlerArch() {
            this.pageArch = 1;
            this.displayRecordPerPageArch(this.pageArch);
    }

    //press on previous button this method will be called
    previousHandlerArch() {
        if (this.pageArch > 1) {
            this.pageArch = this.pageArch - 1;
            this.displayRecordPerPageArch(this.pageArch);
        }
    }

    //press on next button this method will be called
    nextHandlerArch() {
        if ((this.pageArch < this.totalPageArch) && this.pageArch !== this.totalPageArch) {
            this.pageArch = this.pageArch + 1;
            this.displayRecordPerPageArch(this.pageArch);
        }
    }


    lastHandlerArch() {
            this.pageArch = this.totalPageArch ;
            this.displayRecordPerPageArch(this.pageArch);
    }

    //this method displays records page by page
    displayRecordPerPageArch(pageArch) {

        this.startingRecordArch = ((pageArch - 1) * this.pageSizeArch);
        this.endingRecordArch = (this.pageSizeArch * pageArch);

        this.endingRecordArch = (this.endingRecordArch > this.totalRecountCountArch)
            ? this.totalRecountCountArch : this.endingRecordArch;

        this.recordsToDisplayArchData = this.sObjectRecordarchivedList.slice(this.startingRecordArch, this.endingRecordArch);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecordArch = this.startingRecordArch + 1;
        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }*/
}