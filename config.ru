$stdout.sync = true

$:.unshift File.expand_path("../web", __FILE__)
require "toolbelt"
run Toolbelt
