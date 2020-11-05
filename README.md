GPUCIImageView
===========

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat-square)](https://github.com/apple/swift-package-manager)


## ToDo

- Write Super Cool README.
- Make Ultra Cool Sample App.


## What is this

`UIImageView` みたいに、雑に `UIImage` を放り込むと良い感じのパフォーマンスで描画してくれるやつの `CIImage` 版みたいなやつ。

とにかく `CIImage` を `UIKit` に慣れた開発者が雑に使っても高パフォーマンスで描画させたい気持ちで書いた。これ単体だと何も面白くないけど、動画やカメラからの入力を低レイヤを意識せずにリアルタイムにフィルタしながら描画したい、みたいな用途で使う想定。


## Metal or OpenGL

最終的に `MTKView` はこういう実装には向かないというか、きちんと GPU のことを分かってて自分でパイプラインを意識できるというか低レイヤまで分かってて初めてパフォーマンスが出せるということが分かった。

iOS 10 ではまだ `MTKView` は素人が雑に使える段階ではない。iOS 9 の `MTKView` はもっと酷い。`Metal` 自体は iOS 8 からであるけど、`MTKView` の完成度が高くないように思える。

終始経験的な話で申し訳ないのだけれど、この実装であれば `GLKView` ベースの `GLCIImageView` の方がパフォーマンスは良いし描画も正確。単純に僕の理解が浅いだけである可能性は十分にある。


## Poem

最近の iOS 界隈というか Swift 界隈、型に厳密でクールでお洒落なライブラリじゃないとダサいみたいな風潮あると思うんだけど、完全に個人で自分が使うためだけに書いたというか、知らん、これは俺が使うんだ！！！俺こそがユーザーだ！！！


## Carthage

https://github.com/Carthage/Carthage

Write your `Cartfile`

```
github "dnpp73/GPUCIImageView"
```

and run

```sh
carthage bootstrap --no-use-binaries --platform iOS
```


## How to Use

See [`CIImageShowable`](/Sources/CIImageShowable.swift) protocol

You can use `GLCIImageView`(based on `GLKView`) or `MTCIImageView`(based on `MTKView`).

`GPUCIImageView` is based on `MTKView`(if Metal support Device) or `GLKView`(fallback).


## License

[MIT](/LICENSE)
