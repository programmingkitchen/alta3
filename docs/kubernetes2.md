# Openshift Cheat Sheet

## Three patterns

```bash
oc get <resource>
oc describe <resource> <name>
oc logs <pod>
```

## 0. First 15 OpenShift Examination Commands


| NAME | COMMAND |
| ----------- | ----------- |
| Client/server version | `oc version` |
| Cluster version | `oc get clusterversion` |
| Cluster Operator health | `oc get co` |
| Nodes | `oc get nodes -o wide` |
| Machine Config Pools | `oc get mcp` |
| Node utilization | `oc adm top nodes` |
| Projects | `oc get projects` |
| All pods | `oc get pods -A -o wide` |
| Pod utilization | `oc adm top pods -A` |
| Events | `oc get events -A --sort-by=.metadata.creationTimestamp` |
| Persistent volumes | `oc get pv` |
| Persistent volume claims | `oc get pvc -A` |
| Services | `oc get svc -A` |
| Routes | `oc get routes -A` |
| Installed OLM Operators | `oc get csv -A` |

## 0. Login 


## 1. Overall Cluster Health

| NAME | COMMAND |
| ----------- | ----------- |
| OpenShift version | `oc version`  |
| Cluster version and upgrade/status information | `oc get clusterversion` |
| | `oc get clusterversion -o wide` |
| Cluster Operators | `oc get co` |
| More detail about a particular operator  | `oc describe co machine-config` |
| Nodes | `oc get nodes` |
|  | `oc get nodes -o wide` |

## 2. Nodes 

| NAME | COMMAND |
| ----------- | ----------- |
| List nodes | `oc get nodes` |
| Include IP, OS, kernel, container runtime | `oc get nodes -o wide` |
| Detailed node information | `oc describe node <node>` |
| Node labels  | `oc get nodes --show-labels`  |
| Resource utilization | `oc adm top nodes` |
| Details about a node | `oc describe node <node>` |
|  |  |

### oc describe nodes 

`oc describe node <node>`

- Conditions
- CPU/memory capacity
- Allocated resources
- Taints
- Labels
- Pods running on the node
- Events

## 3. Machine Configuration / RHCOS

| NAME | COMMAND |
| ----------- | ----------- |
| Machine Config Pools | `oc get mcp` |
| Detailed MCP | `oc describe mcp worker` |
|  | `oc describe mcp master` |
| MachineConfigs | `oc get mc` |
| Examine a MachineConfig | `oc describe mc <machineconfig>` |
| Machine Config Operator | `oc get co machine-config` |
|  | `oc describe co machine-config` |

- The relationship

```bash
MachineConfig (MC)
       ↓
MachineConfigPool (MCP)
       ↓
Nodes / RHCOS
```


## 4. Projects / Namespaces

| NAME | COMMAND |
| ----------- | ----------- |
| Current project  | `oc project` |
| Projects | `oc get projects` |
| Kubernetes namespaces  | `oc get namespaces` |
| Everything commonly associated with current project | `oc get all` |
| Examine another namespace without changing your active project  | `oc get pods -n openshift-monitoring` |

## 5. Pods

| NAME | COMMAND |
| ----------- | ----------- |
| Pods in current namespace | `oc get pods` |
| More information | `oc get pods -o wide` |
| Pods in another namespace | `oc get pods -n <namespace>` |
| Pods across the entire cluster | `oc get pods -A` |
| Detailed pod information | `oc describe pod <pod> -n <namespace>` |
| See where pods are running | `oc get pods -A -o wide` |
| Find unhealthy pods | `oc get pods -A \| grep -v Running` |


## 6. Pod Logs

| NAME | COMMAND |
| ----------- | ----------- |
| Pod logs | `oc logs <pod>` |
| Specific namespace | `oc logs <pod> -n <namespace>` |
| Specific container  | `oc logs <pod> -c <container>`  |
| Previous container instance | `oc logs <pod> --previous` |
| Last 100 lines  | `oc logs <pod> --tail=100` |
| Logs since last hour | `oc logs <pod> --since=1h` |
| Include timestamps  | `oc logs <pod> --timestamps` |
| For a crash-looping container, this is particularly useful | `oc logs <pod> -n <namespace> --previous` |


## 7. Deployments and Workloads

| NAME | COMMAND |
| ----------- | ----------- |
| Get deployments  | `oc get deployments`  |
| Get all deployments across cluster  | `oc get deployments -A`  |
| Detailed info about a deployment | `oc describe deployment <deployment>` |
| Get replica sets  | `oc get replicasets` |
| Get daemon sets | `oc get daemonsets`  |
| Get stateful sets  | `oc get statefulsets` |
| Get jobs | `oc get jobs` |
| Get cron jobs | `oc get cronjobs` |
| A useful overview | `oc get deploy,ds,sts -A` |

## 8. Services, Routes and Networking

| NAME | COMMAND |
| ----------- | ----------- |
| Services | `oc get svc`  |
|  | `oc get svc -A` |
| Routes  | `oc get routes`  |
|  | `oc get routes -A` |
| Endpoints | `oc get endpoints` |
| EndpointSlices | `oc get endpointslices`  |
| Network policies | `oc get networkpolicy -A` |
| For examining an application path | `oc get route -n <namespace>`  |
|  | `oc get svc -n <namespace>` |
|  | `oc get endpoints -n <namespace>` |
|  | `oc get pods -n <namespace> -o wide`  |

- Architecture

```bash
Route
  ↓
Service
  ↓
Endpoint
  ↓
Pod
```

## 9. Storage

| NAME | COMMAND |
| ----------- | ----------- |
| Storage classes | `oc get storageclass` |
| Persistent volumes | `oc get pv |
| Persistent volume claims | `oc get pvc -A`  |
| Detailed PVC | `oc describe pvc <pvc> -n <namespace>` |
| Detailed PV | `oc describe pv <pv>` |

### Short names

| NAME | SHORT COMMAND |
| ----------- | ----------- |
| Storage classes  | `oc get sc`  |
| Persistent volumes | `oc get pv` |
| Persistent volume claims | `oc get pvc` |

### When storage isn't mounting 

| NAME | COMMAND |
| ----------- | ----------- |
|  | `oc get pvc -n <namespace>`  |
|  | `oc describe pvc <pvc> -n <namespace>`  |
|  | `oc describe pod <pod> -n <namespace>` |

## 10. Events

- Events are extremely valuable when troubleshooting

| NAME | COMMAND |
| ----------- | ----------- |
| Get the events | `oc get events`  |
| Across the cluster | `oc get events -A` |
| Sort chronologically | `oc get events -A --sort-by=.metadata.creationTimestamp` |
| For a specific namespace | `oc get events -n <namespace> --sort-by=.metadata.creationTimestamp`  |


## 11. CPU and Memory

| NAME | COMMAND |
| ----------- | ----------- |
| Node utilization  | `oc adm top nodes` |
| Pod utilization | `oc adm top pods -A`  |
| Specific namespace  | `oc adm top pods -n <namespace>` |
| A good combination is:  | `oc adm top nodes` |
|  | `oc adm top pods -A` |

## 12. Operators

| NAME | COMMAND |
| ----------- | ----------- |
| Cluster Operators | `oc get co` |
| ClusterServiceVersions | `oc get csv -A` |
| Subscriptions | `oc get subscriptions -A`  |
| InstallPlans | `oc get installplans -A` |
| OperatorGroups | `oc get operatorgroups -A`  |

### Architecture

```bash
oc get co
     │
     └── Core OpenShift Cluster Operators

oc get csv -A
     │
     └── OLM-installed Operators
```


## 13. OpenShift API Resources

- Very useful when you're learning the cluster. 

| NAME | COMMAND |
| ----------- | ----------- |
| Everything the API knows about | `oc api-resources` |
| API versions | `oc api-versions`  |
| Find a resource | `oc api-resources \| grep -i machine` |
| Learn about it | `oc explain machineconfigpool` |
| Go deeper | `oc explain machineconfigpool.spec` |
|  | `oc explain deployment.spec` |
|  | `oc explain pod.spec.containers` |

## 14. RBAC / Permissions

| NAME | COMMAND |
| ----------- | ----------- |
| Current user  | `oc whoami` |
| Current API server | `oc whoami --show-server` |
| Can I perform something? | `oc auth can-i get pods` |
|  | `oc auth can-i get node`s |
|  | `oc auth can-i get secrets -n <namespace>`  |

## 15. Secrets and ConfigMaps

| NAME | COMMAND |
| ----------- | ----------- |
|  | `oc get configmaps` |
|  | `oc get cm` |
|  | `oc describe cm <configmap>`  |
|  | `oc get secrets` |
|  | `oc describe secret <secret>` |


## 16. Certificates

- troubleshooting API or ingress certificate issues

| NAME | COMMAND |
| ----------- | ----------- |
|  | `oc get certificatesigningrequests` |
|  | `oc get csr` |
|  | `oc describe csr <csr>` |
|  | `oc get co authentication` |
|  | `oc get co ingress`  |
|  | `oc get co kube-apiserver` |

## 17. Ingress / DNS

- These are good places to look when applications work internally but aren't reachable through their routes.

| NAME | COMMAND |
| ----------- | ----------- |
| Ingress controller | `oc get ingresscontroller -n openshift-ingress-operator`  |
| DNS | `oc get dns.operator/default`  |
| Related operators | `oc get co ingress` |
|  | `oc get co dns`  |
| Router pods | `oc get pods -n openshift-ingress` |
| DNS pods  | `oc get pods -n openshift-dns` |


