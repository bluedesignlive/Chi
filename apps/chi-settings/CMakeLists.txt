cmake_minimum_required(VERSION 3.16)
project(chi-settings LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(chi-settings main.cpp)

qt_add_qml_module(chi-settings
    URI ChiSettings
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(chi-settings PRIVATE Qt6::Quick)

install(TARGETS chi-settings
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
