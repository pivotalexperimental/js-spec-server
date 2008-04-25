module JsSpec
  module Resources
    class SpecDir < ::JsSpec::Resources::Dir
      include Spec

      def spec_files
        glob("/**/*_spec.js")
      end

      def locate(name)
        if file = file(name)
          file
        elsif subdir = subdir(name)
          subdir
        elsif spec_file = spec_file(name)
          spec_file
        else
          base_path = "#{relative_path}/#{name}"
          raise "No file or directory found at #{base_path} or spec found at #{base_path}.js."
        end
      end

      def subdir(name)
        absolute_dir_path, relative_dir_path = determine_child_paths(name)
        if ::File.directory?(absolute_dir_path)
          Resources::SpecDir.new(absolute_dir_path, relative_dir_path)
        else
          nil
        end
      end

      def spec_file(name)
        absolute_file_path, relative_file_path = determine_child_paths("#{name}.js")
        if ::File.exists?(absolute_file_path) && !::File.directory?(absolute_file_path)
          Resources::SpecFile.new(absolute_file_path, relative_file_path)
        else
          nil
        end
      end
    end
  end
end