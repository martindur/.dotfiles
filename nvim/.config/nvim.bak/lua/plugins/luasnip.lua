return {
  "L3MON4D3/LuaSnip",
  keys = {
    { "<tab>", false, mode = { "i", "s" } },
    {
      "<c-k>",
      function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<c-j>",
      function()
        local ls = require("luasnip")
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<c-l>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      silent = true,
      mode = "i",
    },
  },
}
