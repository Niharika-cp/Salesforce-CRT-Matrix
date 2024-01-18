import { LightningElement,track ,api } from 'lwc';
import LightningConfirm from 'lightning/confirm';
import getsObjectRecord from "@salesforce/apex/CentralClass.getsObjectRecord";
import sObjectRecordDeleted from "@salesforce/apex/CentralClass.sObjectRecordDeleted";
import sObjectRecordHardDeleted from "@salesforce/apex/CentralClass.sObjectRecordHardDeleted";
import practicePromotionRecord from "@salesforce/apex/CentralClass.practicePromotionRecord";
import practiceFeatureMethod from "@salesforce/apex/CentralClass.practiceFeatureMethod";
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ; 
import callScheduleClass from '@salesforce/apex/CentralClass.callScheduleClass';
import getStepObjectRecordList from "@salesforce/apex/CentralClass.getStepObjectRecordList";
import getuserStoryBranchRecord from "@salesforce/apex/CentralClass.getuserStoryBranchRecord";
import callFeatureScheduleClass from '@salesforce/apex/CentralClass.callFeatureScheduleClass';
import callPromotionScheduleClass from '@salesforce/apex/CentralClass.callPromotionScheduleClass';


const columns=[];

const  columns1 = [
    { label: 'Name', fieldName: 'Name', editable: true },
   /* { label: 'Created By', fieldName: 'CreatedBy.Name', editable: true },
    { label: 'Last Modified By', fieldName: 'LastModifiedBy.Name', editable: true },*/
    { label: 'Created Date', fieldName: 'CreatedDate', editable: true },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', editable: true },
  ];


  const  columns2 = [
    { label: 'Name', fieldName: 'Name', editable: false },
    /*{ label: 'Created By', fieldName: 'CreatedBy.Name', editable: false },
    { label: 'Last Modified By', fieldName: 'LastModifiedBy.Name', editable: false },*/
    { label: 'Created Date', fieldName: 'CreatedDate', editable: false },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', editable: false },
  ];



  const  columns122 = [
    
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

  const  columns222 = [
    
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


export default class Screen2Compo extends LightningElement {


    @track selectedStep = 'Cleanup Operation';

    
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

/*selectStep5() {
    this.selectedStep = 'Finish';
}*/
selectStep5() {
    this.selectedStep = 'Schedule';
}

/*get isSelectStep5() {
    return this.selectedStep === "Finish";
}*/

/////////////////// for RUN Now ////////////////////////
    
    firstRadioFlag = true;
    selectObjectFlag = false;
    GitBranchesButton = false;

    draftValues=[];
    columns = columns;
    totalRecords1
    
    

    // for first next
    handleNext(){

        this.selectedStep = 'Cleanup Operation';

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

    // for second prev
    handlePrev2(){
        this.firstRadioFlag = true;
        this.selectObjectFlag = false;
        var getselectedStep = this.selectedStep;
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
    // for second next
    handleNext2(){
        
        this.selectObjectFlag = false;
        this.preSelectedRows = null;


        if(this.showRunNowhBrandButton==true){
           this.showDataTable=true
           this.selectedFormFlag = false
           this.showSchedulePage=false
           this.columns=columns1;
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
        getsObjectRecord({months:this.months,objectName:this.objectName})
                        .then( (result) => {
                            this.showSpinnerFlag = false
                            this.result = result;
                            this.error = undefined
                            console.log(this.result );
                            this.sObjectRecordList = result;
                            this.totalRecords1 = result.length;

                        })
                        .catch( (error) => {

                        this.result = undefined;
                        this.error = error;
                        console.log(this.error);
                    })
    }

    handlePrev3(){

        this.selectObjectFlag=true;
        this.showDataTable=false;
        this.selectedFormFlag = false;

        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Data Selection'){
            this.selectedStep = 'Entity Selection';
        }

    }

  @track  preSelectedRows = [];

    handlePrev4(){
        this.selectedFormFlag = false;
        


        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Review Selection'){
            this.selectedStep = 'Data Selection';
        }

    }

    handleNext3(){
        this.showDataTable=false;

        this.selectedFormFlag = true;
        
        if(this.selectedRecordsId != null ){

            this.sObjectSelectedRecordList = this.selectedRecordsId;

            console.log('** ='+this.sObjectSelectedRecordList);

            this.totalselectedRecords1 = this.sObjectSelectedRecordList.length;

            this.columns=columns2;
}

else{
    this.showErrorToast2();
}

        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Data Selection'){
            this.selectedStep = 'Review Selection';
        }
}
    
selectedRecordsCount1 

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

        

    // Selected obejects Radio button variables
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
   
    objectName 
    sObjectRecordList
    selectedRecordsCount = '0';
    selectedRecords
    selectedRecordsId
    totalselectedRecords
    totalselectedRecords1
    selectedFormFlag = false
    result
    error

    sObjectSelectedRecordList

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

    //  handling Copado Records and Git Branches Radio Button
     get options1() {
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
     }

    //  handling Selected Objects Radio Button 
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

     show3MonthButton=true
     show6MonthButton = true

     show3MonthBrandButton = false
     show6MonthBrandButton = false




     showRunNowButton = true
     showScheduledButton = true


     showRunNowhBrandButton = false
     showScheduledBrandButton = false


     showDataTableOnRunNowButton=false
     showSchedulePageOnScheduleButton=false

     showDataTable=false
     showSchedulePage=false


     showRunPathFlag = true;
     showScheduledPathFlag = false;

    
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
 
       threeMonthHandler(){
 
         this.show3MonthButton = false;
         this.show3MonthBrandButton = true;
  
         this.show6MonthBrandButton = false;
         this.show6MonthButton = true;
  
  
                this.months=3 
                 console.log('Months= '+this.months);
                 
                 this.showSpinnerFlag = true;
 
       }
 
 threeMonthBrandHandler(){
 
     this.show3MonthBrandButton = false;
     this.show3MonthButton = true;
     this.show6MonthBrandButton = false;
     this.show6MonthButton = true;
 
 
     this.months=3 
     console.log('Months= '+this.months);
     
     this.showSpinnerFlag = true;
 
 
 
   
                      
 }
 
 sixMonthHandler(){
 
 
     this.show6MonthButton = false;
     this.show3MonthBrandButton = false;
     this.show3MonthButton = true;
    this.show6MonthBrandButton = true;
 
 
      this.months=6
         console.log('Months= '+this.months);
         this.showSpinnerFlag = true
 
       
 }
 
 
 sixMonthBrandHandler(){
 
     this.show3MonthBrandButton = false;
     this.show3MonthButton =true;
 
         
     this.show6MonthBrandButton = false;
     this.show6MonthButton = true;
    
     
    
     this.months=6
     console.log('Months= '+this.months);
     this.showSpinnerFlag = true
 
     
 }


 deleteHandler(){
    console.log('I m in delete');
    console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
    console.log('objectReceived'+this.objectName);

   let text;
   if (confirm("Do you really want to delete that record ?") == true) {
     
    sObjectRecordDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectName})
                           .then((result) => {
                           this.result = result;
                           this.error = undefined;
                           this.showSuccessToast1();
                        
                           this.selectedFormFlag = false;
                           
                           this.getRefeshData();
                          // this.firstRadioFlag = true;
                           this.totalRecords = result.length;
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
   // eval("$A.get('e.force:refreshView').fire();");
}
}


deleteAllHandler(){
console.log('I m in delete');
console.log('sObjectSelectedRecordList'+this.sObjectSelectedRecordList);
console.log('objectReceived'+this.objectName);

let text;
if (confirm("Do you really want to delete that record ?") == true){
 
sObjectRecordHardDeleted({sObjectRecordIdList:this.sObjectSelectedRecordList,objectName:this.objectName})
                       .then((result) => {
                       this.result = result;
                       this.error = undefined;
                       this.showSuccessToast1();
                       this.selectedFormFlag = false;
                       
                       this.getRefeshData();
                       this.firstRadioFlag = true;
                       this.totalRecords = result.length;
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
                    //eval("$A.get('e.force:refreshView').fire();");
                    }

}


getRefeshData(){ 

                getsObjectRecord({months:this.months,objectName:this.objectName})
                                .then((result) => {

                                    console.log(result)
                                    this.sObjectRecordList = result       
                                    this.error = undefined;
                                    this.totalRecords = result.length;

                                })
                                .catch((error) => {
                                    console.log(error)
                                    this.error = error;
                                    this.result = undefined;
                                });

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




///////////////////////////// for Schedule /////////////////////////////////


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

Hour 
Minut

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
showMondayBrandButton = false
showTuesBrandButton = false
showWedBrandButton = false
showThursBrandButton = false
showFridayBrandButton = false
showSatBrandButton = false
showSunBrandButton = false
showButton = true

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
  console.log('** HourValue= '+this.hourlyValue);

 
      this.showHourlyButton=true;
      this.showWeeklyButton=false;
      this.showDailyButton=false;
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
  console.log('DailyValue = '+this.DailyValue);

  this.showDailyButton=true
  this.showWeeklyButton=false
  this.showHourlyButton=false
  this.cron='0 0 12 1/1 * ? *'
  this.weekdays= ['?']
  this.numberOfDays=1
  this.dayOfMonth='1/'+this.numberOfDays;
}else{

  this.DailyValue = false;
  
}



if (this.value == 'WeekdayValue'){
  this.weekdaysValue = true;
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
this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year


}


numberOfMinutesHandler(evt){
   
this.Minut=evt.target.value
console.log('Number Of MINUTE= '+this.Minut);
this.min=this.Minut.toString();
console.log('Minute= '+this.min);
this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year


}



scheduleJobNameHandleChange(evt) {
this.scheduleJobName=evt.target.value
console.log('Schedule Job Name: ' + this.scheduleJobName);
}



scheduleApexJob(){ 

console.log('On schedule button click Month= '+this.months)
console.log('On schedule button click cron= '+this.cron)
console.log('On schedule button click jobname= '+this.scheduleJobName)
console.log('On schedule button click object name= '+this.objectNameReceived)





callScheduleClass({month:this.months, cron:this.cron, jobName:this.scheduleJobName ,objectName:this.objectName})
            .then((result) => {
                console.log(result)
                this.showSuccessToast4();      
                this.error = undefined;

                this.showSchedulePage = false;
                this.firstRadioFlag = true;
              
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

                    
                      

        ////////////////////// Git Branches Code Start ///////////////////////////////     
        
    showButtonFlag=false
    apiKeyVar =null
    serverUrlVar =null
    branchToBeVar =null
    gitRepositoryObject
    BranchToBeList = [];
    recordId
    sObjectSelectedRecordList
    rowOffset = 0;
    objectNameReceived = 'copado__User_Story__c'


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

      handleChange23(event) {
            this.showButtonFlag=true;
            this.gitRepositoryObject=event.detail.value;
            this.recordId = event.detail.value[0];
            console.log('You selected Git Repository : '+event.detail.value[0]);

            console.log('Record Id ='+this.recordId);
            console.log('Object Name ='+this.objectNameReceived);
            
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

     userStoryFeatureRecordList
    showSpinnerFlag = false

     recordList
    

    @track selectedOption

    
    showFeatureDataTable = false;
    showSelectedFeatureDataTableFlag = false;


    changeHandler(event) {
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
          

   
    show3MonthButton2=true
    show6MonthButton2 = true

    show3MonthBrandButton2 = false
    show6MonthBrandButton2 = false

    

  

    threeMonthHandler2(){

        this.show3MonthButton2 = false;
       this.show3MonthBrandButton2 = true;

       this.show6MonthBrandButton2 = false;
       this.show6MonthButton2 = true;

       
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

    threeMonthBrandHandler2(){

        this.show3MonthBrandButton2 = false;
        this.show3MonthButton2 = true;

        
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

     sixMonthHandler2(){

        
        this.show6MonthButton2 = false;
        this.show3MonthBrandButton2= false;
        this.show3MonthButton2 = true;
       this.show6MonthBrandButton2 = true;


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

    sixMonthBrandHandler2(){

        
        this.show6MonthBrandButton2 = false;
        this.show6MonthButton2 = true;

        
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


    handleNext233(){

        this.showFeatureDataTable = true;
        this.GitBranchesButton = false;
        this.showDataTable =false;

        if(this.showRunNowhBrandButton2==true){
            this.showFeatureDataTable=true
            this.selectedFormFlag = false
            this.showScheduleBranchFlag=false
            this.columns=columns122;

            /*var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Entity Selection'){
                        this.selectedStep = 'Data Selection';
                    }*/

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

                if(this.objectNameReceived=='copado__User_Story__c')
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
                                        this.columns=columns122;


                                        
                if(this.objectNameReceived=='copado__Step__c'){

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
                                this.columns=columns222;

                                }  
                    
                        
                            this.showPopupModel=this.bol;
                        
}


handlePrev23333(){
    this.showFeatureDataTable = false;
    this.GitBranchesButton = true;
    this.showSelectedFeatureDataTableFlag = false;

    var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Data Selection'){
            this.selectedStep = 'Entity Selection';
        }


}


handleNext233333(){

    this.showSelectedFeatureDataTableFlag = true;
    this.showFeatureDataTable = false;



    this.sObjectSelectedRecordList = this.selectedRecordsId;

    console.log('** ='+this.sObjectSelectedRecordList);

    this.totalselectedRecords = this.sObjectSelectedRecordList.length;

    if(this.objectNameReceived=='copado__User_Story__c'){
    this.columns=columns12;
    }
    if(this.objectNameReceived=='copado__Step__c'){
    this.columns=columns22;
    }

    var getselectedStep = this.selectedStep;
 if(getselectedStep === 'Data Selection'){
    this.selectedStep = 'Review Selection';
}


}

handlePrev233(){
            this.firstRadioFlag = true;
            this.GitBranchesButton = false;

      
            var getselectedStep = this.selectedStep;
                if(this.firstRadioFlag==true){
                        if(getselectedStep === 'Entity Selection'){
                            this.selectedStep = 'Cleanup Operation';
                        }
            }
            if(this.showBranchSchedulePageOnScheduleButton ==true){
                        if(getselectedStep === 'Scheduled'){
                            this.selectedStep = 'Entity Selection';
                        }
            }


}


handlePrev23333444(){
  
        this.showSelectedFeatureDataTableFlag = false;
        this.showFeatureDataTable = true;

        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Review Selection'){
            this.selectedStep = 'Data Selection';
        }

}



async deleteHandler2(){
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
                                         this.showSuccessToast3();

                                         this.selectedPopup=false;
                                         this.getRefeshData();
                                         this.totalRecords = result.length;
                                     })
                                     .catch((error) => {
                                         console.log(error)
                                         this.error = error;
                                         this.showErrorToast3();
                                     });
                     }
  if(this.objectName=='copado__Step__c'){
             practicePromotionRecord({recordIdList : this.sObjectSelectedRecordList,repositoryId:this.recordId,serverURL:this.serverUrlVar,copadoAPIKey:this.apiKeyVar, keepThoseBranches : this.BranchToBeList})
                                         .then((result) => {
                                         this.result = result;
                                         this.showSuccessToast3();

                                         this.selectedPopup=false;
                                         this.getRefeshData();
                                        this.totalRecords = result.length;
                                     })
                                     .catch((error) => {
                                         console.log(error)
                                         this.error = error;
                                         this.showErrorToast3();
                                     });
                 }

                 var getselectedStep = this.selectedStep;
                 if(getselectedStep === 'Review Selection'){
                  this.selectedStep = 'Finish';
              }

              var getselectedStep = this.selectedStep;
                    if(getselectedStep === 'Review Selection'){
                        this.selectedStep = 'Cleanup Operation';
                    // eval("$A.get('e.force:refreshView').fire();");
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
 
        scheduleBranchApexJob(){
                              console.log('On schedule button click Month= '+this.month)
                              console.log('On schedule button click cron= '+this.cron)
                              console.log('On schedule button click jobname= '+this.scheduleJobName)
                              console.log('On schedule button click object name= '+this.objectNameReceived)
                              console.log('repository Id ='+this.repositoryId )
                              console.log('apiKey ='+this.apiKey )
                              console.log('serverUrl ='+this.serverUrl )
                              console.log('branchTobe ='+this.branchTobe )
                          
                              if(this.objectNameReceived=='copado__User_Story__c'){
                                   if(this.month != null){
                          
                                    callFeatureScheduleClass({month:this.month, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.repositoryId , copadoAPIKey:this.apiKey , serverURL:this.serverUrl , keepThoseBranches:this.branchTobe})
                                                                .then((result) => {
                                                                    console.log(result)
                                                                    this.showSuccessToast();      
                                                                    this.error = undefined;
                                                                  
                                                                })
                                                                .catch((error) => {
                                                                    console.log(error)
                                                                    this.error = error;
                                                                    this.result = undefined;
                                                                    this.showErrorToast();
                                                                });
                            }
                          }
                             
                          
                                if(this.objectNameReceived=='copado__Step__c'){
                                  if(this.month != null){
                              
                                    callPromotionScheduleClass({month:this.month, cron:this.cron, jobName:this.scheduleJobName, repositoryId:this.repositoryId , copadoAPIKey:this.apiKey , serverURL:this.serverUrl , keepThoseBranches:this.branchTobe })
                                                              .then((result) => {
                                                                  console.log(result)
                                                                  this.showSuccessToast();      
                                                                  this.error = undefined;
                                                                
                                                              })
                                                              .catch((error) => {
                                                                  console.log(error)
                                                                  this.error = error;
                                                                  this.result = undefined;
                                                                  this.showErrorToast();
                                                              });
                                }
                              }
                            }

         /*   handleFinish() {
                              //  alert('Finished...');
                                 this.selectedStep = 'Cleanup Operation';
                                 this.firstRadioFlag = true;
                                 this.showSelectedFeatureDataTableFlag = false;
                                 eval("$A.get('e.force:refreshView').fire();");
                             }


                             get isSelectStep4() {
                                return this.selectedStep === "Finish";
                             }*/

    handlePrevSchedule(){
            this.selectObjectFlag = true;
            this.showSchedulePage = false;
            this.showRunNowhBrandButton=false;

    }

    handlePrevSchedule2(){

        this.showScheduleBranchFlag = false;
        this.GitBranchesButton = true;
        this.showRunNowhBrandButton2 = false;
}

            
}