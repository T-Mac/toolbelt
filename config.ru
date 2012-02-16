$stdout.sync = true

$:.unshift File.expand_path("../web", __FILE__)

require "toolbelt_common_logger"
require "toolbelt"

use ToolbeltCommonLogger
run Toolbelt
