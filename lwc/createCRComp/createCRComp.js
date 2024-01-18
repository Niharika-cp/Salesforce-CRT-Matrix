import { LightningElement,api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import createCr from '@salesforce/apex/ServiceNow.createCR';
export default class CreateCRComp extends LightningElement {

    @api recordId;
    result 

    @api async invoke() {
        let params ={
            "crid" : this.recordId
        };
        await createCr(params)
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Success',
                    variant: 'success',
                }),
            );
            location.reload();
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