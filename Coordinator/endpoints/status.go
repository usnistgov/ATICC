package endpoints

import (
	"fmt"
	"net/http"
)

// Status is a DEMO 'hello world' endpoint and is only intended for demonstration
func Status(w http.ResponseWriter, r *http.Request) {
	// write json status message
	_, err := fmt.Fprintf(w, "{\"status\": \"ok\"}")
	if err != nil {
		// some error writing to response buffer?
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	// set Content-Type header to JSON so that it can be parsed by sender
	w.Header().Set("Content-Type", "application/json")
}
