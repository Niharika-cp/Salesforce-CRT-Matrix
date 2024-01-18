import { LightningElement, track } from 'lwc';
import createCR from '@salesforce/apex/ServiceNow.createCR';

export default class RecordIdPasser extends LightningElement {
    @track recordId = '';

    handleRecordIdChange(event) {
        this.recordId = event.target.value;
    }

    createCR() {
        if (this.recordId) {
            createCR({ recordId: this.recordId })
                .then(result => {
                    // Handle the result if needed
                })
                .catch(error => {
                    // Handle the error if needed
                });
        }
    }
}