import { LightningElement, track,wire,api} from 'lwc';

import { refreshApex } from '@salesforce/apex';

import calculateCoverage from '@salesforce/apex/DTestCoverageDataForLWC.calculateCoverage';
import searchKey from '@salesforce/apex/DTestCoverageDataForLWC.searchKey';



const columns = [    
    { label: 'ApexClassOrTrigger', fieldName: 'name',type:'text',cellAttributes: { alignment: 'left' } },    
    { label: 'ApexTestClass', fieldName: 'testNam',type:'text',cellAttributes: { alignment: 'left' } },  
    { label: 'TestMethod', fieldName: 'testmth', type: 'text' }, 
     { label: 'Covered Lines', fieldName: 'numCov',type:'Number',cellAttributes: { alignment: 'center' } },    
     { label: 'Uncovered Lines', fieldName: 'numUncov',type:'Numbert',cellAttributes: { alignment: 'center' } },
     { label: 'Coverage', fieldName: 'covPer',type:'percent', cellAttributes: { alignment: 'center' }}];

export default class TestCoverage extends LightningElement {

    @track loader = false;
    @track isModalOpen = false;
    @track value;
    @track error;
    @track data;
    @api sortedDirection = 'asc';
    @api sortedBy = 'Name';
    @api searchKey = '';
    result;
    @track allSelectedRows = [];
    @track page = 1;
    @track items = [];
    @track data =[] ;
    @track columns;f
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = '25';
    @track totalRecountCount = 0;
    @track totalPage = 0;
    isPageChanged = false;
    initialLoad = true;
    mapAccount = new Map();
    @track coverageData =[];
    selectedAccounts
    draftValues=[];
    columns = columns;
    selectedRecordsId
    selectedRecords =[];

    get options() {
        return [
            { label: '25', value: '25' },
            { label: '50', value: '50' },
            { label: '100', value: '100' },
        ];
    }

    handleChange(event) {
        this.pageSize = event.detail.value;
        this.processRecords(this.items);
    }

    @wire(calculateCoverage, {})
    wiredApexClasses({ error, data }) {
        console.log( 'working fetchApexClasses in JS');
        this.loader = true;
        if (data) {
            this.loader = false;
            this.processRecords(data);
            this.error = undefined;
        } else if (error) {
            this.loader = false;
            this.error = error;
            this.data = undefined;
        }
    }

    handleKeyChange(event) {
        
        this.searchKey = event.target.value;
        console.log('searchKey ='+this.searchKey);

        this.loader = true
        if(this.searchKey != null){
        searchKey({searchKey: this.searchKey})
                        .then( (result) => {
                            this.loader = false
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
        

    processRecords(data) {
        this.items = data;
        this.totalRecountCount = data.length;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        this.data = this.items.slice(0, this.pageSize);
        this.endingRecord = this.pageSize;
        this.columns = columns;
    }

    //clicking on previous button this method will be called
    previousHandler() {
        this.isPageChanged = true;
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
        var selectedIds = [];
        for (var i = 0; i < this.allSelectedRows.length; i++) {
            selectedIds.push(this.allSelectedRows[i].Id);
        }
        this.template.querySelector('[data-id="table"]').selectedRows = selectedIds;
    }

    //clicking on next button this method will be called
    nextHandler() {
        this.isPageChanged = true;
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }
        var selectedIds = [];
        for (var i = 0; i < this.allSelectedRows.length; i++) {
            selectedIds.push(this.allSelectedRows[i].Id);
        }
        this.template.querySelector('[data-id="table"]').selectedRows = selectedIds;
    }

    //Method to displays records page by page
    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) ? this.totalRecountCount : this.endingRecord;
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }

    sortColumns(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        return refreshApex(this.result);
    }
  
    
    

    selectedRecordsHandler(event){
       const  selectedRows  =   event.detail.selectedRows;
        console.log("Selected Rows = "+ JSON.stringify(selectedRows))
       // this.selectedRecordsCount = event.detail.selectedRows.length;

       this.selectedRecords = selectedRows;
  
        let recordsSets = new Set();
  
        // getting selected record id
        for (let i = 0; i < this.selectedRecords.length; i++) {
            recordsSets.add(this.selectedRecords[i]);
        }
        // coverting to array
        this.selectedRecordsId = Array.from(recordsSets);
        console.log('selectedRecords Id ==='+this.selectedRecordsId);
      }


    showSelectedAccounts() {

        if (this.selectedRecordsId != null && this.selectedRecordsId.length > 0) {            
            this.isModalOpen = true;
        }
        else {
            alert('Please select apex classes..!!');
        }
    }

    closeModal() {
        this.isModalOpen = false;
    }

    
}