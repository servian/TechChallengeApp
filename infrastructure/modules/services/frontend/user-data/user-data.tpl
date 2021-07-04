#!/bin/bash

LATEST_APP_PACKAGE_PATH="https://github.com/servian/TechChallengeApp/releases/download/v.0.8.0/TechChallengeApp_v.0.8.0_linux64.zip"
APP_PACKAGE="TechChallenge.zip"

curl -L -o $APP_PACKAGE ${latest_app_package_path}

mv $APP_PACKAGE /opt

cd /opt

unzip $APP_PACKAGE
rm -rf $APP_PACKAGE
cd dist/

# Replace the existing contents with the new contents
echo "\"DbUser\" = "\"${db_user}\""
\"DbPassword\" = "\"${db_password}\""
\"DbName\" = "\"${db_name}\""
\"DbPort\" = "\"${db_port}\""
\"DbHost\" = "\"${db_host}\""
\"ListenHost\" = "\"${listen_host}\""
\"ListenPort\" = "\"${listen_port}\""
" > conf.toml

# Now run the TecChallngeApp
nohup ./TechChallengeApp serve &

ps -fx | grep TechChallengeApp

echo "App is running successfully"