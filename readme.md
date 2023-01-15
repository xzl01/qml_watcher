## qml 实时预览器

基于好友的项目继续维护更新

### 简介

由于Qt 没有提供qml实时预览的功能，没办法只能写一个类似功能的程序。
B站演示视频：https://www.bilibili.com/video/BV19u41167eJ/?spm_id_from=333.788

- [x] 动态加载qml
- [x] 相对路径加载qml文件，js文件，图片
- [x] 支持window和item

原理：使用QFileSystemWatcher 实时监测文件是否修改
TODO:后续改为使用dtkcore中的QFileWatcher检测文件修改


## 更新日志
### 2022-5-31 dev
 添加主题切换功能
 ![示例](docs/img/5.31.gif)


### 如何使用

自行编译后，见gif  ,拖动到 窗口内开启预览。

![GIF 2022-5-17 19-56-57](docs/img/gif.gif)
