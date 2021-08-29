DevOps has seen explosive growth recently, as organizations look to deliver releases and features faster by automating operations with an Infrastructure as Code approach. This shift in the industry is making for some very interesting transformations, both in how organizations deploy applications and what is expected from IT operations.

DevOps plays a big role, not just in the delivery of infrastructure, but in the application deployment process itself. Many times, DevOps and development go hand in hand, with infrastructure deployed for the sole purpose of developing an application pipeline. The lifecycle of an application has become nimbler with the adoption of modern deployment methodologies, and NGINX can provide flexibility to enhance this process.

Hardware appliances for application delivery are traditionally fairly static and don’t lend themselves well to the agility that is required when utilizing a pipeline for application deployment. Being able to define the delivery needs of a specific application as part of the development and iteration process enhances the DevOps process.

## Blue-Green Deployments

One of the approaches to building an application environment that makes development more agile is blue‑green deployment. A blue‑green deployment essentially requires running two production environments at the same time. The goal is to keep the environments as close to identical as possible, but with only one of them live at any given time. The environment that isn’t live is used for staging and testing.

For the sake of this discussion, let’s call the live environment blue and the staging environment green. Once the testing of application updates in the green environment is deemed successful, green becomes the live environment and blue becomes the new staging environment ready for the next iteration of changes to the app. If something goes wrong soon after the green environment goes live, you can easily roll back to the blue environment because you know it was production‑ready before the switch.

The lightweight and agile nature of NGINX makes it a great tool for controlling application delivery in a blue‑green environment. Both the switch between environments and the required changes to the app‑delivery configuration can be rolled into the pipeline process itself. As detailed on the [NGINX blog](https://www.nginx.com/blog/introducing-ask-nginx/#blue-green), with NGINX Plus you can use the key‑value store to implement blue‑green deployment.

## Canary Releases

Canary release is another approach that NGINX is well suited for. Named after the [old mining trick](https://www.smithsonianmag.com/smart-news/story-real-canary-coal-mine-180961570/) for detecting the presence of dangerous gases in coal mines, a canary deployment exposes application updates to a small subset of users – the “canaries” who test whether the updates work correctly. There are many ways to choose your canaries – perhaps they are from a specific country, or hit the system during a specific time period in the middle of the night. Canary releases limit any possible repercussions to a smaller number of users while still providing feedback about when the update is ready to be released to the masses.

You can easily perform a canary release with NGINX and NGINX Plus using the [Split Clients](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html?_ga=2.59690347.774045537.1575698247-2108688350.1575698247) module. For details, see the [NGINX blog](https://www.nginx.com/blog/nginx-plus-backend-upgrades-application-version/#application-canary-release).

## Conclusion

Both of these use cases highlight the flexibility that is required for modern application deployment. Developers need tools that can keep up with the pipeline methodologies used in the current development landscape. Integrating NGINX with existing CI/CD tool chains can arm developers and operations teams with another way to accelerate agility.
