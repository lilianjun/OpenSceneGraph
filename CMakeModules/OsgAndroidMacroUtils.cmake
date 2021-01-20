MACRO(SETUP_ANDROID_LIBRARY LIB_NAME)

    #foreach(arg ${TARGET_LIBRARIES})
    #    set(MODULE_LIBS "${MODULE_LIBS} -l${arg}")
    #endforeach(arg ${TARGET_LIBRARIES})
    
    foreach(arg ${TARGET_SRC})
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" n_f ${arg})
        IF ("${arg}" MATCHES ".*\\.c$" OR "${arg}" MATCHES ".*\\.cpp$")
            #We only include source files, not header files, this removes anoying warnings
            set(MODULE_SOURCES "${MODULE_SOURCES} ${n_f}")
    ENDIF()
    endforeach(arg ${TARGET_SRC})
    
       #SET(MODULE_INCLUDES "${CMAKE_SOURCE_DIR}/include include") 
    GET_DIRECTORY_PROPERTY(loc_includes INCLUDE_DIRECTORIES)
    foreach(arg ${loc_includes})
        IF(NOT "${arg}" MATCHES "/usr/include" AND NOT "${arg}" MATCHES "/usr/local/include")
            set(MODULE_INCLUDES "${MODULE_INCLUDES} ${arg}")
        ENDIF()
    endforeach(arg ${loc_includes})

    GET_DIRECTORY_PROPERTY(loc_definitions COMPILE_DEFINITIONS) 
    foreach(arg ${loc_definitions})
        set(DEFINITIONS "${DEFINITIONS} -D${arg}")
    endforeach(arg ${loc_definitions})

    message(STATUS "##############Creating Android Makefile#################")
    message(STATUS "name: ${LIB_NAME}")
        
    set(MODULE_NAME        ${LIB_NAME})
    set(MODULE_DIR         ${CMAKE_CURRENT_SOURCE_DIR})
    set(MODULE_FLAGS_C       ${DEFINITIONS})
    set(MODULE_FLAGS_CPP   ${DEFINITIONS})
    #TODO: determine if GLES2 or GLES
    IF(OSG_GLES1_AVAILABLE)
        SET(OPENGLES_LIBRARY -lGLESv1_CM)
    ELSEIF(OSG_GLES2_AVAILABLE)
        SET(OPENGLES_LIBRARY -lGLESv2)
    ENDIF()
    #${MODULE_LIBS}
    set(MODULE_LIBS_FLAGS "${OPENGLES_LIBRARY} -ldl")   
    if(NOT CPP_EXTENSION)
        set(CPP_EXTENSION "cpp")
    endif()
    IF(NOT MODULE_USER_STATIC_OR_DYNAMIC)
        MESSAGE(FATAL_ERROR "Not defined MODULE_USER_STATIC_OR_DYNAMIC")
    ENDIF()
    IF("MODULE_USER_STATIC_OR_DYNAMIC" MATCHES "STATIC")
        SET(MODULE_BUILD_TYPE "\$\(BUILD_STATIC_LIBRARY\)")
    SET(MODULE_LIBS_SHARED " ")
    SET(MODULE_LIBS_STATIC ${TARGET_LIBRARIES})
    ELSE()
        SET(MODULE_BUILD_TYPE "\$\(BUILD_SHARED_LIBRARY\)")
    SET(MODULE_LIBS_SHARED ${TARGET_LIBRARIES})
    SET(MODULE_LIBS_STATIC " ")
    ENDIF()
    set(ENV{AND_OSG_LIB_NAMES} "$ENV{AND_OSG_LIB_NAMES} ${LIB_NAME}")
    set(ENV{AND_OSG_LIB_PATHS} "$ENV{AND_OSG_LIB_PATHS}include ${CMAKE_CURRENT_BINARY_DIR}/Android.mk \n")
    
    configure_file("${OSG_ANDROID_TEMPLATES}/Android.mk.modules.in" "${CMAKE_CURRENT_BINARY_DIR}/Android.mk")
    
ENDMACRO()

MACRO(ANDROID_3RD_PARTY)
    ################################################
    #ZLIB
    ################################################
    find_package(ZLIB)

    ################################################
    #JPEG
    ################################################
    find_package(JPEG)

    ################################################
    #PNG
    ################################################
    find_package(PNG)

    ################################################
    #GIF
    ################################################
    
    ################################################
    #TIF
    ################################################
    find_package(TIFF)

    ################################################
    #CURL
    ################################################
    find_package(CURL)

    ################################################
    #FREETYPE
    ################################################
    find_package(FREETYPE)

    MESSAGE(STATUS "LLJ  ${FREETYPE_FOUND} -- ${FREETYPE_INCLUDE_DIRS} -- ${FREETYPE_INCLUDE_DIR_ft2build} -- ${FREETYPE_INCLUDE_DIR_freetype2} --")

    ################################################
    #GDAL
    ################################################
    
ENDMACRO()
