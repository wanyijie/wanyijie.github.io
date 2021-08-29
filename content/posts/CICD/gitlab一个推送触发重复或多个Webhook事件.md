
当GitLab发送webhook时，它需要10秒内的响应（设置默认值）。如果它没有收到，它将重试webhook。如果端点在这10秒内没有发送HTTP响应，GitLab可能会决定挂钩失败并重试。

如果您收到多个请求，可以尝试增加默认值以在发送webhook后等待HTTP响应，方法是取消注释或将以下设置添加到/etc/gitlab/gitlab.rb：

    gitlab_rails['webhook_timeout'] = 10 
