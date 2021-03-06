@echo off

set MAPNIK_VERSION=2.3.0
set MAPNIK_VERSION_NUMBER=200300
set MAPNIK_PREFIX=c:\\mapnik-v%MAPNIK_VERSION%
set MAPNIK_LIBS=%MAPNIK_PREFIX%\\lib
set MAPNIK_INCLUDES=%MAPNIK_PREFIX%\\include
set MAPNIK_INPUT_PLUGINS_DIRECTORY=%MAPNIK_PREFIX%\\lib\\mapnik\\input
set MAPNIK_FONTS_DIRECTORY=%MAPNIK_PREFIX%\\lib\\mapnik\\fonts

if /i "%1"=="" (
  goto help
  goto exit_error
)

if /i "%1"=="-v" (
  echo %MAPNIK_VERSION%
  goto exit_ok
)

if /i "%1"=="--version" (
  echo %MAPNIK_VERSION%
  goto exit_ok
)

if /i "%1"=="--version-number" (
  echo %MAPNIK_VERSION_NUMBER%
  goto exit_ok
)

if /i "%1"=="--git-revision" (
  echo TODO
  goto exit_ok
)

if /i "%1"=="--git-describe" (
  echo TODO
  goto exit_ok
)

if /i "%1"=="help" (
  goto help
  goto exit_ok
)

if /i "%1"=="--help" (
  goto help
  goto exit_ok
)

if /i "%1"=="-help" (
  goto help
  goto exit_ok
)

if /i "%1"=="-h" (
  goto help
  goto exit_ok
)

if /i "%1"=="/help" (
  goto help
  goto exit_ok
)

if /i "%1"=="?" (
  goto help
  goto exit_ok
)

if /i "%1"=="-?" (
  goto help
  goto exit_ok
)

if /i "%1"=="--?" (
  goto help
  goto exit_ok
)

if /i "%1"=="/?" (
  goto help
  goto exit_ok
)

set hit=""

if /i "%1"=="--prefix" (
  echo %MAPNIK_PREFIX%
  set hit="yes"
)

if /i "%1"=="--input-plugins" (
  echo %MAPNIK_INPUT_PLUGINS_DIRECTORY%
  set hit="yes"
)

if /i "%1"=="--fonts" (
  echo %MAPNIK_FONTS_DIRECTORY%
  set hit="yes"
)

if /i "%1"=="--lib-name" (
  echo mapnik
  set hit="yes"
)

if /i "%1"=="--libs" (
  echo mapnik.lib
  set hit="yes"
)

@rem TODO - figure out how to avoid hardcoding these library names
if /i "%1"=="--dep-libs" (
  echo libpng.lib zlib.lib libwebp.lib libjpeg.lib icuuc.lib icuin.lib cairo.lib libboost_system-vc100-mt-1_49.lib libxml2_a.lib ws2_32.lib
  set hit="yes"
)

if /i "%1"=="--ldflags" (
  echo %MAPNIK_LIBS%
  set hit="yes"
)

if /i "%1"=="--defines" (
  echo _WINDOWS HAVE_JPEG HAVE_PNG HAVE_WEBP HAVE_TIFF MAPNIK_USE_PROJ4 BOOST_REGEX_HAS_ICU GRID_RENDERER MAPNIK_THREADSAFE BIGINT HAVE_LIBXML2 HAVE_CAIRO LIBXML_STATIC
  set hit="yes"
)

@rem /MD is multithreaded dynamic linking - http://msdn.microsoft.com/en-us/library/2kzt1wy3.aspx
@rem /EHsc is to support c++ exceptions - http://msdn.microsoft.com/en-us/library/1deeycx5(v=vs.80).aspx
@rem /GR is to support rtti (runtime type detection) - http://msdn.microsoft.com/en-us/library/we6hfdy0.aspx
if /i "%1"=="--cxxflags" (
  echo /MD /EHsc /GR
  set hit="yes"
)

if /i "%1"=="--includes" (
  echo %MAPNIK_INCLUDES% %MAPNIK_INCLUDES%\\mapnik\\agg
  set hit="yes"
)

if /i "%1"=="--all-flags" (
  @rem nothing here yet
  echo ""
  set hit="yes"
)

if /i "%1"=="--cxx" (
  @rem nothing here yet
  echo ""
  set hit="yes"
)

if /i "%1"=="--cflags" (
  @rem nothing here yet 
  echo ""
  set hit="yes"
)

if /i "%1"=="--dep-includes" (
  @rem nothing here yet
  echo ""
  set hit="yes"
)

@rem if we got here print warning
if /i %hit%=="" (
  echo unknown option %1 1>&2
)

goto exit_ok

:help
echo Usage: mapnik-config 
echo Examples:
echo   --libs            : provide lib name for mapnik.dll
echo   --defines         : provide compiler defines needed for this mapnik build
echo   --dep-libs        : provide lib names of depedencies
echo   --ldflags         : provide lib paths to depedencies
echo   --cxxflags        : provide compiler flags
echo   --includes        : provide header paths for mapnik
echo   --dep-includes    : provide header paths for dependencies
echo   --input-plugins   : provide path to input plugins directory
echo   --fonts           : provide path to fonts directory


:exit_error
@rem exit /b 1
goto :EOF

:exit_ok
@rem exit /b 0
goto :EOF