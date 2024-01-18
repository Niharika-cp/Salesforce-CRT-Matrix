import { LightningElement, track} from 'lwc';

export default class CreateDynamicRecord extends LightningElement {
  




@track selectedStep = 'Cleanup Operation';

    
showSecondRadio = false;

steps = [{label: "Cleanup Operation", value: "1"}, {label: "Entity Selection", value: "2"}, {label: "Data Selection", value: "3"}, {label: "Review Selection", value: "4"}];
current = "1";



handleNext() {
    var getselectedStep = this.selectedStep;
    if(getselectedStep === 'Cleanup Operation'){
        this.selectedStep = 'Entity Selection';
    }
    else if(getselectedStep === 'Entity Selection'){
        this.selectedStep = 'Data Selection';
    }
    else if(getselectedStep === 'Data Selection'){
        this.selectedStep = 'Review Selection';
    }
}

handlePrev() {
    var getselectedStep = this.selectedStep;
    if(getselectedStep === 'Entity Selection'){
        this.selectedStep = 'Cleanup Operation';
    }
    else if(getselectedStep === 'Data Selection'){
        this.selectedStep = 'Entity Selection';
    }
    else if(getselectedStep === 'Review Selection'){
        this.selectedStep = 'Data Selection';
    }
}
  
handleFinish() {
   alert('Finished...');
    this.selectedStep = 'Cleanup Operation';
}
  
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

get isSelectStep4() {
    return this.selectedStep === "Review Selection";
}
}