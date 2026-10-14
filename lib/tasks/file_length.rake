# Finds the code files that outgrew the length the style guide allows.
module FileLength
  # The longest a code file may be, blank and comment lines counted.
  MAX = 120

  # The code we write, as opposed to prose, markup and data.
  CODE = /\.(js|rake|rb)\z/

  # Vendored code, generated binstubs, migrations and tests.
  EXEMPT = %r{\Adb/(migrate|schema\.rb)|\A(bin|node_modules|public|test|vendor)/}

  # Every tracked code file over the limit, with its length, longest first.
  def self.offenders
    tracked = `git ls-files`.split("\n")
    tracked.grep(CODE).reject { |path| path.match? EXEMPT }
      .map { |path| [path, File.readlines(path).size] }
      .select { |_path, lines| lines > MAX }
      .sort_by { |_path, lines| -lines }
  end
end

desc 'Fail when a tracked code file runs longer than 120 lines'
task :file_length do
  offenders = FileLength.offenders
  offenders.each { |path, lines| puts "#{path}: #{lines} lines" }
  abort "#{offenders.size} file(s) over #{FileLength::MAX} lines" if offenders.any?
  puts "No tracked code file over #{FileLength::MAX} lines"
end
