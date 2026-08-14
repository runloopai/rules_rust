"""Unit tests for link-self-contained flag selection."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

# buildifier: disable=bzl-visibility
load("//rust/private:toolchain.bzl", "effective_link_self_contained_for_testing")

def _zig_disables_self_contained_linking_for_musl_test_impl(ctx):
    env = unittest.begin(ctx)
    asserts.false(
        env,
        effective_link_self_contained_for_testing(
            link_self_contained = True,
            is_zig_cc_toolchain = True,
            target_abi = "musl",
        ),
    )
    return unittest.end(env)

def _zig_preserves_self_contained_linking_for_gnu_test_impl(ctx):
    env = unittest.begin(ctx)
    asserts.true(
        env,
        effective_link_self_contained_for_testing(
            link_self_contained = True,
            is_zig_cc_toolchain = True,
            target_abi = "gnu",
        ),
    )
    return unittest.end(env)

def _non_zig_toolchain_preserves_self_contained_linking_for_musl_test_impl(ctx):
    env = unittest.begin(ctx)
    asserts.true(
        env,
        effective_link_self_contained_for_testing(
            link_self_contained = True,
            is_zig_cc_toolchain = False,
            target_abi = "musl",
        ),
    )
    return unittest.end(env)

zig_disables_self_contained_linking_for_musl_test = unittest.make(
    _zig_disables_self_contained_linking_for_musl_test_impl,
)

zig_preserves_self_contained_linking_for_gnu_test = unittest.make(
    _zig_preserves_self_contained_linking_for_gnu_test_impl,
)

non_zig_toolchain_preserves_self_contained_linking_for_musl_test = unittest.make(
    _non_zig_toolchain_preserves_self_contained_linking_for_musl_test_impl,
)

def link_self_contained_test_suite(name):
    unittest.suite(
        name,
        zig_disables_self_contained_linking_for_musl_test,
        zig_preserves_self_contained_linking_for_gnu_test,
        non_zig_toolchain_preserves_self_contained_linking_for_musl_test,
    )
