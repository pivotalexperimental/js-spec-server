module JsSpec
  class Dir < File
    def locate(name)
      if file = file(name)
        file
      else
        locate_spec_runner(name)
      end
    end

    def get
      SpecDirRunner.new(self).get
    end

    def glob(pattern)
      expanded_pattern = absolute_path + pattern
      ::Dir.glob(expanded_pattern).map do |absolute_globbed_path|
        relative_globbed_path = absolute_globbed_path.gsub(absolute_path, relative_path)
        File.new(absolute_globbed_path, relative_globbed_path)
      end
    end

    protected
    def determine_child_paths(name)
      absolute_child_path = ::File.expand_path("#{absolute_path}/#{name}")
      relative_child_path = ::File.expand_path("#{relative_path}/#{name}")
      [absolute_child_path, relative_child_path]
    end

    def locate_spec_runner(name)
      if subdir = subdir(name)
        subdir
      elsif file = file(name + '.js')
        SpecFileRunner.new(file)
      else
        raise "No specs found at #{relative_path}/#{name}."
      end
    end

    def file(name)
      absolute_file_path, relative_file_path = determine_child_paths(name)
      if ::File.exists?(absolute_file_path) && !::File.directory?(absolute_file_path)
        JsSpec::File.new(absolute_file_path, relative_file_path)
      else
        nil
      end
    end

    def subdir(name)
      absolute_dir_path, relative_dir_path = determine_child_paths(name)
      if ::File.directory?(absolute_dir_path)
        JsSpec::Dir.new(absolute_dir_path, relative_dir_path)
      else
        nil
      end
    end
  end
end