# Copyright 2022 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""apple_dynamic_xcframework_import and apple_static_xcframework_import Starlark tests."""

load(
    ":rules/analysis_target_outputs_test.bzl",
    "analysis_target_outputs_test",
)
load(
    ":rules/apple_verification_test.bzl",
    "apple_verification_test",
)
load(
    ":rules/common_verification_tests.bzl",
    "archive_contents_test",
)

def apple_xcframework_import_test_suite(name):
    """Test suite for apple_dynamic_xcframework_import and apple_static_xcframework_import.

    Args:
      name: the base name to be used in things created by this macro
    """

    # Test that apple_dynamic_xcframework_import can import XCFrameworks bundling dynamic frameworks
    analysis_target_outputs_test(
        name = "{}_dynamic_xcfw_import_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_dynamic_xcfmwk",
        expected_outputs = ["app_with_imported_dynamic_xcfmwk.ipa"],
        tags = [name],
    )

    analysis_target_outputs_test(
        name = "{}_dynamic_xcfw_import_with_lib_ids_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_dynamic_xcfmwk_with_lib_ids",
        expected_outputs = ["app_with_imported_dynamic_xcfmwk_with_lib_ids.ipa"],
        tags = [name],
    )

    apple_verification_test(
        name = "{}_imported_dynamic_xcfmwk_codesign_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_dynamic_xcfmwk",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    # Test that apple_static_xcframework_import can import XCFrameworks bundling static frameworks
    analysis_target_outputs_test(
        name = "{}_xcfmwk_bundling_static_fmwks_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_static_fmwks",
        expected_outputs = ["app_with_imported_xcfmwk_bundling_static_fmwks.ipa"],
        tags = [name],
    )

    apple_verification_test(
        name = "{}_xcfmwk_bundling_static_xcfmwks_codesign_test_simulator".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_static_fmwks",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    apple_verification_test(
        name = "{}_xcfmwk_bundling_static_xcfmwks_codesign_test_device".format(name),
        build_type = "device",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_static_fmwks",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    # Test that apple_static_xcframework_import can import XCFrameworks
    # bundling static libraries and make them usable from objc_library
    analysis_target_outputs_test(
        name = "{}_static_xcfw_import_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_static_xcfmwk",
        expected_outputs = ["app_with_imported_static_xcfmwk.ipa"],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_static_xcfw_binary_not_bundled_simulator".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_static_fmwks_with_resources",
        contains = [
            "$BUNDLE_ROOT/resource_bundle.bundle/custom_apple_resource_info.out",
            "$BUNDLE_ROOT/resource_bundle.bundle/Info.plist",
        ],
        not_contains = [
            "$BUNDLE_ROOT/Frameworks/ios_static_xcframework_with_resources.framework/ios_static_xcframework_with_resources",
        ],
        tags = [name],
    )

    archive_contents_test(
        name = "{}_static_xcfw_binary_not_bundled_device".format(name),
        build_type = "device",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_static_fmwks_with_resources",
        contains = [
            "$BUNDLE_ROOT/resource_bundle.bundle/custom_apple_resource_info.out",
            "$BUNDLE_ROOT/resource_bundle.bundle/Info.plist",
        ],
        not_contains = [
            "$BUNDLE_ROOT/Frameworks/ios_static_xcframework_with_resources.framework/ios_static_xcframework_with_resources",
        ],
        tags = [name],
    )

    # Verify ios_application with static XCFramework that has data attribute
    # bundles the framework's data in the final binary.
    archive_contents_test(
        name = "{}_static_xcfw_with_bundle_resources_and_data".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_xcfmwk_bundling_resources_and_data",
        contains = [
            "$BUNDLE_ROOT/sample.png",
            "$BUNDLE_ROOT/it.lproj/view_ios.nib",
            "$BUNDLE_ROOT/fr.lproj/view_ios.nib",
            "$BUNDLE_ROOT/resource_bundle.bundle/",
        ],
        tags = [name],
    )

    analysis_target_outputs_test(
        name = "{}_static_xcfw_import_with_lib_ids_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_static_xcfmwk_with_lib_ids",
        expected_outputs = ["app_with_imported_static_xcfmwk_with_lib_ids.ipa"],
        tags = [name],
    )

    apple_verification_test(
        name = "{}_imported_static_xcfmwk_codesign_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_static_xcfmwk",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    # Test that apple_static_xcframework_import can import XCFrameworks
    # bundling static libraries with module maps make them usable from
    # swift_library
    analysis_target_outputs_test(
        name = "{}_static_xcfw_with_module_map_import_ipa_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_static_xcfmwk_with_module_map",
        expected_outputs = ["app_with_imported_static_xcfmwk_with_module_map.ipa"],
        tags = [name],
    )

    apple_verification_test(
        name = "{}_imported_static_xcfmwk_with_module_map_codesign_test".format(name),
        build_type = "simulator",
        target_under_test = "//test/starlark_tests/targets_under_test/ios:app_with_imported_static_xcfmwk_with_module_map",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    native.test_suite(
        name = name,
        tags = [name],
    )
