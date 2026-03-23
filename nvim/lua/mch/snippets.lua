local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local M = {}

-- Define the snippets
local snippets = {
	jinja = {
		s("{{", {
			t("{{ "),
			i(1),
			t(" }}"),
		}),
		s("{%", {
			t("{% "),
			i(1),
			t(" %}"),
		}),
		s("if", {
			t("{% if "),
			i(1, "condition"),
			t(" %}"),
			t({ "", "\t" }),
			i(2),
			t({ "", "{% endif %}" }),
		}),
		s("for", {
			t("{% for "),
			i(1, "item"),
			t(" in "),
			i(2, "items"),
			t(" %}"),
			t({ "", "\t" }),
			i(3),
			t({ "", "{% endfor %}" }),
		}),
		s("block", {
			t("{% block "),
			i(1, "name"),
			t(" %}"),
			t({ "", "\t" }),
			i(2),
			t({ "", "{% endblock %}" }),
		}),
		s("extends", {
			t("{% extends \""),
			i(1, "base.html"),
			t("\" %}"),
		}),
		s("include", {
			t("{% include \""),
			i(1, "partial.html"),
			t("\" %}"),
		}),
		s("set", {
			t("{% set "),
			i(1, "name"),
			t(" = "),
			i(2, "value"),
			t(" %}"),
		}),
		s("macro", {
			t("{% macro "),
			i(1, "name"),
			t("("),
			i(2),
			t(") %}"),
			t({ "", "\t" }),
			i(3),
			t({ "", "{% endmacro %}" }),
		}),
		s("cmt", {
			t("{# "),
			i(1, "comment"),
			t(" #}"),
		}),
	},
}

snippets.jinja2 = snippets.jinja

local is_registered = false

function M.setup()
	if is_registered then
		return
	end

	for filetype, filetype_snippets in pairs(snippets) do
		ls.add_snippets(filetype, filetype_snippets)
	end
	is_registered = true
end

M.snippets = snippets

return M
