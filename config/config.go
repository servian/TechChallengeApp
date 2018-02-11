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

package config

import (
	"io/ioutil"

	"github.com/BurntSushi/toml"
)

// internalConfig wraps the config values as the toml library was
// having issue with getters and setters on the struct
type Config struct {
	DbUser     string
	DbPassword string
	DbName     string
	ListenHost string
	ListenPort string
}

// LoadConfig loads the configuration from file,
// and falls back to default calues if file
// could not be be loaded
func LoadConfig(path string) (Config, error) {
	var conf = Config{}

	bytes, err := ioutil.ReadFile(path)

	if err != nil {
		return conf, err
	}

	tomlcontent := string(bytes)

	_, err = toml.Decode(tomlcontent, &conf)

	if err != nil {
		return conf, err
	}

	return conf, nil
}
