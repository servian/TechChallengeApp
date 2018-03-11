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

package ui

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/vibrato/TechTestApp/db"
	"github.com/vibrato/TechTestApp/model"
)

// Config configuration for ui package
type Config struct {
	Assets http.FileSystem
	DB     db.Config
}

// Start - start web server and handle web requets
func Start(cfg Config, listener net.Listener) {

	server := &http.Server{
		ReadTimeout:    60 * time.Second,
		WriteTimeout:   60 * time.Second,
		MaxHeaderBytes: 1 << 16}

	mainRouter := mux.NewRouter().PathPrefix("/").Subrouter()
	mainRouter.PathPrefix("/js/").Handler(assetHandler(cfg))
	mainRouter.PathPrefix("/css/").Handler(assetHandler(cfg))
	mainRouter.PathPrefix("/images/").Handler(assetHandler(cfg))
	mainRouter.Handle("/api/task/{id:[0-9]+}/", deleteTask(cfg)).Methods("DELETE")
	mainRouter.Handle("/api/task/", allTasksHandler(cfg))
	mainRouter.Handle("/healthcheck/", healthcheckHandler(cfg))
	mainRouter.Handle("/", indexHandler())
	http.Handle("/", mainRouter)

	go server.Serve(listener)
}

const (
	cdnReact           = "https://cdnjs.cloudflare.com/ajax/libs/react/15.5.4/react.min.js"
	cdnReactDom        = "https://cdnjs.cloudflare.com/ajax/libs/react/15.5.4/react-dom.min.js"
	cdnBabelStandalone = "https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.24.0/babel.min.js"
	cdnAxios           = "https://cdnjs.cloudflare.com/ajax/libs/axios/0.16.1/axios.min.js"
)

const indexHTML = `
<!DOCTYPE HTML>
<html>
  <head>
    <meta charset="utf-8">
	<title>Vibrato Tech Test App</title>
	<link rel="stylesheet" href="/css/site.css" type="text/css" />
	<link href="https://fonts.googleapis.com/css?family=Arimo" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
	<script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>
  </head>
  <body>
  	<header>
    	<img src="/images/VIBRATO_Logo_dark-cropped-200.png" width="100" height="85"/>
    </header>
    <div id='root'></div>
	<footer>
        &COPY; Vibrato
	</footer>
	<script src="` + cdnReact + `"></script>
    <script src="` + cdnReactDom + `"></script>
    <script src="` + cdnBabelStandalone + `"></script>
    <script src="` + cdnAxios + `"></script>
	<script src="/js/app.jsx" type="text/babel"></script>
  </body>
</html>
`

func assetHandler(cfg Config) http.Handler {
	// so not secure!
	return http.FileServer(cfg.Assets)
}

func healthcheckHandler(cfg Config) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, err := db.GetAllTasks(cfg.DB)

		if err != nil {
			fmt.Fprintf(w, "Error: db connection down")
			return
		}

		fmt.Fprintf(w, "OK")
	})
}

func indexHandler() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, indexHTML)
	})
}

func allTasksHandler(cfg Config) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		switch r.Method {
		case ("GET"):
			getTasks(cfg, w)
			break
		case ("POST"):
			addTask(cfg, w, r)
		case ("PATCH"):
			updateTask(cfg, w, r)
		}
	})
}

func getTasks(cfg Config, w http.ResponseWriter) {
	output, _ := db.GetAllTasks(cfg.DB)
	js, _ := json.Marshal(output)
	fmt.Fprintf(w, string(js))
}

func addTask(cfg Config, w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	var task model.Task

	err := decoder.Decode(&task)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), 400)
		return
	}

	newTask, err := db.AddTask(cfg.DB, task)

	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), 500)
		return
	}

	js, _ := json.Marshal(newTask)

	fmt.Fprintf(w, string(js))
}

func updateTask(cfg Config, w http.ResponseWriter, r *http.Request) {

}

func deleteTask(cfg Config) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)

		id, err := strconv.Atoi(vars["id"])

		if err != nil {
			fmt.Print(err)
			http.Error(w, err.Error(), 500)
			return
		}

		err = db.DeleteTask(cfg.DB, model.Task{ID: id})

		if err != nil {
			fmt.Print(err)
			http.Error(w, err.Error(), 500)
			return
		}
	})
}
