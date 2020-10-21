package scenarios

import (
	"log"
)

type pingRequest struct {
	Address string `json:"address"`
	Count   int    `json:"count"`
}

func (p pingRequest) Run() (*ScenarioResponse, error) {
	log.Printf("Pinging address %s (%d times)", p.Address, p.Count)

	// todo

	return &ScenarioResponse{
		Success: true,
		Summary: "",
	}, nil
}

func (p pingRequest) GetType() string {
	return "ping"
}
