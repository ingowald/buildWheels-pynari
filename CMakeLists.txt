cmake_minimum_required(VERSION 3.28)

cmake_policy(SET CMP0104 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

set(CMAKE_BUILD_TYPE_INIT "Release")

#project(buildWheels-pynari)
project(pynari)

set(PYWHEEL_CUDA_ARCHITECTURES "all-major" CACHE STRING
  "Which CUDA architecture to build for")
set(CMAKE_CUDA_ARCHITECTURES ${PYWHEEL_CUDA_ARCHITECTURES})

#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

set(CMAKE_BUILD_PARALLEL_LEVEL 8)
set(CMAKE_BUILD_TYPE Release)

option(SAUCY "Secret-Sauce!?" OFF)
#set(CMAKE_INSTALL_RPATH $ORIGIN)
#set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
#set(CMAKE_INSTALL_NAME_DIR "${RPATHS}")
#set(CMAKE_SKIP_BUILD_RPATH FALSE)
#SET(CMAKE_INSTALL_NAME_DIR @executable_path)
#SET(CMAKE_BUILD_WITH_INSTALL_RPATH ON)


# ==================================================================
# Build ***OWL***, using fixed, known version of optix
# ==================================================================
add_library(cuda_static_stub INTERFACE #STATIC
#  cuda_static_stub.cpp
)
target_compile_definitions(cuda_static_stub INTERFACE -DOWL_CUDA_DRIVER_STATIC=1)
set(OWL_CUDA_STATIC cuda_static_stub)
if (SAUCY)
  set(OptiX_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/optix/)
else()
  set(OptiX_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/nvidia/)
endif()
add_subdirectory(submodules/owl EXCLUDE_FROM_ALL)

# ==================================================================
# Build ***CUBQL***, such that barney can use it
# ==================================================================
add_subdirectory(submodules/cuBQL EXCLUDE_FROM_ALL)

# ==================================================================
# Build ***ANARI-SDK***, such that barney can use it
# ==================================================================
set (BUILD_HELIDE_DEVICE OFF)
set (BUILD_SHARED_LIBS OFF)
add_subdirectory(submodules/ANARI-SDK EXCLUDE_FROM_ALL)

# ==================================================================
# Build ***BARNEY***, with known components and static linkage
# ==================================================================
set(BARNEY_BUILD_ANARI ON)
set(BARNEY_DISABLE_OIDN ON)
set(BARNEY_MPI OFF)
set(BANARI_SKIP_QUERIES ON)
set(BARNEY_DISABLE_DENOISING ON)
#set(BARNEY_CUDA_ARCHITECTURES all-major)
add_subdirectory(submodules/barney EXCLUDE_FROM_ALL)

# ==================================================================
# Build ***PYNARI***, with static linkage
# ==================================================================
set(PYNARI_BAKED_BACKENDS barney)
set(CMAKE_CUDA_ARCHITECUTURES all-major)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

add_subdirectory(submodules/pynari)# EXCLUDE_FROM_ALL)

message("ROOT PROJECT_BINARY_DIR ${PROJECT_BINARY_DIR} ")

#install(TARGETS pynari LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/pynari)
#install(TARGETS pynari LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/)
install(TARGETS pynari LIBRARY DESTINATION pynari)

#${PROJECT_BINARY_DIR}/../cmake_install/pynari)
#install(pynari)a

# ... and statically link in barney
#target_link_libraries(pynari
#  PRIVATE
#  barney_static
#  barney-Spheres-ptx
#  barney-StructuredData-ptx
#  barney-cylinders-ptx
#  barney-capsules-ptx
#  barney-triangles-ptx
#  barney-traceRays-ptx  
#  barney-UMeshRTXObjectSpace-ptx
#  barney-UMeshMC-ptx
#  barney-AWT-ptx  
#  barney-BlockStructuredMC-ptx
#  anari_library_barney_static
#  )

#message("ROOT ${PROJECT_BINARY_DIR} ${PROJECT_INSTALL_DIR}")
#set_property(TARGET pynari PROPERTY EXCLUDE_FROM_ALL FALSE)
#install(TARGETS pynari
#  LIBRARY DESTINATION ${PROJECT_BINARY_DIR}/pynari
#  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/pynari
#  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/pynari
#)


install(
  TARGETS pynari
  LIBRARY
  DESTINATION pynari
)

# installs our package's main '__init__.py' file in
# <install>/pyquiri/__init__.py, so the buildwheel tool will properly
# recognize this pyquiri/ dir as a buildable and installable package
install(
  FILES src/__init__.py
  # where to put it - we want this in <install>/pyquiri
  # $(install_dir)/<packagename(=pyquiri)>/__init__.py
  DESTINATION pynari
  )





