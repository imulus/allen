module Allen
  class UmbracoProject < Project

    def install!
      super
      packages = Nokogiri::XML(File.read("#{settings.webroot}/packages.config"))
      umbraco  = packages.xpath("//package[@id='UmbracoCms']")

      package_name    = umbraco.xpath('@id').text
      package_version = umbraco.xpath('@version').text
      package_path    = "#{src_dir}/packages/#{package_name}.#{package_version}/UmbracoFiles"

      ['umbraco', 'umbraco_client', 'install'].map do |directory|
        File.join package_path, directory
      end.each do |directory|
        cp_r directory, settings.webroot
      end

      build!
    end

  end
end

