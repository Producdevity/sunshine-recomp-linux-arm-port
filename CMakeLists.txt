cmake_minimum_required(VERSION 3.20)
project(super_mario_sunshine C CXX ASM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# sunshine: the shipped binary. It holds no code from the game: at first launch it translates
# the executable on the player's disc (gc-recomp's AArch64 backend) into the cache folder.
# sunshine-c (with SMS_DISC): the same game compiled from a disc image at build time through
# gc-recomp's C path, the reference for differential testing.
set(SMS_DISC "" CACHE FILEPATH "Super Mario Sunshine (USA) disc image (ISO) for sunshine-c")
# Function boundaries from the doldecomp/sms decompilation (CC0), commit 4b2fd238.
set(SMS_SYMBOLS "${CMAKE_CURRENT_SOURCE_DIR}/config/GMSE01.symbols.txt" CACHE FILEPATH "GMSE01 function list (dtk symbols.txt)")
# gc-recomp is a submodule (git clone --recurse-submodules); point GC_RECOMP_DIR at another
# checkout to build against local gc-recomp work.
set(GC_RECOMP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third_party/gc-recomp" CACHE PATH "gc-recomp checkout")
set(GC_RECOMPILER "" CACHE FILEPATH "Host gcrecomp for cross builds")

if(GC_RECOMPILER)
    set(GC_BUILD_RECOMPILER OFF CACHE BOOL "" FORCE)
endif()
set(GC_TESTS OFF CACHE BOOL "" FORCE)
set(GC_FRONTEND ON CACHE BOOL "" FORCE)
set(GC_BACKEND ON CACHE BOOL "" FORCE)
set(STARLET_GLES ON CACHE BOOL "" FORCE)
if(NOT EXISTS "${GC_RECOMP_DIR}/CMakeLists.txt")
    message(FATAL_ERROR "gc-recomp not found in ${GC_RECOMP_DIR}; run git submodule update --init --recursive")
endif()
add_subdirectory("${GC_RECOMP_DIR}" gc-recomp)

add_executable(sunshine src/main.cpp)
target_link_libraries(sunshine PRIVATE gcrt_frontend)
set_target_properties(sunshine PROPERTIES ENABLE_EXPORTS ON)
# The translator's inputs sit next to the binary, as in the port folder.
foreach(file GMSE01.symbols.txt GMSE01.cfg)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/config/${file}" "${CMAKE_CURRENT_BINARY_DIR}/${file}" COPYONLY)
endforeach()

if(SMS_DISC)
    set(recompile_args DISC "${SMS_DISC}" SYMBOLS "${SMS_SYMBOLS}"
        CONFIG "${CMAKE_CURRENT_SOURCE_DIR}/config/GMSE01.cfg")
    if(GC_RECOMPILER)
        list(APPEND recompile_args RECOMPILER "${GC_RECOMPILER}")
    endif()
    gc_recompile(gmse01_code ${recompile_args})
    add_executable(sunshine-c src/main.cpp)
    target_compile_definitions(sunshine-c PRIVATE SMS_COMPILED)
    target_link_libraries(sunshine-c PRIVATE gmse01_code gcrt_frontend)
    # Exported symbols let the in-process sampler name recompiled functions.
    set_target_properties(sunshine-c PROPERTIES ENABLE_EXPORTS ON)
endif()
