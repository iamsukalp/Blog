@echo off
setlocal enabledelayedexpansion

REM Check if project name is provided
if "%1"=="" (
    echo Usage: %0 project_name
    exit /b 1
)

REM Get the project name
SET PROJECT_NAME=%1

REM Prompt the user for the GitHub repository URL
set /p GITHUB_URL="Enter your GitHub repository URL (e.g., github.com/username/repo.git): "

REM Construct the full URL with https
set "GITHUB_URL_FULL=https://%GITHUB_URL%"

REM Set the project directory
cd /d "%~dp0%PROJECT_NAME%"

REM Initialize a Git repository
echo Initializing Git repository...
git init
if %ERRORLEVEL% neq 0 (
    echo Failed to initialize Git repository.
    exit /b 1
)

REM Add all files to Git
git add .
if %ERRORLEVEL% neq 0 (
    echo Failed to add files to Git repository.
    exit /b 1
)

REM Commit the files
git commit -m "Initial commit"
if %ERRORLEVEL% neq 0 (
    echo Failed to commit files to Git repository.
    exit /b 1
)

REM Add the remote repository
echo Adding remote repository...
git remote add origin %GITHUB_URL_FULL%
if %ERRORLEVEL% neq 0 (
    echo Failed to add remote repository. Error code: %ERRORLEVEL%
    exit /b 1
)

REM Push to the master branch
echo Pushing to remote repository...
git push -u origin master
if %ERRORLEVEL% neq 0 (
    echo Failed to push to remote repository. Error code: %ERRORLEVEL%
    exit /b 1
)

echo Git setup for project %PROJECT_NAME% completed.
endlocal
