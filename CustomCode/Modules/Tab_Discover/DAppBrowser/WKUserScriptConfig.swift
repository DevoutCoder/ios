
import Foundation
import WebKit

struct WKUserScriptConfig {

    let address: String
    let chainId: Int
    let rpcUrl: String

    var providerScript: WKUserScript {
        let bundle = Bundle(path: Bundle.main.bundlePath)!
        let providerJsBundleUrl =  bundle.url(forResource: "onekey-min", withExtension: "js")!
        let source = try! String(contentsOf: providerJsBundleUrl)
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return script
    }

    var injectedScript: WKUserScript {
        let source =
            """
            (function() {
                var config = {
                    chainId: \(chainId),
                    rpcUrl: "\(rpcUrl)",
                    address: "\(address)",
                };
                const provider = new window.trustwallet.Provider(config);
                provider.isDebug = true;
                window.ethereum = provider;
                window.web3 = new window.trustwallet.Web3(provider);
                window.web3.eth.defaultAccount = config.address;
                window.chrome = {webstore: {}};

                window.trustwallet.customMethodMessage = {
                    personalEcRecover: {
                        postMessage: (message) => {
                            provider.sendResponse(message.id, message.object.data);
                        }
                    },
                    signMessageHash: {
                        postMessage: (message) => {
                            const id = message.id;
                            const messageHex = message.object.data;
                            const payload = message.object.params;
                            const name = "\(DAppMethod.oneKeySignMessageHex.rawValue)";
                            let object = {
                                    id: id,
                                    name: name,
                                    object: {
                                        data : messageHex,
                                        payload: payload
                                    },
                            };
                            window.webkit.messageHandlers[name].postMessage(object);
                        }
                    }
                }

            })();
            """
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return script
    }
}
