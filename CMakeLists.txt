cmake_minimum_required(VERSION 3.16)

project(chi
    VERSION 0.2.0
    DESCRIPTION "Chi — Material 3 Design System for Qt/QML"
    LANGUAGES CXX
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml)

# ── Qt QML install path ──────────────────────────────────────
get_target_property(QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
execute_process(
    COMMAND ${QMAKE_EXECUTABLE} -query QT_INSTALL_QML
    OUTPUT_VARIABLE QT_QML_INSTALL_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "Qt QML path: ${QT_QML_INSTALL_DIR}")
message(STATUS "Chi will install to: ${QT_QML_INSTALL_DIR}/Chi")

# ── Plugin library ────────────────────────────────────────────
add_library(ChiPlugin SHARED
    chi.cpp
    chi.h
    resources.qrc
)

target_link_libraries(ChiPlugin PRIVATE Qt6::Quick Qt6::Qml)
target_include_directories(ChiPlugin PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# ── QML files (IDE visibility only) ──────────────────────────
file(GLOB_RECURSE CHI_QML_FILES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/Chi/*.qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/Chi/*.js"
)
add_custom_target(Chi_QmlFiles SOURCES ${CHI_QML_FILES})

# ── Install plugin binary ────────────────────────────────────
install(TARGETS ChiPlugin
    LIBRARY DESTINATION ${QT_QML_INSTALL_DIR}/Chi
    ARCHIVE DESTINATION ${QT_QML_INSTALL_DIR}/Chi
)

# ── Install QML module ───────────────────────────────────────
install(DIRECTORY qml/Chi/
    DESTINATION ${QT_QML_INSTALL_DIR}/Chi
    FILES_MATCHING
        PATTERN "*.qml"
        PATTERN "qmldir"
        PATTERN "*.js"
        PATTERN "*.png"
        PATTERN "*.svg"
        PATTERN "*.ttf"
        PATTERN "*.woff2"
)
