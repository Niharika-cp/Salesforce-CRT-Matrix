import { LightningElement,track,api,wire } from 'lwc';
import getsObjectRecord from "@salesforce/apex/CentralClass.getsObjectRecord";
import LightningConfirm from 'lightning/confirm';
import sObjectRecordDeleted from "@salesforce/apex/CentralClass.sObjectRecordDeleted";
import sObjectRecordHardDeleted from "@salesforce/apex/CentralClass.sObjectRecordHardDeleted";
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ;
import getStepObjectRecordList from "@salesforce/apex/CentralClass.getStepObjectRecordList";
import getuserStoryBranchRecord from "@salesforce/apex/CentralClass.getuserStoryBranchRecord";
import practicePromotionRecord from "@salesforce/apex/CentralClass.practicePromotionRecord";
import practiceFeatureMethod from "@salesforce/apex/CentralClass.practiceFeatureMethod";
import callFeatureScheduleClass from '@salesforce/apex/CentralClass.callFeatureScheduleClass';
import callPromotionScheduleClass from '@salesforce/apex/CentralClass.callPromotionScheduleClass';
import callScheduleClass from '@salesforce/apex/CentralClass.callScheduleClass';
import CleanUpIcon from '@salesforce/resourceUrl/CleanUpIcon';
import getsObjectRecordForArchieved from '@salesforce/apex/CentralClass.getsObjectRecordForArchieved'
const columns=[];

const  columnsRecordCleanup1 = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate'},
];

const  columnsSelectedRecordCleanup = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate'},
];  


const  columnsFeatureBranchRecord = [
    { label: 'User Story Name', fieldName: 'Name'},
    { label: 'View in Git', fieldName: 'BranchName__c'},
    { label: 'Project', fieldName: 'Project__Name__c'},
    { label: 'Release', fieldName: 'Release_Name__c'},
    { label: 'Enviornment', fieldName: 'Environment_Name__c'},
  ];

  const  columnsSelectedFeatureBranchRecord = [
    
    { label: 'User Story Name', fieldName: 'Name'},
    { label: 'View in Git', fieldName: 'BranchName__c'},
    { label: 'Project', fieldName: 'Project__Name__c'},
    { label: 'Release', fieldName: 'Release_Name__c'},
    { label: 'Enviornment', fieldName: 'Environment_Name__c'},
  ];

  const  columnsPromotionBranchRecord = [
    
    { label: 'Promotion Name', fieldName: 'Name'},
    { label: 'Status', fieldName: 'copado__Status__c'},
    { label: 'Check Only', fieldName: 'copado__CheckOnly__c'},
    { label: 'Branch', fieldName: 'copado__Branch__c'},
  ];

  const  columnsSelectedPromotionBranchRecord = [
    
    { label: 'Promotion Name', fieldName: 'Name'},
    { label: 'Status', fieldName: 'copado__Status__c'},
    { label: 'Check Only', fieldName: 'copado__CheckOnly__c'},
    { label: 'Branch', fieldName: 'copado__Branch__c'},
  ];
export default class CleanupComponent extends LightningElement {

    @track selectedStep = 'Cleanup Operation';

    showRunPathFlag = true;
    showScheduledPathFlag = false;
    
    
 selectStep1() {
        this.selectedStep = 'Cleanup Operation';
    }
    
    selectStep2() {
        this.selectedStep = 'Entity Selection';
    }
    
    selectStep3() {
        this.selectedStep = 'Data Selection';
    }
    
    selectStep4() {
        this.selectedStep = 'Review Selection';
    }
    
    selectStep5() {
        this.selectedStep = 'Schedule';
    }

    get CleanUp(){
        return CleanUpIcon;
    }

 ////////////////////////// for 1st Screen Methods And Variables for Record Cleanup /////////////////////////////////

    firstRadioFlag = true
    selectObjectFlag = false
    value = [];

   /* get options1() {
        return [
            { label: 'Copado Records', value: 'Copado Records' },
            { label: 'GIT Branches ', value: 'GIT Branches' },
            
        ];
    }

    get selectedValues() {
        return this.value.join(',') 
    }

    handleChange1(e){
          this.value = e.detail.value;
     }*/

///// Next Screen 1 /////

     handleNextScreen1(){

          /*      console.log('I am in Next Screen 1');
                this.selectedStep = 'Cleanup Operation';
      if(this.value != ''){
                if (this.value == 'Copado Records'){
                    this.firstRadioFlag = false;
                    this.selectObjectFlag = true;
                }

                if (this.value == 'GIT Branches'){
                    this.firstRadioFlag = false;
                    this.GitBranchesButton = true;
                }
        var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Cleanup Operation'){
                    this.selectedStep = 'Entity Selection';
                }
            }
            else{
                this.showErrorToast1stScreen();
            }*/

            console.log('I am in Next Screen 1');
            this.selectObjectFlag = true;
            this.firstRadioFlag = false;
            

            var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Cleanup Operation'){
                    this.selectedStep = 'Entity Selection';
                }
           

    }

    handleNextScreen1git(){
        console.log('I am in Next Screen 1 git');
        this.GitBranchesButton = true;
        this.firstRadioFlag = false;
        

        var getselectedStep = this.selectedStep;
            if(getselectedStep === 'Cleanup Operation'){
                this.selectedStep = 'Entity Selection';
            }
       
    }

    showErrorToast1stScreen() {
        const evt = new ShowToastEvent({
                                          title: 'Toast Error',
                                          message: 'Please select',
                                          variant: 'error',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                         }
     

    //////// selection for select Object Flag for Record Cleanup /////////////////

    objectName 
    ObjectLabel 

    // Selected objects Variables
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


    // Selected objects simple Name Label Variable
    objUserStoryLable =  'Copado User Story '
    objUserStoryTaskLable = 'Copado User Story Task' 
    objDeployTaskLable = 'Copado Deployment Task'
    objUSCommitLable = 'Copado User Story Commit'
    objUSMetadataLable =  'Copado User Story Metadata'
    objUSDataCommitLable = 'Copado User Story Data Commit'
    objPullRequestLable = 'Copado Pull Request'
    objStaticCodeLable = 'Copado Static Code Analysis Result'
    objPromotedUserLable = 'Copado Promoted User Story'
    objDeploymentsLable =  'Copado Deployment'
    objStepsLable ='Copado Step'
    objDeployJobLable = 'Copado Deployment Job'
    objComplianceScanResultLable =  'Copado Compliance Scan Result'


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

    get options2() {
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

    
     handleChange2(e){
          this.value = e.detail.value;


          if (this.value == 'copado__User_Story__c'){
            this.userStoryValue = true;
            
            this.objectName = this.objUserStory;
            
            this.ObjectLabel = this.objUserStoryLable;
            console.log('1##object='+this.objectName);
        }else{

            this.userStoryValue = false;
            
        }
    
        if (this.value == 'copado__User_Story_Task__c'){
            this.userStoryTaskValue = true;
            
            this.objectName = this.objUserStoryTask;
            this.ObjectLabel = this.objUserStoryTaskLable;
            console.log('1##object='+this.objectName);

        }else{
            this.userStoryTaskValue = false;
        }
        
        if (this.value == 'copado__Deployment_Task__c'){
            this.deploymentTaskValue = true;
            
            this.objectName = this.objDeployTask;
            this.ObjectLabel = this.objDeployTaskLable;
            console.log('1##object='+this.objectName);

        }else{
            this.deploymentTaskValue = false;
        }

        if (this.value == 'copado__User_Story_Commit__c'){
            this.userStoryCommitsValue = true;
            
            this.objectName = this.objUSCommit;
            this.ObjectLabel = this.objUSCommitLable;
            console.log('1##object='+this.objectName);

        }else{
            this.userStoryCommitsValue = false;
        }

        if (this.value == 'copado__User_Story_Metadata__c'){
            this.userStoryMetadataValue = true;
            
            this.objectName = this.objUSMetadata;
            this.ObjectLabel = this.objUSMetadataLable;
            console.log('1##object='+this.objectName);

        }else{
            this.userStoryMetadataValue = false;
        }

        if (this.value == 'copado__User_Story_Data_Commit__c'){
            this.userstoryDataCommitsValue = true;
            
            this.objectName = this.objUSDataCommit;
            this.ObjectLabel = this.objUSDataCommitLable;
            console.log('1##object='+this.objectName);

        }else{
            this.userstoryDataCommitsValue = false;
        }

        if (this.value == 'copado__Pull_Request__c'){
            this.pullRequestValue = true;
            
            this.objectName = this.objPullRequest;
            this.ObjectLabel = this.objPullRequestLable;
            console.log('1##object='+this.objectName);

        }else{
            this.pullRequestValue = false;
        }

        if (this.value == 'copado__Static_Code_Analysis_Result__c'){
            this.staticCodeAnalysisResultsValue = true;
            
            this.objectName = this.objStaticCode;
            this.ObjectLabel = this.objStaticCodeLable;
            console.log('1##object='+this.objectName);

        }else{
            this.staticCodeAnalysisResultsValue = false;
        }

        if (this.value == 'copado__Promoted_User_Story__c'){
            this.promotedUserStoryValue = true;
            
            this.objectName = this.objPromotedUser;
            this.ObjectLabel = this.objPromotedUserLable;
            console.log('1##object='+this.objectName);

        }else{
            this.promotedUserStoryValue= false;
        }

        if (this.value == 'copado__Deployment__c'){
            this. deploymentsValue = true;
            
            this.objectName = this.objDeployments;
            this.ObjectLabel = this.objDeploymentsLable;
            console.log('1##object='+this.objectName);

        }else{
            this. deploymentsValue = false;
        }

        if (this.value == 'copado__Step__c'){
            this.stepValue = true;
            
            this.objectName = this.objSteps;
            this.ObjectLabel = this.objStepsLable;
            console.log('1##object='+this.objectName);

        }else{
            this.stepValueue = false;
        }

        if (this.value == 'copado__Deployment_Job__c'){
            this.deploymentJobValue = true;
            
            this.objectName = this.objDeployJob;
            this.ObjectLabel = this.objDeployJobLable;
            console.log('1##object='+this.objectName);

        }else{
            this.deploymentJobValue = false;
        }

        if (this.value == 'copado__Compliance_Scan_Result__c'){
            this.compilanceScanResultValue = true;
            
            this.objectName = this.objComplianceScanResult;
            this.ObjectLabel = this.objComplianceScanResultLable;
            console.log('1##object='+this.objectName);

        }else{
            this.compilanceScanResultValue = false;
        }
     }


      //////// selection for 3months 6 months for Record Cleanup /////////////////

    months

    show3MonthButton=true
    show6MonthButton = true

    show3MonthBrandButton = false
    show6MonthBrandButton = false

    threeMonthHandler(){
        console.log('I am in 3 Month Handler Record Cleanup');
                this.show3MonthButton = false;
                this.show3MonthBrandButton = true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;

                this.months=3 
                console.log('Months= '+this.months);
        
    }

    threeMonthBrandHandler(){
        console.log('I am in 3 Month Brand Handler Record Cleanup');
                this.show3MonthBrandButton = false;
                this.show3MonthButton = true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;

                this.months=3 
                console.log('Months= '+this.months);
    }

    sixMonthHandler(){
        console.log('I am in 6 Month Handler Record Cleanup');
                this.show6MonthButton = false;
                this.show3MonthBrandButton = false;
                this.show3MonthButton = true;
                this.show6MonthBrandButton = true;

                this.months=6
                console.log('Months= '+this.months);

    }


    sixMonthBrandHandler(){
        console.log('I am in 6 Month Brand Handler Record Cleanup');
                this.show3MonthBrandButton = false;
                this.show3MonthButton =true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;
            
                this.months=6
                console.log('Months= '+this.months);
    }


    //////// selection for Run Now and Scheduled for Record Cleanup /////////////////

    showRunNowButton = true
    showRunNowhBrandButton = false

    showScheduledButton = true
    showScheduledBrandButton = false

    showSchedulePageOnScheduleButton = false

    RunNowHandler(){

        console.log('I am in Run Now Handler Record Cleanup');
                this.showRunNowButton = false;
                this.showRunNowhBrandButton = true;
                
                this.showScheduledBrandButton = false;
                this.showScheduledButton = true;
                this.showDataTableOnRunNowButton=true;

                this.showRunPathFlag = true;
                this.showScheduledPathFlag = false;
                this.selectedStep = 'Entity Selection';
    }

    RunNowBrandHandler(){
        console.log('I am in Run Now Brand Handler Record Cleanup');
                this.showRunNowhBrandButton = false;
                this.showRunNowButton = true;
                this.showScheduledBrandButton = false;
                this.showScheduledButton = true;

                this.showRunPathFlag = true;
                this.showScheduledPathFlag = false;
                this.selectedStep = 'Entity Selection';

     }

    scheduledPageHandler(){
        console.log('I am in Scheduled Handler Record Cleanup');
                this.showScheduledButton = false;
                this.showRunNowhBrandButton = false;
                this.showRunNowButton = true;

                this.showScheduledBrandButton = true;
                this.showSchedulePageOnScheduleButton=true

                this.showScheduledPathFlag = true;
                this.showRunPathFlag = false;
     }

    scheduledPageBrandHandler(){
        console.log('I am in Scheduled Brand Handler Record Cleanup');
                this.showRunNowhBrandButton = false;
                this.showRunNowButton =true;
                    
                this.showScheduledBrandButton = false;
                this.showScheduledButton = true;

                this.showScheduledPathFlag = true;
                this.showRunPathFlag = false;
     }

    /////// prev & next for Screen 2 ///////////

    sObjectRecordList
    totalRecordForRecordCleanup

    handlePrevScreen2(){
        console.log('I am in Previous Screen 2');
                    this.firstRadioFlag = true;
                    this.selectObjectFlag = false;
                    
                    var getselectedStep = this.selectedStep;
                    //this.selectedStep = 'Cleanup Operation';
                if(this.firstRadioFlag==true){
                                if(getselectedStep === 'Entity Selection'){
                                      this.selectedStep = 'Cleanup Operation';
                                }
                    }
                    if(this.showSchedulePageOnScheduleButton==true){
                                if(getselectedStep === 'Scheduled'){
                                      this.selectedStep = 'Entity Selection';
                                }
                    }
                    eval("$A.get('e.force:refreshView').fire();");


    }

    handleNextScreen2(){
        console.log('I am in Next Screen 2');
        if((this.show3MonthBrandButton == true || this.show6MonthBrandButton == true) && this.objectName!= null && (this.showRunNowhBrandButton == true || this.showScheduledBrandButton == true)){
                    this.selectObjectFlag = false;
                  
                    if(this.showRunNowhBrandButton==true){
                            this.showDataTable=true
                            this.selectedDataTableFlag = false
                            this.showSchedulePage=false
                            this.columns=columnsRecordCleanup1;

                             var getselectedStep = this.selectedStep;

                                if(getselectedStep === 'Entity Selection'){
                                    this.selectedStep = 'Data Selection';
                                    this.showSchedulePage=false;
                                    this.showDataTable=true;
                                }
                    }
                    if(this.showScheduledBrandButton==true){
                            this.showSchedulePage=true
                            this.showDataTable=false

                            var getselectedStep = this.selectedStep;

                                    if(getselectedStep === 'Entity Selection'){
                                        this.selectedStep = 'Scheduled';
                                    }
                    }

                    console.log('objectName ='+this.objectName);
                    console.log('month ='+this.months);
                    this.showSpinnerFlag = true
                    getsObjectRecord({months:this.months,objectName:this.objectName})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.sObjectRecordList = result;
                                        this.totalRecordForRecordCleanup = result.length;

                                    })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
                                })
                            }
            else{
                this.showErrorToast2ndScreen();
            }
     }
     
    showErrorToast2ndScreen() {
        const evt = new ShowToastEvent({
                                          title: 'Toast Error',
                                          message: 'Please select all Value',
                                          variant: 'error',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                         }


/////////////////////// Data Table For Record Cleanup ///////////////////////

draftValues=[];
columns = columns;

showSpinnerFlag = false
selectedRecordsCount1 = '0'
totalRecordForRecordCleanup
selectedRecords

selectedRecordsHandler1(event){
    const selectedRows  =   event.detail.selectedRows;
    console.log("Selected Rows = "+selectedRows)
    this.selectedRecordsCount1 = event.detail.selectedRows.length;

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

 /////// prev & next for Screen 3 ///////////
 showDataTable = false 
 selectedDataTableFlag = false

        handlePrevScreen3(){
                this.showDataTable=false;
                this.selectObjectFlag=true;
              //  this.selectedDataTableFlag = false;

                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Data Selection'){
                    this.selectedStep = 'Entity Selection';
                }
        }

        totalselectedRecords1
        sObjectSelectedRecordList
        selectedRecordsId 

        handleNextScreen3(){
                if(this.selectedRecordsCount1 > 0 ){
                    
                                this.showDataTable=false;

                                this.selectedDataTableFlag = true;
            
                                this.sObjectSelectedRecordList = this.selectedRecordsId;
                    
                                console.log('** selected Record Id ='+this.sObjectSelectedRecordList);
                    
                                this.totalselectedRecords1 = this.sObjectSelectedRecordList.length;
                    
                                this.columns=columnsSelectedRecordCleanup;

                                var getselectedStep = this.selectedStep;
                                if(getselectedStep === 'Data Selection'){
                                    this.selectedStep = 'Review Selection';
                                }
                    }
                    else{
                         this.showErrorToast3ndScreen();
                    }
        }

        showErrorToast3ndScreen() {
            const evt = new ShowToastEvent({
                                              title: 'Toast Error',
                                              message: 'Please select Some Records',
                                              variant: 'error',
                                              mode: 'dismissable'
                                          });
                                          this.dispatchEvent(evt);
                             }

        handlePrevScreen4(){
                this.showDataTable=true;
                this.selectedDataTableFlag = false;

                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Review Selection'){
                    this.selectedStep = 'Data Selection';
                }
        }

        recycleBinHandler(){
                        console.log('I m in recycle Bin Handler');
                        console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
                        console.log('objectReceived'+this.objectName);
                    
                    let text;
                    if (confirm("Do you really want to delete that record ?") == true) {
                        
                        sObjectRecordDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectName})
                                            .then((result) => {
                                            this.result = result;
                                            this.error = undefined;
                                            this.showSuccessToast1();
                                            
                                            this.selectedDataTableFlag = false;
                                            
                                            this.getRefeshData();
                                            this.firstRadioFlag = true;
                                            this.totalRecordForRecordCleanup = result.length;

                                        })
                                        .catch((error) => {
                                                console.log(error)
                                                this.error = error;
                                                this.result = undefined;
                                                this.showErrorToast1();
                                        });
                    
                    } else {
                        
                        text = "You cancelled!";
                        
                    }
                    var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Review Selection'){
                        this.selectedStep = 'Cleanup Operation';
                      
                    }
                    
        }

        permanantDeleteHandler(){
                    console.log('I m in Permanant delete');
                    console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
                    console.log('objectReceived'+this.objectName);
            
                    let text;
                    if (confirm("Do you really want to delete that record ?") == true){
                    
                        sObjectRecordHardDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectName})
                                            .then((result) => {
                                            this.result = result;
                                            this.error = undefined;
                                            this.showSuccessToast1();
                                            this.selectedDataTableFlag = false;
                                            this.getRefeshData();
                                            this.firstRadioFlag = true;
                                            this.totalRecordForRecordCleanup = result.length;
                                        })
                                        .catch((error) => {
                                                console.log(error)
                                                this.error = error;
                                                this.result = undefined;
                                                this.showErrorToast1();
                                        });
                        
                                } else {
                                text = "You cancelled!";
                                this.selectedDataTableFlag = true;
                                }
                                    var getselectedStep = this.selectedStep;
                                    if(getselectedStep === 'Review Selection'){
                                            this.selectedStep = 'Cleanup Operation';
                                         //   eval("$A.get('e.force:refreshView').fire();");
                                        }
                                     
        }

        getRefeshData(){ 
            this.showSpinnerFlag = true;

            getsObjectRecord({months:this.months,objectName:this.objectName})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false
                                        this.result = result;
                                        this.error = undefined
                                        console.log(this.result );
                                        this.sObjectRecordList = result;
                                        this.totalRecordForRecordCleanup = result.length;

                                    })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                    console.log(this.error);
                                })

}


showSuccessToast1() {
    const evt = new ShowToastEvent({
                                        title: 'Message',
                                        message: this.result,
                                        variant: 'success',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
    }
    
    showErrorToast1() {
    const evt = new ShowToastEvent({
                                      title: 'Toast Error',
                                      message: this.error,
                                      variant: 'error',
                                      mode: 'dismissable'
                                  });
                                  this.dispatchEvent(evt);
                              }
    
    
    showErrorToast2() {
                                const evt = new ShowToastEvent({
                                                                  title: 'Toast Error',
                                                                  message: 'Please select some Records...!!!',
                                                                  variant: 'error',
                                                                  mode: 'dismissable'
                                                              });
                                                              this.dispatchEvent(evt);
                                                          }


      //////////////// Scheduled Job For Record Cleanup Starts //////////////////////////                                        
        //3/6 Months and Daily,Hourly,Weekly Radio button handler

showWeeklyButton=false
showDailyButton=false
showHourlyButton=false

scheduleJobName='';


@track weekdays=[]


//months

numberOfDays
numberOfHours
dayOfMonth
hoursInDay
monthOfYear='*'
year='*'

Hour ='0'
Minut='0'

hour 
hr='0'
min='0'
sec='0'


cron='0 0 0/1 1/1 * ? *'

value = ''


hourlyValue=false
DailyValue = false
weekdaysValue = false

showSelectedMonthFlag = false

showButton = true

showMondayBrandButton = false
showTuesBrandButton = false
showWedBrandButton = false
showThursBrandButton = false
showFridayBrandButton = false
showSatBrandButton = false
showSunBrandButton = false

showMonButton = true
showTueButton = true
showWedButton = true
showThurButton = true
showFriButton = true
showSatButton = true
showSunButton = true

get options3() {
return [
  { label: 'Hourly', value: 'HourValue' },
  { label: 'Daily', value: 'DailyValue' },
  { label: 'Weekly', value: 'WeekdayValue' },
];
}


handleChange3(e) {
this.value = e.detail.value;

if (this.value == 'HourValue'){
                this.hourlyValue = true;
                this.DailyValue = false;
                this.weekdaysValue = false;

                console.log('** HourValue= '+this.hourlyValue);
                
                    this.showHourlyButton=true;
                    this.showWeeklyButton=false;
                    this.showDailyButton=false;
                    this.showMondayBrandButton = false
                    this.showTuesBrandButton = false
                    this.showWedBrandButton = false
                    this.showThursBrandButton = false
                    this.showFridayBrandButton = false
                    this.showSatBrandButton = false
                    this.showSunBrandButton = false

                    this.showMonButton = true
                    this.showTueButton = true
                    this.showWedButton = true
                    this.showThurButton = true
                    this.showFriButton = true
                    this.showSatButton = true
                    this.showSunButton = true


                    this.min='0'
                    this.hr='0'
                    this.weekdays= ['?']
                    this.cron='0 0 0/1 1/1 * ? *'
                    this.numberOfHours=1
                    this.hoursInDay='0/'+this.numberOfHours;

        }else{
                this.hourlyValue = false;
                }


if (this.value == 'DailyValue'){
            this.DailyValue = true;
            this.weekdaysValue = false;
            this.hourlyValue = false;

            console.log('DailyValue = '+this.DailyValue);

            this.showDailyButton=true
            this.showWeeklyButton=false
            this.showHourlyButton=false

                this.showMondayBrandButton = false
                this.showTuesBrandButton = false
                this.showWedBrandButton = false
                this.showThursBrandButton = false
                this.showFridayBrandButton = false
                this.showSatBrandButton = false
                this.showSunBrandButton = false

                this.showMonButton = true
                this.showTueButton = true
                this.showWedButton = true
                this.showThurButton = true
                this.showFriButton = true
                this.showSatButton = true
                this.showSunButton = true

            this.cron='0 0 12 1/1 * ? *'
            this.weekdays= ['?']
            this.numberOfDays=1
            this.dayOfMonth='1/'+this.numberOfDays;
    }else{
            this.DailyValue = false;
            }



if (this.value == 'WeekdayValue'){
            this.weekdaysValue = true;
            this.hourlyValue = false;
            this.showDailyButton=false

            console.log('WeekdayValue'+this.weekdaysValue);

            this.showWeeklyButton=true
            this.showDailyButton=false
            this.showHourlyButton=false
            this.cron='0 0 12 ? *  *'
            this.dayOfMonth='?'
            
     }else{
            this.weekdaysValue = false;
            }
}



//show on weekly flag

        mondayHandler() {
                this.showMonButton = false;
                this.showMondayBrandButton = true;

                  if (this.weekdays.includes('?')) {
                    this.weekdays.splice(this.weekdays.indexOf('?'),1);
                    } 
                    console.log('I am In Monday Handler');
                    if (!this.weekdays.includes('MON')) {
                        this.weekdays.push('MON')
                    } else {
                        this.weekdays.splice(this.weekdays.indexOf('MON'),1);
                    }
                        this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                   
        }


        mondayBrandHandler(){
                this.showMondayBrandButton = false;
                this.showMonButton = true;

                      if (this.weekdays.includes('?')) {
                    this.weekdays.splice(this.weekdays.indexOf('?'),1);
                    } 
                    console.log('I am In Monday Handler');
                    if (!this.weekdays.includes('MON')) {
                        this.weekdays.push('MON')
                    } else {
                        this.weekdays.splice(this.weekdays.indexOf('MON'),1);
                    }
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
        
        }

        tuesdayHandler() {
                this.showTueButton = false;
                this.showTuesBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Tuesday Handler');
                if (!this.weekdays.includes('TUE')) {
                    this.weekdays.push('TUE')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('TUE'),1);
                }
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        TuesdayBrandHandler(){

                this.showTuesBrandButton = false;
                this.showTueButton = true;

                 if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Tuesday Handler');
                if (!this.weekdays.includes('TUE')) {
                    this.weekdays.push('TUE')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('TUE'),1);
                }
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        wednesdayHandler() {

                this.showWedButton = false;
                this.showWedBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Wednesday Handler');
                if (!this.weekdays.includes('WED')) {
                    this.weekdays.push('WED')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('WED'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        WednesdayBrandHandler(){

                this.showWedBrandButton = false;
                this.showWedButton = true;

                 if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Wednesday Handler');
                if (!this.weekdays.includes('WED')) {
                    this.weekdays.push('WED')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('WED'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        thursdayHandler() {
                this.showThurButton = false;
                this.showThursBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Thursday Handler');
                if (!this.weekdays.includes('THU')) {
                    this.weekdays.push('THU')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('THU'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        ThursdayBrandHandler(){

                this.showThursBrandButton = false;
                this.showThurButton = true;

              if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Thursday Handler');
                if (!this.weekdays.includes('THU')) {
                    this.weekdays.push('THU')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('THU'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        fridayHandler() {
                this.showFriButton = false;
                this.showFridayBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Friday Handler');
                if (!this.weekdays.includes('FRI')) {
                    this.weekdays.push('FRI')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('FRI'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        FridayBrandHandler(){

                this.showFridayBrandButton = false;
                this.showFriButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Friday Handler');
                if (!this.weekdays.includes('FRI')) {
                    this.weekdays.push('FRI')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('FRI'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        saturdayHandler() {
                this.showSatButton = false;
                this.showSatBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Saturday Handler');
                if (!this.weekdays.includes('SAT')) {
                    this.weekdays.push('SAT')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SAT'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        SaturdayBrandHandler(){

                this.showSatBrandButton = false;
                this.showSatButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Saturday Handler');
                if (!this.weekdays.includes('SAT')) {
                    this.weekdays.push('SAT')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SAT'),1);
                } 
                this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }


        sundayHandler() {
                this.showSunButton = false;
                this.showSunBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Sunday Handler');
                if (!this.weekdays.includes('SUN')) {
                    this.weekdays.push('SUN')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SUN'),1);
                }
                this.cron=this.sec+' '+this.min+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }

        SundayBrandHandler(){

                this.showSunBrandButton = false;
                this.showSunButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                console.log('I am In Sunday Handler');
                if (!this.weekdays.includes('SUN')) {
                    this.weekdays.push('SUN')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SUN'),1);
                }
                this.cron=this.sec+' '+this.min+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year

        }


// DAY MINUTE HOUR HANDLER


    numberOfEveryHoursHandler(evt){
            this.numberOfHours=evt.target.value
            console.log('Number Of Days= '+this.numberOfHours);
            this.hoursInDay='0/'+this.numberOfHours;
            this.cron=this.sec+' '+this.min+' '+this.hoursInDay+' '+'1/1'+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
    }

    numberOfDaysHandler(evt){
            this.numberOfDays=evt.target.value
            console.log('Number Of Days= '+this.numberOfDays);
            this.dayOfMonth='1/'+this.numberOfDays;
            this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
            
    }


    numberOfHoursHandler(evt){
        
            this.Hour=evt.target.value
            console.log('Number Of HOUR= '+this.Hour);
            this.hr=this.Hour.toString();
            console.log('Hours= '+this.hr);
            if(this.hr < 24){
               this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
        }
        else{
            this.showErrorToastCron();
        }
    }


    numberOfMinutesHandler(evt){
        
            this.Minut=evt.target.value
            console.log('Number Of MINUTE= '+this.Minut);
            this.min=this.Minut.toString();
            console.log('Minute= '+this.min);
            if(this.min < 60){
             this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
        }
        else{
                this.showErrorToastCron();
        }
    }

    
    showErrorToastCron() {
        const evt = new ShowToastEvent({
                                          title: 'Toast Error',
                                          message: 'Incorrect Input',
                                          variant: 'error',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                         }


    scheduleJobNameHandleChange(evt) {
            this.scheduleJobName=evt.target.value
            console.log('Schedule Job Name: ' + this.scheduleJobName);
    }



    scheduleApexJob(){ 

                console.log('On schedule button click Month= '+this.months)
                console.log('On schedule button click cron= '+this.cron)
                console.log('On schedule button click jobname= '+this.scheduleJobName)
                console.log('On schedule button click object name= '+this.objectName)

                callScheduleClass({month:this.months, cron:this.cron, jobName:this.scheduleJobName ,objectName:this.objectName})
                            .then((result) => {
                                console.log(result)
                                this.showSuccessToast4();      
                                this.error = undefined;
                                this.showSchedulePage = false;
                                this.firstRadioFlag = true;
                                this.showRunPathFlag = true;
                                this.showScheduledPathFlag = false;
                                this.selectedStep = 'Cleanup Operation';
                            
                            })
                            .catch((error) => {
                                console.log(error)
                                this.error = error;
                                this.result = undefined;
                                this.showErrorToast4();
                                
                            });

}

showSuccessToast4() {
        const evt = new ShowToastEvent({
                                        title: 'Message',
                                        message: 'Successfully Scheduled...!!!',
                                        variant: 'success',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
}

showErrorToast4() {
            const evt = new ShowToastEvent({
                                        title: 'Toast Error',
                                        message: 'Please fill all * (Required) value...!!!',
                                        variant: 'error',
                                        mode: 'dismissable'
                                    });
                                    this.dispatchEvent(evt);
                                }

handlePrevScheduleScreen(){
            this.selectObjectFlag = true;
            this.showSchedulePage = false;
            this.showRunNowhBrandButton=false;
            this.selectedStep = 'Entity Selection';
}

///////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////// Git Branches Methods and  Variables Starts ////////////////////////////////c/animation

GitBranchesButton = false;
gitRepositoryObject
objectNameReceived = 'copado__User_Story__c'
gitRepoRecordId



apiKeyVar =null 
serverUrlVar = null
branchToBeVar = null
BranchToBeList = [];

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

    handleChangeGitRepository(event) {
        
        this.gitRepositoryObject=event.detail.value;
        this.gitRepoRecordId = event.detail.value[0];
        console.log('You selected Git Repository : '+event.detail.value[0]);

        console.log('git Repo Record Id ='+this.gitRepoRecordId);
        
    }


    //Proceed Button Handler
    @api bol = false;


// Data Table / Popup JS  starts
    draftValues=[];
    columns = columns;
    selectedGitBranchesRecords
    selectedGitBranchesRecordsCount
    totalGitBranchesRecords
    result
    error

    userStoryFeatureRecordList
    showSpinnerFlag = false

    gitBranchesRecordList

    @track selectedOption
    
    showFeatureDataTable = false;
    showSelectedFeatureDataTableFlag = false;

   /* changeHandler(event) {
        const field = event.target.name;
        if (field === 'Branches') {
            this.selectedOption = event.target.value;
                console.log("you have selected : "+this.selectedOption);

            
                if(this.selectedOption == 'User Story'){
                    this.objectNameReceived = this.objUserStory;
                    console.log('Object Name = '+this.objectNameReceived);
                }

                if(this.selectedOption == 'Promotion Branches'){
                    this.objectNameReceived = this.objSteps;
                    console.log('Object Name = '+this.objectNameReceived);
                }
            } 
    }
*/
    
    get optionsBranchType() {
        return [
          { label: 'User Story', value: 'UserStory' },
          { label: 'Promotion Branches', value: 'PromotionBranches' },
          
        ];
        }

     handleChangeBranchType(e){
            this.value = e.detail.value;

            if(this.value == 'UserStory'){
                this.objectNameReceived = this.objUserStory;
                console.log('Object Name = '+this.objectNameReceived);
            }
            if(this.value == 'PromotionBranches'){
                this.objectNameReceived = this.objSteps;
                console.log('Object Name = '+this.objectNameReceived);
            }
        }

    show3MonthButton2=true
    show6MonthButton2 = true

    show3MonthBrandButton2 = false
    show6MonthBrandButton2 = false

    gitMonths

    threeMonthHandler2(){

       this.show3MonthButton2 = false;
       this.show3MonthBrandButton2 = true;

       this.show6MonthBrandButton2 = false;
       this.show6MonthButton2 = true;

       this.gitMonths=3 
        console.log('Months= '+this.gitMonths);

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
        });
}

    threeMonthBrandHandler2(){

        this.show3MonthBrandButton2 = false;
        this.show3MonthButton2 = true;

        this.gitMonths=3 
        console.log('Months= '+this.gitMonths);

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
 
        });
        console.log('apiKeyVarafter= '+this.apiKeyVar);
        console.log('ServerVarafter= '+this.serverUrlVar);
        console.log('popup show = '+this.bol);
        
    }

     sixMonthHandler2(){
        this.show6MonthButton2 = false;
        this.show3MonthBrandButton2= false;
        this.show3MonthButton2 = true;
       this.show6MonthBrandButton2 = true;

       this.gitMonths=6
        console.log('Months= '+this.gitMonths);

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

           
        });

}

    sixMonthBrandHandler2(){
        this.show6MonthBrandButton2 = false;
        this.show6MonthButton2 = true;
        
        this.gitMonths=6
        console.log('Months= '+this.gitMonths);

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

           
        });
        console.log('apiKeyVarafter= '+this.apiKeyVar);
        console.log('ServerVarafter= '+this.serverUrlVar);
       
        console.log('popup show = '+this.bol);
    }

    showRunNowButton2 = true
    showScheduledButton2 = true

    showRunNowhBrandButton2 = false
    showScheduledBrandButton2 = false

    showBranchDataTableOnRunNowButton = false;
    showBranchSchedulePageOnScheduleButton = false

    RunNowHandler2(){

        this.showRunNowButton2 = false;
        this.showRunNowhBrandButton2 = true;
        
        this.showScheduledBrandButton2 = false;
        this.showScheduledButton2 = true;
        this.showBranchDataTableOnRunNowButton=true;


        this.showRunPathFlag = true;
        this.showScheduledPathFlag = false;

        this.selectedStep = 'Entity Selection';
    }


    RunNowBrandHandler2(){
        this.showRunNowhBrandButton2 = false;
        this.showRunNowButton2 = true;
        this.showScheduledBrandButton2 = false;
        this.showScheduledButton2 = true;

        this.showRunPathFlag = true;
        this.showScheduledPathFlag = false;

        this.selectedStep = 'Entity Selection';
    }


    scheduledPageHandler2(){
        this.showScheduledButton2 = false;
        this.showRunNowhBrandButton2 = false;
        this.showRunNowButton2 = true;
        this.showScheduledBrandButton2 = true;
        this.showBranchSchedulePageOnScheduleButton=true

        this.showScheduledPathFlag = true;
        this.showRunPathFlag = false;
    }

    scheduledPageBrandHandler2(){

        this.showRunNowhBrandButton2 = false;
        this.showRunNowButton2 =true;
            
        this.showScheduledBrandButton2 = false;
        this.showScheduledButton2 = true;

        this.showScheduledPathFlag = true;
        this.showRunPathFlag = false;

    }

    handlePrevGitScreen2(){
                this.firstRadioFlag = true;
                this.GitBranchesButton = false;
                this.showSelectedFeatureDataTableFlag = false;
        
                this.selectedStep = 'Cleanup Operation';

            /*  var getselectedStep = this.selectedStep;
                    if(this.firstRadioFlag==true){
                            if(getselectedStep === 'Entity Selection'){
                                this.selectedStep = 'Cleanup Operation';
                            }
                }
                if(this.showBranchSchedulePageOnScheduleButton ==true){
                            if(getselectedStep === 'Scheduled'){
                                this.selectedStep = 'Entity Selection';
                            }
                }*/
                eval("$A.get('e.force:refreshView').fire();");
    }

    gitBranchesRecordList
   

    handleNextGitScreen2(){
       

           if(this.apiKeyVar != '' && this.serverUrlVar!= '' && (this.show3MonthBrandButton2 == true || this.show6MonthBrandButton2 == true) && this.gitRepoRecordId != null && (this.showRunNowhBrandButton2 == true || this.showScheduledBrandButton2 == true)){
                            this.showFeatureDataTable = true;
                            this.GitBranchesButton = false;
                            this.showDataTable =false;

                            if(this.showRunNowhBrandButton2==true){
                                this.showFeatureDataTable=true
                                this.selectedDataTableFlag = false
                                this.showScheduleBranchFlag=false
                                this.columns=columnsFeatureBranchRecord;

                                var getselectedStep = this.selectedStep;
                                        if(getselectedStep === 'Entity Selection'){
                                            this.selectedStep = 'Data Selection';
                                            this.showScheduleBranchFlag=false;
                                            this.showFeatureDataTable=true;
                                        }
                            }
                            if(this.showScheduledBrandButton2==true){
                                this.showScheduleBranchFlag=true
                                this.showFeatureDataTable=false

                                var getselectedStep = this.selectedStep;
                                if(getselectedStep === 'Entity Selection'){
                                    this.selectedStep = 'Scheduled';
                                }
                            }
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

                                    
                                            });
                                            console.log('apiKeyVarafter= '+this.apiKeyVar);
                                            console.log('ServerVarafter= '+this.serverUrlVar);
                                            
                                            this.showSpinnerFlag = true;

                                    if(this.objectNameReceived=='copado__User_Story__c')
                                           getuserStoryBranchRecord({months:this.gitMonths})
                                                                    .then( (result) => {
                                                                        this.showSpinnerFlag = false;
                                                                        this.result = result;
                                                                        this.error = undefined
                                                                        console.log(this.result );
                                                                        this.gitBranchesRecordList = result;
                                                                        this.totalRecords = result.length;
                                                            
                                                            })
                                                                    .catch( (error) => {
                                                                    this.result = undefined;
                                                                    this.error = error;
                                                                    console.log(this.error);
                                                            })
                                                            
                                                           
                                                            this.columns=columnsFeatureBranchRecord;
                                                            
                                    if(this.objectNameReceived=='copado__Step__c'){

                                    getStepObjectRecordList({months:this.gitMonths})
                                                            .then( (result) => {
                                                                this.showSpinnerFlag = false;
                                                                this.result = result;
                                                                this.error = undefined
                                                                console.log(this.result );
                                                                this.gitBranchesRecordList = result;
                                                                this.totalRecords = result.length;
                                                    
                                                    })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                            console.log(this.error);
                                                    })
                                                    this.columns=columnsPromotionBranchRecord;

                                                    }  
                                                this.showPopupModel=this.bol;
                      }
                      else{
                        this.showErrorToast2ndScreen();
                      }

                      
    }

    gitselectedRecordsId
    gitselectedRecordsCount = '0'
    gitselectedRecords

    //data table
    selectedRecordsHandler(event){
            const selectedRows  =   event.detail.selectedRows;
            console.log("Selected Rows = "+selectedRows)
            this.gitselectedRecordsCount = event.detail.selectedRows.length;
        
            this.gitselectedRecords = selectedRows;
            console.log("git selectedRecords = "+this.gitselectedRecords);
        
            let recordsSets = new Set();
        
            // getting selected record id
            for (let i = 0; i < selectedRows.length; i++) {
                recordsSets.add(selectedRows[i].Id);
            }
        
            // coverting to array
            this.gitselectedRecordsId = Array.from(recordsSets);
    }

    handlePrevGitScreen3(){
        this.showFeatureDataTable = false;
        this.GitBranchesButton = true;
        this.showSelectedFeatureDataTableFlag = false;
    
        var getselectedStep = this.selectedStep;
            if(getselectedStep === 'Data Selection'){
                this.selectedStep = 'Entity Selection';
            }
    }

    sObjectSelectedGitRecordList
    totalselectedGitRecords

    handleNextGitScreen3(){
         if(this.gitselectedRecordsCount > 0) {         
                    this.showSelectedFeatureDataTableFlag = true;
                    this.showFeatureDataTable = false;
                
                    this.sObjectSelectedGitRecordList = this.gitselectedRecordsId;
                
                    console.log('** ='+this.sObjectSelectedGitRecordList);
                
                    this.totalselectedGitRecords = this.sObjectSelectedGitRecordList.length;
                
                    if(this.objectNameReceived=='copado__User_Story__c'){
                    this.columns=columnsSelectedFeatureBranchRecord;
                    }
                    if(this.objectNameReceived=='copado__Step__c'){
                    this.columns=columnsSelectedPromotionBranchRecord;
                    }
                
                    var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Data Selection'){
                        this.selectedStep = 'Review Selection';
                    }

                }
                else{
                    this.showErrorToast3ndScreen();
                }
    }

    handlePrevGitScreen4(){
        this.showSelectedFeatureDataTableFlag = false;
        this.showFeatureDataTable = true;

        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Review Selection'){
            this.selectedStep = 'Data Selection';
        }
    }

    async gitDeleteHandler(){
        const result = await LightningConfirm.open({
            message: 'The Action about to be executed cannot be halted or reverted once the job has been triggered. ',
            variant: 'Destructive',
            label: 'Conformation Massage',
            
        });
   
        console.log('I m in delete JS');
        console.log('this.sObjectSelectedGitRecordList'+this.sObjectSelectedGitRecordList);
        console.log('gitRepositoryObject'+this.gitRepositoryObject);
        console.log('Record Id ='+this.gitRepoRecordId);
        console.log('serverUrlVar'+this.serverUrlVar);
        console.log('apiKeyVar'+this.apiKeyVar);
        
    if(this.objectNameReceived=='copado__User_Story__c'){
                practiceFeatureMethod({recordIdList: this.sObjectSelectedGitRecordList, serverURL : this.serverUrlVar, repositoryId : this.gitRepoRecordId , copadoAPIKey : this.apiKeyVar ,keepThoseBranches : this.BranchToBeList})
                                            .then((result) => {
                                            this.result = result;
                                            this.showSuccessToast3();
                                            this.showSpinnerFlag = false;
                                            this.showSelectedFeatureDataTableFlag=false;
                                            this.firstRadioFlag = true;
                                            
                                        })
                                        .catch((error) => {
                                            console.log(error)
                                            this.error = error;
                                            this.showErrorToast3();
                                        });
                        }
     if(this.objectNameReceived=='copado__Step__c'){
                practicePromotionRecord({recordIdList : this.sObjectSelectedGitRecordList,repositoryId:this.gitRepoRecordId,serverURL:this.serverUrlVar,copadoAPIKey:this.apiKeyVar, keepThoseBranches : this.BranchToBeList})
                                            .then((result) => {
                                            this.result = result;
                                            this.showSuccessToast3();
                                            this.showSpinnerFlag = false;
                                            this.showSelectedFeatureDataTableFlag=false;
                                            this.firstRadioFlag = true;
                                            
                                        })
                                        .catch((error) => {
                                            console.log(error)
                                            this.error = error;
                                            this.showErrorToast3();
                                        });
                    }
   
                    var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Review Selection'){
                        this.selectedStep = 'Cleanup Operation';
                        
                    }
                    
   }
    
    showSuccessToast3() {
        const evt = new ShowToastEvent({
                                            title: 'Message',
                                            message: this.result,
                                            variant: 'success',
                                            mode: 'dismissable'
                                        });
                                        this.dispatchEvent(evt);
    }
    
    showErrorToast3() {
        const evt = new ShowToastEvent({
                                          title: 'Toast Error',
                                          message: 'Give Correct Input',
                                          variant: 'error',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                                  }

    handlePrevGitSchedule(){
        this.showScheduleBranchFlag = false;
        this.GitBranchesButton = true;
        this.showRunNowhBrandButton2 = false;
        this.selectedStep = 'Entity Selection';
    }

    scheduleBranchApexJob(){
                              console.log('On schedule button click Month= '+this.gitMonths)
                              console.log('On schedule button click cron= '+this.cron)
                              console.log('On schedule button click jobname= '+this.scheduleJobName)
                              console.log('On schedule button click object name= '+this.objectNameReceived)
                              console.log('repository Id ='+this.gitRepoRecordId )
                              console.log('apiKey ='+this.apiKeyVar )
                              console.log('serverUrl ='+this.serverUrlVar )
                              console.log('branchTobe ='+this.BranchToBeList )
                          
                        if(this.objectNameReceived=='copado__User_Story__c'){
                                    callFeatureScheduleClass({month:this.gitMonths, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.gitRepoRecordId , copadoAPIKey:this.apiKeyVar , serverURL:this.serverUrlVar , keepThoseBranches:this.branchToBeVar})
                                                                .then((result) => {
                                                                    console.log(result)
                                                                    this.showSuccessToast();      
                                                                    this.error = undefined;
                                                                    this.showScheduleBranchFlag = false;
                                                                    this.firstRadioFlag = true;
                                                                    this.showRunPathFlag = true;
                                                                    this.showScheduledPathFlag = false;
                                                                    this.selectedStep = 'Cleanup Operation';
                                                                  
                                                                })
                                                                .catch((error) => {
                                                                    console.log(error)
                                                                    this.error = error;
                                                                    this.result = undefined;
                                                                    this.showErrorToast();
                                                                });
                                
                        }
                        
                    if(this.objectNameReceived=='copado__Step__c'){
                                    callPromotionScheduleClass({month:this.gitMonths, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.gitRepoRecordId , copadoAPIKey:this.apiKeyVar , serverURL:this.serverUrlVar , keepThoseBranches:this.branchToBeVar })
                                                              .then((result) => {
                                                                  console.log(result)
                                                                  this.showSuccessToast();      
                                                                  this.error = undefined;
                                                                  this.showScheduleBranchFlag = false;
                                                                  this.firstRadioFlag = true;
                                                                  this.showRunPathFlag = true;
                                                                  this.showScheduledPathFlag = false;
                                                                  this.selectedStep = 'Cleanup Operation';
                                                              })
                                                              .catch((error) => {
                                                                  console.log(error)
                                                                  this.error = error;
                                                                  this.result = undefined;
                                                                  this.showErrorToast();
                                                              });
                                
                        }
          
    }
    showSuccessToast() {
        const evt = new ShowToastEvent({
                                            title: 'Message',
                                            message: 'Successfully Scheduled...!!!',
                                            variant: 'success',
                                            mode: 'dismissable'
                                        });
                                        this.dispatchEvent(evt);
      }
    
      showErrorToast() {
        const evt = new ShowToastEvent({
                                          title: 'Toast Error',
                                          message: 'Please fill all Required value...!!!',
                                          variant: 'error',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
                         }
        
                  /*   @track allActiveData    
                         @wire(getuserStoryBranchRecord, {months : 'gitMonths'})
                         userStoryResults({data,error}){
                            if(data){
                                console.log(data);
                                this.allActiveData = data.map(
                                    {"copado__Project__c.Name" : record.copado__Project__c.Name , "copado__Environment__c.Name" : record.copado__Environment__c.Name}
                                )
                            }
                            if(error){
                                console.error(error);
                                this.allActiveData = undefined;
                            }
                         }*/

            showOnArchieved = false 
            showDataTableArchived = false
            
            handleArchived(){
                   
                    console.log('I am in Next Screen 1 git');
                    this.showOnArchieved =true;
                    this.firstRadioFlag = false;
                

                    var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Cleanup Operation'){
                        this.selectedStep = 'Entity Selection';
                    }
             }

     

           handlePrevArchived2(){

                        console.log('I am in Previous Screen 2');
                        this.firstRadioFlag = true;
                        this.showOnArchieved = false;
                        
                        var getselectedStep = this.selectedStep;
                        //this.selectedStep = 'Cleanup Operation';
                    if(this.firstRadioFlag==true){
                                    if(getselectedStep === 'Entity Selection'){
                                        this.selectedStep = 'Cleanup Operation';
                                    }
                        }
                        if(this.showSchedulePageOnScheduleButton==true){
                                    if(getselectedStep === 'Scheduled'){
                                        this.selectedStep = 'Entity Selection';
                                    }
                        }
           } 

           handleNextArchived2(){

            console.log('I am in Next Screen Archived 2');
            if((this.show3MonthBrandButton == true || this.show6MonthBrandButton == true)  && (this.showRunNowhBrandButton == true || this.showScheduledBrandButton == true)){
                        this.showOnArchieved = false;
                      
                        if(this.showRunNowhBrandButton==true){
                                this.showDataTableArchived=true
                                this.selectedDataTableFlag = false
                                this.showSchedulePage=false
                                this.columns=columnsRecordCleanup1;
    
                                 var getselectedStep = this.selectedStep;
    
                                    if(getselectedStep === 'Entity Selection'){
                                        this.selectedStep = 'Data Selection';
                                        this.showSchedulePage=false;
                                        this.showDataTableArchived=true;
                                    }
                        }
                        if(this.showScheduledBrandButton==true){
                                this.showSchedulePage=true
                                this.showDataTableArchived=false
    
                                var getselectedStep = this.selectedStep;
    
                                        if(getselectedStep === 'Entity Selection'){
                                            this.selectedStep = 'Scheduled';
                                        }
                        }
                       
                        console.log('month ='+this.months);
                        this.showSpinnerFlag = true
                        getsObjectRecordForArchieved({months:this.months})
                                        .then( (result) => {
                                            this.showSpinnerFlag = false
                                            this.result = result;
                                            this.error = undefined
                                            console.log(this.result );
                                            this.sObjectRecordList = result;
                                            this.totalRecordForRecordCleanup = result.length;
    
                                        })
                                        .catch( (error) => {
                                        this.result = undefined;
                                        this.error = error;
                                        console.log(this.error);
                                    })
                                }
                else{
                    this.showErrorToast2ndScreenArchived();
                }
         }


         showErrorToast2ndScreenArchived() {
            const evt = new ShowToastEvent({
                                              title: 'Toast Error',
                                              message: 'Please select all Value for archived ',
                                              variant: 'error',
                                              mode: 'dismissable'
                                          });
                                          this.dispatchEvent(evt);
                             }



         handlePrevScreenArch3(){
                this.showDataTableArchived=false;
                this.showOnArchieved=true;

                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Data Selection'){
                    this.selectedStep = 'Entity Selection';
                }
         }
        }