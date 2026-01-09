-- lua/custom/plugins/java.lua
-- Java LSP + DAP + Test integration (Mason v2-compatible)
return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  config = function()
    local jdtls = require 'jdtls'

    --------------------------------------------------------------------
    -- OS-specific config dir for jdtls
    --------------------------------------------------------------------
    local sysname = (vim.uv or vim.loop).os_uname().sysname
    local os_config = (sysname == 'Darwin' and 'config_mac') or (sysname == 'Linux' and 'config_linux') or 'config_win'

    --------------------------------------------------------------------
    -- Mason root + jdtls package directory
    --------------------------------------------------------------------
    local mason_root = vim.fn.expand '$MASON'
    if mason_root == '' then
      mason_root = vim.fn.stdpath 'data' .. '/mason'
    end

    -- Mason installs packages into $MASON/packages/<name>
    local jdtls_path = mason_root .. '/packages/jdtls'

    -- Fallback: Homebrew (macOS)
    if vim.fn.isdirectory(jdtls_path) == 0 and sysname == 'Darwin' then
      local brew_path = '/opt/homebrew/opt/jdtls/libexec'
      if vim.fn.isdirectory(brew_path) == 1 then
        jdtls_path = brew_path
      end
    end

    -- Bail out early with a helpful message
    if vim.fn.isdirectory(jdtls_path) == 0 then
      vim.notify('jdtls not found. Install via :MasonInstall jdtls or `brew install jdtls` (macOS).', vim.log.levels.ERROR)
      return
    end

    local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
    if launcher == '' then
      vim.notify('Could not find jdtls launcher JAR in ' .. jdtls_path, vim.log.levels.ERROR)
      return
    end

    --------------------------------------------------------------------
    -- Optional: DAP / Test bundles via Mason share/
    --------------------------------------------------------------------
    local bundles = {}

    local function add_glob(glob)
      local items = vim.split(vim.fn.glob(glob), '\n', { trimempty = true })
      for _, p in ipairs(items) do
        if p ~= '' then
          table.insert(bundles, p)
        end
      end
    end

    local mason_share = mason_root .. '/share'

    -- java-debug-adapter bundles
    if vim.fn.isdirectory(mason_share .. '/java-debug-adapter') == 1 then
      add_glob(mason_share .. '/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar')
    end

    -- java-test bundles
    if vim.fn.isdirectory(mason_share .. '/java-test') == 1 then
      add_glob(mason_share .. '/java-test/*.jar')
    end

    --------------------------------------------------------------------
    -- Workspace per project
    --------------------------------------------------------------------
    local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
    local root_dir = require('jdtls.setup').find_root(root_markers) or vim.fn.getcwd()
    local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

    --------------------------------------------------------------------
    -- Capabilities (nvim-cmp)
    --------------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok_cmp then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    --------------------------------------------------------------------
    -- Start/attach jdtls
    --------------------------------------------------------------------
    -- If you ever want to force a specific JDK (e.g. sdkman),
    -- replace 'java' below with an absolute path to your java binary.
    local cmd = {
      'java', -- Make sure this is a JDK ≥ 17 (21+ recommended)
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-jar',
      launcher,
      '-configuration',
      jdtls_path .. '/' .. os_config,
      '-data',
      workspace_dir,
    }

    local function on_attach(client, bufnr)
      -- DAP + Commands
      pcall(jdtls.setup_dap, { hotcodereplace = 'auto' })
      pcall(jdtls.setup.add_commands)
      pcall(jdtls.setup_dap_main_class_configs)

      -- Safe mapping helper: only map if fn is actually a function
      local function safe_map(lhs, fn, desc)
        if type(fn) == 'function' then
          vim.keymap.set('n', lhs, fn, {
            buffer = bufnr,
            desc = 'Java: ' .. desc,
          })
        end
      end

      safe_map('<leader>ji', jdtls.organize_imports, 'Organize Imports')
      safe_map('<leader>jr', jdtls.rename_file, 'Rename File & Imports')
      safe_map('<leader>je', jdtls.extract_variable, 'Extract Variable')
      safe_map('<leader>jE', jdtls.extract_constant, 'Extract Constant')
      safe_map('<leader>jm', jdtls.extract_method, 'Extract Method')
      safe_map('<leader>jt', jdtls.test_nearest_method, 'Test Nearest')
      safe_map('<leader>jT', jdtls.test_class, 'Test Class')
    end

    local config = {
      cmd = cmd,
      root_dir = root_dir,
      capabilities = capabilities,
      settings = {
        java = {
          -- 👇 Tell jdtls that "src" is the source root
          project = {
            sourcePaths = { 'src' },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' },
          sources = {
            organizeImports = {
              starThreshold = 999,
              staticStarThreshold = 999,
            },
          },
          configuration = { updateBuildConfiguration = 'interactive' },
          format = { enabled = false }, -- you already use google-java-format via conform.nvim
        },
      },
      init_options = { bundles = bundles },
      on_attach = on_attach,
    }

    jdtls.start_or_attach(config)
  end,
}
