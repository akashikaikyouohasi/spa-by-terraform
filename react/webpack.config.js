'use strict'

// Node.jsで実行されるのでCommon JS形式になっている！
const {resolve} = require('path')

module.exports = {
    // ビルドする環境。
    mode: 'development',
    //mode: process.env.NODE_ENV || 'development',
    // ソースマップを生成する方法。webpackによって変換前後のコードを関連づける
    // デバッガーからTSのファイルを参照できる！
    devtool: 'inline-source-map',
    // エントリーポイントとなるファイルのパス
    entry: resolve(__dirname, 'src/index.tsx'),

    // 出力設定
    output: {
        filename: 'index.js',
        path: resolve(__dirname, 'dist'),
    },
    // モジュールの解決方法
    resolve: {
        // importでは、extensionで指定した拡張子で依存関係を解決する。.jsは外部ライブラリ用
        extensions: ['.ts', '.js', '.jsx', '.tsx'],
    },
    // JavaScript以外のファイルをモジュールとして扱う場合のloader
    // tscでやっていたことをts-loaderで実行する。
    module: {
        rules: [
            {
                test: /\.(ts|jsx|tsx)$/,
                use: {
                    loader: 'ts-loader',
                },
            },
        ],
    }
}
