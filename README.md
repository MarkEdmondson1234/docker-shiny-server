# docker-shiny-server
Shiny Server for my stuff.

## Base image

Based on https://hub.docker.com/r/rocker/shiny/

## Installs

Nano

* DT
* zoo
* devtools
* shinydashboard
* dplyr
* plotrix
* ggplot2
* lubridate
* stringr
* MarkEdmondson1234/googleAuthR
* MarkEdmondson1234/googleAnalyticsR_public
* rstudio/shinyapps

## Use on Google Compute Engine

* https://docs.docker.com/engine/installation/google/
* https://hub.docker.com/r/rocker/shiny/
* https://cloud.google.com/compute/docs/containers/container_vms

```
gcloud --project iih-tools-analytics \
  compute instances create r-shiny-server \
  --image container-vm \
  --zone europe-west1-b

gcloud --project iih-tools-analytics \
  compute ssh --zone europe-west1-b r-shiny-server

gcloud --project iih-tools-analytics \
  compute firewall-rules create shiny-server --allow tcp:3838
```

Now should be logged in to GCE

```
## docker working?
sudo docker run hello-world

sudo apt-get update

## why does this not work on port 80?
sudo docker run -d -p 3838:3838 \
        -v /srv/shinyapps/:/srv/shiny-server/ \
        -v /srv/shinylog/:/var/log/ \
        markedmondson1234/shiny-server
        
## CTRL-D to get back to local
```

## Log in to docker container and setup if needed
```
## get name of docker container
docker ps

## example logging in for container called 'focused_hawking'
sudo docker exec -it focused_hawking bash

### Now in docker container, do stuff:

## install stuff under sudo to make sure all users can use it
sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('MarkEdmondson1234/googleAuthR')\""
```

## Running Shinyapps / RMarkdown

Put shiny apps in `/srv/shinyapps/appdir` where `/appdir/` will appear at `http://localhost:3838/appdir/`

```
## copy app files up from your local to GCE
sudo gcloud --project iih-tools-analytics \
      compute copy-files ~/dev/RMarkdownTraining \
      r-shiny-server:/srv/shinyapps/r-markdown-training \
      --zone europe-west1-b
```

* If multiple .Rmd files, rename one of the .Rmd files to index.Rmd to make it work...
* RMarkdown apps then available at `http://instance-ip:3838/folder-name/app-name`


## Launching new GCE instances

Launch with docker image predone via configuration.yaml
* https://cloud.google.com/compute/docs/containers/container_vms

```
gcloud compute instances create containervm-test-1 \
    --image container-vm \
    --metadata-from-file google-container-manifest=containers.yaml \
    --zone us-central1-a \
    --machine-type f1-micro
```

containers.yaml

* guide: http://kubernetes.io/v1.1/docs/user-guide/simple-yaml.html
* http://kubernetes.io/v1.1/docs/user-guide/configuring-containers.html

```
apiVersion: v1
kind: Pod
metadata:
  name: simple-echo
spec:
  containers:
    - name: simple-echo
      image: gcr.io/google-containers/busybox
      command: ['nc', '-p', '8080', '-l', '-l', '-e', 'echo', 'hello world!']
      imagePullPolicy: Always
      ports:
        - containerPort: 8080
          hostPort: 8080
```





