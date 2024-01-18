import { LightningElement,track } from 'lwc';

export default class JustToCheck extends LightningElement {

    objectName 
    ObjectLabel = 'Copado User Story'

    // Selected objects Variables
    objUserStory =  'copado__User_Story__c'
    objUserStoryTask = 'copado__User_Story_Task__c'

    // Selected objects simple Name Label Variable
    objUserStoryLable =  'Copado User Story '
    objUserStoryTaskLable = 'Copado User Story Task' 


    userStoryValue=false
    userStoryTaskValue=false


    @track options = [
        { label: 'Copado User Story', value: 'copado__User_Story__c' , disabled: false },
        { label: 'Copado User Story Task', value: 'copado__User_Story_Task__c' , disabled: false  },
      ];
    
      handleChange(event) {
        const selectedValue = event.target.value;
       
        console.log('selectedValue==='+selectedValue);
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
                console.log('this.objectName==='+this.objectName);
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
          console.log('this.objectName==='+this.objectName);
          this.ObjectLabel = this.objUserStoryTaskLable;
          console.log('this.ObjectLabel==='+this.ObjectLabel);
          
      }else{
          this.userStoryTaskValue = false;
          if(selectedValue ==''){
              this.objectName = '';
              this.childObjectListPopup = false;
      }
      }
      }

}