set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 6e335c9599be98423dc11fa4fdaca2dfb10ce45b3d0f96cc8bafefff2f94dc4073cc5a1b40bd5b66d80fbf3d831d2c58768574b92744af4ecd86f10e4e2b7d50
)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_install_msbuild(
    SOURCE_PATH "${SOURCE_PATH}"
    PROJECT_SUBPATH src/neflib.vcxproj
    RELEASE_CONFIGURATION "Release"
    DEBUG_CONFIGURATION "Debug"
    PLATFORM ${PLATFORM}
)

vcpkg_fixup_pkgconfig()

vcpkg_copy_pdbs()

file(COPY
    "${SOURCE_PATH}/include/nefarius/neflib"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/nefarius"
    FILES_MATCHING PATTERN *.h PATTERN *.hpp)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
