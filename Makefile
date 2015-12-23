EXCLUDE_ARCHS += eldk
EXCLUDE_VERSIONS += 3.15.2

include ${EPICS_ENV_PATH}/module.Makefile


PROJECT = ioc_misc_freia

USR_DEPENDENCIES += seq
HEADERS += $(wildcard src/main/epics/misc-freiaApp/src/*.h)
SOURCES += $(wildcard src/main/epics/misc-freiaApp/src/*.cpp)
SOURCES += $(wildcard src/main/epics/misc-freiaApp/src/*.st)

STARTUPS = $(wildcard src/main/ioc/*.cmd)

OPIS = src/main/boy
