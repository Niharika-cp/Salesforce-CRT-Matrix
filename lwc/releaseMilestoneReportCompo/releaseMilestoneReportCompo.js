import { LightningElement,track,wire } from 'lwc';
import getMilestones from '@salesforce/apex/ReleaseMilestoneController.getMilestones';

export default class ReleaseMilestoneReportCompo extends LightningElement {
    @track releases = [];
    @track environments = [];

    @wire(getMilestones)
    wiredMilestones({ error, data }) {
        if (data) {
            this.processData(data);
        } else if (error) {
            console.error('Error retrieving milestones:', error);
        }
    }

    processData(milestones) {
        // Unique list of environments
        const envSet = new Set(milestones.map(ms => ms.Environment__r.Name));
        this.environments = Array.from(envSet).sort();

        // Mapping milestones by release
        const releaseMap = new Map();
        milestones.forEach((ms, index) => {
            const releaseName = ms.Release__r.Name;
            const envName = ms.Environment__r.Name;
            if (!releaseMap.has(releaseName)) {
                releaseMap.set(releaseName, {});
            }
            
            if (!releaseMap.get(releaseName)[envName]) {
                releaseMap.get(releaseName)[envName] = { startDates: [], endDates: [], startKeys: [], endKeys: [] };
            }
            const envData = releaseMap.get(releaseName)[envName];
            envData.startDates.push(ms.Start_Date__c);
            envData.endDates.push(ms.End_Date__c);
            // Creating unique keys for each date
            envData.startKeys.push(`start-${index}`);
            envData.endKeys.push(`end-${index}`);
        });

        // Calculate the rowspan value based on the environments length
        // Assuming each environment has two rows (start date and end date)
        const rowspanValue = this.environments.length * 2;

        // Convert map to array for rendering
        this.releases = Array.from(releaseMap, ([releaseName, envData]) => {
            return {
                releaseName,
                // Add the rowspan value to each release object
                rowspan: rowspanValue,
                environments: this.environments.map(envName => {
                    // Ensure that we have data for each environment
                    const environment = envData[envName] || { startDates: [], endDates: [], startKeys: [], endKeys: [] };
                    // Now we create a new array that combines the dates and keys into single objects for the template
                    const datesWithKeys = environment.startDates.map((startDate, index) => {
                        return {
                            startDate,
                            endDate: environment.endDates[index],
                            startKey: environment.startKeys[index],
                            endKey: environment.endKeys[index]
                        };
                    });
                    return {
                        envName,
                        datesWithKeys // This is an array of objects with startDate, endDate, startKey, endKey
                    };
                })
            };
        });
    }
}