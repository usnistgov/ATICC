package gov.nist.csd.pm.admintool.actions.scenarios;

import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.services.RestService;
import gov.nist.csd.pm.admintool.services.coordinatorResponse;
import org.springframework.http.HttpMethod;

import java.util.HashMap;
import java.util.Map;


public class Ping extends Action {

    public Ping() {
        setName("Ping Scenario");
        addParam("Address", Type.STRING);
        addParam("Count", Type.INT);
    }

    @Override
    public boolean run() {
        String address = ((String)getParams().get("Address").getValue());
        Integer count = ((Integer)getParams().get("Count").getValue());

        Map<String,Object> subParams = new HashMap<String, Object>();
        subParams.put("Address", address);
        subParams.put("Count", count);

        Map<String,Object> params = new HashMap<String, Object>();
        params.put("type", "ping");
        params.put("body", subParams);

        coordinatorResponse response = RestService
                .sendRequest(Action.coordinatorURL.concat("/scenario"), HttpMethod.POST, params);
        Boolean success = response.success;

        if (success) {
            this.explanation = "Ping test to " + address + " passed " + count + " times.";
        } else {
            this.explanation = "Ping test to " + address + " failed:\n" + response.summary;
        }

        return success;
    }

    @Override
    public String toString() {
        String address = ((String)getParams().get("Address").getValue());
        int count = ((int)getParams().get("Count").getValue());
        return name + " [Address: " + address + "; Count: " + count + "]";
    }
}