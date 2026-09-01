@rem
@rem Safe's Playce — Livestream Android launcher (Windows).
@rem Self-bootstrapping wrapper: downloads gradle-wrapper.jar on first run.
@rem
@rem Usage:
@rem   gradlew assembleDebug
@rem   gradlew installDebug
@rem

@echo off
setlocal

set APP_HOME=%~dp0
set WRAPPER_JAR=%APP_HOME%gradle\wrapper\gradle-wrapper.jar
set WRAPPER_URL=https://raw.githubusercontent.com/gradle/gradle/v8.7.0/gradle/wrapper/gradle-wrapper.jar

if not defined JAVA_HOME (
    set JAVA=java
) else (
    set "JAVA=%JAVA_HOME%\bin\java.exe"
)

if not exist "%WRAPPER_JAR%" (
    echo Gradle wrapper JAR not found - downloading once...
    if not exist "%APP_HOME%gradle\wrapper" mkdir "%APP_HOME%gradle\wrapper"
    where curl >nul 2>nul
    if %errorlevel%==0 (
        curl -fsSL "%WRAPPER_URL%" -o "%WRAPPER_JAR%"
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%WRAPPER_URL%' -OutFile '%WRAPPER_JAR%'"
    )
    if not exist "%WRAPPER_JAR%" (
        echo ERROR: could not download Gradle wrapper JAR. Check network / proxy.
        exit /b 1
    )
)

"%JAVA%" -Dorg.gradle.appname=gradlew -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain %*
endlocal
