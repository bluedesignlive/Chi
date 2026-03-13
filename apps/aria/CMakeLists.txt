cmake_minimum_required(VERSION 3.16)
project(aria VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml Multimedia)

# Suppress Qt policy warnings
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

set(APP_ID "io.github.chi.aria")

qt_add_executable(aria
    src/main.cpp
    src/audioengine.cpp
    src/audioengine.h
    src/waveformgenerator.cpp
    src/waveformgenerator.h
    src/folderplayer.cpp
    src/folderplayer.h
)

qt_add_qml_module(aria
    URI Aria
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Waveform.qml
        qml/DropZone.qml
        qml/CompactPlayer.qml
        qml/TimeDisplay.qml
        qml/VolumeSlider.qml
)

target_link_libraries(aria PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS aria RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES data/${APP_ID}.desktop DESTINATION ${CMAKE_INSTALL_DATADIR}/applications)
install(FILES data/${APP_ID}.metainfo.xml DESTINATION ${CMAKE_INSTALL_DATADIR}/metainfo)
install(FILES data/icons/hicolor/scalable/apps/${APP_ID}.svg
    DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps)
