Pod::Spec.new do |s|
  s.name             = 'KAPinField'
  s.version          =  '5.0.3'
  s.summary          = 'Lightweight, highly customizable Pin Code Field library for iOS, written in Swift'
  s.homepage         = 'https://github.com/kirualex/KAPinField'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Alexis Creuzot" => "alexis.creuzot@gmail.com" }
  s.source           = { :git => "https://github.com/kirualex/KAPinField.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.source_files     = '**/KAPinField.swift'
end
