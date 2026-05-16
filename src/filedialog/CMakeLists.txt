find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Concurrent)

set(CMAKE_AUTOMOC ON)

add_library(ChiFileDialog STATIC
    filelistmodel.cpp
    thumbnailprovider.cpp
    fileiconprovider.cpp
    register_types.cpp
)

target_include_directories(ChiFileDialog PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(ChiFileDialog
    PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::Quick
        Qt6::Concurrent
)
