@echo off
setlocal enabledelayedexpansion
title Layanan Warga Kelurahan Cepoko - Web Runner

echo ===================================================================
echo            LAYANAN WARGA KELURAHAN CEPOKO
echo              Kec. Gunungpati, Kota Semarang
echo ===================================================================
echo.
echo [Kredensial Pengujian]
echo   - Warga Demo        : warga@cepoko.test / CepokoWarga2026!
echo   - Petugas Kelurahan : petugas@cepoko.test / CepokoAdmin2026!
echo   - Kunci Admin Server: TJiUNoA7pTQXeiQZ3uqoCod31iGGdiJa5b
echo.
echo [Target API Backend]
echo   - Base URL: http://[IP_ADDRESS]/api
echo.
echo * Catatan: Pastikan backend API sudah berjalan pada port 4173.
echo   (Jalankan "npm run api:dev" di direktori backend)
echo.
echo ===================================================================

if "%1"=="server" goto run_server
if "%1"=="edge" goto run_edge
if "%1"=="chrome" goto run_chrome

echo Memilih browser default (Google Chrome)...
echo [Tekan tombol apapun atau tunggu 3 detik untuk memulai Chrome]
echo.

flutter run -d chrome --dart-define=API_BASE_URL=http://[IP_ADDRESS]/api
if %ERRORLEVEL% EQU 0 goto end

echo.
echo [INFO] Chrome tidak berhasil diluncurkan, mencoba Microsoft Edge...
:run_edge
flutter run -d edge --dart-define=API_BASE_URL=http://[IP_ADDRESS]/api
if %ERRORLEVEL% EQU 0 goto end

echo.
echo [INFO] Menjalankan dengan Web Server lokal (port 8765)...
:run_server
echo Buka browser dan arahkan ke http://

[IP_ADDRESS]
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8765 --dart-define=API_BASE_URL=http://[IP_ADDRESS]/api
goto end

:run_chrome
flutter run -d chrome --dart-define=API_BASE_URL=http://[IP_ADDRESS]/api
goto end

:end
echo.
echo Aplikasi Flutter Web telah berhenti.
pause

