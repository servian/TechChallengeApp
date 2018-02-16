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

package db

import (
	"database/sql"
	"errors"
	"fmt"

	_ "github.com/lib/pq"
	"github.com/vibrato/TechTestApp/model"
)

// Config - configuration for the db package
type Config struct {
	DbUser     string
	DbPassword string
	DbName     string
	DbHost     string
	DbPort     string
}

func getDbInfo(cfg Config) string {
	return fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		cfg.DbHost, cfg.DbPort, cfg.DbUser, cfg.DbPassword, cfg.DbName)
}

// GetAllTasks lists ass tasks in the database
func GetAllTasks(cfg Config) ([]model.Task, error) {

	var tasks []model.Task

	dbinfo := getDbInfo(cfg)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return nil, err
	}

	defer db.Close()

	rows, err := db.Query("SELECT * FROM public.\"Tasks\"")

	if err != nil {
		return nil, err
	}

	for rows.Next() {
		task := model.Task{}

		rows.Scan(&task.ID, &task.Complete, &task.Priority, &task.Title)

		tasks = append(tasks, task)
	}

	return tasks, nil
}

func AddTask(cfg Config, task model.Task) (model.Task, error) {
	dbinfo := getDbInfo(cfg)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return task, err
	}

	defer db.Close()

	err = db.QueryRow("INSERT INTO public.\"Tasks\"(\"Completed\", \"Priority\", \"Title\") VALUES($1, $2, $3) returning \"Id\"",
		task.Complete, task.Priority, task.Title).Scan(&task.ID)

	if err != nil {
		return task, err
	}

	return task, nil
}

func DeleteTask(cfg Config, task model.Task) error {
	dbInfo := getDbInfo(cfg)

	db, err := sql.Open("postgres", dbInfo)

	if err != nil {
		return err
	}

	defer db.Close()

	stmt, err := db.Prepare("DELETE FROM public.\"Tasks\" WHERE \"Id\"=$1")

	if err != nil {
		return err
	}

	res, err := stmt.Exec(task.ID)

	if err != nil {
		return err
	}

	affect, err := res.RowsAffected()

	if err != nil {
		return err
	}

	if affect < 1 {
		return errors.New("Nothing was deleted")
	}

	return nil

}

func UpdateTask(cfg Config, task model.Task) (model.Task, error) {

	dbInfo := getDbInfo(cfg)

	db, err := sql.Open("postgres", dbInfo)

	if err != nil {
		return task, err
	}

	defer db.Close()

	stmt, err := db.Prepare("UPDATE pulic.\"Tasks\" SET Completed=$1, Priority=$2, Title=$3 WHERE \"Id\"=$4")

	if err != nil {
		return task, err
	}

	_, err = stmt.Exec(task.Complete, task.Priority, task.Title, task.ID)

	if err != nil {
		return task, nil
	}

	return task, nil
}
