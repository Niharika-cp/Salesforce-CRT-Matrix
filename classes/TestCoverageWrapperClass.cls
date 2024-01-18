public class TestCoverageWrapperClass {
    public Integer size;
	public Integer totalSize;
	public Boolean done;
	public Object queryLocator;
	public String entityTypeName;
	public List<Records> records;

	public class ApexTestClass {
		public Attributes attributes;
		public String Name;
	}

	public class Attributes {
		public String type;
		public String url;
	}

	public class Records {
		public Attributes attributes;
		public ApexTestClass ApexTestClass;
		public ApexTestClass ApexClassOrTrigger;
		public String TestMethodName;
		public Integer NumLinesCovered;
		public Integer NumLinesUncovered;
	}
  
  }