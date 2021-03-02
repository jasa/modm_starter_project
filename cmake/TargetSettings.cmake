# Copyright (c) 2018, Sergiy Yevtushenko
# Copyright (c) 2018-2019, Niklas Hauser
# Copyright (c) 2010, Jacob Andersen
#
# This file is part of the modm project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This file was autogenerated by the modm cmake builder. Do not modify!

function(set_target_settings target_options target_warnings)
  set(CPPDEFINES
  )

  set(CPPDEFINES_RELEASE
  )

  set(CPPDEFINES_DEBUG
    -DMODM_DEBUG_BUILD
  )


  set(CCFLAGS
    -fdata-sections
    -ffunction-sections
    -finline-limit=10000
    -fshort-wchar
    -fsingle-precision-constant
    -funsigned-bitfields
    -funsigned-char
    -fwrapv
    -g3
    -gdwarf-3
  )

  set(CCFLAGS_RELEASE
  )

  set(CCFLAGS_DEBUG
    -fno-move-loop-invariants
    -fno-split-wide-types
    -fno-tree-loop-optimize
  )


  set(CFLAGS
  )

  set(CFLAGS_RELEASE
  )

  set(CFLAGS_DEBUG
  )


  set(CXXFLAGS
    -fno-exceptions
    -fno-rtti
    -fno-unwind-tables
    -fstrict-enums
    -fuse-cxa-atexit
  )

  set(CXXFLAGS_RELEASE
  )

  set(CXXFLAGS_DEBUG
  )


  set(ASFLAGS
    -g3
    -gdwarf-3
  )

  set(ASFLAGS_RELEASE
  )

  set(ASFLAGS_DEBUG
  )


  set(ARCHFLAGS
    -mcpu=cortex-m4
    -mfloat-abi=hard
    -mfpu=fpv4-sp-d16
    -mthumb
  )

  set(ARCHFLAGS_RELEASE
  )

  set(ARCHFLAGS_DEBUG
  )


  set(LINKFLAGS
    --specs=nano.specs
    --specs=nosys.specs
    -L${CMAKE_CURRENT_SOURCE_DIR}
    -nostartfiles
    -T${CMAKE_CURRENT_SOURCE_DIR}/link/linkerscript.ld
    -Wl,--build-id=sha1
    -Wl,--fatal-warnings
    -Wl,--gc-sections
    -Wl,--no-wchar-size-warning
    -Wl,--relax
    -Wl,-wrap,_calloc_r
    -Wl,-wrap,_free_r
    -Wl,-wrap,_malloc_r
    -Wl,-wrap,_realloc_r
  )

  set(LINKFLAGS_RELEASE
  )

  set(LINKFLAGS_DEBUG
  )


  set(CWARN
    -Wbad-function-cast
    -Wimplicit
    -Wredundant-decls
    -Wstrict-prototypes
  )

  set(CWARN_RELEASE
  )

  set(CWARN_DEBUG
  )


  set(CCWARN
    -W
    -Wall
    -Wdouble-promotion
    -Wduplicated-cond
    -Werror=format
    -Werror=maybe-uninitialized
    -Werror=overflow
    -Werror=sign-compare
    -Wextra
    -Wlogical-op
    -Wno-redundant-decls
    -Wpointer-arith
    -Wundef
  )

  set(CCWARN_RELEASE
  )

  set(CCWARN_DEBUG
  )


  set(CXXWARN
    -Wno-volatile
    -Woverloaded-virtual
  )

  set(CXXWARN_RELEASE
  )

  set(CXXWARN_DEBUG
  )


  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CCFLAGS ${CCFLAGS} ${CCFLAGS_DEBUG})
    set(CPPDEFINES ${CPPDEFINES} ${CPPDEFINES_DEBUG})
  endif()

  target_compile_definitions(${target_options} INTERFACE ${CPPDEFINES})
  target_compile_options(${target_options} INTERFACE
    ${CCFLAGS} ${ARCHFLAGS}
    $<$<COMPILE_LANGUAGE:CXX>:${CXXFLAGS}>
    $<$<COMPILE_LANGUAGE:ASM>:${ARCHFLAGS}>
    $<$<COMPILE_LANGUAGE:C>:${CFLAGS}>
  )

  target_compile_options(${target_warnings} INTERFACE
    ${CCWARN}
    $<$<COMPILE_LANGUAGE:CXX>:${CXXWARN}>
    $<$<COMPILE_LANGUAGE:ASM>:${ASFLAGS}>
    $<$<COMPILE_LANGUAGE:C>:${CWARN}>
  )

  target_link_options(${target_options} INTERFACE ${LINKFLAGS} ${ARCHFLAGS})
endfunction()

function(write_target_files project_name)
  set_target_properties(${project_name}
    PROPERTIES SUFFIX ".elf")

  add_custom_command(TARGET ${project_name}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Obinary ${project_name}.elf ${project_name}.bin)

  add_custom_command(TARGET ${project_name}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Oihex ${project_name}.elf ${project_name}.hex)

  #add_custom_command(TARGET ${project_name}
  #  POST_BUILD
  #  COMMAND ${CMAKE_OBJDUMP}  -x -s -S -l -w ${project_name}.elf > ${project_name}.lss)

  add_custom_command(TARGET ${project_name}
    POST_BUILD
    COMMAND ${CMAKE_SIZE_UTIL} ${project_name}.elf)

  # TODO Not working due to a releative path in modm/modm_tools/openocd.py
  add_custom_target(openocd DEPENDS ${project_name}.elf)
  add_custom_command(TARGET openocd
    USES_TERMINAL
    COMMAND python3 ${PROJECT_SOURCE_DIR}/modm/modm_tools/openocd.py -f ${PROJECT_SOURCE_DIR}/modm/openocd.cfg ${project_name}.elf)

  add_custom_target(stflash DEPENDS ${project_name}.elf)
  add_custom_command(TARGET stflash
    USES_TERMINAL
    COMMAND st-flash --reset write ${project_name}.bin 0x8000000)
endfunction()