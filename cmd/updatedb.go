// Copyright © 2020 Servian
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
	"fmt"
	"os"

	"github.com/servian/TechChallengeApp/db"
	"github.com/spf13/cobra"
)

// updatedbCmd represents the updatedb command
var updatedbCmd = &cobra.Command{
	Use:   "updatedb",
	Short: "Updates DB",
	Long:  `Updates DB that has been defined in the configuration file. If no db exist, one will be created`,
	Run: func(cmd *cobra.Command, args []string) {
		err := updateDb(cfg.UI.DB)

		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	},
}

var skipCreateDbOption bool

func init() {
	rootCmd.AddCommand(updatedbCmd)
	updatedbCmd.Flags().BoolVarP(&skipCreateDbOption, "skip-create-db", "s", false, "Use to skip the creation of the database")
}

func updateDb(cfg db.Config) error {

	if !skipCreateDbOption {
		fmt.Println("Dropping and recreating database: " + cfg.DbName)
		err := db.RebuildDb(cfg)

		if err != nil {
			return err
		}
	}

	fmt.Println("Dropping and recreating table: tasks")
	err := db.CreateTable(cfg)

	if err != nil {
		return err
	}

	fmt.Println("Seeding table with data")
	err = db.SeedData(cfg)

	return err
}
