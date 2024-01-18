import { LightningElement,wire,track } from 'lwc';
import matrix from '@salesforce/apex/SharedComponentMatrixClass.matrix'
const columns = [
    { label: 'Metadata Name', fieldName: 'component'},
    { label: 'Type', fieldName: 'typer' },
    { label: 'User Story', fieldName: 'userstory' },
    { label: 'Source Org', fieldName: 'source' },
    { label: 'Owner', fieldName: 'owner' }
];
export default class CheckingMetadata extends LightningElement {4
    @track piwis = [];
    @wire(matrix)
    matrix({ error, data }) {
        if (data) {
            this.piwis = data;
        } else if (error) {
            console.error(error);
        }
    }
}