require "commander/import"

program :description, "Extract data from PDF files"
program :help_formatter, :compact
program :version, PDF::Extract::VERSION

global_option("-v", "--verbose") { $verbose = true }

default_command :extract
