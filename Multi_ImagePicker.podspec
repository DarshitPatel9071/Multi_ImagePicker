Pod::Spec.new do |spec|

  spec.name         = "Multi_ImagePicker"
  spec.version      = "1.0.0"
  spec.summary      = "Get Multiple asset selection"
  spec.description  = <<-DESC
                      Select multiple asset for video/images
                   DESC
  spec.homepage     = "https://github.com/DarshitPatel9071/Multi_ImagePicker"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Darshit Patel" => "" }
  spec.source       = { :git => "https://github.com/DarshitPatel9071/Multi_ImagePicker", :tag => "#{spec.version}"}
  spec.source_files  = 'MultiImagePicker_project/**/*.{swift}'
  spec.resources = "MultiImagePicker_project/**/*.{png,storyboard,xib,xcassets}"
  spec.ios.deployment_target = '12.0'
  spec.swift_versions = "5.0"
end
