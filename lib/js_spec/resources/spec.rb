module JsSpec
  module Resources
    module Spec
      def get
        html = <<-HTML
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
        <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>JSSpec results</title>
        <link rel="stylesheet" type="text/css" href="/core/JSSpec.css" />
        <script type="text/javascript" src="/core/diff_match_patch.js"></script>
        <script type="text/javascript" src="/core/JSSpec.js"></script>
        <script type="text/javascript" src="/core/JSSpecExtensions.js"></script>
        HTML
        spec_files.each do |file|
          html << %{<script type="text/javascript" src="#{file.relative_path}"></script>\n}
        end

        html << <<-HTML
        </head>
        <body>
        <div id="js_spec_content"></div>
        </body>
        </html>
        HTML
        connection.send_head
        connection.send_body(html.gsub(/^        /, ""))
      end
    end
  end
end
