class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    "#{ENV['CMP_RUBY_API_BASE_PATH']}/swagger_docs/#{path}"
  end
end
Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/swagger_docs",
    # the URL base path to your API
    :base_path => "#{ENV['CMP_RUBY_API_API_PATH']}",
    # if you want to delete all .json files at each generation
    :base_api_controller => "Api::ApiController",
    :clean_directory => true,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "USAGov Platform API Interactive Documentation",
        "description" => "This is documentation for the <a href=\"https://www.usa.gov/explore\">USAGov</a> Platform API. In addition to this interactive documentation, we also have information on how to use the API available on <a href=\"https://github.com/usagov/USAGov-Platform-API-Documentation/wiki\">GitHub</a>."
        #"termsOfServiceUrl" => "http://www.usa.gov",
        #"contact" => "cmp@usa.gov",
        #"license" => "MIT License",
        #"licenseUrl" => "http://opensource.org/licenses/MIT"
      }
    }
  }
})
