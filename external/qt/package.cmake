# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

if (NOT DESKTOP_APP_USE_PACKAGED)
    if (DESKTOP_APP_QT6)
        set(qt_version 6.3.1)
    else()
        set(qt_version 5.15.4)
    endif()

    if (WIN32)
        set(qt_loc ${libs_loc}/Qt-${qt_version})
    elseif (APPLE)
        set(qt_loc ${libs_loc}/local/Qt-${qt_version})
    else()
        set(qt_loc /usr/local/desktop-app/Qt-${qt_version})
    endif()

    set(CMAKE_PREFIX_PATH ${qt_loc})
endif()

if (DESKTOP_APP_QT6)
    find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
else()
    find_package(QT NAMES Qt5 REQUIRED COMPONENTS Core)
endif()

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Widgets Network Svg REQUIRED)

if (QT_VERSION_MAJOR GREATER_EQUAL 6)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core5Compat OpenGL OpenGLWidgets REQUIRED)
endif()

if (LINUX)
    if (NOT DESKTOP_APP_DISABLE_WAYLAND_INTEGRATION)
        find_package(Qt${QT_VERSION_MAJOR} COMPONENTS WaylandClient REQUIRED)
        if (QT_VERSION_MAJOR GREATER_EQUAL 6)
            find_package(Qt${QT_VERSION_MAJOR} OPTIONAL_COMPONENTS WaylandGlobalPrivate QUIET)
        else()
            find_package(Qt${QT_VERSION_MAJOR} OPTIONAL_COMPONENTS XkbCommonSupport QUIET)
        endif()
    endif()

    if ((NOT DESKTOP_APP_USE_PACKAGED
                OR (DESKTOP_APP_USE_PACKAGED AND DESKTOP_APP_USE_PACKAGED_LAZY))
            AND NOT DESKTOP_APP_DISABLE_DBUS_INTEGRATION)
        find_package(Qt${QT_VERSION_MAJOR} COMPONENTS DBus REQUIRED)
    elseif (NOT DESKTOP_APP_USE_PACKAGED)
        find_package(Qt${QT_VERSION_MAJOR} OPTIONAL_COMPONENTS DBus QUIET)
    endif()
endif()

set_property(GLOBAL PROPERTY AUTOGEN_SOURCE_GROUP "(gen)")
set_property(GLOBAL PROPERTY AUTOGEN_TARGETS_FOLDER "(gen)")
