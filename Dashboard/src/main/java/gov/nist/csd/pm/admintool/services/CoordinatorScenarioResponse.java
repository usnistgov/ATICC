package gov.nist.csd.pm.admintool.services;

public class CoordinatorScenarioResponse {
    public Boolean success;
    public String summary;

    public CoordinatorScenarioResponse() {}

    public CoordinatorScenarioResponse (Boolean success, String summary) {
        this.success = success;
        this.summary = summary;
    }
}
