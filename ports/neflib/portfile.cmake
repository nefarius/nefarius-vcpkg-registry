set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nefarius/neflib
    REF master
    SHA512 e5abeb1727e4c80c53632acb90e73f2746cdbd8177f0502895794d56ec89eb8511d2003beebe9e0cd58c321f26160baa3d4f16902160e44629c6ed62947d185c
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
