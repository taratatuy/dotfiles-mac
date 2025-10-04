return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")

      -- Root directory detection
      local root_markers = { "gradlew", "mvnw", ".git" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == nil then
        return -- not a Java project
      end

      local home = os.getenv("HOME")
      local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration",
          jdtls_path .. "/config_mac", -- << macOS here
          "-data",
          workspace_dir,
        },

        root_dir = root_dir,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      -- Start or attach jdtls
      jdtls.start_or_attach(config)

      -- Optional Java-specific keymaps
      local opts = { buffer = true }
      -- vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
      -- vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)
      -- vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts)
    end,
  },
}
