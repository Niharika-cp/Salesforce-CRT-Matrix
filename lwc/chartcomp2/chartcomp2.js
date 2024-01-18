import { LightningElement, wire } from 'lwc';
//import count from '@salesforce/apex/ChartWire.getCount'
import Name from '@salesforce/apex/ChartWire.getName'
import Emp from '@salesforce/apex/ChartWire.getEmpty'
import scheduled from '@salesforce/apex/ScheduleChart.scheduled'
import warn from '@salesforce/apex/ChartObjectQuery.warnScheduled'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Chartcomp2 extends LightningElement {
    val=[];
    check=false;
    opps = false;
    

    columns;
    arr0;
    arr1 ;
    arr2 ;
    arr3 ;
    arr4 ;
    arr5 ;
    arr6 ;
    arr7 ;
    arr8 ;
    arr9 ;
    arr10;
    arr11;
    arr12;
    arr13;
    arr14;
    arr15;
    arr16;
    arr17;
    arr18;
    arr19;
    arr20;
    arr21;
    arr22;
    arr23;
    arr24;
    arr25;
    arr26;
    arr27;
    arr28;
    arr29;
    arr30;
    arr31;


    n0 ;
    n1 ;
    n2 ;
    n3 ;
    n4 ;
    n5 ;
    n6 ;
    n7 ;
    n8 ;
    n9 ;
    n10;
    n11;
    n12;
    n13;
    n14;
    n15;
    n16;
    n17;
    n18;
    n19;
    n20;
    n21;
    n22;
    n23;
    n24;
    n25;
    n26;
    n27;
    n28;
    n29;
    n30;
    n31;

    @wire(Name) 
    name({data}){
        if(data){
            if(data.x0.X__c != 0 & data.x0.Y__c!=0){
            this.arr0 = [{"x": data.x0.X__c,"y": data.x0.Y__c,"r":10}]
            this.n0 = data.x0.Name;
        }
        if(data.x1.X__c != 0 & data.x1.Y__c!=0){
            this.arr1 = [{"x": data.x1.X__c,"y": data.x1.Y__c,"r":10}]
            this.n1 = data.x1.Name;
        }
        if(data.x2.X__c != 0 & data.x2.Y__c!=0){
            this.arr2 = [{"x": data.x2.X__c,"y": data.x2.Y__c,"r":10}]
            this.n2  = data.x2.Name;
        }
        if(data.x3.X__c != 0 & data.x3.Y__c!=0){
            this.arr3 = [{"x": data.x3.X__c,"y": data.x3.Y__c,"r":10}]
            this.n3 = data.x3.Name;
        }
        if(data.x4.X__c != 0 & data.x4.Y__c!=0){
            this.arr4 = [{"x": data.x4.X__c,"y": data.x4.Y__c,"r":10}]
            this.n4 = data.x4.Name;
        }
        if(data.x5.X__c != 0 & data.x5.Y__c!=0){
            this.arr5 = [{"x": data.x5.X__c,"y": data.x5.Y__c,"r":10}]
            this.n5 = data.x5.Name;
        }
        if(data.x6.X__c != 0 & data.x6.Y__c!=0){
            this.arr6 = [{"x": data.x6.X__c,"y": data.x6.Y__c,"r":10}]
            this.n6 = data.x6.Name;
        }
        if(data.x7.X__c != 0 & data.x7.Y__c!=0){
            this.arr7 = [{"x": data.x7.X__c,"y": data.x7.Y__c,"r":10}]
            this.n7 = data.x7.Name;
        }
        if(data.x8.X__c != 0 & data.x8.Y__c!=0){
            this.arr8 = [{"x": data.x8.X__c,"y": data.x8.Y__c,"r":10}]
            this.n8 = data.x8.Name;
        }
        if(data.x9.X__c != 0 & data.x9.Y__c!=0){
            this.arr9 = [{"x": data.x9.X__c,"y": data.x9.Y__c,"r":10}]
            this.n9 = data.x9.Name;
        }
        if(data.x10.X__c != 0 & data.x10.Y__c!=0){
            this.arr10 = [{"x": data.x10.X__c,"y": data.x10.Y__c,"r":10}]
            this.n10= data.x10.Name;
        }
        if(data.x11.X__c != 0 & data.x11.Y__c!=0){
            this.arr11 = [{"x": data.x11.X__c,"y": data.x11.Y__c,"r":10}]
            this.n11= data.x11.Name;
        }
        if(data.x12.X__c != 0 & data.x12.Y__c!=0){
            this.arr12 = [{"x": data.x12.X__c,"y": data.x12.Y__c,"r":10}]
            this.n12= data.x12.Name;
        }
        if(data.x13.X__c != 0 & data.x13.Y__c!=0){
            this.arr13 = [{"x": data.x13.X__c,"y": data.x13.Y__c,"r":10}]
            this.n13= data.x13.Name;
        }
        if(data.x14.X__c != 0 & data.x14.Y__c!=0){
            this.arr14 = [{"x": data.x14.X__c,"y": data.x14.Y__c,"r":10}]
            this.n14= data.x14.Name;
        }
        if(data.x15.X__c != 0 & data.x15.Y__c!=0){
            this.arr15 = [{"x": data.x15.X__c,"y": data.x15.Y__c,"r":10}]
            this.n15= data.x15.Name;
        }
        if(data.x16.X__c != 0 & data.x16.Y__c!=0){
            this.arr16 = [{"x": data.x16.X__c,"y": data.x16.Y__c,"r":10}]
            this.n16= data.x16.Name;
        }
        if(data.x17.X__c != 0 & data.x17.Y__c!=0){
            this.arr17 = [{"x": data.x17.X__c,"y": data.x17.Y__c,"r":10}]
            this.n17= data.x17.Name;
        }
        if(data.x18.X__c != 0 & data.x18.Y__c!=0){
            this.arr18 = [{"x": data.x18.X__c,"y": data.x18.Y__c,"r":10}]
            this.n18= data.x18.Name;
        }
        if(data.x19.X__c != 0 & data.x19.Y__c!=0){
            this.arr19 = [{"x": data.x19.X__c,"y": data.x19.Y__c,"r":10}]
            this.n19= data.x19.Name;
        }
        if(data.x20.X__c != 0 & data.x20.Y__c!=0){
            this.arr20 = [{"x": data.x20.X__c,"y": data.x20.Y__c,"r":10}]
            this.n20= data.x20.Name;
        }
        if(data.x21.X__c != 0 & data.x21.Y__c!=0){
            this.arr21 = [{"x": data.x21.X__c,"y": data.x21.Y__c,"r":10}]
            this.n21= data.x21.Name;
        }
        if(data.x22.X__c != 0 & data.x22.Y__c!=0){
            this.arr22 = [{"x": data.x22.X__c,"y": data.x22.Y__c,"r":10}]
            this.n22= data.x22.Name;
        }
        
        if(data.x23.X__c != 0 & data.x23.Y__c!=0){
            this.arr23 = [{"x": data.x23.X__c,"y": data.x23.Y__c,"r":10}]
            this.n23= data.x23.Name;
        }
        if(data.x24.X__c != 0 & data.x24.Y__c!=0){
            this.arr24 = [{"x": data.x24.X__c,"y": data.x24.Y__c,"r":10}]
            this.n24= data.x24.Name;
        }
        if(data.x25.X__c != 0 & data.x25.Y__c!=0){
            this.arr25 = [{"x": data.x25.X__c,"y": data.x25.Y__c,"r":10}]
            this.n25= data.x25.Name;
        }
        if(data.x26.X__c != 0 & data.x26.Y__c!=0){
            this.arr26 = [{"x": data.x26.X__c,"y": data.x26.Y__c,"r":10}]
            this.n26= data.x26.Name;
        }
        if(data.x27.X__c != 0 & data.x27.Y__c!=0){
            this.arr27 = [{"x": data.x27.X__c,"y": data.x27.Y__c,"r":10}]
            this.n27= data.x27.Name;
        }
        if(data.x28.X__c != 0 & data.x28.Y__c!=0){
            this.arr28 = [{"x": data.x28.X__c,"y": data.x28.Y__c,"r":10}]
            this.n28= data.x28.Name;
        }
        if(data.x29.X__c != 0 & data.x29.Y__c!=0){
            this.arr29 = [{"x": data.x29.X__c,"y": data.x29.Y__c,"r":10}]
            this.n29= data.x29.Name;
        }
        if(data.x30.X__c != 0 & data.x30.Y__c!=0){
            this.arr30 = [{"x": data.x30.X__c,"y": data.x30.Y__c,"r":10}]
            this.n30= data.x30.Name;
        }
        if(data.x31.X__c != 0 & data.x31.Y__c!=0){
            this.arr31 = [{"x": data.x31.X__c,"y": data.x31.Y__c,"r":10}]
            this.n31= data.x31.Name;
        }
    }
    }
    // @wire(count) 
    // count({data}){
    //     if(data){
            
    //     }
    // }
    @wire(Emp) 
    count2({data}){
    this.val = data;
    // if(this.val==[]){
    //     this.check = false;
    // }
    // else{
        console.log(this.val)
        console.log(typeof(this.val))
            this.check = true;    
            this.columns = [
                { label: 'Features', fieldName: 'Name'},
                { label: 'Priority', fieldName: 'Priority__c'},
                { label: 'Impact', fieldName: 'Impact__c'},
                { label: 'More Information', fieldName: 'More_Information__c', type:'textarea', wrapText:true }]
        }
        
        handleClick(){
            scheduled()
                .then(result =>{
                    console.log(result);
                    if(result!='Dont Allow'){
                    const event = new ShowToastEvent({
                        title: 'Scheduled Successfully',
                        message: 'New Chart will be visible from next day 6AM',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                }
                else{
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Chart Generation already scheduled',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }

                })
                .catch(error =>{
                    console.log(error);
                    
                })
                
                    
                }
                @wire(warn)
                warn({data}){
                    if (data =='Schedule Chart'){
                        this.opps = true;
                    }
                }
                    
                                    
                
            
        // @wire(schedule)
        // sch({data,error}){
        //     if(data){
        //             const event = new ShowToastEvent({
        //                 title: 'Scheduled Successfully',
        //                 message: 'New Chart will be visible from next day 5AM',
        //                 variant: 'success',
        //                 mode: 'dismissable'
        //             });
        //             this.dispatchEvent(event);
        //         }
            
        //         if(error){
        //                 const evt = new ShowToastEvent({
        //                     title: 'Error',
        //                     message: 'Chart Generation already scheduled',
        //                     variant: 'error',
        //                     mode: 'dismissable'
        //                 });
        //                 this.dispatchEvent(evt);
        //             }
        //         }
            
            
            
        

        
        
        // }
}


//     @wire(countcon) 
//     count1({data,error}){
//         if(data){
//             this.arr2 = [{"x": 2,"y": data,"r":10}];
//             this.error = undefined;
//             console.log(data)
//         }
//         else if(error){
//             this.error=error;
//             this.record = undefined;
//         }
//     }
//     @wire(count) 
//     count2({data}){
//         if(data){
//             this.arr1 = [{"x": 2,"y": data,"r":10}];
//         }
//     }
    
//     detailone = '[{"x": 2,"y": 2,"r":10}]';
//     get detailone() {
//         return this.detailone;
//     }
//     set detailone(value) {
//         this.detailone = value;
//     }
//     @wire (countopp)
//     oppcou({data}){
//         if(data){
//             this.arr3 = [{"x": 2,"y": data,"r":10}]
//         }
//     }