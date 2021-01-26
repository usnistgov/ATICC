package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"

	"github.com/usnistgov/ATICC/Coordinator/endpoints"
)

// ParseFlags provides all runtime arguments for the coordinator
func ParseFlags() (string, error) {
	var port = flag.Int("port", 8081, "Port that the web server will run on")

	flag.Parse()

	address := fmt.Sprintf(":%d", *port)

	return address, nil
}

func main() {
	address, err := ParseFlags()
	if err != nil {
		log.Fatal("Failed to parse arguments: ", err)
	}

	http.HandleFunc("/status", endpoints.Status)
	http.HandleFunc("/scenario", endpoints.Scenario)

	log.Printf("Mapped routes, listening on %s", address)

	err = http.ListenAndServe(address, nil)
	if err != nil {
		log.Fatal("Failed to start web server: ", err)
	}
}
