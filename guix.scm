(use-modules (gnu)
             (gnu packages protobuf)
             (gnu packages crates-apple)
             (gnu packages crates-crypto)
             (gnu packages crates-io)
             (gnu packages crates-tls)
             (gnu packages crates-web)
             (gnu packages crates-windows)
             (gnu packages rust)
             (guix build-system cargo)
             (guix download)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (guix utils)
             (ice-9 match)
             (srfi srfi-1))

(define-public rust-mio-aio-0.8
  (package
    (inherit rust-mio-aio-0.7)
    (name "rust-mio-aio")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mio-aio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ynga39vd3r7i3bjqsiv8b6b9z8ympby88l7vkk5cvhp6kn3livj"))))))

(define-public rust-tokio-1.36
  (package
    (inherit rust-tokio-1)
    (name "rust-tokio")
    (version "1.36.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0c89p36zbd4abr1z3l5mipp43x7z4c9b4vp4s6r8y0gs2mjmya31"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-tokio-1)
       ((#:cargo-inputs original-inputs)
        (assoc-set! original-inputs
                    "rust-mio-aio"
                    `(,rust-mio-aio-0.8)))))))

(define-public rust-h2-0.3.24
  (package
    (inherit rust-h2-0.3)
    (name "rust-h2")
    (version "0.3.24")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "h2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jf9488b66nayxzp3iw3b2rb64y49hdbbywnv9wfwrsv14i48b5v"))))))

(define-public rust-tonic-0.11
  (package
    (inherit rust-tonic-0.10)
    (name "rust-tonic")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tonic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04qsr527i256i3dk9dp1g2jr42q7yl91y5h06rvd9ycy9rxfpi3n"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-tonic-0.10)
       ((#:cargo-inputs original-inputs)
        (fold (lambda (replacement inputs)
                (match replacement
                  ((name gexp)
                   (assoc-set! inputs name (list gexp)))))
              original-inputs
              `(("rust-h2" ,rust-h2-0.3.24)
                ("rustls-native-certs" ,rust-rustls-native-certs-0.7)
                ("rust-tokio-rustls" ,rust-tokio-rustls-0.25)
                ("rust-webpki-roots" ,rust-webpki-roots-0.26)
                ("rust-zstd" ,rust-zstd-0.12))))))))

(define-public rust-tonic-build-0.11
  (package
    (inherit rust-tonic-build-0.10)
    (name "rust-tonic-build")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tonic-build" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hm99ckaw0pzq8h22bdjy6gpbg06kpvs0f73nj60f456f3fzckmy"))))))
(define-public rust-libp2p-mplex-0.41
  (package
    (name "rust-libp2p-mplex")
    (version "0.41.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-mplex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "095901lmd66qs7zxwbxzh3zx3nl68snbfz2zn8bh5qr7brv9bs55"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.7))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Mplex multiplexing protocol for libp2p")
    (description "Mplex multiplexing protocol for libp2p")
    (license license:expat)))

(define-public rust-yamux-0.13
  (package
    (name "rust-yamux")
    (version "0.13.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yamux" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00lhri6k2z63p3470yva2slibgfsxjcywjwrf9z0804kp14027dd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-static-assertions" ,rust-static-assertions-1))))
    (home-page "https://github.com/paritytech/yamux")
    (synopsis "Multiplexer over reliable, ordered connections")
    (description "Multiplexer over reliable, ordered connections")
    (license (list license:asl2.0 license:expat))))

(define-public rust-nohash-hasher-0.2
  (package
    (name "rust-nohash-hasher")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nohash-hasher" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lf4p6k01w4wm7zn4grnihzj8s7zd5qczjmzng7wviwxawih5x9b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/paritytech/nohash-hasher")
    (synopsis
     "An implementation of `std::hash::Hasher` which does not hash at all.")
    (description
     "An implementation of `std::hash::Hasher` which does not hash at all.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-yamux-0.12
  (package
    (name "rust-yamux")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yamux" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xmpsk686lh8x2b0331xd69mifvy321g1a8994adrwhrwr51dl4y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-static-assertions" ,rust-static-assertions-1))))
    (home-page "https://github.com/paritytech/yamux")
    (synopsis "Multiplexer over reliable, ordered connections")
    (description "Multiplexer over reliable, ordered connections")
    (license (list license:asl2.0 license:expat))))

(define-public rust-libp2p-yamux-0.45
  (package
    (name "rust-libp2p-yamux")
    (version "0.45.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-yamux" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rbi9d1n6jnjz0ddwn9r1af9pmxyfwfl62ym4w4pci4s6i8bw310"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-yamux" ,rust-yamux-0.12)
                       ("rust-yamux" ,rust-yamux-0.13))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Yamux multiplexing protocol for libp2p")
    (description "Yamux multiplexing protocol for libp2p")
    (license license:expat)))

(define-public rust-libp2p-webtransport-websys-0.2
  (package
    (name "rust-libp2p-webtransport-websys")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-webtransport-websys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09yn962wwvqcp6d84r22f73d484siva2skryvyrvvv9v3rl662w4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-noise" ,rust-libp2p-noise-0.44)
                       ("rust-multiaddr" ,rust-multiaddr-0.18)
                       ("rust-multihash" ,rust-multihash-0.19)
                       ("rust-send-wrapper" ,rust-send-wrapper-0.6)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "WebTransport for libp2p under WASM environment")
    (description "@code{WebTransport} for libp2p under WASM environment")
    (license license:expat)))

(define-public rust-libp2p-websocket-websys-0.3
  (package
    (name "rust-libp2p-websocket-websys")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-websocket-websys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vxzall4c7bcsnqnhdwmc5k8xzjy3wfq6r6mknz75mcwrj6mf3jm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-send-wrapper" ,rust-send-wrapper-0.6)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "WebSocket for libp2p under WASM environment")
    (description "@code{WebSocket} for libp2p under WASM environment")
    (license license:expat)))

(define-public rust-soketto-0.7
  (package
    (name "rust-soketto")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "soketto" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hkf17swk2a7rdj0rxbwwg53p2zpy9274b1w719rdq1rbqqcbla1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-sha-1" ,rust-sha-1-0.9))))
    (home-page "https://github.com/paritytech/soketto")
    (synopsis "A websocket protocol implementation.")
    (description "This package provides a websocket protocol implementation.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-libp2p-websocket-0.43
  (package
    (name "rust-libp2p-websocket")
    (version "0.43.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-websocket" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0phs8cb3qh2nprqmbipsqsx4zp9hp9a3f719ckhq10fhmx8nv17l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-rustls" ,rust-futures-rustls-0.24)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rw-stream-sink" ,rust-rw-stream-sink-0.4)
                       ("rust-soketto" ,rust-soketto-0.7)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-url" ,rust-url-2)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.25))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "WebSocket transport for libp2p")
    (description "@code{WebSocket} transport for libp2p")
    (license license:expat)))

(define-public rust-http-client-6
  (package
    (name "rust-http-client")
    (version "6.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "http-client" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19g19jli98cd0ywrzcsbw5j34rypm8n43yszxa3gaaqyr46m2iqr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-h1" ,rust-async-h1-2)
                       ("rust-async-native-tls" ,rust-async-native-tls-0.3)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-async-tls" ,rust-async-tls-0.10)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-dashmap" ,rust-dashmap-5)
                       ("rust-deadpool" ,rust-deadpool-0.7)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http-types" ,rust-http-types-2)
                       ("rust-hyper" ,rust-hyper-0.13)
                       ("rust-hyper-tls" ,rust-hyper-tls-0.4)
                       ("rust-isahc" ,rust-isahc-0.9)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustls" ,rust-rustls-0.18)
                       ("rust-tokio" ,rust-tokio-0.2)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/http-rs/http-client")
    (synopsis "Types and traits for http clients.")
    (description "Types and traits for http clients.")
    (license (list license:expat license:asl2.0))))

(define-public rust-surf-2
  (package
    (name "rust-surf")
    (version "2.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "surf" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mwd0fj0pcdd1q3qp4r045znf0gnvsq1s0pzxlnrhl83npk1m2vi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-native-tls" ,rust-async-native-tls-0.3)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-http-client" ,rust-http-client-6)
                       ("rust-http-types" ,rust-http-types-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rustls" ,rust-rustls-0.18)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/http-rs/surf")
    (synopsis "Surf the web - HTTP client framework")
    (description "Surf the web - HTTP client framework")
    (license (list license:expat license:asl2.0))))

(define-public rust-attohttpc-0.24
  (package
    (name "rust-attohttpc")
    (version "0.24.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "attohttpc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18mj9g4xsxkmagykszmwpmqcddn23ikipf8ip7h9wx4snzw9p6ld"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-encoding-rs-io" ,rust-encoding-rs-io-0.1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-multipart" ,rust-multipart-0.18)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-rustls" ,rust-rustls-0.20)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-url" ,rust-url-2)
                       ("rust-webpki" ,rust-webpki-0.22)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22))))
    (home-page "https://github.com/sbstp/attohttpc")
    (synopsis "Small and lightweight HTTP client")
    (description "Small and lightweight HTTP client")
    (license license:mpl2.0)))

(define-public rust-igd-next-0.14
  (package
    (name "rust-igd-next")
    (version "0.14.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "igd-next" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r29bzibllsjas8qgcd22j8hva55fn4av7mkwy210m0dq7z90k86"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-attohttpc" ,rust-attohttpc-0.24)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-surf" ,rust-surf-2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-url" ,rust-url-2)
                       ("rust-xmltree" ,rust-xmltree-0.10))))
    (home-page "https://github.com/dariusc93/rust-igd")
    (synopsis "Internet Gateway Protocol client")
    (description "Internet Gateway Protocol client")
    (license license:expat)))

(define-public rust-libp2p-upnp-0.2
  (package
    (name "rust-libp2p-upnp")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-upnp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0d9xvbs3siah77a6mrwkzqiqqd9jq7i4zkcpja30c3mz96cwi75l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-igd-next" ,rust-igd-next-0.14)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "UPnP support for libp2p transports")
    (description "U@code{PnP} support for libp2p transports")
    (license license:expat)))

(define-public rust-libp2p-uds-0.40
  (package
    (name "rust-libp2p-uds")
    (version "0.40.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-uds" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gyq77q2hfikfk3wagrlvhp48wb9rkjjzr8cqxw8cqaghkj32rgf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Unix domain sockets transport for libp2p")
    (description "Unix domain sockets transport for libp2p")
    (license license:expat)))

(define-public rust-libp2p-tcp-0.41
  (package
    (name "rust-libp2p-tcp")
    (version "0.41.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-tcp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0k4xaag2rga984bgnx7k86g5gr4nnamc3jwyz7grm4a84zy6094b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-io" ,rust-async-io-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-if-watch" ,rust-if-watch-3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "TCP/IP transport protocol for libp2p")
    (description "TCP/IP transport protocol for libp2p")
    (license license:expat)))

(define-public rust-bimap-0.6
  (package
    (name "rust-bimap")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bimap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xx4dns6hj0mf1sl47lh3r0z4jcvmhqhsr7qacjs69d3lqf5y313"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/billyrieger/bimap-rs/")
    (synopsis "Bijective maps")
    (description "Bijective maps")
    (license (list license:asl2.0 license:expat))))

(define-public rust-libp2p-rendezvous-0.14
  (package
    (name "rust-libp2p-rendezvous")
    (version "0.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-rendezvous" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11b3rcf3jxh2j3fk19v4dqapjh3j68d0iaj8rcdpfsgm2r5492hn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bimap" ,rust-bimap-0.6)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-request-response" ,rust-libp2p-request-response-0.26)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Rendezvous protocol for libp2p")
    (description "Rendezvous protocol for libp2p")
    (license license:expat)))

(define-public rust-futures-rustls-0.24
  (package
    (name "rust-futures-rustls")
    (version "0.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "futures-rustls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a1acak02s42wh6qjmjyviscc5j77qsh1qrqd023hdqqikv3rg9m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-rustls" ,rust-rustls-0.21))))
    (home-page "https://github.com/quininer/futures-rustls")
    (synopsis "Asynchronous TLS/SSL streams for futures using Rustls.")
    (description "Asynchronous TLS/SSL streams for futures using Rustls.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libp2p-tls-0.3
  (package
    (name "rust-libp2p-tls")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-tls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19875g82jg6zfnp9x7wydvwjywl1g4arbiwfs22xcsbm5qy7xklk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-rustls" ,rust-futures-rustls-0.24)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-rcgen" ,rust-rcgen-0.11)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-webpki" ,rust-rustls-webpki-0.101)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-x509-parser" ,rust-x509-parser-0.15)
                       ("rust-yasna" ,rust-yasna-0.5))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "TLS configuration based on libp2p TLS specs.")
    (description "TLS configuration based on libp2p TLS specs.")
    (license license:expat)))

(define-public rust-libp2p-quic-0.10
  (package
    (name "rust-libp2p-quic")
    (version "0.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-quic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rk6bvzp38wlqbqhr91k1mvyv2mp4nvgvw7i7qqppd2pxvgmqdx0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-if-watch" ,rust-if-watch-3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-tls" ,rust-libp2p-tls-0.3)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-quinn" ,rust-quinn-0.10)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "TLS based QUIC transport implementation for libp2p")
    (description "TLS based QUIC transport implementation for libp2p")
    (license license:expat)))

(define-public rust-libp2p-pnet-0.24
  (package
    (name "rust-libp2p-pnet")
    (version "0.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-pnet" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06l1s6r7g6sn7fbz40pzdzv1y8b1mlq2vfd3y2xb0r1h261cnbdg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-salsa20" ,rust-salsa20-0.10)
                       ("rust-sha3" ,rust-sha3-0.10)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Private swarm support for libp2p")
    (description "Private swarm support for libp2p")
    (license license:expat)))

(define-public rust-libp2p-plaintext-0.41
  (package
    (name "rust-libp2p-plaintext")
    (version "0.41.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-plaintext" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gqbb4c679b0jqrgn0539z3h9bdprw9ijma2dms7w8b71gs0lcv7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.2)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Plaintext encryption dummy protocol for libp2p")
    (description "Plaintext encryption dummy protocol for libp2p")
    (license license:expat)))

(define-public rust-x25519-dalek-2
  (package
    (name "rust-x25519-dalek")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "x25519-dalek" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xyjgqpsa0q6pprakdp58q1hy45rf8wnqqscgzx0gyw13hr6ir67"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-curve25519-dalek" ,rust-curve25519-dalek-4)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis
     "X25519 elliptic curve Diffie-Hellman key exchange in pure-Rust, using curve25519-dalek.")
    (description
     "X25519 elliptic curve Diffie-Hellman key exchange in pure-Rust, using
curve25519-dalek.")
    (license license:bsd-3)))

(define-public rust-libsodium-sys-0.2
  (package
    (name "rust-libsodium-sys")
    (version "0.2.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libsodium-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zcjka23grayr8kjrgbada6vwagp0kkni9m45v0gpbanrn3r6xvb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/sodiumoxide/sodiumoxide.git")
    (synopsis "FFI binding to libsodium")
    (description "FFI binding to libsodium")
    (license (list license:expat license:asl2.0))))

(define-public rust-sodiumoxide-0.2
  (package
    (name "rust-sodiumoxide")
    (version "0.2.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sodiumoxide" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a00rcp2vphrs8qh0477rzs6lhsng1m5i0l4qamagnf2nsnf6sz2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ed25519" ,rust-ed25519-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libsodium-sys" ,rust-libsodium-sys-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/sodiumoxide/sodiumoxide")
    (synopsis "Fast cryptographic library for Rust (bindings to libsodium)")
    (description "Fast cryptographic library for Rust (bindings to libsodium)")
    (license (list license:expat license:asl2.0))))

(define-public rust-pqcrypto-traits-0.3
  (package
    (name "rust-pqcrypto-traits")
    (version "0.3.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pqcrypto-traits" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fsigdrjrwkyc00da0y2z1n626lnak268wfjsxl9xvafcp3m3s4l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rustpq/")
    (synopsis "Shared traits for post-quantum cryptographic primitives")
    (description "Shared traits for post-quantum cryptographic primitives")
    (license (list license:expat license:asl2.0))))

(define-public rust-pqcrypto-internals-0.2
  (package
    (name "rust-pqcrypto-internals")
    (version "0.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pqcrypto-internals" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ipv96543y0g71qkwzir0cigl7rd565vcj3pvvk868mydbn4plyr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-dunce" ,rust-dunce-1)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "bindings to common cryptography")
    (description "bindings to common cryptography")
    (license (list license:expat license:asl2.0))))

(define-public rust-pqcrypto-kyber-0.8
  (package
    (name "rust-pqcrypto-kyber")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pqcrypto-kyber" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00503fds71zjqzyp6g162avrmmjg0n456ibiqz85k249ry9h5h0m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pqcrypto-internals" ,rust-pqcrypto-internals-0.2)
                       ("rust-pqcrypto-traits" ,rust-pqcrypto-traits-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-big-array" ,rust-serde-big-array-0.5))))
    (home-page "https://github.com/rustpq/")
    (synopsis "Post-Quantum Key-Encapsulation Mechanism kyber")
    (description "Post-Quantum Key-Encapsulation Mechanism kyber")
    (license (list license:expat license:asl2.0))))

(define-public rust-chacha20poly1305-0.10
  (package
    (name "rust-chacha20poly1305")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chacha20poly1305" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dfwq9ag7x7lnd0znafpcn8h7k4nfr9gkzm0w7sc1lcj451pkk8h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.5)
                       ("rust-chacha20" ,rust-chacha20-0.9)
                       ("rust-cipher" ,rust-cipher-0.4)
                       ("rust-poly1305" ,rust-poly1305-0.8)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page
     "https://github.com/RustCrypto/AEADs/tree/master/chacha20poly1305")
    (synopsis
     "Pure Rust implementation of the ChaCha20Poly1305 Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration. Also contains implementations of the XChaCha20Poly1305
extended nonce variant of ChaCha20Poly1305, and the reduced-round
ChaCha8Poly1305 and ChaCha12Poly1305 lightweight variants.
")
    (description
     "Pure Rust implementation of the @code{ChaCha20Poly1305} Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration.  Also contains implementations of the
X@code{ChaCha20Poly1305} extended nonce variant of @code{ChaCha20Poly1305}, and
the reduced-round @code{ChaCha8Poly1305} and @code{ChaCha12Poly1305} lightweight
variants.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-snow-0.9
  (package
    (name "rust-snow")
    (version "0.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "snow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "119g3wk6pw27h7yj3dn3nim6f2fiqjny23w6mfw17rv8w2z4h2c5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aes-gcm" ,rust-aes-gcm-0.10)
                       ("rust-blake2" ,rust-blake2-0.10)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chacha20poly1305" ,rust-chacha20poly1305-0.10)
                       ("rust-curve25519-dalek" ,rust-curve25519-dalek-4)
                       ("rust-pqcrypto-kyber" ,rust-pqcrypto-kyber-0.8)
                       ("rust-pqcrypto-traits" ,rust-pqcrypto-traits-0.3)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-ring" ,rust-ring-0.17)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-sodiumoxide" ,rust-sodiumoxide-0.2)
                       ("rust-subtle" ,rust-subtle-2))))
    (home-page "https://github.com/mcginty/snow")
    (synopsis "A pure-rust implementation of the Noise Protocol Framework")
    (description
     "This package provides a pure-rust implementation of the Noise Protocol Framework")
    (license (list license:asl2.0 license:expat))))

(define-public rust-libp2p-noise-0.44
  (package
    (name "rust-libp2p-noise")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-noise" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14sps0mqqdaasg8al2iqnj9jd57ys3l7djsb8fjnwzq7rr2hbkcf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-curve25519-dalek" ,rust-curve25519-dalek-4)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-multiaddr" ,rust-multiaddr-0.18)
                       ("rust-multihash" ,rust-multihash-0.19)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-snow" ,rust-snow-0.9)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-x25519-dalek" ,rust-x25519-dalek-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Cryptographic handshake protocol using the noise framework.")
    (description "Cryptographic handshake protocol using the noise framework.")
    (license license:expat)))

(define-public rust-libp2p-relay-0.17
  (package
    (name "rust-libp2p-relay")
    (version "0.17.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-relay" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17cd3ikm0pnl2cc9idsdxbr71wvvq07wz3f4p7radqf8zw9v5b8a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-bounded" ,rust-futures-bounded-0.2)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.3)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Communications relaying for libp2p")
    (description "Communications relaying for libp2p")
    (license license:expat)))

(define-public rust-libp2p-ping-0.44
  (package
    (name "rust-libp2p-ping")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-ping" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qkwikzgpgwchc9pkg3rzqkdx67b8lg8a2769wcr9hnq3gj4xfbn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Ping protocol for libp2p")
    (description "Ping protocol for libp2p")
    (license license:expat)))

(define-public rust-libp2p-metrics-0.14
  (package
    (name "rust-libp2p-metrics")
    (version "0.14.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-metrics" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mrk5mlzg4mgi5wj5vpj9pw33j9h52d06336nailc4199yp93b7x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-dcutr" ,rust-libp2p-dcutr-0.11)
                       ("rust-libp2p-gossipsub" ,rust-libp2p-gossipsub-0.46)
                       ("rust-libp2p-identify" ,rust-libp2p-identify-0.44)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-kad" ,rust-libp2p-kad-0.45)
                       ("rust-libp2p-ping" ,rust-libp2p-ping-0.44)
                       ("rust-libp2p-relay" ,rust-libp2p-relay-0.17)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-prometheus-client" ,rust-prometheus-client-0.22))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Metrics for libp2p")
    (description "Metrics for libp2p")
    (license license:expat)))

(define-public rust-sysinfo-0.29
  (package
    (name "rust-sysinfo")
    (version "0.29.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sysinfo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rp6911qqjppvvbh72j27znscrawfvplqlyrj9n0y1n24g27ywnd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-core-foundation-sys" ,rust-core-foundation-sys-0.8)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-ntapi" ,rust-ntapi-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/GuillaumeGomez/sysinfo")
    (synopsis
     "Library to get system information such as processes, CPUs, disks, components and networks")
    (description
     "Library to get system information such as processes, CPUs, disks, components and
networks")
    (license license:expat)))

(define-public rust-memory-stats-1
  (package
    (name "rust-memory-stats")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memory-stats" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k5amihbjv30wbz2z2kcqp9gh4hr7wka3k9s952rap2cjvwrrxrl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/Arc-blroth/memory-stats")
    (synopsis "A cross-platform memory profiler for Rust.")
    (description
     "This package provides a cross-platform memory profiler for Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libp2p-memory-connection-limits-0.2
  (package
    (name "rust-libp2p-memory-connection-limits")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-memory-connection-limits" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14wj9bm0p9kmd5rzk2h741nnr1366ms165pk2ncim0i4l8lw8gpn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-memory-stats" ,rust-memory-stats-1)
                       ("rust-sysinfo" ,rust-sysinfo-0.29)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Memory usage based connection limits for libp2p.")
    (description "Memory usage based connection limits for libp2p.")
    (license license:expat)))

(define-public rust-windows-interface-0.51
  (package
    (name "rust-windows-interface")
    (version "0.51.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-interface" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xps1k3ii3cdiniv896mgcv3mbmm787gl4937m008k763hzfcih5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The interface macro for the windows crate")
    (description "The interface macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-implement-0.51
  (package
    (name "rust-windows-implement")
    (version "0.51.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-implement" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mg5q1rzfix05xvl4fhmp5b6azm8a0pn4dk8hkc21by5zs71aazv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The implement macro for the windows crate")
    (description "The implement macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-msvc-0.48
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f4mdp895kkjh9zv8dxvn4pc10xr7839lf5pa9l0193i2pkgr57d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnullvm-0.48
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_gnullvm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k24810wfbgz8k48c2yknqjmiigmql6kk3knmddkv8k8g1v54yqb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnu-0.48
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_gnu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13kiqqcvz2vnyxzydjh73hwgigsdr2z1xpzx313kxll34nyhmm2k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-msvc-0.48
  (package
    (name "rust-windows-i686-msvc")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_i686_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01m4rik437dl9rdf0ndnm2syh10hizvq0dajdkv2fjqcywrw4mcg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-gnu-0.48
  (package
    (name "rust-windows-i686-gnu")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_i686_gnu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gklnglwd9ilqx7ac3cn8hbhkraqisd0n83jxzf9837nvvkiand7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-msvc-0.48
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_aarch64_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1g5l4ry968p73g6bg6jgyvy9lb8fyhcs54067yzxpcpkf44k2dfw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-gnullvm-0.48
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_aarch64_gnullvm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1n05v7qblg1ci3i567inc7xrkmywczxrs1z3lj3rkkxw18py6f1b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-targets-0.48
  (package
    (name "rust-windows-targets")
    (version "0.48.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-targets" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "034ljxqshifs1lan89xwpcy1hp0lhdh4b5n0d2z4fwjx2piacbws"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.48)
                       ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.48)
                       ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.48)
                       ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.48)
                       ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.48)
                       ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.48)
                       ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import libs for Windows")
    (description "Import libs for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-core-0.51
  (package
    (name "rust-windows-core")
    (version "0.51.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r1f57hsshsghjyc7ypp2s0i78f7b1vr93w68sdb8baxyf2czy7i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-0.51
  (package
    (name "rust-windows")
    (version "0.51.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ja500kr2pdvz9lxqmcr7zclnnwpvw28z78ypkrc4f7fqlb9j8na"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-core" ,rust-windows-core-0.51)
                       ("rust-windows-implement" ,rust-windows-implement-0.51)
                       ("rust-windows-interface" ,rust-windows-interface-0.51)
                       ("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-netlink-proto-0.10
  (package
    (name "rust-netlink-proto")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "netlink-proto" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19is4avr4l5hkm7nn1wwm22m999bsmv221ljq01lfhmbi52b3d35"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-netlink-packet-core" ,rust-netlink-packet-core-0.4)
                       ("rust-netlink-sys" ,rust-netlink-sys-0.8)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/rust-netlink/netlink-proto")
    (synopsis "async netlink protocol")
    (description "async netlink protocol")
    (license license:expat)))

(define-public rust-netlink-packet-core-0.4
  (package
    (name "rust-netlink-packet-core")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "netlink-packet-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15qj97azqrkrkmp2w5cfwxhd16b6hmb8rs33csca4wafpnsqlnrl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-netlink-packet-utils" ,rust-netlink-packet-utils-0.5))))
    (home-page "https://github.com/rust-netlink/netlink-packet-core")
    (synopsis "netlink packet types")
    (description "netlink packet types")
    (license license:expat)))

(define-public rust-netlink-packet-route-0.12
  (package
    (name "rust-netlink-packet-route")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "netlink-packet-route" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1azs9rkzv56gnqdkfdm1bv4673k8ldg256924j47m6kmp4147snr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-netlink-packet-core" ,rust-netlink-packet-core-0.4)
                       ("rust-netlink-packet-utils" ,rust-netlink-packet-utils-0.5))))
    (home-page "https://github.com/rust-netlink/netlink-packet-route")
    (synopsis "netlink packet types")
    (description "netlink packet types")
    (license license:expat)))

(define-public rust-rtnetlink-0.10
  (package
    (name "rust-rtnetlink")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rtnetlink" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1839yijva206a46vv9ba6lyh8fnyj60db0bkqbqri1m1fvym6b1j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-global-executor" ,rust-async-global-executor-2)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-netlink-packet-route" ,rust-netlink-packet-route-0.12)
                       ("rust-netlink-proto" ,rust-netlink-proto-0.10)
                       ("rust-nix" ,rust-nix-0.24)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/rust-netlink/rtnetlink")
    (synopsis "manipulate linux networking resources via netlink")
    (description "manipulate linux networking resources via netlink")
    (license license:expat)))

(define-public rust-if-addrs-0.10
  (package
    (name "rust-if-addrs")
    (version "0.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "if-addrs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02lgvpz14a7qx3s704i18xf3dp6ywniwij8mzy0kfr0sslch1fya"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/messense/if-addrs")
    (synopsis "Return interface IP addresses on Posix and windows systems")
    (description "Return interface IP addresses on Posix and windows systems")
    (license (list license:expat license:bsd-3))))

(define-public rust-if-watch-3
  (package
    (name "rust-if-watch")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "if-watch" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07kyvhha4l41gg4a79vli0ksyg34mq22xi4w2sbhxknphqn45c6n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-io" ,rust-async-io-2)
                       ("rust-core-foundation" ,rust-core-foundation-0.9)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-if-addrs" ,rust-if-addrs-0.10)
                       ("rust-ipnet" ,rust-ipnet-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rtnetlink" ,rust-rtnetlink-0.10)
                       ("rust-smol" ,rust-smol-1)
                       ("rust-system-configuration" ,rust-system-configuration-0.5)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-windows" ,rust-windows-0.51))))
    (home-page "https://github.com/mxinden/if-watch")
    (synopsis "crossplatform asynchronous network watcher")
    (description "crossplatform asynchronous network watcher")
    (license (list license:expat license:asl2.0))))

(define-public rust-libp2p-mdns-0.45
  (package
    (name "rust-libp2p-mdns")
    (version "0.45.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-mdns" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wpssw16iwnkq8z1k4fhnw0d68xzbp06fkdwxrz1sglv6fd7s029"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-io" ,rust-async-io-2)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-hickory-proto" ,rust-hickory-proto-0.24)
                       ("rust-if-watch" ,rust-if-watch-3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Implementation of the libp2p mDNS discovery method")
    (description "Implementation of the libp2p @code{mDNS} discovery method")
    (license license:expat)))

(define-public rust-libp2p-kad-0.45
  (package
    (name "rust-libp2p-kad")
    (version "0.45.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-kad" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1lls7x13hga67g1ykk42iq08ir7hk34i5n2dqzmc8qnh4xvpdiaw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-bounded" ,rust-futures-bounded-0.2)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.3)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-uint" ,rust-uint-0.9)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Kademlia protocol for libp2p")
    (description "Kademlia protocol for libp2p")
    (license license:expat)))

(define-public rust-libp2p-identify-0.44
  (package
    (name "rust-libp2p-identify")
    (version "0.44.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-identify" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09k11y38z7d2cmzrrqg35q6kf3rci543i6r6qvyj20igbna9lj90"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-bounded" ,rust-futures-bounded-0.2)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-lru" ,rust-lru-0.12)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.3)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Nodes identifcation protocol for libp2p")
    (description "Nodes identifcation protocol for libp2p")
    (license license:expat)))

(define-public rust-quick-protobuf-codec-0.3
  (package
    (name "rust-quick-protobuf-codec")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quick-protobuf-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0x14vq4v829j58avwcc9fcbcl9ljjsxb57d3sx2rf5ibnc55i80m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.8))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis
     "Asynchronous de-/encoding of Protobuf structs using asynchronous-codec, unsigned-varint and quick-protobuf.")
    (description
     "Asynchronous de-/encoding of Protobuf structs using asynchronous-codec,
unsigned-varint and quick-protobuf.")
    (license license:expat)))

(define-public rust-prost-types-0.11
  (package
    (name "rust-prost-types")
    (version "0.11.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prost-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04ryk38sqkp2nf4dgdqdfbgn6zwwvjraw6hqq6d9a6088shj4di1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-prost" ,rust-prost-0.11))))
    (home-page "https://github.com/tokio-rs/prost")
    (synopsis "A Protocol Buffers implementation for the Rust Language.")
    (description
     "This package provides a Protocol Buffers implementation for the Rust Language.")
    (license license:asl2.0)))

(define-public rust-prost-build-0.11
  (package
    (name "rust-prost-build")
    (version "0.11.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prost-build" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w5jx97q96ydhkg67wx3lb11kfy8195c56g0476glzws5iak758i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-heck" ,rust-heck-0.4)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-multimap" ,rust-multimap-0.8)
                       ("rust-petgraph" ,rust-petgraph-0.6)
                       ("rust-prettyplease" ,rust-prettyplease-0.1)
                       ("rust-prost" ,rust-prost-0.11)
                       ("rust-prost-types" ,rust-prost-types-0.11)
                       ("rust-pulldown-cmark" ,rust-pulldown-cmark-0.9)
                       ("rust-pulldown-cmark-to-cmark" ,rust-pulldown-cmark-to-cmark-10)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-which" ,rust-which-4))))
    (home-page "https://github.com/tokio-rs/prost")
    (synopsis "A Protocol Buffers implementation for the Rust Language.")
    (description
     "This package provides a Protocol Buffers implementation for the Rust Language.")
    (license license:asl2.0)))

(define-public rust-prometheus-client-derive-encode-0.4
  (package
    (name "rust-prometheus-client-derive-encode")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prometheus-client-derive-encode" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f22ckswiqnjlh1xaxkh8pqlfsdhj851ns33bnvrcsczp97743s4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/prometheus/client_rust")
    (synopsis "Auxiliary crate to derive Encode trait from prometheus-client.")
    (description
     "Auxiliary crate to derive Encode trait from prometheus-client.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-dtoa-1
  (package
    (name "rust-dtoa")
    (version "1.0.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dtoa" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lv6zzgrd3hfh83n9jqhzz8645729hv1wclag8zw4dbmx3w2pfyw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-no-panic" ,rust-no-panic-0.1))))
    (home-page "https://github.com/dtolnay/dtoa")
    (synopsis "Fast floating point primitive to string conversion")
    (description "Fast floating point primitive to string conversion")
    (license (list license:expat license:asl2.0))))

(define-public rust-prometheus-client-0.22
  (package
    (name "rust-prometheus-client")
    (version "0.22.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prometheus-client" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1alvj3amnjary5qlv9fk3z1wz79zybjyjfm7y84jacralafrbjn1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dtoa" ,rust-dtoa-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-prometheus-client-derive-encode" ,rust-prometheus-client-derive-encode-0.4)
                       ("rust-prost" ,rust-prost-0.11)
                       ("rust-prost-build" ,rust-prost-build-0.11)
                       ("rust-prost-types" ,rust-prost-types-0.11))))
    (home-page "https://github.com/prometheus/client_rust")
    (synopsis
     "Open Metrics client library allowing users to natively instrument applications.")
    (description
     "Open Metrics client library allowing users to natively instrument applications.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-hex-fmt-0.3
  (package
    (name "rust-hex-fmt")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hex_fmt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vrkzxd1wb4piij68fhmhycj01ky6nsn73piy37dk97h7xwn0zxh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/poanetwork/hex_fmt")
    (synopsis "Formatting and shortening byte slices as hexadecimal strings")
    (description
     "Formatting and shortening byte slices as hexadecimal strings")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-ticker-0.0.3
  (package
    (name "rust-futures-ticker")
    (version "0.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "futures-ticker" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bk8868aira9vjqwby0zzklwcgsbd9zwq5p9a8m664zp8y00aqwp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1))))
    (home-page "https://github.com/antifuchs/futures-ticker")
    (synopsis "An asynchronous recurring time event")
    (description "An asynchronous recurring time event")
    (license license:expat)))

(define-public rust-libp2p-gossipsub-0.46
  (package
    (name "rust-libp2p-gossipsub")
    (version "0.46.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-gossipsub" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xwl5h2nsjq8zwc348mipzcdr3286c96n67zbzffpbbdc5518rfn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-ticker" ,rust-futures-ticker-0.0.3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-hex-fmt" ,rust-hex-fmt-0.3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-prometheus-client" ,rust-prometheus-client-0.22)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.3)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Gossipsub protocol for libp2p")
    (description "Gossipsub protocol for libp2p")
    (license license:expat)))

(define-public rust-farmhash-1
  (package
    (name "rust-farmhash")
    (version "1.1.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "farmhash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jz3xvrrmsssjmshgw8anmly792i55sk1hyvx9fcg4cqzg4fjp7k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "http://seif.codes")
    (synopsis
     "Farmhash is a successor to Cityhash (also from Google). Farmhash, like Cityhash before it, use ideas from Austin Appleby's MurmurHash.")
    (description
     "Farmhash is a successor to Cityhash (also from Google).  Farmhash, like Cityhash
before it, use ideas from Austin Appleby's @code{MurmurHash}.")
    (license license:expat)))

(define-public rust-cuckoofilter-0.5
  (package
    (name "rust-cuckoofilter")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cuckoofilter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "067fkr9dc118rqddr72xdldq05d31yyipvvyrmj9yrrik52ah45q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-clippy" ,rust-clippy-0.0)
                       ("rust-farmhash" ,rust-farmhash-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-rand" ,rust-rand-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-bytes" ,rust-serde-bytes-0.11)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "http://axiom.co")
    (synopsis "Cuckoo Filter: Practically Better Than Bloom")
    (description "Cuckoo Filter: Practically Better Than Bloom")
    (license license:expat)))

(define-public rust-bytes-1
  (package
    (name "rust-bytes")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytes" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08w2i8ac912l8vlvkv3q51cd4gr09pwlg3sjsjffcizlrb0i5gd2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/tokio-rs/bytes")
    (synopsis "Types and traits for working with bytes")
    (description "Types and traits for working with bytes")
    (license license:expat)))

(define-public rust-libp2p-floodsub-0.44
  (package
    (name "rust-libp2p-floodsub")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-floodsub" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11z0kqbziyj290hz77rl1h6g2nbifzmkffyyca18a5almxkvrn9g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-cuckoofilter" ,rust-cuckoofilter-0.5)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Floodsub protocol for libp2p")
    (description "Floodsub protocol for libp2p")
    (license license:expat)))

(define-public rust-async-std-resolver-0.24
  (package
    (name "rust-async-std-resolver")
    (version "0.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-std-resolver" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jzv44g5dhr1ylqw0yixbl5ix73m0i7adianhz1d44qwcyvd43iw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-hickory-resolver" ,rust-hickory-resolver-0.24)
                       ("rust-pin-utils" ,rust-pin-utils-0.1)
                       ("rust-socket2" ,rust-socket2-0.5))))
    (home-page "https://trust-dns.org/")
    (synopsis
     "Trust-DNS is a safe and secure DNS library, for async-std. This Resolver library uses the trust-dns-proto library to perform all DNS queries. The Resolver is intended to be a high-level library for any DNS record resolution see Resolver and AsyncResolver for supported resolution types. The Client can be used for other queries.
")
    (description
     "Trust-DNS is a safe and secure DNS library, for async-std.  This Resolver
library uses the trust-dns-proto library to perform all DNS queries.  The
Resolver is intended to be a high-level library for any DNS record resolution
see Resolver and @code{AsyncResolver} for supported resolution types.  The
Client can be used for other queries.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libp2p-dns-0.41
  (package
    (name "rust-libp2p-dns")
    (version "0.41.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-dns" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dn4fsazyxpb90788wpafyvnr7gyd2hf83aniqz5rwqg2vvvqz6i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std-resolver" ,rust-async-std-resolver-0.24)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-hickory-resolver" ,rust-hickory-resolver-0.24)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "DNS transport implementation for libp2p")
    (description "DNS transport implementation for libp2p")
    (license license:expat)))

(define-public rust-lru-0.11
  (package
    (name "rust-lru")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lru" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08dzlpriy9xajga5k2rgsh7qq5zhx3rfd6jgwfh46dlbd6vkza54"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hashbrown" ,rust-hashbrown-0.14))))
    (home-page "https://github.com/jeromefroe/lru-rs")
    (synopsis "A LRU cache implementation")
    (description "This package provides a LRU cache implementation")
    (license license:expat)))

(define-public rust-libp2p-dcutr-0.11
  (package
    (name "rust-libp2p-dcutr")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-dcutr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wvvr7wqa6l66mg3gdk2iijln7jwzzinfvqaqgcwmrmrl9zvpxx4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-bounded" ,rust-futures-bounded-0.2)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-lru" ,rust-lru-0.11)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Direct connection upgrade through relay")
    (description "Direct connection upgrade through relay")
    (license license:expat)))

(define-public rust-libp2p-connection-limits-0.3
  (package
    (name "rust-libp2p-connection-limits")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-connection-limits" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zdlfp82qhm8sc9hz1vnydbq24xhwhycvfjcx56s3bfgijkm1kf7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Connection limits for libp2p.")
    (description "Connection limits for libp2p.")
    (license license:expat)))

(define-public rust-quick-protobuf-codec-0.2
  (package
    (name "rust-quick-protobuf-codec")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quick-protobuf-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "163fynrgzw3n584z0ynmqwvfgyrrf46dslad4hkiclvqrnqyvvgq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.7))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis
     "Asynchronous de-/encoding of Protobuf structs using asynchronous-codec, unsigned-varint and quick-protobuf.")
    (description
     "Asynchronous de-/encoding of Protobuf structs using asynchronous-codec,
unsigned-varint and quick-protobuf.")
    (license license:expat)))

(define-public rust-futures-bounded-0.2
  (package
    (name "rust-futures-bounded")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "futures-bounded" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wz1rrii9wklc6ja7dkcblja6vzq82mz87ry7ppriq84q567gqp1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-futures-util" ,rust-futures-util-0.3))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Utilities for bounding futures in size and time.")
    (description "Utilities for bounding futures in size and time.")
    (license license:expat)))

(define-public rust-cbor4ii-0.3
  (package
    (name "rust-cbor4ii")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cbor4ii" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z8hvca8mxgqdilp8caarsz340jd3l03j3b0c6q5fiycp61wid2r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-half" ,rust-half-2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/quininer/cbor4ii")
    (synopsis "CBOR: Concise Binary Object Representation")
    (description "CBOR: Concise Binary Object Representation")
    (license license:expat)))

(define-public rust-libp2p-request-response-0.26
  (package
    (name "rust-libp2p-request-response")
    (version "0.26.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-request-response" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vrgay4vpzcllbcf3x1z53qsy2d6x4mzmvm6vvfmpi701wjj6a71"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-cbor4ii" ,rust-cbor4ii-0.3)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-bounded" ,rust-futures-bounded-0.2)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Generic Request/Response Protocols")
    (description "Generic Request/Response Protocols")
    (license license:expat)))

(define-public rust-libp2p-autonat-0.12
  (package
    (name "rust-libp2p-autonat")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-autonat" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11h5a42crvghzfliclpn2jmf93w85g29bgrm2xcipr3hc5r52lfr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-request-response" ,rust-libp2p-request-response-0.26)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-quick-protobuf-codec" ,rust-quick-protobuf-codec-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "NAT and firewall detection for libp2p")
    (description "NAT and firewall detection for libp2p")
    (license license:expat)))

(define-public rust-libp2p-swarm-derive-0.34
  (package
    (name "rust-libp2p-swarm-derive")
    (version "0.34.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-swarm-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vwbgmh0h8zx7c8psa239jmrcvd3wxp24c8b22kadnng9a5jci5n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Procedural macros of libp2p-swarm")
    (description "Procedural macros of libp2p-swarm")
    (license license:expat)))

(define-public rust-getrandom-0.2
  (package
    (name "rust-getrandom")
    (version "0.2.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "getrandom" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d8jb9bv38nkwlqqdjcav6gxckgwc9g30pm3qq506rvncpm9400r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-wasi" ,rust-wasi-0.11)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2))))
    (home-page "https://github.com/rust-random/getrandom")
    (synopsis
     "A small cross-platform library for retrieving random data from system source")
    (description
     "This package provides a small cross-platform library for retrieving random data
from system source")
    (license (list license:expat license:asl2.0))))

(define-public rust-libp2p-swarm-0.44
  (package
    (name "rust-libp2p-swarm")
    (version "0.44.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-swarm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rhqfsj6ihmbjxafl9kpfwc3f40hkdf82wf362p95cjg7ky349g9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm-derive" ,rust-libp2p-swarm-derive-0.34)
                       ("rust-multistream-select" ,rust-multistream-select-0.13)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "The libp2p swarm")
    (description "The libp2p swarm")
    (license license:expat)))

(define-public rust-asynchronous-codec-0.7
  (package
    (name "rust-asynchronous-codec")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "asynchronous-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cy2aqcq7km8ggpjmfvrbckvjgf1bpxh803kb4z90zqp48h0fq58"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-cbor" ,rust-serde-cbor-0.11)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/mxinden/asynchronous-codec")
    (synopsis "Utilities for encoding and decoding frames using `async/await`")
    (description
     "Utilities for encoding and decoding frames using `async/await`")
    (license license:expat)))

(define-public rust-unsigned-varint-0.8
  (package
    (name "rust-unsigned-varint")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unsigned-varint" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01lwzxp0hf5p966fjq0lyz2x4l44b52py1fbffp9clabn9cnj1pb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.7)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-tokio-util" ,rust-tokio-util-0.7))))
    (home-page "https://github.com/paritytech/unsigned-varint")
    (synopsis "unsigned varint encoding")
    (description "unsigned varint encoding")
    (license license:expat)))

(define-public rust-smallvec-1
  (package
    (name "rust-smallvec")
    (version "1.13.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "smallvec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mzk9j117pn3k1gabys0b7nz8cdjsx5xc6q7fwnm8r0an62d7v76"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/servo/rust-smallvec")
    (synopsis
     "'Small vector' optimization: store up to a small number of items on the stack")
    (description
     "Small vector optimization: store up to a small number of items on the stack")
    (license (list license:expat license:asl2.0))))

(define-public rust-rw-stream-sink-0.4
  (package
    (name "rust-rw-stream-sink")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rw-stream-sink" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18g9bxl1lb6har1f9i09zcdh10v32lzjig2vwjjkvwnjymph5jfq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-static-assertions" ,rust-static-assertions-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Adaptator between Stream/Sink and AsyncRead/AsyncWrite")
    (description
     "Adaptator between Stream/Sink and @code{AsyncRead/AsyncWrite}")
    (license license:expat)))

(define-public rust-pin-project-internal-1
  (package
    (name "rust-pin-project-internal")
    (version "1.1.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pin-project-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r9r4ivwiyqf45sv6b30l1dx282lxaax2f6gl84jwa3q590s8f1g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/taiki-e/pin-project")
    (synopsis "Implementation detail of the `pin-project` crate.
")
    (description "Implementation detail of the `pin-project` crate.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-pin-project-1
  (package
    (name "rust-pin-project")
    (version "1.1.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pin-project" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cxl146x0q7lawp0m1826wsgj8mmmfs6ja8q7m6f7ff5j6vl7gxn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-pin-project-internal" ,rust-pin-project-internal-1))))
    (home-page "https://github.com/taiki-e/pin-project")
    (synopsis "A crate for safe and ergonomic pin-projection.
")
    (description
     "This package provides a crate for safe and ergonomic pin-projection.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-multistream-select-0.13
  (package
    (name "rust-multistream-select")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multistream-select" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "069gqjl4gy9qggrrvkyz145bk9p1gw6lzvi6ndi8laf2xvjzh3ga"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.7))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Multistream-select negotiation protocol for libp2p")
    (description "Multistream-select negotiation protocol for libp2p")
    (license license:expat)))

(define-public rust-data-encoding-macro-internal-0.1
  (package
    (name "rust-data-encoding-macro-internal")
    (version "0.1.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "data-encoding-macro-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wvn4p7wzr6p8fy8q9qpzgbvb9j1k3b5016867b7vcc95izx0iq0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/ia0/data-encoding")
    (synopsis "Internal library for data-encoding-macro")
    (description "Internal library for data-encoding-macro")
    (license license:expat)))

(define-public rust-data-encoding-macro-0.1
  (package
    (name "rust-data-encoding-macro")
    (version "0.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "data-encoding-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gnkqpd3h24wy272vpdphp7z6gcbq9kyn8df5ggyyaglyl31rh10"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-data-encoding-macro-internal" ,rust-data-encoding-macro-internal-0.1))))
    (home-page "https://github.com/ia0/data-encoding")
    (synopsis "Macros for data-encoding")
    (description "Macros for data-encoding")
    (license license:expat)))

(define-public rust-multibase-0.9
  (package
    (name "rust-multibase")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multibase" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "014l697md16829k41hzmfx4in9jzhn774q5292bsq10z7kn3jdcv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base-x" ,rust-base-x-0.2)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-data-encoding-macro" ,rust-data-encoding-macro-0.1))))
    (home-page "https://github.com/multiformats/rust-multibase")
    (synopsis "multibase in rust")
    (description "multibase in rust")
    (license license:expat)))

(define-public rust-multiaddr-0.18
  (package
    (name "rust-multiaddr")
    (version "0.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multiaddr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w108z42cfc15a9zmnsv19wr4jvps18gl56dd3nzx99d5b02p1cb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-multibase" ,rust-multibase-0.9)
                       ("rust-multihash" ,rust-multihash-0.19)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.7)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://github.com/multiformats/rust-multiaddr")
    (synopsis "Implementation of the multiaddr format")
    (description "Implementation of the multiaddr format")
    (license license:expat)))

(define-public rust-quick-protobuf-0.8
  (package
    (name "rust-quick-protobuf")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quick-protobuf" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07rf1pdzq9l5rsv0qg96487ijvi73rp2zfh1ksc2lwh4q96ahvcx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1))))
    (home-page "https://github.com/tafia/quick-protobuf")
    (synopsis "A pure Rust protobuf (de)serializer. Quick.")
    (description
     "This package provides a pure Rust protobuf (de)serializer.  Quick.")
    (license license:expat)))

(define-public rust-asynchronous-codec-0.6
  (package
    (name "rust-asynchronous-codec")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "asynchronous-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0s2mnrgnkbybq33k4issnxvbz6wf7i1kiyr2iqazrcnv5b1z4ms0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-cbor" ,rust-serde-cbor-0.11)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/mxinden/asynchronous-codec")
    (synopsis "Utilities for encoding and decoding frames using `async/await`")
    (description
     "Utilities for encoding and decoding frames using `async/await`")
    (license license:expat)))

(define-public rust-unsigned-varint-0.7
  (package
    (name "rust-unsigned-varint")
    (version "0.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unsigned-varint" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "018iai89m508xasxxcdfxnnr80vk5ixgjszc9i817w7i95ysg2b8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asynchronous-codec" ,rust-asynchronous-codec-0.6)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-tokio-util" ,rust-tokio-util-0.7))))
    (home-page "https://github.com/paritytech/unsigned-varint")
    (synopsis "unsigned varint encoding")
    (description "unsigned varint encoding")
    (license license:expat)))

(define-public rust-parity-scale-codec-derive-3
  (package
    (name "rust-parity-scale-codec-derive")
    (version "3.6.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "parity-scale-codec-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nyydc05sqjpryzscaw66nd1fvdqggjqvcw3cqrsbyx9n3sflc5y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-crate" ,rust-proc-macro-crate-2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "")
    (synopsis
     "Serialization and deserialization derive macro for Parity SCALE Codec")
    (description
     "Serialization and deserialization derive macro for Parity SCALE Codec")
    (license license:asl2.0)))

(define-public rust-impl-trait-for-tuples-0.2
  (package
    (name "rust-impl-trait-for-tuples")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "impl-trait-for-tuples" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1swmfdzfcfhnyvpm8irr5pvq8vpf8wfbdj91g6jzww8b6gvakmqi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/bkchr/impl-trait-for-tuples")
    (synopsis "Attribute macro to implement a trait for tuples
")
    (description "Attribute macro to implement a trait for tuples")
    (license (list license:asl2.0 license:expat))))

(define-public rust-byte-slice-cast-1
  (package
    (name "rust-byte-slice-cast")
    (version "1.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "byte-slice-cast" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "033vv1qddzsj9yfsam4abj55rp60digngcr9a8wgv9pccf5rzb63"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/sdroege/bytes-num-slice-cast")
    (synopsis
     "Safely cast bytes slices from/to slices of built-in fundamental numeric types")
    (description
     "Safely cast bytes slices from/to slices of built-in fundamental numeric types")
    (license license:expat)))

(define-public rust-derive-arbitrary-1
  (package
    (name "rust-derive-arbitrary")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "derive_arbitrary" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04bnd985frl81r5sgixgpvncnnj1bfpfnd7qvdx1aahnqi9pbrv7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/rust-fuzz/arbitrary")
    (synopsis "Derives arbitrary traits")
    (description "Derives arbitrary traits")
    (license (list license:expat license:asl2.0))))

(define-public rust-arbitrary-1
  (package
    (name "rust-arbitrary")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arbitrary" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0471f0c4f1bgibhyhf8vnapkp158h1nkrzx0wnq97jwd9n0jcnkx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-derive-arbitrary" ,rust-derive-arbitrary-1))))
    (home-page "https://github.com/rust-fuzz/arbitrary/")
    (synopsis
     "The trait for generating structured data from unstructured data")
    (description
     "The trait for generating structured data from unstructured data")
    (license (list license:expat license:asl2.0))))

(define-public rust-parity-scale-codec-3
  (package
    (name "rust-parity-scale-codec")
    (version "3.6.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "parity-scale-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zp8lywhvbyijwjwbz3wwhawdvcg79jbjbfcc7xs4hm89zik24w8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bitvec" ,rust-bitvec-1)
                       ("rust-byte-slice-cast" ,rust-byte-slice-cast-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-generic-array" ,rust-generic-array-0.14)
                       ("rust-impl-trait-for-tuples" ,rust-impl-trait-for-tuples-0.2)
                       ("rust-parity-scale-codec-derive" ,rust-parity-scale-codec-derive-3)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/paritytech/parity-scale-codec")
    (synopsis "SCALE - Simple Concatenating Aggregated Little Endians")
    (description "SCALE - Simple Concatenating Aggregated Little Endians")
    (license license:asl2.0)))

(define-public rust-multihash-0.19
  (package
    (name "rust-multihash")
    (version "0.19.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multihash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14n46nki4ynr6lh28wa4zinphxy56qf0n7a7mgaa1qm0fs6m8v87"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-core2" ,rust-core2-0.4)
                       ("rust-parity-scale-codec" ,rust-parity-scale-codec-3)
                       ("rust-quickcheck" ,rust-quickcheck-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.7))))
    (home-page "https://github.com/multiformats/rust-multihash")
    (synopsis "Implementation of the multihash format")
    (description "Implementation of the multihash format")
    (license license:expat)))

(define-public rust-libsecp256k1-gen-genmult-0.3
  (package
    (name "rust-libsecp256k1-gen-genmult")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libsecp256k1-gen-genmult" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z3gl0x5rpdjrr3mds8620gk0h0qjfccr33f1v2ar7pc5jxddf1x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libsecp256k1-core" ,rust-libsecp256k1-core-0.3))))
    (home-page "https://github.com/paritytech/libsecp256k1")
    (synopsis "Generator function of const for libsecp256k1.")
    (description "Generator function of const for libsecp256k1.")
    (license license:asl2.0)))

(define-public rust-libsecp256k1-gen-ecmult-0.3
  (package
    (name "rust-libsecp256k1-gen-ecmult")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libsecp256k1-gen-ecmult" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02a8rddxan8616rrq5b88hbw9ikz323psfk4fahyi1swql4chf1h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libsecp256k1-core" ,rust-libsecp256k1-core-0.3))))
    (home-page "https://github.com/paritytech/libsecp256k1")
    (synopsis "Generator function of const_gen for libsecp256k1.")
    (description "Generator function of const_gen for libsecp256k1.")
    (license license:asl2.0)))

(define-public rust-libsecp256k1-core-0.3
  (package
    (name "rust-libsecp256k1-core")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libsecp256k1-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lalbm1f67dd0cxpa12mjq0q6wvcq5bangjk9nj2519dcjxvksav"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crunchy" ,rust-crunchy-0.2)
                       ("rust-digest" ,rust-digest-0.9)
                       ("rust-subtle" ,rust-subtle-2))))
    (home-page "https://github.com/paritytech/libsecp256k1")
    (synopsis "Core functions for pure Rust secp256k1 implementation.")
    (description "Core functions for pure Rust secp256k1 implementation.")
    (license license:asl2.0)))

(define-public rust-hmac-drbg-0.3
  (package
    (name "rust-hmac-drbg")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hmac-drbg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cc5ddks8bg3512fzrd4n2gqr1kqkvg1l33fv9s6anyzjh9hmshp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-digest" ,rust-digest-0.9)
                       ("rust-generic-array" ,rust-generic-array-0.14)
                       ("rust-hmac" ,rust-hmac-0.8))))
    (home-page "")
    (synopsis "Pure Rust implementation of Hmac DRBG.")
    (description "Pure Rust implementation of Hmac DRBG.")
    (license license:asl2.0)))

(define-public rust-libsecp256k1-0.7
  (package
    (name "rust-libsecp256k1")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libsecp256k1" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18g2ap7ny8h6r59rrqn734clhypwj6kd7kkpp0rkpv9m3gzrxc4m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-digest" ,rust-digest-0.9)
                       ("rust-hmac-drbg" ,rust-hmac-drbg-0.3)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libsecp256k1-core" ,rust-libsecp256k1-core-0.3)
                       ("rust-libsecp256k1-gen-ecmult" ,rust-libsecp256k1-gen-ecmult-0.3)
                       ("rust-libsecp256k1-gen-genmult" ,rust-libsecp256k1-gen-genmult-0.3)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.9)
                       ("rust-typenum" ,rust-typenum-1))))
    (home-page "https://github.com/paritytech/libsecp256k1")
    (synopsis "Pure Rust secp256k1 implementation.")
    (description "Pure Rust secp256k1 implementation.")
    (license license:asl2.0)))

(define-public rust-merlin-3
  (package
    (name "rust-merlin")
    (version "3.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "merlin" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z9rh9jlpcs0i0cijbs6pcq26gl4qwz05y7zbnv7h2gwk4kqxhsq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-hex" ,rust-hex-0.3)
                       ("rust-keccak" ,rust-keccak-0.1)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://docs.rs/merlin")
    (synopsis
     "Composable proof transcripts for public-coin arguments of knowledge")
    (description
     "Composable proof transcripts for public-coin arguments of knowledge")
    (license license:expat)))

(define-public rust-ed25519-2
  (package
    (name "rust-ed25519")
    (version "2.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ed25519" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lydzdf26zbn82g7xfczcac9d7mzm3qgx934ijjrd5hjpjx32m8i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-pkcs8" ,rust-pkcs8-0.10)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-bytes" ,rust-serde-bytes-0.11)
                       ("rust-signature" ,rust-signature-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/RustCrypto/signatures/tree/master/ed25519")
    (synopsis
     "Edwards Digital Signature Algorithm (EdDSA) over Curve25519 (as specified in RFC 8032)
support library providing signature type definitions and PKCS#8 private key
decoding/encoding support
")
    (description
     "Edwards Digital Signature Algorithm (@code{EdDSA}) over Curve25519 (as specified
in RFC 8032) support library providing signature type definitions and PKCS#8
private key decoding/encoding support")
    (license (list license:asl2.0 license:expat))))

(define-public rust-platforms-3
  (package
    (name "rust-platforms")
    (version "3.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "platforms" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0k7q6pigmnvgpfasvssb12m2pv3pc94zrhrfg9by3h3wmhyfqvb2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://rustsec.org")
    (synopsis
     "Rust platform registry with information about valid Rust platforms (target
triple, target_arch, target_os) sourced from the Rust compiler.
")
    (description
     "Rust platform registry with information about valid Rust platforms (target
triple, target_arch, target_os) sourced from the Rust compiler.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fiat-crypto-0.2
  (package
    (name "rust-fiat-crypto")
    (version "0.2.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fiat-crypto" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10hkkkjynhibvchznkxx81gwxqarn9i5sgz40d6xxb8xzhsz8xhn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/mit-plv/fiat-crypto")
    (synopsis "Fiat-crypto generated Rust")
    (description "Fiat-crypto generated Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-curve25519-dalek-derive-0.1
  (package
    (name "rust-curve25519-dalek-derive")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "curve25519-dalek-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cry71xxrr0mcy5my3fb502cwfxy6822k4pm19cwrilrg7hq4s7l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis "curve25519-dalek Derives")
    (description "curve25519-dalek Derives")
    (license (list license:expat license:asl2.0))))

(define-public rust-curve25519-dalek-4
  (package
    (name "rust-curve25519-dalek")
    (version "4.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "curve25519-dalek" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0j7kqchcgycs4a11gvlda93h9w2jr05nn4hjpfyh2kn94a4pnrqa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-curve25519-dalek-derive" ,rust-curve25519-dalek-derive-0.1)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-ff" ,rust-ff-0.13)
                       ("rust-fiat-crypto" ,rust-fiat-crypto-0.2)
                       ("rust-group" ,rust-group-0.13)
                       ("rust-platforms" ,rust-platforms-3)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-subtle" ,rust-subtle-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis
     "A pure-Rust implementation of group operations on ristretto255 and Curve25519")
    (description
     "This package provides a pure-Rust implementation of group operations on
ristretto255 and Curve25519")
    (license license:bsd-3)))

(define-public rust-ed25519-dalek-2
  (package
    (name "rust-ed25519-dalek")
    (version "2.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ed25519-dalek" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w88cafwglg9hjizldbmlza0ns3hls81zk1bcih3m5m3h67algaa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-curve25519-dalek" ,rust-curve25519-dalek-4)
                       ("rust-ed25519" ,rust-ed25519-2)
                       ("rust-merlin" ,rust-merlin-3)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-signature" ,rust-signature-2)
                       ("rust-subtle" ,rust-subtle-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis
     "Fast and efficient ed25519 EdDSA key generations, signing, and verification in pure Rust.")
    (description
     "Fast and efficient ed25519 @code{EdDSA} key generations, signing, and
verification in pure Rust.")
    (license license:bsd-3)))

(define-public rust-bs58-0.5
  (package
    (name "rust-bs58")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bs58" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15kqgld75z03srq6nzsdgraakhvap5avgw364h352x0z6hv3ydgm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sha2" ,rust-sha2-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tinyvec" ,rust-tinyvec-1))))
    (home-page "https://github.com/Nullus157/bs58-rs")
    (synopsis "Another Base58 codec implementation.")
    (description "Another Base58 codec implementation.")
    (license (list license:expat license:asl2.0))))

(define-public rust-asn1-der-0.7
  (package
    (name "rust-asn1-der")
    (version "0.7.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "asn1_der" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0iy22nmh8x21xmzbgdx54ybrw2lk7la1b2mqqxxbgij2bqc5lnhm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-no-panic" ,rust-no-panic-0.1))))
    (home-page "https://github.com/KizzyCode/asn1_der-rust")
    (synopsis "This crate provides an ASN.1-DER en-/decoder")
    (description "This crate provides an ASN.1-DER en-/decoder")
    (license (list license:bsd-2 license:expat))))

(define-public rust-libp2p-identity-0.2
  (package
    (name "rust-libp2p-identity")
    (version "0.2.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-identity" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1q4vmg3igan0qq8nlvy6pplk5jb6qimnlwkna0skbyxj842cg7lr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asn1-der" ,rust-asn1-der-0.7)
                       ("rust-bs58" ,rust-bs58-0.5)
                       ("rust-ed25519-dalek" ,rust-ed25519-dalek-2)
                       ("rust-hkdf" ,rust-hkdf-0.12)
                       ("rust-libsecp256k1" ,rust-libsecp256k1-0.7)
                       ("rust-multihash" ,rust-multihash-0.19)
                       ("rust-p256" ,rust-p256-0.13)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-ring" ,rust-ring-0.17)
                       ("rust-sec1" ,rust-sec1-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-void" ,rust-void-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis
     "Data structures and algorithms for identifying peers in libp2p.")
    (description
     "Data structures and algorithms for identifying peers in libp2p.")
    (license license:expat)))

(define-public rust-libp2p-core-0.41
  (package
    (name "rust-libp2p-core")
    (version "0.41.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01bc0rjvx69nl96b5vylp3999kabvw5pf70kam6mb8k5kqkahc41"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-multiaddr" ,rust-multiaddr-0.18)
                       ("rust-multihash" ,rust-multihash-0.19)
                       ("rust-multistream-select" ,rust-multistream-select-0.13)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-quick-protobuf" ,rust-quick-protobuf-0.8)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rw-stream-sink" ,rust-rw-stream-sink-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-unsigned-varint" ,rust-unsigned-varint-0.8)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Core traits and structs of libp2p")
    (description "Core traits and structs of libp2p")
    (license license:expat)))

(define-public rust-libp2p-allow-block-list-0.3
  (package
    (name "rust-libp2p-allow-block-list")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p-allow-block-list" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rij19djzdfg80l6dzkjkf4h0cnagk7mvbbl7fskmf2cg65j6yqh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-void" ,rust-void-1))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Allow/block list connection management for libp2p.")
    (description "Allow/block list connection management for libp2p.")
    (license license:expat)))

(define-public rust-libp2p-0.53
  (package
    (name "rust-libp2p")
    (version "0.53.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libp2p" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16gwqsf38j82qgrsr18i0sa9y2ywvkjynckxlpbyvyzdhgqv67v8"))))
    (build-system cargo-build-system)
    (arguments
     `(;; Some tests use the network.
       #:tests? #f
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-libp2p-allow-block-list" ,rust-libp2p-allow-block-list-0.3)
                       ("rust-libp2p-autonat" ,rust-libp2p-autonat-0.12)
                       ("rust-libp2p-connection-limits" ,rust-libp2p-connection-limits-0.3)
                       ("rust-libp2p-core" ,rust-libp2p-core-0.41)
                       ("rust-libp2p-dcutr" ,rust-libp2p-dcutr-0.11)
                       ("rust-libp2p-dns" ,rust-libp2p-dns-0.41)
                       ("rust-libp2p-floodsub" ,rust-libp2p-floodsub-0.44)
                       ("rust-libp2p-gossipsub" ,rust-libp2p-gossipsub-0.46)
                       ("rust-libp2p-identify" ,rust-libp2p-identify-0.44)
                       ("rust-libp2p-identity" ,rust-libp2p-identity-0.2)
                       ("rust-libp2p-kad" ,rust-libp2p-kad-0.45)
                       ("rust-libp2p-mdns" ,rust-libp2p-mdns-0.45)
                       ("rust-libp2p-memory-connection-limits" ,rust-libp2p-memory-connection-limits-0.2)
                       ("rust-libp2p-metrics" ,rust-libp2p-metrics-0.14)
                       ("rust-libp2p-noise" ,rust-libp2p-noise-0.44)
                       ("rust-libp2p-ping" ,rust-libp2p-ping-0.44)
                       ("rust-libp2p-plaintext" ,rust-libp2p-plaintext-0.41)
                       ("rust-libp2p-pnet" ,rust-libp2p-pnet-0.24)
                       ("rust-libp2p-quic" ,rust-libp2p-quic-0.10)
                       ("rust-libp2p-relay" ,rust-libp2p-relay-0.17)
                       ("rust-libp2p-rendezvous" ,rust-libp2p-rendezvous-0.14)
                       ("rust-libp2p-request-response" ,rust-libp2p-request-response-0.26)
                       ("rust-libp2p-swarm" ,rust-libp2p-swarm-0.44)
                       ("rust-libp2p-tcp" ,rust-libp2p-tcp-0.41)
                       ("rust-libp2p-tls" ,rust-libp2p-tls-0.3)
                       ("rust-libp2p-uds" ,rust-libp2p-uds-0.40)
                       ("rust-libp2p-upnp" ,rust-libp2p-upnp-0.2)
                       ("rust-libp2p-websocket" ,rust-libp2p-websocket-0.43)
                       ("rust-libp2p-websocket-websys" ,rust-libp2p-websocket-websys-0.3)
                       ("rust-libp2p-webtransport-websys" ,rust-libp2p-webtransport-websys-0.2)
                       ("rust-libp2p-yamux" ,rust-libp2p-yamux-0.45)
                       ("rust-multiaddr" ,rust-multiaddr-0.18)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rw-stream-sink" ,rust-rw-stream-sink-0.4)
                       ("rust-thiserror" ,rust-thiserror-1))
       #:cargo-development-inputs (("rust-async-std" ,rust-async-std-1)
                                   ("rust-async-trait" ,rust-async-trait-0.1)
                                   ("rust-clap" ,rust-clap-4)
                                   ("rust-libp2p-mplex" ,rust-libp2p-mplex-0.41)
                                   ("rust-libp2p-noise" ,rust-libp2p-noise-0.44)
                                   ("rust-libp2p-tcp" ,rust-libp2p-tcp-0.41)
                                   ("rust-tokio" ,rust-tokio-1)
                                   ("rust-tracing-subscriber" ,rust-tracing-subscriber-0.3))))
    (home-page "https://github.com/libp2p/rust-libp2p")
    (synopsis "Peer-to-peer networking library")
    (description "Peer-to-peer networking library")
    (license license:expat)))

(define-public rust-serde-1/newer
  (package
    (name "rust-serde")
    (version "1.0.197")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qjcxqd3p4yh5cmmax9q4ics1zy34j5ij32cvjj5dc5rw5rwic9z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))
       #:cargo-development-inputs (("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://serde.rs")
    (synopsis "A generic serialization/deserialization framework")
    (description
     "This package provides a generic serialization/deserialization framework")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.197")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02v1x0sdv8qy06lpr6by4ar1n3jz3hmab15cgimpzhgd895v7c3y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))
       #:cargo-development-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://serde.rs")
    (synopsis "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (description
     "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (license (list license:expat license:asl2.0))))

(define-public rust-indexmap-2
  (package
    (name "rust-indexmap")
    (version "2.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "indexmap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x4x9zdqvlkfks3y84dsynh1p8na3nn48nn454s26rqla6fr42vv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-borsh" ,rust-borsh-1)
                       ("rust-equivalent" ,rust-equivalent-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-quickcheck" ,rust-quickcheck-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rustc-rayon" ,rust-rustc-rayon-0.5)
                       ("rust-serde" ,rust-serde-1))
       #:cargo-development-inputs (("rust-fnv" ,rust-fnv-1)
                                   ("rust-fxhash" ,rust-fxhash-0.2)
                                   ("rust-itertools" ,rust-itertools-0.12)
                                   ("rust-lazy-static" ,rust-lazy-static-1)
                                   ("rust-quickcheck" ,rust-quickcheck-1)
                                   ("rust-rand" ,rust-rand-0.8)
                                   ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://github.com/indexmap-rs/indexmap")
    (synopsis "A hash table with consistent order and fast iteration.")
    (description
     "This package provides a hash table with consistent order and fast iteration.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-serde-json-1/newer
  (package
    (name "rust-serde-json")
    (version "1.0.114")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1q4saigxwkf8bw4y5kp6k33dnavlvvwa2q4zmag59vrjsqdrpw65"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #f
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1))
       #:cargo-development-inputs (("rust-automod" ,rust-automod-1)
                                   ("rust-indoc" ,rust-indoc-2)
                                   ("rust-ref-cast" ,rust-ref-cast-1)
                                   ("rust-rustversion" ,rust-rustversion-1)
                                   ("rust-serde" ,rust-serde-1)
                                   ("rust-serde-bytes" ,rust-serde-bytes-0.11)
                                   ("rust-serde-derive" ,rust-serde-derive-1)
                                   ("rust-serde-stacker" ,rust-serde-stacker-0.1)
                                   ("rust-trybuild" ,rust-trybuild-1))))
    (home-page "https://github.com/serde-rs/json")
    (synopsis "A JSON serialization file format")
    (description "This package provides a JSON serialization file format")
    (license (list license:expat license:asl2.0))))

(define-public orcanet-market-lib-proto
  (package
   (name "orcanet-market-lib-proto")
   (version "0.1.0")
   (source
    (local-file (string-append (dirname (current-filename)) "/lib-proto")
                #:recursive? #t))
   (build-system cargo-build-system)
   (arguments
    (list
     #:cargo-inputs `(("rust-prost" ,rust-prost-0.12)
                      ("rust-serde" ,rust-serde-1/newer)
                      ("rust-tonic" ,rust-tonic-0.11)
                      ("rust-tonic-build" ,rust-tonic-build-0.11))))
   (native-inputs
    (list protobuf))
   (synopsis "TODO")
   (description "TODO")
   (license #f)
   (home-page "TODO")))

;; TODO: Requires lib-proto version to be specified in Cargo.toml
(define-public orcanet-market
  (package
    (name "orcanet-market")
    (version "0.1.0")
    (source
     (local-file (string-append (dirname (current-filename)) ;"/market"
                                )
                 #:recursive? #t))
    (build-system cargo-build-system)
    (arguments
     (list
      #:cargo-inputs
      `(("rust-libp2p" ,rust-libp2p-0.53)
        ("rust-prost" ,rust-prost-0.12)
        ("rust-tokio" ,rust-tokio-1.36)
        ("rust-tonic" ,rust-tonic-0.11)
        ("rust-serde" ,rust-serde-1/newer)
        ("rust-serde-json" ,rust-serde-json-1/newer)
        ;; ("orcanet-market-lib-proto" ,orcanet-market-lib-proto)

        ("rust-tonic-build" ,rust-tonic-build-0.11))
      #:phases
      ;; Delete the package phase since it fails due to issues with lib-proto
      ;; being a workspace dependency rather than a published, separate
      ;; dependency, if my interpretation of the following is correct:
      ;; https://stackoverflow.com/questions/72348259/cargo-package-doesnt-work-with-rusts-workspace
      #~(modify-phases %standard-phases
          (delete 'package))))
    (native-inputs
     (list protobuf))
    (synopsis "TODO")
    (description "TODO")
    (license #f)
    (home-page "TODO")))

orcanet-market
