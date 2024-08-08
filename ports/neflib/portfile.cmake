set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 0297d2a680c1813022568335201ca91cd582c0cba77c0670c01bb20b30f9fdaeb0e2ede934052d037d285e92f7072a0449a27ac0e70d66a512cf92a72f6cfe50
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
