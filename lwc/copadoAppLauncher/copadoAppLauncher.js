import { LightningElement,track } from 'lwc';
import DoraIcon from '@salesforce/resourceUrl/DoraIcon';
import AuditLogo from '@salesforce/resourceUrl/AuditLogo';
import CleanUpIcon from '@salesforce/resourceUrl/CleanUpIcon';
import Logs from '@salesforce/resourceUrl/AuditLogs';
export default class CopadoAppLauncher extends LightningElement {
    @track checkCC= false;
    @track checkFA= false;
    @track checkAL= false;
    @track checkDR= false;  
    showCCInfo1(){
        this.checkCC = false;
        if(this.checkCC==false){
            this.template.querySelector('.data-1').innerText = 'This Utility helps to keep your Copado Infrastructure Clean ';
    }
        
    }
    showCCInfo2(){
        this.checkCC = true;
        if(this.checkCC == true){
            this.template.querySelector('.data-1').innerText = 'This Utility helps to keep your Copado infrastructure clean by deleting unwanted attachments, deployment failures records, validation, and successful promotion branches. ';
            
        }
        
    }

    showFAInfo1(){
        this.checkFA = false;
        if(this.checkFA==false){
            this.template.querySelector('.data-2').innerText = 'The Copado Feature Audit will run against your Copado Installation';
    }
        
    }
    showFAInfo2(){
        this.checkFA = true;
        if(this.checkFA == true){
            this.template.querySelector('.data-2').innerText = 'The Copado Feature Audit will run against your Copado Installation and prepares a report of Copado Features that are currently being used by your team based on your license and the impact of unused features.';
            
        }
        
    }
    showALInfo1(){
        this.checkAL = false;
        if(this.checkAL==false){
            this.template.querySelector('.data-3').innerText = 'Audit Log will capture the transactions done thourgh this utility.';
    }
        
    }
    showALInfo2(){
        this.checkAL = true;
        if(this.checkAL == true){
            this.template.querySelector('.data-3').innerText = 'The Audit Log will capture the transactions done through this utility. It holds data like operation type, user, and timestamp, which also helps report the clean-up activities performed. ';
            
        }
        
    }
    showDRInfo1(){
        this.checkDR = false;
        if(this.checkDR==false){
            this.template.querySelector('.data-4').innerText = 'DORA principles are basis for defining DevOps Maturity Model.';
    }
        
    }
    showDRInfo2(){
        this.checkDR = true;
        if(this.checkDR == true){
            this.template.querySelector('.data-4').innerText = ' DORA principles are the basis for defining DevOps Maturity Model. The Current version of DORA Reports contains Deployment Frequency, Lead Time to change, Failure/Success rate, and Time to Recovery. ';
            
        }
        
    }
    get dora(){
        return DoraIcon;
    }
    get audit(){
        return AuditLogo;
    }
    get CleanUp(){
        return CleanUpIcon;
    }
    get logs(){
        return Logs;
    }
}