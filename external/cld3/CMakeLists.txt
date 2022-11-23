# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

add_library(external_cld3 INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_cld3 ALIAS external_cld3)

if (DESKTOP_APP_USE_PACKAGED)
    # find_package(Protobuf REQUIRED)
endif()

add_library(external_cld3_bundled STATIC)
init_target(external_cld3_bundled "(external)")

set(cld3_loc ${third_party_loc}/cld3)
set(cld3_src ${cld3_loc}/src)

set(gen_loc ${cld3_loc}/build/gen)
set(gen_dst ${gen_loc}/cld_3/protos)

if (WIN32)
    set(build_loc ${libs_loc}/protobuf/build/$<IF:$<CONFIG:Debug>,Debug,Release>)
    set(protoc_executable ${build_loc}/protoc.exe)
    set(protobuf_lib ${build_loc}/libprotobuf-lite.lib)
else()
    set(protoc_executable ${libs_loc}/protobuf/build/protoc)
    set(protobuf_lib ${libs_loc}/protobuf/build/libprotobuf-lite.a)
    if (LINUX)
        target_compile_options(external_cld3_bundled PRIVATE -Wno-implicit-fallthrough)
    endif()
endif()
if (PROTOBUF_PROTOC_EXECUTABLE)
    set(protoc_executable ${PROTOBUF_PROTOC_EXECUTABLE})
endif()

include(generate_protobuf.cmake)

function(generate protobuf_name)
    generate_single_protobuf(
        external_cld3_bundled
        ${gen_dst}
        ${protobuf_name}
        ${protoc_executable})
endfunction()

generate(feature_extractor.proto)
generate(sentence.proto)
generate(task_spec.proto)

nice_target_sources(external_cld3_bundled ${cld3_src}
PRIVATE
    feature_extractor.proto
    sentence.proto
    task_spec.proto

    base.cc
    embedding_feature_extractor.cc
    embedding_network.cc
    feature_extractor.cc
    feature_extractor.h
    feature_types.cc
    fml_parser.cc
    language_identifier_features.cc
    lang_id_nn_params.cc
    nnet_language_identifier.cc
    registry.cc
    relevant_script_feature.cc
    sentence_features.cc
    task_context.cc
    task_context_params.cc
    unicodetext.cc
    utils.cc
    workspace.cc

    script_span/generated_entities.cc
    script_span/getonescriptspan.cc
    script_span/getonescriptspan.h
    script_span/getonescriptspan_test.cc
    script_span/utf8statetable.cc
    script_span/offsetmap.cc
    script_span/text_processing.cc
    script_span/text_processing.h
    script_span/fixunicodevalue.cc
)

target_include_directories(external_cld3_bundled
PUBLIC
    ${cld3_src}
    ${gen_loc}
    ${libs_loc}/protobuf/src
    ${libs_loc}/protobuf/third_party/abseil-cpp
)

target_link_libraries(external_cld3
INTERFACE
    external_cld3_bundled
    ${protobuf_lib}
)