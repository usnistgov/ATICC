package gov.nist.csd.pm.admintool.actions.scenarios;

import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.services.CoordinatorScenarioResponse;
import gov.nist.csd.pm.admintool.services.RestService;
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
    public CoordinatorScenarioResponse run() {
        String address = ((String)getParams().get("Address").getValue());
        Integer count = ((Integer)getParams().get("Count").getValue());

        Map<String,Object> subParams = new HashMap<String, Object>();
        subParams.put("Address", address);
        subParams.put("Count", count);

        Map<String,Object> params = new HashMap<String, Object>();
        params.put("type", "ping");
        params.put("body", subParams);


        //CoordinatorScenarioResponse response = RestService
        return RestService
                .sendRequest(Action.coordinatorURL.concat("/scenario"), HttpMethod.POST, params);

//        return this.storedResponse;
    }

    @Override
    public String explain() {
        String address = ((String)getParams().get("Address").getValue());
        Integer count = ((Integer)getParams().get("Count").getValue());
        Boolean success = analyze();
        String explanation;

        if (this.storedResponse.success) {
            explanation = "Ping test to " + address + " passed " + count + " times.";
        } else {
            explanation = "Ping test to " + address + " failed:\n" + storedResponse.summary;
        }

        if (expectedSuccess) {
            explanation += "\n---\nExpected Result: Success";
        } else {
            explanation += "\n---\nExpected Result: Failure";
        }

        if (success) {
            explanation += "\n---\nThe Results Matched";
        } else {
            explanation += "\n---\nThe Results did not Match";
        }

        return explanation;
    }

    @Override
    public String toString() {
        String address = ((String)getParams().get("Address").getValue());
        int count = ((int)getParams().get("Count").getValue());
        return name + " [Address: " + address + "; Count: " + count + "]"
                + " [Expected Result: " + (expectedSuccess ? "True" : "False") + "]";
    }
}
