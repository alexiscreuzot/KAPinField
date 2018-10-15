Pod::Spec.new do |s|
  s.name             = 'KAPinField'
  s.version          =  '1.0.0'
  s.summary          = 'Lightweight Pin Code Field library for iOS, written in Swift'
  s.homepage         = 'https://github.com/kirualex/KAPinField'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Alexis Creuzot" => "alexis.creuzot@gmail.com" }
  s.source           = { :git => "https://github.com/kirualex/KAPinField.git", :tag => s.version.to_s }
  s.platform     = :ios, '10.3'
  s.requires_arc = true
  s.source_files = '*/KAPinField.swift'
  s.swift_version = '4.2'
end
