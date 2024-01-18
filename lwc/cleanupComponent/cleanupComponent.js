import { LightningElement,track,api} from 'lwc';
import getsObjectRecord from "@salesforce/apex/CentralClass.getsObjectRecord";
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
import archivedRecord from '@salesforce/apex/CentralClass.archivedRecord'
import ArchivedIcon from '@salesforce/resourceUrl/ArchivedIcon';
import callwrapperClassCleanup from '@salesforce/apex/CentralClass.callwrapperClassCleanup';
import callArchivedScheduleClass from '@salesforce/apex/CentralClass.callArchivedScheduleClass';
import fetchChildObject from '@salesforce/apex/CentralClass.fetchChildObject';
import getSelectedParentrecords from '@salesforce/apex/CentralClass.getSelectedParentrecords';
import getSelectedUSBranches from '@salesforce/apex/CentralClass.getSelectedUSBranches';
import getSelectedPromoBranches from '@salesforce/apex/CentralClass.getSelectedPromoBranches';
import getSelectedArchRecord from '@salesforce/apex/CentralClass.getSelectedArchRecord';
import getsObjectRecordForUnArchieved from '@salesforce/apex/CentralClass.getsObjectRecordForUnArchieved';
import getSelectedUnArchRecord from '@salesforce/apex/CentralClass.getSelectedUnArchRecord';
import unArchivedRecord from '@salesforce/apex/CentralClass.unArchivedRecord';
import callUnArchivedScheduleClass from '@salesforce/apex/CentralClass.callUnArchivedScheduleClass';

const columns=[];
const  columnsRecordCleanup1 = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate',type: 'date',
                typeAttributes: {
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
       }
    },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate',type: 'date',
                typeAttributes: {
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                }
    },
    { label: 'Status', fieldName: 'copado__Status__c'},
];
const  columnsSelectedRecordParent = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate',type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    }},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate',type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    }},
    { label: 'Status', fieldName: 'copado__Status__c'},
];
const  columnsDefault = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Created Date', fieldName: 'CreatedDate',type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    }},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate',type: 'date',
    typeAttributes: {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    }}
];
const  columnsSelectedRecordCleanup = [
    { label: 'Id', fieldName: 'Id' , type: 'string'},
    { label: 'Name', fieldName: 'name' , type: 'string'},
    { label: 'parent', fieldName: 'parent' , type: 'string'},
    { label: 'ParentType', fieldName: 'parentType' , type: 'string'},
    { label: 'Type', fieldName: 'type' , type: 'string'},
];  
const  columnsFeatureBranchRecord = [
    { label: 'User Story Name', fieldName: 'Name'},
    { label: 'View in Git', fieldName: 'BranchName__c'},
    { label: 'Project', fieldName: 'Project_Name__c'},
    { label: 'Release', fieldName: 'Release_Name__c'},
    { label: 'Enviornment', fieldName: 'Environment_Name__c'},
    { label: 'Status', fieldName: 'copado__Status__c'},
  ];
  const  columnsSelectedFeatureBranchRecord = [
    { label: 'User Story Name', fieldName: 'Name'},
    { label: 'View in Git', fieldName: 'BranchName__c'},
    { label: 'Project', fieldName: 'Project_Name__c'},
    { label: 'Release', fieldName: 'Release_Name__c'},
    { label: 'Enviornment', fieldName: 'Environment_Name__c'},
    { label: 'Status', fieldName: 'copado__Status__c'},
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
    @track scheduleJobName = '';
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

    get Archived(){
        return ArchivedIcon;
    }
///////////////// for 1st Screen Methods And Variables for Record Cleanup //////////////

    firstRadioFlag = true
    selectObjectFlag = false
    value = [];
    @track checkCC= false;
    @track checkFA= false;
    @track checkAR= false;

    showCCInfo1(){
        this.checkCC = false;
        if(this.checkCC==false){
            this.template.querySelector('.data-1').innerText = 'This Utility helps to keep your Copado Records clean.';
    }
    }
    showCCInfo2(){
        this.checkCC = true;
        if(this.checkCC == true){
            this.template.querySelector('.data-1').innerText = 'This Utility helps to keep your Copado Records clean by deleting unwanted attachments, deployment failure records, validation, and successful promotion branches. ';
     }
    }

    showFAInfo1(){
        this.checkFA = false;
        if(this.checkFA==false){
            this.template.querySelector('.data-2').innerText = 'This Utility helps to keep your Copado Git Branches clean.';
        }
    }
    showFAInfo2(){
        this.checkFA = true;
        if(this.checkFA == true){
            this.template.querySelector('.data-2').innerText = 'This Utility helps to keep your Copado Git Branches clean.';
            
        }
    }
    showARInfo1(){
        this.checkAR = false;
        if(this.checkAR==false){
            this.template.querySelector('.data-3').innerText = 'This Utility helps to keep your User Story Records.';
       }
    }
    showARInfo2(){
        this.checkAR = true;
        if(this.checkAR == true){
            this.template.querySelector('.data-3').innerText = 'This Utility helps to keep your User story records archived. And User cannot delete these archival records. ';
       }
    }
///// Next Screen 1 /////
     handleNextScreen1(){
            this.selectObjectFlag = true;
            this.firstRadioFlag = false;
            var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Cleanup Operation'){
                    this.selectedStep = 'Entity Selection';
                }
    }

    handleNextScreen1git(){
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
    //selection for select Object Flag for Record Cleanup 
    objectName 
    ObjectLabel = 'Copado User Story'

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
    objPromotion ='copado__Promotion__c'

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
    objPromotionLable = 'Promotion'

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
    promotion= false

    childObjectListPopup = false
    @api childObjectList

    @track options = [
            { label: 'Copado User Story', value: 'copado__User_Story__c' ,disabled: false },
            { label: 'Copado User Story Task', value: 'copado__User_Story_Task__c' , disabled: false },
            { label: 'Copado Deployment Task', value: 'copado__Deployment_Task__c' , disabled: false},
            { label: 'Copado User Story Commits', value: 'copado__User_Story_Commit__c' , disabled: false},
            { label: 'Copado User Story Metadata', value: 'copado__User_Story_Metadata__c' , disabled: false},
            { label: 'Copado User Story Data Commits', value: 'copado__User_Story_Data_Commit__c' , disabled: false},
            { label: 'Copado Pull Request', value: 'copado__Pull_Request__c' , disabled: false},
            { label: 'Copado Static Code Analysis Results', value: 'copado__Static_Code_Analysis_Result__c', disabled: false },
            { label: 'Copado Promoted User Story', value: 'copado__Promoted_User_Story__c' , disabled: false},
            { label: 'Copado Deployments', value: 'copado__Deployment__c' , disabled: false},
            { label: 'Copado Step', value: 'copado__Step__c' , disabled: false},
            { label: 'Copado Deployment Job', value: 'copado__Deployment_Job__c' , disabled: false},
            { label: 'Copado Compilance Scan Result', value: 'copado__Compliance_Scan_Result__c' , disabled: false},
            { label: 'Promotion', value: 'copado__Promotion__c', disabled: false },
        ];
   
     handleChange(event){
                            const selectedValue = event.target.value;
                            this.options = this.options.map(option => {
                            if (option.value === selectedValue) {
                                option.disabled = false;
                            } else if (!event.target.checked) {
                                option.disabled = false;
                            } else {
                                option.disabled = true;
                            }
                            return option;
                            });
                            if (selectedValue == 'copado__User_Story__c'){
                                this.userStoryValue = true;
                                this.objectName = this.objUserStory;
                                this.ObjectLabel = this.objUserStoryLable;
                            }else{
                                this.userStoryValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
                          if (selectedValue == 'copado__User_Story_Task__c'){
                                    this.userStoryTaskValue = true;
                                    this.objectName = this.objUserStoryTask;
                                    this.ObjectLabel = this.objUserStoryTaskLable;
                                }else{
                                    this.userStoryTaskValue = false;
                                    if(selectedValue ==''){
                                        this.objectName = '';
                                        this.childObjectListPopup = false;
                                }
                    }
                            
                            if (selectedValue == 'copado__Deployment_Task__c'){
                                this.deploymentTaskValue = true;
                                this.objectName = this.objDeployTask;
                                this.ObjectLabel = this.objDeployTaskLable;
                            }else{
                                this.deploymentTaskValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                            if (selectedValue == 'copado__User_Story_Commit__c'){
                                this.userStoryCommitsValue = true;
                                this.objectName = this.objUSCommit;
                                this.ObjectLabel = this.objUSCommitLable;
                            }else{
                                this.userStoryCommitsValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                        if (selectedValue == 'copado__User_Story_Metadata__c'){
                                this.userStoryMetadataValue = true;
                                this.objectName = this.objUSMetadata;
                                this.ObjectLabel = this.objUSMetadataLable;
                            }else{
                                this.userStoryMetadataValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                        if (selectedValue == 'copado__User_Story_Data_Commit__c'){
                                this.userstoryDataCommitsValue = true;
                                this.objectName = this.objUSDataCommit;
                                this.ObjectLabel = this.objUSDataCommitLable;
                            }else{
                                this.userstoryDataCommitsValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                            if (selectedValue == 'copado__Pull_Request__c'){
                                this.pullRequestValue = true;
                                this.objectName = this.objPullRequest;
                                this.ObjectLabel = this.objUserStoryLable;
                            }else{
                                this.pullRequestValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                        if (selectedValue == 'copado__Static_Code_Analysis_Result__c'){
                                this.staticCodeAnalysisResultsValue = true;
                                this.objectName = this.objStaticCode;
                                this.ObjectLabel = this.objStaticCodeLable;
                            }else{
                                this.staticCodeAnalysisResultsValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                            if (selectedValue == 'copado__Promoted_User_Story__c'){
                                this.promotedUserStoryValue = true;
                                this.objectName = this.objPromotedUser;
                                this.ObjectLabel = this.objPromotedUserLable;
                            }else{
                                this.promotedUserStoryValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
                        if (selectedValue == 'copado__Deployment__c'){
                                this.deploymentsValue = true;
                                this.objectName = this.objDeployments;
                                this.ObjectLabel = this.objDeploymentsLable;
                                

                            }else{
                                this.deploymentsValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
                            if (selectedValue == 'copado__Step__c'){
                                this.stepValue = true;
                                this.objectName = this.objSteps;
                                this.ObjectLabel = this.objStepsLable;
                            }else{
                                this.stepValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
                        if (selectedValue == 'copado__Deployment_Job__c'){
                                this.deploymentJobValue = true;
                                this.objectName = this.objDeployJob;
                                this.ObjectLabel = this.objDeployJobLable;
                            }else{
                                this.deploymentJobValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
                        if (selectedValue == 'copado__Compliance_Scan_Result__c'){
                                this.compilanceScanResultValue = true;
                                this.objectName = this.objComplianceScanResult;
                                this.ObjectLabel = this.objComplianceScanResultLable;
                            }else{
                                this.compilanceScanResultValue = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }

                            if (selectedValue == 'copado__Promotion__c'){
                                this.promotion = true;
                                this.objectName = this.objPromotion;
                                this.ObjectLabel = this.objPromotionLable;
                            }else{
                                this.promotion = false;
                                if(selectedValue ==''){
                                    this.objectName = '';
                                    this.childObjectListPopup = false;
                            }
                    }
    }

     cancelHandler(){
             this.childObjectListPopup = false; 
             this.firstRadioFlag = false;
             this.selectObjectFlag = true;
     }

     okayHandler(){
        this.childObjectListPopup = false;
       
            if(this.showRunNowhBrandButton==true){
                    this.showDataTable=true
                    this.selectedDataTableFlag = false
                    this.selectObjectFlag = false
                    this.showSchedulePage=false
                    this.columnsq=columnsRecordCleanup1;

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
                    this.selectObjectFlag = false

                    var getselectedStep = this.selectedStep;

                            if(getselectedStep === 'Entity Selection'){
                                this.selectedStep = 'Scheduled';
                            }
            }
            
            this.showSpinnerFlag = true
            getsObjectRecord({months:this.months,objectName:this.objectName})
                            .then( (result) => {
                                this.showSpinnerFlag = false
                                this.error = undefined
                                this.sObjectRecordList = result;
                                this.totalRecordForRecordCleanup = result.length;
                                this.totalRecountCount1= this.totalRecordForRecordCleanup ;
                                this.totalPage1 = Math.ceil(this.totalRecountCount1 / this.pageSize1);
                                this.recordsToDisplay1 = this.sObjectRecordList.slice(0, this.pageSize1);
                                this.endingRecord1 = this.pageSize1;
                                this.pageSize1= this.pageSizeOptions1[0]; //set pageSize with default value as first option
                            })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                        })
     }

      //selection for 3months 6 months for Record Cleanup

    months
    show3MonthButton=true
    show6MonthButton = true
    show3MonthBrandButton = false
    show6MonthBrandButton = false
    show12MonthButton = true
    show12MonthBrandButton = false

    threeMonthHandler(){
                this.show3MonthButton = false;
                this.show3MonthBrandButton = true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;

                this.show12MonthButton = true;
                this.show12MonthBrandButton = false;

                this.months=3 
    }

    threeMonthBrandHandler(){
                this.show3MonthBrandButton = false;
                this.show3MonthButton = true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;
                this.show12MonthButton = true;
                this.show12MonthBrandButton = false;
                this.months=3 
    }

    sixMonthHandler(){
                this.show6MonthButton = false;
                this.show3MonthBrandButton = false;
                this.show3MonthButton = true;
                this.show6MonthBrandButton = true;
                this.show12MonthButton = true;
                this.show12MonthBrandButton = false;
                this.months=6
    }


    sixMonthBrandHandler(){
                this.show3MonthBrandButton = false;
                this.show3MonthButton =true;
                this.show6MonthBrandButton = false;
                this.show6MonthButton = true;
                this.show12MonthButton =true;
                this.show12MonthBrandButton = false;
                this.months=6
    }


    twelveMonthHandler(){
        this.show6MonthButton = true;
        this.show3MonthBrandButton = false;
        this.show3MonthButton = true;
        this.show6MonthBrandButton = false;
        this.show12MonthButton = false;
        this.show12MonthBrandButton = true;
        this.months=12
    }

    twelveMonthBrandHandler(){
        this.show6MonthButton = true;
        this.show3MonthBrandButton = false;
        this.show3MonthButton = true;
        this.show6MonthBrandButton = false;
        this.show12MonthButton = true;
        this.show12MonthBrandButton = false;
        this.months=12
    }

    // selection for Run Now and Scheduled for Record Cleanup 
    showRunNowButton = true
    showRunNowhBrandButton = false

    showScheduledButton = true
    showScheduledBrandButton = false

    showSchedulePageOnScheduleButton = false

    RunNowHandler(){
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
                this.showRunNowhBrandButton = false;
                this.showRunNowButton = true;
                this.showScheduledBrandButton = false;
                this.showScheduledButton = true;

                this.showRunPathFlag = true;
                this.showScheduledPathFlag = false;
                this.selectedStep = 'Entity Selection';
     }

    scheduledPageHandler(){
        
                this.showScheduledButton = false;
                this.showRunNowhBrandButton = false;
                this.showRunNowButton = true;

                this.showScheduledBrandButton = true;
                this.showSchedulePageOnScheduleButton=true

                this.showScheduledPathFlag = true;
                this.showRunPathFlag = false;
     }

    scheduledPageBrandHandler(){
        
                this.showRunNowhBrandButton = false;
                this.showRunNowButton =true;
                    
                this.showScheduledBrandButton = false;
                this.showScheduledButton = true;

                this.showScheduledPathFlag = true;
                this.showRunPathFlag = false;
     }

    // prev & next for Screen 2

    sObjectRecordList
    totalRecordForRecordCleanup

    handlePrevScreen2(){
                    this.firstRadioFlag = true;
                    this.selectObjectFlag = false;
                    
                    var getselectedStep = this.selectedStep;
                    
                if(this.firstRadioFlag==true){
                                if(getselectedStep === 'Entity Selection'){
                                      this.selectedStep = 'Cleanup Operation';
                                      eval("$A.get('e.force:refreshView').fire();");
                                }
                    }
                    if(this.showSchedulePageOnScheduleButton==true){
                                if(getselectedStep === 'Scheduled'){
                                      this.selectedStep = 'Entity Selection';
                                      eval("$A.get('e.force:refreshView').fire();");
                                }
                    }
    }

    childObjectListPopup;

    handleNextScreen2(){
        if(this.objectName==''){
            
            this.showErrorToast2ndScreen();
        }
        else{
            
            if((this.show3MonthBrandButton == true || this.show6MonthBrandButton == true || this.show12MonthBrandButton == true) && this.objectName!= null && (this.showRunNowhBrandButton == true || this.showScheduledBrandButton == true)){
        
                    fetchChildObject({objectName:this.objectName})
                                    .then( (result) => {
                                        this.error = undefined
                                        this.childObjectList = result;
                                        if(result.length > 0){
                                              this.childObjectListPopup = true;
                                        }
                                        else{
                                            this.childObjectListPopup = false;
  
                                            if(this.showRunNowhBrandButton==true){
                                                this.showDataTable=true
                                                this.selectedDataTableFlag = false
                                                this.selectObjectFlag = false
                                                this.showSchedulePage=false
                                                this.columnsq=columnsRecordCleanup1;
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
                                                this.selectObjectFlag = false
                                                
                                                var getselectedStep = this.selectedStep;
                                                        if(getselectedStep === 'Entity Selection'){
                                                            this.selectedStep = 'Scheduled';
                                                        }
                                        }

                                            this.showSpinnerFlag = true
                                            getsObjectRecord({months:this.months,objectName:this.objectName})
                                                            .then( (result) => {
                                                                this.showSpinnerFlag = false
                                                                if(this.objectName =='Copado__User_Story__c'){
                                                                    this.columnsp=columnsSelectedRecordParent;
                                                                }
                                                                else{
                                                                    this.columnsp = columnsDefault;
                                                                }
                                                                this.error = undefined
                                                                this.sObjectRecordList = result;
                                                                this.totalRecordForRecordCleanup = result.length;
                                                                this.totalRecountCount1 = this.totalRecordForRecordCleanup
                                                                this.totalPage1 = Math.ceil(this.totalRecountCount1 / this.pageSize1);
                                                                //here we slice the data according page size
                                                                this.recordsToDisplay1 = this.sObjectRecordList.slice(0, this.pageSize1);
                                                                this.endingRecord1 = this.pageSize1;
                                                                this.pageSize1= this.pageSizeOptions1[0]; //set pageSize with default value as first option
                                
                                                            })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                        })
                                        }
                                    })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                })
                }
                else{
                    this.showErrorToast2ndScreen();
                }                
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
columnsp;
columnsq;

showSpinnerFlag = false
selectedRecordsCount1 = 0
totalRecordForRecordCleanup
selectedRecords

selectedRecordsHandler1(event){
    let updatedItemsSet = new Set();

        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRows1);
        // List of items currently loaded for the current view.

        let loadedItemsSet = new Set();
        this.recordsToDisplay1.map((ele) => {
            loadedItemsSet.add(ele.Id);

        });

        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });

            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }

        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });
        this.selectedRows1 = [...selectedItemsSet];
        this.selectedRecordsCount1 = this.selectedRows1.length;
}
 /////// prev & next for Screen 3 ///////////
 showDataTable = false 
 selectedDataTableFlag = false

        handlePrevScreen3(){
                this.showDataTable=false;
                this.selectObjectFlag=true;
         
              if(this.showDataTable ==false){
                    this.sObjectRecordList = null;
                    this.selectedRecordsCount1 = 0;
              }

                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Data Selection'){
                    this.selectedStep = 'Entity Selection';
                }
        }

        totalselectedRecords1
        @api sObjSelParentRecordList
        selectedRecordsId 
        @api sObjectRecordPCList
        result1
        totalselectedRecords2
        selectedRowsParent

        handleNextScreen3(){
            this.showSpinnerFlag = true;

                if(this.selectedRecordsCount1 > 0 ){
                             this.showSpinnerFlag = false
                                this.showDataTable=false;
                                this.selectedDataTableFlag = true;
          
            getSelectedParentrecords({objectName:this.objectName,recordIdList:this.selectedRows1})  
                            .then( (result) => {
                                if(this.objectName =='Copado__User_Story__c'){
                                    this.columnsp=columnsSelectedRecordParent;
                                }
                                else{
                                    this.columnsp = columnsDefault;
                                }
                                this.selectedRowsParent = result;
                                this.error = undefined
                                this.totalselectedRecords1 = this.selectedRowsParent.length;
                            }) 
                              
            callwrapperClassCleanup({objectName:this.objectName,recordIdList:this.selectedRows1})
                            .then( (result) => {
                                this.columns=columnsSelectedRecordCleanup;
                                this.error = undefined
                                this.sObjectRecordPCList=[];
                              
                                result.forEach( objWrap=>{
                                    this.sObjectRecordPCList.push({
                                          Id : String(objWrap['id']),
                                          name:String(objWrap['name']),
                                          parent: String(objWrap['parent']),
                                          parentType: String(objWrap['parentType']),
                                          type: String(objWrap['type'])
                                    });
                                });
                            
                                this.totalselectedRecords2 = this.sObjectRecordPCList.length;
                            })
                            .catch( (error) => {
                            this.result = undefined;
                            this.error = error;
                            })

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
                    let text;
                    if (confirm("Do you really want to delete that record ?") == true) {
                        
                        sObjectRecordDeleted({sObjectRecordIdList:this.selectedRows1,objectName:this.objectName})
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
                                               
                                        });
                    
                    } else {
                        text = "You cancelled!";
                        this.selectedDataTableFlag = true;
                    }
                    var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Review Selection'){
                        this.selectedStep = 'Cleanup Operation';
                        //eval("$A.get('e.force:refreshView').fire();");
                    }
        }

        permanantDeleteHandler(){
                    let text;
                    if (confirm("Do you really want to delete that record ?") == true){
                        sObjectRecordHardDeleted({sObjectRecordIdList:this.selectedRows1,objectName:this.objectName})
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
                                        });
                        
                                } else {
                                text = "You cancelled!";
                                this.selectedDataTableFlag = true;
                                }
                                    var getselectedStep = this.selectedStep;
                                    if(getselectedStep === 'Review Selection'){
                                            this.selectedStep = 'Cleanup Operation';
                              }
        }

        getRefeshData(){ 
            this.showSpinnerFlag = true;
            getsObjectRecord({months:this.months,objectName:this.objectName})
                                    .then( (result) => {
                                        this.showSpinnerFlag = false
                                        this.error = undefined
                                        this.sObjectRecordList = result;
                                        this.totalRecordForRecordCleanup = result.length;
                                    })
                                    .catch( (error) => {
                                    this.result = undefined;
                                    this.error = error;
                                })
}


showSuccessToast1() {
    const evt = new ShowToastEvent({
                                        title: 'Message',
                                        message: 'Successfully Deleted',
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
      // Scheduled Job For Record Cleanup Starts                                        
      // 3/6 Months and Daily,Hourly,Weekly Radio button handler

showWeeklyButton=false
showDailyButton=false
showHourlyButton=false
scheduleJobName='';
@track weekdays=[]
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

cron=null

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
                    this.weekdays= ['?']
                    this.cron=null
                    this.numberOfHours=0
                    this.hoursInDay='0/'+this.numberOfHours;
        }else{
                this.hourlyValue = false;
                }


if (this.value == 'DailyValue'){
            this.DailyValue = true;
            this.weekdaysValue = false;
            this.hourlyValue = false;

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

            this.cron=null
            this.weekdays= ['?']
            this.numberOfDays=0
            this.dayOfMonth='1/'+this.numberOfDays;
            this.Hour ='00'
            this.Minut='00'
    }else{
            this.DailyValue = false;
            }

if (this.value == 'WeekdayValue'){
            this.weekdaysValue = true;
            this.hourlyValue = false;
            this.showDailyButton=false

            this.showWeeklyButton=true
            this.showDailyButton=false
            this.showHourlyButton=false
            this.cron=null
            this.dayOfMonth='?'
            this.Hour ='00'
            this.Minut='00'
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
                    
                    if (!this.weekdays.includes('MON')) {
                        this.weekdays.push('MON')
                    } else {
                        this.weekdays.splice(this.weekdays.indexOf('MON'),1);
                    }
             
                   if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }
        }

        tuesdayHandler() {
                this.showTueButton = false;
                this.showTuesBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                
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
                
                if (!this.weekdays.includes('TUE')) {
                    this.weekdays.push('TUE')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('TUE'),1);
                }
               
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }

        }

        wednesdayHandler() {
                this.showWedButton = false;
                this.showWedBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                
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
                
                if (!this.weekdays.includes('WED')) {
                    this.weekdays.push('WED')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('WED'),1);
                } 
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }

        }

        thursdayHandler() {
                this.showThurButton = false;
                this.showThursBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
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
                
                if (!this.weekdays.includes('THU')) {
                    this.weekdays.push('THU')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('THU'),1);
                } 
                //this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }
   }

        fridayHandler() {
                this.showFriButton = false;
                this.showFridayBrandButton = true;

               if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                
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
                
                if (!this.weekdays.includes('FRI')) {
                    this.weekdays.push('FRI')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('FRI'),1);
                } 
                //this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }
        }

        saturdayHandler() {
                this.showSatButton = false;
                this.showSatBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                
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
               
                if (!this.weekdays.includes('SAT')) {
                    this.weekdays.push('SAT')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SAT'),1);
                } 
                //this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }
        }


        sundayHandler() {
                this.showSunButton = false;
                this.showSunBrandButton = true;

                if (this.weekdays.includes('?')) {
                this.weekdays.splice(this.weekdays.indexOf('?'),1);
                }
                
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
                
                if (!this.weekdays.includes('SUN')) {
                    this.weekdays.push('SUN')
                } else {
                this.weekdays.splice(this.weekdays.indexOf('SUN'),1);
                }
                //this.cron=this.sec+' '+this.min+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                if(this.weekdays.length === 0){
                    this.cron = null
                }
                else{
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                }
        }


// DAY MINUTE HOUR HANDLER

    numberOfEveryHoursHandler(evt){
            this.numberOfHours=evt.target.value
            if(this.numberOfHours==0){
                this.cron=null
            }
            else{
                    this.hoursInDay='0/'+this.numberOfHours;
                    this.cron=this.sec+' '+this.min+' '+this.hoursInDay+' '+'1/1'+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
        }
    }

    numberOfDaysHandler(evt){
            this.numberOfDays=evt.target.value
            if(this.numberOfDays==0){
                this.cron=null
            }
            else{
                    this.dayOfMonth='1/'+this.numberOfDays;
                    this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
            } 
    }


    numberOfHoursHandler(evt){
            this.Hour=evt.target.value
            this.hr=this.Hour.toString();
            if(this.hr < 24){
               this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
        }
        else{
            this.showErrorToastCron();
        }
    }


    numberOfMinutesHandler(evt){
            this.Minut=evt.target.value;
            this.min=this.Minut.toString();
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


    scheduleJobNameHandleChange(event) {
            this.scheduleJobName=event.target.value;
            const inputValue = event.target.value;    const pattern = /^[a-zA-Z0-9]+$/;    if (pattern.test(inputValue)) {      this.scheduleJobName = inputValue;    } else {      this.scheduleJobName = '';      alert('Special characters are not allowed in this scheduleJobName field.');    }
    }

    scheduleApexJob(){ 
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

                                if(this.selectedStep = 'Cleanup Operation'){
                                    eval("$A.get('e.force:refreshView').fire();");
                                  }
                            })
                            .catch((error) => {
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
            if(this.objectName == 'copado__User_Story__c'){
                   this.value = 'copado__User_Story__c';
            }
            if(this.objectName == 'copado__User_Story_Task__c'){
                this.value = 'copado__User_Story_Task__c';
            }
            if(this.objectName == 'copado__Deployment_Task__c'){
                this.value = 'copado__Deployment_Task__c';
            }
            if(this.objectName == 'copado__User_Story_Commit__c'){
                this.value = 'copado__User_Story_Commit__c';
            }
            if(this.objectName == 'copado__User_Story_Metadata__c'){
                this.value = 'copado__User_Story_Metadata__c';
            }
            if(this.objectName == 'copado__User_Story_Data_Commit__c'){
                this.value = 'copado__User_Story_Data_Commit__c';
            }
            if(this.objectName == 'copado__Pull_Request__c'){
                this.value = 'copado__Pull_Request__c';
            }
            if(this.objectName == 'copado__Static_Code_Analysis_Result__c'){
                this.value = 'copado__Static_Code_Analysis_Result__c';
            }
            if(this.objectName == 'copado__Promoted_User_Story__c'){
                this.value = 'copado__Promoted_User_Story__c';
            }
            if(this.objectName == 'copado__Deployment__c'){
                this.value = 'copado__Deployment__c';
            }
            if(this.objectName == 'copado__Step__c'){
                this.value = 'copado__Step__c';
            }

            if(this.objectName == 'copado__Deployment_Job__c'){
                this.value = 'copado__Deployment_Job__c';
            }

            if(this.objectName == 'copado__Compliance_Scan_Result__c'){
                this.value = 'copado__Compliance_Scan_Result__c';
            }
            if(this.objectName == 'copado__Promotion__c'){
                this.value = 'copado__Promotion__c';
            }


            if(this.showSchedulePage == false){
                        this.scheduleJobName = null;
                        this.cron='0 0 0/1 1/1 * ? *';
                        this.Minut = 0;
                        this.Hour = 0;
                        this.hourlyValue=false
                        this.DailyValue = false
                        this.weekdaysValue = false
                        
                        this.showWeeklyButton=false
                        this.showDailyButton=false
                        this.showHourlyButton=false

                        this.showMonButton = true
                        this.showTueButton = true
                        this.showWedButton = true
                        this.showThurButton = true
                        this.showFriButton = true
                        this.showSatButton = true
                        this.showSunButton = true

                        this.showMondayBrandButton = false
                        this.showTuesBrandButton = false
                        this.showWedBrandButton = false
                        this.showThursBrandButton = false
                        this.showFridayBrandButton = false
                        this.showSatBrandButton = false
                        this.showSunBrandButton = false

                        this.numberOfHours=1;
                        this.numberOfDays = 1;
            }
            this.showRunNowhBrandButton=false;
            this.selectedStep = 'Entity Selection';
}
/////////////////////// Git Branches Methods and  Variables Starts ////////////////////////////////
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
    }

    //Proceed Button Handler
    @api bol = false;

    handleInput(event) {
        var inputFields=this.template.querySelectorAll("input");
        inputFields.forEach(element=>{
            
            if(element.name=='apiKey'){
                if(element.value != null){
                    this.apiKeyVar = element.value;
                    this.bol =true;
                }
                else{
                    this.showErrorToast();
                    this.bol=false;
                }
            }
        });
        const inputValue = event.target.value;    const pattern = /^[a-zA-Z0-9]+$/;    if (pattern.test(inputValue)) {      this.apiKeyVar = inputValue;    } else {      this.apiKeyVar = '';      alert('Special characters are not allowed in this API Key field.');    }
 }

    handleInputUrl(){
        var inputFields=this.template.querySelectorAll("input");
        inputFields.forEach(element=>{
            
            if(element.name=='serverUrl'){
                if(element.value != null){
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

    @track selectedOption
    
    showFeatureDataTable = false;
    showSelectedFeatureDataTableFlag = false;

    featurebranchFlag = true
    featurebranchBrandFlag = false
    promotionBranchFlag = true
    promotionBranchBrandFlag = false

        featurebranchHandler(){
            this.featurebranchFlag = false;
            this.featurebranchBrandFlag = true;
     
            this.promotionBranchBrandFlag = false;
            this.promotionBranchFlag = true;

            this.objectNameReceived = this.objUserStory;
        }

        featurebranchBrandHandler(){
            this.featurebranchBrandFlag = false;
            this.featurebranchFlag = true;
            this.objectNameReceived = this.objUserStory;
    }

        promotionBranchHandler(){
            this.promotionBranchFlag = false;
            this.featurebranchBrandFlag= false;
            this.featurebranchFlag = true;
           this.promotionBranchBrandFlag = true;

           this.objectNameReceived = this.objSteps;
        }

        promotionBranchBrandHandler(){
            this.promotionBranchBrandFlag = false;
            this.promotionBranchFlag = true;
            this.objectNameReceived = this.objSteps;
    }

    show3MonthButton2=true
    show6MonthButton2 = true

    show3MonthBrandButton2 = false
    show6MonthBrandButton2 = false

    show12MonthButton2 = true
    show12MonthBrandButton2 = false

    gitMonths

    threeMonthHandler2(){

        this.show3MonthButton2 = false;
        this.show3MonthBrandButton2 = true;
        this.show6MonthBrandButton2 = false;
        this.show6MonthButton2 = true;

        this.show12MonthButton2 = true;
        this.show12MonthBrandButton2 = false;

       this.gitMonths=3
}

    threeMonthBrandHandler2(){
        this.show3MonthBrandButton2 = false;
        this.show3MonthButton2= true;
        this.show6MonthBrandButton2 = false;
        this.show6MonthButton2 = true;
        this.show12MonthButton2 = true;
        this.show12MonthBrandButton2 = false;
        this.gitMonths=3 
    }

     sixMonthHandler2(){
                this.show6MonthButton2 = false;
                this.show3MonthBrandButton2= false;
                this.show3MonthButton2 = true;
                this.show6MonthBrandButton2 = true;
                this.show12MonthButton2 = true;
                this.show12MonthBrandButton2= false;

        this.gitMonths=6
}

    sixMonthBrandHandler2(){
        
                this.show3MonthBrandButton2 = false;
                this.show3MonthButton2 =true;
                this.show6MonthBrandButton2 = false;
                this.show6MonthButton2 = true;
                this.show12MonthButton2 =true;
                this.show12MonthBrandButton2 = false;
        
        this.gitMonths=6
    }

    twelveMonthHandler2(){
        
        this.show6MonthButton2 = true;
        this.show3MonthBrandButton2 = false;
        this.show3MonthButton2 = true;
        this.show6MonthBrandButton2 = false;
        this.show12MonthButton2 = false;
        this.show12MonthBrandButton2 = true;

        this.gitMonths=12
    }

    twelveMonthBrandHandler2(){
      
        this.show6MonthButton2 = true;
        this.show3MonthBrandButton2 = false;
        this.show3MonthButton2 = true;
        this.show6MonthBrandButton2 = false;
        this.show12MonthButton2 = true;
        this.show12MonthBrandButton2 = false;

        this.gitMonths=12
    }

    showRunNowButton2 = true
    showScheduledButton2 = true

    showRunNowhBrandButton2 = false
    showScheduledBrandButton2 = false

    showBranchDataTableOnRunNowButton = false;
    showBranchSchedulePageOnScheduleButton = false

    gitBranchesRecordList =[]

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
            
        this.showScheduledBrandButton2 = false
        this.showScheduledButton2 = true;

        this.showScheduledPathFlag = true;
        this.showRunPathFlag = false;
    }

    handlePrevGitScreen2(){
                this.firstRadioFlag = true;
                this.GitBranchesButton = false;
                this.showSelectedFeatureDataTableFlag = false;
        
                this.selectedStep = 'Cleanup Operation';

                eval("$A.get('e.force:refreshView').fire();");
    }

    handleNextGitScreen2(){
           if( this.apiKeyVar != null && this.serverUrlVar != null && (this.show3MonthBrandButton2 == true || this.show6MonthBrandButton2 == true || this.show12MonthBrandButton2 == true) && this.gitRepoRecordId != null && this.gitRepositoryObject != null && (this.showRunNowhBrandButton2 == true || this.showScheduledBrandButton2 == true) && (this.featurebranchBrandFlag == true || this.promotionBranchBrandFlag == true)){
                            this.showFeatureDataTable = true;
                            this.GitBranchesButton = false;
                            this.showDataTable =false;
                            
                            if(this.showRunNowhBrandButton2==true){
                                this.showFeatureDataTable=true
                                this.selectedDataTableFlag = false
                                this.showScheduleBranchFlag=false
                                this.columns=columnsFeatureBranchRecord;
                                            
                            this.showSpinnerFlag = true;

                        if(this.objectNameReceived=='copado__User_Story__c')
                                           getuserStoryBranchRecord({months:this.gitMonths})
                                                                    .then( (result) => {
                                                                        this.showSpinnerFlag = false;
                                                                        this.gitBranchesRecordList = result;
                                                                        this.totalRecords2 = result.length;
                                                                        this.error = undefined;
                                                                        this.totalRecountCount2 = this.totalRecords2
                                                                        this.totalPage2 = Math.ceil(this.totalRecountCount2 / this.pageSize2);
                                                                        //here we slice the data according page size
                                                                        this.recordsToDisplay2 = this.gitBranchesRecordList.slice(0, this.pageSize2);
                                                                        this.endingRecord2 = this.pageSize2;
                                                                        this.pageSize2= this.pageSizeOptions2[0]; //set pageSize with default value as first option
                                                                        this.columns=columnsFeatureBranchRecord;
                                                                        this.error = undefined
                                                            })
                                                                    .catch( (error) => {
                                                                    this.result = undefined;
                                                                    this.error = error;
                                                                    console.log(this.error);
                                                            })
                                                            
                        if(this.objectNameReceived=='copado__Step__c'){
                                    getStepObjectRecordList({months:this.gitMonths})
                                                        .then( (result) => {
                                                            this.showSpinnerFlag = false;
                                                            this.gitBranchesRecordList = result;
                                                            this.totalRecords2 = result.length;
                                                            this.totalRecountCount2 = this.totalRecords2
                                                            this.totalPage2 = Math.ceil(this.totalRecountCount2 / this.pageSize2);
                                                            //here we slice the data according page size
                                                            this.recordsToDisplay2 = this.gitBranchesRecordList.slice(0, this.pageSize2);
                                                            this.endingRecord2 = this.pageSize2;
                                                            this.pageSize2= this.pageSizeOptions2[0]; //set pageSize with default value as first option
                                                            this.columns=columnsPromotionBranchRecord;
                                                            this.error = undefined
                                                    })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                            console.log(this.error);
                                                    })
                                                }  
                                                this.showPopupModel=this.bol;

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
                      }
                      else{
                        this.showErrorToast2ndScreen();
                      }
    }

    gitselectedRecordsId
    gitselectedRecords
    selectedRecordsCount2=0

    //data table
    selectedRecordsHandler2(event){
                let updatedItemsSet = new Set();
                let selectedItemsSet = new Set(this.selectedRows2);// List of selected items we maintain.
                let loadedItemsSet = new Set();// List of items currently loaded for the current view.
                this.recordsToDisplay2.map((ele) => {
                    loadedItemsSet.add(ele.Id);
                });

                if (event.detail.selectedRows) {
                    event.detail.selectedRows.map((ele) => {
                        updatedItemsSet.add(ele.Id);
                    });

                    // Add any new items to the selectedRows list
                    updatedItemsSet.forEach((id) => {
                        if (!selectedItemsSet.has(id)) {
                            selectedItemsSet.add(id);
                        }
                    });
                }

                loadedItemsSet.forEach((id) => {
                    if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                        // Remove any items that were unselected.
                        selectedItemsSet.delete(id);
                    }
                });

                this.selectedRows2 = [...selectedItemsSet];
                this.selectedRecountCount2 = this.selectedRows2.length;
    }

    handlePrevGitScreen3(){
        this.showFeatureDataTable = false;
        this.GitBranchesButton = true;
        this.showSelectedFeatureDataTableFlag = false;

        if(this.showFeatureDataTable == false){
              this.gitBranchesRecordList = null;
              this.selectedRecordsCount2 = 0;
        }
    
        var getselectedStep = this.selectedStep;
            if(getselectedStep === 'Data Selection'){
                this.selectedStep = 'Entity Selection';
            }
    }

    sObjectSelectedGitRecordList
    totalselectedGitRecords

    handleNextGitScreen3(){ 
         if(this.selectedRecountCount2 > 0) {         
                    this.showSelectedFeatureDataTableFlag = true;
                    this.showFeatureDataTable = false;
                    this.sObjectSelectedGitRecordList = this.selectedRows2;
                    this.totalselectedGitRecords = this.sObjectSelectedGitRecordList.length;
                    if(this.objectNameReceived=='copado__User_Story__c'){
                    
                        getSelectedUSBranches({recordIdList:this.selectedRows2})
                                                            .then( (result) => {
                                                                this.showSpinnerFlag = false;
                                                                this.selectedusbranches = result;
                                                                this.columns=columnsSelectedFeatureBranchRecord;
                                                                this.error = undefined;
                                                    })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                    })

                    }
                    if(this.objectNameReceived=='copado__Step__c'){
                    getSelectedPromoBranches({recordIdList:this.selectedRows2})
                                                            .then( (result) => {
                                                                this.showSpinnerFlag = false;
                                                                this.selectedusbranches = result;
                                                                 this.columns=columnsSelectedPromotionBranchRecord;
                                                                this.error = undefined;
                                                    })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                    })
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
        this.showSpinnerFlag = true
        this.showSelectedFeatureDataTableFlag = false;           
        this.showFeatureDataTable = true;
        this.showSpinnerFlag = false 

        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Review Selection'){
            this.selectedStep = 'Data Selection';
        }
    }

    gitDeleteHandler(){
        let text;
        if (confirm("The Action about to be executed cannot be halted or reverted once the job has been triggered.") == true) {

                    if(this.objectNameReceived=='copado__User_Story__c'){
                                practiceFeatureMethod({recordIdList: this.selectedRows2, serverURL : this.serverUrlVar, repositoryId : this.gitRepoRecordId , copadoAPIKey : this.apiKeyVar ,keepThoseBranches : this.BranchToBeList})
                                                            .then((result) => {
                                                            this.result = result;
                                                            this.showSuccessToast3();
                                                            this.showSpinnerFlag = false;
                                                            this.showSelectedFeatureDataTableFlag=false;
                                                            this.firstRadioFlag = true;
                                                            var getselectedStep = this.selectedStep;
                                                            if(getselectedStep === 'Review Selection'){
                                                                this.selectedStep = 'Cleanup Operation';
                                                            }
                                                            
                                                        })
                                                        .catch((error) => {
                                                            this.error = error;
                                                            this.showErrorToast3();
                                                        });
                                        }
                    if(this.objectNameReceived=='copado__Step__c'){
                                practicePromotionRecord({recordIdList : this.selectedRows2,repositoryId:this.gitRepoRecordId,serverURL:this.serverUrlVar,copadoAPIKey:this.apiKeyVar, keepThoseBranches : this.BranchToBeList})
                                                            .then((result) => {
                                                            this.showSpinnerFlag = false;
                                                            this.result = result;
                                                            this.showSuccessToast3();
                                                            this.showSelectedFeatureDataTableFlag=false;
                                                            this.firstRadioFlag = true;
                                                            var getselectedStep = this.selectedStep;
                                                            if(getselectedStep === 'Review Selection'){
                                                                this.selectedStep = 'Cleanup Operation';
                                                            }
                                                            
                                                        })
                                                        .catch((error) => {
                                                            this.error = error;
                                                            this.showErrorToast3();
                                                        });
                                    }
                        }                 
                        else {
                            text = "You cancelled!";
                            if(this.objectNameReceived=='copado__User_Story__c'){
                                this.showSelectedFeatureDataTableFlag=true;
                            }
                            if(this.objectNameReceived=='copado__Step__c'){
                                this.showSelectedFeatureDataTableFlag = true;
                            }
                        }   
        }
    
    showSuccessToast3() {
        const evt = new ShowToastEvent({
                                            title: 'Message',
                                            message: 'Successfully Deleted...!!',
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

        if(this.showScheduleBranchFlag == false){
            this.scheduleJobName = null;
            this.cron=null;
            this.Minut = 0;
            this.Hour = 0;
            this.hourlyValue=false
            this.DailyValue = false
            this.weekdaysValue = false
            
            this.showWeeklyButton=false
            this.showDailyButton=false
            this.showHourlyButton=false


            this.showMonButton = true
            this.showTueButton = true
            this.showWedButton = true
            this.showThurButton = true
            this.showFriButton = true
            this.showSatButton = true
            this.showSunButton = true

            this.showMondayBrandButton = false
            this.showTuesBrandButton = false
            this.showWedBrandButton = false
            this.showThursBrandButton = false
            this.showFridayBrandButton = false
            this.showSatBrandButton = false
            this.showSunBrandButton = false

            this.numberOfHours=1;
            this.numberOfDays = 1;
        }
    }

    scheduleBranchApexJob(){
                        if(this.objectNameReceived=='copado__User_Story__c'){
                                    callFeatureScheduleClass({month:this.gitMonths, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.gitRepoRecordId , copadoAPIKey:this.apiKeyVar , serverURL:this.serverUrlVar , keepThoseBranches:this.branchToBeVar})
                                                                .then((result) => {
                                                                    this.showSuccessToast();      
                                                                    this.error = undefined;
                                                                    this.showScheduleBranchFlag = false;
                                                                    this.firstRadioFlag = true;
                                                                    this.showRunPathFlag = true;
                                                                    this.showScheduledPathFlag = false;
                                                                    this.selectedStep = 'Cleanup Operation';
                                                                    if(this.selectedStep = 'Cleanup Operation'){
                                                                        eval("$A.get('e.force:refreshView').fire();");
                                                                      }
                                                                })
                                                                .catch((error) => {
                                                                    this.error = error;
                                                                    this.result = undefined;
                                                                    this.showErrorToast();
                                                                });
                        }
                        
                    if(this.objectNameReceived=='copado__Step__c'){
                                    callPromotionScheduleClass({month:this.gitMonths, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.gitRepoRecordId , copadoAPIKey:this.apiKeyVar , serverURL:this.serverUrlVar , keepThoseBranches:this.branchToBeVar })
                                                              .then((result) => {
                                                                  this.showSuccessToast();      
                                                                  this.error = undefined;
                                                                  this.showScheduleBranchFlag = false;
                                                                  this.firstRadioFlag = true;
                                                                  this.showRunPathFlag = true;
                                                                  this.showScheduledPathFlag = false;
                                                                  this.selectedStep = 'Cleanup Operation';
                                                                  if(this.selectedStep = 'Cleanup Operation'){
                                                                    eval("$A.get('e.force:refreshView').fire();");
                                                                  }
                                                              })
                                                              .catch((error) => {
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
                
            showOnArchieved = false 
            showDataTableArchived = false
            archivedSelectedDataTableFlag = false
            sObjectRecordarchivedList =[];
            showArchivalUnarchButtonsFlag = false
            selectedArchUnarch 

            valueArchUnarch = '';
            get optionsArchUnarch() {
                return [
                    { label: 'Archival Records', value: 'archivRecords' },
                    { label: 'Unarchival Records', value: 'unarchivRecords' },
                ];
            }

            selectedArchUnarch

            handleChangeArchUnarch(event){
                const selectedValue = event.target.value;
                this.selectedArchUnarch = selectedValue;
               
            }

            cancelArchHandler(){
                   this.showArchivalUnarchButtonsFlag =  false;
                   this.firstRadioFlag  = true
                   this.showOnArchieved =false; 
            }

            okayArchHandler(){
                this.showOnArchieved =true;
                this.showArchivalUnarchButtonsFlag =  false;
                this.firstRadioFlag = false;

                var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Cleanup Operation'){
                        this.selectedStep = 'Entity Selection';
                    }
            }
            
            handleArchived(){
                    this.showArchivalUnarchButtonsFlag =  true;
                    this.showOnArchieved =true;
                    this.firstRadioFlag = false;
             }

           handlePrevArchived2(){

                        this.firstRadioFlag = true;
                        this.showOnArchieved = false;
                        
                        var getselectedStep = this.selectedStep;
                       
                    if(this.firstRadioFlag==true){
                                    if(getselectedStep === 'Entity Selection'){
                                        this.selectedStep = 'Cleanup Operation';
                                        eval("$A.get('e.force:refreshView').fire();");
                                    }
                        }
                        if(this.showSchedulePageOnScheduleButton==true){
                                    if(getselectedStep === 'Scheduled'){
                                        this.selectedStep = 'Entity Selection';
                                        eval("$A.get('e.force:refreshView').fire();");
                                    }
                        }
           } 

           totalRecordForArchived = '0'

           handleNextArchived2(){
            if((this.show3MonthBrandButton == true || this.show6MonthBrandButton == true || this.show12MonthBrandButton == true)  && (this.showRunNowhBrandButton == true || this.showScheduledBrandButton == true)){
                        this.showOnArchieved = false;
                      
                        if(this.showRunNowhBrandButton==true){
                                this.showDataTableArchived=true
                                this.archivedSelectedDataTableFlag = false
                                this.showScheduleArchivedFlag=false
                                this.columnsq=columnsRecordCleanup1;
    
                                 var getselectedStep = this.selectedStep;
    
                                    if(getselectedStep === 'Entity Selection'){
                                        this.selectedStep = 'Data Selection';
                                        this.showScheduleArchivedFlag=false;
                                        this.showDataTableArchived=true;
                                    }
                        }
                        if(this.showScheduledBrandButton==true){
                                this.showScheduleArchivedFlag=true
                                this.showDataTableArchived=false
    
                                var getselectedStep = this.selectedStep;
    
                                        if(getselectedStep === 'Entity Selection'){
                                            this.selectedStep = 'Scheduled';
                                        }
                        }
                      
                        this.showSpinnerFlag = true

                        if (this.selectedArchUnarch == 'archivRecords'){
                     
                            getsObjectRecordForArchieved({months:this.months})
                                            .then( (result) => {
                                                this.showSpinnerFlag = false
                                                this.error = undefined
                                                this.sObjectRecordarchivedList = result;
                                                this.totalRecountCountArch = result.length;
                                                this.totalPageArch = Math.ceil(this.totalRecountCountArch / this.pageSizeArch);
                                                //here we slice the data according page size
                                                this.recordsToDisplayArchData = this.sObjectRecordarchivedList.slice(0, this.pageSizeArch);
                                                this.endingRecordArch = this.pageSizeArch;
                                                this.pageSizeArch= this.pageSizeOptionsArch[0]; //set pageSize with default value as first option
                                                this.columnsq=columnsRecordCleanup1;
                                            })
                                            .catch( (error) => {
                                            this.result = undefined;
                                            this.error = error;
                                            console.log(this.error);
                                        })
                                    }
                                 if (this.selectedArchUnarch == 'unarchivRecords'){ 
                                    getsObjectRecordForUnArchieved({months:this.months})
                                      .then( (result) => {
                                          this.showSpinnerFlag = false
                                          this.error = undefined
                                          this.sObjectRecordarchivedList = result;
                                          this.totalRecountCountArch = result.length;
                                          this.totalPageArch = Math.ceil(this.totalRecountCountArch / this.pageSizeArch);
                                          //here we slice the data according page size
                                          this.recordsToDisplayArchData = this.sObjectRecordarchivedList.slice(0, this.pageSizeArch);
                                          this.endingRecordArch = this.pageSizeArch;
                                          this.pageSizeArch= this.pageSizeOptionsArch[0]; //set pageSize with default value as first option
                                          this.columnsq=columnsRecordCleanup1;
                                      })
                                      .catch( (error) => {
                                      this.result = undefined;
                                      this.error = error;
                                      console.log(this.error);
                                  })
                                 }
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

                if(this.showDataTableArchived==false){
                         this.sObjectRecordarchivedList = null;
                         this.selectedRecordsCountArch = 0;
                }
                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Data Selection'){
                    this.selectedStep = 'Entity Selection';
                }
         }
         handlePrevScreenArchived4(){
                this.showDataTableArchived=true;
                this.archivedSelectedDataTableFlag = false;

                var getselectedStep = this.selectedStep;
                if(getselectedStep === 'Review Selection'){
                    this.selectedStep = 'Data Selection';
                }
         }


         totalselectedRecordsArch='0'
         selectedRecordsCountArch = '0'
         selectedRowsArch=[];
        sObjectSelectedArchRecordList

         handleNextScreenArchived3(){
            if(this.selectedRecountCountArch > 0 ){
                this.showDataTableArchived=false;
                this.archivedSelectedDataTableFlag = true;
                if (this.selectedArchUnarch == 'archivRecords'){
                    getSelectedArchRecord({recordIdList:this.selectedRowsArch})
                                                            .then( (result) => {
                                                                this.showSpinnerFlag = false;
                                                                this.sObjectSelectedArchRecordList = result;
                                                                this.columnsp=columnsSelectedRecordParent;
                                                                this.error = undefined;
                                                    })
                                                            .catch( (error) => {
                                                            this.result = undefined;
                                                            this.error = error;
                                                    })
                   }
                   if (this.selectedArchUnarch == 'unarchivRecords') {
                    getSelectedUnArchRecord({recordIdList:this.selectedRowsArch})
                                        .then( (result) => {
                                            this.showSpinnerFlag = false;
                                            this.sObjectSelectedArchRecordList = result;
                                            this.columnsp=columnsSelectedRecordParent;
                                            this.error = undefined;
                                })
                                        .catch( (error) => {
                                        this.result = undefined;
                                        this.error = error;
                                })
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

         archievedHandler(){
            let text;
                    if (confirm("Do you really want to Archived that record ?") == true) {

                        if (this.selectedArchUnarch == 'archivRecords') {
                                archivedRecord({recordIdList:this.selectedRowsArch})
                                                    .then((result) => {
                                                    this.result = result;
                                                    this.showSuccessToastArch();
                                                    this.archivedSelectedDataTableFlag = false;
                                                    this.firstRadioFlag = true;
                                                    var getselectedStep = this.selectedStep;
                            
                                                    if(getselectedStep === 'Review Selection'){
                                                        this.selectedStep = 'Cleanup Operation';
                                                    }
                                                })
                                                .catch((error) => {
                                                        this.error = error;
                                                        this.result = undefined;
                                                });
                          }
                          if (this.selectedArchUnarch == 'unarchivRecords'){
                                unArchivedRecord({recordIdList:this.selectedRowsArch})
                                            .then((result) => {
                                            this.result = result;
                                            this.showSuccessToastunArch();
                                            this.archivedSelectedDataTableFlag = false;
                                            this.firstRadioFlag = true;
                                            var getselectedStep = this.selectedStep;
                    
                                            if(getselectedStep === 'Review Selection'){
                                                this.selectedStep = 'Cleanup Operation';
                                            }
                                        })
                                        .catch((error) => {
                                                this.error = error;
                                                this.result = undefined;
                                        });
                          }
                    } else {
                        text = "You cancelled!";
                        this.archivedSelectedDataTableFlag = true;
                    }
         }

         showSuccessToastArch() {
            const evt = new ShowToastEvent({
                                title: 'Message',
                                message: 'Successfully Archived.....!!!!',
                                variant: 'success',
                                mode: 'dismissable'
                            });
                            this.dispatchEvent(evt);
            }
         showSuccessToastunArch() {
                const evt = new ShowToastEvent({
                                    title: 'Message',
                                    message: 'Successfully UnArchived.....!!!!',
                                    variant: 'success',
                                    mode: 'dismissable'
                                });
                                this.dispatchEvent(evt);
                }

      showScheduleArchivedFlag = false

       handlePrevArchviedSchedule(){
                    this.showOnArchieved = true;
                    this.showScheduleArchivedFlag = false;
                    this.showRunNowhBrandButton=false;
                    this.selectedStep = 'Entity Selection';

                    if(this.showScheduleArchivedFlag == false){
                        this.scheduleJobName = null;
                        this.cron=null;
                        this.Minut = 0;
                        this.Hour = 0;
                        this.hourlyValue=false
                        this.DailyValue = false
                        this.weekdaysValue = false
                        
                        this.showWeeklyButton=false
                        this.showDailyButton=false
                        this.showHourlyButton=false

                        this.showMonButton = true
                        this.showTueButton = true
                        this.showWedButton = true
                        this.showThurButton = true
                        this.showFriButton = true
                        this.showSatButton = true
                        this.showSunButton = true

                        this.showMondayBrandButton = false
                        this.showTuesBrandButton = false
                        this.showWedBrandButton = false
                        this.showThursBrandButton = false
                        this.showFridayBrandButton = false
                        this.showSatBrandButton = false
                        this.showSunBrandButton = false

                        this.numberOfHours=1;
                        this.numberOfDays = 1;
            }
      }

          scheduleArchivedApexJob(){
             if (this.selectedArchUnarch == 'archivRecords') {
                    callArchivedScheduleClass({month:this.months, cron:this.cron, jobName:this.scheduleJobName })
                                .then((result) => {
                                    console.log(result)
                                    this.showSuccessToast4();      
                                    this.error = undefined;
                                    this.showScheduleArchivedFlag = false;
                                    this.firstRadioFlag = true;
                                    this.showRunPathFlag = true;
                                    this.showScheduledPathFlag = false;
                                    this.selectedStep = 'Cleanup Operation';

                                    if(this.selectedStep = 'Cleanup Operation'){
                                        eval("$A.get('e.force:refreshView').fire();");
                                      }
                                })
                                .catch((error) => {
                                    this.error = error;
                                    this.result = undefined;
                                    this.showErrorToast4();
                                });
                     }

                     if (this.selectedArchUnarch == 'unarchivRecords') {
                        callUnArchivedScheduleClass({month:this.months, cron:this.cron, jobName:this.scheduleJobName })
                                    .then((result) => {
                                        console.log(result)
                                        this.showSuccessToast4();      
                                        this.error = undefined;
                                        this.showScheduleArchivedFlag = false;
                                        this.firstRadioFlag = true;
                                        this.showRunPathFlag = true;
                                        this.showScheduledPathFlag = false;
                                        this.selectedStep = 'Cleanup Operation';
    
                                        if(this.selectedStep = 'Cleanup Operation'){
                                            eval("$A.get('e.force:refreshView').fire();");
                                          }
                                    })
                                    .catch((error) => {
                                        this.error = error;
                                        this.result = undefined;
                                        this.showErrorToast4();
                                    });
                         }
                }

                goHomeHandler(){
                    this.firstRadioFlag = true;
                    this.selectedStep == 'Cleanup Operation'
                    if(this.firstRadioFlag == true){
                        eval("$A.get('e.force:refreshView').fire();");
                    }
                    this.selectObjectFlag = false;
                    this.showDataTable = false;
                    this.selectedDataTableFlag = false;
                    this.showSchedulePage = false;
                    this.GitBranchesButton = false;
                    this.showFeatureDataTable = false;
                    this.showSelectedFeatureDataTableFlag = false;
                    this.showScheduleBranchFlag = false
                    this.showOnArchieved = false;
                    this.showDataTableArchived = false;
                    this.archivedSelectedDataTableFlag = false
                    this.showScheduleArchivedFlag = false
                }

       //Pagination code - 1 (Record Cleanup)
             page1 = 1; //initialize 1st page
            recordsToDisplay1 =[];
            sObjectRecordList = [];
            columns; //holds column info.
            columnsq;
            startingRecord1 = 1; //start record position per page
            endingRecord1 = 0; //end record position per page
            pageSize1 = 10; //default value we are assigning
            totalRecountCount1 = 0; //total record count received from all retrieved records
            totalPage1 = 0; //total number of page is needed to display all records
            selectedRows1 = [];
            pageSizeOptions1 = [10, 25, 50, 75, 100];
            selectedRecountCount1 = 0;
           
            handleRecordsPerPage1(event) {
                this.pageSize1 = event.target.value;
                this.displayRecordPerPage1(this.page1);
            }

            firstHandler1() {
                    this.page1 = 1;
                    this.displayRecordPerPage1(this.page1);
            }

            //press on previous button this method will be called
            previousHandler1() {
                if (this.page1 > 1) {
                    this.page1= this.page1 - 1;
                    this.displayRecordPerPage1(this.page1);
                }
            }

            //press on next button this method will be called
            nextHandler1() {
                if ((this.page1 < this.totalPage1) && this.page1 !== this.totalPage1) {
                    this.page1= this.page1 + 1;
                    this.displayRecordPerPage1(this.page1);
                }
            }

            lastHandler1() {
                    this.page1 = this.totalPage1 ;
                    this.displayRecordPerPage1(this.page1);
            }

            //this method displays records page by page
            displayRecordPerPage1(page1) {

                this.startingRecord1 = ((page1 - 1) * this.pageSize1);
                this.endingRecord1 = (this.pageSize1 * page1);

                this.endingRecord1 = (this.endingRecord1 > this.totalRecountCount1)
                    ? this.totalRecountCount1 : this.endingRecord1;

                this.recordsToDisplay1 = this.sObjectRecordList.slice(this.startingRecord1, this.endingRecord1);

                //increment by 1 to display the startingRecord count, 
                //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
                this.startingRecord1 = this.startingRecord1 + 1;
                this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows1;
            }


         //Pagination code - 2(Git)
         page2 = 1; //initialize 1st page
         recordsToDisplay2 =[];
         columns; //holds column info.
         columns;
         startingRecord2 = 1; //start record position per page
         endingRecord2 = 0; //end record position per page
         pageSize2 = 10; //default value we are assigning
         totalRecountCount2 = 0; //total record count received from all retrieved records
         totalPage2 = 0; //total number of page is needed to display all records
         selectedRows2 = [];
         pageSizeOptions2 = [10, 25, 50, 75, 100];
         selectedRecountCount2 = 0;  //selectedRecordsCount2
        
          handleRecordsPerPage2(event) {
               this.pageSize2 = event.target.value;
               this.displayRecordPerPage2(this.page2);
           }
     
         firstHandler2() {
                 this.page2 = 1;
                 this.displayRecordPerPage2(this.page2);
         }
     
         //press on previous button this method will be called
         previousHandler2() {
             if (this.page2 > 1) {
                 this.page2= this.page2 - 1;
                 this.displayRecordPerPage2(this.page2);
             }
         }
     
         //press on next button this method will be called
         nextHandler2() {
             if ((this.page2 < this.totalPage2) && this.page2 !== this.totalPage2) {
                 this.page2= this.page2 + 1;
                 this.displayRecordPerPage2(this.page2);
             }
         }
     
         lastHandler2() {
                 this.page2 = this.totalPage2 ;
                 this.displayRecordPerPage2(this.page2);
         }
     
         //this method displays records page by page
         displayRecordPerPage2(page2) {
     
             this.startingRecord2 = ((page2 - 1) * this.pageSize2);
             this.endingRecord2 = (this.pageSize2 * page2);
     
             this.endingRecord2 = (this.endingRecord2 > this.totalRecountCount2)
                 ? this.totalRecountCount2 : this.endingRecord2;
     
             this.recordsToDisplay2 = this.gitBranchesRecordList.slice(this.startingRecord2, this.endingRecord2);
     
             //increment by 1 to display the startingRecord count, 
             //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
             this.startingRecord2 = this.startingRecord2 + 1;
             this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows2;
         }
         //Pagination End (Git)

    //Pagination code - 1 (Archival Record)
    pageArch = 1; //initialize 1st page
    recordsToDisplayArchData =[];
  //  sObjectRecordarchivedList = [];
    columns; //holds column info.
    columnsq;
    startingRecordArch = 1; //start record position per page
    endingRecordArch = 0; //end record position per page
    pageSizeArch = 10; //default value we are assigning
    totalRecountCountArch = 0; //total record count received from all retrieved records
    totalPageArch = 0; //total number of page is needed to display all records
    selectedRowsArch = [];
    pageSizeOptionsArch = [10, 25, 50, 75, 100];
    selectedRecountCountArch = 0;

     handleRecordsPerPageArch(event) {
          this.pageSizeArch = event.target.value;
          this.displayRecordPerPageArch(this.pageArch);
      }

    firstHandlerArch() {
            this.pageArch = 1;
            this.displayRecordPerPageArch(this.pageArch);
    }

    //press on previous button this method will be called
    previousHandlerArch() {
        if (this.pageArch > 1) {
            this.pageArch = this.pageArch - 1;
            this.displayRecordPerPageArch(this.pageArch);
        }
    }

    //press on next button this method will be called
    nextHandlerArch() {
        if ((this.pageArch < this.totalPageArch) && this.pageArch !== this.totalPageArch) {
            this.pageArch = this.pageArch + 1;
            this.displayRecordPerPageArch(this.pageArch);
        }
    }

    lastHandlerArch() {
            this.pageArch = this.totalPageArch ;
            this.displayRecordPerPageArch(this.pageArch);
    }

    //this method displays records page by page
    displayRecordPerPageArch(pageArch) {

        this.startingRecordArch = ((pageArch - 1) * this.pageSizeArch);
        this.endingRecordArch = (this.pageSizeArch * pageArch);

        this.endingRecordArch = (this.endingRecordArch > this.totalRecountCountArch)
            ? this.totalRecountCountArch : this.endingRecordArch;

        this.recordsToDisplayArchData = this.sObjectRecordarchivedList.slice(this.startingRecordArch, this.endingRecordArch);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecordArch = this.startingRecordArch + 1;
        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRowsArch;
    }
                        
    selectedRecordsHandlerArch(event){
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRowsArch);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();

        this.recordsToDisplayArchData.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });

        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });

            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }

        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });

        this.selectedRowsArch = [...selectedItemsSet];
        this.selectedRecountCountArch = this.selectedRowsArch.length;
        }    
        //Pagination code Arch end    

   }