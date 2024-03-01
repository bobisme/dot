local ls = require("luasnip")
-- some shorthands...
local snippet = ls.snippet
-- local snode = ls.snippet_node
local t = ls.text_node
local ins = ls.insert_node
local fn = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

return {
  snippet("cows", {
    t("Cow<'a, str>"),
    ins(0),
  }),
  snippet("cowb", {
    t("Cow<'a, [u8]>"),
    ins(0),
  }),
  snippet("cow", {
    t("Cow<'a, "),
    ins(1),
    t(">"),
    ins(0),
  }),
  snippet("inl", {
    t("#[inline]"),
    ins(0),
  }),
  snippet("mus", {
    t("#[must_use]"),
    ins(0),
  }),
  snippet("comptest", {
    t({
      "// compile-time tests",
      "const _: () = {",
      "\tassert!(",
    }),
    ins(1),
    t({ ")", "};" }),
    ins(0),
  }),
  snippet("testmod", {
    t({
      "#[cfg(test)]",
      "mod test",
    }),
    ins(1),
    t({
      "{",
      "\tuse super::*;",
      "\tuse assert2::assert;",
      "\tuse rstest::*;",
      "",
      "\t#[rstest]",
      "\tfn it_works() {",
      "\t\t",
    }),
    ins(0),
    t({
      "",
      "\t}",
      "}",
    }),
  }),
  -- tracing subscriber
  snippet("tracingsub", {
    t({
      "fn subscriber() -> impl tracing::subscriber::Subscriber {",
      "    use tracing_subscriber::{fmt::format::FmtSpan, prelude::*};",
      "    tracing_subscriber::registry()",
      "        .with(tracing_subscriber::EnvFilter::from_default_env())",
      "        .with(",
      "            tracing_subscriber::fmt::layer()",
      "                .compact()",
      "                .with_target(false)",
      "                .without_time()",
      "                .with_span_events(FmtSpan::CLOSE),",
      "        )",
      "}",
      "tracing::subscriber::set_global_default(subscriber()).unwrap();",
    }),
  }),
}
