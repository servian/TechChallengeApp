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
	"encoding/json"
	"fmt"

	bolt "go.etcd.io/bbolt"

	"github.com/servian/TechChallengeApp/model"
)

type Boltdb struct {
}

// https://pkg.go.dev/github.com/etcd-io/bbolt

// RebuildDb drops the database and recreates it
func (b Boltdb) RebuildDb(cfg Config) error {
	database, err := bolt.Open(cfg.DbName, 0644, nil)
	if err != nil {
		return err
	}
	defer database.Close()

	err = database.Update(func(tx *bolt.Tx) error {
		tx.DeleteBucket([]byte(cfg.DbUser))
		return nil
	})
	if err != nil {
		return err
	}

	return nil
}

func (b Boltdb) CreateTable(cfg Config) error {
	database, err := bolt.Open(cfg.DbName, 0644, nil)
	if err != nil {
		return err
	}
	defer database.Close()

	err = database.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(cfg.DbUser))
		if err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return err
	}
	return nil
}

func (b Boltdb) GetAllTasks(cfg Config) ([]model.Task, error) {

	database, err := bolt.Open(cfg.DbName, 0644, nil)
	if err != nil {
		return nil, err
	}
	defer database.Close()

	var tasks []model.Task
	err = database.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(cfg.DbUser))

		c := b.Cursor()

		for k, v := c.First(); k != nil; k, v = c.Next() {
			task := model.Task{}
			json.Unmarshal([]byte(v), &task)
			tasks = append(tasks, task)
		}
		return nil
	})
	if err != nil {
		return nil, err
	}

	return tasks, nil
}

func (b Boltdb) AddTask(cfg Config, task model.Task) (model.Task, error) {
	database, err := bolt.Open(cfg.DbName, 0644, nil)
	if err != nil {
		return task, err
	}
	defer database.Close()

	err = database.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(cfg.DbUser))
		id, _ := b.NextSequence()
		task.ID = int(id)
		bytes, err := json.Marshal(task)
		if err != nil {
			return err
		}
		err = tx.Bucket([]byte(cfg.DbUser)).Put([]byte(fmt.Sprint(task.ID)), bytes)
		if err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return task, err
	}

	return task, nil
}

func (b Boltdb) DeleteTask(cfg Config, task model.Task) error {
	database, err := bolt.Open(cfg.DbName, 0644, nil)
	if err != nil {
		return err
	}
	defer database.Close()

	err = database.Update(func(tx *bolt.Tx) error {
		if err != nil {
			return err
		}
		err = tx.Bucket([]byte(cfg.DbUser)).Delete([]byte(fmt.Sprint(task.ID)))
		if err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return err
	}

	return nil
}
