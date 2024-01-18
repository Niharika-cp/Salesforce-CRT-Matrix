import { LightningElement ,wire,track} from 'lwc';
import repo from '@salesforce/apex/BranchesExcluded.repo';
import branchesExcluded from '@salesforce/apex/BranchesExcluded.branchesExcluded';
import { refreshApex } from '@salesforce/apex';
export default class Repository extends LightningElement {
    @track varOptions=[];   //display available repositories
    @track selectedRepositoryId;  //stores selected repository Id
    @track duelPicklist; 
    @track error;
    @track _varResult;
    @track _selected;
    @wire(repo) 
    gitRepositories({ error, data }){
         if(data){
              let optionslist=[];
              data.forEach(element => {
                    optionslist.push({value:element.Id,label:element.Name})
              });
              console.log(optionslist);
              this.varOptions=optionslist;
         }
    }
    handleChange(event){
           this.selectedRepositoryId = event.detail.value;
           console.log(`selectedRepository is ${this.selectedRepositoryId}`);
    }
    branchhandler(){
        branchesExcluded({repo:this.selectedRepositoryId})
            .then(result => {
                console.log(`result ${result}`)
                this._varResult=result;
                console.log(`this.varResult is ${this._varResult}`)
                if(result){
                    
                    let opt=[];
                    result.forEach(branch=>{
                          opt.push(
                            {value:branch.Id,label:branch.Name}
                          )
                          this.duelPicklist = opt;
                          console.log(`duelopt ${this.duelPicklist}`);
                    })
                }
            })
            .catch(error => {
                this.error = error;
                console.log(this.error);
            });
    
 }
 duelhandleChange(event){
    this._selected = event.detail.value;
 }
}