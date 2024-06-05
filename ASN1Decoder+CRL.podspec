Pod::Spec.new do |s|
  s.name         = "ASN1Decoder+CRL"
  s.version      = "1.3.3"
  s.summary      = "ASN1 DER Decoder for X.509 certificate"
  s.description  = "ASN1 DER Decoder to parse X.509 certificate"
  s.homepage     = "https://github.com/algonrey/ASN1Decoder"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Filippo Maguolo" => "maguolo.ios@outlook.com" }
  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.13"
  s.source        = { :git => "https://github.com/algonrey/ASN1Decoder.git", :tag => s.version }
  s.source_files  = "ASN1Decoder/*.swift"
  s.frameworks    = "Foundation"
  s.swift_version = '4.0'
end
