# ASN1Decoder+CRL
ASN1 DER Decoder for X.509 Certificate

In this fork from the filom version, we add support for Objective-C and also get dates expiration dates from CRL files.

## Requirements

- iOS 9.0+ | macOS 10.10+
- Xcode 9

## Integration

#### CocoaPods (iOS 9+, OS X 10.10+)

You can use [CocoaPods](http://cocoapods.org/) to install `ASN1Decoder+CRL` by adding it to your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
	pod 'ASN1Decoder+CRL'
end
```

#### Swift Package Manager

Go to XCode --> File --> Add Package Dependencies --> In serach enter --> https://github.com/algonrey/ASN1Decoder

Now add this dependency in your Target.

## Usage

### Parse a DER/PEM X.509 certificate

``` swift
import ASN1Decoder_CRL

do {
    let x509 = try X509Certificate(data: certData)

    let subject = x509.subjectDistinguishedName ?? ""

} catch {
    print(error)
}
```



### Usage for SSL pinning

Define a delegate for URLSession

``` swift
import Security
import ASN1Decoder_CRL

class PinningURLSessionDelegate: NSObject, URLSessionDelegate {

    var publicKeyHexEncoded: String!

    public init(publicKeyHexEncoded: String) {
        self.publicKeyHexEncoded = publicKeyHexEncoded.uppercased()
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {

        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)

                if status == errSecSuccess {

                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {

                        let serverCertificateCFData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateCFData)
                        let size = CFDataGetLength(serverCertificateCFData)
                        let certData = NSData(bytes: data, length: size)

                        do {
                            let x509cert = try X509Certificate(data: certData as Data)

                            if let pk = x509cert.publicKey?.key {

                                let serverPkHexEncoded = dataToHexString(pk)

                                if publicKeyHexEncoded == serverPkHexEncoded {
                                    completionHandler(.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }

                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }

        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    func dataToHexString(_ data: Data) -> String {
        return data.map { String(format: "%02X", $0) }.joined()
    }
}
```


Then create a URLSession and use it as usual

``` swift
let publicKeyHexEncoded = "..." // your HTTPS certifcate public key

let session = URLSession(
                configuration: URLSessionConfiguration.ephemeral,
                delegate: PinningURLSessionDelegate(publicKeyHexEncoded: publicKeyHexEncoded),
                delegateQueue: nil)
```


To extract the public key from your certificate with openssl use this command line

```
openssl x509 -modulus -noout < certificate.cer
```


### How to use for AppStore receipt parse

``` swift
import ASN1Decoder_CRL

if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

    do {
        let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)

        let pkcs7 = try PKCS7(data: receiptData)

        if let receiptInfo = pkcs7.receipt() {
            print(receiptInfo.originalApplicationVersion)
        }

    } catch {
        print(error)
    }
}
```
