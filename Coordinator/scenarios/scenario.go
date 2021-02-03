package scenarios

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
)

// ScenarioResponse is returned from all IScenario.Run() implementations
type ScenarioResponse struct {
	Success bool   `json:"success"`
	Summary string `json:"summary"`
}

// IScenario defines what members each scenario should implement
type IScenario interface {
	Run() (*ScenarioResponse, error)
	GetType() string
}

// UnmarshalScenarioJSON unmarshall scenario based on type key, returning an IScenario impl
func UnmarshalScenarioJSON(body io.Reader) (IScenario, error) {
	data, err := ioutil.ReadAll(body)
	if err != nil {
		return nil, err
	}

	rawScenario := struct {
		// selector for scenario type
		Type string `json:"type"`
		// "partially" decoded body
		Body json.RawMessage `json:"body"`
	}{}

	err = json.Unmarshal(data, &rawScenario)
	if err != nil {
		return nil, err
	}

	switch rawScenario.Type {
	case "ping":
		var scenario pingRequest
		err = json.Unmarshal(rawScenario.Body, &scenario)
		return scenario, err
	default:
		return nil, fmt.Errorf("Unknown test type: %s", rawScenario.Type)
	}
}
