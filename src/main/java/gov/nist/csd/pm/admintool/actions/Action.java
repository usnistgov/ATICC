package gov.nist.csd.pm.admintool.actions;

import java.util.HashMap;
import java.util.Map;

public abstract class Action {
    protected Map<String, Element> params = new HashMap<>();
    protected String name;

    public int getParamsLength() {
        return params.keySet().size();
    }

    protected Map<String, Element> getParams() {
        return params;
    }

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
            case NODETYPE:
//                params.put(paramName, new Element<Node>(paramType));
                break;
            case OPERATION:
//                params.put(paramName, new Element<String>(paramType));
                break;
            case STRING:
//                params.put(paramName, new Element<String>(paramType));
                break;
        }
    }

    public void setParamValue (String paramName, Object paramValue) {
        Element element = params.get(paramName);
        if (element != null) {
            element.setValue(paramValue);
        } else {
            // todo: throw exception
            System.out.println("no such element with param name: " + paramName);
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

    public enum Type {
        NODETYPE, OPERATION, STRING
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