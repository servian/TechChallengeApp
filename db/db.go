package db

import (
	"github.com/servian/TechChallengeApp/model"
)

// Config - configuration for the db package
type Config struct {
	DbUser     string
	DbPassword string
	DbName     string
	DbHost     string
	DbPort     string
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
