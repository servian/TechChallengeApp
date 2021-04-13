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

	"github.com/servian/TechChallengeApp/config"
	"github.com/servian/TechChallengeApp/daemon"
	"github.com/spf13/cobra"
)

var cfgFile string
var cfg *daemon.Config

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "TechChallengeApp",
	Short: "Application used to test potential candidates at Servian",
	Long: `
 .:ooooool,      .:odddddl;.      .;ooooc. .l,          ;c.    ::.      'coddddoc'         ,looooooc.                  
'kk;....';,    .lOx:'...,cxkc.   .dOc....  .xO'        ,0d.   .kk.    ,xko;....;okx,     .xkl,....;dOl.                
:Xl           .xO,         :0d.  ;Kl        ,0o       .dO'    .kk.   :0d.        .d0:   .xO'        lK:                
.oOxc,.       lKl...........oK:  :Kc         l0;      :Kc     .kk.  .Ok.          .kO.  '0d         '0d                
  .;ldddo;.   oXkdddddddddddxx,  :Kc         .kk.    .Ox.     .kk.  '0d            d0'  '0d         '0d                
       .cOk.  lKc                :Kc          :0l    o0;      .kk.  .Ok.          .k0'  '0d         '0d                
         cXc  .xO;         ..    :Kc          .d0'  ;0o       .kk.   :0d.        .dN0'  '0d         '0d                
,c,....'cOx.   .lOxc,...':dkc.   :Kc           'Ox',kk.       .kk.    ,xko;'..';okk00,  '0d         '0d   ';;;;;;;;;;,.
'looooool;.      .;ldddddo:.     'l'            .lool.         ::       'coddddoc'.;l.  .l;         .c;  .cxxxxxxxxxxo.

This application is used as part of challenging potential candiates at Sevian.

Please visit http://Servian.com for more details`,
	Version: "0.8.0",
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
