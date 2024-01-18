import { LightningElement,track,api} from 'lwc';
import LightningConfirm from 'lightning/confirm';
import getuserStoryBranchRecord from "@salesforce/apex/CentralClass.getuserStoryBranchRecord";
import getStepObjectRecordList from "@salesforce/apex/CentralClass.getStepObjectRecordList";
import practiceFeatureMethod from "@salesforce/apex/CentralClass.practiceFeatureMethod";
import practicePromotionRecord from "@salesforce/apex/CentralClass.practicePromotionRecord";
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ; 

const columns=[];

const  columns1 = [
    
    { label: 'User Story Name', fieldName: 'Name', editable: true },
    { label: 'View in Git', fieldName: 'BranchName__c', editable: true },
    { label: 'Project', fieldName: 'copado__Project__c', editable: true },
    { label: 'Release', fieldName: 'copado__Release__c', editable: true },
    { label: 'Enviornment', fieldName: 'copado__Environment__c', editable: true },
  ];

  const  columns12 = [
    
    { label: 'User Story Name', fieldName: 'Name', editable: false },
    { label: 'View in Git', fieldName: 'BranchName__c', editable: false },
    { label: 'Project', fieldName: 'copado__Project__c', editable: false },
    { label: 'Release', fieldName: 'copado__Release__c', editable: false },
    { label: 'Enviornment', fieldName: 'copado__Environment__c', editable: false },
  ];

  const  columns2 = [
    
    { label: 'Promotion Name', fieldName: 'Name', editable: true },
    { label: 'Status', fieldName: 'copado__Status__c', editable: true },
    { label: 'Check Only', fieldName: 'copado__CheckOnly__c', editable: true },
    { label: 'Branch', fieldName: 'copado__Branch__c', editable: true },
    { label: 'Deployment', fieldName: 'copado__Deployment__c', editable: true },
  ];

  const  columns22 = [
    
    { label: 'Promotion Name', fieldName: 'Name', editable: false },
    { label: 'Status', fieldName: 'copado__Status__c', editable: false },
    { label: 'Check Only', fieldName: 'copado__CheckOnly__c', editable: false },
    { label: 'Branch', fieldName: 'copado__Branch__c', editable: false },
    { label: 'Deployment', fieldName: 'copado__Deployment__c', editable: false },
  ];


export default class Practice extends LightningElement {
    value = [];
    
    userStoryValue=false
    userStoryTaskValue=false
    deploymentTaskValue=false
    userStoryCommitsValue=false
    userStoryMetadataValue=false
    userstoryDataCommitsValue=false
    pullRequestValue=false
    staticCodeAnalysisResultsValue=false
    promotedUserStoryValue=false
    deploymentsValue=false
    stepValue=false
    deploymentJobValue=false
    compilanceScanResultValue=false

    showUserStoryPopupFlag=false

    selectedPopup = false
    
    
     objectName = 'copado__User_Story__c'

     result
     error
     
 
     tabContent1 = '';
     tabContent2 = '';
     showScheduledFlag=false
     showBranchScheduledFlag = false
 
    
 
     RecordCleanUpHandler(event){
         console.log('I m in Record');
       
        const tab = event.target;
        this.tabContent1 = `Tab ${event.target.value} is now active`;
     }
 
     BranchCleanUpHandler(event){
         console.log('I m in Branch');
       
 
        const tab = event.target;
        this.tabContent2 = `Tab ${event.target.value} is now active`;
        
     }
 

     objUserStory =  'copado__User_Story__c'
     objUserStoryTask = 'copado__User_Story_Task__c'
     objDeployTask = 'copado__Deployment_Task__c'
     objUSCommit = 'copado__User_Story_Commit__c'
     objUSMetadata =  'copado__User_Story_Metadata__c'
     objUSDataCommit = 'copado__User_Story_Data_Commit__c'
     objPullRequest = 'copado__Pull_Request__c'
     objStaticCode = 'copado__Static_Code_Analysis_Result__c'
     objPromotedUser = 'copado__Promoted_User_Story__c'
     objDeployments =  'copado__Deployment__c'
     objSteps ='copado__Step__c'
     objDeployJob = 'copado__Deployment_Job__c'
     objComplianceScanResult =  'copado__Compliance_Scan_Result__c'

   

    
    get options() {
        return [
            { label: 'Copado User Story', value: 'copado__User_Story__c' },
            { label: 'Copado User Story Task', value: 'copado__User_Story_Task__c' },
            { label: 'Copado Deployment Task', value: 'copado__Deployment_Task__c' },
            { label: 'Copado User Story Commits', value: 'copado__User_Story_Commit__c' },
            { label: 'Copado User Story Metadata', value: 'copado__User_Story_Metadata__c' },
            { label: 'Copado User Story Data Commits', value: 'copado__User_Story_Data_Commit__c' },
            { label: 'Copado Pull Request', value: 'copado__Pull_Request__c' },
            { label: 'Copado Static Code Analysis Results', value: 'copado__Static_Code_Analysis_Result__c' },
            { label: 'Copado Promoted User Story', value: 'copado__Promoted_User_Story__c' },
            { label: 'Copado Deployments', value: 'copado__Deployment__c' },
            { label: 'Copado Step', value: 'copado__Step__c' },
            { label: 'Copado Deployment Job', value: 'copado__Deployment_Job__c' },
            { label: 'Copado Compilance Scan Result', value: 'copado__Compliance_Scan_Result__c' },
        ];
    }

    get selectedValues() {
        return this.value.join(',') 
    }

    
     handleChange(e){
          this.value = e.detail.value;
     }

     ProceedselectedHandler(){
                    if (this.value == 'copado__User_Story__c'){
                        this.userStoryValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objUserStory;
                        console.log('1##object='+this.objectName);
                    }else{

                        this.userStoryValue = false;
                        
                    }
                
                    if (this.value == 'copado__User_Story_Task__c'){
                        this.userStoryTaskValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objUserStoryTask;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.userStoryTaskValue = false;
                    }
                    
                    if (this.value == 'copado__Deployment_Task__c'){
                        this.deploymentTaskValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objDeployTask;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.deploymentTaskValue = false;
                    }

                    if (this.value == 'copado__User_Story_Commit__c'){
                        this.userStoryCommitsValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objUSCommit;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.userStoryCommitsValue = false;
                    }

                    if (this.value == 'copado__User_Story_Metadata__c'){
                        this.userStoryMetadataValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objUSMetadata;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.userStoryMetadataValue = false;
                    }

                    if (this.value == 'copado__User_Story_Data_Commit__c'){
                        this.userstoryDataCommitsValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objUSDataCommit;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.userstoryDataCommitsValue = false;
                    }

                    if (this.value == 'copado__Pull_Request__c'){
                        this.pullRequestValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objPullRequest;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.pullRequestValue = false;
                    }

                    if (this.value == 'copado__Static_Code_Analysis_Result__c'){
                        this.staticCodeAnalysisResultsValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objStaticCode;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.staticCodeAnalysisResultsValue = false;
                    }

                    if (this.value == 'copado__Promoted_User_Story__c'){
                        this.promotedUserStoryValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objPromotedUser;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.promotedUserStoryValue= false;
                    }

                    if (this.value == 'copado__Deployment__c'){
                        this. deploymentsValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objDeployments;
                        console.log('1##object='+this.objectName);

                    }else{
                        this. deploymentsValue = false;
                    }

                    if (this.value == 'copado__Step__c'){
                        this.stepValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objSteps;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.stepValueue = false;
                    }

                    if (this.value == 'copado__Deployment_Job__c'){
                        this.deploymentJobValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objDeployJob;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.deploymentJobValue = false;
                    }

                    if (this.value == 'copado__Compliance_Scan_Result__c'){
                        this.compilanceScanResultValue = true;
                        this.showUserStoryPopupFlag=true;
                        this.objectName = this.objComplianceScanResult;
                        console.log('1##object='+this.objectName);

                    }else{
                        this.compilanceScanResultValue = false;
                    }

                    
                }
 


userStoryclosePopupHandler(event){

    this.showUserStoryPopupFlag=event.detail
}

scheduleBranchCloseJobPopupHandler(event){ 
    this.showBranchScheduledFlag=event.detail
}


//Branch Cleanup Starts

showPopupModel=false
showPlusInputFieldFlag=false
showAddBranchInputFieldFlag=true


//@track showModal = false;


showButtonFlag=false
apiKeyVar =null
serverUrlVar =null
branchToBeVar =null
gitRepositoryObject
BranchToBeList = [];
@api recordId
sObjectSelectedRecordList
rowOffset = 0;


//git Repository Lookup
handleSuccess(event) {
    
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success1',
            message: event.detail.apiName + ' created.',
            variant: 'success',
        })
    );
}

handleChange1(event) {
    this.showButtonFlag=true;
    this.gitRepositoryObject=event.detail.value;
    this.recordId = event.detail.value[0];
    console.log('You selected Git Repository : ' +event.detail.value[0]);

    console.log('Record Id ='+this.recordId);
    console.log('Object Name ='+this.objectName);
    
}



//Proceed Button Handler
@api bol = false;


// Data Table / Popup JS  starts
    draftValues=[];
    columns = columns;
    selectedRecords
    selectedRecordsCount
    totalRecords
    result
    error

    @api userStoryFeatureRecordList
    showSpinnerFlag = false

    @api recordList
    

    @track selectedOption

    

    changeHandler(event) {
    const field = event.target.name;
    if (field === 'Branches') {
        this.selectedOption = event.target.value;
            console.log("you have selected : "+this.selectedOption);

          
            if(this.selectedOption == 'User Story'){
                this.objectName = this.objUserStory;
                console.log('Object Name = '+this.objectName);
            }

            if(this.selectedOption == 'Promotion Branches'){
                this.objectName = this.objSteps;
                console.log('Object Name = '+this.objectName);
            }
        } 
    }

    selectedRecordsHandler(event){
        const selectedRows  =   event.detail.selectedRows;
        console.log("Selected Rows = "+selectedRows)
        this.selectedRecordsCount = event.detail.selectedRows.length;
    
        this.selectedRecords = selectedRows;
        console.log("selectedRecords = "+this.selectedRecords);
    
        let recordsSets = new Set();
    
        // getting selected record id
        for (let i = 0; i < selectedRows.length; i++) {
            recordsSets.add(selectedRows[i].Id);
        }
    
        // coverting to array
    
        this.selectedRecordsId = Array.from(recordsSets);
     
    }
          

   
    show3MonthButton=true
    show6MonthButton = true

    show3MonthBrandButton = false
    show6MonthBrandButton = false

   
  

    threeMonthHandler(){

        this.show3MonthButton = false;
       this.show3MonthBrandButton = true;

       this.show6MonthBrandButton = false;
       this.show6MonthButton = true;

       
       this.months=3 
       console.log('Months= '+this.months);
      


       var inputFields=this.template.querySelectorAll("input");
       inputFields.forEach(element=>{
           
           if(element.name=='apiKey'){
               if(element.value != ''){
             this.apiKeyVar = element.value;
             this.bol =true;
               }
               else{
                   this.showErrorToast();
                   this.bol=false;
               }
           }
     
           if(element.name=='serverUrl'){
               if(element.value != ''){
                   this.serverUrlVar = element.value;
                   this.bol =true;
                     }
                     else{
                         this.showErrorToast();
                         this.bol=false;
                     }
             
           }

           if(element.name=='branchToBe'){
               this.branchToBeVar = element.value;

               this.BranchToBeList  = this.branchToBeVar.split(',');
           }

       });
       console.log('apiKeyVarafter= '+this.apiKeyVar);
       console.log('ServerVarafter= '+this.serverUrlVar);
       console.log('branchToBe After = '+this.branchToBeVar);
       console.log('BranchToBeList After = '+this.BranchToBeList);
       console.log('popup show = '+this.bol);


        
}

    threeMonthBrandHandler(){

        this.show3MonthBrandButton = false;
        this.show3MonthButton = true;

        
        this.months=3 
        console.log('Months= '+this.months);
       


        var inputFields=this.template.querySelectorAll("input");
        inputFields.forEach(element=>{
            
            if(element.name=='apiKey'){
                if(element.value != ''){
              this.apiKeyVar = element.value;
              this.bol =true;
                }
                else{
                    this.showErrorToast();
                    this.bol=false;
                }
            }
      
            if(element.name=='serverUrl'){
                if(element.value != ''){
                    this.serverUrlVar = element.value;
                    this.bol =true;
                      }
                      else{
                          this.showErrorToast();
                          this.bol=false;
                      }
              
            }

            if(element.name=='branchToBe'){
                this.branchToBeVar = element.value;

                this.BranchToBeList  = this.branchToBeVar.split(',');
            }
 
        });
        console.log('apiKeyVarafter= '+this.apiKeyVar);
        console.log('ServerVarafter= '+this.serverUrlVar);
        console.log('branchToBe After = '+this.branchToBeVar);
        console.log('BranchToBeList After = '+this.BranchToBeList);
        console.log('popup show = '+this.bol);



        
        
    }

     sixMonthHandler(){

        
        this.show6MonthButton = false;
        this.show3MonthBrandButton = false;
        this.show3MonthButton = true;
       this.show6MonthBrandButton = true;

       
       this.months=6
       console.log('Months= '+this.months);

       var inputFields=this.template.querySelectorAll("input");
       inputFields.forEach(element=>{
           
           if(element.name=='apiKey'){
               if(element.value != ''){
             this.apiKeyVar = element.value;
             this.bol =true;
               }
               else{
                   this.showErrorToast();
                   this.bol=false;
               }
           }
     
           if(element.name=='serverUrl'){
               if(element.value != ''){
                   this.serverUrlVar = element.value;
                   this.bol =true;
                     }
                     else{
                         this.showErrorToast();
                         this.bol=false;
                     }
             
           }

           if(element.name=='branchToBe'){
               this.branchToBeVar = element.value;

               this.BranchToBeList  = this.branchToBeVar.split(',');
           }

       });
       console.log('apiKeyVarafter= '+this.apiKeyVar);
       console.log('ServerVarafter= '+this.serverUrlVar);
       console.log('branchToBe After = '+this.branchToBeVar);
       console.log('BranchToBeList After = '+this.BranchToBeList);
       console.log('popup show = '+this.bol);



       
}

    sixMonthBrandHandler(){

        
        this.show6MonthBrandButton = false;
        this.show6MonthButton = true;

        
        this.months=6
        console.log('Months= '+this.months);
       

        var inputFields=this.template.querySelectorAll("input");
        inputFields.forEach(element=>{
            
            if(element.name=='apiKey'){
                if(element.value != ''){
              this.apiKeyVar = element.value;
              this.bol =true;
                }
                else{
                    this.showErrorToast();
                    this.bol=false;
                }
            }
      
            if(element.name=='serverUrl'){
                if(element.value != ''){
                    this.serverUrlVar = element.value;
                    this.bol =true;
                      }
                      else{
                          this.showErrorToast();
                          this.bol=false;
                      }
              
            }

            if(element.name=='branchToBe'){
                this.branchToBeVar = element.value;

                this.BranchToBeList  = this.branchToBeVar.split(',');
            }
 
        });
        console.log('apiKeyVarafter= '+this.apiKeyVar);
        console.log('ServerVarafter= '+this.serverUrlVar);
        console.log('branchToBe After = '+this.branchToBeVar);
        console.log('BranchToBeList After = '+this.BranchToBeList);
        console.log('popup show = '+this.bol);



    }

    proceedHandler(){
        var inputFields=this.template.querySelectorAll("input");
            inputFields.forEach(element=>{
                
                if(element.name=='apiKey'){
                    if(element.value != ''){
                  this.apiKeyVar = element.value;
                  this.bol =true;
                    }
                    else{
                        this.showErrorToast();
                        this.bol=false;
                    }
                }
          
                if(element.name=='serverUrl'){
                    if(element.value != ''){
                        this.serverUrlVar = element.value;
                        this.bol =true;
                          }
                          else{
                              this.showErrorToast();
                              this.bol=false;
                          }
                  
                }
    
                if(element.name=='branchToBe'){
                    this.branchToBeVar = element.value;
    
                    this.BranchToBeList  = this.branchToBeVar.split(',');
                }
     
            });
            console.log('apiKeyVarafter= '+this.apiKeyVar);
            console.log('ServerVarafter= '+this.serverUrlVar);
            console.log('branchToBe After = '+this.branchToBeVar);
            console.log('BranchToBeList After = '+this.BranchToBeList);
            console.log('popup show = '+this.bol);
    
            this.showSpinnerFlag = true;
    
    if(this.objectName=='copado__User_Story__c')
            getuserStoryBranchRecord({months:this.months})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false;
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.recordList = result;
                                        this.totalRecords = result.length;
                            
                            })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
                            })
                            this.columns=columns1;
    
    
                            
    if(this.objectName=='copado__Step__c'){
    
    getStepObjectRecordList({months:this.months})
                            .then( (result) => {
                                this.showSpinnerFlag = false;
                                this.result = result;
                                this.error = undefined
                                console.log(this.result );
                                this.recordList = result;
                                this.totalRecords = result.length;
                    
                    })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                            console.log(this.error);
                    })
                    this.columns=columns2;
                    }  
          
            
                this.showPopupModel=this.bol;
            
    }


selectedHandler(){
    this.selectedPopup = true;

    this.sObjectSelectedRecordList = this.selectedRecordsId;

    console.log('** ='+this.sObjectSelectedRecordList);

   this.totalselectedRecords = this.sObjectSelectedRecordList.length;

   if(this.objectName=='copado__User_Story__c'){
      this.columns=columns12;
   }
   if(this.objectName=='copado__Step__c'){
      this.columns=columns22;
   }
}



    closeModal(){
        this.showPopupModel=false;

    }

    closeModalTwo(){
        this.selectedPopup=false;
      
    }
    
   
    
    async deleteHandler(){
       const result = await LightningConfirm.open({
            message: 'The Action about to be executed cannot be halted or reverted once the job has been triggered. ',
            variant: 'Destructive',
            label: 'Conformation Massage',
            
        });

        console.log('I m in delete JS');
        console.log('this.sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
        console.log('gitRepositoryObject'+this.gitRepositoryObject);
        console.log('Record Id ='+this.recordId);
        console.log('serverUrlVar'+this.serverUrlVar);
        console.log('apiKeyVar'+this.apiKeyVar);
        
    if(this.objectName=='copado__User_Story__c'){
                practiceFeatureMethod({recordIdList: this.sObjectSelectedRecordList, serverURL : this.serverUrlVar, repositoryId : this.recordId , copadoAPIKey : this.apiKeyVar ,keepThoseBranches : this.BranchToBeList})
                                            .then((result) => {
                                            this.result = result;
                                            this.showSuccessToast();


                                            this.selectedPopup=false;
                                            this.getRefeshData();
                                            this.totalRecords = result.length;
                                        })
                                        .catch((error) => {
                                            console.log(error)
                                            this.error = error;
                                            this.showErrorToast();
                                        });
                        }
     if(this.objectName=='copado__Step__c'){
                practicePromotionRecord({recordIdList : this.sObjectSelectedRecordList,repositoryId:this.recordId,serverURL:this.serverUrlVar,copadoAPIKey:this.apiKeyVar, keepThoseBranches : this.BranchToBeList})
                                            .then((result) => {
                                            this.result = result;
                                            this.showSuccessToast();

                                            this.selectedPopup=false;
                                            this.getRefeshData();
                                           this.totalRecords = result.length;
                                        })
                                        .catch((error) => {
                                            console.log(error)
                                            this.error = error;
                                            this.showErrorToast();
                                        });
                    }
       
    }

    getRefeshData(){ 

        if(this.objectName=='copado__User_Story__c'){
            getuserStoryBranchRecord({months:this.months})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false;
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.recordList = result;
                                        this.totalRecords = result.length;

            })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
            })
            this.columns=columns1;
        }    


        if(this.objectName=='copado__Step__c'){
            getStepObjectRecordList({months:this.months})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false;
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.recordList = result;
                                        this.totalRecords = result.length;

            })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
            })
            this.columns=columns2;
        }    


    }

    ScheduledBranchFeatureJobHandler(){
        console.log('i m in branch schedule');

        var inputFields=this.template.querySelectorAll("input");
            inputFields.forEach(element=>{
                
                if(element.name=='apiKey'){
                    if(element.value != ''){
                  this.apiKeyVar = element.value;
                  this.bol =true;
                    }
                    else{
                        this.showErrorToast();
                        this.bol=false;
                    }
                }
          
                if(element.name=='serverUrl'){
                    if(element.value != ''){
                        this.serverUrlVar = element.value;
                        this.bol =true;
                          }
                          else{
                              this.showErrorToast();
                              this.bol=false;
                          }
                  
                }
    
                if(element.name=='branchToBe'){
                    this.branchToBeVar = element.value;
    
                    this.BranchToBeList  = this.branchToBeVar.split(',');
                }
     
            });
            console.log('apiKeyVarafter= '+this.apiKeyVar);
            console.log('ServerVarafter= '+this.serverUrlVar);
            console.log('branchToBe After = '+this.branchToBeVar);
            console.log('BranchToBeList After = '+this.BranchToBeList);
            console.log('popup show = '+this.bol);

            this.showBranchScheduledFlag = this.bol;
    }
    
   showSuccessToast() {
    const evt = new ShowToastEvent({
                                        title: 'Message',
                                        message: this.result,
                                        variant: 'success',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
}




ScheduledJobHandler(){

    console.log('I am in scheduled');
            
    this.showScheduledFlag=true;

}



resetHandler(){
    this.showPopupModel=true;
  
}

scheduleclosePopupHandler(event){
    this.showScheduledFlag=event.detail

}

showErrorToast() {
    const evt = new ShowToastEvent({
                                      title: 'Toast Error',
                                      message: 'Give Correct Input',
                                      variant: 'error',
                                      mode: 'dismissable'
                                  });
                                  this.dispatchEvent(evt);
                              }
 
   
   
}