import { LightningElement,track,api } from 'lwc';
import callScheduleClass from '@salesforce/apex/CentralClass.callScheduleClass';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';




export default class ScheduledPopupCompo extends LightningElement {
  

  @api objectNameReceived
  
  
     //event
    scheduleJobPopupHandler(){ 
          const myEvent = new CustomEvent("schedulepopupevent",{detail:false});
          this.dispatchEvent(myEvent);
      }

     //3/6 Months and Daily,Hourly,Weekly Radio button handler

        is3MonthSelected = false
        is6MonthSelected = false


        showWeeklyButton=false
        showDailyButton=false
        showHourlyButton=false
        
        scheduleJobName='';
        

        @track weekdays=[]
      

        month

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

    get options2() {
      return [
          { label: 'Hourly', value: 'HourValue' },
          { label: 'Daily', value: 'DailyValue' },
          { label: 'Weekly', value: 'WeekdayValue' },
      ];
  }

  get options1() {
    return [
        { label: 'Last 3 Month', value: 'threeMonthValue' },
        { label: 'Last 6 Month', value: 'sixMonthValue' },
        
    ];
  }
  
   

  handleChange1(e) {
      this.value = e.detail.value;

      if (this.value == 'threeMonthValue'){
        this.is3MonthSelected = true;
        console.log('&& threeMonthValue = '+this.is3MonthSelected);

        this.month=3
        console.log('Selected Month= '+this.month);
        this.showSelectedMonthFlag = true;
    }else{

        this.is3MonthSelected = false;
    }

    if (this.value == 'sixMonthValue'){
      this.is6MonthSelected = true;
      console.log('** sixMonthValue= '+this.is6MonthSelected);

     
      this.month=6
      console.log('Selected Month= '+this.month);
      this.showSelectedMonthFlag = true;
    }else{

      this.is6MonthSelected = false;
      
    }
  }

  handleChange2(e) {
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
  
    console.log('On schedule button click Month= '+this.month)
    console.log('On schedule button click cron= '+this.cron)
    console.log('On schedule button click jobname= '+this.scheduleJobName)
    console.log('On schedule button click object name= '+this.objectNameReceived)
   

    if(this.month != null){

    
    callScheduleClass({month:this.month, cron:this.cron, jobName:this.scheduleJobName  ,objectName:this.objectNameReceived})
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

      else{
        this.showErrorToast();
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
                                      message: 'Please fill all * (Required) value...!!!',
                                      variant: 'error',
                                      mode: 'dismissable'
                                  });
                                  this.dispatchEvent(evt);
                              }
   
}