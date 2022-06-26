// Copyright © 2022 Servian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package cmd

import (
	"log"
	"net/http"

	"github.com/servian/TechChallengeApp/daemon"
	"github.com/spf13/cobra"
)

// serveCmd represents the serve command
var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Starts the web server",
	Long: `Starts the web server and starts serving connection on port and hostname 
			defined in the configuration file`,
	Run: func(cmd *cobra.Command, args []string) {
		setupHTTPAssets(cfg)

		if err := daemon.Run(cfg); err != nil {
			log.Printf("Error in main: %v", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(serveCmd)
}

func setupHTTPAssets(cfg *daemon.Config) {
	assetPath := "assets"

	log.Printf("Assets served from %q.", assetPath)
	cfg.UI.Assets = http.Dir(assetPath)
}
