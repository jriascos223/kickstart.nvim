-- lsp/sourcekit.lua
-- Config for the SourceKit-LSP server that ships with the Swift toolchain.
-- Auto-loaded by Neovim when `vim.lsp.enable("sourcekit")` runs (the filename
-- "sourcekit" is the server name). This is a vim.lsp config table, NOT a
-- lazy.nvim plugin spec.
return {
  cmd = { 'sourcekit-lsp' },
  filetypes = { 'swift' },
  root_markers = {
    '.git',
    'compile_commands.json',
    '.sourcekit-lsp',
    'Package.swift',
  },
  get_language_id = function(_, ftype)
    return ftype
  end,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
}
