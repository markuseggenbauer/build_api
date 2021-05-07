include_guard(GLOBAL)

include(me_build_variants)
include(me_build_property_asan)
include(me_build_property_tsan)
include(me_build_property_usan)
include(me_build_property_clangtidy)

# default definitions
me_add_build_variant(Sanitize BUILD_PROPERTIES ASan USan)
me_add_build_variant(SanitizeThreads BUILD_PROPERTIES TSan)
me_add_build_variant(StaticChecks BUILD_PROPERTIES ClangTidy)
