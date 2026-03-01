cmake_minimum_required(VERSION 3.16)

project(smartui-beta
    VERSION 0.1.0
    DESCRIPTION "SmartUI — Material 3 Design System for Qt/QML"
    LANGUAGES CXX
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml)

# ── Qt QML install path detection ────────────────────────────
get_target_property(QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
execute_process(
    COMMAND ${QMAKE_EXECUTABLE} -query QT_INSTALL_QML
    OUTPUT_VARIABLE QT_QML_INSTALL_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "Qt QML path: ${QT_QML_INSTALL_DIR}")
message(STATUS "Installing SmartUIBeta to: ${QT_QML_INSTALL_DIR}/SmartUIBeta")

# ── Plugin library (C++ sources ONLY) ────────────────────────
add_library(SmartUIBeta SHARED
    smartui.cpp
    smartui.h
    resources.qrc
)

target_link_libraries(SmartUIBeta PRIVATE Qt6::Quick Qt6::Qml)
target_include_directories(SmartUIBeta PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# ── QML files: tracked for IDE visibility, NOT compiled ──────
# These appear in Qt Creator / CLion project tree but are not
# passed to the C++ compiler. Installation is handled below.
file(GLOB_RECURSE SMARTUI_QML_FILES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/smartui/*.qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/smartui/*.js"
)
add_custom_target(SmartUI_QmlFiles SOURCES ${SMARTUI_QML_FILES})

# ── Install plugin binary ────────────────────────────────────
install(TARGETS SmartUIBeta
    LIBRARY DESTINATION ${QT_QML_INSTALL_DIR}/SmartUIBeta
    ARCHIVE DESTINATION ${QT_QML_INSTALL_DIR}/SmartUIBeta
)

# ── Install QML files ────────────────────────────────────────
install(DIRECTORY qml/smartui/
    DESTINATION ${QT_QML_INSTALL_DIR}/SmartUIBeta
    FILES_MATCHING
        PATTERN "*.qml"
        PATTERN "qmldir"
        PATTERN "*.js"
        PATTERN "*.png"
        PATTERN "*.svg"
        PATTERN "*.ttf"
        PATTERN "*.woff2"
)

install(FILES smartui.h resources.qrc
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/SmartUIBeta
)
