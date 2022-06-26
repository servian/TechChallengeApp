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

package ui

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/servian/TechChallengeApp/db"
	"github.com/servian/TechChallengeApp/model"
)

// TaskID parameter.
//
// swagger:parameters deleteTask
type TaskID struct {
	// The ID of the task
	//
	// in: path
	// min: 0
	// required: true
	ID int `json:"id"`
}

// Sucessful Task Array Response
//
// swagger:response allTasks
type allTasks struct {
	// in: body
	// The tasks being returned
	// required: true
	Tasks []model.Task `json:"tasks"`
}

// swagger:route GET /api/task/ getTasks
//
// Fetch all tasks
//
//    Produces:
//      - application/json
//
//    Responses:
//      200: allTasks
//
func getTasks(cfg Config) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		output, _ := db.GetAllTasks(cfg.DB)
		js, _ := json.Marshal(output)
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, string(js))
	})
}

// Sucessful Single Task Response
//
// swagger:response aTask
type aTask struct {
	// in: body
	// The tasks being returned
	// required: true
	Task model.Task `json:"task"`
}

// swagger:parameters addTask
type taskParameter struct {
	// in:body
	Task model.Task `json:"task"`
}

// swagger:route POST /api/task/ addTask
//
// Add a new task to the list.
//
//    Produces:
//      - application/json
//
//    Responses:
//      200: aTask
//      400:
//      500:
//
func addTask(cfg Config) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
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
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, string(js))
	})
}

// swagger:route DELETE /api/task/{id}/ deleteTask
//
// Delete a Task by ID
//
// Responses:
//    204:
//    404:
//    500:
//
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

		w.WriteHeader(http.StatusNoContent)
	})
}

func apiHandler(cfg Config, router *mux.Router) {
	router.Handle("/task/{id:[0-9]+}/", deleteTask(cfg)).Methods("DELETE")
	router.Handle("/task/", getTasks(cfg)).Methods("GET")
	router.Handle("/task/", addTask(cfg)).Methods("POST")
}
