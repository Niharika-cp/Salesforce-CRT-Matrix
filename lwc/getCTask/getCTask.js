import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getCTask from '@salesforce/apex/ServiceNow.getCTask';
export default class GetCTask extends LightningElement {

    @api recordId;
    result 

    @api async invoke() {
        let params ={
            "crid" : this.recordId
        };
        await getCTask(params)
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Succcess',
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