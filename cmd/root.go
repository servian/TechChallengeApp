// Copyright © 2018 Thomas Winsnes <tom@vibrato.com.au>
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

	"github.com/spf13/cobra"
	"github.com/vibrato/TechTestApp/config"
	"github.com/vibrato/TechTestApp/daemon"
)

var cfgFile string
var cfg *daemon.Config

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "TechTestApp",
	Short: "Application used to test potential candidates at Vibrato",
	Long: `
   /*.                       ,//                                                                               
 ##%&&%%%&%            .&&%%%%%%#(                                                                             
  */****%&%%,         *%&&&/(((((                                                                              
   ,***/*(%%#,       ,%%%&*((#((                                                                               
    ,,*/**(((#*     /#%%&//###*                                                                                
     ,//*//(((//   (#%%(//.%%,         */     ,(    */    *((((,     ,((((/         /      (((((((     *(##(.  
      ,//*//(((/* (#%%#//,,%,           (*   .#     */    */   (*    ,(   .#       *(*        #.     .#.    *( 
       .#(*(((#/%%#%%##/**/.             (* .#      */    *(((#/     ,(**/(/      *( (,       #.     (.      (*
         ##*,((%%%#%/((//(                ((#       */    */   ,(    ,( .#*      *(   ((      #.     //      #.
         .%(/,*#%%%*/((((                  (,       */    *(///#*    ,(   *(    .#     (*     #.      ,#/**((  
           %(/,,*#/#(((*                                                                                       
            /**,,(#(//,                                                                                        
             ***,(###,                                                                                         

This application is used as part of testing potential candiates at Vibrato.

Please visit http://vibrato.com.au for more details`,
	Version: "0.3.4",
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	conf, err := config.LoadConfig()

	if err != nil {
		fmt.Print(err)
		os.Exit(1)
	}

	cfg = &daemon.Config{}
	cfg.UI.DB.DbName = conf.DbName
	cfg.UI.DB.DbPassword = conf.DbPassword
	cfg.UI.DB.DbUser = conf.DbUser
	cfg.UI.DB.DbHost = conf.DbHost
	cfg.UI.DB.DbPort = conf.DbPort
	cfg.ListenSpec = conf.ListenHost + ":" + conf.ListenPort

}
