// Copyright ©2022 Servian
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
	"github.com/servian/TechChallengeApp/model"
)

type Pqdb struct {
}

func (Pqdb) getDbInfo(cfg Config) string {
	return fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		cfg.DbHost, cfg.DbPort, cfg.DbUser, cfg.DbPassword, cfg.DbName)
}

// RebuildDb drops the database and recreates it
func (Pqdb) RebuildDb(cfg Config) error {
	dbinfo := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=postgres sslmode=disable",
		cfg.DbHost, cfg.DbPort, cfg.DbUser, cfg.DbPassword)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return err
	}

	defer db.Close()

	query := "DROP DATABASE IF EXISTS " + cfg.DbName

	fmt.Println(query)

	_, err = db.Query(query)

	if err != nil {
		return err
	}

	query = fmt.Sprintf(`CREATE DATABASE %s
WITH
OWNER = %s
ENCODING = 'UTF8'
LC_COLLATE = 'en_US.utf8'
LC_CTYPE = 'en_US.utf8'
TABLESPACE = pg_default
CONNECTION LIMIT = -1
TEMPLATE template0;`, cfg.DbName, cfg.DbUser)

	fmt.Println(query)

	_, err = db.Query(query)

	return err
}

func (p Pqdb) CreateTable(cfg Config) error {
	dbinfo := p.getDbInfo(cfg)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return err
	}

	defer db.Close()

	tx, err := db.Begin()

	if err != nil {
		return err
	}

	defer tx.Rollback()

	query := "DROP TABLE IF EXISTS tasks CASCADE"

	fmt.Println(query)

	_, err = tx.Exec(query)

	if err != nil {
		return err
	}

	query = "CREATE TABLE tasks ( id SERIAL PRIMARY KEY, completed boolean NOT NULL, priority integer NOT NULL, title text NOT NULL)"

	fmt.Println(query)

	_, err = tx.Exec(query)

	if err != nil {
		return err
	}

	if err != nil {
		return err
	}

	err = tx.Commit()

	return err
}

// GetAllTasks lists all tasks in the database
func (p Pqdb) GetAllTasks(cfg Config) ([]model.Task, error) {

	var tasks []model.Task

	dbinfo := p.getDbInfo(cfg)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return nil, err
	}

	defer db.Close()

	rows, err := db.Query("SELECT * FROM tasks")

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

func (p Pqdb) AddTask(cfg Config, task model.Task) (model.Task, error) {
	dbinfo := p.getDbInfo(cfg)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		return task, err
	}

	defer db.Close()

	err = db.QueryRow("INSERT INTO tasks (completed, priority, title) VALUES($1, $2, $3) returning id",
		task.Complete, task.Priority, task.Title).Scan(&task.ID)

	if err != nil {
		return task, err
	}

	return task, nil
}

func (p Pqdb) DeleteTask(cfg Config, task model.Task) error {
	dbInfo := p.getDbInfo(cfg)

	db, err := sql.Open("postgres", dbInfo)

	if err != nil {
		return err
	}

	defer db.Close()

	stmt, err := db.Prepare("DELETE FROM tasks WHERE id=$1")

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
