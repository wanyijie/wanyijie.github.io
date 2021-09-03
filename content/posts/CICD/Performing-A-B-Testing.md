When you are testing changes to an application, there are some factors you can measure only in a production environment rather than a development test bed. Examples include the effect of UI changes on user behavior and the impact on overall performance. A common testing method is *A/B testing* – also known as *split testing* – in which a (usually small) proportion of users is directed to the new version of an application while most users continue to use the current version.
<!--more-->
In this blog post we’ll explore why it is important to perform A/B testing when deploying new versions of your web application and how to use [NGINX](https://nginx.org/en) and [NGINX Plus](https://www.nginx.com/products/nginx/) to control which version of an application users see. Configuration examples illustrate how you can use NGINX and NGINX Plus directives, parameters, and variables to achieve accurate and measurable A/B testing.

## Why Do A/B Testing?[](https://www.nginx.com/blog/performing-a-b-testing-nginx-plus/#Why-Do-A/B&nbsp;Testing)

As we mentioned, A/B testing enables you to measure the difference in application performance or effectiveness between two versions. Perhaps your development team wants to change the visual arrangement of buttons in the UI or overhaul the entire shopping cart process, but wants to compare the close rate of transactions to make sure the change has the desired business impact. Using A/B testing you can send a defined percent of the traffic to the new version and the remaining to the old version and measure the effectiveness of both versions of the application.

Or perhaps your concern is less the effect on user behavior and more related to the performance impact. Let’s say you plan to deploy a huge set of changes to your web application and don’t feel that testing within your quality assurance environment truly captures the possible effect on performance in production. In this case, an A/B deployment allows you to expose the new version to a small, defined percentage of visitors to measure the performance impact of the changes, and gradually increase the percentage until eventually you roll out the changed application to all users.

## Using NGINX and NGINX Plus for A/B Testing[](https://www.nginx.com/blog/performing-a-b-testing-nginx-plus/#Using-NGINX-and-NGINX&nbsp;Plus-for-A/B&nbsp;Testing)

NGINX and NGINX Plus provide a couple methods for controlling where web application traffic is sent. The first method is available in both products, whereas the second is available in NGINX Plus only.

Both methods choose the destination of a request based on the values of one or more NGINX variables that capture characteristics of the client (such as its IP address) or of the request URI (such as a named argument), but the differences between them make them suitable for different A/B‑testing use cases:

*   The `split_clients` method chooses the destination of a request based on a hash of the variable values extracted from the request. The set of all possible hash values is divided up among the application versions, and you can assign a different proportion of the set to each application. The choice of destination ends up being randomized.
*   The `sticky` `route` method provides you much greater control over the destination of each request. The choice of application is based on the variable values themselves (not a hash), so you can set explicitly which application receives requests that have certain variable values. You can also use regular expressions to base the decision on just portions of a variable value, and can preferentially choose one variable over another as the basis for the decision.

### Using the `split_clients` Method

In this method, the [`split_clients`](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html#split_clients) configuration block sets a variable for each request that determines which upstream group the [`proxy_pass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive sends the request to. In the sample configuration below, the value of the `$appversion` variable determines where the `proxy_pass` directive sends a request. The [`split_clients`](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html#split_clients) block uses a hash function to dynamically set the variable’s value to one of two upstream group names, either **version_1a** or **version_1b**.

```
http {
    # ...
    # application version 1a 
    upstream version_1a {
        server 10.0.0.100:3001;
        server 10.0.0.101:3001;
    }

    # application version 1b
    upstream version_1b {
        server 10.0.0.104:6002;
        server 10.0.0.105:6002;
    }

    split_clients "${arg_token}" $appversion {
        95%     version_1a;
        *       version_1b;
    }

    server {
        # ...
        listen 80;
        location / {
            proxy_set_header Host $host;
            proxy_pass http://$appversion;
        }
    }
}
```
