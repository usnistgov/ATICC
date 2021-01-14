package gov.nist.csd.pm.admintool.actions.scenarios;

import com.sun.org.apache.regexp.internal.RE;
import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.services.RestService;
import org.apache.http.client.HttpClient;


public class Ping extends Action {

    public Ping() {
        setName("Ping Scenario");
        addParam("Address", Type.STRING);
        addParam("Count", Type.INT);
    }

    @Override
    public boolean run() {
        String address = ((String)getParams().get("Address").getValue());
        int count = ((int)getParams().get("Count").getValue());



        return false;
    }

    @Override
    public String explain() {
        String address = ((String)getParams().get("Address").getValue());
        int count = ((int)getParams().get("Count").getValue());

        return "Something";
    }

    @Override
    public String toString() {
        String address = ((String)getParams().get("Address").getValue());
        int count = ((int)getParams().get("Count").getValue());
        return name + " [Address: " + address + "; Count: " + count + "]";
    }
}
