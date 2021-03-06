PROJECT(po)

FIND_PROGRAM(K3D_INTLTOOL_UPDATE intltool-update)

FIND_PROGRAM(K3D_XGETTEXT xgettext)

FIND_PROGRAM(K3D_MSGMERGE msgmerge)

FIND_PROGRAM(K3D_MSGFMT msgfmt)

MESSAGE(STATUS "generating i18n catalog")

SET(SKIP_FILES
	"^share/shaders/"
	)

SET(LOCALIZABLE_FILES "")
FILE(GLOB_RECURSE TEMP_FILES "${k3d_SOURCE_DIR}/*.h")
LIST(APPEND LOCALIZABLE_FILES ${TEMP_FILES})
FILE(GLOB_RECURSE TEMP_FILES "${k3d_SOURCE_DIR}/*.cpp")
LIST(APPEND LOCALIZABLE_FILES ${TEMP_FILES})
LIST(SORT LOCALIZABLE_FILES)

FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/POTFILES.in "")
FOREACH(LOCALIZABLE_FILE ${LOCALIZABLE_FILES})
	FILE(RELATIVE_PATH RELATIVE_LOCALIZABLE_FILE ${k3d_SOURCE_DIR} ${LOCALIZABLE_FILE})

	SET(TEST_FILE 1)
	FOREACH(SKIP_FILE ${SKIP_FILES})
		IF(RELATIVE_LOCALIZABLE_FILE MATCHES "${SKIP_FILE}")
			SET(TEST_FILE 0)
			BREAK()
		ENDIF()
	ENDFOREACH()

	IF(TEST_FILE)
		FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/POTFILES.in "${RELATIVE_LOCALIZABLE_FILE}\n")
	ENDIF()
ENDFOREACH()

MESSAGE(STATUS "  done")

ADD_CUSTOM_COMMAND(
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/POTFILES.in
	COMMAND ${K3D_XGETTEXT} --files-from ${CMAKE_CURRENT_BINARY_DIR}/POTFILES.in --keyword=_ -o ${CMAKE_CURRENT_BINARY_DIR}/k3d.pot --copyright-holder="Timothy M. Shead" --msgid-bugs-address="k3d-development@lists.sourceforge.net" --no-wrap --no-location
	WORKING_DIRECTORY ${k3d_SOURCE_DIR}
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/k3d.pot
	)

SET(K3D_CATALOGS chef)
SET(K3D_CATALOG_TARGETS "")
FOREACH(catalog ${K3D_CATALOGS})
	ADD_CUSTOM_TARGET(nls-update-${catalog}.po
		DEPENDS ${po_SOURCE_DIR}/${catalog}.po
		COMMAND ${K3D_MSGMERGE} ${po_SOURCE_DIR}/${catalog}.po ${CMAKE_CURRENT_BINARY_DIR}/k3d.pot -o ${catalog}.po --no-wrap --sort-output
		WORKING_DIRECTORY ${po_SOURCE_DIR}
		)

	FILE(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${catalog}/LC_MESSAGES")

	ADD_CUSTOM_COMMAND(
		DEPENDS ${po_SOURCE_DIR}/${catalog}.po
		COMMAND ${K3D_MSGFMT} -c -o ${CMAKE_CURRENT_BINARY_DIR}/${catalog}/LC_MESSAGES/k3d.mo ${po_SOURCE_DIR}/${catalog}.po
		OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${catalog}/LC_MESSAGES/k3d.mo
		)

	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/${catalog}/LC_MESSAGES/k3d.mo
		DESTINATION share/k3d/locale/${catalog}/LC_MESSAGES
		)

	LIST(APPEND K3D_CATALOG_TARGETS ${CMAKE_CURRENT_BINARY_DIR}/${catalog}/LC_MESSAGES/k3d.mo)
ENDFOREACH(catalog)

ADD_CUSTOM_TARGET(nls ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/k3d.pot ${K3D_CATALOG_TARGETS}
	)

