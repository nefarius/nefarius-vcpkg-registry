set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 b8a611f8d9c13d779ab896ad48e0c3d1473cdcd664dfa73283c5133c18fe1f07bbbc91ff9679f2645798f50652d8120f7173ecaee5029307d551a360c31bf697
)

vcpkg_msbuild_install(
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
