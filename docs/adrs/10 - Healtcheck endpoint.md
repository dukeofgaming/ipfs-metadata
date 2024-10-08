## Status
Accepted

## Context
When hooking up the service to a load balancer, a challenge was encountered. The balancer was configured to expect a "200" status from the root ("/") endpoint for health checks, but the application, by default, returned a "404". 

Altering the root endpoint was considered, but the principle of [Chesterton's Fence](https://www.youtube.com/watch?v=qPGbl2gxGqI) suggested caution: it's unwise to change something without understanding why it exists in the first place.

## Decision
Rather than altering the existing root endpoint, a new `/healthcheck` endpoint was introduced. 

This endpoint performs a **database connectivity check** and returns the application's version. 

This approach satisfies the load balancer's requirements without modifying the root endpoint's behavior.

## Consequences
1. Elimination of unnecessary ECS restarts if there is oversight in configuring the load balancer at any point, as the load balancer now receives the "200" status it requires.

2. Preservation of the root endpoint's original design, respecting its intended purpose if any.

3. Enhancement of debugging capabilities through the inclusion of the application's version in the health check response.

4. Establishment of a precedent for *future health check adjustments* without disrupting other application parts.

5. **Reduced attack surface** by limiting the matcher to a well-known HTTP status code, that can be used to test the infrastructure with other images.