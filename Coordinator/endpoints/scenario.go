package endpoints

import (
	"encoding/json"
	"net/http"

	"github.com/usnistgov/ATICC/Coordinator/scenarios"
)

// Scenario is an endpoint used to request a new test
func Scenario(w http.ResponseWriter, r *http.Request) {
	scenario, err := scenarios.UnmarshalScenarioJSON(r.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	response, err := scenario.Run()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	responseJSON, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	_, err = w.Write(responseJSON)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
