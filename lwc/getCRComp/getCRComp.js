import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getCr from '@salesforce/apex/ServiceNow.getCR';
export default class GetCRComp extends LightningElement {

    @api recordId;
    result 

    @api async invoke() {
        let params ={
            "crid" : this.recordId
        };
        await getCr(params)
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