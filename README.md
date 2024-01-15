# Mutating Webhook example

## Remove the Workload identity label from cert-manager CSV
Edit the cert-manager csv in the operator namespace and remove the `azure.workload.identity/use: "true"` label from `/spec/template/metadata/labels`.

After this is removed scale the cert-manager deployment and verify that the label is no longer applied to the cert-manager pod.

## Setup the webhook

```
kubectl apply -f webhook.yaml
```

## Set up the CA Certificate
Once the webhook runs (give it a few seconds to initialize), the CA certificate can be downloaded by executing a curl command within the container. To retrieve the base64 encoded version of this ca.pem, use the following command:
```
kubectl exec -it -n kube-system $(kubectl get pods --selector=app=cert-manager-wi-webhook --output=jsonpath={.items..metadata.name} -n kube-system) -- wget -q -O- 127.0.0.1:8080/ca.pem?base64
```

The output of this command should replace the base64 string in caBundle in webhook.yaml:
```
    caBundle: "cGxhY2Vob2xkZXIK" # <= replace this string within quotes
```

Then reapply the webhook using:
```
kubectl apply -f webhook.yaml
```

Scale the cert-manager deployment and verify that the `azure.workload.identity/use: "true"` has been applied to the new cert-manager Pod.
