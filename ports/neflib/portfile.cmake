vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 0
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR})

vcpkg_copy_pdbs()

file(WRITE ${CURRENT_PACKAGES_DIR}/share/neflib/vcpkg-cmake-wrapper.cmake
"
# This file is a wrapper for configuring the CMake project that consumes this package.
# Add any additional variables or configuration options you want to automatically
# apply when this port is consumed.

set(neflib_DIR \${CURRENT_PACKAGES_DIR}/lib/cmake/neflib CACHE STRING \"neflib library path\")
")

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_TOOLCHAIN_FILE=${VCPKG_CMAKE_TOOLCHAIN_FILE}
        -DVCPKG_TARGET_TRIPLET=${TARGET_TRIPLET}
)

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/neflib)
vcpkg_copy_pdbs()
vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src DESTINATION ${CURRENT_PACKAGES_DIR}/src)

vcpkg_copy_pdbs()

file(WRITE ${CURRENT_PACKAGES_DIR}/share/neflib/vcpkg-cmake-wrapper.cmake
"
# This file is a wrapper for configuring the CMake project that consumes this package.
# Add any additional variables or configuration options you want to automatically
# apply when this port is consumed.

set(neflib_DIR \${CURRENT_PACKAGES_DIR}/lib/cmake/neflib CACHE STRING \"neflib library path\")
")

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/neflib)
