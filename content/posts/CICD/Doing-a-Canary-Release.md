Sometimes it’s safest to test the new version of an application on a small set of users to see how it performs in production, then gradually ramp up the proportion of traffic to the new servers until eventually all traffic is going to them. 
<!--more-->
This method is commonly called a *canary release* or a *dark launch*. (“Canary release” refers to the [old mining practice](https://www.smithsonianmag.com/smart-news/story-real-canary-coal-mine-180961570/) of taking a canary down into a coal mine to detect the presence of dangerous gases before the miners were affected. In this context the users directed to the new servers are the canaries.).The split‑clients feature in NGINX Plus (and NGINX) is perfect for it.

The [`split_clients`](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html#split_clients) configuration block directs fixed percentages of traffic to different upstream groups. In this example we start by directing 5% of the incoming requests to the new upstream group. If all goes well we can increase to 10%, then to 20%, and so on. When we decide it’s safe to move completely to the new version, we simply remove the `split_clients` block and change the `proxy_pass` directive to point to the new upstream group.

Note that this method is not compatible with session persistence, which requires that NGINX Plus direct traffic from a particular client to the same server that processed the client’s first request. The `split_clients` directive sends a strict proportion of traffic to each upstream group without considering its source, so it might send a client request to an upstream group that doesn’t include the correct server.

1.  Create a new upstream group, demoapp-v2, for the new application version (as in the previous section).

    ```
    # In the HTTP context
    upstream demoapp {
        zone demoapp 64K;
        server 172.16.210.81:80 slow_start=30s;
        server 172.16.210.82:80 slow_start=30s;
    }

    upstream demoapp-v2 {
        zone demoapp-v2 64K;
        server 172.16.210.83:80 slow_start=30s;
        server 172.16.210.84:80 slow_start=30s;
    }
    ```

2.  In the first `server` block we created in [Base Configuration for the Upgrade Use Cases](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#base-configuration), change the `proxy_pass` block to use a variable to represent the upstream group name instead of a literal like **demoapp** (the variable gets set in the `split_clients` block, which we define in the next step).

    ```
    # In the first server block
    location / {
        proxy_pass http://$app_upstream;
    }
    ```

3.  Add a `split_clients` block in the `http` context. Here we tell NGINX Plus to set the variable `$app_upstream` to `demoapp-v2` for 5% of incoming requests and to `demoapp` for all remaining requests. The variable value is passed to the `proxy_pass` directive (defined in Step 2) to determine which upstream group the request goes to.

    The first parameter to `split_clients` defines the request characteristics that are hashed to determine how requests are distributed, here the client IP address ([`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr)) and port ([`$remote_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_port)).

    ```
    # In the HTTP context 
    split_clients $remote_addr$remote_port $app_upstream {
        5% demoapp-v2;
        *  demoapp;
    }
    ```

4.  Previously we mentioned that in some cases the health check must be defined in a `location` block separate from the one for regular traffic, and this is such a case. NGINX Plus sets up health checks as it initializes and must know at that point which upstream groups it will send health checks to. When the configuration uses a runtime variable to select the upstream group, as in this case, NGINX Plus can’t determine the upstream group names. To provide the needed information at initialization, we create a separate `location` block for each upstream group that explicitly names it. In the current case, we have two upstream groups, so for each we have a `location` block in the server block.

    ```
    # In the first server block
    location @healthcheck {
        internal;
        proxy_pass http://demoapp;
        health_check uri=/healthcheck.html match=matchstring-v1;
    }

    location @healthcheck-v2 {
        internal;
        proxy_pass http://demoapp-v2;
        health_check uri=/healthcheck.html match=matchstring-v2;
    }
    ```

5.  In the `http` context we add a `match` block to define the match conditions for each health check.

    ```
    # In the HTTP context
    match matchstring-v1 {
        status 200;
        body ~ "Version: 1.0 Status: OK";
    }

    match matchstring-v2 {
        status 200;
        body ~ "Version: 2.0 Status: OK";
    }
    ```

### Scheduling the Launch

With just a bit of Lua scripting we can schedule an upgrade for a specific time. Once we have set up the new upstream group, the script returns a different upstream name depending on the system time – the old upstream name prior to the cut-over time and the new upstream group afterward.

Using the same upstream groups as in [Doing a Canary Release](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#application-canary-release), we can add the following Lua script to the main `location` block ( **/** ) to make the cutover happen at 10:00 PM local time on June 21, 2016\. All requests received before that time are sent to the `demoapp` upstream group and all requests received at or after that time will be sent to the demoapp-v2 upstream group.

```
# In the first server block
location / {
    rewrite_by_lua '
        if ngx.localtime() >= "2016-06-21 22:00:00" then
            ngx.var.app_upstream = "demoapp-v2"
        else
            ngx.var.app_upstream = "demoapp"
        end
    ';

    proxy_pass http://$app_upstream;
}
```

### Controlling Access to the New Version Based on Client IP Address

In [Doing a Canary Release](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#application-canary-release), we covered one way to test a new application with a small number of users before opening it to everyone. Here we select a small number of users based on their IP address and allow only them access to the URI for the new application. Specifically, we set up a [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) block that sets the upstream group name based on the `$remote_addr` variable, which contains the client IP address. We can specify a specific client IP address or a range of IP addresses.

As an example, using the same upstream groups described in [Doing a Canary Release](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#application-canary-release), we create a regular expression to direct requests from internal IP addresses in the range between 172.16.210.1 and 172.16.210.19 to the demoapp-v2 upstream group (where the servers are running the new application version) while sending all other requests to the **demoapp** upstream group:

```
# In the HTTP context
map $remote_addr $app_upstream {
    ~^172.16.210.([1-9]|[1-9][0-9])$ demoapp-v2;
    default demoapp;
}
```

As before, the value of the `$app_upstream` variable is passed to the `proxy_pass` directive in the first `server` block, and so determines which upstream group receives the request.

```
# In the first server block
location / {
    proxy_pass http://$app_upstream;
}
```

## Conclusion[](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#Conclusion)

NGINX Plus provides operations and DevOps engineers with several options for managing software and hardware upgrades on individual servers while continuing to provide a good customer experience by avoiding downtime.

