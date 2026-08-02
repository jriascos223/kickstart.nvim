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
    init = function()
      -- Parser builds must behave identically on macOS and Windows, so pin the
      -- compiler search order instead of taking whatever the default list finds
      -- first ({ $CC, cc, gcc, clang, cl, zig }).
      --
      -- zig is the only entry that is one self-contained binary on both
      -- platforms -- no Xcode CLT, no Visual Studio Build Tools -- and
      -- nvim-treesitter has a dedicated `zig c++` argument path for it.
      -- cc/clang stay as a native fallback (on macOS `cc` is clang).
      --
      -- gcc is deliberately omitted: S:\devkitPro\msys2\usr\bin is on PATH here,
      -- and an msys2 gcc appearing there would outrank zig in the default order
      -- and emit a parser linked against the msys2 runtime that nvim cannot load.
      require('nvim-treesitter.install').compilers = { 'zig', 'cc', 'clang' }
    end,
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
