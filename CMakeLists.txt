cmake_minimum_required(VERSION 3.13)

project(QmlWatcher VERSION 0.1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17) # C++17
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON) # Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTORCC ON) # Instruct CMake to run rcc automatically when needed.
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Enforce C++17 standard
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # Generate compile_commands.json
# set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin)
#SET(CMAKE_BUILD_TYPE "Release")

file(GLOB_RECURSE   SRCS  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}  LIST_DIRECTORIES false
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
    )
LIST(APPEND SRCS "qml/qml.qrc")


find_package(Qt5 REQUIRED COMPONENTS Quick Core Qml)
find_package(Dtk REQUIRED COMPONENTS Core Gui)
find_package(Qt5QuickControls2)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    ${SRCS}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::QuickControls2
        Dtk::Core
        Dtk::Gui
)
