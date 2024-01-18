/*************************************************Run this for creating sample data in Test_Obj_to_Mask__c**********************************************/
List<String> cityName  = new List<String>{
		'Agra',
		'Ahmedabad',
		'Bangalore',
		'Bhopal',
		'Chennai',
		'Coimbatore',
		'Delhi',
		'Ghaziabad',
		'Hyderabad',
		'Indore',
		'Jaipur',
		'Kanpur',
		'Kolkata',
		'Lucknow',
		'Ludhiana',
		'Madurai',
		'Mumbai',
		'Nagpur',
		'Patna',
		'Pune',
		'Surat',
		'Thane',
		'Vadodara',
		'Visakhapatnam',
		'Nashik',
		'Faridabad',
		'Meerut',
		'Rajkot',
		'Dombivali',
		'Vasai-Virar',
		'Varanasi',
		'Srinagar',
		'Aurangabad',
		'Dhanbad',
		'Amritsar',
		'Navi Mumbai',
		'Allahabad',
		'Ranchi',
		'Howrah',
		'Jabalpur',
		'Gwalior',
		'Vijayawada',
		'Jodhpur',
		'Raipur',
		'Kota',
		'Guwahati',
		'Chandigarh',
		'Thiruvananthapuram',
		'Solapur'
};

List<String> aboutMe = new List<String>{
	'I am cool',
	'I am Super cool',
	'I like Playing',
	'I like Dancing',
	'I like Reading',
	'I love Salesforce',
	'I am a Cinephile',
	'Wanderlust',
	'Techomaniac',
	'I am into Computer Games'
};

List<String> emailDomains = new List<String>{'@gmail.com','@hotmail.com','@live.com','@yahoo.com','@yahoomail.com','@aol.com','@rediffmail.com','@outlook.com'};

Date myDate = Date.newInstance(2017, 1, 18);

List<Test_Obj_to_Mask__c> testObjectList = new List<Test_Obj_to_Mask__c>();

//change i<100 to any number <=10000
for(Integer i=0;i<100;i++){
	Test_Obj_to_Mask__c obj = new Test_Obj_to_Mask__c();
	obj.Name = 'Test Object ' +  String.ValueOf(i);
	obj.About_me__c = aboutMe.get(math.mod(i, aboutMe.size()));
	obj.city__c = cityName.get(math.mod(i, cityName.size()));
	obj.Email__c = 'Email'+  String.ValueOf(i) + emailDomains.get(math.mod(i,emailDomains.size()));
	obj.isUseful__c = math.mod(i,2)==0?true:false;
	obj.My_Location__Longitude__s = math.mod((5+i),90);
	obj.My_Location__Latitude__s = math.mod((7+i),90);
	obj.Phone__c = String.valueOf(math.mod((100000000 + i*72989354),999999999));
	obj.roll_Num__c = i;
	obj.scheduled_Date__c = mydate.addDays(math.mod(i,120));
	obj.Serial_Number__c = math.mod((1000 + i*729),9999);
	obj.Task_Name__c = 'Task'+ String.ValueOf(i);
	testObjectList.add(obj);
}

insert testObjectList;
/*************************************************Run this for creating sample data in Test_Obj_to_Mask__c**********************************************/


/*************************************************Run this for deleting all data in Test_Obj_to_Mask__c**************************************************/
delete [SELECT ID from Test_Obj_to_Mask__c];
/*************************************************Run this for deleting all data in Test_Obj_to_Mask__c**************************************************/


/*************************************************Run this for deleting all data in Data_Dictionary__c***************************************************/
delete [SELECT ID from Data_Dictionary__c];
/*************************************************Run this for deleting all data in Data_Dictionary__c***************************************************/

/*************************************************Run this for viewing all data in Test_Obj_to_Mask__c*************************************************/
SELECT 	Id, 
					Name, 
					About_me__c, 
					city__c, 
					Email__c, 
					isUseful__c, 
					My_Location__c, 
					Phone__c, 
					roll_Num__c, 
					scheduled_Date__c, 
					Serial_Number__c, 
					Task_Name__c 
from Test_Obj_to_Mask__c
/*************************************************Run this for viewing all data in Test_Obj_to_Mask__c*************************************************/
