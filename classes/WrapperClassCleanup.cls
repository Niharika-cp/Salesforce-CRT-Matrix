public with sharing class WrapperClassCleanup {      // This Class is used for fetching all child record
   
    @AuraEnabled    public String id { get; set; }   // for Child Record Id
    @AuraEnabled    public String name { get; set; }  // for Child Record Name
    @AuraEnabled    public String parent { get; set; } // parent record name
    @AuraEnabled    public String parentType { get; set; } // parent object name
    @AuraEnabled    public String type { get; set; }  // child object name
      
        public WrapperClassCleanup(String id, String name, String parent, String parentType, String type) {
          this.id = id;
          this.name = name;
          this.parent = parent;
          this.parentType = parentType;
          this.type = type;
        }
      
}