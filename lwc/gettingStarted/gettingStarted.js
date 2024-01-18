import { LightningElement, wire,track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import copado__Status__c from '@salesforce/schema/copado__User_Story__c.copado__Status__c';
import updateValue from '@salesforce/apex/UpdateMdt.updateValue';
import showPreviousValue from '@salesforce/apex/UpdateMdt.showPreviousValue';
import blist from '@salesforce/apex/BranchExclusion.getBranches';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
export default class GettingStarted extends LightningElement {
    @track pickListValues;
    @track varError;
    @track valueSelected;
    @track prevValue;
    @track responseData;
    @wire (getPicklistValues,
        { recordTypeId:'012000000000000AAA',fieldApiName: copado__Status__c})
        wirePickListValues({data,error}){
              if(data){
                console.log(`PicklistValues are`,data.values);
                this.pickListValues=data.values;
                this.varError = undefined;
              }
              else if(error){
                console.log(`error while fetching picklist values ${error}`);
                this.varError=error;
                this.pickListValues=undefined;
              }
        }
   
        @wire(showPreviousValue)
        getMetadata(response){
            this.prevValue = response.data;
            this.valueSelected = response.data;
            this.responseData = response;
        }
        @wire(blist) 
        count2({data}){
        this.bval = data;
            console.log(this.bval)
            console.log(typeof(this.bval))
                this.check = true;    
                this.columns = [
                    { label: 'Repository', fieldName: 'Repository_Name__c' },
                    { label: 'Branch', fieldName: 'copado__Branch__c' }]
            }

    optionChange(event){
        this.valueSelected = event.detail.value;
        this.varMessage = `Changed Values - ${this.valueSelected}`;        
        console.log(`this.prevValue ${this.prevValue}`);
        console.log(`this.valueSelected ${this.valueSelected}`);
    }
    submitHandler(){
        if(this.valueSelected !== ''/* && this.valueSelected != this.prevValue*/){
                    updateValue({valueToUpdate:this.valueSelected})
                    .then(result =>{
                        console.log(result);
                        refreshApex(this.getMetadata);
                        if(result=='varResult'){
                        const event = new ShowToastEvent({
                            title: 'Success',
                            message:'Submitted Successfully' ,
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(event);
                    } 
                    
                    })
                    .catch(error => {
                        console.log(error);
                    });
                }
                    /*else{
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: 'Submission Failed',
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }*/
                    //eval("$A.get('e.force:refreshView').fire();"); 
                    
                }
            }