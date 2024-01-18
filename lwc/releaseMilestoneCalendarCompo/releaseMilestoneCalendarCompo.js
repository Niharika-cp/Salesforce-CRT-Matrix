import { LightningElement, track } from 'lwc';

export default class ReleaseMilestoneCalendarCompo extends LightningElement {
    @track daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    @track calendarDays = [];
    @track monthLabel;
    @track year;
    currentDate = new Date();

    connectedCallback() {
        this.generateCalendar();
    }

    generateCalendar() {
        this.calendarDays = [];

        this.monthLabel = this.currentDate.toLocaleString('default', { month: 'long' });
        this.year = this.currentDate.getFullYear();
    
        let firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1);
        let lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0);
    
        let daysInMonth = lastDayOfMonth.getDate();
        let firstDayWeekday = firstDayOfMonth.getDay();
    
        // Create placeholders for the empty slots before the first day of the month
        let days = [];
        for (let i = 0; i < firstDayWeekday; i++) {
            days.push({ label: '', key: `empty-before-${i}`, classes: 'day empty' });
        }
    
        // Create the actual days of the month
        for (let i = 1; i <= daysInMonth; i++) {
            days.push({ label: i, key: `day-${i}`, classes: 'day' });
        }
    
        // Fill the rest of the last week of the month with empty placeholders
        let lastDayWeekday = lastDayOfMonth.getDay();
        for (let i = lastDayWeekday; i < 6; i++) {
            days.push({ label: '', key: `empty-after-${i}`, classes: 'day empty' });
        }
    
        // Chunk the days into weeks to be displayed as rows
        let week = [];
        days.forEach((day, index) => {
            week.push(day);
            if (week.length === 7) {
                this.calendarDays.push(week);
                week = [];
            }
        });
    }
    

    goToPreviousMonth() {
        this.currentDate.setMonth(this.currentDate.getMonth() - 1);
        this.generateCalendar();
    }

    goToNextMonth() {
        this.currentDate.setMonth(this.currentDate.getMonth() + 1);
        this.generateCalendar();
    }
}