package scenarios

import (
	"strings"
	"testing"
)

func TestUnmarshalScenarioJSON(t *testing.T) {
	// todo: create a more generic test
	r := strings.NewReader(`{
		"type": "ping",
		"body": {
			"address": "127.0.0.1",
			"count": 1
		}
	}`)
	scenario, err := UnmarshalScenarioJSON(r)
	if err != nil {
		t.Logf("Scenario unmarshalling failed: %s", err.Error())
		t.FailNow()
	}

	if scenario.GetType() != "ping" {
		t.Log("Incorrect scenario type")
		t.FailNow()
	}
}
