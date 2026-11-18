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
    -- Copilot next-edit suggestions (used by the <Tab> chain below) and an
    -- AI CLI split (Claude Code / opencode) under <leader>a
    {
      "folke/sidekick.nvim",
      opts = {
        cli = { picker = "telescope" },
      },
      config = function(_, opts)
        require("sidekick").setup(opts)

        -- sidekick lists any listening `opencode` process as an attachable
        -- external session, including opencode v2's background
        -- `opencode serve --service` daemon. That one has no terminal, so once
        -- it's picked, toggling (<leader>aa) silently does nothing. Hide it.
        local Session = require("sidekick.cli.session")
        Session.setup()
        local backend = Session.backends.opencode
        if backend then
          local sessions = backend.sessions
          backend.sessions = function(...)
            return vim.tbl_filter(function(s)
              local cmd = vim.system({ "ps", "-o", "command=", "-p", tostring(s.pid) }):wait().stdout or ""
              return not cmd:find("opencode serve", 1, true)
            end, sessions(...))
          end
        end
      end,
      keys = {
        {
          "<Tab>",
          function()
            -- jump to / apply a next-edit suggestion, otherwise a normal <Tab>
            if not require("sidekick").nes_jump_or_apply() then
              return "<Tab>"
            end
          end,
          expr = true,
          desc = "Goto/Apply next edit suggestion",
        },
        { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Toggle AI CLI" },
        { "<leader>as", function() require("sidekick.cli").select() end, desc = "Select AI CLI" },
        { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Detach AI CLI session" },
        { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Toggle Claude Code" },
        { "<leader>ao", function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end, desc = "Toggle opencode" },
        { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "n", "x" }, desc = "Send this to AI CLI" },
        { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = "x", desc = "Send selection to AI CLI" },
        { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Pick AI prompt" },
      },
    },
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
      -- Zed-style: Copilot ghost text > next-edit suggestion > snippet jump > <Tab>
      ["<Tab>"] = {
        function()
          return vim.lsp.inline_completion.get()
        end,
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
        "snippet_forward",
        "fallback",
      },
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
      -- off: Copilot's inline ghost text takes this spot
      ghost_text = { enabled = false },
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
