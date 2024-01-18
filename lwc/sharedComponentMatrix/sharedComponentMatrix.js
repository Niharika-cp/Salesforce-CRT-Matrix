import { LightningElement,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import matrix from '@salesforce/apex/SharedComponentMatrixClass.matrix';
import searchKey from '@salesforce/apex/SharedComponentMatrixClass.searchKey';
import sendEmail from '@salesforce/apex/SharedComponentEmailGeneration.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent' ;
import scheduleEmail from '@salesforce/apex/SharedComponentEmailGeneration.scheduleEmail';

export default class SharedComponentMatrix extends NavigationMixin(LightningElement) {
     wrappersList = [];
    wrappers =[]; //All records available in the data table

    @wire(matrix)
    wiredData({ error, data }) {
        if (data) {
            this.wrappersList = data.map(item => {
                return {
                    component: item.component,
                    typer: item.typer,
                    usList: item.usList.map(usItem => {
                        return {
                            Id: usItem.userStory.Id, 
                            Name: usItem.userStory.Name, 
                            Environment: usItem.userStory.copado__Environment__r.Name, 
                            Owner: usItem.userStory.CreatedBy.Name,
                            lastCommitDate: usItem.lastCommitDate
                        };
                    })
                };
            });
    
            this.wrappers = this.wrappersList;
            console.log('usList === ' + JSON.stringify(this.wrappersList));
            this.totalRecords = this.wrappers.length;           
            this.pageSize = this.pageSizeOptions[0]; 
            this.paginationHelper(); 
        } else if (error) {
            console.error(error);
        }
    }
    

    navigateToUSRecord(event) {
        const recordId  = event.currentTarget.dataset.contactId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId ,
                objectApiName: 'copado__User_Story__c',
                actionName: 'view'
            }
        });
    }

    goToVfPageforCsv = false
    src    // for csv url
    goToVfPageforPdf = false
    src1   // for pdf url
    showEmailIdInput = false
    emailId=''

    exportCsvHandle(){
        this.goToVfPageforCsv = true
        this.src= "/apex/SharedComponentCsvPage?days="+this.numberOfDaysFre+"&fromDt="+this.formDate+"&toDt="+this.toDate;
        //?org1="+this.value1+"&org2="+this.value2+"&less75="+this.less75+"&diffcc="+this.diffcc
        this.showSpinnerFlag = false
    }

    exportpdfHandler(){
        console.log('Number of days===='+this.numberOfDaysFre);
        console.log('Fromdate===='+this.formDate);
        console.log('Todate===='+this.toDate);
        this.goToVfPageforPdf = true 
        this.src1= "/apex/sharedComponentPage_v2?days="+this.numberOfDaysFre+"&fromDt="+this.formDate+"&toDt="+this.toDate;
    }

    ClosePopupHandler(){
        this.goToVfPageforPdf = false 
    }

   
    sendEmailHandler(){
        this.showEmailIdInput= true   
    }

    ClosePopupHandlerEmail(){
        this.showEmailIdInput= false   
   }


    emailSelectionHandler(event){
        this.emailId =  event.target.value
        console.log('this.emailId ==='+this.emailId);
   }

    sendEmail(){
            sendEmail({ emailIds : this.emailId,days: this.numberOfDaysFre, fromDt: this.formDate, toDt: this.toDate})
            .then( (result) => {
                this.result = result;
                this.showsuccessMsg();
                this.showEmailIdInput = false
                this.error = undefined
                console.log(this.result );
                this.emailId.reset();
                })
                .catch( (error) => {
                this.result = undefined;
                this.error = error;
                console.log(this.error);
            })
    }

    showsuccessMsg() {
        const evt = new ShowToastEvent({
                                          title: 'Message',
                                          message: 'Email sent successfully',
                                          variant: 'success',
                                          mode: 'dismissable'
                                      });
                                      this.dispatchEvent(evt);
             }
    


    // FOR SCHEDULE REPORT

    showScheduleInput = false
    emailIdSch =''
    
    scheduleButtonHandler(){
        this.showScheduleInput = true
    }

    schClosePopupHandler(){
        this.showScheduleInput = false
    }

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

//cron='0 0 0/1 1/1 * ? *'
cron=null

value = ''

hourlyValue=false
DailyValue = false
weekdaysValue = false

showSelectedMonthFlag = false

showButton = true
timeStartFlag = true

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

schJobNameHandler(event){
    this.scheduleJobName =  event.target.value
}

emailSelectionHandlersch(event){
    this.emailIdSch =event.target.value
}

get optionsRadio() {
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
                this.timeStartFlag = false
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
                    //this.cron='0 0 0/1 1/1 * ? *'
                    this.cron=null
                    this.numberOfHours=0
                    this.hoursInDay='0/'+this.numberOfHours;

        }else{
                this.hourlyValue = false;
                this.timeStartFlag = true
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

            //this.cron='0 0 12 1/1 * ? *'
            this.cron=null
            this.weekdays= ['?']
            this.numberOfDays=0
            this.dayOfMonth='1/'+this.numberOfDays;
            //this.min='0'
           // this.hr='0'
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
            //this.cron='0 0 12 ? *  *'
            this.cron=null
            this.dayOfMonth='?'
           // this.min='0'
           // this.hr='0'
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
                   // this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
                   
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
                //this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
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
                //this.cron=this.sec+' '+this.min+' '+this.hr+' '+this.dayOfMonth+' '+this.monthOfYear+' '+this.weekdays+' '+this.year
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

    scheduleHandler(){ 
        scheduleEmail({ emailIds:this.emailIdSch, cronExp:this.cron, jobName:this.scheduleJobName,days: this.numberOfDaysFre, fromDt: this.formDate, toDt: this.toDate })
        .then((result) => {
            console.log(result)
            this.showSuccessToast4();      
            this.error = undefined;
            this.showScheduleInput = false
        })
        .catch((error) => {
            console.log(error)
            this.error = error;
            this.result = undefined;
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
   
// Pagination 

// JS Properties 
pageSizeOptions = [10, 25, 50, 75, 100]; //Page size options
wrappers =[]; //All records available in the data table
columns = []; //columns information available in the data table
totalRecords = 0; //Total no.of records
pageSize; //No.of records to be displayed per page
totalPages; //Total no.of pages
pageNumber = 1; //Page number    
recordsToDisplay = []; //Records to be displayed on the page

get bDisableFirst() {
    return this.pageNumber == 1;
}
get bDisableLast() {
    return this.pageNumber == this.totalPages;
}
handleRecordsPerPage(event) {
    this.pageSize = event.target.value;
    console.log('this.pageSize'+this.pageSize);
    this.paginationHelper();
}
previousPage() {
    this.pageNumber = this.pageNumber - 1;
    this.paginationHelper();
}
nextPage() {
    this.pageNumber = this.pageNumber + 1;
    this.paginationHelper();
}
firstPage() {
    this.pageNumber = 1;
    this.paginationHelper();
}
lastPage() {
    this.pageNumber = this.totalPages;
    this.paginationHelper();
}
// JS function to handel pagination logic 
paginationHelper() {
    console.log('Pagination Helper');
    this.recordsToDisplay = [];
    // calculate total pages
    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    // set page number 
    if (this.pageNumber <= 1) {
        this.pageNumber = 1;
    } else if (this.pageNumber >= this.totalPages) {
        this.pageNumber = this.totalPages;
    }
    // set records to display on current page 
    for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
        if (i === this.totalRecords) {
            break;
        }
        this.recordsToDisplay.push(this.wrappers[i]);
        console.log('this.recordsToDisplay'+this.recordsToDisplay);
    }
}
    // Search Box for Component Name

    searchKey  // on first page, have a search input above data table 

    handleKeyChange(event) {
        this.searchKey = event.target.value;
        if (this.searchKey) {
            // When there is a search key, perform the search
            this.performSearch();
        } else {
            // When the search key is cleared, reload the full list
            this.loadInitialData();
        }
    }
    
    performSearch() {
        this.showSpinnerFlag = true;
        searchKey({ searchKey: this.searchKey })
            .then(result => {
                // handle search result
                this.processData(result);
                this.showSpinnerFlag = false;
            })
            .catch(error => {
                // handle error
                this.showSpinnerFlag = false;
                console.error('Search Error:', error);
            });
    }
    
    loadInitialData() {
        this.showSpinnerFlag = true;
        matrix()
            .then(result => {
                // handle result
                this.processData(result);
                this.showSpinnerFlag = false;
            })
            .catch(error => {
                // handle error
                this.showSpinnerFlag = false;
                console.error('Error loading initial data:', error);
            });
    }
    
    processData(data) {
        this.wrappersList = data.map(item => {
            return {
                component: item.component,
                typer: item.typer,
                usList: item.usList.map(usItem => {
                    return {
                        Id: usItem.userStory.Id, 
                        Name: usItem.userStory.Name, 
                        Environment: usItem.userStory.copado__Environment__r.Name, 
                        Owner: usItem.userStory.CreatedBy.Name,
                        lastCommitDate: usItem.lastCommitDate
                    };
                })
            };
        });
       
        this.wrappers = this.wrappersList;
        this.totalRecords = this.wrappers.length;
        this.pageSize = this.pageSizeOptions[0];
        this.paginationHelper();
    }
    
    


    
    // Date Filters
    @track valueFre
    showNoOfDays = false
    showFormToDate = false
    numberOfDaysFre =null
    formDate =null
    toDate=null

    get optionsFre() {
        return [
            { label: 'Number Of Days', value: 'noOfDay' },
            { label: 'Select From-To Date', value: 'formToDate' },
        ];
    }

    handleChangeFre(e) {
        this.valueFre = e.detail.value;

        if (this.valueFre == 'noOfDay') {
            this.showNoOfDays = true
            this.showFormToDate = false
        } else {
            this.showNoOfDays = false
        }

        if (this.valueFre == 'formToDate') {
            this.showNoOfDays = false
            this.showFormToDate = true
        } else {
            this.showFormToDate = false
        }
    }

    numberOfDaysHandlerFre(evt) {
        this.numberOfDaysFre = evt.target.value
    }

    formDateHandler(evt) {
        this.formDate = evt.target.value
    }

    toDateHandler(evt) {
        this.toDate = evt.target.value
    }

    runHandler(){
        if (this.numberOfDaysFre != null || (this.formDate != null && this.toDate != null)) {
            this.onRunNowPage = true
          
            if (this.showNoOfDays == false) {
                this.numberOfDaysFre = null;
            }
            else if (this.showFormToDate == false) {
                this.formDate = null
                this.toDate = null
            }
            
            matrix({ days: this.numberOfDaysFre, fromDt: this.formDate, toDt: this.toDate })
                .then((result) => {
                    this.wrappersList = result;
                    console.log('this.wrappersList =='+this.wrappersList);
                    this.wrappers = this.wrappersList;
                    console.log('this.records =='+this.wrappers);
                    this.totalRecords = this.wrappers.length; // update total records count                 
                    this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                    this.paginationHelper(); // call helper menthod to update pagination logic 
                })
                .catch((error) => {
                    this.error = error;
                    console.log(this.error);
                })
        }
        else {
            this.showErrorToastonRunNow();
        } 
    }

    showErrorToastonRunNow() {
        const evt = new ShowToastEvent({
            title: 'Toast Error',
            message: 'Please select Date Range Filter',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    refreshHandler(){
        eval("$A.get('e.force:refreshView').fire();");
    }
}