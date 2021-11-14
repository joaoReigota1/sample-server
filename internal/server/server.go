package server

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/zerolog/log"
	"github.com/simple_server/internal/server/handlers"
)

// Server is a struct that holds the server configuration
type Server struct {
	port    string
	handler *mux.Router
}

// NewServer returns a new server instance
func NewServer(port string) (*Server, error) {

	return &Server{
		port:    ":" + port,
		handler: handlers.ConfigureHandlers(),
	}, nil
}

// Run starts the server and listens for requests on the configured port
func (s *Server) Run() error {
	log.Info().Msgf("Server is running on port %s", s.port)
	if err := http.ListenAndServe(s.port, s.handler); err != nil {
		log.Err(err).Msg("Failed to start server")
		return err
	}
	return nil
}
