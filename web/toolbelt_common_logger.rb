class ToolbeltCommonLogger

  FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %s %0.4f\n}

  def initialize(app)
    @app = app
  end

  def call(env)
    began_at = Time.now
    status, headers, body = @app.call(env)
    ended_at = Time.now

    header_hash = Rack::Utils::HeaderHash.new(headers)
    length = extract_content_length(header_hash)

    puts FORMAT % [
      env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
      env["REMOTE_USER"] || "-",
      ended_at.strftime("%d/%b/%Y %H:%M:%S"),
      env["REQUEST_METHOD"],
      env["PATH_INFO"],
      env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"],
      env["HTTP_VERSION"],
      status.to_s[0..3],
      length,
      ended_at - began_at
    ]

    [status, headers, body]
  end

private

  def extract_content_length(headers)
    value = headers['Content-Length'] or return '-'
    value.to_s == '0' ? '-' : value
  end

end
