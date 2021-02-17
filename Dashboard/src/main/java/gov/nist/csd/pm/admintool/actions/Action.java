package gov.nist.csd.pm.admintool.actions;

import gov.nist.csd.pm.admintool.app.MainView;
import gov.nist.csd.pm.admintool.services.CoordinatorScenarioResponse;

import java.util.HashMap;
import java.util.Map;

public abstract class Action {
    public static String coordinatorURL = "http://localhost:8081";

    protected Map<String, Element> params = new HashMap<>();
    protected String name;

    public int getParamsLength() {
        return params.keySet().size();
    }

    protected Map<String, Element> getParams() {
        return params;
    }

    public CoordinatorScenarioResponse storedResponse;

    public Map<String, Type> getParamNamesAndTypes() {
        HashMap<String, Type> ret = new HashMap<>();
        for (String key: params.keySet()) {
            ret.put(key, params.get(key).type);
        }
        return ret;
    }

    protected Element getElement(String paramName) {
        return params.get(paramName);
    }

    protected void addParam(String paramName, Type paramType) {
        switch (paramType) {
            case STRING:
                params.put(paramName, new Element<String>(paramType));
                break;
            case INT:
                params.put(paramName, new Element<Integer>(paramType));
                break;
        }
    }

    public void setParamValue (String paramName, Object paramValue) {
        Element element = params.get(paramName);
        if (element != null) {
            element.setValue(paramValue);
        } else {
            MainView.notify("no such element with param name: " + paramName, MainView.NotificationType.ERROR);
            throw new IllegalArgumentException("no such element with param name: " + paramName);
        }
    }

    public String getName() {
        return name;
    }

    protected void setName(String name) {
        this.name = name;
    }

    public abstract boolean run();

    public abstract String explain();

    public abstract String toString();

    public enum Type {
        STRING, INT
    }

    protected class Element<K> {
        Type type;
        K value;
        public Element(Type type) {
            this.type = type;
            value = null;
        }

        public K getValue() {
            return value;
        }

        public void setValue(K value) {
            this.value = value;
        }
    }
}