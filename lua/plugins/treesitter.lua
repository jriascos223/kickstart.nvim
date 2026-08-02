return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    -- Pinned explicitly: the `main` rewrite has a different API (`.install{}` /
    -- `.setup{}` on the root module) and needs a C toolchain to build parsers.
    -- This machine has no compiler, so stay on master and reuse the parsers
    -- already compiled under lazy/nvim-treesitter/parser/.
    branch = 'master',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'kotlin',
        'java',
        'python',
        'typescript',
        'tsx',
        'sql',
        'proto',
        'graphql',
        'terraform',
        'yaml',
        'json',
        'dockerfile',
      },
      -- Never build on the fly: without a compiler that just throws on every
      -- new filetype. Install a toolchain, then run :TSInstall <lang> manually.
      auto_install = false,
      sync_install = false,
      highlight = { enable = true },
    },
  },
}
