package gov.nist.csd.pm.admintool.actions;

import java.util.ArrayList;

public class SingletonActiveActions extends ArrayList<Action> {
    public static SingletonActiveActions actions;
    private SingletonActiveActions(){
        super();
        //Prevent form the reflection api.
        if (actions != null){
            throw new RuntimeException("Use getInstance() method to get the single instance of this class.");
        }
    }

    public synchronized static SingletonActiveActions getInstance() {
        if (actions == null){ // if there is no instance available... create new one
            actions = new SingletonActiveActions();
        }
        return actions;
    }

    public static boolean addTest(Action testToAdd) {
        return actions.add(testToAdd);
    }

    public static boolean removeTest(Action testToRemove) {
        return actions.remove(testToRemove);
    }

    public static void removeAllTests() {
        for (int i = 0; i < actions.size(); i++) {
            actions.remove(0);
        }
    }
}
