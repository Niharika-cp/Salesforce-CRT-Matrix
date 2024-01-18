public class updatedescriptionHandler {
        private static Boolean isFirstRun = true;
    
    public static Boolean shouldRun() {
        if (isFirstRun) {
            isFirstRun = false;
            return true;
        }
        return false;
    }

}