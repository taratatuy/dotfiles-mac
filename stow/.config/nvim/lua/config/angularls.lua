local util = require("lspconfig.util")

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
local TYPESCRIPT_LIB = "typescript"
local ANGULAR_LANGUAGE_SERVICE_LIB = "@angular/language-service"

local function get_project_node_modules_dir(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])

  return project_root and (project_root .. "/node_modules") or ""
end

local function get_angular_core_version(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])

  if not project_root then
    return ""
  end

  local package_json = project_root .. "/package.json"
  if not vim.loop.fs_stat(package_json) then
    return ""
  end

  local contents = io.open(package_json):read("*a")
  local json = vim.json.decode(contents)
  if not json.dependencies then
    return ""
  end

  local angular_core_version = json.dependencies["@angular/core"]

  angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

  return angular_core_version
end

local function resolve_probe_path(probe, project_node_modules_dir, global_node_modules_dir)
  local fount_in_project = vim.fs.find(probe, { path = project_node_modules_dir, upward = true })[1]
  local fount_in_global = vim.fs.find(probe, { path = global_node_modules_dir, upward = true })[1]

  return (fount_in_project and project_node_modules_dir) or (fount_in_global and global_node_modules_dir) or ""
end

local project_node_modules_dir = get_project_node_modules_dir(vim.fn.getcwd())
local global_node_modules_dir = vim.fn.trim(vim.fn.system("npm root -g"))
local ts_probe_location = resolve_probe_path(TYPESCRIPT_LIB, project_node_modules_dir, global_node_modules_dir)
local ng_probe_location =
  resolve_probe_path(ANGULAR_LANGUAGE_SERVICE_LIB, project_node_modules_dir, global_node_modules_dir)
local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

return {
  default_config = {
    cmd = {
      "ngserver",
      "--stdio",
      "--tsProbeLocations",
      ts_probe_location,
      "--ngProbeLocations",
      ng_probe_location,
      "--angularCoreVersion",
      default_angular_core_version,
    },
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
    -- Check for angular.json since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern("angular.json"),
  },
  on_new_config = function(new_config, new_root_dir)
    local new_project_node_modules_dir = get_project_node_modules_dir(new_root_dir)
    local new_global_node_modules_dir = vim.fn.trim(vim.fn.system("npm root -g"))
    local new_ts_probe_location =
      resolve_probe_path(TYPESCRIPT_LIB, new_project_node_modules_dir, new_global_node_modules_dir)
    local new_ng_probe_location =
      resolve_probe_path(ANGULAR_LANGUAGE_SERVICE_LIB, new_project_node_modules_dir, new_global_node_modules_dir)
    local angular_core_version = get_angular_core_version(new_root_dir)

    -- We need to check our probe directories because they may have changed.
    new_config.cmd = {
      vim.fn.exepath("ngserver"),
      "--stdio",
      "--tsProbeLocations",
      new_ts_probe_location,
      "--ngProbeLocations",
      new_ng_probe_location,
      "--angularCoreVersion",
      angular_core_version,
    }
  end,
  docs = {
    description = [[
https://github.com/angular/vscode-ng-language-service

`angular-language-server` can be installed via npm `npm install -g @angular/language-server`.

Note, that if you override the default `cmd`, you must also update `on_new_config` to set `new_config.cmd` during startup.

```lua
local project_library_path = "/path/to/project/lib"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}

require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
```
    ]],
  },
}
