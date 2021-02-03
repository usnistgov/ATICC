package scenarios

import (
	"log"
	"os/exec"
	"strconv"
	"strings"
)

type pingRequest struct {
	Address string `json:"address"`
	Count   int    `json:"count"`
}

func (p pingRequest) Run() (*ScenarioResponse, error) {
	log.Printf("Pinging address %s (%d times)", p.Address, p.Count)

	// ping -c p.Count p.Address > /dev/null && echo "1" || echo "0"
	// if "1" then it connected, otherwise not.

	command := exec.Command("sh", "-c",
		"ping -c "+strconv.Itoa(p.Count)+" "+p.Address+" > /dev/null && echo \"1\" || echo \"0\"")

	out, err := command.CombinedOutput()
	if err != nil {
		log.Fatal(err)
	}

	var response ScenarioResponse

	if strings.HasPrefix(string(out), "1") {
		response = ScenarioResponse{
			Success: true,
			Summary: "The console output was: \n" + string(out),
		}
	} else {
		response = ScenarioResponse{
			Success: false,
			Summary: "The console output was: \n" + string(out),
		}
	}

	return &response, nil
}

func (p pingRequest) GetType() string {
	return "ping"
}
