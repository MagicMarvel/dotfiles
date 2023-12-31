-- 单独配置java的lsp，请不要在lspconfig里面配置jstls
-- 需要 java17 和 python3.9
local status_ok, jdtls = pcall(require, 'jdtls')
if not status_ok then
    vim.api.nvim_notify("jdtls was installed fail", vim.log.levels.DEBUG, {})
    return
end

local home_dir = vim.fn.getenv("HOME")
-- 手动填写java17的路径，因为jdtls需要java17，但是项目需要java8，
-- 方便起见在这里先写死java17，项目需要哪个版本的java就update—alternate到哪个版本
local java17 = "/usr/lib/jvm/java-17-openjdk-amd64/bin/java"
-- jdtls路径，来源于mason自动安装，需要调整
local jdtls_path = home_dir .. "/.local/share/nvim/mason/packages/jdtls"
-- NOTE: 这里一定要填一个包的名字，要去mason装的jdtls下面找(具体的版本不一定是这个，要根据自己的情况改)
local jar = vim.fn.expand(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
-- 不用改
local jdtls_config = jdtls_path .. "/config_linux"
-- 自动根据项目名字生成一个文件夹名
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
-- 这里是保存每一个项目产生的配置文件的地址，随便找个地方放就行
local workspace_dir = vim.fn.expand('~' .. '/java_workspace/' .. project_name)
-- 配置插件，需要什么加什么进来
local lombok_dir = home_dir .. "/.config/nvim/dependencies/lombok.jar"

local config = {
    cmd = {
        java17,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "-Xmx2G",
        "-javaagent:" .. lombok_dir,
        -- "-Xbootclasspath/a:" .. lombok_dir,
        "-jar", jar,
        "-configuration",
        jdtls_config,
        "-data", workspace_dir,
        "--add-modules=ALL-SYSTEM ",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    },
    root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    settings = {
        java = {
            configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk-amd64"
                    },
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk-amd64",
                    },
                    -- {
                    --     name = "JavaSE-13",
                    --     path = "/usr/lib/jvm/java-13-openjdk-amd64",
                    -- },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk-amd64",
                    },
                }
            }
        }
    }
}
jdtls.start_or_attach(config)

local bufnr = 0
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
        vim.lsp.buf.format({ bufnr = bufnr })
    end,
})
