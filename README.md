# aosp-build-docker-images

This image is based on https://github.com/alsutton/aosp-build-docker-images with the required changes to build on Apple's M1 hardware.

It also enables you to easily add your Github tokens. This allows you to access private sources you might need for building your version of AOSP.

## Config

(1) Add git config to file `gitconfig`. You can find an example in `gitconfig.example`.

(2) Add ssh token files to `ssh/`, named `github-docker` and `github-docker.pub`.
To create a new one, check out [Github's guide for that](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux).

## Building the image

You can build the docker images using the standard docker build command;

```shell
docker build -f ubuntu-20_04-aosp.dockerfile -t ubuntu-aosp .
```

## Running the image

Docker allows you to use volumes to separate data files from your main image. This
allows you to rebuild your docker image, or even change the entire distribution 
you're building in, without needing to download the AOSP source code again.

First you'll need to create a volume in which you'll store your data by running;

```shell
docker volume create aosp-build
```

then, when you run the image you create above, you'll need to tell docker to mount
the image in a known location. In this example I'll use `/aosp`;

```shell
docker run -i -t --mount source=aosp-build,target=/aosp ubuntu-aosp
```

Once the container is running you should do all your work (checkout, build, etc.) in
`/aosp`. If you do anything outside of `/aosp` you risk losing if your docker container
is destroyed, or the image is updated.

## Docker Desktop settings

Make sure to allocate enough resource for Docker. I chose to go with the following settings on 
an Apple M1 Max (allocated / max):
- CPU: 8 / 10
- Memory Limit: 40GB / 64GB
- Swap: 2GB / 4GB
- Virtual Disk Limit: 1TB / 4TB

## Checkout and Build

For instructions on how to check-out and build the AOSP please see the 
[download](https://source.android.com/setup/build/downloading) and
[build](https://source.android.com/setup/build/building) sections of
the AOSP documentation from Google.

**Important**: Due to an issue with Kernel 6.x (and Docker using your system's Kernel)
you can't use dex2oat. So in `build/core/board_config.mk` you'll have to set
`WITH_DEXPREOPT` to false before building.

## Extracting and running the emulator

Build a zip to download

```shell
m emu_img_zip
```

Get your container id

```shell
docker ps
```

Download the zip from docker

```shell
docker cp [container id]:/aosp/[path to the zip] [Local path]
```

Extract the emulator into `~/Library/Android/sdk/system-images/android-[some number]/[image name]/arm64-v8a`.
Then create a package.xml, e.g. by copying and modifying it from a similar image.

After that you should be able to see it when creating a new AVD in Android Studio

