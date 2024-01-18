import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import closeCTask from '@salesforce/apex/ServiceNow.closeCTask';
export default class closeCTaskcomp extends LightningElement {

    @api recordId;
    result 

    @api async invoke() {
        let params ={
            "ctid" : this.recordId
        };
        await closeCTask(params)
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