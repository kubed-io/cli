# Kube Tools  

A useful set of kustomize and kubectl tools for improving the kubectl experience. 

## Requirements  

The following CLI applications must be installed for everything to work. Most of these can be installed with your package manager of choice, ie `brew`, `choco`, etc. 

 - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
 - [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
 - [helm](https://helm.sh/docs/intro/install/)
 - [nova](https://nova.docs.fairwinds.com/installation/) - CLI to find outdated helm releases easily. 
 - [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
 - [yq](https://github.com/mikefarah/yq/#install)
 - [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
 - [lastpass-cli](https://github.com/lastpass/lastpass-cli) - Optional, used for kustomize lastpass secret generator. Doesn't work with sso unfortunately. 
 - [fzf](https://github.com/junegunn/fzf) - Optional, fancy fuzzy search in bash

## Configure AWS CLI  

It is bad practice to rely on AWS Access Keys, therefore use SSO to login to CLI for super secure and wory free access to AWS. 

**Initialize Profile:**

Each time you need access to another account, run this once to set up the profile. You will need the start URL from your admin for the first step in the process.   
```bash
aws configure sso
```

**Logging In**  

Once your profile is setup you will be logged at that moment. However the SSO will eventually time out and you will simply login again with:  
```bash  
aws sso login
```

## Configure kubectl

Now we want to set up our environment for kubectl, kustomize, and helm. These three are the main local cli tools for working with kubernetes. To use this project as the working directory simply by exporting `XDG_CONFIG_HOME` and adding the kubectl plugins to your `PATH`.  

`~/.bash_profile`  
```sh
export XDG_CONFIG_HOME="$HOME/git/kube-tools"
export PATH=$PATH:$XDG_CONFIG_HOME/kubectl/plugin
alias k="kubectl"
```  
Here is what's going on:  
 - `kustomize` is looking for `$XDG_CONFIG_HOME/kustomize/plugin`  
 - `kubectl` is looking for executables on the `PATH` which start with `kubectl-`, e.g. `kubectl-myplugin`. This is why we add the `/kubectl/plugin` dir to the path.  
 - `helm` is looking to create a working dir at `$XDG_CONFIG_HOME/helm`.  
 - The alias saves time as you only need to type `k` instead of `kubectl`  
 - `XDG_CONFIG_HOME` is the path to this directory  

## Install Python Package  

A few plugins are using python. The end result is a number of kubectl plugins created using the magik of python endpoints.  

From this directory simply run

```sh
pip3 install .
```

## Useful Kubectl Plugins with Krew    

Krew is the plugin manager for kubectl.  
It works just like any other package manager:  

```sh
k krew install <plugin-name>
```

These are recommended:  

```sh  
k krew install ctx, ns, neat
```

## Gain Access to EKS Cluster  

Assuming you have a valid aws-cli profile initialized, aws-cli will configure `kubectl` with credentials to EKS. Simply run the command below replacing or setting the variables denoted with `$`. This command will auto update or create the [`$KUBECONFIG`](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) automagically for you. 

```sh  
aws eks update-kubeconfig \ 
    --name $CLUSTER_NAME \ 
    --region $REGION \
    --role-arn $ROLE_ARN \
    --profile $PROFILE_NAME
```

## Viewing and Managing Resources  

When it comes to accessing resources, ie viewing and managing, in a Kubernetes cluster there are many options. No matter what tool, ie GUI, you use, they all use the same [`$KUBECONFIG`](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/). This means from here on you can freely install any Kubernetes tools you like and they all simply just work and have the same access to the same clusters. 

The following is a curated list of tools which have a proven track record and loved by many. 

### 1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and [kui](https://github.com/kubernetes-sigs/kui) for control  

Option 1 is simply using kubectl and all the plugins from this project. It's really all you need and it is the official CLI for kubernetes. If you really want to turbocharge `kubectl`, the official kubernetes team has created an innovative GUI/CLI hybrid named [kui](https://github.com/kubernetes-sigs/kui). It is a wrapper for kubectl in an electron window which beautifies the output with HTML/CSS/JS. 

### 2. [Lens](https://k8slens.dev/) for focus  

Option 2 is the highest recommended for ease of use and high performance. It is by far the simplest to navigate and sports a ton of awesome features to make working with kubernetes an absolute dream. [Get started here!](https://k8slens.dev/)  

### 3. [VSCode](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) for development  

Option 3 is simply to use everyones favorite "text editor". [The official VSCode Kubernetes plugin by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) integrates the most useful aspects of kubernetes for developers such as terminal access, logs, and a simple explorer to view the raw yaml of kubernetes resources. 

### 4. Etc... for curiousity  

Option 4 is to pick something else from the many options out there. Here is a quick curated list of some other notable GUI options.  

 - [Octant by VMWare](https://octant.dev/) - Browser Application, cluster or local
 - [k9s-cli](https://k9scli.io/) - Advanced Terminal GUI  
 - [Kubenav](https://kubenav.io/) - Standalone Application with mobile support  
 - [kubelive](https://github.com/ameerthehacker/kubelive) - Advanced Terminal GUI
 - [Kubevious](https://github.com/kubevious/kubevious) - Browser Application, cluster only