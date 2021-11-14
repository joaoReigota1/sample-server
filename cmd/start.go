package cmd

import (
	"github.com/rs/zerolog/log"
	"github.com/simple_server/internal/server"
	"github.com/spf13/cobra"
)

var startCmd = &cobra.Command{
	Use:     "start",
	Short:   "start command intializes the server",
	Example: "server start --port 8080",
	Run: func(cmd *cobra.Command, args []string) {
		executeStartCmd()
	},
}

func executeStartCmd() {
	ser, err := server.NewServer(port)
	if err != nil {
		panic(err)
	}

	if err := ser.Run(); err != nil {
		log.Err(err).Msgf("server failed to start")
		panic(err)
	}
}
