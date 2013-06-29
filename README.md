#RVideoURLParse

常见视频网站的视频地址解析，支持网站

* Youku 优酷
* Tudou 土豆
* Sohu 搜狐


#使用

##Easy模式

    NSURL *url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XNTc2NjcxMDI4.html"];
    [[RVideoParser sharedVideoParser] parseWithURL:url callback:^(NSError *error, RVideoMeta *meta) {
      //procced with video meta
    }];

##Hard模式

1. 每个URL解析策略都可以单独使用

        NSURL *url = [NSURL URLWithString:@"http://www.tudou.com/programs/view/d6bk4RpkI5Y/"];
        RTudouStrategy *tudou = [[RTudouStrategy alloc] init];
        [tudou parseURL:url withCallback:^(NSError *, RVideoMeta *) {
          //procced with video meta
        }];

2. 有一些视频网站要求配置API

        [RTudouStrategy configureAPIKey:@"you api key"];

3. 关于`RVideoMeta`: 本身没有什么功能的一个数据结构，存储视频的解析信息，有方便的getter。详细有那些属性请参考源代码了。

4. 并不是所有字段都是可以获取的，视频的详细介绍`RVideoMeta#description`、时长`RVideoMeta#duration`，受API限制是不可靠的。

#关于Tudou

土豆有三种视频资源

* 单个视频 Item
* 播放列表 Playlist
* 剧集 Album

Album的查询API并未开放，所以暂时无法支持解析album的URL。网上有一些hack的方法，之后会考虑实现。

#TODO

* Sina
* QQ