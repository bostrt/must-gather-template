# Must Gather Template Repo

This repository contains a starting point for creating your own basic [OpenShift 4 Must Gather image](https://docs.openshift.com/container-platform/latest/support/gathering-cluster-data.html). 


## Customize

1. Fork this repo.
1. Add your own commands into `scripts/gather`.
2. Make sure any command output you want to save is written into a file in the `${BASE_COLLECTION_PATH}` directory.
	- See [`scripts/gather`](./scripts/gather) for an example of saving `oc describe nodes` output.
3. Save your changes and proceed with Build instructions below.


## Build


### Community Origin Base Image (Default)

This template repostiroy is setup to use the community base image by default so the build command is simple:

```
$ podman build -t my-must-gather .
```

### Red Hat OpenShift Base Image

If you wish to use the image distributed and maintained by Red Hat, edit the `Dockerfile` and replace the `FROM` line with `FROM registry.redhat.io/openshift4/ose-cli` then proceed with building. 

You will need to use the authenticated Red Hat Container Registry. [See here](https://access.redhat.com/RegistryAuthentication) on how to get credentials if you don't have any yet: 

```
$ podman login registry.redhat.io
$ podman build -t my-must-gather .
```

## Distribute Image

Once you have built the image, you can tag and push it somewhere so others can access it. For example:

```
$ podman tag my-must-gather quay.io/bostrt/my-must-gather:latest

$ podman login quay.io
$ podman push quay.io/bostrt/my-must-gather:latest
```

*Reminder: Do you want your image public? Check registry repo settings on https://quay.io!*

## Use Your Image

At this point, you can use your new Must Gather image. 

```
$ oc adm must-gather --image=quay.io/bostrt/my-must-gather
```

### Image vs ImageStream

If you are doing rapid development and frequently pushing an updated images to your container registry repo, you may need to use an ImageStream like so:

```
$ oc import-image my-must-gather --from=quay.io/bostrt/my-must-gather:latest --confirm
$ oc adm must-gather --image-stream=default/my-must-gather
```

Each time you push a new updated image to your registry repo, you can then sync it in OpenShift by running the same `oc import-image` command above. 

*NOTE: This is necessary since the Must Gather Pod is created with an image pull policy of [`IfNotPresent`](https://github.com/openshift/oc/blob/master/pkg/cli/admin/mustgather/mustgather.go#L623) and not `Always`.*
