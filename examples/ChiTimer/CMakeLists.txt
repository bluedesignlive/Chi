cmake_minimum_required(VERSION 3.20)
project(ChiTimer VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_add_executable(chitimer
    src/main.cpp
)

qt_add_qml_module(chitimer
    URI ChiTimer
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/TimerTab.qml
        qml/StopwatchTab.qml
        qml/AlarmTab.qml
        qml/WorldClockTab.qml
    IMPORTS
        Chi
)

target_link_libraries(chitimer
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
