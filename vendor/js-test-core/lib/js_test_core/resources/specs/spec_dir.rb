module JsTestCore
  module Resources
    module Specs
      class SpecDirSuperclass < ::JsTestCore::Resources::Dir
        def get
          raise NotImplementedError, "#{self.class}#get needs to be implemented"
        end
      end

      class SpecDir < SpecDirSuperclass
        def spec_files
          glob("/**/*_spec.js")
        end

        route ANY do |env, name|
          if result = (file(name) || subdir(name) || spec_file(name))
            result
          else
            base_path = "#{relative_path}/#{name}"
            raise "No file or directory found at #{base_path} or spec found at #{base_path}.js."
          end
        end

        protected

        def subdir(name)
          absolute_path, relative_path = determine_child_paths(name)
          if ::File.directory?(absolute_path)
            SpecDir.new(env.merge(:absolute_path => absolute_path, :relative_path => relative_path))
          else
            nil
          end
        end

        def spec_file(name)
          absolute_path, relative_path = determine_child_paths("#{name}.js")
          if ::File.exists?(absolute_path) && !::File.directory?(absolute_path)
            SpecFile.new(env.merge(:absolute_path => absolute_path, :relative_path => relative_path))
          else
            nil
          end
        end
      end
    end
  end
end