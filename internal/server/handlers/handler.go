package handlers

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/zerolog/log"
)

func ConfigureHandlers() (r *mux.Router) {
	r = mux.NewRouter()

	// ROUTES
	r.HandleFunc("/", HomeHandler).Methods("GET")

	return
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	log.Info().Msg("Recieved GET call to '/'")
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "text/plain")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	fmt.Fprint(w, "Hello World")
}
