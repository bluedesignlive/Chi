cmake_minimum_required(VERSION 3.16)

project(testui VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)

# Set Qt policy to suppress warning
qt_policy(SET QTP0001 NEW)

qt_add_executable(apptestui
    main.cpp
)

qt_add_qml_module(apptestui
    URI testui
    VERSION 1.0
    RESOURCE_PREFIX /
    QML_FILES
        Main.qml
        ButtonShowcase.qml
        IconButtonShowcase.qml
        IconButtonToggleShowcase.qml
        SwitchShowcase.qml
        ToggleButtonShowcase.qml
        SplitButtonShowcase.qml
        FABMenuShowcase.qml
        LinearProgressShowcase.qml
        NavigationRailShowcase.qml
        TextFieldShowcase.qml
        CheckboxShowcase.qml
        RadioButtonShowcase.qml
        CardShowcase.qml
        DialogShowcase.qml
        TabsShowcase.qml
        AvatarShowcase.qml
        BadgeShowcase.qml
        MenuShowcase.qml
        SliderShowcase.qml
    )

set_target_properties(apptestui PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(apptestui
    PRIVATE Qt6::Quick Qt6::Qml
)

target_compile_definitions(apptestui
    PRIVATE SMARTUI_QML_DIR="${CMAKE_SOURCE_DIR}/qml"
)

include(GNUInstallDirs)
install(TARGETS apptestui
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
