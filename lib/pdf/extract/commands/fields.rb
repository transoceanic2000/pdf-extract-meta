command :fields do |c|

  STDOUT.sync = true

  c.syntax = "pdf-extract fields <path>"

  c.action do |args, options|
    path = args.pop
    say_error "Unspecified file" and abort if !path

    pdf = PDF::Extract::Document.new(path: path)
    data = pdf.fields.map { |f| f.as_json }
    puts Oj.dump(data)
  end

end
