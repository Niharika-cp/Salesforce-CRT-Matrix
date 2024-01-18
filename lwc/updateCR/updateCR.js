import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import updateCR from '@salesforce/apex/ServiceNow.updateCR';
export default class UpdateCR extends LightningElement {

    @api recordId;
    result 

    @api async invoke() {
        let params ={
            "crid" : this.recordId
        };
        await updateCR(params)
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Succcess',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Failed',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }
}