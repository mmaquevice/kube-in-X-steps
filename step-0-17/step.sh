#!/usr/bin/env bash

######### Pods in a StatefulSet #########



# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl apply -f web.yaml

# => Pods created in order



#### Stable network identities ####

for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
# => names not dynamic

kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
# in container $> nslookup web-0.nginx
# in container $> nslookup web-1.nginx
# CNAME of the Headless Service
# in container $> nslookup nginx

# => The CNAME of the headless service points to SRV records (one for each Pod that is Running and Ready). The SRV records point to A record entries that contain the Pods’ IP addresses.

# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl delete pod -l app=nginx

# Once recreated
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
# => same as previously

kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
# in container $> nslookup web-0.nginx
# in container $> nslookup web-1.nginx
# in container $> nslookup nginx



#### Stable storage ####

kubectl get pvc -l app=nginx

# write index.html in each pod
for i in 0 1; do kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done
# verify each pod serve the hostnames
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done

# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl delete pod -l app=nginx

for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done

# => Even though web-0 and web-1 were rescheduled, they continue to serve their hostnames because the PersistentVolumes associated with their PersistentVolumeClaims are remounted to their volumeMounts.
# No matter what node web-0and web-1 are scheduled on, their PersistentVolumes will be mounted to the appropriate mount points.



######### Scaling a StatefulSet #########



# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl scale sts web --replicas=5 # Scale up
# => Creates each Pod sequentially with respect to its ordinal index, and it waited for each Pod’s predecessor to be Running and Ready before launching the subsequent Pod.

kubectl patch sts web -p '{"spec":{"replicas":3}}' # Scale down
# => The controller deleted one Pod at a time, in reverse order with respect to its ordinal index.

kubectl get pvc -l app=nginx
# => There are still five PersistentVolumeClaims and five PersistentVolumes.



######### Updating StatefulSets #########

# 2 spec.updateStrategy : RollingUpdate (default) and OnDelete

kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}' # not required as it is the default value

# open 2 terminals
# 1
kubectl rollout status sts/web
# 2
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'
# => The Pods in the StatefulSet are updated in reverse ordinal order.

# Get the image pods
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done



# Staging an Update

# A staged update will keep all of the Pods in the StatefulSet at the current version while allowing mutations to the StatefulSet’s .spec.template.

kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"k8s.gcr.io/nginx-slim:0.7"}]'
kubectl delete po web-2

kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
# => Notice that, even though the update strategy is RollingUpdate the StatefulSet controller restored the Pod with its original container.
# This is because the ordinal of the Pod is less than the partition specified by the updateStrategy.

# Rolling Out a Canary

kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'
kubectl get po -l app=nginx -w
kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'

# => When you changed the partition, the StatefulSet controller automatically updated the web-2 Pod because the Pod’s ordinal was greater than or equal to the partition.

kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}'
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done

# => all to new version



######### Deleting StatefulSets #########

# StatefulSet supports both Non-Cascading and Cascading deletion.
# In a Non-Cascading Delete, the StatefulSet’s Pods are not deleted when the StatefulSet is deleted.
# In a Cascading Delete, both the StatefulSet and its Pods are deleted.

### Non-Cascading Delete

# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl delete statefulset web --cascade=false

kubectl get pods -l app=nginx
# => pods still present

kubectl delete pod web-0
kubectl get pods -l app=nginx
# => As the web StatefulSet has been deleted, web-0 has not been relaunched.

kubectl apply -f web.yaml
# => When the web StatefulSet was recreated, it first relaunched web-0.
# Since web-1 was already Running and Ready, when web-0 transitioned to Running and Ready, it simply adopted this Pod.

for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
#  It still serves the hostname originally entered into its index.html file.

### Cascading Delete

# open 2 terminals
# 1
kubectl get pods -w -l app=nginx
# 2
kubectl delete statefulset web
kubectl delete service nginx

kubectl apply -f web.yaml
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
# => Pods still serve their hostnames

kubectl delete service nginx
kubectl delete statefulset web



######### Pod Management Policy #########

# For some distributed systems, the StatefulSet ordering guarantees are unnecessary and/or undesirable. These systems require only uniqueness and identity.

# 2 .spec.podManagementPolicy : OrderedReady (default) and Parallel

# open 2 terminals
# 1
kubectl get po -l app=nginx -w
# 2
kubectl apply -f web-parallel.yaml
# => The StatefulSet controller launched both web-0 and web-1 at the same time.

kubectl scale statefulset/web --replicas=4
# => It did not wait for the first to become Running and Ready prior to launching the second.

kubectl delete sts web
# => The StatefulSet controller deletes all Pods.

kubectl delete svc nginx

kubectl delete --all pvc



