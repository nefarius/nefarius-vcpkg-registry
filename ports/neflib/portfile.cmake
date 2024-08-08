set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 0a83618ea0a14630475e2763273cd38b25d54c57a05238f6b3ca40480bd7ed21475d4071d941b3d3b80a953a7d33f1d6233a884ccb9d81503ff0076a87b8b088
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
