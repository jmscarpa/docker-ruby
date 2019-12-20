Pry.config.prompt = proc do |obj, level, _|
  tenant_name = "\033[0;33m (#{tenant})\e[m" if respond_to? :tenant
  prompt = ""
  prompt << "#{Rails.version}@" if defined?(Rails)
  prompt << "#{RUBY_VERSION}"
  prompt = ""
  "#{prompt} (#{obj})> "
  "\033[1;36m#{Rails.application.class.try(:module_parent_name) || Rails.application.class.parent_name}\e[m#{tenant_name} >> "
end

if defined?(Rails) && Rails.env
  if defined?(Rails::ConsoleMethods)
    include Rails::ConsoleMethods
  else
    def reload!(print=true)
      puts "Reloading..." if print
      ActionDispatch::Reloader.cleanup!
      ActionDispatch::Reloader.prepare!
      true
    end
  end
end

Pry.config.exception_handler = proc do |output, exception, _|
  output.puts "\e[31m#{exception.class}: #{exception.message}"
  output.puts "from #{exception.backtrace.first}\e[0m"
end

begin
  require "pry-meta"

  Pry.config.print = proc do |output, value|
    Pry::Helpers::BaseHelpers
      .stagger_output("=> #{value.ai}\n", output)
  end

  Pry.commands.alias_command 'w', 'whereami'
  Pry.commands.alias_command "s", "step"
  Pry.commands.alias_command "n", "next"
  Pry.commands.alias_command "c", "continue"
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command "ex", "exit-program"

  Pry.commands.alias_command 'ff', 'frame'
  Pry.commands.alias_command 'u', 'up'
  Pry.commands.alias_command 'd', 'down'
  Pry.commands.alias_command 'b', 'break'

  puts ""
  puts "Debugging Shortcuts"
  puts 'w  :  whereami'
  puts 's  :  step'
  puts 'n  :  next'
  puts 'c  :  continue'
  puts 'f  :  finish'
  puts 'ex  :  exit-program'

  puts ""
  puts 'Stack movement'
  puts 'ff :  frame'
  puts 'u  :  up'
  puts 'd  :  down'
  puts 'b  :  break'
  puts ""
rescue LoadError => error
  warn "=> Unable to load pry-meta"
end