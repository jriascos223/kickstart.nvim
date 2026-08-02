-- devkitPro homebrew builds cannot run under cmd.exe: the Makefiles reference
-- $(DEVKITPRO) = /opt/devkitpro, which only resolves through MSYS2's mount
-- table (S:\devkitPro -> /opt/devkitpro, msys2/etc/fstab). 'shell' stays
-- cmd.exe so plugins keep working (see core/options.lua), so builds are routed
-- through MSYS2's bash explicitly instead.
--
--   bash -l   login shell, sources /etc/profile.d/devkit-env.sh, which exports
--             DEVKITPRO and puts devkitPro's tools on PATH
--   CHERE_INVOKING=1
--             keeps the login shell in the current directory instead of cd'ing
--             to $HOME; MSYS2 translates the inherited Windows cwd for us
--
-- Everything here is a no-op off Windows and when MSYS2 is not installed.
local M = {}

---Root of the devkitPro MSYS2 tree. Override with MSYS2_ROOT in the
---environment, or MSYS2_ROOT in lua/local.lua, if devkitPro is not on S:.
---@return string
local function msys2_root()
  local ok, machine = pcall(require, 'local')
  if ok and machine.MSYS2_ROOT and machine.MSYS2_ROOT ~= '' then
    return machine.MSYS2_ROOT
  end
  if vim.env.MSYS2_ROOT and vim.env.MSYS2_ROOT ~= '' then
    return vim.env.MSYS2_ROOT
  end
  return 'S:/devkitPro/msys2'
end

---Root of the devkitPro install on the Windows side (the MSYS2 tree lives
---inside it), or nil when devkitPro is not installed.
---@return string|nil
function M.root()
  local root = msys2_root():gsub('/msys2$', '')
  return vim.fn.isdirectory(root) == 1 and root or nil
end

---Compiler globs for clangd's --query-driver. devkitPro's cross compilers are
---not on clangd's allow-list, so without these it refuses to interrogate them
---for the target's system include paths and every <switch.h> reads as missing.
---@return string[]
function M.query_driver_globs()
  local root = M.root()
  if not root then
    return {}
  end
  return {
    root .. '/devkitA64/bin/aarch64-none-elf-*',
    root .. '/devkitARM/bin/arm-none-eabi-*',
    root .. '/devkitPPC/bin/powerpc-eabi-*',
  }
end

---Path to MSYS2's bash, or nil when it is not installed.
---@return string|nil
function M.bash()
  local bash = msys2_root() .. '/usr/bin/bash.exe'
  return vim.fn.executable(bash) == 1 and bash or nil
end

function M.setup()
  if vim.fn.has 'win32' ~= 1 then
    return
  end
  local bash = M.bash()
  if not bash then
    return
  end

  -- Inherited by every child process nvim spawns, so :make lands in the
  -- project directory rather than $HOME.
  vim.env.CHERE_INVOKING = '1'

  -- aarch64-none-elf-gcc reports plain GNU-style diagnostics, so the stock
  -- errorformat already parses them; only the program needs redirecting.
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('core-devkitpro', { clear = true }),
    pattern = { 'c', 'cpp', 'make' },
    callback = function(event)
      vim.bo[event.buf].makeprg = bash .. ' -lc "make $*"'
    end,
  })

  vim.api.nvim_create_user_command('Dkp', function(opts)
    vim.cmd('make ' .. opts.args)
  end, { nargs = '*', desc = 'devkitPro: make via MSYS2 (:Dkp clean, :Dkp -j8, ...)' })
end

return M
