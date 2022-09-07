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
	SeedData(cfg Config) error
	GetAllTasks(cfg Config) ([]model.Task, error)
	AddTask(cfg Config, task model.Task) (model.Task, error)
	DeleteTask(cfg Config, task model.Task) error
	//UpdateTask(cfg Config, task model.Task) (model.Task, error)
}

func GetDatabase(cfg Config) Database {
	if "postgres" == cfg.DbType {
		return Pqdb{}
	}

	fmt.Println("No Database Type set")
	os.Exit(1)

	return nil
}
