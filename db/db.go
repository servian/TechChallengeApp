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
	"fmt"
	"os"

	"github.com/servian/TechChallengeApp/model"
)

// Config - configuration for the db package
type Config struct {
	DbUser     string
	DbPassword string
	DbName     string
	DbHost     string
	DbPort     string
	DbType     string
}

type Database interface {
	RebuildDb(cfg Config) error
	CreateTable(cfg Config) error
	GetAllTasks(cfg Config) ([]model.Task, error)
	AddTask(cfg Config, task model.Task) (model.Task, error)
	DeleteTask(cfg Config, task model.Task) error
}

func GetDatabase(cfg Config) Database {
	if "postgres" == cfg.DbType {
		return Pqdb{}
	}

	if "boltdb" == cfg.DbType {
		return Boltdb{}
	}

	fmt.Println("No Database Type set")
	os.Exit(1)

	return nil
}
