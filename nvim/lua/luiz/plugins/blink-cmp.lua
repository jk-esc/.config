return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
    },
    "rafamadriz/friendly-snippets",
  },
  opts = {
    -- dressing.nvim renders vim.ui.input (nvim-tree add/rename/delete prompts)
    -- as a scratch buffer with filetype "DressingInput". Disable completion there
    -- so typing a filename / y-N answer isn't hijacked by snippet/path completion.
    enabled = function()
      return vim.bo.filetype ~= "DressingInput"
    end,
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      ghost_text = { enabled = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },
    signature = { enabled = true },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lazydev", "lsp", "snippets", "buffer", "path" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    -- No completion in command-line mode: ":" commands, "/" "?" search, and
    -- input() prompts (nvim-tree add/rename + its y/N confirmation) stay native.
    cmdline = { enabled = false },
  },
  config = function(_, opts)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("blink.cmp").setup(opts)
  end,
}
