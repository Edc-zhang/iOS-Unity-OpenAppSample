# iOS-Unity-OpenAppSample
iOS App and UnityApp Open Each Other With Image Params （OpenURL/URL Scheme）

## Sample Content
- 实现iOS（Objective-C）两个App之间的互相跳转并传递图片参数
- 实现iOS与UnityApp之间的互通、跳转和传递参数

## Supported Platforms

- iOS
- Unity

## Main Introduce
- MainApp可以和PhotoApp、UnityApp进行相互跳转（使用OpenURL方式，需配置各App的URL Scheme）
- MainApp提供从PhotoApp（iOS原生项目）、UnityApp（Unity项目）两个入口获取图片并返回至MainApp
- MainApp跳转至PhotoApp和UnityApp时可进行传参（这里传递了简单coord信息）
- PhotoApp中提供拍照和从相册中选取图片功能，拍照或选取图片后可返回MainApp并把图片Base64信息带回MainApp进行展示
- UnityApp中提供截图功能，支持跳转至MainApp并把当前截图并回传至MainApp进行展示

## Unity3D Build iOS Project
- https://www.jianshu.com/p/a0315d33cdf4
- https://gameinstitute.qq.com/community/detail/122510

## Tips
### Scheme
- MainApp -> mainapp
- PhotoApp -> photoapp
- UnityApp -> unityphotoapp


## Download Code
https://github.com/Edc-zhang/iOS-Unity-OpenAppSample.git
