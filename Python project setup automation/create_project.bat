@echo off
setlocal enabledelayedexpansion

REM Check if project type and name are provided
if "%1"=="" (
    echo Usage: %0 [base|ai] project_name
    exit /b 1
)

REM Prompt the user to ask if Streamlit is required
set /p STREAMLIT_REQ="Is Streamlit required? (y/n): "

REM Set project type to base if only project name is provided
if "%2"=="" (
    SET PROJECT_TYPE=base
    SET PROJECT_NAME=%1
) else (
    SET PROJECT_TYPE=%1
    SET PROJECT_NAME=%2
)

REM Print the project type and name for debugging
echo Creating project: %PROJECT_NAME% with type: %PROJECT_TYPE%

REM Create project directory
echo Creating project directory...
mkdir %PROJECT_NAME%
cd %PROJECT_NAME%

REM Create project structure
echo Creating project structure...
mkdir src tests
echo. > src\main.py
echo. > tests\test_main.py

REM Create a constants.yml file in the src directory
echo Creating constants.yml...
echo. > src\constants.yml

REM Create a README.md file with activation instructions
echo Creating README.md...
(
    echo # %PROJECT_NAME%
    echo
    echo To activate the virtual environment, run:
    echo ```
    echo myenv\Scripts\activate
    echo ```
) > README.md

REM Create a .gitignore file to ignore the myenv folder
echo Creating .gitignore...
echo myenv/ > .gitignore

REM Print the current directory for debugging
echo Current directory: %cd%

REM Create a virtual environment with the generic name 'myenv'
echo Creating virtual environment...
python -m venv myenv

REM Check if virtual environment creation was successful
if not exist myenv\Scripts\activate (
    echo Failed to create virtual environment.
    exit /b 1
)

REM Create the appropriate requirements file based on the project type
echo Creating requirements file...
if "%PROJECT_TYPE%"=="ai" (
    (
        echo tensorflow
        echo keras
        echo scikit-learn
    ) > ai_requirements.txt
    SET REQUIREMENTS_FILE=ai_requirements.txt
) else (
    (
        echo numpy
        echo pandas
        echo requests
    ) > base_requirements.txt
    SET REQUIREMENTS_FILE=base_requirements.txt
)

REM Activate the virtual environment and install libraries
echo Activating virtual environment and installing libraries...
call myenv\Scripts\activate
if %ERRORLEVEL% neq 0 (
    echo Failed to activate virtual environment.
    exit /b 1
)
pip install -r %REQUIREMENTS_FILE%
if %ERRORLEVEL% neq 0 (
    echo Failed to install required libraries.
    exit /b 1
)

REM Install Streamlit if the user responds with 'y'
if /I "%STREAMLIT_REQ%"=="y" (
    echo Installing Streamlit...
    pip install streamlit
    if %ERRORLEVEL% neq 0 (
        echo Failed to install Streamlit.
        exit /b 1
    )
)


REM Deactivate the virtual environment
echo Deactivating virtual environment...
call deactivate
if %ERRORLEVEL% neq 0 (
    echo Failed to deactivate virtual environment. Error code: %ERRORLEVEL%
    exit /b 1
)

REM Call the Git script
echo Calling Git setup script...
call setup_git.bat %PROJECT_NAME%

echo Project %PROJECT_NAME% of type %PROJECT_TYPE% has been created with a virtual environment and basic libraries installed.
if /I "%STREAMLIT_REQ%"=="y" (
    echo Streamlit has also been installed.
)
echo The project has been initialized as a Git repository.
if /I "%GITHUB_SETUP%"=="y" (
    echo The repository has been pushed to %GITHUB_URL%.
)

endlocal
