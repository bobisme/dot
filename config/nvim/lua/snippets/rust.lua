local ls = require("luasnip")
-- some shorthands...
local snippet = ls.snippet
-- local snode = ls.snippet_node
local text = ls.text_node
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

ls.add_snippets("rust", {
	snippet("cows", {
		text("Cow<'a, str>"),
    ins(0),
	}),
	snippet("cowb", {
		text("Cow<'a, [u8]>"),
    ins(0),
	}),
	snippet("cow", {
		text("Cow<'a, "), ins(1), text(">"),
    ins(0),
	}),
})
