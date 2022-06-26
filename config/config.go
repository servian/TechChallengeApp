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

package config

import (
	"strings"

	"github.com/spf13/viper"
)

// internalConfig wraps the config values as the toml library was
// having issue with getters and setters on the struct
type Config struct {
	DbUser     string
	DbPassword string
	DbName     string
	DbHost     string
	DbPort     string
	ListenHost string
	ListenPort string
}

func LoadConfig() (*Config, error) {
	var conf = &Config{}

	v := viper.New()

	v.SetConfigName("conf")
	v.SetConfigType("toml")
	v.AddConfigPath(".")

	v.SetEnvPrefix("VTT")
	v.AutomaticEnv()

	v.SetDefault("DbUser", "postgres")
	v.SetDefault("DbPassword", "postgres")
	v.SetDefault("DbName", "postgres")
	v.SetDefault("DbPort", "postgres")
	v.SetDefault("DbHost", "localhost")

	v.SetDefault("ListenHost", "127.0.0.1")
	v.SetDefault("ListenPort", "3000")

	err := v.ReadInConfig() // Find and read the config file

	if err != nil {
		return nil, err
	}

	conf.DbUser = strings.TrimSpace(v.GetString("DbUser"))
	conf.DbPassword = strings.TrimSpace(v.GetString("DbPassword"))
	conf.DbName = strings.TrimSpace(v.GetString("DbName"))
	conf.DbHost = strings.TrimSpace(v.GetString("DbHost"))
	conf.DbPort = strings.TrimSpace(v.GetString("DbPort"))
	conf.ListenHost = strings.TrimSpace(v.GetString("ListenHost"))
	conf.ListenPort = strings.TrimSpace(v.GetString("ListenPort"))

	return conf, nil
}
